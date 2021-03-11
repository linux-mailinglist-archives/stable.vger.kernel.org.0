Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E483373A9
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhCKNW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 08:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233468AbhCKNWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 08:22:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20C8B64E68;
        Thu, 11 Mar 2021 13:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615468923;
        bh=FD6ZMiswDzIWbkmUuou6+tMWEeEbwlKRh6st/DxFgpQ=;
        h=From:To:Cc:Subject:Date:From;
        b=M1YFNrOgzXeUCUwuwLdWPocWxnGQVlnttJHiGB357Qb0q66gvQYyHISWrA360izFY
         9WyL/P85ydByKxg+fM31DV4Hj+LZpr2hTwUfOlch2aAMbSK4VOa8fPXEs3m4sw8aiW
         mB+oiU8xt5+RRup188UshuHOWK62T2Mro6y0FOIU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.261
Date:   Thu, 11 Mar 2021 14:21:58 +0100
Message-Id: <1615468918183237@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 4.9.261 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 
 drivers/block/rsxx/core.c                  |    8 +-
 drivers/iommu/amd_iommu.c                  |   10 +--
 drivers/md/dm-table.c                      |   91 ++++++++++++++++++-----------
 drivers/misc/eeprom/eeprom_93xx46.c        |   15 ++++
 drivers/pci/quirks.c                       |    3 
 drivers/platform/x86/acer-wmi.c            |    8 ++
 fs/btrfs/raid56.c                          |   58 +++++++-----------
 include/linux/eeprom_93xx46.h              |    2 
 sound/pci/ctxfi/cthw20k2.c                 |    2 
 tools/usb/usbip/libsrc/usbip_host_common.c |    2 
 11 files changed, 123 insertions(+), 78 deletions(-)

Andrey Ryabinin (1):
      iommu/amd: Fix sleeping in atomic in increase_address_space()

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
      Linux 4.9.261

Hans de Goede (1):
      platform/x86: acer-wmi: Add new force_caps module parameter

Ira Weiny (1):
      btrfs: fix raid6 qstripe kmap

Jeffle Xu (2):
      dm table: fix iterate_devices based device capability checks
      dm table: fix DAX iterate_devices based device capability checks

