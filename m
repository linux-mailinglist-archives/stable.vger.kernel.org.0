Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3A814E225
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgA3SrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731062AbgA3SrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C9AB20CC7;
        Thu, 30 Jan 2020 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410023;
        bh=ZgAbJnQqB8T9wgapFXZrn8RVdA0u48nSyqfXHQ8VjPM=;
        h=From:To:Cc:Subject:Date:From;
        b=pyqe45TOC1i5zNlKr4xW3+7uuPkvXwfABtHON6sfU5+30obZwwh1jeR8j6KgtLQMF
         2e9uyBI0XrzJELPkDS4sHhc5l76khEzbYFc1DFP3ikhfIK1o6jxUr88uOUJl8s0CAm
         MrPi4StXMssGEjYb2I+LED5y8vLFZsiGSdAXa890=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/55] 4.19.101-stable review
Date:   Thu, 30 Jan 2020 19:38:41 +0100
Message-Id: <20200130183608.563083888@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.101-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.101-rc1
X-KernelTest-Deadline: 2020-02-01T18:36+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.101 release.
There are 55 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.101-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.101-rc1

Andrew Murray <andrew.murray@arm.com>
    KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

Dave Chinner <dchinner@redhat.com>
    block: fix 32 bit overflow in __blkdev_issue_discard()

Ming Lei <ming.lei@redhat.com>
    block: cleanup __blkdev_issue_discard()

Linus Torvalds <torvalds@linux-foundation.org>
    random: try to actively add entropy rather than passively wait for it

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Use bh_lock_sock in sk_destruct

Johan Hovold <johan@kernel.org>
    rsi: fix non-atomic allocation in completion handler

Johan Hovold <johan@kernel.org>
    rsi: fix memory leak on failed URB submission

Johan Hovold <johan@kernel.org>
    rsi: fix use-after-free on probe errors

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Fix insertion in rq->leaf_cfs_rq_list

Peter Zijlstra <peterz@infradead.org>
    sched/fair: Add tmp_alone_branch assertion

Laura Abbott <labbott@fedoraproject.org>
    usb-storage: Disable UAS on JMicron SATA enclosure

Ben Dooks <ben.dooks@codethink.co.uk>
    ARM: OMAP2+: SmartReflex: add omap_sr_pdata definition

Logan Gunthorpe <logang@deltatee.com>
    iommu/amd: Support multiple PCI DMA aliases in IRQ Remapping

Slawomir Pawlowski <slawomir.pawlowski@intel.com>
    PCI: Add DMA alias quirk for Intel VCA NTB

Pacien TRAN-GIRARD <pacien.trangirard@pacien.net>
    platform/x86: dell-laptop: disable kbd backlight on Inspiron 10xx

Rodrigo Rivas Costa <rodrigorivascosta@gmail.com>
    HID: steam: Fix input device disappearing

Arnd Bergmann <arnd@arndb.de>
    atm: eni: fix uninitialized variable warning

Dmitry Osipenko <digetx@gmail.com>
    gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Krzysztof Kozlowski <krzk@kernel.org>
    net: wan: sdla: Fix cast from pointer to integer of different size

Fenghua Yu <fenghua.yu@intel.com>
    drivers/net/b44: Change to non-atomic bit operations on pwol_mask

wuxu.wu <wuxu.wu@huawei.com>
    spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls

Andreas Kemnade <andreas@kemnade.info>
    watchdog: rn5t618_wdt: fix module aliases

David Engraf <david.engraf@sysgo.com>
    watchdog: max77620_wdt: fix potential build errors

Tony Lindgren <tony@atomide.com>
    phy: cpcap-usb: Prevent USB line glitches from waking up modem

Bjorn Andersson <bjorn.andersson@linaro.org>
    phy: qcom-qmp: Increase PHY ready timeout

Pan Zhang <zhangpan26@huawei.com>
    drivers/hid/hid-multitouch.c: fix a possible null pointer access.

Pavel Balan <admin@kryma.net>
    HID: Add quirk for incorrect input length on Lenovo Y720

Hans de Goede <hdegoede@redhat.com>
    HID: ite: Add USB id match for Acer SW5-012 keyboard dock

Priit Laes <plaes@plaes.org>
    HID: Add quirk for Xin-Mo Dual Controller

Randy Dunlap <rdunlap@infradead.org>
    arc: eznps: fix allmodconfig kconfig warning

Aaron Ma <aaron.ma@canonical.com>
    HID: multitouch: Add LG MELF0410 I2C touchscreen support

Cong Wang <xiyou.wangcong@gmail.com>
    net_sched: fix ops->bind_class() implementations

Eric Dumazet <edumazet@google.com>
    net_sched: ematch: reject invalid TCF_EM_SIMPLE

Johan Hovold <johan@kernel.org>
    zd1211rw: fix storage endpoint lookup

Johan Hovold <johan@kernel.org>
    rtl8xxxu: fix interface sanity check

Johan Hovold <johan@kernel.org>
    brcmfmac: fix interface sanity check

Johan Hovold <johan@kernel.org>
    ath9k: fix storage endpoint lookup

Paulo Alcantara (SUSE) <pc@cjr.nz>
    cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Eric Biggers <ebiggers@google.com>
    crypto: chelsio - fix writing tfm flags to wrong place

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: st_gyro: Correct data for LSM9DS0 gyro

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: add comet point (lake) H device ids

Lubomir Rintel <lkundrak@v3.sk>
    component: do not dereference opaque pointer in debugfs

Lukas Wunner <lukas@wunner.de>
    serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: Fix false Tx excessive retries reporting.

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: use NULLFUCTION stack on mac80211

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: correct packet types for CTS protect, mode.

Colin Ian King <colin.king@canonical.com>
    staging: wlan-ng: ensure error return is actually returned

Andrey Shvetsov <andrey.shvetsov@k2l.de>
    staging: most: net: fix buffer overflow

Bin Liu <b-liu@ti.com>
    usb: dwc3: turn off VBUS when leaving host mode

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix IrLAP framing

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: fix link-speed handling

Johan Hovold <johan@kernel.org>
    USB: serial: ir-usb: add missing endpoint sanity check

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: pci: add ID for the Intel Comet Lake -V variant

Johan Hovold <johan@kernel.org>
    rsi_91x_usb: fix interface sanity check

Johan Hovold <johan@kernel.org>
    orinoco_usb: fix interface sanity check


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/plat-eznps/Kconfig                        |   2 +-
 arch/arm64/kvm/debug.c                             |   6 +-
 block/blk-lib.c                                    |  23 +---
 crypto/af_alg.c                                    |   6 +-
 drivers/atm/eni.c                                  |   4 +-
 drivers/base/component.c                           |   8 +-
 drivers/char/random.c                              |  62 ++++++++-
 drivers/crypto/chelsio/chcr_algo.c                 |  16 +--
 drivers/gpio/Kconfig                               |   1 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-ite.c                              |   3 +
 drivers/hid/hid-multitouch.c                       |   5 +-
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/hid-steam.c                            |   4 +
 drivers/hid/i2c-hid/i2c-hid-core.c                 |  16 ++-
 drivers/iio/gyro/st_gyro_core.c                    |  75 +++++++++-
 drivers/iommu/amd_iommu.c                          |  37 ++++-
 drivers/misc/mei/hw-me-regs.h                      |   4 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/net/ethernet/broadcom/b44.c                |   9 +-
 drivers/net/wan/sdla.c                             |   2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   4 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   4 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  12 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  19 +--
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   2 +-
 drivers/pci/quirks.c                               |  34 +++++
 drivers/phy/motorola/phy-cpcap-usb.c               |  18 ++-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |   2 +-
 drivers/platform/x86/dell-laptop.c                 |  26 ++++
 drivers/spi/spi-dw.c                               |  15 +-
 drivers/spi/spi-dw.h                               |   1 +
 drivers/staging/most/net/net.c                     |  10 ++
 drivers/staging/vt6656/device.h                    |   2 +
 drivers/staging/vt6656/int.c                       |   6 +-
 drivers/staging/vt6656/main_usb.c                  |   1 +
 drivers/staging/vt6656/rxtx.c                      |  26 ++--
 drivers/staging/wlan-ng/prism2mgmt.c               |   2 +-
 drivers/tty/serial/8250/8250_bcm2835aux.c          |   2 +-
 drivers/usb/dwc3/core.c                            |   3 +
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +
 drivers/usb/serial/ir-usb.c                        | 136 +++++++++++++-----
 drivers/usb/storage/unusual_uas.h                  |   7 +-
 drivers/watchdog/Kconfig                           |   1 +
 drivers/watchdog/rn5t618_wdt.c                     |   1 +
 fs/cifs/smb2misc.c                                 |   2 +-
 include/linux/power/smartreflex.h                  |   3 +
 include/linux/usb/irda.h                           |  13 +-
 include/net/pkt_cls.h                              |  33 +++--
 include/net/sch_generic.h                          |   3 +-
 kernel/sched/fair.c                                | 153 +++++++++++++--------
 net/sched/cls_basic.c                              |  11 +-
 net/sched/cls_bpf.c                                |  11 +-
 net/sched/cls_flower.c                             |  11 +-
 net/sched/cls_fw.c                                 |  11 +-
 net/sched/cls_matchall.c                           |  11 +-
 net/sched/cls_route.c                              |  11 +-
 net/sched/cls_rsvp.h                               |  11 +-
 net/sched/cls_tcindex.c                            |  11 +-
 net/sched/cls_u32.c                                |  11 +-
 net/sched/ematch.c                                 |   3 +
 net/sched/sch_api.c                                |   6 +-
 65 files changed, 710 insertions(+), 240 deletions(-)


