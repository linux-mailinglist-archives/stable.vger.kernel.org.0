Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541E2333E2E
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhCJNZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233183AbhCJNZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 453F664FFD;
        Wed, 10 Mar 2021 13:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382702;
        bh=zJKt1BxN9mBneiEwI3ScoYkRpOBSH347dIjQIQ5Ltbo=;
        h=From:To:Cc:Subject:Date:From;
        b=p5uOYJSo/GqaMloLdMnGOWyOB1l4C+uj6pAwnq69e7B6nr7qoIfbAFRpk8g4Hmoll
         bVJt+l6vz2dUjIbEXHS7cIiYWwMCBgOVjDXqj2uf72PJ+V5dLzCcb6T8pti5B4qq3Y
         i6ncwgd1+7GQhFRkP5uXxRHZnaKLTVGxA+YrkM90=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.14 00/20] 4.14.225-rc1 review
Date:   Wed, 10 Mar 2021 14:24:37 +0100
Message-Id: <20210310132320.512307035@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.225-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.225-rc1
X-KernelTest-Deadline: 2021-03-12T13:23+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 4.14.225 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.225-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.225-rc1

AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
    drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register

Aswath Govindraju <a-govindraju@ti.com>
    misc: eeprom_93xx46: Add quirk to support Microchip 93LC46B eeprom

Bjorn Helgaas <bhelgaas@google.com>
    PCI: Add function 1 DMA alias quirk for Marvell 9215 SATA controller

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add ACER_CAP_KBD_DOCK quirk for the Aspire Switch 10E SW3-016

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Add new force_caps module parameter

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Cleanup accelerometer device handling

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Cleanup ACER_CAP_FOO defines

Tsuchiya Yuto <kitakar@gmail.com>
    mwifiex: pcie: skip cancel_work_sync() on reset failure path

Andrey Ryabinin <arbn@yandex-team.com>
    iommu/amd: Fix sleeping in atomic in increase_address_space()

Jeffle Xu <jefflexu@linux.alibaba.com>
    dm table: fix zoned iterate_devices based device capability checks

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Update device status before letting suppliers suspend

Ira Weiny <ira.weiny@intel.com>
    btrfs: fix raid6 qstripe kmap

David Sterba <dsterba@suse.com>
    btrfs: raid56: simplify tracking of Q stripe presence


-------------

Diffstat:

 Makefile                                    |   4 +-
 drivers/base/power/runtime.c                |  62 ++++++----
 drivers/block/rsxx/core.c                   |   8 +-
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c       |   2 -
 drivers/iommu/amd_iommu.c                   |  10 +-
 drivers/md/dm-table.c                       | 168 ++++++++++++---------------
 drivers/misc/eeprom/eeprom_93xx46.c         |  15 +++
 drivers/net/wireless/marvell/mwifiex/pcie.c |  18 ++-
 drivers/net/wireless/marvell/mwifiex/pcie.h |   2 +
 drivers/pci/quirks.c                        |   3 +
 drivers/platform/x86/acer-wmi.c             | 169 +++++++++++++++++++++++-----
 fs/btrfs/raid56.c                           |  58 ++++------
 include/linux/eeprom_93xx46.h               |   2 +
 sound/pci/ctxfi/cthw20k2.c                  |   2 +-
 tools/usb/usbip/libsrc/usbip_host_common.c  |   2 +-
 15 files changed, 326 insertions(+), 199 deletions(-)


