Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A6744B773
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245361AbhKIWfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344748AbhKIWcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AD3661AAD;
        Tue,  9 Nov 2021 22:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496493;
        bh=y9JmxxUw+GlraImsv8ULDFNOvq8gzmhbn+Q6osRu/kE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCUzxiuSmR9nEcS7g+5bcyldez0gKC7CCnjZyouLC2hbuhw/xAxJ8CzkqfoNTDgp6
         jJo7K9q53k5ITSZqXUhNfvVWV83dX61UrroBJ9XXaLOR+/aYkm4lYV9EHZg8GMRbnf
         ZG7QaVPqmi1218y9G7QIZg+46ot+Imf+SZD15hITQEYpbziPmllPk573A7uy0VRNfc
         lNi3lBWHFrsBs9K1zukHJpVk+T4ccy7rKdJRuzFOq7lm91+e/wueP+jeQRzRzp7E8j
         sDHnakAPFBTofol5rlOwQ7OWDsk2q170PefLD88V7fzxm1jU2Qi/Ay1ApmwNZiAxF7
         xHwdmwSpqOo5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 18/50] ARM: dts: ux500: Skomer regulator fixes
Date:   Tue,  9 Nov 2021 17:20:31 -0500
Message-Id: <20211109222103.1234885-18-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

