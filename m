Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99D22E397C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388652AbgL1NYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388637AbgL1NYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10E6F208BA;
        Mon, 28 Dec 2020 13:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161804;
        bh=0/d28QdZsOf2j38RvXjtEvfLxPrhVRdfRcRMjm4fEbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huq+HoMOhtYUpNSBn4j4unUiXh0phakyS+9HlV1kEqtQxiDsxjNNA/dIRYeNsxhEn
         IlTGTCCWBFZhUL/Rwf/mV4vrVskD2akXMijhxYccst3jyoz1FFtoie0iJFBzdXlxWO
         cHBI6Y7vc1NE672fPio7Xxv9KcaNrOZyqdrRmhNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/346] ARM: dts: sun8i: v3s: fix GIC node memory range
Date:   Mon, 28 Dec 2020 13:46:16 +0100
Message-Id: <20201228124922.551658413@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 92fcb756a08a9..97cac6d636923 100644
--- a/arch/arm/boot/dts/sun8i-v3s.dtsi
+++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
@@ -419,7 +419,7 @@
 		gic: interrupt-controller@1c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-			      <0x01c82000 0x1000>,
+			      <0x01c82000 0x2000>,
 			      <0x01c84000 0x2000>,
 			      <0x01c86000 0x2000>;
 			interrupt-controller;
-- 
2.27.0



