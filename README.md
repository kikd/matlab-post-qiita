# matlab-post-qiita
Qiitaに記事を投稿するMATLABスクリプトです。  
画像のアップロードができないため、デフォルトの公開範囲は限定共有記事にしています。  
スクリプトの実行にあたり、環境変数**QIITA_TOKEN**にQiitaのアクセストークンを設定する必要があります。  
スクリプトを実行する前にsetenv関数を使用するなどしてください。  
アクセストークンは[ユーザの管理画面](https://qiita.com/settings/applications)で発行できます。

## 構文 
res = postqiita(filename)  
res = postqiita(filename, Name, Value)  

## 説明
res = postqiita(filename) は filenameの内容をQiitaに投稿します。  
res = postqiita(filename, Name, Value) は 1つ以上の名前と値のペアの引数を使用して、filenameの内容をQiitaに投稿します。

記事の投稿に成功した場合、resには記事のURLが渡されます。
投稿に失敗した場合、resにはエラーの内容が渡されます。

## 使用例
* 限定共有記事として投稿する  
  postqiita('hoge.md')  
  
* 公開記事として投稿する  
  postqiita('hoge.md', 'private', false)

* 記事の投稿をツイートする  
  postqiita('hoge.md', 'tweet', true)
