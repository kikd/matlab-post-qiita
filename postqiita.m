function result = postqiita(filename, options)
arguments
    filename (1,1) string {mustBeFile}
    options.tags (1,:) string {mustBeText} = "matlab"
    options.private (1,1) {mustBeA(options.private, 'logical')} = true
    options.tweet (1,1) {mustBeA(options.tweet,'logical')} = false
end

%% アクセストークンの取得
token = getenv('QIITA_TOKEN');
if (isempty(token))
    error("トークンが環境変数に設定されていません。");
else
    % リクエスト時のAuthorizationヘッダにフォーマット
    auth_header = strjoin({'Bearer' token}, ' ');
end

%% APIの指定とヘッダの設定
uri = 'https://qiita.com/api/v2/items';
webopt = weboptions(...
    'ContentType', 'json',...
    'HeaderFields', {
        'Origin' 'https://qiita.com'
        'Authorization' auth_header
    }...
);

%% tagの生成
tags = options.tags;
tag_count = length(tags);
if(tag_count > 5)
    error("タグの指定が多すぎます");
end
article_tag = {tag_count};
for i = 1:tag_count
    article_tag{i} = struct('name', tags{i});
end

%% markdownファイルからタイトルと本文を抽出
% タイトルと見出し1が同じキャプションになっているため、
% 1行目の見出しをタイトル、2行目以降を本文とする。
% (Live Scriptのタイトルがつけていることを前提としています)
mdtext=fileread(filename);
splited_text = split(mdtext, regexpPattern("\n+"));
title = erase(splited_text{1}, regexpPattern("^# ")); % 行頭の# だけ消したい
text = strjoin(splited_text(2:end),newline);

% article_tagはタグが1つだけでもjsonの配列オブジェクトにしたいので、cell配列にしています。
article_body = struct("title",title, "body",text, "private",options.private, ...
    "tags", {article_tag},"tweet", options.tweet);

try
  response = webwrite(uri, article_body, webopt);
  result = response.url;
catch ME
  result = ME.identifier;
end

end
