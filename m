Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462134988A5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245447AbiAXStJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245338AbiAXSsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:48:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA70C061757;
        Mon, 24 Jan 2022 10:48:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 530BCB8121B;
        Mon, 24 Jan 2022 18:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A1CC340E5;
        Mon, 24 Jan 2022 18:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050129;
        bh=DK0Dj3VYRyVwzaa4T0o1SONPI5s73K8amnDF6ZI4Enc=;
        h=From:To:Cc:Subject:Date:From;
        b=upj4+lfrrsJSHRzDS2xPp/gTXNhQwNm9I/dLGYyyPyDFxdE0RBRJkBY5L3JmKDSeS
         7d5LH3soEHXMFN51wS03EsDRLJDexgpnY0XPDGzodWFzimo9aCGfRq0iF2SGzMi+T6
         Hs87W6gV3Sw202ctqFFsGLj5N5rZJkRQb+85lWio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: [PATCH 4.4 000/114] 4.4.300-rc1 review
Date:   Mon, 24 Jan 2022 19:41:35 +0100
Message-Id: <20220124183927.095545464@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.300-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.300-rc1
X-KernelTest-Deadline: 2022-01-26T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.4.300 release.
There are 114 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.300-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.4.300-rc1

Miaoqian Lin <linmq006@gmail.com>
    lib82596: Fix IRQ check in sni_82596_probe

Sergey Shtylyov <s.shtylyov@omp.ru>
    bcmgenet: add WOL IRQ check

Kevin Bracey <kevin@bracey.fi>
    net_sched: restore "mpu xxx" handling

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Fix lld view setting

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Print debug message after realeasing the lock

Tudor Ambarus <tudor.ambarus@microchip.com>
    dmaengine: at_xdmac: Don't start transactions at tx_submit level

Eric Dumazet <edumazet@google.com>
    netns: add schedule point in ops_exit_list()

Robert Hancock <robert.hancock@calian.com>
    net: axienet: fix number of TX ring slots for available check

Robert Hancock <robert.hancock@calian.com>
    net: axienet: Wait for PhyRstCmplt after core reset

Eric Dumazet <edumazet@google.com>
    af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress

Miaoqian Lin <linmq006@gmail.com>
    parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries

Tobias Waldekranz <tobias@waldekranz.com>
    net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Tobias Waldekranz <tobias@waldekranz.com>
    powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses

Theodore Ts'o <tytso@mit.edu>
    ext4: don't use the orphan list when migrating an inode

Ye Bin <yebin10@huawei.com>
    ext4: Fix BUG_ON in ext4_bread when write quota data

Luís Henriques <lhenriques@suse.de>
    ext4: set csum seed in tmp inode while migrating to extents

Petr Cvachoucek <cvachoucek@gmail.com>
    ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Yauhen Kharuzhy <jekhor@gmail.com>
    power: bq25890: Enable continuous conversion for ADC at charging

Christoph Hellwig <hch@lst.de>
    scsi: sr: Don't use GFP_DMA

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    MIPS: Octeon: Fix build errors using clang

Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
    i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Takashi Iwai <tiwai@suse.de>
    ALSA: seq: Set upper limit of processed events

Christophe Leroy <christophe.leroy@csgroup.eu>
    w1: Misuse of get_user()/put_user() reported by sparse

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    i2c: mpc: Correct I2C reset procedure

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING

Heiner Kallweit <hkallweit1@gmail.com>
    i2c: i801: Don't silently correct invalid transfer size

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/btext: add missing of_node_put

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/cell: add missing of_node_put

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/powernv: add missing of_node_put

Julia Lawall <Julia.Lawall@lip6.fr>
    powerpc/6xx: add missing of_node_put

John David Anglin <dave.anglin@bell.net>
    parisc: Avoid calling faulthandler_disabled() twice

Lukas Wunner <lukas@wunner.de>
    serial: core: Keep mctrl register state and cached copy in sync

Lukas Wunner <lukas@wunner.de>
    serial: pl010: Drop CR register reset on set_termios

Joe Thornber <ejt@redhat.com>
    dm space map common: add bounds check to sm_ll_lookup_bitmap()

Joe Thornber <ejt@redhat.com>
    dm btree: add a defensive bounds check to insert_at()

Florian Fainelli <f.fainelli@gmail.com>
    net: mdio: Demote probed message to debug print

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove BUG_ON(!eie) in find_parent_nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove BUG_ON() in find_parent_nodes()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Utilities: Avoid deleting the same object twice in a row

Randy Dunlap <rdunlap@infradead.org>
    um: registers: Rename function names to avoid conflicts and build problems

Zekun Shen <bruceshenzk@gmail.com>
    ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Kai-Heng Feng <kai.heng.feng@canonical.com>
    usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

Sean Young <sean@mess.org>
    media: igorplugusb: receiver overflow should be reported

Suresh Kumar <surkumar@redhat.com>
    net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: synchronize with FW after multicast commands

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: m920x: don't use stack on USB reads

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()

Xiongwei Song <sxwjean@gmail.com>
    floppy: Add max size check for user space request

Zekun Shen <bruceshenzk@gmail.com>
    mwifiex: Fix skb_over_panic in mwifiex_usb_recv()

Chengfeng Ye <cyeaa@connect.ust.hk>
    HSI: core: Fix return freed object in hsi_new_client

Zheyu Ma <zheyuma97@gmail.com>
    media: b2c2: Add missing check in flexcop_pci_isr:

Pavankumar Kondeti <quic_pkondeti@quicinc.com>
    usb: gadget: f_fs: Use stream_open() for endpoint files

Zekun Shen <bruceshenzk@gmail.com>
    ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply

Alexander Aring <aahringo@redhat.com>
    fs: dlm: filter user dlm messages for kernel locks

Wei Yongjun <weiyongjun1@huawei.com>
    Bluetooth: Fix debugfs entry leak in hci_register_dev()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/cxgb4: Set queue pair state when being queried

Randy Dunlap <rdunlap@infradead.org>
    mips: bcm63xx: add support for clk_set_parent()

Randy Dunlap <rdunlap@infradead.org>
    mips: lantiq: add support for clk_set_parent()

Wei Yongjun <weiyongjun1@huawei.com>
    misc: lattice-ecp3-config: Fix task hung when firmware load failed

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: samsung: idma: Check of ioremap return value

Arnd Bergmann <arnd@arndb.de>
    dmaengine: pxa/mmp: stop referencing config->slave_id

Avihai Horon <avihaih@nvidia.com>
    RDMA/core: Let ib_find_gid() continue search even after empty entry

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    uio: uio_dmem_genirq: Catch the Exception

Kees Cook <keescook@chromium.org>
    char/mwave: Adjust io port register size

Bixuan Cui <cuibixuan@linux.alibaba.com>
    ALSA: oss: fix compile error when OSS_DEBUG is enabled

Peiwei Hu <jlu.hpw@foxmail.com>
    powerpc/prom_init: Fix improper check of prom_getprop()

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Add missing rwsem around snd_ctl_remove() calls

Takashi Iwai <tiwai@suse.de>
    ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls

Takashi Iwai <tiwai@suse.de>
    ALSA: jack: Add missing rwsem around snd_ctl_remove() calls

Jan Kara <jack@suse.cz>
    ext4: avoid trim error on fs with small groups

Pavel Skripkin <paskripkin@gmail.com>
    net: mcs7830: handle usb read errors properly

Dominik Brodowski <linux@dominikbrodowski.net>
    pcmcia: fix setting of kthread task states

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    can: xilinx_can: xcan_probe(): check for error irq

Marc Kleine-Budde <mkl@pengutronix.de>
    can: softing: softing_startstop(): fix set but not used variable warning

Miaoqian Lin <linmq006@gmail.com>
    spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe

Eric Dumazet <edumazet@google.com>
    ppp: ensure minimum packet size in ppp_write()

Zhou Qingyang <zhou1615@umn.edu>
    pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()

Zhou Qingyang <zhou1615@umn.edu>
    pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()

Wei Yongjun <weiyongjun1@huawei.com>
    usb: ftdi-elan: fix memory leak on device disconnect

Wang Hai <wanghai38@huawei.com>
    media: msi001: fix possible null-ptr-deref in msi001_probe()

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()

Zhou Qingyang <zhou1615@umn.edu>
    media: dib8000: Fix a memleak in dib8000_init()

Tasos Sahanidis <tasos@tasossah.com>
    floppy: Fix hang in watchdog when disk is ejected

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: amba-pl011: do not request memory region twice

Zhou Qingyang <zhou1615@umn.edu>
    drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8916: fix MMC controller aliases

Florian Westphal <fw@strlen.de>
    netfilter: bridge: add support for pppoe filtering

Tudor Ambarus <tudor.ambarus@microchip.com>
    tty: serial: atmel: Call dma_async_issue_pending()

Tudor Ambarus <tudor.ambarus@microchip.com>
    tty: serial: atmel: Check return code of dmaengine_submit()

Chengfeng Ye <cyeaa@connect.ust.hk>
    crypto: qce - fix uaf on qce_ahash_register_one

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: stop proccessing malicious adv data

Wang Hai <wanghai38@huawei.com>
    Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails

Yifeng Li <tomli@tomli.me>
    PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Johan Hovold <johan@kernel.org>
    can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johan Hovold <johan@kernel.org>
    media: stk1160: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: pvrusb2: fix control-message timeouts

Michael Kuron <michael.kuron@gmail.com>
    media: dib0700: fix undefined behavior in tuner shutdown

Johan Hovold <johan@kernel.org>
    media: em28xx: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: mceusb: fix control-message timeouts

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: take rtc_lock while reading from CMOS

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Jann Horn <jannh@google.com>
    HID: uhid: Fix worker destroying device without any protection

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Johan Hovold <johan@kernel.org>
    media: uvcvideo: fix division by zero at stream start

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Brian Silverman <brian.silverman@bluerivertech.com>
    can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Marc Kleine-Budde <mkl@pengutronix.de>
    can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug in resuming hub's handling of wakeup requests

Johan Hovold <johan@kernel.org>
    Bluetooth: bfusb: fix division by zero in send path


-------------

Diffstat:

 Makefile                                           |  4 +--
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |  4 +--
 arch/mips/bcm63xx/clk.c                            |  6 ++++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |  4 +--
 arch/mips/lantiq/clk.c                             |  6 ++++
 arch/parisc/kernel/traps.c                         |  2 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi      |  2 ++
 arch/powerpc/kernel/btext.c                        |  4 ++-
 arch/powerpc/kernel/prom_init.c                    |  2 +-
 arch/powerpc/kernel/smp.c                          |  2 ++
 arch/powerpc/platforms/cell/iommu.c                |  1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |  1 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |  1 +
 arch/um/include/shared/registers.h                 |  4 +--
 arch/um/os-Linux/registers.c                       |  4 +--
 arch/um/os-Linux/start_up.c                        |  2 +-
 arch/x86/um/syscalls_64.c                          |  3 +-
 drivers/acpi/acpica/exoparg1.c                     |  3 +-
 drivers/acpi/acpica/utdelete.c                     |  1 +
 drivers/block/floppy.c                             |  6 ++--
 drivers/bluetooth/bfusb.c                          |  3 ++
 drivers/char/mwave/3780i.h                         |  2 +-
 drivers/crypto/qce/sha.c                           |  2 +-
 drivers/dma/at_xdmac.c                             | 32 ++++++++++------------
 drivers/dma/mmp_pdma.c                             |  6 ----
 drivers/dma/pxa_dma.c                              |  7 -----
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  6 ++++
 drivers/gpu/drm/i915/intel_pm.c                    |  6 ++--
 drivers/hid/uhid.c                                 | 29 +++++++++++++++++---
 drivers/hsi/hsi.c                                  |  1 +
 drivers/i2c/busses/i2c-designware-pcidrv.c         |  8 +++---
 drivers/i2c/busses/i2c-i801.c                      | 15 ++++------
 drivers/i2c/busses/i2c-mpc.c                       | 23 ++++++++++------
 drivers/infiniband/core/device.c                   |  3 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  1 +
 drivers/md/persistent-data/dm-btree.c              |  8 ++++--
 drivers/md/persistent-data/dm-space-map-common.c   |  5 ++++
 drivers/media/common/saa7146/saa7146_fops.c        |  2 +-
 drivers/media/dvb-frontends/dib8000.c              |  4 ++-
 drivers/media/pci/b2c2/flexcop-pci.c               |  3 ++
 drivers/media/pci/saa7146/hexium_gemini.c          |  7 ++++-
 drivers/media/pci/saa7146/hexium_orion.c           |  8 +++++-
 drivers/media/pci/saa7146/mxb.c                    |  8 +++++-
 drivers/media/rc/igorplugusb.c                     |  4 ++-
 drivers/media/rc/mceusb.c                          |  8 +++---
 drivers/media/tuners/msi001.c                      |  7 +++++
 drivers/media/usb/dvb-usb/dib0700_core.c           |  2 --
 drivers/media/usb/dvb-usb/m920x.c                  | 12 +++++++-
 drivers/media/usb/em28xx/em28xx-core.c             |  4 +--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  8 +++---
 drivers/media/usb/stk1160/stk1160-core.c           |  4 +--
 drivers/media/usb/uvc/uvc_video.c                  |  4 +++
 drivers/mfd/intel-lpss-acpi.c                      |  7 ++++-
 drivers/misc/lattice-ecp3-config.c                 | 12 ++++----
 drivers/net/bonding/bond_main.c                    |  6 ++--
 drivers/net/can/softing/softing_cs.c               |  2 +-
 drivers/net/can/softing/softing_fw.c               | 11 ++++----
 drivers/net/can/usb/gs_usb.c                       |  5 +++-
 drivers/net/can/xilinx_can.c                       |  7 ++++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 10 ++++---
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  3 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |  3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 14 ++++++++--
 drivers/net/phy/mdio_bus.c                         |  2 +-
 drivers/net/ppp/ppp_generic.c                      |  7 ++++-
 drivers/net/usb/mcs7830.c                          | 12 ++++++--
 drivers/net/wireless/ath/ar5523/ar5523.c           |  4 +++
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  7 +++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        | 17 ++++++++++++
 drivers/net/wireless/mwifiex/usb.c                 |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  1 +
 drivers/parisc/pdc_stable.c                        |  4 ++-
 drivers/pci/quirks.c                               |  3 ++
 drivers/pcmcia/cs.c                                |  8 ++----
 drivers/pcmcia/rsrc_nonstatic.c                    |  6 ++++
 drivers/power/bq25890_charger.c                    |  4 +--
 drivers/rtc/rtc-cmos.c                             |  3 ++
 drivers/scsi/sr.c                                  |  2 +-
 drivers/scsi/sr_vendor.c                           |  4 +--
 drivers/spi/spi-meson-spifc.c                      |  1 +
 drivers/tty/serial/amba-pl010.c                    |  3 --
 drivers/tty/serial/amba-pl011.c                    | 27 ++----------------
 drivers/tty/serial/atmel_serial.c                  | 14 ++++++++++
 drivers/tty/serial/serial_core.c                   |  3 +-
 drivers/uio/uio_dmem_genirq.c                      |  6 +++-
 drivers/usb/core/hcd.c                             |  9 +++++-
 drivers/usb/core/hub.c                             |  7 +++--
 drivers/usb/gadget/function/f_fs.c                 |  4 +--
 drivers/usb/misc/ftdi-elan.c                       |  1 +
 drivers/w1/slaves/w1_ds28e04.c                     | 26 ++++--------------
 fs/btrfs/backref.c                                 | 21 +++++++++++---
 fs/dlm/lock.c                                      |  9 ++++++
 fs/ext4/ioctl.c                                    |  2 --
 fs/ext4/mballoc.c                                  |  8 ++++++
 fs/ext4/migrate.c                                  | 23 ++++++++--------
 fs/ext4/super.c                                    |  2 +-
 fs/ubifs/super.c                                   |  1 -
 include/net/sch_generic.h                          |  5 ++++
 net/bluetooth/cmtp/core.c                          |  4 +--
 net/bluetooth/hci_core.c                           |  1 +
 net/bluetooth/hci_event.c                          |  8 +++++-
 net/bridge/br_netfilter_hooks.c                    |  7 ++---
 net/core/net_namespace.c                           |  4 ++-
 net/nfc/llcp_sock.c                                |  5 ++++
 net/sched/sch_generic.c                            |  1 +
 net/unix/garbage.c                                 | 14 ++++++++--
 net/unix/scm.c                                     |  6 ++--
 sound/core/jack.c                                  |  3 ++
 sound/core/oss/pcm_oss.c                           |  2 +-
 sound/core/pcm.c                                   |  6 +++-
 sound/core/seq/seq_queue.c                         | 14 ++++++++--
 sound/pci/hda/hda_codec.c                          |  3 ++
 sound/soc/samsung/idma.c                           |  2 ++
 113 files changed, 485 insertions(+), 238 deletions(-)


