Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE792E64B7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390607AbgL1PwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391225AbgL1Nim (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EB62205CB;
        Mon, 28 Dec 2020 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162681;
        bh=pR26vfX01sjE8P13sv0GYBuJB2wouUtS0lCio6Fb2Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuIYWdreB/wuu0U8c93hjTln17Af6+SynAky/aw2xZfMFq6lIYvwUJ4JCHlE1PC0Z
         rcfUpexNvxsdVctQehUMrB5irbiZTX+8x2XZrh6NAxV+Z5FBkZrO5XQdpw5/57/6Gn
         8zkqXzeVo5MF44CVtY0a1gBXNgbSQnc8hKf6d5Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/453] ARM: dts: sun8i: v3s: fix GIC node memory range
Date:   Mon, 28 Dec 2020 13:44:02 +0100
Message-Id: <20201228124937.550013014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit a98fd117a2553ab1a6d2fe3c7acae88c1eca4372 ]

Currently the GIC node in V3s DTSI follows some old DT examples, and
being broken. This leads a warning at boot.

Fix this.

Fixes: f989086ccbc6 ("ARM: dts: sunxi: add dtsi file for V3s SoC")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201120050851.4123759-1-icenowy@aosc.io
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-v3s.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-v3s.dtsi b/arch/arm/boot/dts/sun8i-v3s.dtsi
index 2abcba35d27e6..50c32cf72c65c 100644
--- a/arch/arm/boot/dts/sun8i-v3s.dtsi
+++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
@@ -423,7 +423,7 @@
 		gic: interrupt-controller@1c81000 {
 			compatible = "arm,gic-400";
 			reg = <0x01c81000 0x1000>,
-			      <0x01c82000 0x1000>,
+			      <0x01c82000 0x2000>,
 			      <0x01c84000 0x2000>,
 			      <0x01c86000 0x2000>;
 			interrupt-controller;
-- 
2.27.0



