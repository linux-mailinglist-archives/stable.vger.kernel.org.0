Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674A72E3D0A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439015AbgL1OKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438993AbgL1OKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BABFB205CB;
        Mon, 28 Dec 2020 14:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164582;
        bh=HFNg8JIIOWpaHw9VZMaqfPUhL/uzENC1QVvQ1Xe30Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OF8FbnZyKv6DqnsT7y4h7wI3Md3P38/k8B0f/p1rGbvF46I2fpH4CjXe6Hv8FZJYE
         G6XtV91mSjTo1/usfgdn7Ns5dD0KWx6FR8SM1YNSpBFFB55i9t122svxNnrS3EZu+V
         cnBIz3cih24SEZtoB9Stqz0ioSuAZ+Ply6yXlw9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/717] ARM: dts: Remove non-existent i2c1 from 98dx3236
Date:   Mon, 28 Dec 2020 13:43:44 +0100
Message-Id: <20201228125031.810779925@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 7f24479ead579459106bb55c2320a000135731f9 ]

The switches with integrated CPUs have only got a single i2c controller.
They incorrectly gained one when they were split from the Armada-XP.

Fixes: 43e28ba87708 ("ARM: dts: Use armada-370-xp as a base for armada-xp-98dx3236")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-xp-98dx3236.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
index 654648b05c7c2..aeccedd125740 100644
--- a/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
+++ b/arch/arm/boot/dts/armada-xp-98dx3236.dtsi
@@ -266,11 +266,6 @@
 	reg = <0x11000 0x100>;
 };
 
-&i2c1 {
-	compatible = "marvell,mv78230-i2c", "marvell,mv64xxx-i2c";
-	reg = <0x11100 0x100>;
-};
-
 &mpic {
 	reg = <0x20a00 0x2d0>, <0x21070 0x58>;
 };
-- 
2.27.0



