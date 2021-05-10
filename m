Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808DB37856A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbhEJLAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234159AbhEJK4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EACF6144F;
        Mon, 10 May 2021 10:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643464;
        bh=eJh4oQrwCyuRE+nIcxF7v8RhKUzvcgR3cToP6EwYf1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BAa1JTuA0qeUEYv8AtTrFhnS59JdckzQIR3qeKdYNU9RXATvwlZi8T6aTTM5Bodlw
         G1cYiy+9vA5924l/ozWhEmz+FST3hPm3K2xNEqfTi9E1otaTzzzVoFm+hyPLaZRwOa
         M3PqhZWx7aeOA7CUvAxnN4VOOTrccShJjqG6phC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 5.11 018/342] arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node
Date:   Mon, 10 May 2021 12:16:48 +0200
Message-Id: <20210510102010.708116220@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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


