Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13052A6397
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgKDLtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbgKDLsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Nov 2020 06:48:41 -0500
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94142236F
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604490520;
        bh=OkC3OI19VRsZQB50NkZwMnwUdDOdVwEYnPr/zRIPJnw=;
        h=From:To:Subject:Date:From;
        b=R7IdonU0g8A7/cFxbQK3ZT0AwhzfTbyIdaGcpk+PWWOMW0KtIlwrkjiBEtVMnv75q
         Y1UtUw4SQGyU5FVCC+Q7YMFtOOrduLnEzkNCS6K2R1dnweg8NXo0Q9ri9oLz4f/oxx
         mTWuS5JQ0NurCndFpA2GVEPfXiyP4tR2G3YjR4gU=
Received: by pali.im (Postfix)
        id 3A5B164E; Wed,  4 Nov 2020 12:48:38 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Subject: [PATCH] arm64: dts: marvell: espressobin: add ethernet alias
Date:   Wed,  4 Nov 2020 12:48:13 +0100
Message-Id: <20201104114813.1199-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
[pali: Backported to 4.14]
Signed-off-by: Pali Rohár <pali@kernel.org>

---
This patch is backport for 4.14 stable release. From original patch were
removed aliases for uarts as they are not defined in 4.14 kernel version.

Stable releases 4.19 and 5.4 already contain backport of this patch.
---
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
index 2ce52ba74f73..13c0ec053ada 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts
@@ -52,6 +52,10 @@
 	model = "Globalscale Marvell ESPRESSOBin Board";
 	compatible = "globalscale,espressobin", "marvell,armada3720", "marvell,armada3710";
 
+	aliases {
+		ethernet0 = &eth0;
+	};
+
 	chosen {
 		stdout-path = "serial0:115200n8";
 	};
-- 
2.20.1

