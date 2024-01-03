# frozen_string_literal: true

# rubocop:disable all

my_user = User.find('a009c281-499a-4038-a4ed-f6847b5db934')
# 各カテゴリのスキルリストを定義
project_skills = %w[project_management product_management project_management_office project_leader
                    chief_technology_officer tech_lead]
software_skills = %w[requirements_definition basic_design detailed_design frontend_development
                     backend_development infrastructure mobile_development game_development business_system_development embedded_development ecommerce_site database_design_construction big_data vr test_design quality_assurance tester]
programming_skills = %w[html_css php ruby python perl javascript typescript dart swift
                        objective_c java kotlin scala c_sharp asp_net c_language go rust zig c_plus_plus carbon webassembly erlang elixir r clojure haskell vba vbscript cobol sql pl_sql]
framework_skills = %w[laravel cakephp fuelphp symfony ruby_on_rails django flask angular
                      react_js next_js vue_js nuxt_js express_js nestjs node_js deno electron flutter react_native xamarin cordova spring spring_boot struts seasar2 unity hadoop apache_spark]
database_skills = %w[oracle mysql postgresql sql_server access mongodb redis cassandra sqlite
                     elasticsearch]
tool_skills = %w[aws azure gcp wordpress ansible chef terraform jenkins docker kubernetes
                 tensorflow firebase tableau scikit_learn pytorch salesforce sap active_directory uipath]

# 全てのスキルを一つの配列にまとめる
all_skills = project_skills + software_skills + programming_skills + framework_skills + database_skills + tool_skills

# 各ユーザーの投稿内容を定義
posts = [
  'AWSマネージドコンソールで、RailsアプリをECSにデプロイする方法について詳しくまとめました。ECSの設定から、Dockerfileの作成、デプロイまでの一連の流れを解説しています。これからAWSを使ってRailsアプリをデプロイする方の参考になれば幸いです。',
  '今日のコードレビューで、リファクタリングのアイデアをいくつか得ました。特に、メソッドの分割や変数名の改善について有益なフィードバックをもらいました。これらのアイデアを元に、明日から実装に取り組む予定です。',
  'ニトリのITパスポート取得要求について考えてみました。私もITパスポートはよい資格だと思います。ただ、従業員が資格取得に費やした時間・お金に対して、給与と同等の対価を貰えるのかが気になります。企業が全額負担するなら社会的だと思いますが、従業員が自己負担するならブラックな社風を感じます。',
  '新しいプロジェクトでReactを使うことになりました。公式ドキュメントを読み込んで学習中です。Reactのコンポーネント思考やstate、propsの概念について理解を深めています。また、HooksやContext APIについても学んでいます。',
  '今日はバグの原因を追いかけて一日が終わりました。複雑な条件分岐の中に潜んでいたバグで、再現条件を特定するのに苦労しました。明日こそは解決したいと思います。',
  '最近、Dockerの理解が深まってきました。特に、コンテナ化のメリットを実感しています。開発環境の統一や、本番環境との差異を最小限に抑えられる点が非常に有益だと感じています。これからもDockerを活用していきたいと思います。',
  'Pythonでのデータ分析について学んでいます。PandasやNumPy、Matplotlibなどのライブラリを使ってデータの前処理や可視化を行っています。データ分析のスキルは、今後のエンジニアリングにおいてますます重要になってくると思うので、しっかりと学んでいきたいと思います。',
  'Vue.jsでのフロントエンド開発について学んでいます。Vue.jsのコンポーネント思考や、Vuexを使った状態管理の方法について理解を深めています。また、Nuxt.jsを使ったSSRについても学んでいます。',
  '最近、GraphQLについて学んでいます。REST APIと比較して、必要なデータだけを効率的に取得できる点が魅力的だと感じています。これからもGraphQLを活用していきたいと思います。'
]

# メッセージの内容を定義
messages = [
  'こんにちは、初めまして。',
  'プロジェクトについて話しましょう。',
  '最近どんな技術を学んでいますか？',
  '次回のミーティングはいつがいいですか？'
]

# ユーザーを3人作成
users = [
  {
    name: 'やまだ',
    purpose: 'work',
    comment: '一緒に学びましょう！',
    work: 'fullTime',
    occupation: 'engineer',
    gender: 'male',
    experience: 1,
    introduction: "新しい技術を学ぶのが好きです。\n特に、最近はフロントエンドの技術に興味があり、ReactやVue.jsを使った開発を学んでいます。\nまた、バックエンドではRuby on RailsやNode.jsを使った開発も行っています。新しい技術の学習は、常に新しい発見があるため、非常に楽しいです。",
    hobby: "私の趣味は読書と旅行です。\n読書は、新しい知識を得るだけでなく、異なる視点や考え方を理解するのに役立ちます。特に、歴史や科学の本を読むのが好きです。\n旅行は、新しい場所を探索し、異なる文化を体験するのが好きです。特に、自然が豊かな場所に行くのが好きで、山登りやキャンプを楽しんでいます。\n一緒に読書や旅行を楽しみませんか？",
    birthday: Date.parse('2010-01-01'),
    location: '東京都',
    website: 'https://taro.example.com',
    last_sign_in_at: 3.days.ago,
    skills: %w[html_css javascript ruby_on_rails]
  },
  {
    name: 'かず子',
    birthday: Date.parse('2000-05-05'),
    last_sign_in_at: 2.days.ago,
    skills: %w[project_management java spring oracle aws]
  },
  {
    name: 'たなか',
    purpose: 'hobby',
    comment: '美しいウェブを作りたい！',
    work: 'businessOwner',
    occupation: 'consultant',
    gender: 'other',
    experience: 20,
    introduction: 'ユーザー体験を重視しています。',
    hobby: "映画鑑賞\n一緒にしませんか。",
    birthday: Date.parse('1990-08-20'),
    location: '福岡県',
    website: 'https://ichiro.example.com',
    last_sign_in_at: 1.day.ago,
    skills: %w[project_management product_management c_language c_plus_plus sql aws azure]
  }
]

users.each_with_index do |user, user_index|
  created_user = User.create!(
    provider: 'github',
    provider_id: SecureRandom.uuid,
    name: user[:name],
    purpose: user[:purpose],
    comment: user[:comment],
    work: user[:work],
    occupation: user[:occupation],
    gender: user[:gender],
    experience: user[:experience],
    introduction: user[:introduction],
    hobby: user[:hobby],
    birthday: user[:birthday],
    location: user[:location],
    website: user[:website],
    last_sign_in_at: user[:last_sign_in_at]
  )
  user[:skills].each do |skill|
    Skill.create!(
      user_id: created_user.id,
      name: skill,
      level: rand(0..7)
    )
  end
  3.times do |i|
    Post.create!(
      user_id: created_user.id,
      content: posts[(user_index * 2) + i]
    )
  end

  # my_userと各ユーザー間のグループを作成
  group = Group.create!

  # グループにユーザーを追加
  GroupUser.create!(
    group_id: group.id,
    user_id: my_user.id
  )
  GroupUser.create!(
    group_id: group.id,
    user_id: created_user.id
  )

  # my_userから各ユーザーへのメッセージ
  2.times do |i|
    Message.create!(
      group_id: group.id,
      user_id: my_user.id,
      content: messages[i],
      is_read: false
    )
  end

  # 各ユーザーからmy_userへのメッセージ
  2.times do |i|
    Message.create!(
      group_id: group.id,
      user_id: created_user.id,
      content: messages[i + 2],
      is_read: false,
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    )
  end
end
