Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D7045C29B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349455AbhKXNaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:30:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350780AbhKXN2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:28:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC05961151;
        Wed, 24 Nov 2021 12:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758274;
        bh=y9JmxxUw+GlraImsv8ULDFNOvq8gzmhbn+Q6osRu/kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arOC5LhBL0z6Yp3erhCyJ0rdrsVtcDT7VIBd5kJtNqPGjb2+NQIW+EXbPybD2cs+S
         kkJMkf8tKcXjp/8hTx4pfhrXCpZmhEAZYXsZev+sJzRk2MbRIxSRrJ4IyfWLFVLc9r
         QrOAqBPBQDyvBZMWoiKabxgsqeQiymOtTdfhVm3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/154] ARM: dts: ux500: Skomer regulator fixes
Date:   Wed, 24 Nov 2021 12:56:52 +0100
Message-Id: <20211124115702.903666800@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 7aee0288beab72cdfa35af51f62e94373fca595d ]

AUX2 has slightly wrong voltage and AUX5 doesn't need to be
always on.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
index 27722c42b61c4..08bddbf0336da 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -262,10 +262,10 @@
 					};
 
 					ab8500_ldo_aux2 {
-						/* Supplies the Cypress TMA140 touchscreen only with 3.3V */
+						/* Supplies the Cypress TMA140 touchscreen only with 3.0V */
 						regulator-name = "AUX2";
-						regulator-min-microvolt = <3300000>;
-						regulator-max-microvolt = <3300000>;
+						regulator-min-microvolt = <3000000>;
+						regulator-max-microvolt = <3000000>;
 					};
 
 					ab8500_ldo_aux3 {
@@ -284,9 +284,9 @@
 
 					ab8500_ldo_aux5 {
 						regulator-name = "AUX5";
+						/* Intended for 1V8 for touchscreen but actually left unused */
 						regulator-min-microvolt = <1050000>;
 						regulator-max-microvolt = <2790000>;
-						regulator-always-on;
 					};
 
 					ab8500_ldo_aux6 {
-- 
2.33.0



