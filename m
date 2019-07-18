Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9E86C57F
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389822AbfGRDHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390286AbfGRDGr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:06:47 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EF4A2053B;
        Thu, 18 Jul 2019 03:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419205;
        bh=Yjc7wMInJmC59RzwyYhjyKlyMR4XAq65Y6OexQiEM6c=;
        h=From:To:Cc:Subject:Date:From;
        b=auK1DNSWJ0+qheGDMT6Og+7w6WF8mVSpTnSyvSDMbG1yoSqYhMIF3KadC4hmUjuBV
         fXODa/K5DxIkgaCpU9iRPpeR/zqW0a0NaxvZ7XYik6j1gvbVam4XM03r88h9krr9KH
         7Lonu9G2F499pGK2waG4U0mqSUsOzZML1y3ZsIi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/47] 4.19.60-stable review
Date:   Thu, 18 Jul 2019 12:01:14 +0900
Message-Id: <20190718030045.780672747@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.60-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.60-rc1
X-KernelTest-Deadline: 2019-07-20T03:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.60 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.60-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.60-rc1

Jiri Slaby <jslaby@suse.cz>
    x86/entry/32: Fix ENDPROC of common_spurious

Dave Airlie <airlied@redhat.com>
    drm/udl: move to embedding drm device inside udl device.

Thomas Zimmermann <tzimmermann@suse.de>
    drm/udl: Replace drm_dev_unref with drm_dev_put

Dave Airlie <airlied@redhat.com>
    drm/udl: introduce a macro to convert dev to udl.

Mark Zhang <markz@nvidia.com>
    regmap-irq: do not write mask register if mask_base is zero

Haren Myneni <haren@linux.vnet.ibm.com>
    crypto/NX: Set receive window credits to max number of CRBs in RxFIFO

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - fix hash on SEC1.

Christophe Leroy <christophe.leroy@c-s.fr>
    crypto: talitos - move struct talitos_edesc into talitos.h

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: (re-)initialize tiqdio list entries

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390: fix stfle zero padding

Arnd Bergmann <arnd@arndb.de>
    ARC: hide unused function unw_hdr_alloc

Thomas Gleixner <tglx@linutronix.de>
    x86/irq: Seperate unused system vectors from spurious entry again

Thomas Gleixner <tglx@linutronix.de>
    x86/irq: Handle spurious interrupt after shutdown gracefully

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Implement irq_get_irqchip_state() callback

Thomas Gleixner <tglx@linutronix.de>
    genirq: Add optional hardware synchronization for shutdown

Thomas Gleixner <tglx@linutronix.de>
    genirq: Fix misleading synchronize_irq() documentation

Thomas Gleixner <tglx@linutronix.de>
    genirq: Delay deactivation in free_irq()

Vinod Koul <vkoul@kernel.org>
    linux/kernel.h: fix overflow for DIV_ROUND_UP_ULL

Nicolas Boichat <drinkcat@chromium.org>
    pinctrl: mediatek: Update cur_mask in mask/mask ops

Eiichi Tsukata <devel@etsukata.com>
    cpu/hotplug: Fix out-of-bounds read when setting fail state

Nicolas Boichat <drinkcat@chromium.org>
    pinctrl: mediatek: Ignore interrupts that are wake only during resume

Kai-Heng Feng <kai.heng.feng@canonical.com>
    HID: multitouch: Add pointstick support for ALPS Touchpad

Oleksandr Natalenko <oleksandr@redhat.com>
    HID: chicony: add another quirk for PixArt mouse

Kirill A. Shutemov <kirill@shutemov.name>
    x86/boot/64: Add missing fixup_pointer() for next_early_pgt access

Kirill A. Shutemov <kirill@shutemov.name>
    x86/boot/64: Fix crash if kernel image crosses page table boundary

Milan Broz <gmazyland@gmail.com>
    dm verity: use message limit for data block corruption message

Jerome Marchand <jmarchan@redhat.com>
    dm table: don't copy from a NULL pointer in realloc_argv()

Phil Reid <preid@electromag.com.au>
    pinctrl: mcp23s08: Fix add_data and irqchip_add_nested call order

Sébastien Szymanski <sebastien.szymanski@armadeus.com>
    ARM: dts: imx6ul: fix PWM[1-4] interrupts

Sergej Benilov <sergej.benilov@googlemail.com>
    sis900: fix TX completion

Takashi Iwai <tiwai@suse.de>
    ppp: mppe: Add softdep to arc4

Petr Oros <poros@redhat.com>
    be2net: fix link failure after ethtool offline test

Colin Ian King <colin.king@canonical.com>
    x86/apic: Fix integer overflow on 10 bit left shift of cpu_khz

David Howells <dhowells@redhat.com>
    afs: Fix uninitialised spinlock afs_volume::cb_break_lock

Arnd Bergmann <arnd@arndb.de>
    ARM: omap2: remove incorrect __init annotation

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: gemini Fix up DNS-313 compatible string

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix perf_sample_regs_user() mm check

Hans de Goede <hdegoede@redhat.com>
    efi/bgrt: Drop BGRT status field reserved bits check

Tony Lindgren <tony@atomide.com>
    clk: ti: clkctrl: Fix returning uninitialized data

Heyi Guo <guoheyi@huawei.com>
    irqchip/gic-v3-its: Fix command queue pointer comparison bug

Sven Van Asbroeck <thesven73@gmail.com>
    firmware: improve LSM/IMA security behaviour

James Morse <james.morse@arm.com>
    drivers: base: cacheinfo: Ensure cpu hotplug work is done before Intel RDT

Masahiro Yamada <yamada.masahiro@socionext.com>
    nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi header

Cole Rogers <colerogers@disroot.org>
    Input: synaptics - enable SMBUS on T480 thinkpad trackpad

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    e1000e: start network tx queue only when link is up

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    Revert "e1000e: fix cyclic resets at link up with active tx"


-------------

Diffstat:

 Makefile                                       |  4 +-
 arch/arc/kernel/unwind.c                       |  9 ++-
 arch/arm/boot/dts/gemini-dlink-dns-313.dts     |  2 +-
 arch/arm/boot/dts/imx6ul.dtsi                  |  8 +--
 arch/arm/mach-omap2/prm3xxx.c                  |  2 +-
 arch/s390/include/asm/facility.h               | 21 ++++--
 arch/x86/entry/entry_32.S                      | 24 +++++++
 arch/x86/entry/entry_64.S                      | 30 ++++++--
 arch/x86/include/asm/hw_irq.h                  |  5 +-
 arch/x86/kernel/apic/apic.c                    | 36 ++++++----
 arch/x86/kernel/apic/io_apic.c                 | 46 ++++++++++++
 arch/x86/kernel/apic/vector.c                  |  4 +-
 arch/x86/kernel/head64.c                       | 20 +++---
 arch/x86/kernel/idt.c                          |  3 +-
 arch/x86/kernel/irq.c                          |  2 +-
 drivers/base/cacheinfo.c                       |  3 +-
 drivers/base/firmware_loader/fallback.c        |  2 +-
 drivers/base/regmap/regmap-irq.c               |  6 ++
 drivers/clk/ti/clkctrl.c                       |  7 +-
 drivers/crypto/nx/nx-842-powernv.c             |  8 ++-
 drivers/crypto/talitos.c                       | 99 +++++++++++---------------
 drivers/crypto/talitos.h                       | 30 ++++++++
 drivers/firmware/efi/efi-bgrt.c                |  5 --
 drivers/gpu/drm/udl/udl_drv.c                  | 56 ++++++++++++---
 drivers/gpu/drm/udl/udl_drv.h                  |  9 +--
 drivers/gpu/drm/udl/udl_fb.c                   | 12 ++--
 drivers/gpu/drm/udl/udl_gem.c                  |  2 +-
 drivers/gpu/drm/udl/udl_main.c                 | 35 +++------
 drivers/hid/hid-ids.h                          |  2 +
 drivers/hid/hid-multitouch.c                   |  4 ++
 drivers/hid/hid-quirks.c                       |  1 +
 drivers/input/mouse/synaptics.c                |  1 +
 drivers/irqchip/irq-gic-v3-its.c               | 35 ++++++---
 drivers/md/dm-table.c                          |  2 +-
 drivers/md/dm-verity-target.c                  |  4 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 28 ++++++--
 drivers/net/ethernet/intel/e1000e/netdev.c     | 21 +++---
 drivers/net/ethernet/sis/sis900.c              | 16 ++---
 drivers/net/ppp/ppp_mppe.c                     |  1 +
 drivers/pinctrl/mediatek/mtk-eint.c            | 34 +++++----
 drivers/pinctrl/pinctrl-mcp23s08.c             |  8 +--
 drivers/s390/cio/qdio_setup.c                  |  2 +
 drivers/s390/cio/qdio_thinint.c                |  5 +-
 fs/afs/callback.c                              |  4 +-
 fs/afs/internal.h                              |  2 +-
 fs/afs/volume.c                                |  1 +
 include/linux/cpuhotplug.h                     |  1 +
 include/linux/kernel.h                         |  3 +-
 include/uapi/linux/nilfs2_ondisk.h             | 24 +++----
 kernel/cpu.c                                   |  3 +
 kernel/events/core.c                           |  2 +-
 kernel/irq/autoprobe.c                         |  6 +-
 kernel/irq/chip.c                              |  6 ++
 kernel/irq/cpuhotplug.c                        |  2 +-
 kernel/irq/internals.h                         |  5 ++
 kernel/irq/manage.c                            | 88 +++++++++++++++++------
 56 files changed, 534 insertions(+), 267 deletions(-)


