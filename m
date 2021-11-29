Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37491461DEA
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354480AbhK2Sao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:30:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49240 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348065AbhK2S2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:28:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2BF34CE13DB;
        Mon, 29 Nov 2021 18:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B21C53FAD;
        Mon, 29 Nov 2021 18:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210323;
        bh=KuIJE8WdtVbwv4vN9QUxtEGF6G5gnTFTliNnDyJMsIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i33+8AHemx6RInzqqO0EBFJCIV63k02htYsAKqvyPOYpP1LXWiEod5FRkNMrRbI0+
         yP4QnyFXPW022NW6gpmWrdd2Yd73Ag6fz3LweVQ0jIQ8dvnV8qM3zPsIgXM/uBT2h6
         AvtgcO0NMs2S9eF9sBl5fOHQv0PmIrSjRcYPbKUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/92] ARM: dts: BCM5301X: Add interrupt properties to GPIO node
Date:   Mon, 29 Nov 2021 19:18:17 +0100
Message-Id: <20211129181709.025259287@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
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
index 51f20ded92f04..05d67f9769118 100644
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



