---
name: create-pr
description: Issueに紐付くプルリクエストを作成する手順。Issue・baseの確認→秘密情報の混入チェック→差分の自己精査→検証→コミットとpush→PR作成→Issueへの追跡記録までを行う。「Issueの実装をPRにして」「プルリク出して」「レビュー出したい」「変更をまとめて」などで使う。マージは絶対に行わない（人間がレビューする）。
---

# プルリクエスト作成ランブック

作業した変更をレビューに出せる状態にまとめ、PR を作成するまでの手順。

> **このスキルはマージを含まない。** PR 作成で完了とし、マージは人間が行う。
> リポジトリ固有のルール（コミット規約・検証手順・秘密情報の扱いなど）は、**リポジトリ直下の `AGENTS.md` または `CLAUDE.md`** を優先する。本スキルはその上に立つ汎用フローを定義する。

---

## 0. Issue・base・ブランチの確認

```bash
git branch --show-current    # main にいないこと
git status --short           # 未コミットの変更を把握
git log --oneline <base>..HEAD # このブランチのコミット
gh issue view <issue番号>     # 対象がIssueであることを確認
gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name'
```

- **実装対象のIssue番号を、作業開始時に確定する。** ユーザから指定されていなければ、PRを作る前に確認する。Issueなしで進めるのは、ユーザが明示した場合だけとする。
- **base branchを確定する。** 親の作業ブランチへ積むPRではその親、通常PRでは既定ブランチをbaseにする。既定ブランチ名を`main`と決め打ちしない。
- **既定ブランチにいたらブランチを切る**。リポジトリの `AGENTS.md` / `CLAUDE.md` に命名規約があればそれに従う。無ければ `<type>/<issue番号>-<slug>`（例: `fix/77-collector-profile-preflight`）を推奨。`type`は `feat` / `fix` / `refactor` / `docs` / `chore` の5つに揃えると読みやすい。
- ブランチ名には英小文字・数字・ハイフンだけを使う。`[]`、`()`、`{}`、空白、`_`、大文字、`issue-`接頭辞を混ぜない。
- 未コミットの変更があれば、この後のステップで内容を確認してからコミットする。
- PR番号とIssue番号を混同しない。`gh issue view`で確認できない番号を、IssueとしてPR本文へ書かない。

### ブランチを作る前のbase確認

新規ブランチは現在のHEADから切らず、意図したbaseの最新headから切る。通常は既定branch、継続中の一連の変更では指定された統合branch、親PRへ積む場合は親branchをbaseにする。

```bash
BASE=<意図したbase branch>
git status --short
git fetch origin "$BASE"
git log -1 --oneline "$BASE"
git log -1 --oneline "origin/$BASE"
test "$(git rev-parse "$BASE")" = "$(git rev-parse "origin/$BASE")"
git switch "$BASE"
git pull --ff-only origin "$BASE"
git switch -c <type>/<issue番号>-<slug> "origin/$BASE"
```

- localとremoteのSHAが一致しなければ、最新remote headへfast-forwardしてから切る。分岐している・fast-forwardできない場合は、どちらをbaseにするかユーザへ確認する。
- `git status --short`に出力がある場合は、未コミット変更を抱えたままswitchしない。先にユーザの変更を保全する。
- localだけのbaseは、コミットSHAと理由を示してユーザが承認した場合だけ使う。
- `git switch -c <new>`のように起点を省略しない。確認済みの`origin/<base>`または承認済みSHAを明示する。

### Issueのリンクと自動クローズ

GitHubのclosing keyword（`Closes #123`など）は、**既定ブランチをbaseにしたPRでだけ**解釈される。非既定ブランチへのPRでは、keywordを書いてもIssueへのリンクも自動クローズも作られない。

| PRのbase | PR本文 | マージ後の扱い |
|---|---|---|
| 既定ブランチ | `Closes #<issue番号>` | GitHubがIssueを自動クローズする。作成後にリンクを確認する。 |
| 非既定ブランチ | `Related: #<issue番号>` | PR作成直後にIssueへPR URL・base・作業ブランチをコメントし、追跡可能にする。マージ後もIssueは自動では閉じない。 |

非既定ブランチのIssueを閉じるのは、PRのマージ確認後にユーザが明示してから行う。マージ前に閉じたり、`Closes`だけを書いて閉じる前提にしたりしない。

---

## 1. 秘密情報の混入チェック（最優先）

**push してしまった秘密情報は、後始末のコストが跳ね上がる。** 必ず **push 前に**確認する。リポジトリに秘密ファイルを常在させている（VPN 設定、認証情報、`.env` など）場合は特に注意。

```bash
# ステージ済み・コミット済みの差分に秘密情報が混ざっていないか
git diff <base>...HEAD --stat
git diff <base>...HEAD | grep -inE "PrivateKey|BEGIN .*PRIVATE KEY|api[_-]?key|secret|password|token|Authorization" | head -20

# 追跡対象に入ってしまった秘密ファイルがないか
git ls-files | grep -iE '\.env$|credentials/|\.pem$|\.key$|id_rsa|id_ed25519|wg\.conf' || echo "なし ✅"
```

リポジトリ固有の秘密パターンがあれば `AGENTS.md` / `CLAUDE.md` に列挙されている想定で、そちらも突き合わせる。

見つかった場合の対処:

- **まだ push していない**（`git ls-remote --heads origin <branch>` が空）なら履歴から消せる:
  ```bash
  echo "/path/to/secret_dir/" >> .gitignore
  git rm --cached path/to/secret_file
  git add -A && git commit --amend --no-edit
  # 到達可能なオブジェクトから消えたことを確認
  git rev-list --objects --all | grep -i "secret_file" || echo "なし ✅"
  ```
- **push 済み**なら履歴の書き換えかキーのローテーションが必要。**独断で force-push せず、ユーザに報告して判断を仰ぐ。**

秘密情報を含むディレクトリを新規追加した場合は、**同じコミットで `.gitignore` にも追加する**。

---

## 2. レビュー

### 2-1. エージェント自身による差分の精査

```bash
git diff <base>...HEAD
```

差分を頭から読み、最低限これを確認する:

- **意図しない変更が混ざっていないか**（デバッグ用の出力、コメントアウトした試行錯誤、無関係なファイル）
- **エラーを握り潰していないか**（`2>/dev/null`、握るだけの `except`、終了コードを見ない呼び出し）
- **失敗時にどうなるか。** 特に「失敗しても処理が続く」経路は、続いた結果が安全かを確認する
- 変更した関数・スクリプトの**呼び出し元をすべて確認したか**（`grep` で洗う）

### 2-2. `/code-review` はユーザに促す

`/code-review` は**ユーザが起動するコマンド**で、エージェントからは実行できない（`/code-review ultra` は課金対象の多エージェントレビュー）。**Bash 等で起動しようとしない。**

深いレビューを入れたい変更のときは、PR 作成前に**ユーザへ `/code-review` の実行を提案する**。指摘が出たら潰してから PR を出す。潰さないものは、なぜ対応しないかを PR 本文に書く。

整理・簡潔化のみが目的なら `/simplify`、ユーザが明示的に依頼した場合は `/security-review` を案内する。

---

## 3. 検証

**「動くはず」で PR を出さない。** 変更の種類に応じて、リポジトリ固有の検証手順（`AGENTS.md` / `CLAUDE.md` の「検証」セクション、または `Makefile` / `package.json` / `pyproject.toml` のスクリプト定義）に従って実施する。

指針:

| 変更対象 | 実施すること |
|---|---|
| アプリケーションコード | プロジェクトのテストランナーを実行（`make test` / `pytest` / `flutter test` / `npm test` 等） |
| ビルド構成 (Dockerfile, compose, ビルドスクリプト) | ビルドを実際に流し、成功を確認 |
| リポジトリ固有のスモーク／統合スキル | リポジトリで定義された該当スキルを実行 |
| シェルスクリプト | `bash -n` に加えて**実際に動かす**。可能なら異常系も |
| ドキュメントのみ | 不要（その旨を PR に書く） |

注意点:

- **結果は数字で記録する。** 「動いた」ではなく「テスト142件全部成功」「収集19件 / 8ストア status=1」のように書く。PR 本文にそのまま使える形にする。
- 実施しなかった検証は、**やっていないと明記する**。検証したことにしない。
- リポジトリのスモークテスト等が run ごとのアーティファクトを持つ場合、どこに出力されるかは `AGENTS.md` / `CLAUDE.md` に従う。

---

## 4. 別件の報告

作業中に見つけた**この PR のスコープ外の問題**は、この PR に混ぜず切り離す。

**起票する前に内容を報告し、指示を受けてから作成する**。エージェントの判断で勝手に起票しない。

```bash
gh issue create --title "<事象を端的に>" --body "..."
```

- 症状・切り分け結果・影響・再現手順を書く。ログを引用する場合は**秘密情報をマスクする**。
- 既存イシューに該当するものは、新規起票せず**そのイシューにコメントで追記**する（状況が変わった場合も同じ）。
- 起票した場合、その番号は PR 本文の「関連 Issue」に含める。

---

## 5. コミットと push

```bash
git add -A && git status --short   # 何がステージされたか必ず目視
git commit -m "$(cat <<'EOF'
<type>(<scope>): <日本語の要約>

<なぜこの変更が必要かと、何をしたか>
<設計上の判断があれば、選ばなかった選択肢とその理由も>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
git push -u origin $(git branch --show-current)
```

- **「なぜ」を本文に書く。** 差分から読み取れない情報だけがコミットメッセージの価値。
- 複数の関心事が混ざるならコミットを分ける。
- コミット規約（Conventional Commits の型、scope の命名など）は `AGENTS.md` / `CLAUDE.md` を優先。

---

## 6. PR 作成

`.github/pull_request_template.md` の構成に沿って本文を書く（無ければ user/org レベルの `.github` リポのテンプレートに従う）。対象Issueとbaseの組み合わせに応じて、次のどちらかを必ず書く。

- 既定ブランチ向け: `- Closes #<issue番号>`
- 非既定ブランチ向け: `- Related: #<issue番号>`

Issueなしをユーザが明示した場合は、`- Issueなし（理由: ...）`と理由を残す。空欄のままPRを作らない。

```bash
gh pr create --base "<base branch>" --head "$(git branch --show-current)" --title "<type>(<scope>): <要約>" --body "$(cat <<'EOF'
## 概要

<何を直したか / 追加したか。なぜ必要だったか>

## 変更内容

<実装の要点。設計上の判断とトレードオフがあれば、選ばなかった選択肢とその理由も>

## テスト

- 実行したコマンドと**結果の数字**
- 手動確認した内容
- **未実施の確認があれば、その理由**

## 関連 Issue

- <baseに応じて `Closes #<issue番号>` または `Related: #<issue番号>`>

## レビューポイント

<特に見てほしい観点。判断に迷った箇所、レビュアーの意見が欲しい設計判断>
EOF
)"
```

本文を書くときの指針:

- **レビュアーが差分を読む前に判断できる情報を書く。** 特に「なぜこの実装にしたか」「何を検証済みで、何が未検証か」。
- 途中で方針を変えた場合は、**採用しなかった案とその理由も書く**。同じ議論の再発を防げる。
- 既知の制約・積み残しは隠さず書く。

### 6-1. 作成直後のIssue追跡確認

PR URLと番号を取得したら、Issueの扱いを必ず確認する。

```bash
gh pr view <pr番号> --json number,url,baseRefName,closingIssuesReferences
```

- **既定ブランチ向け**: `closingIssuesReferences`に対象Issueがあることを確認する。無ければ、PR本文を直してからレビューに出す。
- **非既定ブランチ向け**: Issueへ次のコメントを残す。GitHubのDevelopment欄への自動リンクは非既定baseでは作れないため、IssueからPRをたどれる正の記録にする。

  ```bash
  gh issue comment <issue番号> --body \
    "実装PR: #<pr番号> <pr URL>\nbase: <base branch>\nbranch: <head branch>\n非既定branch向けPRのため、マージ後もIssueは自動では閉じません。"
  ```

  GitHub UIを操作できる場合は、Issueの **Development** からこのPRを手動リンクする。CLI/APIで同じ操作ができない環境では、上のIssueコメントを必ず残し、完了報告でDevelopment欄が未リンクであることを明記する。

PRを作っただけでIssueをクローズしない。レビューコメントへ対応したら、対応内容とコミットをPRスレッドへ返信する。

---

## 7. 完了報告

**ここで止める。マージしない。**

ユーザには以下を伝える:

- PR の URL
- **マージしていないこと**、レビュー待ちであること
- 検証で分かったこと（特に**未検証の範囲**、既知の制約）
- 報告した別件（起票済みならイシュー番号）
- レビュー前に判断が必要な事項があればそれ
- 対象Issueとその状態。非既定branch向けなら「マージ後に明示的なクローズが必要」と書く。

```bash
gh pr view <番号> --json state,mergeable,mergeStateStatus
```

---

## やってはいけないこと

- **`gh pr merge` の実行。** 会話の中で「マージして閉じたい」と言われていても、それはレビュー後の意図であって、レビューを飛ばす許可ではない。**その場で個別に指示された場合のみ**実行する。
- マージに付随する作業（イシューのクローズ、ブランチ削除）を先回りして行うこと。
- 既定ブランチへの直接コミット、既定ブランチへの force-push。
- 検証していないことを検証したと書くこと。
- 秘密情報を PR 本文・コメント・イシューに貼ること。
