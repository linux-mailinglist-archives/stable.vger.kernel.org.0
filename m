Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6915A44B5E1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245685AbhKIWXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245726AbhKIWWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:22:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BBCB61251;
        Tue,  9 Nov 2021 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496304;
        bh=U22rbgzymfHX++0ABHjijmAjDVGHM7QIFGG1734d080=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loQc2yW5IJZfBHSHmlfRIAB5j4yIesM3FOECDhWTknL6701kqLHKLJlQ6JA5oSImU
         YeMJ8GqBLYQG5a467yvvqz5I5e6Hg/C4uj+sisJRH0d4gEoCXlvqcSfGBiZlxYuPsJ
         ia0L6vPqmiXYQRMD67Jj5l1zbkqS+QE6BPGDmrLQ5CIKn7GzfuHySdhjImOqnq5q+k
         xoBlDK/uQosT+cGwUuh340AAEIxev0sMNPqY1EHtt/DYXcz8gSuIZukxN2zlYjVMWP
         FsNEaKU2Sn5GL4xKx2AGqrPTbuRj+4dl7E90o8vGsI/DFdSkoQKFXBMQ3t2aZY1lAL
         rTHzzMH8p+/FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Yang <leoyang.li@nxp.com>,
        Kuldeep Singh <kuldeep.singh@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 57/82] ARM: dts: ls1021a-tsn: use generic "jedec,spi-nor" compatible for flash
Date:   Tue,  9 Nov 2021 17:16:15 -0500
Message-Id: <20211109221641.1233217-57-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Yang <leoyang.li@nxp.com>

[ Upstream commit 05e63b48b20fa70726be505a7660d1a07bc1cffb ]

We cannot list all the possible chips used in different board revisions,
just use the generic "jedec,spi-nor" compatible instead.  This also
fixes dtbs_check error:
['jedec,spi-nor', 's25fl256s1', 's25fl512s'] is too long

Signed-off-by: Li Yang <leoyang.li@nxp.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 9d8f0c2a8aba3..aca78b5eddf20 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -251,7 +251,7 @@
 
 	flash@0 {
 		/* Rev. A uses 64MB flash, Rev. B & C use 32MB flash */
-		compatible = "jedec,spi-nor", "s25fl256s1", "s25fl512s";
+		compatible = "jedec,spi-nor";
 		spi-max-frequency = <20000000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
2.33.0

