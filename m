Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACAE333E5F
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhCJN0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:26:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233277AbhCJNZQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 009E965022;
        Wed, 10 Mar 2021 13:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382716;
        bh=pyrNr/1dmh2uiwmM1FGlbXOji6cGAJEDA4nJJNjy2NU=;
        h=From:To:Cc:Subject:Date:From;
        b=icthX1z/Zavem/9uKoaIEITs7jW/1RgvnGRxv01Vq/LMzoX8LayH7xRple8maZJHV
         zdo9xGlixcYWU4hT9LcKonLHkoyhSwhIkmjqMXKZEiFIi6HWIsJ6OnCCbrgPsG5j2B
         5sOLk9avnWd+GpV2nm9z+OM7iaLevjH1DUHPfdWk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.9 00/11] 4.9.261-rc1 review
Date:   Wed, 10 Mar 2021 14:24:59 +0100
Message-Id: <20210310132320.393957501@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.261-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.261-rc1
X-KernelTest-Deadline: 2021-03-12T13:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 4.9.261 release.
There are 11 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.261-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.261-rc1

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add new force_caps module parameter

Andrey Ryabinin <arbn@yandex-team.com>
    iommu/amd: Fix sleeping in atomic in increase_address_space()

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix DAX iterate_devices based device capability checks

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix iterate_devices based device capability checks

Dan Carpenter <dan.carpenter@oracle.com>
    rsxx: Return -EFAULT if copy_to_user() fails

Colin Ian King <colin.king@canonical.com>
    ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits

Antonio Borneo <borneo.antonio@gmail.com>
    usbip: tools: fix build error for multiple definition

Ira Weiny <ira.weiny@intel.com>
    btrfs: fix raid6 qstripe kmap

David Sterba <dsterba@suse.com>
    btrfs: raid56: simplify tracking of Q stripe presence


-------------

Diffstat:

 Makefile                                   |  4 +-
 drivers/block/rsxx/core.c                  |  8 ++-
 drivers/iommu/amd_iommu.c                  | 10 ++--
 drivers/md/dm-table.c                      | 91 +++++++++++++++++++-----------
 drivers/misc/eeprom/eeprom_93xx46.c        | 15 +++++
 drivers/pci/quirks.c                       |  3 +
 drivers/platform/x86/acer-wmi.c            |  8 ++-
 fs/btrfs/raid56.c                          | 58 ++++++++-----------
 include/linux/eeprom_93xx46.h              |  2 +
 sound/pci/ctxfi/cthw20k2.c                 |  2 +-
 tools/usb/usbip/libsrc/usbip_host_common.c |  2 +-
 11 files changed, 124 insertions(+), 79 deletions(-)


