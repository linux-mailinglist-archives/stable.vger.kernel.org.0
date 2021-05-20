Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D97838A237
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhETJje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhETJho (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:37:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90F0761415;
        Thu, 20 May 2021 09:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503027;
        bh=g9lcrvbedBjcGmtX7bSTpR/T7bL9Hv2jZH2ZdJAl2ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCcwOdwv0cM/BydhoTb8dj94/MF+Z3Hjvm1BO7WLGiM7FWJI98JQ4ivVx8Fzq1aYd
         4KnlFKHt3BxtM5aXxN8AQMVUZcPpZrYZqRSORGJGYhp6BfzCDsg3u+dlJygDZ2Gb/G
         lnzNaVnJw+O4oO0vs49IXuEecCSYTtqDDEeI5JDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 4.19 006/425] arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node
Date:   Thu, 20 May 2021 11:16:15 +0200
Message-Id: <20210520092131.541380012@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -143,7 +143,8 @@
 			};
 
 			nb_periph_clk: nb-periph-clk@13000 {
-				compatible = "marvell,armada-3700-periph-clock-nb";
+				compatible = "marvell,armada-3700-periph-clock-nb",
+					     "syscon";
 				reg = <0x13000 0x100>;
 				clocks = <&tbg 0>, <&tbg 1>, <&tbg 2>,
 				<&tbg 3>, <&xtalclk>;


