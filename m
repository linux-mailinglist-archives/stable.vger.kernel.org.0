Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C4B106659
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbfKVG3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfKVFt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893E82070B;
        Fri, 22 Nov 2019 05:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401796;
        bh=hRQeDkByL8QEKVXoXktXKnPJwQx473J1hBcnIlZEy3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5567OOMi2HSqclILq58Q5cIb6CZeh3LJv9ABLD3KHsja1Mm2JyIZjc/PC9uhVPJM
         ZCMA8leDHLzoV8QCpyFAXfi/b8wammknZ12Ofzbt4hPzLQGt+k0AxT5OX6nQ1yLoSj
         su6zgTVsJBLyt9MMx/70piwmQ4j5PlPI6nDLEosY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 043/219] arm64: dts: renesas: draak: Fix CVBS input
Date:   Fri, 22 Nov 2019 00:46:15 -0500
Message-Id: <20191122054911.1750-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 6f61a2c8f1f6163c7e08c77c5f71df0427e4d2f6 ]

A typo in the adv7180 DT node prevents successful probing of the VIN.
Fix it.

Fixes: 6a0942c20f5c ("arm64: dts: renesas: draak: Describe CVBS input")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77995-draak.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77995-draak.dts b/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
index a8e8f2669d4c5..1b8f19ee257f0 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77995-draak.dts
@@ -188,7 +188,7 @@
 		compatible = "adi,adv7180cp";
 		reg = <0x20>;
 
-		port {
+		ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-- 
2.20.1

