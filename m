Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBDE106D4E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbfKVK7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbfKVK7C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B133020721;
        Fri, 22 Nov 2019 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420342;
        bh=NObG4ppKYgwiPwjuxGjJCTSDOQBfWncIECXrZIt8Aws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MA2SD5MYYioNdTut1HKdZaVlJAsnx6lsaqM9kI9w1EA1RRaFVJVVl1hnYs/oXrV4W
         bYAAPFjtMUUhHoaG2/in8jP0WX60bs1OtdXWpg/xuPmye3zR/m/dMP1mQSwo+S/5/E
         Nxv2yoi2IihAcEr9GoakRJuEjNnCUhHMEC0oTvaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/220] ARM: dts: at91: sama5d2_ptc_ek: fix bootloader env offsets
Date:   Fri, 22 Nov 2019 11:27:17 +0100
Message-Id: <20191122100917.399704323@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



