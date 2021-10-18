Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC9431E3A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhJRN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhJRN5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E1E6136F;
        Mon, 18 Oct 2021 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564452;
        bh=55U3LlrO4w7xet1pLUzha3h7GlalIhkOLUH2mdmmPIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/qR5wcECxUIghNFva/ho88EJ36fMWbE2XudD93M2kEKarhYGHnk5ALqNTj0WjmpA
         8UA5bidMX9HxOg1x7M49xFnu2TlOHArvARhQ7xcCBc/j1fvHISJLhiDuc5n4E5T6wV
         IMbyu7CvioTre/jHlqgEn9eoi9acONZ8PFMl5S/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>
Subject: [PATCH 5.14 094/151] ARM: dts: bcm2711-rpi-4-b: fix sd_io_1v8_reg regulator states
Date:   Mon, 18 Oct 2021 15:24:33 +0200
Message-Id: <20211018132343.735312940@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit b55ec7528879a822a4d350248daa04bbb27f25fd upstream.

DT schema check complains at sd_io_1v8_reg about the following:

 [1800000, 1, 3300000, 0] is too long
 Additional items are not allowed (3300000, 0 were unexpected)

So fix the states definition.

Fixes: 7dbe8c62ceeb ("ARM: dts: Add minimal Raspberry Pi 4 support")
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1628334401-6577-3-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-4-b.dts
@@ -40,8 +40,8 @@
 		regulator-always-on;
 		regulator-settling-time-us = <5000>;
 		gpios = <&expgpio 4 GPIO_ACTIVE_HIGH>;
-		states = <1800000 0x1
-			  3300000 0x0>;
+		states = <1800000 0x1>,
+			 <3300000 0x0>;
 		status = "okay";
 	};
 


