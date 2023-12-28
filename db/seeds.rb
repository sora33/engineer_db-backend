# frozen_string_literal: true

# ユーザーを3人作成
3.times do |i|
  user = User.create!(
    id: SecureRandom.uuid,
    provider: 'github',
    provider_id: SecureRandom.uuid,
    name: "User #{i + 1}",
    last_sign_in_at: Time.zone.now,
    created_at: Time.zone.now,
    updated_at: Time.zone.now
  )

  # 各ユーザーが投稿を作成
  5.times do |j|
    Post.create!(
      user:,
      content: "Content #{j + 1} by User #{i + 1} ContentContentContentContent",
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    )
  end
end
