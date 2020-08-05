Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450E923C967
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgHEJoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgHEJoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 05:44:00 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD832067C
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 09:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596620639;
        bh=SD6A3xz7cpNt+VHyoOzgeZgqK/dbWYSO7YjBdkQXYXg=;
        h=From:To:Subject:Date:From;
        b=JoooD10slbezWdrlaiRmL5xxbHkMqKq5ibPK7/i6+MKcP5UNc/HDUbFQMBQdGzyn0
         /ApNzaPVcRLuBVA0FvRn1RL13cc7mA9g79fW6NM1pbVWmJStXNXCcIfZQXp6RL1HzD
         N4gelRu/1WCJP/llTKiF6/Nipq/dGyCU+y7/LR2w=
Received: by pali.im (Postfix)
        id 94DFACBA; Wed,  5 Aug 2020 11:43:57 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Subject: [PATCH] arm64: dts: marvell: espressobin: add ethernet alias
Date:   Wed,  5 Aug 2020 11:43:33 +0200
Message-Id: <20200805094333.12503-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomasz Maciej Nowak <tmn505@gmail.com>

commit 5253cb8c00a6f4356760efb38bca0e0393aa06de upstream.

The maker of this board and its variants, stores MAC address in U-Boot
environment. Add alias for bootloader to recognise, to which ethernet
node inject the factory MAC address.

Signed-off-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
[pali: Backported to 5.4 and older versions]
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
index fbcf03f86c96..05dc58c13fa4 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -19,6 +19,12 @@
 	model = "Globalscale Marvell ESPRESSOBin Board";
 	compatible = "globalscale,espressobin", "marvell,armada3720", "marvell,armada3710";
 
+	aliases {
+		ethernet0 = &eth0;
+		serial0 = &uart0;
+		serial1 = &uart1;
+	};
+
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
-- 
2.20.1

