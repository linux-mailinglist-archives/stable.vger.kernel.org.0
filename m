Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C745C47D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351856AbhKXNta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346141AbhKXNqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:46:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCAC6332F;
        Wed, 24 Nov 2021 13:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758864;
        bh=cu/bqtw9RWtPNA9V8zfU73kT1TMaVL2UnCG56a5XWpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNeR9MNnWcV1oeisIaaIcBIr2t8TlX986K3zh7ZkO0W/UOxSd+nXSL6cpW1Zx2Kfl
         00w4yxB/qnfN9F5tUf64hU+wVGKdYmfVB3y4cNzk7OcYCjSzLBhElhsmkI1tMhtTN3
         xKY7Zabg+1yqhk2bqBZUAg67NKU1/+O/LE2EJsTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/279] ARM: dts: ux500: Skomer regulator fixes
Date:   Wed, 24 Nov 2021 12:55:09 +0100
Message-Id: <20211124115719.512685948@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
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
index 264f3e9b5fce5..86e83639fadc1 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -292,10 +292,10 @@
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
@@ -314,9 +314,9 @@
 
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



