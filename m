Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2FB378146
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhEJKZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbhEJKZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D90C46147E;
        Mon, 10 May 2021 10:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642241;
        bh=TfYi122ws3cT89cYJaUpYxYCu/XbM+A8AeiGtlZofmg=;
        h=From:To:Cc:Subject:Date:From;
        b=mvGZChV6wWdi2HAY7L2DJYZd4SXQhRX12bAuct/65IFPqhBfK+JvLUiuqjmKQs5pH
         76wXg9byYVNNUOT7iZWNPCh8HRz81QKgiYNQ0ruNXnq5FrVnSs0Ip01W4syOFh6Ia8
         AtkUrBXD6tv37gLVoZ9bCx25tftSw+lOQ5aKjfgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/184] 5.4.118-rc1 review
Date:   Mon, 10 May 2021 12:18:14 +0200
Message-Id: <20210510101950.200777181@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.118-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.118-rc1
X-KernelTest-Deadline: 2021-05-12T10:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.118 release.
There are 184 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.118-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.118-rc1

Benjamin Block <bblock@linux.ibm.com>
    dm rq: fix double free of blk_mq_tag_set in dev remove after table load fails

Tian Tao <tiantao6@hisilicon.com>
    dm integrity: fix missing goto in bitmap_flush_interval error handling

Joe Thornber <ejt@redhat.com>
    dm space map common: fix division bug in sm_ll_find_free_block()

Joe Thornber <ejt@redhat.com>
    dm persistent data: packed struct should have an aligned() attribute too

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Restructure trace_clock_global() to never block

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Map all PIDs to command lines

Marek Vasut <marex@denx.de>
    rsi: Use resume_noirq for SDIO

Pavel Skripkin <paskripkin@gmail.com>
    tty: fix memory leak in vc_deallocate

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix session request interrupt handler

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix START_TRANSFER link state check

Dean Anderson <dean@sensoray.com>
    usb: gadget/function/f_fs string table fix for multiple languages

Hemant Kumar <hemantk@codeaurora.org>
    usb: gadget: Fix double free of device descriptor pointers

Anirudh Rayabharam <mail@anirudhrb.com>
    usb: gadget: dummy_hcd: fix gpf in gadget_setup

Ricardo Ribalda <ribalda@chromium.org>
    media: staging/intel-ipu3: Fix race condition during set_fmt

Ricardo Ribalda <ribalda@chromium.org>
    media: staging/intel-ipu3: Fix set_fmt error handling

Ricardo Ribalda <ribalda@chromium.org>
    media: staging/intel-ipu3: Fix memory leak in imu_fmt

Takashi Iwai <tiwai@suse.de>
    media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()

Takashi Iwai <tiwai@suse.de>
    media: dvb-usb: Fix use-after-free access

Peilin Ye <yepeilin.cs@gmail.com>
    media: dvbdev: Fix memory leak in dvb_media_device_free()

Fengnan Chang <changfengnan@vivo.com>
    ext4: fix error code in ext4_commit_super

Zhang Yi <yi.zhang@huawei.com>
    ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix check to prevent false positive report of incorrect used inodes

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: update config_data.gz only when the content of .config is changed

Sean Christopherson <seanjc@google.com>
    x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

Thomas Gleixner <tglx@linutronix.de>
    Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")

Yang Yang <yang.yang29@zte.com.cn>
    jffs2: check the validity of dstlen in jffs2_zlib_compress()

Linus Torvalds <torvalds@linux-foundation.org>
    Fix misc new gcc warnings

Arnd Bergmann <arnd@arndb.de>
    security: commoncap: fix -Wstringop-overread warning

Vivek Goyal <vgoyal@redhat.com>
    fuse: fix write deadlock

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

Paul Clements <paul.clements@us.sios.com>
    md/raid1: properly indicate failure when ending a failed write request

Eric Biggers <ebiggers@google.com>
    crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS

Stefan Berger <stefanb@linux.ibm.com>
    tpm: vtpm_proxy: Avoid reading host log when using a virtual device

Stefan Berger <stefanb@linux.ibm.com>
    tpm: efi: Use local variable for calculating final log size

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Alder Lake-M support

Tony Ambardar <tony.ambardar@gmail.com>
    powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

lizhe <lizhe67@huawei.com>
    jffs2: Fix kasan slab-out-of-bounds problem

Hansem Ro <hansemro@outlook.com>
    Input: ili210x - add missing negation for touch indication on ili210x

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't discard segments marked for return in _pnfs_return_layout()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't discard pNFS layout segments that are marked for return

Marc Zyngier <maz@kernel.org>
    ACPI: GTDT: Don't corrupt interrupt mappings on watchdow probe failure

Davide Caratti <dcaratti@redhat.com>
    openvswitch: fix stack OOB read while fragmenting IPv4 packets

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_mr: Update egress RIF list before route's action

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-bounds memory access

Guochun Mao <guochun.mao@mediatek.com>
    ubifs: Only check replay with inode type to judge if inode linked

Luis Henriques <lhenriques@suse.de>
    virtiofs: fix memory leak in virtio_fs_probe()

Nathan Chancellor <nathan@kernel.org>
    Makefile: Move -Wno-unused-but-set-variable out of GCC only block

Bill Wendling <morbo@google.com>
    arm64/vdso: Discard .note.gnu.property sections in vDSO

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when picking most recent mod log operation for an old root

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx

Sami Loone <sami@loone.fi>
    ALSA: hda/realtek: fix static noise on ALC285 Lenovo laptops

Phil Calvin <phil@philcalvin.com>
    ALSA: hda/realtek: fix mic boost on Intel NUC 8

Luke D Jones <luke@ljones.dev>
    ALSA: hda/realtek: GA503 use same quirks as GA401

Timo Gurr <timo.gurr@gmail.com>
    ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: More constifications

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Explicitly set up the clock selector

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: sb: Fix two use after free in snd_sb_qsound_build

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Re-order CX5066 quirk table entries

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer

Harald Freudenberger <freude@linux.ibm.com>
    s390/archrandom: add parameter check for s390_arch_random_generate

Bart Van Assche <bvanassche@acm.org>
    scsi: libfc: Fix a format specifier

Dinghao Liu <dinghao.liu@zju.edu.cn>
    mfd: arizona: Fix rumtime PM imbalance on error

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix error handling for mailboxes completed in MBX_POLL mode

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix NULL pointer dereference

Arnd Bergmann <arnd@arndb.de>
    amdgpu: avoid incorrect %hu format string

Qu Huang <jinsdb@126.com>
    drm/amdkfd: Fix cat debugfs hang_hws file causes system crash bug

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/mdp5: Do not multiply vclk line count by 100

Marijn Suijten <marijn.suijten@somainline.org>
    drm/msm/mdp5: Configure PP_SYNC_HEIGHT to double the vtotal

Lingutla Chandrasekhar <clingutla@codeaurora.org>
    sched/fair: Ignore percpu threads for imbalance pulls

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gscpa/stv06xx: fix memory leak

Pavel Skripkin <paskripkin@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init

Dinghao Liu <dinghao.liu@zju.edu.cn>
    media: platform: sti: Fix runtime PM imbalance in regs_show

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: adv7842: fix possible use-after-free in adv7842_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: tda1997: Fix possible use-after-free in tda1997x_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: i2c: adv7511-v4l2: fix possible use-after-free in adv7511_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: adv7604: fix possible use-after-free in adv76xx_remove()

Yang Yingliang <yangyingliang@huawei.com>
    media: tc358743: fix possible use-after-free in tc358743_remove()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: s3c_adc_battery: fix possible use-after-free in s3c_adc_bat_remove()

Yang Yingliang <yangyingliang@huawei.com>
    power: supply: generic-adc-battery: fix possible use-after-free in gab_remove()

Colin Ian King <colin.king@canonical.com>
    clk: socfpga: arria10: Fix memory leak of socfpga_clk on error return

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: vivid: update EDID

Muhammad Usama Anjum <musamaanjum@gmail.com>
    media: em28xx: fix memory leak

Ewan D. Milne <emilne@redhat.com>
    scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Kevin Barnett <kevin.barnett@microchip.com>
    scsi: smartpqi: Add new PCI IDs

Murthy Bhat <Murthy.Bhat@microchip.com>
    scsi: smartpqi: Correct request leakage during reset operations

Xingui Yang <yangxingui@huawei.com>
    ata: ahci: Disable SXS for Hisilicon Kunpeng920

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Add PCI IDs for Intel LKF

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free in bsg

Dmitry Vyukov <dvyukov@google.com>
    drm/vkms: fix misuse of WARN_ON

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix dml prefetch validation

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: Fix UBSAN warning for not a valid value for type '_Bool'

shaoyunl <shaoyun.liu@amd.com>
    drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f

Anson Jacob <Anson.Jacob@amd.com>
    drm/amdkfd: Fix UBSAN shift-out-of-bounds warning

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdgpu: mask the xgmi number of hops reported from psp to kfd

dongjian <dongjian@yulong.com>
    power: supply: Use IRQF_ONESHOT

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca/sq905.c: fix uninitialized variable

Daniel Niv <danielniv3@gmail.com>
    media: media/saa7164: fix saa7164_encoder_register() memory leak bugs

Hans de Goede <hdegoede@redhat.com>
    extcon: arizona: Fix various races on driver unbind

Hans de Goede <hdegoede@redhat.com>
    extcon: arizona: Fix some issues when HPDET IRQ fires after the jack has been unplugged

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    power: supply: bq27xxx: fix power_avg for newer ICs

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()

Julian Braha <julianbraha@gmail.com>
    media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB

Sean Young <sean@mess.org>
    media: ite-cir: check for receive overflow

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix pt2pt connection does not recover after LOGO

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Don't optimize bandwidth before disabling planes

Eryk Brol <eryk.brol@amd.com>
    drm/amd/display: Check for DSC support instead of ASIC revision

Gerd Hoffmann <kraxel@redhat.com>
    drm/qxl: release shadow on shutdown

Jared Baldridge <jrb@expunge.us>
    drm: Added orientation quirk for OneGX1 Pro

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmc_core: Don't use global pmcdev in quirks

Shixin Liu <liushixin2@huawei.com>
    crypto: omap-aes - Fix PM reference leak on omap-aes.c

Shixin Liu <liushixin2@huawei.com>
    crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c

Shixin Liu <liushixin2@huawei.com>
    crypto: stm32/hash - Fix PM reference leak on stm32-hash.c

Yang Yingliang <yangyingliang@huawei.com>
    phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()

Pavel Machek <pavel@ucw.cz>
    intel_th: Consistency and off-by-one fix

Hillf Danton <hdanton@sina.com>
    tty: n_gsm: check error while registering tty devices

Bixuan Cui <cuibixuan@huawei.com>
    usb: core: hub: Fix PM reference leak in usb_port_resume()

Bixuan Cui <cuibixuan@huawei.com>
    usb: musb: fix PM reference leak in musb_irq_work()

Wang Li <wangli74@huawei.com>
    spi: qup: fix PM reference leak in spi_qup_remove()

Wei Yongjun <weiyongjun1@huawei.com>
    spi: omap-100k: Fix reference leak to master

Wei Yongjun <weiyongjun1@huawei.com>
    spi: dln2: Fix reference leak to master

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix potential array out of bounds with several interrupters

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check control context is valid before dereferencing it.

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: support quirk to disable usb2 lpm

Robin Murphy <robin.murphy@arm.com>
    perf/arm_pmu_platform: Fix error handling

Jerome Forissier <jerome@forissier.org>
    tee: optee: do not check memref size on return from Secure World

John Millikin <john@john-millikin.com>
    x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Do not read power state in pci_enable_device_flags()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: xhci: Fix port minor revision

Wesley Cheng <wcheng@codeaurora.org>
    usb: dwc3: gadget: Ignore EP queue requests during bus reset

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac1: validate input parameters

Ruslan Bilovol <ruslan.bilovol@gmail.com>
    usb: gadget: f_uac2: validate input parameters

Vitaly Kuznetsov <vkuznets@redhat.com>
    genirq/matrix: Prevent allocation counter corruption

Pawel Laszczak <pawell@cadence.com>
    usb: webcam: Invalid size of Processing Unit Descriptor

Pawel Laszczak <pawell@cadence.com>
    usb: gadget: uvc: add bInterval checking for HS mode

Hui Tang <tanghui20@huawei.com>
    crypto: qat - fix unmap invalid dma address

Ard Biesheuvel <ardb@kernel.org>
    crypto: api - check for ERR pointers in crypto_destroy_tfm()

David Bauer <mail@david-bauer.net>
    spi: ath79: remove spi-master setup and cleanup assignment

David Bauer <mail@david-bauer.net>
    spi: ath79: always call chipselect function

karthik alapati <mail@karthek.com>
    staging: wimax/i2400m: fix byte-order issue

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first

Phillip Potter <phil@philpotter.co.uk>
    fbdev: zero-fill colormap in fbcmap.c

Chen Jun <chenjun102@huawei.com>
    posix-timers: Preserve return value in clock_adjtime32()

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Rocket Lake CPU support

Filipe Manana <fdmanana@suse.com>
    btrfs: fix metadata extent leak after failure to create subvolume

Paul Aurich <paul@darkrain42.org>
    cifs: Return correct error code from smb2_get_enc_key

He Ying <heying24@huawei.com>
    irqchip/gic-v3: Do not enable irqs when handling spurious interrups

Christoph Hellwig <hch@lst.de>
    modules: inherit TAINT_PROPRIETARY_MODULE

Christoph Hellwig <hch@lst.de>
    modules: return licensing information from find_symbol

Christoph Hellwig <hch@lst.de>
    modules: rename the licence field in struct symsearch to license

Christoph Hellwig <hch@lst.de>
    modules: unexport __module_address

Christoph Hellwig <hch@lst.de>
    modules: unexport __module_text_address

Christoph Hellwig <hch@lst.de>
    modules: mark each_symbol_section static

Christoph Hellwig <hch@lst.de>
    modules: mark find_symbol static

Christoph Hellwig <hch@lst.de>
    modules: mark ref_module static

Ulf Hansson <ulf.hansson@linaro.org>
    mmc: core: Fix hanging on I/O during system suspend for removable cards

Seunghui Lee <sh043.lee@samsung.com>
    mmc: core: Set read only for SD cards with permanent write protect bit

DooHyun Hwang <dh0421.hwang@samsung.com>
    mmc: core: Do a power cycle when the CMD11 fails

Avri Altman <avri.altman@wdc.com>
    mmc: block: Issue a cache flush only when it's enabled

Avri Altman <avri.altman@wdc.com>
    mmc: block: Update ext_csd.cache_ctrl if it was written

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Fix initialization of some SD cards for Intel BYT-based controllers

Pradeep P V K <pragalla@codeaurora.org>
    mmc: sdhci: Check for reset prior to DMA address unmap

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: uniphier-sd: Fix a resource leak in the remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mmc: uniphier-sd: Fix an error handling path in uniphier_sd_probe()

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Block PCI config access from userspace during reset

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()

Tudor Ambarus <tudor.ambarus@microchip.com>
    spi: spi-ti-qspi: Free DMA resources

Gao Xiang <hsiangkao@redhat.com>
    erofs: add unsupported inode i_format check

Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
    mtd: rawnand: atmel: Update ecc_stats.corrected counter

Alexander Lobakin <alobakin@pm.me>
    mtd: spinand: core: add missing MODULE_DEVICE_TABLE()

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    ecryptfs: fix kernel panic with null dev_name

Chunfeng Yun <chunfeng.yun@mediatek.com>
    arm64: dts: mt8173: fix property typo of 'phys' in dsi node

Marek Behún <kabel@kernel.org>
    arm64: dts: marvell: armada-37xx: add syscon compatible to NB clk node

Ard Biesheuvel <ardb@kernel.org>
    ARM: 9056/1: decompressor: fix BSS size calculation for LLVM ld.lld

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle commands when closing set_ftrace_filter file

Mark Langsdorf <mlangsdo@redhat.com>
    ACPI: custom_method: fix a possible memory leak

Mark Langsdorf <mlangsdo@redhat.com>
    ACPI: custom_method: fix potential use-after-free issue

Vasily Gorbik <gor@linux.ibm.com>
    s390/disassembler: increase ebpf disasm buffer size


-------------

Diffstat:

 Makefile                                           |  12 +-
 arch/arm/boot/compressed/Makefile                  |   4 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   3 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   2 +-
 arch/arm64/kernel/vdso/vdso.lds.S                  |   8 +-
 arch/powerpc/include/uapi/asm/errno.h              |   1 +
 arch/powerpc/kernel/eeh.c                          |  11 +-
 arch/s390/crypto/arch_random.c                     |   4 +
 arch/s390/kernel/dis.c                             |   2 +-
 arch/x86/Makefile                                  |   1 +
 arch/x86/kernel/cpu/common.c                       |   2 +-
 crypto/api.c                                       |   2 +-
 crypto/rng.c                                       |  10 +-
 drivers/acpi/arm64/gtdt.c                          |  10 +-
 drivers/acpi/custom_method.c                       |   4 +-
 drivers/ata/ahci.c                                 |   5 +
 drivers/ata/ahci.h                                 |   1 +
 drivers/ata/libahci.c                              |   5 +
 drivers/bus/ti-sysc.c                              |  49 ++++++
 drivers/char/tpm/eventlog/common.c                 |   3 +
 drivers/char/tpm/eventlog/efi.c                    |  29 +++-
 drivers/clk/socfpga/clk-gate-a10.c                 |   1 +
 drivers/crypto/omap-aes.c                          |   6 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  11 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   4 +-
 drivers/crypto/stm32/stm32-hash.c                  |   8 +-
 drivers/extcon/extcon-arizona.c                    |  57 +++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   9 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c           |   7 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  17 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   3 +-
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c |   1 +
 .../display/dc/dml/dcn20/display_mode_vba_20v2.c   |   1 +
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  14 ++
 drivers/gpu/drm/i915/intel_pm.c                    |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c   |  18 ++-
 drivers/gpu/drm/qxl/qxl_display.c                  |   4 +
 drivers/gpu/drm/vkms/vkms_crtc.c                   |   3 +-
 drivers/hwtracing/intel_th/gth.c                   |   4 +-
 drivers/hwtracing/intel_th/pci.c                   |  10 ++
 drivers/input/touchscreen/ili210x.c                |   2 +-
 drivers/irqchip/irq-gic-v3.c                       |   8 +-
 drivers/md/dm-integrity.c                          |   1 +
 drivers/md/dm-raid.c                               |  34 +++-
 drivers/md/dm-rq.c                                 |   2 +
 drivers/md/persistent-data/dm-btree-internal.h     |   4 +-
 drivers/md/persistent-data/dm-space-map-common.c   |   2 +
 drivers/md/persistent-data/dm-space-map-common.h   |   8 +-
 drivers/md/raid1.c                                 |   2 +
 drivers/media/dvb-core/dvbdev.c                    |   1 +
 drivers/media/i2c/adv7511-v4l2.c                   |   2 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/i2c/adv7842.c                        |   2 +-
 drivers/media/i2c/tc358743.c                       |   2 +-
 drivers/media/i2c/tda1997x.c                       |   2 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |  20 +--
 drivers/media/pci/sta2x11/Kconfig                  |   1 +
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |   2 +-
 drivers/media/platform/vivid/vivid-core.c          |   6 +-
 drivers/media/rc/ite-cir.c                         |   8 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  90 +++++++----
 drivers/media/usb/dvb-usb/dvb-usb.h                |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   1 +
 drivers/media/usb/gspca/gspca.c                    |   2 +
 drivers/media/usb/gspca/gspca.h                    |   1 +
 drivers/media/usb/gspca/sq905.c                    |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   9 ++
 drivers/mfd/arizona-irq.c                          |   2 +-
 drivers/mmc/core/block.c                           |  16 ++
 drivers/mmc/core/core.c                            |  76 +--------
 drivers/mmc/core/core.h                            |  17 +-
 drivers/mmc/core/host.c                            |  40 ++++-
 drivers/mmc/core/mmc.c                             |   7 +
 drivers/mmc/core/mmc_ops.c                         |   4 +-
 drivers/mmc/core/sd.c                              |   6 +
 drivers/mmc/core/sdio.c                            |  28 +++-
 drivers/mmc/host/sdhci-pci-core.c                  |  29 ++++
 drivers/mmc/host/sdhci-pci.h                       |   2 +
 drivers/mmc/host/sdhci.c                           |  60 +++----
 drivers/mmc/host/uniphier-sd.c                     |   5 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   6 +-
 drivers/mtd/nand/spi/core.c                        |   2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |  30 ++--
 drivers/net/wimax/i2400m/op-rfkill.c               |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   2 +-
 drivers/pci/pci.c                                  |  16 +-
 drivers/perf/arm_pmu_platform.c                    |   2 +-
 drivers/phy/ti/phy-twl4030-usb.c                   |   2 +-
 drivers/platform/x86/intel_pmc_core.c              |  19 ++-
 drivers/power/supply/bq27xxx_battery.c             |  51 +++---
 drivers/power/supply/generic-adc-battery.c         |   2 +-
 drivers/power/supply/lp8788-charger.c              |   2 +-
 drivers/power/supply/pm2301_charger.c              |   2 +-
 drivers/power/supply/s3c_adc_battery.c             |   2 +-
 drivers/power/supply/tps65090-charger.c            |   2 +-
 drivers/power/supply/tps65217_charger.c            |   2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   5 +-
 drivers/scsi/libfc/fc_lport.c                      |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  75 +++++----
 drivers/scsi/lpfc/lpfc_crtn.h                      |   3 -
 drivers/scsi/lpfc/lpfc_hw4.h                       | 174 +--------------------
 drivers/scsi/lpfc/lpfc_init.c                      | 112 +------------
 drivers/scsi/lpfc/lpfc_mbox.c                      |  36 -----
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   1 -
 drivers/scsi/lpfc/lpfc_sli.c                       |  43 ++---
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   4 +
 drivers/scsi/qla2xxx/qla_attr.c                    |   8 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   7 -
 drivers/scsi/smartpqi/smartpqi_init.c              | 160 +++++++++++++++++++
 drivers/spi/spi-ath79.c                            |   3 +-
 drivers/spi/spi-dln2.c                             |   2 +-
 drivers/spi/spi-omap-100k.c                        |   6 +-
 drivers/spi/spi-qup.c                              |   2 +-
 drivers/spi/spi-ti-qspi.c                          |  20 ++-
 drivers/staging/media/imx/imx-media-capture.c      |   2 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  36 +++--
 drivers/target/target_core_pscsi.c                 |   3 +-
 drivers/tee/optee/core.c                           |  10 --
 drivers/tty/n_gsm.c                                |  14 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/usb/core/hub.c                             |   2 +-
 drivers/usb/dwc2/core_intr.c                       |   8 +
 drivers/usb/dwc3/gadget.c                          |  22 ++-
 drivers/usb/gadget/config.c                        |   4 +
 drivers/usb/gadget/function/f_fs.c                 |   3 +-
 drivers/usb/gadget/function/f_uac1.c               |  43 +++++
 drivers/usb/gadget/function/f_uac2.c               |  39 ++++-
 drivers/usb/gadget/function/f_uvc.c                |   8 +-
 drivers/usb/gadget/legacy/webcam.c                 |   1 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |  23 ++-
 drivers/usb/host/xhci-mem.c                        |   9 ++
 drivers/usb/host/xhci-mtk.c                        |   3 +
 drivers/usb/host/xhci-mtk.h                        |   1 +
 drivers/usb/host/xhci.c                            |  14 +-
 drivers/usb/musb/musb_core.c                       |   2 +-
 drivers/video/fbdev/core/fbcmap.c                  |   8 +-
 fs/btrfs/ctree.c                                   |  20 +++
 fs/btrfs/ioctl.c                                   |  18 ++-
 fs/btrfs/relocation.c                              |   6 +-
 fs/cifs/smb2ops.c                                  |   2 +-
 fs/ecryptfs/main.c                                 |   6 +
 fs/erofs/erofs_fs.h                                |   3 +
 fs/erofs/inode.c                                   |   7 +
 fs/ext4/ialloc.c                                   |  48 ++++--
 fs/ext4/super.c                                    |   9 +-
 fs/f2fs/node.c                                     |   3 +
 fs/fuse/file.c                                     |  41 +++--
 fs/fuse/fuse_i.h                                   |   1 +
 fs/fuse/virtio_fs.c                                |   1 +
 fs/jffs2/compr_rtime.c                             |   3 +
 fs/jffs2/scan.c                                    |   2 +-
 fs/nfs/pnfs.c                                      |   7 +-
 fs/ubifs/replay.c                                  |   3 +-
 include/crypto/acompress.h                         |   2 +
 include/crypto/aead.h                              |   2 +
 include/crypto/akcipher.h                          |   2 +
 include/crypto/hash.h                              |   4 +
 include/crypto/kpp.h                               |   2 +
 include/crypto/rng.h                               |   2 +
 include/crypto/skcipher.h                          |   2 +
 include/linux/mmc/host.h                           |   3 -
 include/linux/module.h                             |  26 +--
 include/linux/power/bq27xxx_battery.h              |   1 -
 include/scsi/libfcoe.h                             |   2 +-
 include/uapi/linux/usb/video.h                     |   3 +-
 kernel/.gitignore                                  |   1 +
 kernel/Makefile                                    |   9 +-
 kernel/futex.c                                     |   3 +-
 kernel/irq/matrix.c                                |   4 +-
 kernel/module.c                                    |  60 +++++--
 kernel/sched/fair.c                                |   4 +
 kernel/time/posix-timers.c                         |   4 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace.c                               |  41 ++---
 kernel/trace/trace_clock.c                         |  44 ++++--
 net/bluetooth/ecdh_helper.h                        |   2 +-
 net/openvswitch/actions.c                          |   8 +-
 security/commoncap.c                               |   2 +-
 sound/isa/sb/emu8000.c                             |   4 +-
 sound/isa/sb/sb16_csp.c                            |   8 +-
 sound/pci/hda/patch_conexant.c                     |  14 +-
 sound/pci/hda/patch_realtek.c                      |  25 ++-
 sound/usb/clock.c                                  |  18 ++-
 sound/usb/mixer.c                                  |  60 +++----
 sound/usb/mixer_maps.c                             |  68 ++++----
 sound/usb/mixer_quirks.c                           |   6 +-
 sound/usb/mixer_scarlett.c                         |  14 +-
 sound/usb/proc.c                                   |   2 +-
 sound/usb/stream.c                                 |   4 +-
 sound/usb/validate.c                               |   4 +-
 196 files changed, 1542 insertions(+), 1052 deletions(-)


