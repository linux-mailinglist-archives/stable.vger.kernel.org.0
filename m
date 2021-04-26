Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3636AD15
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhDZHcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232391AbhDZHcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EED661004;
        Mon, 26 Apr 2021 07:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422296;
        bh=4He84xCzeAoiP8FacCYojzef9fGnZKlYE65DEDPsKRE=;
        h=From:To:Cc:Subject:Date:From;
        b=tbxWumEYmGRpyZU2LLLh1GdV084NxiqTOz962oxVu6LiLnVU9JDaUR+Xp8gjVGTGZ
         vz+kY9Z+7HAKWD7Ouzp42rvrTA/tSTZPoXSkD0LUAqGhnBdBHZGdQDvj3Q+KT5DMBk
         Kf0IfHUSmuBaVdPL8WWmUk3bjNwrOiXvcVrn8MKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 4.4 00/32] 4.4.268-rc1 review
Date:   Mon, 26 Apr 2021 09:28:58 +0200
Message-Id: <20210426072816.574319312@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.268-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.268-rc1
X-KernelTest-Deadline: 2021-04-28T07:28+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.268 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.268-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.268-rc1

Mike Galbraith <efault@gmx.de>
    x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Kees Cook <keescook@chromium.org>
    overflow.h: Add allocation size calculation helpers

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    compiler.h: enable builtin overflow checkers and add fallback code

John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    ia64: tools: remove duplicate definition of ia64_mf() on ia64

Randy Dunlap <rdunlap@infradead.org>
    ia64: fix discontig.c section mismatches

Wan Jiabing <wanjiabing@vivo.com>
    cavium/liquidio: Fix duplicate argument

Michael Brown <mbrown@fensystems.co.uk>
    xen-netback: Check for hotplug-status existence before watching

Vasily Gorbik <gor@linux.ibm.com>
    s390/entry: save the caller of psw_idle

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix swapped mmc order for omap3

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct error label in ext4_rename()

Anirudh Rayabharam <mail@anirudhrb.com>
    net: hso: fix null-ptr-deref during tty device unregistration

Fredrik Strupe <fredrik@strupe.net>
    ARM: 9071/1: uprobes: Don't hook on thumb instructions

Jason Xing <xingwanli@kuaishou.com>
    i40e: fix the panic when running bpf in xdpdrv mode

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: davicom: Fix regulator not turned off on failed probe

Jolly Shah <jollys@google.com>
    scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Arnd Bergmann <arnd@arndb.de>
    Input: i8042 - fix Pegatron C15B ID entry

Guenter Roeck <linux@roeck-us.net>
    pcnet32: Use pci_resource_len to validate PCI resource

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec seclevel

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec seclevels for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec devkey

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec devkeys for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: forbid monitor for add llsec dev

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec devs for monitors

Alexander Aring <aahringo@redhat.com>
    net: ieee802154: stop dump llsec keys for monitors

Alexander Shiyan <shc_work@mail.ru>
    ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Arnd Bergmann <arnd@arndb.de>
    ARM: keystone: fix integer overflow warning

Tong Zhu <zhutong@amazon.com>
    neighbour: Disregard DEAD dst in neigh_update

Wang Qing <wangqing@vivo.com>
    arc: kernel: Return -EFAULT if copy_to_user() fails

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix moving mmc devices with aliases for omap4 & 5

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: Make it dependent to HAS_IOMEM

Fabian Vogt <fabian@ritter-vogt.de>
    Input: nspire-keypad - enable interrupts only when opened

Or Cohen <orcohen@paloaltonetworks.com>
    net/sctp: fix race condition in sctp_destroy_sock


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/signal.c                           |   4 +-
 arch/arm/boot/dts/omap3.dtsi                       |   3 +
 arch/arm/boot/dts/omap4.dtsi                       |   5 +
 arch/arm/boot/dts/omap5.dtsi                       |   5 +
 arch/arm/mach-keystone/keystone.c                  |   4 +-
 arch/arm/probes/uprobes/core.c                     |   4 +-
 arch/ia64/mm/discontig.c                           |   6 +-
 arch/s390/kernel/entry.S                           |   1 +
 arch/x86/kernel/crash.c                            |   3 +-
 drivers/dma/dw/Kconfig                             |   2 +
 drivers/input/keyboard/nspire-keypad.c             |  56 +++--
 drivers/input/serio/i8042-x86ia64io.h              |   1 +
 drivers/md/dm-table.c                              |  10 +-
 drivers/net/ethernet/amd/pcnet32.c                 |   5 +-
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |   2 +-
 drivers/net/ethernet/davicom/dm9000.c              |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   6 +
 drivers/net/usb/hso.c                              |  33 +--
 drivers/net/xen-netback/xenbus.c                   |  12 +-
 drivers/scsi/libsas/sas_ata.c                      |   9 +-
 fs/ext4/namei.c                                    |   2 +-
 include/linux/compiler-clang.h                     |  14 ++
 include/linux/compiler-gcc.h                       |   4 +
 include/linux/compiler-intel.h                     |   4 +
 include/linux/overflow.h                           | 278 +++++++++++++++++++++
 net/core/neighbour.c                               |   2 +-
 net/ieee802154/nl802154.c                          |  29 +++
 net/sctp/socket.c                                  |  13 +-
 sound/soc/fsl/fsl_esai.c                           |   8 +-
 tools/arch/ia64/include/asm/barrier.h              |   3 -
 31 files changed, 445 insertions(+), 93 deletions(-)


