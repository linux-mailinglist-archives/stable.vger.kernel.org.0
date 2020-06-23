Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B882205EAD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbgFWUYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390468AbgFWUYq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:24:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10E7D206C3;
        Tue, 23 Jun 2020 20:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943886;
        bh=zwhRJ+OuXl7qZ0G5brL2deN/W22Eb6hT5+ciEo1woDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mm5UrNkRxdfS4a31vCyxbZXReeSXtuwbxTs3uRMw4BsZqUl9DEKop4iiskFuuOo5A
         RL1okNg8jQQixMIyRodeRD5lQA2DyAeDJZdKocvWNPWkR5Zj6H+ha6Ia/F/SgWlQ/N
         /lyeP45SmTpdmy8iWoD8s0zpqEo+DeZKHHVRBjo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <mripard@kernel.org>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/314] ARM: dts: sun8i-h2-plus-bananapi-m2-zero: Fix led polarity
Date:   Tue, 23 Jun 2020 21:54:44 +0200
Message-Id: <20200623195343.114234629@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Stehlé <vincent.stehle@laposte.net>

[ Upstream commit 34b6826df7462c541752cf8b1de2691b26d78ae0 ]

The PWR-LED on the bananapi m2 zero board is on when gpio PL10 is low.
This has been verified on a board and in the schematics [1].

[1]: http://wiki.banana-pi.org/Banana_Pi_BPI-M2_ZERO#Documents

Fixes: 8b8061fcbfae ("ARM: dts: sun8i: h2+: add support for Banana Pi M2 Zero board")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Icenowy Zheng <icenowy@aosc.io>
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts
index d277d043031b2..4c6704e4c57ec 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts
@@ -31,7 +31,7 @@
 
 		pwr_led {
 			label = "bananapi-m2-zero:red:pwr";
-			gpios = <&r_pio 0 10 GPIO_ACTIVE_HIGH>; /* PL10 */
+			gpios = <&r_pio 0 10 GPIO_ACTIVE_LOW>; /* PL10 */
 			default-state = "on";
 		};
 	};
-- 
2.25.1



