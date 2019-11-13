Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BD1FA5CC
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbfKMCZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:25:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbfKMBvt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80ECA204EC;
        Wed, 13 Nov 2019 01:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609909;
        bh=NObG4ppKYgwiPwjuxGjJCTSDOQBfWncIECXrZIt8Aws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsBHJC9TOV/0Gb+pTbnSrwRMFAwWEDp7wSBZd4hJ6oiI1VKwo8FjjJRKO1e8TUhGn
         JLp1kogDrkFTnj80cMZLiyCGdmgr1lajHrAcDkTx3BbjyBHjZg5MNXXPiQbCm6hqdG
         rs8iLj6q0zklqa4s2izhke5ZsZ/CC/iZkleePYJA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 060/209] ARM: dts: at91: sama5d2_ptc_ek: fix bootloader env offsets
Date:   Tue, 12 Nov 2019 20:47:56 -0500
Message-Id: <20191113015025.9685-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit f602b4871c5f7ac01d37d8b285ca947ba7613065 ]

The offsets for the bootloader environment and its redundant partition
were inverted. Fix the addresses to match our nand flash map available at:

http://www.at91.com/linux4sam/pub/Linux4SAM/SambaSubsections//demo_nandflash_map_lnx4sam5x.png

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index 3b1baa8605a77..2214bfe7aa205 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -92,13 +92,13 @@
 							reg = <0x40000 0xc0000>;
 						};
 
-						bootloaderenv@0x100000 {
-							label = "bootloader env";
+						bootloaderenvred@0x100000 {
+							label = "bootloader env redundant";
 							reg = <0x100000 0x40000>;
 						};
 
-						bootloaderenvred@0x140000 {
-							label = "bootloader env redundant";
+						bootloaderenv@0x140000 {
+							label = "bootloader env";
 							reg = <0x140000 0x40000>;
 						};
 
-- 
2.20.1

