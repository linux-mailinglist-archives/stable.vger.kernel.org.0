Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218343C8CF0
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhGNTnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235181AbhGNTmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67877613E2;
        Wed, 14 Jul 2021 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291588;
        bh=9hKbyRxtO7h+nQGpfz2wwACQPbDfUtvoGjRP807Q/pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taKMyJWn+LHB4+Qy+BX6UbRrlNwxkWiNYiHIYuR51xQo0vQtBIYNl0N0VyqYYyGrv
         F01fwewFL/NIPltoFGqvmB4kLExRgjqA9ed0Q15khNLRL7z9Vh5N4xMvB+wrDfLJnH
         MWHAwmrPqK0ydXRASqVWpMh3blahwdFtTnxw69GN3lSZ1N15d9rvgYj8JaRYjGCc+j
         YO0wEQeXr6KzSiqJQU7HAKv5//I8vXsiHSIg5H+ZdkxPq4ZlAZkupEDeEGglC2P730
         48xX6B3kauKa23ujjnJloPT6YCaettckFZPjp43b9jCDEPlKFE9HC8rdJM8gzoYzQj
         lbotDoIOcFbzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 074/108] ARM: dts: stm32: fix ltdc pinctrl on microdev2.0-of7
Date:   Wed, 14 Jul 2021 15:37:26 -0400
Message-Id: <20210714193800.52097-74-sashal@kernel.org>
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

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit 11aaf2a0f8f070e87833775965950157bf57e49a ]

It prevents the following warning:

 pin-controller@50002000: 'ltdc' does not match any of the regexes:
'-[0-9]*$', '^gpio@[0-9a-f]*$', 'pinctrl-[0-9]+'

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/stm32mp157a-microgea-stm32mp1-microdev2.0-of7.dts  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157a-microgea-stm32mp1-microdev2.0-of7.dts b/arch/arm/boot/dts/stm32mp157a-microgea-stm32mp1-microdev2.0-of7.dts
index 674b2d330dc4..5670b23812a2 100644
--- a/arch/arm/boot/dts/stm32mp157a-microgea-stm32mp1-microdev2.0-of7.dts
+++ b/arch/arm/boot/dts/stm32mp157a-microgea-stm32mp1-microdev2.0-of7.dts
@@ -89,7 +89,7 @@ ltdc_ep0_out: endpoint@0 {
 };
 
 &pinctrl {
-	ltdc_pins: ltdc {
+	ltdc_pins: ltdc-0 {
 		pins {
 			pinmux = <STM32_PINMUX('G', 10, AF14)>,	/* LTDC_B2 */
 				 <STM32_PINMUX('H', 12, AF14)>,	/* LTDC_R6 */
-- 
2.30.2

