Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7D3461EF7
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379329AbhK2SmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:42:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42612 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379332AbhK2SkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:40:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 450E3B815D4;
        Mon, 29 Nov 2021 18:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAFFC53FAD;
        Mon, 29 Nov 2021 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211008;
        bh=djMT1jroNL58Oss+UaQjxdK/neylESckMbZRUTQt6Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxRRxREL5yGfLEfPtqa4UBbttn3morKhhdglkvnGjPnuAwMMOCpuxxZR3yT/o2PB9
         nPLT/LcObgbDBwOTwEbTvBIPdBiR4n1ApLxjZ9fEBqlC/rhPWOxL+YEiMKGkQd9RKp
         tNgB+Ez7liol85/etYaVDLYGnmyq/Hx47afDB28M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/179] ARM: dts: BCM5301X: Add interrupt properties to GPIO node
Date:   Mon, 29 Nov 2021 19:17:46 +0100
Message-Id: <20211129181721.318020240@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 40f7342f0587639e5ad625adaa15efdd3cffb18f ]

The GPIO controller is also an interrupt controller provider and is
currently missing the appropriate 'interrupt-controller' and
'#interrupt-cells' properties to denote that.

Fixes: fb026d3de33b ("ARM: BCM5301X: Add Broadcom's bus-axi to the DTS file")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 437a2b0f68de3..f69d2af3c1fa4 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -242,6 +242,8 @@ chipcommon: chipcommon@0 {
 
 			gpio-controller;
 			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 		};
 
 		pcie0: pcie@12000 {
-- 
2.33.0



