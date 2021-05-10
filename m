Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B3F378725
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhEJLOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236066AbhEJLH0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21F03616EA;
        Mon, 10 May 2021 10:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644286;
        bh=eJh4oQrwCyuRE+nIcxF7v8RhKUzvcgR3cToP6EwYf1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RByJKhqqpJZE13g4X49mfFGtSe0H/g0KFz0h5ccozQ6FHc9hOe8E3jKtv0gFsVb1r
         HP9JppCBzv9rypOYCU/r76Y4cfQkBMIoceUf1VsISIBPhDjGLaaEcnZsetUdUplF0j
         +3Web6jRfVTCbW/nqaLWmi4gTA5ViiZqgbCyk4Es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.12 020/384] arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node
Date:   Mon, 10 May 2021 12:16:49 +0200
Message-Id: <20210510102015.542071507@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit 1d88358a89dbac9c7d4559548b9a44840456e6fb upstream.

Add "syscon" compatible to the North Bridge clocks node to allow the
cpufreq driver to access these registers via syscon API.

This is needed for a fix of cpufreq driver.

Signed-off-by: Marek Behún <kabel@kernel.org>
Fixes: e8d66e7927b2 ("arm64: dts: marvell: armada-37xx: add nodes...")
Cc: stable@vger.kernel.org
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -156,7 +156,8 @@
 			};
 
 			nb_periph_clk: nb-periph-clk@13000 {
-				compatible = "marvell,armada-3700-periph-clock-nb";
+				compatible = "marvell,armada-3700-periph-clock-nb",
+					     "syscon";
 				reg = <0x13000 0x100>;
 				clocks = <&tbg 0>, <&tbg 1>, <&tbg 2>,
 				<&tbg 3>, <&xtalclk>;


