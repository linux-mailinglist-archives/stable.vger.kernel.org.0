Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135AC3D29BA
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbhGVQGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234438AbhGVQEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC18361976;
        Thu, 22 Jul 2021 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972318;
        bh=e42oUYOxqbUoQPY3zHnzD3r+ab35lLGWo7U6MqroTqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Egc4Z7YTwDFFVk8Q0qXObYCz/ktv2T2mORS5sgnUAgUrdTRCXW5ditOvgxbcV+bwX
         dHY2plCSml9QpBREd3cLHU9gU88mCUZwZ+AxHXPZ6RKclyOhF051hXq7UEU/rA/or8
         tugCGjSScosznxKfc/m73fadnd8aMQOJEcDZx7d4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 067/156] ARM: dts: stm32: fix ltdc pinctrl on microdev2.0-of7
Date:   Thu, 22 Jul 2021 18:30:42 +0200
Message-Id: <20210722155630.566741910@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -89,7 +89,7 @@
 };
 
 &pinctrl {
-	ltdc_pins: ltdc {
+	ltdc_pins: ltdc-0 {
 		pins {
 			pinmux = <STM32_PINMUX('G', 10, AF14)>,	/* LTDC_B2 */
 				 <STM32_PINMUX('H', 12, AF14)>,	/* LTDC_R6 */
-- 
2.30.2



