Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F7713E4BA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389877AbgAPRKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389874AbgAPRKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF972467E;
        Thu, 16 Jan 2020 17:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194614;
        bh=7rQWqqy9vB7cmNBIyVXD5ebsvNXRbNqggHGF1w89Uj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFX1nVxzB1GdDzOqBcP1Dee2bNRaL++j1QV0/8Z8XcXtQXOQBbdiWiDCWWgWCZPcs
         AvGOffJlXwonQ06C4jqjRTOL43odLG5y1fQRTb86540ude3jiOYpo4o72qK5RSld92
         9rhjZW4SUCpRCOLfNhphqSdEIfdf6v9QGfjOPqkI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 478/671] ARM: dts: stm32: add missing vdda-supply to adc on stm32h743i-eval
Date:   Thu, 16 Jan 2020 12:01:56 -0500
Message-Id: <20200116170509.12787-215-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 493e84c5dc4d703d976b5875f5db22dae08a0782 ]

Add missing vdda-supply required by STM32 ADC.

Fixes: 090992a9ca54 ("ARM: dts: stm32: enable ADC on stm32h743i-eval
board")

Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32h743i-eval.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/stm32h743i-eval.dts b/arch/arm/boot/dts/stm32h743i-eval.dts
index 3f8e0c4a998d..5bf64e63cdf3 100644
--- a/arch/arm/boot/dts/stm32h743i-eval.dts
+++ b/arch/arm/boot/dts/stm32h743i-eval.dts
@@ -79,6 +79,7 @@
 };
 
 &adc_12 {
+	vdda-supply = <&vdda>;
 	vref-supply = <&vdda>;
 	status = "okay";
 	adc1: adc@0 {
-- 
2.20.1

