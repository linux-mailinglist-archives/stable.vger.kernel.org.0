Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F382E410F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440029AbgL1ONF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439349AbgL1OLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6287205CB;
        Mon, 28 Dec 2020 14:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164625;
        bh=WutRhjvWyr3wij4pOX0Hdkp3LWfwCIBbCitfi1RcmQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S65MfeHXjCFJlVILJXZKlNKF4Gi8h06bjkacOBSQWKDZeKcUFXSfirKT0IYe6xj57
         QLHcG2LYHsq1NnWcmCS58cQXJXP/jAo/sHe77ovqh6fg8YR4y39XubV/sVWgVh1vxR
         bYyVqkP0EgTvdZLj7tWqz3zNSBzWFoGQEeDAgwY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/717] arm64: dts: qcom: c630: Fix pinctrl pins properties
Date:   Mon, 28 Dec 2020 13:43:57 +0100
Message-Id: <20201228125032.447287550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit f55d373f7953909160cb4c1398f62123cdbe7650 ]

The "pins" property takes an array of pin _names_, not pin numbers. Fix
this.

Tested-by: Steev Klimaszewski <steev@kali.org>
Fixes: 44acee207844 ("arm64: dts: qcom: Add Lenovo Yoga C630")
Link: https://lore.kernel.org/r/20201130170028.319798-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 60c6ab8162e21..76a8c996d497f 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -432,7 +432,7 @@
 	gpio-reserved-ranges = <0 4>, <81 4>;
 
 	i2c3_hid_active: i2c2-hid-active {
-		pins = <37>;
+		pins = "gpio37";
 		function = "gpio";
 
 		input-enable;
@@ -441,7 +441,7 @@
 	};
 
 	i2c5_hid_active: i2c5-hid-active {
-		pins = <125>;
+		pins = "gpio125";
 		function = "gpio";
 
 		input-enable;
@@ -450,7 +450,7 @@
 	};
 
 	i2c11_hid_active: i2c11-hid-active {
-		pins = <92>;
+		pins = "gpio92";
 		function = "gpio";
 
 		input-enable;
@@ -459,7 +459,7 @@
 	};
 
 	wcd_intr_default: wcd_intr_default {
-		pins = <54>;
+		pins = "gpio54";
 		function = "gpio";
 
 		input-enable;
-- 
2.27.0



