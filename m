Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A3111D27
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbfLCWuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbfLCWum (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:50:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0EDC20848;
        Tue,  3 Dec 2019 22:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413442;
        bh=hRQeDkByL8QEKVXoXktXKnPJwQx473J1hBcnIlZEy3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/l8JAFT27FiTgAuRjL2IyhS4WmiMe77RmXUWaHEPPDQ6P2IomQSDLZ0ch7ClQa0G
         c2T+wHH6TbBRquBDNRHGN7sUoF+XiJzqwb4PVJlmmZ1J4ep8o4CcTodapFJiksAMTx
         NPipZ/88w1ZpHfOn+14rq+/3h86kts8EmxlfuxXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/321] arm64: dts: renesas: draak: Fix CVBS input
Date:   Tue,  3 Dec 2019 23:32:35 +0100
Message-Id: <20191203223431.782925616@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



