Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280EE49B8B2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 17:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiAYQc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 11:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1583551AbiAYQb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 11:31:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFB9C06173B;
        Tue, 25 Jan 2022 08:31:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9866FB8180D;
        Tue, 25 Jan 2022 16:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A0FC340E0;
        Tue, 25 Jan 2022 16:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643128313;
        bh=W3V078rvtKwxGqKudR35oHsugM9aKAkvOngw0GWmF7g=;
        h=From:To:Cc:Subject:Date:From;
        b=O+PtlXb6xh+KsJ0XPX+opiA4+ZX3dl2emCCnDy7OYCnzgDv5rgwwLTSf2l1FayjGC
         EC0KiQvE2Ne/F3zzu7SOVLccvsdENsJLPKM0GKriMQL3uPAiGY0q5jE9oGcfGOnehc
         mOOm4V0weHIIkbyQT+Buf0hOBBODDrjcEhLP9qa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: [PATCH 4.9 000/155] 4.9.298-rc2 review
Date:   Tue, 25 Jan 2022 17:31:50 +0100
Message-Id: <20220125155253.051565866@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.298-rc2
X-KernelTest-Deadline: 2022-01-27T15:52+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.298 release.
There are 155 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 27 Jan 2022 15:52:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.298-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.298-rc2

Nicholas Piggin <npiggin@gmail.com>
    KVM: do not allow mapping valid but non-reference-counted pages

Sean Christopherson <seanjc@google.com>
    KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: do not assume PTE is writable after follow_pfn

Ross Zwisler <ross.zwisler@linux.intel.com>
    mm: add follow_pte_pmd()

Davidlohr Bueso <dave@stgolabs.net>
    lib/timerqueue: Rely on rbtree semantics for next timer

Davidlohr Bueso <dave@stgolabs.net>
    rbtree: cache leftmost node internally

Paul Moore <paul@paul-moore.com>
    cipso,calipso: resolve a number of problems with the DOI refcounts

Michael Braun <michael-dev@fami-braun.de>
    gianfar: fix jumbo packets+napi+rx overrun crash

Andy Spencer <aspencer@spacex.com>
    gianfar: simplify FCS handling and fix memory leak

Dave Airlie <airlied@redhat.com>
    drm/ttm/nouveau: don't call tt destroy callback on alloc failure.

Linus Torvalds <torvalds@linux-foundation.org>
    gup: document and work around "COW can break either way" issue

Ben Hutchings <ben@decadent.org.uk>
    Revert "gup: document and work around "COW can break either way" issue"

Miaoqian Lin <linmq006@gmail.com>
    lib82596: Fix IRQ check in sni_82596_probe

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    scripts/dtc: dtx_diff: remove broken example from help text

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

Guillaume Nault <gnault@redhat.com>
    libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()

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

Chengguang Xu <cgxu519@mykernel.net>
    RDMA/rxe: Fix a typo in opcode name

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Modify the mapping attribute of doorbell to device

Christian König <christian.koenig@amd.com>
    drm/radeon: fix error handling in radeon_driver_open_kms

Amir Goldstein <amir73il@gmail.com>
    fuse: fix live lock in fuse_iget()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix bad inode

Theodore Ts'o <tytso@mit.edu>
    ext4: don't use the orphan list when migrating an inode

Ye Bin <yebin10@huawei.com>
    ext4: Fix BUG_ON in ext4_bread when write quota data

Luís Henriques <lhenriques@suse.de>
    ext4: set csum seed in tmp inode while migrating to extents

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

Petr Cvachoucek <cvachoucek@gmail.com>
    ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Yauhen Kharuzhy <jekhor@gmail.com>
    power: bq25890: Enable continuous conversion for ADC at charging

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: mediatek: mt8173: fix device_node leak

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

Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>
    jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

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

Sebastian Gottschall <s.gottschall@dd-wrt.com>
    ath10k: Fix tx hanging

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

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    ARM: imx: rename DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART

Zheyu Ma <zheyuma97@gmail.com>
    media: b2c2: Add missing check in flexcop_pci_isr:

José Expósito <jose.exposito89@gmail.com>
    HID: apple: Do not reset quirks when the Fn key is not found

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

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix race conditions related to driver data

Kees Cook <keescook@chromium.org>
    char/mwave: Adjust io port register size

Bixuan Cui <cuibixuan@linux.alibaba.com>
    ALSA: oss: fix compile error when OSS_DEBUG is enabled

Peiwei Hu <jlu.hpw@foxmail.com>
    powerpc/prom_init: Fix improper check of prom_getprop()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/hns: Validate the pkey index

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

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fsl/fman: Check for null pointer after calling devm_ioremap

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

Robert Schlabbach <robert_s@gmx.net>
    media: si2157: Fix "warm" tuner state detection

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()

Zhou Qingyang <zhou1615@umn.edu>
    media: dib8000: Fix a memleak in dib8000_init()

Tasos Sahanidis <tasos@tasossah.com>
    floppy: Fix hang in watchdog when disk is ejected

Lino Sanfilippo <LinoSanfilippo@gmx.de>
    serial: amba-pl011: do not request memory region twice

Zhou Qingyang <zhou1615@umn.edu>
    drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()

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

Wang Hai <wanghai38@huawei.com>
    media: dmxdev: fix UAF when dvb_register_device() fails

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: stop proccessing malicious adv data

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND

Wang Hai <wanghai38@huawei.com>
    Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails

Gang Li <ligang.bdlg@bytedance.com>
    shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Yifeng Li <tomli@tomli.me>
    PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Johan Hovold <johan@kernel.org>
    can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johan Hovold <johan@kernel.org>
    media: stk1160: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: pvrusb2: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: redrat3: fix control-message timeouts

Michael Kuron <michael.kuron@gmail.com>
    media: dib0700: fix undefined behavior in tuner shutdown

Johan Hovold <johan@kernel.org>
    media: s2255: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: cpia2: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: em28xx: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: mceusb: fix control-message timeouts

Johan Hovold <johan@kernel.org>
    media: flexcop-usb: fix control-message timeouts

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: cmos: take rtc_lock while reading from CMOS

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Avoid using stale array indicies to read contact count

Jann Horn <jannh@google.com>
    HID: uhid: Fix worker destroying device without any protection

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Johan Hovold <johan@kernel.org>
    media: uvcvideo: fix division by zero at stream start

Nathan Chancellor <nathan@kernel.org>
    drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Nathan Chancellor <nathan@kernel.org>
    staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()

Eric Biggers <ebiggers@google.com>
    random: fix data race on crng init time

Eric Biggers <ebiggers@google.com>
    random: fix data race on crng_node_pool

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

 Documentation/rbtree.txt                           | 33 ++++++++++++
 Makefile                                           |  4 +-
 arch/arm/Kconfig.debug                             | 14 ++---
 arch/arm/include/debug/imx-uart.h                  | 18 +++----
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |  4 +-
 arch/mips/bcm63xx/clk.c                            |  6 +++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |  4 +-
 arch/mips/lantiq/clk.c                             |  6 +++
 arch/mips/mm/gup.c                                 |  9 +++-
 arch/parisc/kernel/traps.c                         |  2 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi      |  2 +
 arch/powerpc/kernel/btext.c                        |  4 +-
 arch/powerpc/kernel/prom_init.c                    |  2 +-
 arch/powerpc/kernel/smp.c                          |  2 +
 arch/powerpc/platforms/cell/iommu.c                |  1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |  1 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |  1 +
 arch/s390/mm/gup.c                                 |  9 +++-
 arch/sh/mm/gup.c                                   |  9 +++-
 arch/sparc/mm/gup.c                                |  9 +++-
 arch/um/include/shared/registers.h                 |  4 +-
 arch/um/os-Linux/registers.c                       |  4 +-
 arch/um/os-Linux/start_up.c                        |  2 +-
 arch/x86/mm/gup.c                                  |  9 +++-
 arch/x86/um/syscalls_64.c                          |  3 +-
 drivers/acpi/acpica/exoparg1.c                     |  3 +-
 drivers/acpi/acpica/utdelete.c                     |  1 +
 drivers/block/floppy.c                             |  6 ++-
 drivers/bluetooth/bfusb.c                          |  3 ++
 drivers/char/mwave/3780i.h                         |  2 +-
 drivers/char/random.c                              | 61 ++++++++++++----------
 drivers/crypto/qce/sha.c                           |  2 +-
 drivers/dma/at_xdmac.c                             | 32 ++++++------
 drivers/dma/mmp_pdma.c                             |  6 ---
 drivers/dma/pxa_dma.c                              |  7 ---
 drivers/gpio/gpiolib-acpi.c                        | 15 ++++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |  6 +++
 drivers/gpu/drm/i915/intel_pm.c                    |  6 +--
 drivers/gpu/drm/nouveau/nouveau_sgdma.c            |  9 ++--
 drivers/gpu/drm/radeon/radeon_kms.c                | 42 ++++++++-------
 drivers/gpu/drm/ttm/ttm_tt.c                       |  2 -
 drivers/hid/hid-apple.c                            |  2 +-
 drivers/hid/uhid.c                                 | 29 ++++++++--
 drivers/hid/wacom_wac.c                            |  4 ++
 drivers/hsi/hsi_core.c                             |  1 +
 drivers/i2c/busses/i2c-designware-pcidrv.c         |  8 +--
 drivers/i2c/busses/i2c-i801.c                      | 15 ++----
 drivers/i2c/busses/i2c-mpc.c                       | 23 +++++---
 drivers/infiniband/core/device.c                   |  3 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |  5 +-
 drivers/infiniband/sw/rxe/rxe_opcode.c             |  2 +-
 drivers/md/persistent-data/dm-btree.c              |  8 +--
 drivers/md/persistent-data/dm-space-map-common.c   |  5 ++
 drivers/media/common/saa7146/saa7146_fops.c        |  2 +-
 drivers/media/dvb-core/dmxdev.c                    | 18 +++++--
 drivers/media/dvb-frontends/dib8000.c              |  4 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |  3 ++
 drivers/media/pci/saa7146/hexium_gemini.c          |  7 ++-
 drivers/media/pci/saa7146/hexium_orion.c           |  8 ++-
 drivers/media/pci/saa7146/mxb.c                    |  8 ++-
 drivers/media/rc/igorplugusb.c                     |  4 +-
 drivers/media/rc/mceusb.c                          |  8 +--
 drivers/media/rc/redrat3.c                         | 22 ++++----
 drivers/media/tuners/msi001.c                      |  7 +++
 drivers/media/tuners/si2157.c                      |  2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               | 10 ++--
 drivers/media/usb/b2c2/flexcop-usb.h               | 12 ++---
 drivers/media/usb/cpia2/cpia2_usb.c                |  4 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |  2 -
 drivers/media/usb/dvb-usb/m920x.c                  | 12 ++++-
 drivers/media/usb/em28xx/em28xx-core.c             |  4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  8 +--
 drivers/media/usb/s2255/s2255drv.c                 |  4 +-
 drivers/media/usb/stk1160/stk1160-core.c           |  4 +-
 drivers/media/usb/uvc/uvc_video.c                  |  4 ++
 drivers/mfd/intel-lpss-acpi.c                      |  7 ++-
 drivers/misc/lattice-ecp3-config.c                 | 12 ++---
 drivers/net/bonding/bond_main.c                    |  6 +--
 drivers/net/can/softing/softing_cs.c               |  2 +-
 drivers/net/can/softing/softing_fw.c               | 11 ++--
 drivers/net/can/usb/gs_usb.c                       |  5 +-
 drivers/net/can/xilinx_can.c                       |  7 ++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 10 ++--
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c  |  3 +-
 drivers/net/ethernet/freescale/fman/mac.c          | 21 ++++++--
 drivers/net/ethernet/freescale/gianfar.c           | 38 ++++++++------
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  3 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |  3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 14 ++++-
 drivers/net/phy/mdio_bus.c                         |  2 +-
 drivers/net/ppp/ppp_generic.c                      |  7 ++-
 drivers/net/usb/mcs7830.c                          | 12 ++++-
 drivers/net/wireless/ath/ar5523/ar5523.c           |  4 ++
 drivers/net/wireless/ath/ath10k/htt_tx.c           |  3 ++
 drivers/net/wireless/ath/ath10k/txrx.c             |  2 -
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  7 +++
 drivers/net/wireless/ath/wcn36xx/smd.c             |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 17 ++++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |  3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  1 +
 drivers/parisc/pdc_stable.c                        |  4 +-
 drivers/pci/quirks.c                               |  3 ++
 drivers/pcmcia/cs.c                                |  8 ++-
 drivers/pcmcia/rsrc_nonstatic.c                    |  6 +++
 drivers/power/supply/bq25890_charger.c             |  4 +-
 drivers/rtc/rtc-cmos.c                             |  3 ++
 drivers/scsi/sr.c                                  |  2 +-
 drivers/scsi/sr_vendor.c                           |  4 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 |  1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  2 -
 drivers/scsi/ufs/ufshcd.c                          |  7 +++
 drivers/spi/spi-meson-spifc.c                      |  1 +
 drivers/staging/wlan-ng/hfa384x_usb.c              | 22 ++++----
 drivers/tty/serial/amba-pl010.c                    |  3 --
 drivers/tty/serial/amba-pl011.c                    | 27 ++--------
 drivers/tty/serial/atmel_serial.c                  | 14 +++++
 drivers/tty/serial/serial_core.c                   |  3 +-
 drivers/usb/core/hcd.c                             |  9 +++-
 drivers/usb/core/hub.c                             |  7 ++-
 drivers/usb/gadget/function/f_fs.c                 |  4 +-
 drivers/usb/misc/ftdi-elan.c                       |  1 +
 drivers/w1/slaves/w1_ds28e04.c                     | 26 +++------
 fs/btrfs/backref.c                                 | 21 ++++++--
 fs/dlm/lock.c                                      |  9 ++++
 fs/ext4/ioctl.c                                    |  2 -
 fs/ext4/mballoc.c                                  |  8 +++
 fs/ext4/migrate.c                                  | 23 ++++----
 fs/ext4/super.c                                    |  2 +-
 fs/fuse/acl.c                                      |  6 +++
 fs/fuse/dir.c                                      | 40 ++++++++++++--
 fs/fuse/file.c                                     | 27 ++++++----
 fs/fuse/fuse_i.h                                   | 13 +++++
 fs/fuse/inode.c                                    |  2 +-
 fs/fuse/xattr.c                                    |  9 ++++
 fs/jffs2/file.c                                    | 40 ++++++++------
 fs/ubifs/super.c                                   |  1 -
 include/linux/mm.h                                 |  2 +
 include/linux/rbtree.h                             | 21 ++++++++
 include/linux/rbtree_augmented.h                   | 33 ++++++++++--
 include/linux/timerqueue.h                         | 13 +++--
 include/net/sch_generic.h                          |  5 ++
 lib/rbtree.c                                       | 34 ++++++++++--
 lib/timerqueue.c                                   | 31 +++++------
 mm/gup.c                                           | 22 ++++----
 mm/memory.c                                        | 37 ++++++++++---
 mm/shmem.c                                         | 37 +++++++------
 net/bluetooth/cmtp/core.c                          |  4 +-
 net/bluetooth/hci_core.c                           |  1 +
 net/bluetooth/hci_event.c                          |  8 ++-
 net/bridge/br_netfilter_hooks.c                    |  7 ++-
 net/core/net_namespace.c                           |  4 +-
 net/ipv4/cipso_ipv4.c                              | 11 +---
 net/ipv6/calipso.c                                 | 14 ++---
 net/netlabel/netlabel_cipso_v4.c                   |  3 ++
 net/nfc/llcp_sock.c                                |  5 ++
 net/sched/sch_generic.c                            |  1 +
 net/unix/garbage.c                                 | 14 +++--
 net/unix/scm.c                                     |  6 ++-
 scripts/dtc/dtx_diff                               |  8 +--
 sound/core/jack.c                                  |  3 ++
 sound/core/oss/pcm_oss.c                           |  2 +-
 sound/core/pcm.c                                   |  6 ++-
 sound/core/seq/seq_queue.c                         | 14 ++++-
 sound/pci/hda/hda_codec.c                          |  3 ++
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |  3 ++
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |  2 +
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |  2 +
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |  2 +
 sound/soc/samsung/idma.c                           |  2 +
 virt/kvm/kvm_main.c                                | 36 ++++++++++---
 172 files changed, 1075 insertions(+), 519 deletions(-)


