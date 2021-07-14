Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45B13C8F60
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbhGNTwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239300AbhGNTtO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 961246140C;
        Wed, 14 Jul 2021 19:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291853;
        bh=29cAEU4K9Wm8Q7228i3YIma5K9Eqt5LH+pj5xiCsELQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THr8pBHCJgiTOj/XCEGgdrrOC0Kt99kNHcx8An1kSaK8fK6WTjbB+yUISySONq8Hk
         BhYv+8t7HBZV9g0PPa72T5dcSa80aYdWj8S7WzMsVV4IL2rD4+QsmEoqPqUQa58d/s
         EuaMvNKaYiI2JWSUwZSXA4MAnqofaeODarsyQho3PjlGJkFw1xbkDeotbLTacHN8vj
         CQl8I/Qr4DOcbF19PFdNXV5/fVPFcWVreMNFSXUQ4JQHHJGeAr22A6gXOvm0mNCp8I
         5nxV49tyl5MbY4duiCIojGc0iYbP2LjHOmrT5PDwUokPWsnOdN0Tw/YalkXMA+HfKl
         TDsI+FvsCYkGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sujit Kautkar <sujitka@chromium.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 46/88] arm64: dts: qcom: sc7180: Move rmtfs memory region
Date:   Wed, 14 Jul 2021 15:42:21 -0400
Message-Id: <20210714194303.54028-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sujit Kautkar <sujitka@chromium.org>

[ Upstream commit d4282fb4f8f9683711ae6c076da16aa8e675fdbd ]

Move rmtfs memory region so that it does not overlap with system
RAM (kernel data) when KAsan is enabled. This puts rmtfs right
after mba_mem which is not supposed to increase beyond 0x94600000

Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Sujit Kautkar <sujitka@chromium.org>
Link: https://lore.kernel.org/r/20210514113430.1.Ic2d032cd80424af229bb95e2c67dd4de1a70cb0c@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-idp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
index e77a7926034a..afe0f9c25816 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -45,7 +45,7 @@ chosen {
 
 /* Increase the size from 2MB to 8MB */
 &rmtfs_mem {
-	reg = <0x0 0x84400000 0x0 0x800000>;
+	reg = <0x0 0x94600000 0x0 0x800000>;
 };
 
 / {
-- 
2.30.2

