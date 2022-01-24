Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3759498DFC
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347110AbiAXTia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352851AbiAXTbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:31:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDFCC028C26;
        Mon, 24 Jan 2022 11:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 547CA6124E;
        Mon, 24 Jan 2022 19:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3194C340E5;
        Mon, 24 Jan 2022 19:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051648;
        bh=i9OsuGECMbq8SS8a8XKIhqDdHAISVBqKpOxb7KXBtBY=;
        h=From:To:Cc:Subject:Date:From;
        b=Mf/oFZSaYDKTT5Th8eEtsm2W5bWDeTDNymDDB/NWDNjZUITughoFX59BhcebEJm2B
         znSIybntnT696xnOWwnsP9egudRIh/+lQyyVb6Y0IP0xGugNi42jRvB2xaZ+5upMXi
         nnQ28rmOUxOukQGUvuVLU20RlzvBvl+/7dvUdVRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: [PATCH 4.19 000/239] 4.19.226-rc1 review
Date:   Mon, 24 Jan 2022 19:40:38 +0100
Message-Id: <20220124183943.102762895@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.226-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.226-rc1
X-KernelTest-Deadline: 2022-01-26T18:39+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.226 release.
There are 239 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.226-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.226-rc1

Amir Goldstein <amir73il@gmail.com>
    fuse: fix live lock in fuse_iget()

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix bad inode

Ben Hutchings <ben@decadent.org.uk>
    mips,s390,sh,sparc: gup: Work around the "COW can break either way" issue

Doyle, Patrick <pdoyle@irobot.com>
    mtd: nand: bbt: Fix corner case in bad block table handling

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

Laurence de Bruxelles <lfdebrux@gmail.com>
    rtc: pxa: fix null pointer dereference

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

Anders Roxell <anders.roxell@linaro.org>
    powerpc/cell: Fix clang -Wimplicit-fallthrough warning

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-mdma: fix STM32_MDMA_CTBR_TSEL_MASK

Chengguang Xu <cgxu519@mykernel.net>
    RDMA/rxe: Fix a typo in opcode name

Yixing Liu <liuyixing1@huawei.com>
    RDMA/hns: Modify the mapping attribute of doorbell to device

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Suresh Udipi <sudipi@jp.adit-jv.com>
    media: rcar-csi2: Optimize the selection PHTW register

Ben Hutchings <ben@decadent.org.uk>
    firmware: Update Kconfig help text for Google firmware

Tony Lindgren <tony@atomide.com>
    ARM: dts: Fix vcsi regulator to be always-on for droid4 to prevent hangs

Christian König <christian.koenig@amd.com>
    drm/radeon: fix error handling in radeon_driver_open_kms

Pascal Paillet <p.paillet@st.com>
    regulator: core: Let boot-on regulators be powered off

KaiChieh Chuang <kaichieh.chuang@mediatek.com>
    ASoC: dpcm: prevent snd_soc_dpcm use after free

Marek Vasut <marex@denx.de>
    crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

Theodore Ts'o <tytso@mit.edu>
    ext4: don't use the orphan list when migrating an inode

Ye Bin <yebin10@huawei.com>
    ext4: Fix BUG_ON in ext4_bread when write quota data

Luís Henriques <lhenriques@suse.de>
    ext4: set csum seed in tmp inode while migrating to extents

Jan Kara <jack@suse.cz>
    ext4: make sure quota gets properly shutdown on error

Jan Kara <jack@suse.cz>
    ext4: make sure to reset inode lockdep class when quota enabling fails

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: limit submit sizes

Alexander Gordeev <agordeev@linux.ibm.com>
    s390/mm: fix 2KB pgtable release race

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

Andrey Ryabinin <arbn@yandex-team.com>
    cputime, cpuacct: Include guest time in user time in cpuacct.stat

Lukas Wunner <lukas@wunner.de>
    serial: Fix incorrect rs485 polarity on uart open

Petr Cvachoucek <cvachoucek@gmail.com>
    ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
    rpmsg: core: Clean up resources on announce_create failure.

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

Ye Guojin <ye.guojin@zte.com.cn>
    MIPS: OCTEON: add put_device() after of_find_device_by_node()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc: handle kdump appropriately with crash_kexec_post_notifiers option

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

Nicholas Piggin <npiggin@gmail.com>
    powerpc/watchdog: Fix missed watchdog reset due to memory ordering race

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

Konrad Dybcio <konrad.dybcio@somainline.org>
    regulator: qcom_smd: Align probe function with rpmh-regulator

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: gemini: allow any RGMII interface mode

Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
    net: phy: marvell: configure RGMII delays for 88E1118

Joe Thornber <ejt@redhat.com>
    dm space map common: add bounds check to sm_ll_lookup_bitmap()

Joe Thornber <ejt@redhat.com>
    dm btree: add a defensive bounds check to insert_at()

Ping-Ke Shih <pkshih@realtek.com>
    mac80211: allow non-standard VHT MCS-10/11

Florian Fainelli <f.fainelli@gmail.com>
    net: mdio: Demote probed message to debug print

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove BUG_ON(!eie) in find_parent_nodes

Josef Bacik <josef@toxicpanda.com>
    btrfs: remove BUG_ON() in find_parent_nodes()

Thomas Weißschuh <linux@weissschuh.net>
    ACPI: battery: Add the ThinkPad "Not Charging" quirk

Zongmin Zhou <zhouzongmin@kylinos.cn>
    drm/amdgpu: fixup bad vram size on gmc v8

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Utilities: Avoid deleting the same object twice in a row

Mark Langsdorf <mlangsdo@redhat.com>
    ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions

Kyeong Yoo <kyeong.yoo@alliedtelesis.co.nz>
    jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

Randy Dunlap <rdunlap@infradead.org>
    um: registers: Rename function names to avoid conflicts and build problems

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Fix calculation of frame length

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: remove module loading failure message

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fix leaks/bad data after failed firmware load

Zekun Shen <bruceshenzk@gmail.com>
    ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Kai-Heng Feng <kai.heng.feng@canonical.com>
    usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Thierry Reding <treding@nvidia.com>
    arm64: tegra: Adjust length of CCPLEX cluster MMIO region

Paul Moore <paul@paul-moore.com>
    audit: ensure userspace is penalized the same as the kernel when under pressure

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

Sean Young <sean@mess.org>
    media: igorplugusb: receiver overflow should be reported

Alistair Francis <alistair@alistair23.me>
    HID: quirks: Allow inverting the absolute X/Y values

Paolo Abeni <pabeni@redhat.com>
    bpf: Do not WARN in bpf_warn_invalid_xdp_action()

Suresh Kumar <surkumar@redhat.com>
    net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Borislav Petkov <bp@suse.de>
    x86/mce: Mark mce_read_aux() noinstr

Borislav Petkov <bp@suse.de>
    x86/mce: Mark mce_end() noinstr

Borislav Petkov <bp@suse.de>
    x86/mce: Mark mce_panic() noinstr

Antoine Tenart <atenart@kernel.org>
    net-sysfs: update the queue counts in the unregistration path

Sebastian Gottschall <s.gottschall@dd-wrt.com>
    ath10k: Fix tx hanging

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: synchronize with FW after multicast commands

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    media: m920x: don't use stack on USB reads

Zhou Qingyang <zhou1615@umn.edu>
    media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()

James Hilliard <james.hilliard1@gmail.com>
    media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.

Xiongwei Song <sxwjean@gmail.com>
    floppy: Add max size check for user space request

Neal Liu <neal_liu@aspeedtech.com>
    usb: uhci: add aspeed ast2600 uhci support

Zekun Shen <bruceshenzk@gmail.com>
    rsi: Fix out-of-bounds read in rsi_read_pkt()

Zekun Shen <bruceshenzk@gmail.com>
    mwifiex: Fix skb_over_panic in mwifiex_usb_recv()

Chengfeng Ye <cyeaa@connect.ust.hk>
    HSI: core: Fix return freed object in hsi_new_client

Hans de Goede <hdegoede@redhat.com>
    gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use

Martyn Welch <martyn.welch@collabora.com>
    drm/bridge: megachips: Ensure both bridges are probed before registration

Danielle Ratson <danieller@nvidia.com>
    mlxsw: pci: Add shutdown method in PCI driver

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    ARM: imx: rename DEBUG_IMX21_IMX27_UART to DEBUG_IMX27_UART

Zheyu Ma <zheyuma97@gmail.com>
    media: b2c2: Add missing check in flexcop_pci_isr:

José Expósito <jose.exposito89@gmail.com>
    HID: apple: Do not reset quirks when the Fn key is not found

Pavankumar Kondeti <quic_pkondeti@quicinc.com>
    usb: gadget: f_fs: Use stream_open() for endpoint files

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR

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

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: mediatek: Check for error clk pointer

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    iommu/iova: Fix race between FQ timeout and teardown

Arnd Bergmann <arnd@arndb.de>
    dmaengine: pxa/mmp: stop referencing config->slave_id

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: rt5663: Handle device_property_read_u32_array error codes

Avihai Horon <avihaih@nvidia.com>
    RDMA/core: Let ib_find_gid() continue search even after empty entry

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Fix race conditions related to driver data

Hector Martin <marcan@marcan.st>
    iommu/io-pgtable-arm: Fix table descriptor paddr formatting

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    uio: uio_dmem_genirq: Catch the Exception

Kees Cook <keescook@chromium.org>
    char/mwave: Adjust io port register size

Bixuan Cui <cuibixuan@linux.alibaba.com>
    ALSA: oss: fix compile error when OSS_DEBUG is enabled

Lukas Bulwahn <lukas.bulwahn@gmail.com>
    ASoC: uniphier: drop selecting non-existing SND_SOC_UNIPHIER_AIO_DMA

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

Chen Jun <chenjun102@huawei.com>
    tpm: add request_locality before write TPM_INT_ENABLE

Miaoqian Lin <linmq006@gmail.com>
    spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    Bluetooth: hci_bcm: Check for error irq

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    fsl/fman: Check for null pointer after calling devm_ioremap

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    staging: greybus: audio: Check null pointer

Eric Dumazet <edumazet@google.com>
    ppp: ensure minimum packet size in ppp_write()

Xin Xiong <xiongx18@fudan.edu.cn>
    netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

Zhou Qingyang <zhou1615@umn.edu>
    pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()

Zhou Qingyang <zhou1615@umn.edu>
    pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()

Zhang Zixun <zhang133010@icloud.com>
    x86/mce/inject: Avoid out-of-bounds write when setting flags

Sergey Shtylyov <s.shtylyov@omp.ru>
    mmc: meson-mx-sdio: add IRQ check

Marek Behún <kabel@kernel.org>
    ARM: dts: armada-38x: Add generic compatible to UART nodes

Wei Yongjun <weiyongjun1@huawei.com>
    usb: ftdi-elan: fix memory leak on device disconnect

Antony Antony <antony.antony@secunet.com>
    xfrm: state and policy should fail if XFRMA_IF_ID 0

Antony Antony <antony.antony@secunet.com>
    xfrm: interface with if_id 0 should return error

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: fix safe status debugfs file

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda/imx-vdoa: Handle dma_set_coherent_mask error codes

Wang Hai <wanghai38@huawei.com>
    media: msi001: fix possible null-ptr-deref in msi001_probe()

Anton Vasilyev <vasilyev@ispras.ru>
    media: dw2102: Fix use after free

Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
    crypto: stm32/cryp - fix double pm exit

Eric Dumazet <edumazet@google.com>
    xfrm: fix a small bug in xfrm_sa_len()

Li Hua <hucool.lihua@huawei.com>
    sched/rt: Try to restart rt period timer when rt runtime exceeded

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

Lizhi Hou <lizhi.hou@xilinx.com>
    tty: serial: uartlite: allow 64 bit address

Zhou Qingyang <zhou1615@umn.edu>
    drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()

Zhou Qingyang <zhou1615@umn.edu>
    drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8916: fix MMC controller aliases

Florian Westphal <fw@strlen.de>
    netfilter: bridge: add support for pppoe filtering

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released

Yang Yingliang <yangyingliang@huawei.com>
    media: si470x-i2c: fix possible memory leak in si470x_i2c_probe()

Suresh Udipi <sudipi@jp.adit-jv.com>
    media: rcar-csi2: Correct the selection of hsfreqrange

Tudor Ambarus <tudor.ambarus@microchip.com>
    tty: serial: atmel: Call dma_async_issue_pending()

Tudor Ambarus <tudor.ambarus@microchip.com>
    tty: serial: atmel: Check return code of dmaengine_submit()

Chengfeng Ye <cyeaa@connect.ust.hk>
    crypto: qce - fix uaf on qce_ahash_register_one

Wang Hai <wanghai38@huawei.com>
    media: dmxdev: fix UAF when dvb_register_device() fails

Jens Wiklander <jens.wiklander@linaro.org>
    tee: fix put order in teedev_close_context()

Pavel Skripkin <paskripkin@gmail.com>
    Bluetooth: stop proccessing malicious adv data

Christian Hewitt <christianshewitt@gmail.com>
    arm64: dts: meson-gxbb-wetek: fix missing GPIO binding

Dongliang Mu <mudongliangabcd@gmail.com>
    media: em28xx: fix memory leak in em28xx_init_dev

Dillon Min <dillon.minfei@gmail.com>
    media: videobuf2: Fix the size printk format

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Release DMA channel descriptor allocations

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND

Maxime Ripard <maxime@cerno.tech>
    clk: bcm-2835: Remove rounding up the dividers

Maxime Ripard <maxime@cerno.tech>
    clk: bcm-2835: Pick the closest clock rate

Wang Hai <wanghai38@huawei.com>
    Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails

Brian Norris <briannorris@chromium.org>
    drm/panel: innolux-p079zca: Delete panel on attach() failure

Gang Li <ligang.bdlg@bytedance.com>
    shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Yifeng Li <tomli@tomli.me>
    PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Christophe Leroy <christophe.leroy@csgroup.eu>
    lkdtm: Fix content of section containing lkdtm_rodata_do_nothing()

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

Lucas De Marchi <lucas.demarchi@intel.com>
    x86/gpu: Reserve stolen memory for first integrated Intel GPU

Stefan Riedmueller <s.riedmueller@phytec.de>
    mtd: rawnand: gpmi: Remove explicit default gpmi clock setting for i.MX6

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check in is_alive()

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Avoid using stale array indicies to read contact count

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ignore the confidence flag when a touch is removed

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Reset expected and received contact counts at the same time

Jann Horn <jannh@google.com>
    HID: uhid: Fix worker destroying device without any protection

Christian Lachner <gladiac@gmail.com>
    ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master after reboot from Windows

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix kobject leak in probe error path

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix sysfs information leak

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Johan Hovold <johan@kernel.org>
    media: uvcvideo: fix division by zero at stream start

Eric Farman <farman@linux.ibm.com>
    KVM: s390: Clarify SIGP orders versus STOP/RESTART

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add $(KBUILD_HOSTLDFLAGS) to 'has_libelf' test

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

Daniel Borkmann <daniel@iogearbox.net>
    veth: Do not record rx queue hint in veth_xmit

Thomas Gleixner <tglx@linutronix.de>
    can: bcm: switch timer to HRTIMER_MODE_SOFT and remove hrtimer_tasklet

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Fix bug in resuming hub's handling of wakeup requests

Johan Hovold <johan@kernel.org>
    Bluetooth: bfusb: fix division by zero in send path


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/spectre.rst      |   2 +-
 Makefile                                           |   6 +-
 arch/arm/Kconfig.debug                             |  14 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |   4 +-
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi     |   4 +-
 arch/arm/include/debug/imx-uart.h                  |  18 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi  |   1 +
 arch/arm64/boot/dts/nvidia/tegra186.dtsi           |   2 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   4 +-
 arch/mips/bcm63xx/clk.c                            |   6 +
 arch/mips/cavium-octeon/octeon-platform.c          |   2 +
 arch/mips/cavium-octeon/octeon-usb.c               |   1 +
 arch/mips/include/asm/octeon/cvmx-bootinfo.h       |   4 +-
 arch/mips/lantiq/clk.c                             |   6 +
 arch/mips/mm/gup.c                                 |   9 +-
 arch/parisc/kernel/traps.c                         |   2 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi      |   2 +
 arch/powerpc/kernel/btext.c                        |   4 +-
 arch/powerpc/kernel/prom_init.c                    |   2 +-
 arch/powerpc/kernel/smp.c                          |  32 ++
 arch/powerpc/kernel/watchdog.c                     |  41 ++-
 arch/powerpc/platforms/cell/iommu.c                |   1 +
 arch/powerpc/platforms/cell/pervasive.c            |   1 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c      |   1 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |   1 +
 arch/s390/kvm/interrupt.c                          |   7 +
 arch/s390/kvm/kvm-s390.c                           |   9 +-
 arch/s390/kvm/kvm-s390.h                           |   1 +
 arch/s390/kvm/sigp.c                               |  28 ++
 arch/s390/mm/gup.c                                 |   9 +-
 arch/s390/mm/pgalloc.c                             |   4 +-
 arch/sh/mm/gup.c                                   |   9 +-
 arch/sparc/mm/gup.c                                |   9 +-
 arch/um/include/shared/registers.h                 |   4 +-
 arch/um/os-Linux/registers.c                       |   4 +-
 arch/um/os-Linux/start_up.c                        |   2 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c            |   2 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |  31 +-
 arch/x86/kernel/early-quirks.c                     |  10 +-
 arch/x86/um/syscalls_64.c                          |   3 +-
 drivers/acpi/acpica/exoparg1.c                     |   3 +-
 drivers/acpi/acpica/hwesleep.c                     |   4 +-
 drivers/acpi/acpica/hwsleep.c                      |   4 +-
 drivers/acpi/acpica/hwxfsleep.c                    |   2 -
 drivers/acpi/acpica/utdelete.c                     |   1 +
 drivers/acpi/battery.c                             |  22 ++
 drivers/block/floppy.c                             |   6 +-
 drivers/bluetooth/bfusb.c                          |   3 +
 drivers/bluetooth/hci_bcm.c                        |   7 +-
 drivers/char/mwave/3780i.h                         |   2 +-
 drivers/char/random.c                              |  61 ++--
 drivers/char/tpm/tpm_tis_core.c                    |   8 +
 drivers/clk/bcm/clk-bcm2835.c                      |  13 +-
 drivers/crypto/qce/sha.c                           |   2 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   2 -
 drivers/crypto/stm32/stm32_crc32.c                 |   4 +-
 drivers/dma/at_xdmac.c                             |  32 +-
 drivers/dma/mmp_pdma.c                             |   6 -
 drivers/dma/pxa_dma.c                              |   7 -
 drivers/dma/stm32-mdma.c                           |   2 +-
 drivers/firmware/google/Kconfig                    |   6 +-
 drivers/firmware/qemu_fw_cfg.c                     |  20 +-
 drivers/gpio/gpiolib-acpi.c                        |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   6 +
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |  13 +-
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c   |  40 ++-
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c       |   6 +
 drivers/gpu/drm/i915/intel_pm.c                    |   6 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   4 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c     |  37 ++-
 drivers/gpu/drm/panel/panel-innolux-p079zca.c      |  10 +-
 drivers/gpu/drm/radeon/radeon_kms.c                |  42 +--
 drivers/hid/hid-apple.c                            |   2 +-
 drivers/hid/hid-input.c                            |   6 +
 drivers/hid/uhid.c                                 |  29 +-
 drivers/hid/wacom_wac.c                            |  39 ++-
 drivers/hsi/hsi_core.c                             |   1 +
 drivers/i2c/busses/i2c-designware-pcidrv.c         |   8 +-
 drivers/i2c/busses/i2c-i801.c                      |  15 +-
 drivers/i2c/busses/i2c-mpc.c                       |  23 +-
 drivers/infiniband/core/device.c                   |   3 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |   1 +
 drivers/infiniband/hw/hns/hns_roce_main.c          |   5 +-
 drivers/infiniband/sw/rxe/rxe_opcode.c             |   2 +-
 drivers/iommu/io-pgtable-arm.c                     |   9 +-
 drivers/iommu/iova.c                               |   3 +-
 drivers/md/persistent-data/dm-btree.c              |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   5 +
 drivers/media/common/saa7146/saa7146_fops.c        |   2 +-
 .../media/common/videobuf2/videobuf2-dma-contig.c  |   8 +-
 drivers/media/dvb-core/dmxdev.c                    |  18 +-
 drivers/media/dvb-frontends/dib8000.c              |   4 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   3 +
 drivers/media/pci/saa7146/hexium_gemini.c          |   7 +-
 drivers/media/pci/saa7146/hexium_orion.c           |   8 +-
 drivers/media/pci/saa7146/mxb.c                    |   8 +-
 drivers/media/platform/coda/imx-vdoa.c             |   6 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |   2 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c        |  18 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   3 +-
 drivers/media/rc/igorplugusb.c                     |   4 +-
 drivers/media/rc/mceusb.c                          |   8 +-
 drivers/media/rc/redrat3.c                         |  22 +-
 drivers/media/tuners/msi001.c                      |   7 +
 drivers/media/tuners/si2157.c                      |   2 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |  10 +-
 drivers/media/usb/b2c2/flexcop-usb.h               |  12 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   4 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   2 -
 drivers/media/usb/dvb-usb/dw2102.c                 | 338 +++++++++++++--------
 drivers/media/usb/dvb-usb/m920x.c                  |  12 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |  18 +-
 drivers/media/usb/em28xx/em28xx-core.c             |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   8 +-
 drivers/media/usb/s2255/s2255drv.c                 |   4 +-
 drivers/media/usb/stk1160/stk1160-core.c           |   4 +-
 drivers/media/usb/uvc/uvc_video.c                  |   4 +
 drivers/media/usb/uvc/uvcvideo.h                   |   2 +-
 drivers/mfd/intel-lpss-acpi.c                      |   7 +-
 drivers/misc/lattice-ecp3-config.c                 |  12 +-
 drivers/misc/lkdtm/Makefile                        |   2 +-
 drivers/mmc/core/sdio.c                            |   4 +-
 drivers/mmc/host/meson-mx-sdio.c                   |   5 +
 drivers/mtd/nand/bbt.c                             |   2 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   9 -
 drivers/net/bonding/bond_main.c                    |   6 +-
 drivers/net/can/softing/softing_cs.c               |   2 +-
 drivers/net/can/softing/softing_fw.c               |  11 +-
 drivers/net/can/usb/gs_usb.c                       |   5 +-
 drivers/net/can/xilinx_can.c                       |   7 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  10 +-
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c  |   3 +-
 drivers/net/ethernet/cortina/gemini.c              |   9 +-
 drivers/net/ethernet/freescale/fman/mac.c          |  21 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   3 +-
 drivers/net/ethernet/i825xx/sni_82596.c            |   3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   1 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  14 +-
 drivers/net/phy/marvell.c                          |   6 +
 drivers/net/phy/mdio_bus.c                         |   2 +-
 drivers/net/ppp/ppp_generic.c                      |   7 +-
 drivers/net/usb/mcs7830.c                          |  12 +-
 drivers/net/veth.c                                 |   1 -
 drivers/net/wireless/ath/ar5523/ar5523.c           |   4 +
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   3 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   2 -
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   7 +
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   5 +
 drivers/net/wireless/ath/wcn36xx/smd.c             |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  17 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  27 ++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   1 +
 drivers/net/wireless/rsi/rsi_91x_main.c            |   4 +
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   1 -
 drivers/net/wireless/rsi/rsi_usb.h                 |   2 +
 drivers/parisc/pdc_stable.c                        |   4 +-
 drivers/pci/quirks.c                               |   3 +
 drivers/pcmcia/cs.c                                |   8 +-
 drivers/pcmcia/rsrc_nonstatic.c                    |   6 +
 drivers/power/supply/bq25890_charger.c             |   4 +-
 drivers/regulator/core.c                           |   4 +-
 drivers/regulator/qcom_smd-regulator.c             | 100 ++++--
 drivers/rpmsg/rpmsg_core.c                         |  20 +-
 drivers/rtc/rtc-cmos.c                             |   3 +
 drivers/rtc/rtc-pxa.c                              |   4 +
 drivers/scsi/sr.c                                  |   2 +-
 drivers/scsi/sr_vendor.c                           |   4 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 |   1 -
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 -
 drivers/scsi/ufs/ufshcd.c                          |   7 +
 drivers/soc/mediatek/mtk-scpsys.c                  |  15 +-
 drivers/spi/spi-meson-spifc.c                      |   1 +
 drivers/staging/greybus/audio_topology.c           |  15 +
 drivers/staging/wlan-ng/hfa384x_usb.c              |  22 +-
 drivers/tee/tee_core.c                             |   4 +-
 drivers/tty/serial/amba-pl010.c                    |   3 -
 drivers/tty/serial/amba-pl011.c                    |  27 +-
 drivers/tty/serial/atmel_serial.c                  |  14 +
 drivers/tty/serial/serial_core.c                   |   7 +-
 drivers/tty/serial/uartlite.c                      |   2 +-
 drivers/uio/uio_dmem_genirq.c                      |   6 +-
 drivers/usb/core/hcd.c                             |   9 +-
 drivers/usb/core/hub.c                             |   7 +-
 drivers/usb/gadget/function/f_fs.c                 |   4 +-
 drivers/usb/host/uhci-platform.c                   |   3 +-
 drivers/usb/misc/ftdi-elan.c                       |   1 +
 drivers/w1/slaves/w1_ds28e04.c                     |  26 +-
 fs/btrfs/backref.c                                 |  21 +-
 fs/dlm/lock.c                                      |   9 +
 fs/ext4/ioctl.c                                    |   2 -
 fs/ext4/mballoc.c                                  |   8 +
 fs/ext4/migrate.c                                  |  23 +-
 fs/ext4/super.c                                    |  25 +-
 fs/f2fs/gc.c                                       |   3 +
 fs/fuse/acl.c                                      |   6 +
 fs/fuse/dir.c                                      |  40 ++-
 fs/fuse/file.c                                     |  27 +-
 fs/fuse/fuse_i.h                                   |  13 +
 fs/fuse/inode.c                                    |   2 +-
 fs/fuse/xattr.c                                    |   9 +
 fs/jffs2/file.c                                    |  40 ++-
 fs/orangefs/orangefs-bufmap.c                      |   7 +-
 fs/ubifs/super.c                                   |   1 -
 include/acpi/actypes.h                             |  10 +-
 include/linux/hid.h                                |   2 +
 include/net/sch_generic.h                          |   5 +
 include/sound/soc.h                                |   2 +
 kernel/audit.c                                     |  18 +-
 kernel/sched/cputime.c                             |   4 +-
 kernel/sched/rt.c                                  |  23 +-
 mm/shmem.c                                         |  37 ++-
 net/bluetooth/cmtp/core.c                          |   4 +-
 net/bluetooth/hci_core.c                           |   1 +
 net/bluetooth/hci_event.c                          |   8 +-
 net/bridge/br_netfilter_hooks.c                    |   7 +-
 net/can/bcm.c                                      | 156 ++++------
 net/core/filter.c                                  |   6 +-
 net/core/net-sysfs.c                               |   3 +
 net/core/net_namespace.c                           |   4 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   5 +-
 net/mac80211/rx.c                                  |   2 +-
 net/nfc/llcp_sock.c                                |   5 +
 net/sched/sch_generic.c                            |   1 +
 net/unix/garbage.c                                 |  14 +-
 net/unix/scm.c                                     |   6 +-
 net/xfrm/xfrm_interface.c                          |  14 +-
 net/xfrm/xfrm_user.c                               |  23 +-
 scripts/dtc/dtx_diff                               |   8 +-
 sound/core/jack.c                                  |   3 +
 sound/core/oss/pcm_oss.c                           |   2 +-
 sound/core/pcm.c                                   |   6 +-
 sound/core/seq/seq_queue.c                         |  14 +-
 sound/pci/hda/hda_codec.c                          |   3 +
 sound/pci/hda/patch_realtek.c                      |  30 +-
 sound/soc/codecs/rt5663.c                          |  12 +-
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |   3 +
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |   2 +
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c   |   2 +
 sound/soc/mediatek/mt8173/mt8173-rt5650.c          |   2 +
 sound/soc/samsung/idma.c                           |   2 +
 sound/soc/soc-core.c                               |   1 +
 sound/soc/soc-pcm.c                                |  40 ++-
 sound/soc/uniphier/Kconfig                         |   2 -
 246 files changed, 1866 insertions(+), 872 deletions(-)


