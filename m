Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F9C378325
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhEJKm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhEJKky (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FA6461919;
        Mon, 10 May 2021 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642692;
        bh=MQJjGvadZTvK9VDa+j+2jkzUuFhX00NkeqSDSKHXN0I=;
        h=From:To:Cc:Subject:Date:From;
        b=mRCVWMfL+f2z+1PrtWyM3hIslmaZwXbNp3EkfMUUiRMyJa8C27Qq9gNeGYwZTHhbL
         7fp6TP2vzzLc4yFF60OCK1wnHs7u01S0UfnNqTT8aqF42UXf/Kq3/bT9CEhPbrPMRb
         p2wA3GFsAWPF3KNrYVlPc7IoVHWiZa+0yhvNsRtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/299] 5.10.36-rc1 review
Date:   Mon, 10 May 2021 12:16:37 +0200
Message-Id: <20210510102004.821838356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.36-rc1
X-KernelTest-Deadline: 2021-05-12T10:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.36 release.
There are 299 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.36-rc1

Lukasz Luba <lukasz.luba@arm.com>
    thermal/core/fair share: Lock the thermal zone while looping over instances

brian-sy yang <brian-sy.yang@mediatek.com>
    thermal/drivers/cpufreq_cooling: Fix slab OOB issue

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    lib/vsprintf.c: remove leftover 'f' and 'F' cases from bstr_printf()

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

Calvin Walton <calvin.walton@kepstin.ca>
    tools/power turbostat: Fix offset overflow issue in index converting

Marek Vasut <marex@denx.de>
    rsi: Use resume_noirq for SDIO

Pavel Skripkin <paskripkin@gmail.com>
    tty: fix memory leak in vc_deallocate

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix session request interrupt handler

Yu Chen <chenyu56@huawei.com>
    usb: dwc3: core: Do core softreset when switch mode

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Fix START_TRANSFER link state check

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Remove FS bInterval_m1 limitation

Dean Anderson <dean@sensoray.com>
    usb: gadget/function/f_fs string table fix for multiple languages

Hemant Kumar <hemantk@codeaurora.org>
    usb: gadget: Fix double free of device descriptor pointers

Anirudh Rayabharam <mail@anirudhrb.com>
    usb: gadget: dummy_hcd: fix gpf in gadget_setup

Stanimir Varbanov <stanimir.varbanov@linaro.org>
    media: venus: hfi_parser: Don't initialize parser on v1

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls: fix reference to freed memory

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

Jan Kara <jack@suse.cz>
    ext4: Fix occasional generic/418 failure

Theodore Ts'o <tytso@mit.edu>
    ext4: allow the dax flag to be set and cleared on inline directories

Xu Yihang <xuyihang@huawei.com>
    ext4: fix error return code in ext4_fc_perform_commit()

Ye Bin <yebin10@huawei.com>
    ext4: fix ext4_error_err save negative errno into superblock

Fengnan Chang <changfengnan@vivo.com>
    ext4: fix error code in ext4_commit_super

Zhang Yi <yi.zhang@huawei.com>
    ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix check to prevent false positive report of incorrect used inodes

Jan Kara <jack@suse.cz>
    ext4: annotate data race in jbd2_journal_dirty_metadata()

Jan Kara <jack@suse.cz>
    ext4: annotate data race in start_this_handle()

Masahiro Yamada <masahiroy@kernel.org>
    kbuild: update config_data.gz only when the content of .config is changed

Sean Christopherson <seanjc@google.com>
    x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is supported

Thomas Gleixner <tglx@linutronix.de>
    futex: Do not apply time namespace adjustment on FUTEX_LOCK_PI

Thomas Gleixner <tglx@linutronix.de>
    Revert 337f13046ff0 ("futex: Allow FUTEX_CLOCK_REALTIME with FUTEX_WAIT op")

Steve French <stfrench@microsoft.com>
    smb3: do not attempt multichannel to server which does not support it

Steve French <stfrench@microsoft.com>
    smb3: when mounting with multichannel include it in requested capabilities

Yang Yang <yang.yang29@zte.com.cn>
    jffs2: check the validity of dstlen in jffs2_zlib_compress()

Linus Torvalds <torvalds@linux-foundation.org>
    Fix misc new gcc warnings

Arnd Bergmann <arnd@arndb.de>
    security: commoncap: fix -Wstringop-overread warning

Edward Cree <ecree.xilinx@gmail.com>
    sfc: farch: fix TX queue lookup in TX event handling

Edward Cree <ecree.xilinx@gmail.com>
    sfc: farch: fix TX queue lookup in TX flush done handling

Hyeongseok Kim <hyeongseok@gmail.com>
    exfat: fix erroneous discard when clear cluster bit

Vivek Goyal <vgoyal@redhat.com>
    fuse: fix write deadlock

Heinz Mauelshagen <heinzm@redhat.com>
    dm raid: fix inconclusive reshape layout on fast raid4/5/6 table reload sequences

Paul Clements <paul.clements@us.sios.com>
    md/raid1: properly indicate failure when ending a failed write request

Eric Biggers <ebiggers@google.com>
    crypto: rng - fix crypto_rng_reset() refcounting when !CRYPTO_STATS

Nathan Chancellor <nathan@kernel.org>
    crypto: arm/curve25519 - Move '.fpu' after '.arch'

Stefan Berger <stefanb@linux.ibm.com>
    tpm: vtpm_proxy: Avoid reading host log when using a virtual device

Stefan Berger <stefanb@linux.ibm.com>
    tpm: efi: Use local variable for calculating final log size

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Alder Lake-M support

Tony Ambardar <tony.ambardar@gmail.com>
    powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32: Fix boot failure with CONFIG_STACKPROTECTOR

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc/kexec_file: Use current CPU info while setting up FDT

Mahesh Salgaonkar <mahesh@linux.ibm.com>
    powerpc/eeh: Fix EEH handling for hugepages in ioremap space.

Nicholas Piggin <npiggin@gmail.com>
    powerpc/powernv: Enable HAIL (HV AIL) for ISA v3.1 processors

Joel Stanley <joel@jms.id.au>
    jffs2: Hook up splice_write callback

lizhe <lizhe67@huawei.com>
    jffs2: Fix kasan slab-out-of-bounds problem

Hansem Ro <hansemro@outlook.com>
    Input: ili210x - add missing negation for touch indication on ili210x

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't discard segments marked for return in _pnfs_return_layout()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't discard pNFS layout segments that are marked for return

Randy Dunlap <rdunlap@infradead.org>
    NFS: fs_context: validate UDP retrans to prevent shift out-of-bounds

Marc Zyngier <maz@kernel.org>
    ACPI: GTDT: Don't corrupt interrupt mappings on watchdow probe failure

Davide Caratti <dcaratti@redhat.com>
    openvswitch: fix stack OOB read while fragmenting IPv4 packets

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_mr: Update egress RIF list before route's action

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid out-of-bounds memory access

Eric Biggers <ebiggers@google.com>
    f2fs: fix error handling in f2fs_end_enable_verity()

Guochun Mao <guochun.mao@mediatek.com>
    ubifs: Only check replay with inode type to judge if inode linked

Marco Elver <elver@google.com>
    kcsan, debugfs: Move debugfs file creation out of early init

Luis Henriques <lhenriques@suse.de>
    virtiofs: fix memory leak in virtio_fs_probe()

Theodore Ts'o <tytso@mit.edu>
    fs: fix reporting supported extra file attributes for statx()

Nathan Chancellor <nathan@kernel.org>
    Makefile: Move -Wno-unused-but-set-variable out of GCC only block

Bill Wendling <morbo@google.com>
    arm64/vdso: Discard .note.gnu.property sections in vDSO

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race when picking most recent mod log operation for an old root

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    tools/power/turbostat: Fix turbostat for AMD Zen CPUs

Eckhart Mohr <e.mohr@tuxedocomputers.com>
    ALSA: hda/realtek: Add quirk for Intel Clevo PCx0Dx

Sami Loone <sami@loone.fi>
    ALSA: hda/realtek: fix static noise on ALC285 Lenovo laptops

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Headset Mic issue on HP platform

Phil Calvin <phil@philcalvin.com>
    ALSA: hda/realtek: fix mic boost on Intel NUC 8

Luke D Jones <luke@ljones.dev>
    ALSA: hda/realtek: GA503 use same quirks as GA401

Jonas Witschel <diabonas@archlinux.org>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G7

Timo Gurr <timo.gurr@gmail.com>
    ALSA: usb-audio: Add dB range mapping for Sennheiser Communications Headset PC 8

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Explicitly set up the clock selector

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: sb: Fix two use after free in snd_sb_qsound_build

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/conexant: Re-order CX5066 quirk table entries

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ALSA: emu8000: Fix a use after free in snd_emu8000_create_mixer

Guangqing Zhu <zhuguangqing83@gmail.com>
    power: supply: cpcap-battery: fix invalid usage of list cursor

Charan Teja Reddy <charante@codeaurora.org>
    sched,psi: Handle potential task count underflow bugs more gracefully

Harald Freudenberger <freude@linux.ibm.com>
    s390/archrandom: add parameter check for s390_arch_random_generate

Gioh Kim <gi-oh.kim@cloud.ionos.com>
    block/rnbd-clt: Fix missing a memory free when unloading the module

Peter Zijlstra <peterz@infradead.org>
    sched,fair: Alternative sched_slice()

Peter Zijlstra <peterz@infradead.org>
    perf: Rework perf_event_exit_event()

Bart Van Assche <bvanassche@acm.org>
    scsi: libfc: Fix a format specifier

Dinghao Liu <dinghao.liu@zju.edu.cn>
    mfd: arizona: Fix rumtime PM imbalance on error

Hubert Streidl <hubert.streidl@de.bosch.com>
    mfd: da9063: Support SMBus and I2C mode

Xu Yilun <yilun.xu@intel.com>
    mfd: intel-m10-bmc: Fix the register access range

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix error handling for mailboxes completed in MBX_POLL mode

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: fix NULL pointer dereference

Werner Sembach <wse@tuxedocomputers.com>
    drm/amd/display: Try YCbCr420 color when YCbCr444 fails

Arnd Bergmann <arnd@arndb.de>
    amdgpu: avoid incorrect %hu format string

Qu Huang <jinsdb@126.com>
    drm/amdkfd: Fix cat debugfs hang_hws file causes system crash bug

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: Fix UBSAN: shift-out-of-bounds warning

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Fix debugfs link_settings entry

Daniel Gomez <daniel@qtec.com>
    drm/radeon/ttm: Fix memory leak userptr pages

Daniel Gomez <daniel@qtec.com>
    drm/amdgpu/ttm: Fix memory leak userptr pages

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
    media: sun8i-di: Fix runtime PM imbalance in deinterlace_start_streaming

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

Abhinav Kumar <abhinavk@codeaurora.org>
    drm/msm/dp: Fix incorrect NULL check kbot warnings in DP driver

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

Don Brace <don.brace@microchip.com>
    scsi: smartpqi: Use host-wide tag space

Carl Philipp Klemm <philipp@uvos.xyz>
    power: supply: cpcap-charger: Add usleep to cpcap charger to avoid usb plug bounce

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Fix checking for < 0 for unsigned values

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Fix incorrect parsing of iMC counters

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Use resctrl/info for feature detection

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Fix missing options "-n" and "-p"

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Clean up resctrl features check

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Fix compilation issues for other global variables

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Fix compilation issues for global variables

Fenghua Yu <fenghua.yu@intel.com>
    selftests/resctrl: Enable gcc checks to detect buffer overflows

Hou Pu <houpu.main@gmail.com>
    nvmet: return proper error code from discovery ctrl

Carsten Haitzler <carsten.haitzler@arm.com>
    drm/komeda: Fix bit check to import to value of proper type

Xingui Yang <yangxingui@huawei.com>
    ata: ahci: Disable SXS for Hisilicon Kunpeng920

Al Cooper <alcooperx@gmail.com>
    mmc: sdhci-brcmstb: Remove CQE quirk

Adrian Hunter <adrian.hunter@intel.com>
    mmc: sdhci-pci: Add PCI IDs for Intel LKF

Peng Fan <peng.fan@nxp.com>
    mmc: sdhci-esdhc-imx: validate pinctrl before use it

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix use after free in bsg

Dmitry Vyukov <dvyukov@google.com>
    drm/vkms: fix misuse of WARN_ON

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()

Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
    drm/amd/display: fix dml prefetch validation

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: DCHUB underflow counter increasing in some scenarios

Anson Jacob <Anson.Jacob@amd.com>
    drm/amd/display: Fix UBSAN warning for not a valid value for type '_Bool'

Kenneth Feng <kenneth.feng@amd.com>
    drm/amd/pm: fix workload mismatch on vega10

shaoyunl <shaoyun.liu@amd.com>
    drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f

Anson Jacob <Anson.Jacob@amd.com>
    drm/amdkfd: Fix UBSAN shift-out-of-bounds warning

Jonathan Kim <jonathan.kim@amd.com>
    drm/amdgpu: mask the xgmi number of hops reported from psp to kfd

Kiran Gunda <kgunda@codeaurora.org>
    backlight: qcom-wled: Fix FSC update issue for WLED5

Obeida Shamoun <oshmoun100@googlemail.com>
    backlight: qcom-wled: Use sink_addr for sync toggle

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

Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
    atomisp: don't let it go past pipes array

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    media: imx: capture: Return -EPIPE from __capture_legacy_try_fmt()

Julian Braha <julianbraha@gmail.com>
    media: drivers: media: pci: sta2x11: fix Kconfig dependency on GPIOLIB

Sean Young <sean@mess.org>
    media: ite-cir: check for receive overflow

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    scsi: target: pscsi: Fix warning in pscsi_complete_cmd()

Uladzislau Rezki (Sony) <urezki@gmail.com>
    kvfree_rcu: Use same set of GFP flags as does single-argument

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/pelt: Fix task util_est update filtering

Emily Deng <Emily.Deng@amd.com>
    drm/amdgpu: Fix some unload driver issues

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix pt2pt connection does not recover after LOGO

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe

Lee Jones <lee.jones@linaro.org>
    drm/amd/display/dc/dce/dce_aux: Remove duplicate line causing 'field overwritten' issue

Xiaogang Chen <xiaogang.chen@amd.com>
    drm/amdgpu/display: buffer INTERRUPT_LOW_IRQ_CONTEXT interrupt work

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Don't optimize bandwidth before disabling planes

Eryk Brol <eryk.brol@amd.com>
    drm/amd/display: Check for DSC support instead of ASIC revision

Tong Zhang <ztong0001@gmail.com>
    drm/ast: fix memory leak when unload the driver

Martin Leung <martin.leung@amd.com>
    drm/amd/display: changing sr exit latency

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Fix invalid usage of AST_MAX_HWC_WIDTH in cursor atomic_check

Gerd Hoffmann <kraxel@redhat.com>
    drm/qxl: release shadow on shutdown

Tong Zhang <ztong0001@gmail.com>
    drm/qxl: do not run release if qxl failed to init

Jared Baldridge <jrb@expunge.us>
    drm: Added orientation quirk for OneGX1 Pro

Josef Bacik <josef@toxicpanda.com>
    btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s

Josef Bacik <josef@toxicpanda.com>
    btrfs: do proper error handling in btrfs_update_reloc_root

Josef Bacik <josef@toxicpanda.com>
    btrfs: do proper error handling in create_reloc_root

David Bauer <mail@david-bauer.net>
    spi: sync up initial chipselect state

David E. Box <david.e.box@linux.intel.com>
    platform/x86: intel_pmc_core: Don't use global pmcdev in quirks

Shixin Liu <liushixin2@huawei.com>
    crypto: omap-aes - Fix PM reference leak on omap-aes.c

Shixin Liu <liushixin2@huawei.com>
    crypto: sa2ul - Fix PM reference leak in sa_ul_probe()

Shixin Liu <liushixin2@huawei.com>
    crypto: stm32/cryp - Fix PM reference leak on stm32-cryp.c

Shixin Liu <liushixin2@huawei.com>
    crypto: stm32/hash - Fix PM reference leak on stm32-hash.c

Shixin Liu <liushixin2@huawei.com>
    crypto: sun8i-ce - Fix PM reference leak in sun8i_ce_probe()

Shixin Liu <liushixin2@huawei.com>
    crypto: sun8i-ss - Fix PM reference leak when pm_runtime_get_sync() fails

Yang Yingliang <yangyingliang@huawei.com>
    phy: phy-twl4030-usb: Fix possible use-after-free in twl4030_usb_remove()

Pavel Machek <pavel@ucw.cz>
    intel_th: Consistency and off-by-one fix

Hillf Danton <hdanton@sina.com>
    tty: n_gsm: check error while registering tty devices

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Check for disabled LPM quirk

Bixuan Cui <cuibixuan@huawei.com>
    usb: core: hub: Fix PM reference leak in usb_port_resume()

Bixuan Cui <cuibixuan@huawei.com>
    usb: musb: fix PM reference leak in musb_irq_work()

Yang Yingliang <yangyingliang@huawei.com>
    usb: gadget: tegra-xudc: Fix possible use-after-free in tegra_xudc_remove()

Wang Li <wangli74@huawei.com>
    spi: qup: fix PM reference leak in spi_qup_remove()

Wei Yongjun <weiyongjun1@huawei.com>
    spi: omap-100k: Fix reference leak to master

Wei Yongjun <weiyongjun1@huawei.com>
    spi: dln2: Fix reference leak to master

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    platform/x86: ISST: Account for increased timeout in some cases

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    tools/power/x86/intel-speed-select: Increase string size

Ludovic Desroches <ludovic.desroches@microchip.com>
    ARM: dts: at91: change the key code of the gpio key

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: core: Clear context for stopped channels from remove()

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix potential array out of bounds with several interrupters

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check control context is valid before dereferencing it.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: check port array allocation was successful before dereferencing it

Russ Weight <russell.h.weight@intel.com>
    fpga: dfl: pci: add DID for D5005 PAC cards

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: support quirk to disable usb2 lpm

Eric Biggers <ebiggers@google.com>
    random: initialize ChaCha20 constants with correct endianness

Robin Murphy <robin.murphy@arm.com>
    perf/arm_pmu_platform: Fix error handling

Robin Murphy <robin.murphy@arm.com>
    perf/arm_pmu_platform: Use dev_err_probe() for IRQ errors

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: cadence: only prepare attached devices on clock stop

Jerome Forissier <jerome@forissier.org>
    tee: optee: do not check memref size on return from Secure World

Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
    arm64: dts: imx8mq-librem5-r3: Mark buck3 as always on

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: pmc: Fix completion of power-gate toggling

Nathan Chancellor <nathan@kernel.org>
    efi/libstub: Add $(CLANG_FLAGS) to x86 flags

Nathan Chancellor <nathan@kernel.org>
    x86/boot: Add $(CLANG_FLAGS) to compressed KBUILD_CFLAGS

John Millikin <john@john-millikin.com>
    x86/build: Propagate $(CLANG_FLAGS) to $(REALMODE_FLAGS)

Linus Walleij <linus.walleij@linaro.org>
    ARM: dts: ux500: Fix up TVK R3 sensors

Rafał Miłecki <rafal@milecki.pl>
    ARM: dts: BCM5301X: fix "reg" formatting in /memory node

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: Fix MTE feature detection

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: PM: Do not read power state in pci_enable_device_flags()

Dmitry Osipenko <digetx@gmail.com>
    ARM: tegra: acer-a500: Rename avdd to vdda of touchscreen node

Andre Przywara <andre.przywara@arm.com>
    kselftest/arm64: mte: Fix compilation with native compiler

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

Longfang Liu <liulongfang@huawei.com>
    crypto: hisilicon/sec - fixes a printing error

Joerg Roedel <jroedel@suse.de>
    x86/sev: Do not require Hypervisor CPUID bit for SEV guests

Pawel Laszczak <pawell@cadence.com>
    usb: webcam: Invalid size of Processing Unit Descriptor

Pawel Laszczak <pawell@cadence.com>
    usb: gadget: uvc: add bInterval checking for HS mode

Hui Tang <tanghui20@huawei.com>
    crypto: qat - fix unmap invalid dma address

Ard Biesheuvel <ardb@kernel.org>
    crypto: api - check for ERR pointers in crypto_destroy_tfm()

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: core: Destroy SBL devices when moving to mission mode

David Bauer <mail@david-bauer.net>
    spi: ath79: remove spi-master setup and cleanup assignment

David Bauer <mail@david-bauer.net>
    spi: ath79: always call chipselect function

karthik alapati <mail@karthek.com>
    staging: wimax/i2400m: fix byte-order issue

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Probe for l4_wkup and l4_cfg interconnect devices first

Dmitry Osipenko <digetx@gmail.com>
    cpuidle: tegra: Fix C7 idling state on Tegra114

Phillip Potter <phil@philpotter.co.uk>
    fbdev: zero-fill colormap in fbcmap.c

Chen Jun <chenjun102@huawei.com>
    posix-timers: Preserve return value in clock_adjtime32()

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between transaction aborts and fsyncs leading to use-after-free

Alexander Shishkin <alexander.shishkin@linux.intel.com>
    intel_th: pci: Add Rocket Lake CPU support

Filipe Manana <fdmanana@suse.com>
    btrfs: fix metadata extent leak after failure to create subvolume

Maciej W. Rozycki <macro@orcam.me.uk>
    x86/build: Disable HIGHMEM64G selection for M486SX

Qu Wenruo <wqu@suse.com>
    btrfs: handle remount to no compress during compression

Aurelien Aptel <aaptel@suse.com>
    smb2: fix use-after-free in smb2_ioctl_query_info()

Shyam Prasad N <sprasad@microsoft.com>
    cifs: detect dead connections only when echoes are enabled.

Eugene Korenevsky <ekorenevsky@astralinux.ru>
    cifs: fix out-of-bound memory access when calling smb3_notify() at mount point

Paul Aurich <paul@darkrain42.org>
    cifs: Return correct error code from smb2_get_enc_key

He Ying <heying24@huawei.com>
    irqchip/gic-v3: Do not enable irqs when handling spurious interrups

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

Aniruddha Tvs Rao <anrao@nvidia.com>
    mmc: sdhci-tegra: Add required callbacks to set/clear CQE_EN bit

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

Christophe Kerello <christophe.kerello@foss.st.com>
    spi: stm32-qspi: fix pm_runtime usage_count counter

Gao Xiang <hsiangkao@redhat.com>
    erofs: add unsupported inode i_format check

Gustavo A. R. Silva <gustavoars@kernel.org>
    mtd: physmap: physmap-bt1-rom: Fix unintentional stack access

Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
    mtd: rawnand: atmel: Update ecc_stats.corrected counter

Alexander Lobakin <alobakin@pm.me>
    mtd: spinand: core: add missing MODULE_DEVICE_TABLE()

Tudor Ambarus <tudor.ambarus@microchip.com>
    Revert "mtd: spi-nor: macronix: Add support for mx25l51245g"

Xiang Chen <chenxiang66@hisilicon.com>
    mtd: spi-nor: core: Fix an issue of releasing resources during read/write

Davidlohr Bueso <dave@stgolabs.net>
    fs/epoll: restore waking from ep_done_scan()

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

Stefan Berger <stefanb@linux.ibm.com>
    tpm: acpi: Check eventlog signature before using it

Jason Wang <jasowang@redhat.com>
    vhost-vdpa: fix vm_flags for virtqueue doorbell mapping

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: fix zcard and zqueue hot-unplug memleak

Vasily Gorbik <gor@linux.ibm.com>
    s390/disassembler: increase ebpf disasm buffer size

Shuo Chen <shuochen@google.com>
    dyndbg: fix parsing file query without a line-range suffix

Mathias Krause <minipli@grsecurity.net>
    nitro_enclaves: Fix stale file descriptors on failed usercopy

Jeffrey Hugo <jhugo@codeaurora.org>
    bus: mhi: core: Sanity check values from remote device before use

Bhaumik Bhatt <bbhatt@codeaurora.org>
    bus: mhi: core: Clear configuration from channel context during reset

Jeffrey Hugo <jhugo@codeaurora.org>
    bus: mhi: core: Fix check for syserr at power_up


-------------

Diffstat:

 Makefile                                           |  12 +-
 arch/arm/boot/compressed/Makefile                  |   4 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |   3 +-
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts        |   3 +-
 arch/arm/boot/dts/at91-sama5d27_wlsom1_ek.dts      |   3 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |   3 +-
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts          |   3 +-
 arch/arm/boot/dts/at91-sama5d2_xplained.dts        |   3 +-
 arch/arm/boot/dts/at91-sama5d3_xplained.dts        |   3 +-
 arch/arm/boot/dts/at91sam9260ek.dts                |   3 +-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   3 +-
 arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dts        |   4 +-
 arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dts        |   4 +-
 arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dts  |   4 +-
 arch/arm/boot/dts/bcm4708-netgear-r6250.dts        |   4 +-
 arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dts     |   4 +-
 arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts      |   4 +-
 arch/arm/boot/dts/bcm47081-asus-rt-n18u.dts        |   4 +-
 arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts |   4 +-
 arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dts  |   4 +-
 arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dts        |   4 +-
 arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dts  |   4 +-
 arch/arm/boot/dts/bcm4709-linksys-ea9200.dts       |   4 +-
 arch/arm/boot/dts/bcm4709-netgear-r7000.dts        |   4 +-
 arch/arm/boot/dts/bcm4709-netgear-r8000.dts        |   4 +-
 arch/arm/boot/dts/bcm47094-dlink-dir-885l.dts      |   4 +-
 arch/arm/boot/dts/bcm47094-linksys-panamera.dts    |   4 +-
 arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts      |   4 +-
 arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts      |   4 +-
 arch/arm/boot/dts/bcm47094-luxul-xwc-2000.dts      |   4 +-
 arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dts      |   4 +-
 arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dts   |   4 +-
 arch/arm/boot/dts/bcm47094-netgear-r8500.dts       |   4 +-
 arch/arm/boot/dts/bcm47094-phicomm-k3.dts          |   4 +-
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi      |  73 ++++++---
 arch/arm/boot/dts/tegra20-acer-a500-picasso.dts    |   2 +-
 arch/arm/crypto/curve25519-core.S                  |   2 +-
 .../arm64/boot/dts/freescale/imx8mq-librem5-r3.dts |   4 +
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   3 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   2 +-
 arch/arm64/kernel/vdso/vdso.lds.S                  |   8 +-
 arch/powerpc/include/asm/reg.h                     |   1 +
 arch/powerpc/include/uapi/asm/errno.h              |   1 +
 arch/powerpc/kernel/eeh.c                          |  11 +-
 arch/powerpc/kernel/setup_64.c                     |  19 ++-
 arch/powerpc/kexec/file_load_64.c                  |  92 +++++++++++
 arch/powerpc/lib/Makefile                          |   3 +
 arch/s390/crypto/arch_random.c                     |   4 +
 arch/s390/kernel/dis.c                             |   2 +-
 arch/x86/Kconfig                                   |   2 +-
 arch/x86/Makefile                                  |   1 +
 arch/x86/boot/compressed/Makefile                  |   1 +
 arch/x86/boot/compressed/mem_encrypt.S             |   6 -
 arch/x86/kernel/cpu/common.c                       |   2 +-
 arch/x86/kernel/sev-es-shared.c                    |   6 +-
 arch/x86/mm/mem_encrypt_identity.c                 |  35 +++--
 crypto/api.c                                       |   2 +-
 crypto/rng.c                                       |  10 +-
 drivers/acpi/arm64/gtdt.c                          |  10 +-
 drivers/acpi/custom_method.c                       |   4 +-
 drivers/ata/ahci.c                                 |   5 +
 drivers/ata/ahci.h                                 |   1 +
 drivers/ata/libahci.c                              |   5 +
 drivers/block/rnbd/rnbd-clt-sysfs.c                |  10 +-
 drivers/bus/mhi/core/init.c                        |  16 +-
 drivers/bus/mhi/core/main.c                        | 110 +++++++++++--
 drivers/bus/mhi/core/pm.c                          |   5 +-
 drivers/bus/ti-sysc.c                              |  49 ++++++
 drivers/char/random.c                              |   4 +-
 drivers/char/tpm/eventlog/acpi.c                   |  33 +++-
 drivers/char/tpm/eventlog/common.c                 |   3 +
 drivers/char/tpm/eventlog/efi.c                    |  29 +++-
 drivers/clk/socfpga/clk-gate-a10.c                 |   1 +
 drivers/cpuidle/cpuidle-tegra.c                    |  12 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |   2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |   2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c  |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c         |   2 +-
 drivers/crypto/omap-aes.c                          |   6 +-
 drivers/crypto/qat/qat_common/qat_algs.c           |  11 +-
 drivers/crypto/sa2ul.c                             |   2 +-
 drivers/crypto/stm32/stm32-cryp.c                  |   4 +-
 drivers/crypto/stm32/stm32-hash.c                  |   8 +-
 drivers/extcon/extcon-arizona.c                    |  57 +++----
 drivers/firmware/efi/libstub/Makefile              |   3 +-
 drivers/fpga/dfl-pci.c                             |  18 ++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c          |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   9 +-
 drivers/gpu/drm/amd/amdkfd/kfd_debugfs.c           |   7 +-
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |  17 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  17 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |  14 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  15 +-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_irq.c  | 115 +++++++++-----
 .../amd/display/dc/clk_mgr/dcn30/dcn30_clk_mgr.c   |   4 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |   3 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_aux.h       |   1 -
 .../gpu/drm/amd/display/dc/dcn30/dcn30_resource.c  |   2 +-
 .../amd/display/dc/dml/dcn20/display_mode_vba_20.c |   1 +
 .../display/dc/dml/dcn20/display_mode_vba_20v2.c   |   1 +
 .../display/dc/dml/dcn20/display_rq_dlg_calc_20.c  |  28 +++-
 .../dc/dml/dcn20/display_rq_dlg_calc_20v2.c        |  28 +++-
 .../display/dc/dml/dcn21/display_rq_dlg_calc_21.c  |  28 +++-
 .../display/dc/dml/dcn30/display_rq_dlg_calc_30.c  |  28 +++-
 .../amd/display/dc/dml/dml1_display_rq_dlg_calc.c  |  28 +++-
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c  |   2 +-
 drivers/gpu/drm/arm/display/include/malidp_utils.h |   3 -
 .../gpu/drm/arm/display/komeda/komeda_pipeline.c   |  16 +-
 .../drm/arm/display/komeda/komeda_pipeline_state.c |  19 ++-
 drivers/gpu/drm/ast/ast_drv.c                      |   2 +
 drivers/gpu/drm/ast/ast_mode.c                     |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  14 ++
 drivers/gpu/drm/i915/intel_pm.c                    |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_cmd_encoder.c   |  18 ++-
 drivers/gpu/drm/msm/dp/dp_hpd.c                    |   4 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |   4 +
 drivers/gpu/drm/qxl/qxl_drv.c                      |   2 +
 drivers/gpu/drm/radeon/radeon_ttm.c                |   5 +-
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
 drivers/media/platform/qcom/venus/hfi_parser.c     |   6 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c     |   2 +-
 drivers/media/platform/sunxi/sun8i-di/sun8i-di.c   |   2 +-
 drivers/media/rc/ite-cir.c                         |   8 +-
 drivers/media/test-drivers/vivid/vivid-core.c      |   6 +-
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  90 +++++++----
 drivers/media/usb/dvb-usb/dvb-usb.h                |   2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c              |   1 +
 drivers/media/usb/gspca/gspca.c                    |   2 +
 drivers/media/usb/gspca/gspca.h                    |   1 +
 drivers/media/usb/gspca/sq905.c                    |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   9 ++
 drivers/media/v4l2-core/v4l2-ctrls.c               | 137 ++++++++--------
 drivers/mfd/arizona-irq.c                          |   2 +-
 drivers/mfd/da9063-i2c.c                           |  10 ++
 drivers/mmc/core/block.c                           |  16 ++
 drivers/mmc/core/core.c                            |  76 +--------
 drivers/mmc/core/core.h                            |  17 +-
 drivers/mmc/core/host.c                            |  40 ++++-
 drivers/mmc/core/mmc.c                             |   7 +
 drivers/mmc/core/mmc_ops.c                         |   4 +-
 drivers/mmc/core/sd.c                              |   6 +
 drivers/mmc/core/sdio.c                            |  28 +++-
 drivers/mmc/host/sdhci-brcmstb.c                   |   1 -
 drivers/mmc/host/sdhci-esdhc-imx.c                 |   2 +-
 drivers/mmc/host/sdhci-pci-core.c                  |  29 ++++
 drivers/mmc/host/sdhci-pci.h                       |   2 +
 drivers/mmc/host/sdhci-tegra.c                     |  32 ++++
 drivers/mmc/host/sdhci.c                           |  60 +++----
 drivers/mmc/host/uniphier-sd.c                     |   5 +-
 drivers/mtd/maps/physmap-bt1-rom.c                 |   2 +-
 drivers/mtd/nand/raw/atmel/nand-controller.c       |   6 +-
 drivers/mtd/nand/spi/core.c                        |   2 +
 drivers/mtd/spi-nor/core.c                         |  33 ++++
 drivers/mtd/spi-nor/macronix.c                     |   3 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |  30 ++--
 drivers/net/ethernet/sfc/farch.c                   |  16 +-
 drivers/net/wimax/i2400m/op-rfkill.c               |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   2 +-
 drivers/nvme/target/discovery.c                    |   6 +-
 drivers/pci/pci.c                                  |  16 +-
 drivers/perf/arm_pmu_platform.c                    |   9 +-
 drivers/phy/ti/phy-twl4030-usb.c                   |   2 +-
 drivers/platform/x86/intel_pmc_core.c              |  19 ++-
 .../x86/intel_speed_select_if/isst_if_mbox_pci.c   |  33 ++--
 drivers/power/supply/bq27xxx_battery.c             |  51 +++---
 drivers/power/supply/cpcap-battery.c               |   2 +-
 drivers/power/supply/cpcap-charger.c               |   3 +
 drivers/power/supply/generic-adc-battery.c         |   2 +-
 drivers/power/supply/lp8788-charger.c              |   2 +-
 drivers/power/supply/pm2301_charger.c              |   2 +-
 drivers/power/supply/s3c_adc_battery.c             |   2 +-
 drivers/power/supply/tps65090-charger.c            |   2 +-
 drivers/power/supply/tps65217_charger.c            |   2 +-
 drivers/s390/crypto/zcrypt_card.c                  |   1 +
 drivers/s390/crypto/zcrypt_queue.c                 |   1 +
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
 drivers/scsi/smartpqi/smartpqi_init.c              | 161 +++++++++++++++++++
 drivers/soc/tegra/pmc.c                            |  70 ++++++++-
 drivers/soundwire/cadence_master.c                 |  10 +-
 drivers/spi/spi-ath79.c                            |   3 +-
 drivers/spi/spi-dln2.c                             |   2 +-
 drivers/spi/spi-omap-100k.c                        |   6 +-
 drivers/spi/spi-qup.c                              |   2 +-
 drivers/spi/spi-stm32-qspi.c                       |  18 ++-
 drivers/spi/spi-ti-qspi.c                          |  20 ++-
 drivers/spi/spi.c                                  |  16 +-
 drivers/staging/media/atomisp/pci/atomisp_fops.c   |   3 +
 drivers/staging/media/imx/imx-media-capture.c      |   2 +-
 drivers/staging/media/ipu3/ipu3-v4l2.c             |  36 +++--
 drivers/target/target_core_pscsi.c                 |   3 +-
 drivers/tee/optee/core.c                           |  10 --
 drivers/thermal/cpufreq_cooling.c                  |   2 +-
 drivers/thermal/gov_fair_share.c                   |   4 +
 drivers/tty/n_gsm.c                                |  14 +-
 drivers/tty/vt/vt.c                                |   1 +
 drivers/usb/core/hub.c                             |   2 +-
 drivers/usb/dwc2/core_intr.c                       |   8 +
 drivers/usb/dwc3/core.c                            |  29 ++++
 drivers/usb/dwc3/core.h                            |   9 +-
 drivers/usb/dwc3/gadget.c                          |  41 +++--
 drivers/usb/gadget/config.c                        |   4 +
 drivers/usb/gadget/function/f_fs.c                 |   3 +-
 drivers/usb/gadget/function/f_uac1.c               |  43 +++++
 drivers/usb/gadget/function/f_uac2.c               |  39 ++++-
 drivers/usb/gadget/function/f_uvc.c                |   8 +-
 drivers/usb/gadget/legacy/webcam.c                 |   1 +
 drivers/usb/gadget/udc/dummy_hcd.c                 |  23 ++-
 drivers/usb/gadget/udc/tegra-xudc.c                |   2 +-
 drivers/usb/host/xhci-mem.c                        |  12 ++
 drivers/usb/host/xhci-mtk.c                        |   3 +
 drivers/usb/host/xhci-mtk.h                        |   1 +
 drivers/usb/host/xhci.c                            |  14 +-
 drivers/usb/musb/musb_core.c                       |   2 +-
 drivers/vhost/vdpa.c                               |   1 +
 drivers/video/backlight/qcom-wled.c                |  29 +++-
 drivers/video/fbdev/core/fbcmap.c                  |   8 +-
 drivers/virt/nitro_enclaves/ne_misc_dev.c          |  43 ++---
 fs/btrfs/compression.c                             |  11 +-
 fs/btrfs/ctree.c                                   |  20 +++
 fs/btrfs/ioctl.c                                   |  18 ++-
 fs/btrfs/relocation.c                              |  46 ++++--
 fs/btrfs/transaction.c                             |  12 +-
 fs/cifs/connect.c                                  |   1 +
 fs/cifs/sess.c                                     |   6 +
 fs/cifs/smb2ops.c                                  |  18 +--
 fs/cifs/smb2pdu.c                                  |   5 +
 fs/ecryptfs/main.c                                 |   6 +
 fs/erofs/erofs_fs.h                                |   3 +
 fs/erofs/inode.c                                   |   7 +
 fs/eventpoll.c                                     |   6 +
 fs/exfat/balloc.c                                  |  11 +-
 fs/ext4/fast_commit.c                              |   4 +-
 fs/ext4/file.c                                     |  25 ++-
 fs/ext4/ialloc.c                                   |  51 ++++--
 fs/ext4/ioctl.c                                    |   6 +
 fs/ext4/mmp.c                                      |   2 +-
 fs/ext4/super.c                                    |   9 +-
 fs/f2fs/node.c                                     |   3 +
 fs/f2fs/verity.c                                   |  75 ++++++---
 fs/fuse/file.c                                     |  41 +++--
 fs/fuse/fuse_i.h                                   |   1 +
 fs/fuse/virtio_fs.c                                |   1 +
 fs/jbd2/transaction.c                              |  15 +-
 fs/jffs2/compr_rtime.c                             |   3 +
 fs/jffs2/file.c                                    |   1 +
 fs/jffs2/scan.c                                    |   2 +-
 fs/nfs/fs_context.c                                |  12 ++
 fs/nfs/pnfs.c                                      |   7 +-
 fs/stat.c                                          |   8 +
 fs/ubifs/replay.c                                  |   3 +-
 include/crypto/acompress.h                         |   2 +
 include/crypto/aead.h                              |   2 +
 include/crypto/akcipher.h                          |   2 +
 include/crypto/chacha.h                            |   9 +-
 include/crypto/hash.h                              |   4 +
 include/crypto/kpp.h                               |   2 +
 include/crypto/rng.h                               |   2 +
 include/crypto/skcipher.h                          |   2 +
 include/linux/mfd/da9063/registers.h               |   3 +
 include/linux/mfd/intel-m10-bmc.h                  |   2 +-
 include/linux/mmc/host.h                           |   3 -
 include/linux/perf_event.h                         |   1 +
 include/linux/power/bq27xxx_battery.h              |   1 -
 include/media/v4l2-ctrls.h                         |  12 +-
 include/scsi/libfcoe.h                             |   2 +-
 include/uapi/linux/usb/video.h                     |   3 +-
 kernel/.gitignore                                  |   1 +
 kernel/Makefile                                    |   9 +-
 kernel/events/core.c                               | 142 +++++++++--------
 kernel/futex.c                                     |   7 +-
 kernel/irq/matrix.c                                |   4 +-
 kernel/kcsan/core.c                                |   2 -
 kernel/kcsan/debugfs.c                             |   4 +-
 kernel/kcsan/kcsan.h                               |   5 -
 kernel/rcu/tree.c                                  |   2 +-
 kernel/sched/fair.c                                |  31 +++-
 kernel/sched/features.h                            |   3 +
 kernel/sched/psi.c                                 |   5 +-
 kernel/time/posix-timers.c                         |   4 +-
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/trace.c                               |  41 ++---
 kernel/trace/trace_clock.c                         |  44 ++++--
 lib/dynamic_debug.c                                |   2 +-
 lib/vsprintf.c                                     |   2 -
 net/bluetooth/ecdh_helper.h                        |   2 +-
 net/openvswitch/actions.c                          |   8 +-
 security/commoncap.c                               |   2 +-
 sound/isa/sb/emu8000.c                             |   4 +-
 sound/isa/sb/sb16_csp.c                            |   8 +-
 sound/pci/hda/patch_conexant.c                     |  14 +-
 sound/pci/hda/patch_realtek.c                      |  52 +++++-
 sound/usb/clock.c                                  |  18 ++-
 sound/usb/mixer_maps.c                             |  12 ++
 tools/power/x86/intel-speed-select/isst-display.c  |  12 +-
 tools/power/x86/turbostat/turbostat.c              |  19 ++-
 tools/testing/selftests/arm64/mte/Makefile         |   2 -
 .../testing/selftests/arm64/mte/mte_common_util.c  |  13 +-
 tools/testing/selftests/resctrl/Makefile           |   2 +-
 tools/testing/selftests/resctrl/cache.c            |   8 +-
 tools/testing/selftests/resctrl/cat_test.c         |  12 +-
 tools/testing/selftests/resctrl/cqm_test.c         |  14 +-
 tools/testing/selftests/resctrl/fill_buf.c         |   4 +-
 tools/testing/selftests/resctrl/mba_test.c         |   2 +-
 tools/testing/selftests/resctrl/mbm_test.c         |   2 +-
 tools/testing/selftests/resctrl/resctrl.h          |  21 ++-
 tools/testing/selftests/resctrl/resctrl_tests.c    |  14 +-
 tools/testing/selftests/resctrl/resctrl_val.c      |  85 ++++++----
 tools/testing/selftests/resctrl/resctrlfs.c        |  79 +++++++---
 344 files changed, 3031 insertions(+), 1640 deletions(-)


