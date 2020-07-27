Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B24222F2CA
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgG0OH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgG0OHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:07:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D07A321744;
        Mon, 27 Jul 2020 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858844;
        bh=d0rm8pf1VjIRHQ6IqBMlyRQ1akt8PToj2Jo9IIE3/SE=;
        h=From:To:Cc:Subject:Date:From;
        b=SUitiHQXZNRnTgv294O9Tj2MkJG2JoyPkmryuQ6VSjTz9ReBnrsDd7WmJPM7I5u4n
         ud8o+R8pH25fJfUUvbddqFdXOqey9YytYcnEa6eM1MzvW1iZjpTifB0CcRz9/p98j0
         KeZunKjvg5MJ0omEZto0zEtrQ9S6rxolNIMW0kLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.14 00/64] 4.14.190-rc1 review
Date:   Mon, 27 Jul 2020 16:03:39 +0200
Message-Id: <20200727134911.020675249@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.190-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.190-rc1
X-KernelTest-Deadline: 2020-07-29T13:49+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.14.190 release.
There are 64 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 29 Jul 2020 13:48:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.190-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.190-rc1

Mark O'Donovan <shiftee@posteo.net>
    ath9k: Fix regression with Atheros 9271

Qiujun Huang <hqjagain@gmail.com>
    ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb

John David Anglin <dave.anglin@bell.net>
    parisc: Add atomic64_set_release() define to avoid CPU soft lockups

Michael J. Ruhl <michael.j.ruhl@intel.com>
    io-mapping: indicate mapping failure

Hugh Dickins <hughd@google.com>
    mm/memcg: fix refcount error while moving and swapping

Fangrui Song <maskray@google.com>
    Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross compilation

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    vt: Reject zero-sized screen buffer size.

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: Detect integer underflow at "struct fbcon_ops"->clear_margins.

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250_mtk: Fix high-speed baud rates clamping

Yang Yingliang <yangyingliang@huawei.com>
    serial: 8250: fix null-ptr-deref in serial8250_start_tx()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: ni_6527: fix INSN_CONFIG_DIGITAL_TRIG support

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: addi_apci_1032: check INSN_CONFIG_DIGITAL_TRIG shift

Rustam Kovhaev <rkovhaev@gmail.com>
    staging: wlan-ng: properly check endpoint types

Steve French <stfrench@microsoft.com>
    Revert "cifs: Fix the target file was deleted when rename failed."

Forest Crossman <cyrozap@gmail.com>
    usb: xhci: Fix ASM2142/ASM3142 DMA addressing

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix the failure of bandwidth allocation

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    binder: Don't use mmput() from shrinker function.

Arnd Bergmann <arnd@arndb.de>
    x86: math-emu: Fix up 'cmp' insn for clang ias

Will Deacon <will@kernel.org>
    arm64: Use test_tsk_thread_flag() for checking TIF_SINGLESTEP

Evgeny Novikov <novikov@ispras.ru>
    usb: gadget: udc: gr_udc: fix memleak on error handling path in gr_ep_init()

Ilya Katsnelson <me@0upti.me>
    Input: synaptics - enable InterTouch for ThinkPad X1E 1st gen

Leonid Ravich <Leonid.Ravich@emc.com>
    dmaengine: ioat setting ioat timeout as module parameter

Evgeny Novikov <novikov@ispras.ru>
    hwmon: (aspeed-pwm-tacho) Avoid possible buffer overflow

Marc Kleine-Budde <mkl@pengutronix.de>
    regmap: dev_get_regmap_match(): fix string comparison

leilk.liu <leilk.liu@mediatek.com>
    spi: mediatek: use correct SPI_CFG2_REG MACRO

Merlijn Wajer <merlijn@wizzup.org>
    Input: add `SW_MACHINE_COVER`

Dinghao Liu <dinghao.liu@zju.edu.cn>
    dmaengine: tegra210-adma: Fix runtime PM imbalance on error

Hans de Goede <hdegoede@redhat.com>
    HID: apple: Disable Fn-key key-re-mapping on clone keyboards

Federico Ricchiuto <fed.ricchiuto@gmail.com>
    HID: i2c-hid: add Mediacom FlexBook edge13 to descriptor override

Pi-Hsun Shih <pihsun@chromium.org>
    scripts/decode_stacktrace: strip basepath from all paths

Matthew Howell <matthew.howell@sealevel.com>
    serial: exar: Fix GPIO configuration for Sealevel cards based on XR17V35X

Cong Wang <xiyou.wangcong@gmail.com>
    bonding: check return value of register_netdevice() in bond_newlink()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: always clear ICSAR to avoid side effects

guodeqing <geffrey.guo@huawei.com>
    ipvs: fix the connection sync failed in some cases

Liu Jian <liujian56@huawei.com>
    mlxsw: destroy workqueue when trap_register in mlxsw_emad_init

Taehee Yoo <ap420073@gmail.com>
    bonding: check error value of register_netdevice() immediately

Wang Hai <wanghai38@huawei.com>
    net: smc91x: Fix possible memory leak in smc_drv_probe()

Chen-Yu Tsai <wens@csie.org>
    drm: sun4i: hdmi: Fix inverted HPD result

Sergey Organov <sorganov@gmail.com>
    net: dp83640: fix SIOCSHWTSTAMP to update the struct with actual configuration

George Kennedy <george.kennedy@oracle.com>
    ax88172a: fix ax88172a_unbind() failures

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    hippi: Fix a size used in a 'pci_free_consistent()' in an error handling path

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Fix race when modifying pause settings.

Robbie Ko <robbieko@synology.com>
    btrfs: fix page leaks after failure to lock page for delalloc

Boris Burkov <boris@bur.io>
    btrfs: fix mount failure caused by race with umount

Filipe Manana <fdmanana@suse.com>
    btrfs: fix double free on ulist after backref resolution failure

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Correct RT5670_LDO_SEL_MASK

Takashi Iwai <tiwai@suse.de>
    ALSA: info: Drop WARN_ON() from buffer NULL sanity check

Oleg Nesterov <oleg@redhat.com>
    uprobes: Change handle_swbp() to send SIGTRAP with si_code=SI_KERNEL, to fix GDB regression

Yang Yingliang <yangyingliang@huawei.com>
    IB/umem: fix reference count leak in ib_umem_odp_get()

Vladimir Oltean <olteanv@gmail.com>
    spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours

Olga Kornievskaia <kolga@netapp.com>
    SUNRPC reverting d03727b248d0 ("NFSv4 fix CLOSE not waiting for direct IO compeletion")

Thomas Gleixner <tglx@linutronix.de>
    irqdomain/treewide: Keep firmware node unconditionally allocated

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/i2c/g94-: increase NV_PMGR_DP_AUXCTL_TRANSACTREQ timeout

Tom Rix <trix@redhat.com>
    net: sky2: initialize return of gm_phy_read

Xie He <xie.he.0141@gmail.com>
    drivers/net/wan/lapbether: Fixed the value of hard_header_len

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: update *pos in cpuinfo_op.next

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix __sync_fetch_and_{and,or}_4 declarations

Tom Rix <trix@redhat.com>
    scsi: scsi_transport_spi: Fix function pointer check

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: allow rx of mesh eapol frames with default rx key

Jacky Hu <hengqing.hu@gmail.com>
    pinctrl: amd: fix npins for uart0 in kerncz_groups

Navid Emamdoost <navid.emamdoost@gmail.com>
    gpio: arizona: put pm_runtime in case of failure

Navid Emamdoost <navid.emamdoost@gmail.com>
    gpio: arizona: handle pm_runtime_get_sync failure case


-------------

Diffstat:

 Makefile                                           |  6 +--
 arch/arm64/kernel/debug-monitors.c                 |  4 +-
 arch/parisc/include/asm/atomic.h                   |  2 +
 arch/x86/kernel/apic/io_apic.c                     | 10 ++---
 arch/x86/kernel/apic/msi.c                         | 16 ++++---
 arch/x86/kernel/apic/vector.c                      |  1 -
 arch/x86/math-emu/wm_sqrt.S                        |  2 +-
 arch/x86/platform/uv/uv_irq.c                      |  3 +-
 arch/xtensa/kernel/setup.c                         |  3 +-
 arch/xtensa/kernel/xtensa_ksyms.c                  |  4 +-
 drivers/android/binder_alloc.c                     |  2 +-
 drivers/base/regmap/regmap.c                       |  2 +-
 drivers/dma/ioat/dma.c                             | 12 +++++
 drivers/dma/ioat/dma.h                             |  2 -
 drivers/dma/tegra210-adma.c                        |  5 ++-
 drivers/gpio/gpio-arizona.c                        |  7 ++-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxg94.c   |  4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/i2c/auxgm200.c |  4 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_enc.c             |  2 +-
 drivers/hid/hid-apple.c                            | 18 ++++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  8 ++++
 drivers/hwmon/aspeed-pwm-tacho.c                   |  2 +
 drivers/i2c/busses/i2c-rcar.c                      |  3 ++
 drivers/infiniband/core/umem_odp.c                 |  3 +-
 drivers/input/mouse/synaptics.c                    |  1 +
 drivers/iommu/amd_iommu.c                          |  5 ++-
 drivers/iommu/intel_irq_remapping.c                |  2 +-
 drivers/net/bonding/bond_main.c                    | 10 +++--
 drivers/net/bonding/bond_netlink.c                 |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  5 ++-
 drivers/net/ethernet/marvell/sky2.c                |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  3 +-
 drivers/net/ethernet/smsc/smc91x.c                 |  4 +-
 drivers/net/hippi/rrunner.c                        |  2 +-
 drivers/net/phy/dp83640.c                          |  4 ++
 drivers/net/usb/ax88172a.c                         |  1 +
 drivers/net/wan/lapbether.c                        |  9 +++-
 drivers/net/wireless/ath/ath9k/hif_usb.c           | 52 +++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/hif_usb.h           |  5 +++
 drivers/pci/host/vmd.c                             |  5 ++-
 drivers/pinctrl/pinctrl-amd.h                      |  2 +-
 drivers/scsi/scsi_transport_spi.c                  |  2 +-
 drivers/spi/spi-fsl-dspi.c                         |  4 +-
 drivers/spi/spi-mt65xx.c                           | 15 ++++---
 drivers/staging/comedi/drivers/addi_apci_1032.c    | 20 ++++++---
 drivers/staging/comedi/drivers/addi_apci_1500.c    | 24 +++++++---
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 20 ++++++---
 drivers/staging/comedi/drivers/ni_6527.c           |  2 +-
 drivers/staging/wlan-ng/prism2usb.c                | 16 ++++++-
 drivers/tty/serial/8250/8250_core.c                |  2 +-
 drivers/tty/serial/8250/8250_exar.c                | 12 ++++-
 drivers/tty/serial/8250/8250_mtk.c                 | 18 ++++++++
 drivers/tty/vt/vt.c                                | 29 +++++++-----
 drivers/usb/gadget/udc/gr_udc.c                    |  7 ++-
 drivers/usb/host/xhci-mtk-sch.c                    |  4 ++
 drivers/usb/host/xhci-pci.c                        |  3 ++
 drivers/video/fbdev/core/bitblit.c                 |  4 +-
 drivers/video/fbdev/core/fbcon_ccw.c               |  4 +-
 drivers/video/fbdev/core/fbcon_cw.c                |  4 +-
 drivers/video/fbdev/core/fbcon_ud.c                |  4 +-
 fs/btrfs/backref.c                                 |  1 +
 fs/btrfs/extent_io.c                               |  3 +-
 fs/btrfs/volumes.c                                 |  8 ++++
 fs/cifs/inode.c                                    | 10 +----
 fs/nfs/direct.c                                    | 13 ++----
 fs/nfs/file.c                                      |  1 -
 include/linux/io-mapping.h                         |  5 ++-
 include/linux/mod_devicetable.h                    |  2 +-
 include/uapi/linux/input-event-codes.h             |  3 +-
 kernel/events/uprobes.c                            |  2 +-
 mm/memcontrol.c                                    |  4 +-
 net/mac80211/rx.c                                  | 26 +++++++++++
 net/netfilter/ipvs/ip_vs_sync.c                    | 12 +++--
 scripts/decode_stacktrace.sh                       |  4 +-
 sound/core/info.c                                  |  4 +-
 sound/soc/codecs/rt5670.h                          |  2 +-
 76 files changed, 387 insertions(+), 147 deletions(-)


