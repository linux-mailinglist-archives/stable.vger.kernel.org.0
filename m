Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E633373D7
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhCKN2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233450AbhCKN2A (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:28:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8513A64E22;
        Thu, 11 Mar 2021 13:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615469280;
        bh=uXrbDE2EzEKkej7JaHPfuGFYRbX7EHtw5G4XbWhZ2Fs=;
        h=From:To:Cc:Subject:Date:From;
        b=BovVGDvpfHyV7i/VsJm7nsvvvnaTFADNSXBCuDfYUEhgm0dJJZmhDSbP/MIM2DJnX
         7QomfavWalFFiuj80RKBz2XoNH9J6jtKAWT9hITdCBArhIn234Xx7iSnvfOMgxltX8
         ws9OSy0O9Gfy2qKb9yo0bH6KZDLovR0lC9dEX5Mg=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.225
Date:   Thu, 11 Mar 2021 14:27:54 +0100
Message-Id: <1615469274239120@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 4.14.225 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 
 drivers/base/power/runtime.c                |   62 ++++++----
 drivers/block/rsxx/core.c                   |    8 -
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c       |    2 
 drivers/iommu/amd_iommu.c                   |   10 -
 drivers/md/dm-table.c                       |  168 +++++++++++----------------
 drivers/misc/eeprom/eeprom_93xx46.c         |   15 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c |   18 ++
 drivers/net/wireless/marvell/mwifiex/pcie.h |    2 
 drivers/pci/quirks.c                        |    3 
 drivers/platform/x86/acer-wmi.c             |  169 +++++++++++++++++++++++-----
 fs/btrfs/raid56.c                           |   58 ++++-----
 include/linux/eeprom_93xx46.h               |    2 
 sound/pci/ctxfi/cthw20k2.c                  |    2 
 tools/usb/usbip/libsrc/usbip_host_common.c  |    2 
 15 files changed, 325 insertions(+), 198 deletions(-)

Andrey Ryabinin (1):
      iommu/amd: Fix sleeping in atomic in increase_address_space()

AngeloGioacchino Del Regno (1):
      drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Antonio Borneo (1):
      usbip: tools: fix build error for multiple definition

Aswath Govindraju (1):
      misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Bjorn Helgaas (1):
      PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Colin Ian King (1):
      ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Dan Carpenter (1):
      rsxx: Return -EFAULT if copy_to_user() fails

David Sterba (1):
      btrfs: raid56: simplify tracking of Q stripe presence

Greg Kroah-Hartman (1):
      Linux 4.14.225

Hans de Goede (6):
      platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines
      platform/x86: acer-wmi: Cleanup accelerometer device handling
      platform/x86: acer-wmi: Add new force_caps module parameter
      platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag
      platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices
      platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016

Ira Weiny (1):
      btrfs: fix raid6 qstripe kmap

Jeffle Xu (3):
      dm table: fix iterate_devices based device capability checks
      dm table: fix DAX iterate_devices based device capability checks
      dm table: fix zoned iterate_devices based device capability checks

Rafael J. Wysocki (1):
      PM: runtime: Update device status before letting suppliers suspend

Tsuchiya Yuto (1):
      mwifiex: pcie: skip cancel_work_sync() on reset failure path

