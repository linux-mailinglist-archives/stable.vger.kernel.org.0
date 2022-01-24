Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E04649955E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392630AbiAXUvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41496 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391087AbiAXUq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AED5260B0B;
        Mon, 24 Jan 2022 20:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98320C340E5;
        Mon, 24 Jan 2022 20:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057216;
        bh=C0ltC4XK+lzZpfHNcWz3++UuYMDZj12sv+fI4U1loHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzN8GWKkfW4KYsFWbIA/Ck/rzlktmirVQVHaRdpsNgOBm85QODo4wwWqpNkXwx4Ve
         TVqmkHBCgE2VFvt2MsVMk9wDxkpheSfL6S7172mf/lHHYVy2GskrTwq+4hUVNVCcA0
         G4IUTREAVuM8hELBO5rbQe0vowiAwvzPf/xbCoSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.15 739/846] Documentation, arch: Remove leftovers from raw device
Date:   Mon, 24 Jan 2022 19:44:16 +0100
Message-Id: <20220124184126.481611657@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexandre.ghiti@canonical.com>

commit 473dcf0ffc31ce1135cd10578e7e06698cf51f4a upstream.

Raw device interface was removed so remove all references to configs
related to it.

Fixes: 603e4922f1c8 ("remove the raw driver")
Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Acked-by: Arnd Bergmann <arnd@arndb.de> [arch/arm/configs]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/devices.txt  |    8 +-------
 arch/arm/configs/spear13xx_defconfig   |    1 -
 arch/arm/configs/spear3xx_defconfig    |    1 -
 arch/arm/configs/spear6xx_defconfig    |    1 -
 arch/powerpc/configs/pseries_defconfig |    1 -
 5 files changed, 1 insertion(+), 11 deletions(-)

--- a/Documentation/admin-guide/devices.txt
+++ b/Documentation/admin-guide/devices.txt
@@ -2339,13 +2339,7 @@
 		disks (see major number 3) except that the limit on
 		partitions is 31.
 
- 162 char	Raw block device interface
-		  0 = /dev/rawctl	Raw I/O control device
-		  1 = /dev/raw/raw1	First raw I/O device
-		  2 = /dev/raw/raw2	Second raw I/O device
-		    ...
-		 max minor number of raw device is set by kernel config
-		 MAX_RAW_DEVS or raw module parameter 'max_raw_devs'
+ 162 char	Used for (now removed) raw block device interface
 
  163 char
 
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -61,7 +61,6 @@ CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
 CONFIG_I2C=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
--- a/arch/arm/configs/spear3xx_defconfig
+++ b/arch/arm/configs/spear3xx_defconfig
@@ -41,7 +41,6 @@ CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 # CONFIG_HW_RANDOM is not set
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
 CONFIG_I2C=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
--- a/arch/arm/configs/spear6xx_defconfig
+++ b/arch/arm/configs/spear6xx_defconfig
@@ -36,7 +36,6 @@ CONFIG_INPUT_FF_MEMLESS=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=8192
 CONFIG_I2C=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_SPI=y
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -190,7 +190,6 @@ CONFIG_HVCS=m
 CONFIG_VIRTIO_CONSOLE=m
 CONFIG_IBM_BSR=m
 CONFIG_RAW_DRIVER=y
-CONFIG_MAX_RAW_DEVS=1024
 CONFIG_I2C_CHARDEV=y
 CONFIG_FB=y
 CONFIG_FIRMWARE_EDID=y


