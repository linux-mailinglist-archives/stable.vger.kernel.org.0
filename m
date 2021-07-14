Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F4F3C8D21
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhGNTnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235761AbhGNTnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41D5A613E4;
        Wed, 14 Jul 2021 19:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291615;
        bh=VS0/Le/ItSlZUoCnxW7/1qeWmT4X2KmBRrxaW+zvDuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIEIOjLByrAZ7RMmTqRCIZpTUeG7PMYmng3D0tZTh0Q+rHCAXpw5aAJDJvbSPPJmz
         P+qPXlD24m7YIePkmcAYmPMshiTlyusSst0A4r7G3yM3PW+3Sze10GjiXs6zGF2u9J
         bPSl7OqbDvZ+lLEINo0xjHD1EXZwIHvnD+xEHXGBhNWbZBZwQu3as6gzd3SdCRuvOE
         sWqLjpn9czsKed6cG9WNqzGz2IpjmxzwqGC73+Ht63vjVMWEm4baMLD66Fb6LsFX+q
         VIO3xuf4upzGw5LN6Z1tr/deAGIks6mDUpP98gdJZ60kyJFxeTHgFVDbiOgZL9pSwu
         4IqPGv+MAMZXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 093/108] arm64: dts: qcom: sm8250: Fix pcie2_lane unit address
Date:   Wed, 14 Jul 2021 15:37:45 -0400
Message-Id: <20210714193800.52097-93-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit dc2f86369b157dfe4dccd31497d2e3c541e7239d ]

The previous one was likely a mistaken copy from pcie1_lane.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Link: https://lore.kernel.org/r/20210613185334.306225-1-konrad.dybcio@somainline.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 75f9476109e6..09b552396557 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1470,7 +1470,7 @@ pcie2_phy: phy@1c16000 {
 
 			status = "disabled";
 
-			pcie2_lane: lanes@1c0e200 {
+			pcie2_lane: lanes@1c16200 {
 				reg = <0 0x1c16200 0 0x170>, /* tx0 */
 				      <0 0x1c16400 0 0x200>, /* rx0 */
 				      <0 0x1c16a00 0 0x1f0>, /* pcs */
-- 
2.30.2

