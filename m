Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 970941A5A50
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgDKXmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728501AbgDKXGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E42C21D7F;
        Sat, 11 Apr 2020 23:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646405;
        bh=rhJOOdjWjLkN4H3GgVO30K+ASXEaoHk0JxgBV90c58Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gub8vzGI6wYxq4oLVF+0GkeC9hENk1WGJfn0fud+GvBtHyEBOcYDMvLdVSl3R0y4
         t+2+E+CeGMPNWtSZkpKMgyGrqw7LWjxch9WqBgrbsofrUlu4QpjrQZP0tjozJ5WSgq
         iG+oUZvO8pZhOJ0mjMTRdqNT4Em+O2oigkeZ/yes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 141/149] arm64: dts: qcom: msm8998-mtp: Disable funnel 4 and 5
Date:   Sat, 11 Apr 2020 19:03:38 -0400
Message-Id: <20200411230347.22371-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
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
index 0e0b9bc12945f..8a14b2bf7bca3 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi
@@ -95,11 +95,15 @@
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

