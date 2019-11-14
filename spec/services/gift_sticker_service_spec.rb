# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GiftStickersService do
  describe '.call' do

    context 'Users in the incompleted state' do
      let(:user_with_early_receipt_2prs) do
        FactoryBot.create(:user, :incompleted)
      end
      let(:user_with_early_receipt_3prs) do
        FactoryBot.create(:user, :incompleted)
      end
      let(:user_with_late_receipt_2prs) do
        FactoryBot.create(:user, :incompleted)
      end
      let(:user_with_late_receipt_3prs) do
        FactoryBot.create(:user, :incompleted)
      end

      before do
        user_with_early_receipt_2prs.update(receipt: UserReceiptHelper.receipt[:early_receipt_2_prs])
        user_with_early_receipt_3prs.update(receipt: UserReceiptHelper.receipt[:early_receipt_3_prs])
        user_with_late_receipt_2prs.update(receipt: UserReceiptHelper.receipt[:late_receipt_2_prs])
        user_with_late_receipt_3prs.update(receipt: UserReceiptHelper.receipt[:late_receipt_3_prs])
      end

      context 'there is 1 sticker coupon' do
        before do
          FactoryBot.create(:sticker_coupon)
          GiftStickersService.call
        end

        it 'assigns the coupon to earliest user with most PRS' do
          binding.pry
          expect(user_with_early_receipt_3prs.sticker_coupon).to_not eq(nil)
        end
      end

      context 'there are 2 sticker coupons' do
        before do
          FactoryBot.create(:sticker_coupon)
          FactoryBot.create(:sticker_coupon)
          GiftStickersService.call
        end

        it 'assigns a coupon to early user with 3 PRS' do
          expect(user_with_early_receipt_3prs.sticker_coupon).to_not eq(nil)
        end

        it 'assigns a coupon to late user with 3 PRS' do
          expect(user_with_late_receipt_3prs.sticker_coupon).to_not eq(nil)
        end
      end

      context 'there are 3 sticker coupons' do
        before do
          FactoryBot.create(:sticker_coupon)
          FactoryBot.create(:sticker_coupon)
          FactoryBot.create(:sticker_coupon)
          GiftStickersService.call
        end

        it 'assigns a coupon to early user with 3 PRS' do
          expect(user_with_early_receipt_3prs.sticker_coupon).to_not eq(nil)
        end

        it 'assigns a coupon to late user with 3 PRS' do
          expect(user_with_late_receipt_3prs.sticker_coupon).to_not eq(nil)
        end

        it 'assigns a coupon to early user with 2 PRs' do
          expect(user_with_early_receipt_2prs.sticker_coupon).to_not eq(nil)
        end
      end
    end
  end
end
