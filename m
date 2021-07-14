Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29A63C8E4F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238233AbhGNTrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234244AbhGNTqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 900EB613DA;
        Wed, 14 Jul 2021 19:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291760;
        bh=zeAJ4J9JQ5MMRnkzirDOW3CVSJbL0orvwAY3M/il1HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3vsrqfujuK+gH48WX4s7MO0gD7LQEEpi4unDM8VwTZGNtMHNi8gk0pvplj8Zw731
         C4PZ/9ALm6O1K9b+8YvhJNg1z+h58fMTXusMbAxowbhB3z1NnbdKemUdCJlyoleEu0
         VNO/aap5zWxdzTDnD36k3jCzMxmH4AzsB+62AR7TlKU65bAEWisNe1br7QsQJEsb91
         JREBilHtsZPy0QDGq9vHA/jjzUoFN4GvrPPGF5qi7KteQNRfWeRB0maMtJtCCUwreE
         NvM5z9MEy3Ex7nMK7/6McWbTYB+dGHOQL78Cn7k6gUJG4uYNq4vZoiNOf1WAxJdAVu
         1l0O+/on+sIug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 087/102] arm64: dts: qcom: sm8250: Fix pcie2_lane unit address
Date:   Wed, 14 Jul 2021 15:40:20 -0400
Message-Id: <20210714194036.53141-87-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index 46a6c18cea91..ee11a6d143e4 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1509,7 +1509,7 @@ pcie2_phy: phy@1c16000 {
 
 			status = "disabled";
 
-			pcie2_lane: lanes@1c0e200 {
+			pcie2_lane: lanes@1c16200 {
 				reg = <0 0x1c16200 0 0x170>, /* tx0 */
 				      <0 0x1c16400 0 0x200>, /* rx0 */
 				      <0 0x1c16a00 0 0x1f0>, /* pcs */
-- 
2.30.2

