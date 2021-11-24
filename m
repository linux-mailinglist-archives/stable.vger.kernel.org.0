Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE64E45C3FB
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348042AbhKXNpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:45:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:34768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353672AbhKXNnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B1460C49;
        Wed, 24 Nov 2021 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758761;
        bh=NNmy4jwqEz7jV8ggkkrX6c46LlgBk5vR4SOzWMcdR8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTgUJ/w+wD1T1MN5qy1j9B6r9S06LnzUJlvelQpyJ4/0fObv9z0CfwV7V1jTyT9vv
         TRq1kH+HQLgz4WQ+mfStUuQwL43N0AKg7UX7SrWGSAjK7qYYGZojtusJl61wdBXY+9
         /YXilIHqK2jXCLZeRp6VtTvypI23HI2aMvTLbgiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/279] ARM: dts: BCM5301X: Fix MDIO mux binding
Date:   Wed, 24 Nov 2021 12:54:56 +0100
Message-Id: <20211124115719.080064561@linuxfoundation.org>
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

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6ee0b56f7530e0ebb496fe15d0b54c5f3a1b5e17 ]

This fixes following error for all BCM5301X dts files:
mdio-bus-mux@18003000: compatible: ['mdio-mux-mmioreg'] is too short

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index f9d3a53065ef7..d4f355015e3ca 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -370,7 +370,7 @@
 	};
 
 	mdio-mux@18003000 {
-		compatible = "mdio-mux-mmioreg";
+		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		mdio-parent-bus = <&mdio>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.33.0



