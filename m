Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6B0469A74
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346362AbhLFPIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:08:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56088 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345455AbhLFPGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79E6B6130A;
        Mon,  6 Dec 2021 15:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE82C341C1;
        Mon,  6 Dec 2021 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802971;
        bh=nRhNyhAGosYuepoTZ4ADOpTMOQsAdOL7fOH2re6rVqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYcJS+r4YZbvo42A2FK5GvCWpm+dLB0BasVvts3SONfoazjMhdL5P6ysed0XL5Zxm
         A1K8AD7+NyHgpqod0j8mW5KpJ2Lsky659yY828jgSVTZ+wVxdkQEMS8k1U+DefbDzu
         NbokUeLZp0Iqyvr7genh478w9ZasUibGXvWWnfnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/62] ARM: dts: BCM5301X: Add interrupt properties to GPIO node
Date:   Mon,  6 Dec 2021 15:55:56 +0100
Message-Id: <20211206145549.615753780@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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
index 4616452ce74de..e0f96be549f14 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -234,6 +234,8 @@ chipcommon: chipcommon@0 {
 
 			gpio-controller;
 			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 		};
 
 		usb2: usb2@21000 {
-- 
2.33.0



