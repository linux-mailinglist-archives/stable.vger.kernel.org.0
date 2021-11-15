Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D51F45118A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243961AbhKOTJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243919AbhKOTGi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D6E5633EC;
        Mon, 15 Nov 2021 18:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000210;
        bh=5xvMpRD9le189Abdi1JrqSaAV7ieI75m9uNIfj5CMow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyDNSf3+N3ZhP0uBF5fnw+Ph33maAHuA/2GnZHtE7vaEJt/aWtfVG+pr3ntjRvMNx
         igZXf8GUyd9GlRfcjkddWCX5XRjAyi+TpqLDkeXqsiURc97HjqFcpYZSOJvi7pNnjY
         Ei5kVOr0sOZ9J+r6pR+wVWSqHG3hdjv0JNJIlBgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 578/849] arm64: dts: renesas: beacon: Fix Ethernet PHY mode
Date:   Mon, 15 Nov 2021 18:01:01 +0100
Message-Id: <20211115165439.807658828@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 59a8bda062f8646d99ff8c4956adf37dee1cb75e ]

While networking works fine in RGMII mode when using the Linux generic
PHY driver, it fails when using the Atheros PHY driver.
Fix this by correcting the Ethernet PHY mode to RGMII-RXID, which works
fine with both drivers.

Fixes: a5200e63af57d05e ("arm64: dts: renesas: rzg2: Convert EtherAVB to explicit delay handling")
Reported-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/2a4c15b2df23bb63f15abf9dfb88860477f4f523.1632465965.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 090dc9c4f57b5..937d17a426b66 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -50,6 +50,7 @@
 &avb {
 	pinctrl-0 = <&avb_pins>;
 	pinctrl-names = "default";
+	phy-mode = "rgmii-rxid";
 	phy-handle = <&phy0>;
 	rx-internal-delay-ps = <1800>;
 	tx-internal-delay-ps = <2000>;
-- 
2.33.0



