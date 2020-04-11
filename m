Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF41A57F4
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgDKX1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:27:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729076AbgDKXLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1565421744;
        Sat, 11 Apr 2020 23:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646709;
        bh=aWqExgihGyj1TfMUyTA5tPHVlHKweus6wnZ2PJwW7Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnX/kuH21wyqrBvcdmBhhI9bSzj6TopufpTqO5Ol3fGY6vaeec4ABlNJmiKOWSFVH
         1KN4PwM2rsmd+KjzN5vXIlOZMS3tYLSHUyHNWVJwOrJnKI0Y7K/HP6JCtAMa3MMz1w
         /xwiC6mJojx0v5MN0RdPvCgIkNdBZBT/Oaiytui0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 101/108] arm64: dts: qcom: msm8998-mtp: Disable funnel 4 and 5
Date:   Sat, 11 Apr 2020 19:09:36 -0400
Message-Id: <20200411230943.24951-101-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 3498d9c05f804414c4645a2c0bba0187630fe5f0 ]

Disable Coresight funnel 4 and 5, for now, as these causes the MTP to
crash when clock late_initcall disables unused clocks.

Reviewed-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20200308055445.1992189-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
index 8d15572d18e64..2c8b8e7218b90 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
@@ -80,11 +80,15 @@
 };
 
 &funnel4 {
-	status = "okay";
+	// FIXME: Figure out why clock late_initcall crashes the board with
+	// this enabled.
+	// status = "okay";
 };
 
 &funnel5 {
-	status = "okay";
+	// FIXME: Figure out why clock late_initcall crashes the board with
+	// this enabled.
+	// status = "okay";
 };
 
 &pm8005_lsid1 {
-- 
2.20.1

