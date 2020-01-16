Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03B6140021
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390456AbgAPXTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:45826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390473AbgAPXTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD2F42075B;
        Thu, 16 Jan 2020 23:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216785;
        bh=3I7dEzS3pT9GTt8X0fJlFTI2uHH9jTuk5l3j2q/magQ=;
        h=From:To:Cc:Subject:Date:From;
        b=V+PWroORqDBJJ8OHSlTl+zuu8Fudh+lCsSO7hwYcUL3500tMHjodnZwsfz5WvOEOk
         x1grTrTWmZacGt2D/ZV4cuLEiy4nBonW6my6ZwBppnjVfe7bnh5WXnQr8ljs6KXPI9
         /alMh6m6MHbwA6B2F3Z2gxNQDiVkFRVKhDc+lgWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/203] 5.4.13-stable review
Date:   Fri, 17 Jan 2020 00:15:17 +0100
Message-Id: <20200116231745.218684830@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.13-rc1
X-KernelTest-Deadline: 2020-01-18T23:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.13 release.
There are 203 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.13-rc1

Kai Li <li.kai4@h3c.com>
    ocfs2: call journal flush to mark journal as empty after journal recovery when mount

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: work around compiler crash

Nick Desaulniers <ndesaulniers@google.com>
    hexagon: parenthesize registers in asm predicates

Ard Biesheuvel <ardb@kernel.org>
    kbuild/deb-pkg: annotate libelf-dev dependency as :native

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: intel-ipu3: Align struct ipu3_uapi_awb_fr_config_s to 32 bytes

changzhu <Changfeng.Zhu@amd.com>
    drm/amdgpu: enable gfxoff for raven1 refresh

Alexander.Barabash@dell.com <Alexander.Barabash@dell.com>
    ioat: ioat_alloc_ring() failure handling.

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: lock the card while changing its hsuid

John Stultz <john.stultz@linaro.org>
    dmaengine: k3dma: Avoid null pointer traversal

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing security check on incoming calls

David Howells <dhowells@redhat.com>
    rxrpc: Don't take call->user_mutex in rxrpc_new_incoming_call()

David Howells <dhowells@redhat.com>
    rxrpc: Unlock new call in rxrpc_new_incoming_call() rather than the caller

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    drm/arm/mali: make malidp_mw_connector_helper_funcs static

Jouni Hogander <jouni.hogander@unikie.com>
    MIPS: Prevent link failure with kcov instrumentation

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: Suppress RCU warning at list_for_each_entry_rcu().

Vincenzo Frascino <vincenzo.frascino@arm.com>
    mips: Fix gettimeofday() in the vdso library

Vladimir Kondratiev <vladimir.kondratiev@intel.com>
    mips: cacheinfo: report shared CPU map

Olof Johansson <olof@lixom.net>
    riscv: export flush_icache_all to modules

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq/selftests: Turn off timeout setting

Shuah Khan <skhan@linuxfoundation.org>
    selftests: firmware: Fix it to do root uid check and skip

Israel Rukshin <israelr@mellanox.com>
    scsi: target/iblock: Fix protection error with blocks greater than 512B

Varun Prakash <varun@chelsio.com>
    scsi: libcxgbi: fix NULL pointer dereference in cxgbi_device_destroy()

Johnson CH Chen (陳昭勳) <JohnsonCH.Chen@moxa.com>
    gpio: mpc8xxx: Add platform device to gpiochip->parent

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    rtc: bd70528: Add MODULE ALIAS to autoload module

Chuhong Yuan <hslester96@gmail.com>
    rtc: brcmstb-waketimer: add missed clk_disable_unprepare

Kars de Jong <jongk@linux-m68k.org>
    rtc: msm6242: Fix reading of 10-hour digit

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    NFSD fixing possible null pointer derefering in copy offload

Chao Yu <chao@kernel.org>
    f2fs: fix potential overflow

Victorien Molle <victorien.molle@wifirst.fr>
    sch_cake: Add missing NLA policy entry TCA_CAKE_SPLIT_GSO

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix support for single antenna diversity

Nathan Chancellor <natechancellor@gmail.com>
    rtlwifi: Remove unnecessary NULL check in rtl_regd_init

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: consider ieee80211 station max amsdu value

Navid Emamdoost <navid.emamdoost@gmail.com>
    spi: lpspi: fix memory leak in fsl_lpspi_probe

Geert Uytterhoeven <geert+renesas@glider.be>
    spi: rspi: Use platform_get_irq_byname_optional() for optional irqs

Mans Rullgard <mans@mansr.com>
    spi: atmel: fix handling of cs_change set on non-last xfer

Daniel Vetter <daniel.vetter@ffwll.ch>
    spi: pxa2xx: Set controller->max_transfer_size in dma mode

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: spi-nor: fix silent truncation in spi_nor_read_raw()

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mtd: spi-nor: fix silent truncation in spi_nor_read()

Huanpeng Xin <huanpeng.xin@unisoc.com>
    spi: sprd: Fix the incorrect SPI register

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: do_kill_orphans: Fix a memory leak bug

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    ubifs: Fixed missed le64_to_cpu() in journal

Richard Weinberger <richard@nod.at>
    Revert "ubifs: Fix memory leak bug in alloc_ubifs_info() error path"

Yong Wu <yong.wu@mediatek.com>
    memory: mtk-smi: Add PM suspend and resume ops

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add a new tlb_lock for tlb_flush

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Correct the flush_iotlb_all callback

Jonas Karlman <jonas@kwiboo.se>
    media: hantro: Set H264 FIELDPIC_FLAG_E flag correctly

Navid Emamdoost <navid.emamdoost@gmail.com>
    media: aspeed-video: Fix memory leaks in aspeed_video_probe

Jonas Karlman <jonas@kwiboo.se>
    media: hantro: Do not reorder H264 scaling list

Jonas Karlman <jonas@kwiboo.se>
    media: cedrus: Use correct H264 8x8 scaling list

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: fix deadlock between decoder picture run and start command

Seung-Woo Kim <sw0312.kim@samsung.com>
    media: exynos4-is: Fix recursive locking in isp_video_release()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: v4l: cadence: Fix how unsued lanes are handled in 'csi2rx_start()'

Boris Brezillon <boris.brezillon@collabora.com>
    media: hantro: h264: Fix the frame_num wraparound case

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: rcar-vin: Fix incorrect return statement in rvin_try_format()

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix default format not applied on device probe

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix .get_fmt() V4L2_SUBDEV_FORMAT_TRY support

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix some format attributes not under control

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    media: ov6650: Fix incorrect use of JPEG colorspace

Dietmar Eggemann <dietmar.eggemann@arm.com>
    ARM: 8943/1: Fix topology setup in case of CPU hotplug for CONFIG_SCHED_MC

Peng Fan <peng.fan@nxp.com>
    tty: serial: pch_uart: correct usage of dma_unmap_sg

Peng Fan <peng.fan@nxp.com>
    tty: serial: imx: use the sg count from dma_map_sg

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: SGI-IP27: Fix crash, when CPUs are disabled via nr_cpus parameter

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS: Loongson: Fix return value of loongson_hwmon_init

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: PCI: remember nasid changed by set interrupt affinity

Oliver O'Halloran <oohall@gmail.com>
    powerpc/powernv: Disable native PCIe port management

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PTM: Remove spurious "d" from granularity message

Hewenliang <hewenliang4@huawei.com>
    tools: PCI: Fix fd leakage

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PM: Clear PCIe PME Status even for legacy power management

Rob Herring <robh@kernel.org>
    PCI: Fix missing bridge dma_ranges resource list cleanup

Niklas Cassel <niklas.cassel@linaro.org>
    PCI: dwc: Fix find_next_bit() usage

Remi Pommarel <repk@triplefau.lt>
    PCI: aardvark: Fix PCI_EXP_RTCTL register configuration

Remi Pommarel <repk@triplefau.lt>
    PCI: aardvark: Use LTSSM state to build link training flag

Arnd Bergmann <arnd@arndb.de>
    compat_ioctl: handle SIOCOUTQNSD

Arnd Bergmann <arnd@arndb.de>
    af_unix: add compat_ioctl support

Arnd Bergmann <arnd@arndb.de>
    gfs2: add compat_ioctl support

Loic Poulain <loic.poulain@linaro.org>
    arm64: dts: apq8096-db820c: Increase load on l21 for SDCARD

Arnd Bergmann <arnd@arndb.de>
    scsi: sd: enable compat ioctls for sed-opal

Xiaojie Yuan <xiaojie.yuan@amd.com>
    drm/amdgpu/discovery: reserve discovery data at the top of VRAM

Christian König <christian.koenig@amd.com>
    drm/amdgpu: cleanup creating BOs at fixed location (v2)

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "drm/virtio: switch virtio_gpu_wait_ioctl() to gem helper."

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI: pciehp: Do not disable interrupt twice on suspend

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: lewisburg: Update pin list according to v1.1v6

Geert Uytterhoeven <geert+renesas@glider.be>
    pinctrl: sh-pfc: Do not use platform_get_irq() to count interrupts

Keiya Nobuta <nobuta.keiya@fujitsu.com>
    pinctrl: sh-pfc: Fix PINMUX_IPSR_PHYS() to set GPSR

Colin Ian King <colin.king@canonical.com>
    pinctl: ti: iodelay: fix error checking on pinctrl_count_index_with_args call

Navid Emamdoost <navid.emamdoost@gmail.com>
    affs: fix a memory leak in affs_remount

Denis Efremov <efremov@linux.com>
    rsi: fix potential null dereference in rsi_probe()

Leonard Crestez <leonard.crestez@nxp.com>
    clk: imx: pll14xx: Fix quick switch of S/K parameter

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    dmaengine: dw: platform: Mark 'hclk' clock optional

Kishon Vijay Abraham I <kishon@ti.com>
    clk: Fix memory leak in clk_unregister()

Marian Mihailescu <mihailescu2m@gmail.com>
    clk: samsung: exynos5420: Preserve CPU clocks configuration during suspend/resume

Jerome Brunet <jbrunet@baylibre.com>
    clk: meson: axg-audio: fix regmap last register

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: fix modalias documentation

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: imu: adis16480: assign bias value only if operation succeeded

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix gyro gain definitions for LSM9DS1

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Drop the slot if nfs4_delegreturn_prepare waits for layoutreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Handle bad/dead sessions correctly in nfs41_sequence_process()

Scott Mayhew <smayhew@redhat.com>
    nfsd: v4 support requires CRYPTO_SHA256

Scott Mayhew <smayhew@redhat.com>
    nfsd: Fix cld_net->cn_tfm initialization

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv2: Fix a typo in encode_sattr()

Eric Biggers <ebiggers@google.com>
    crypto: geode-aes - convert to skcipher API and make thread-safe

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_skcipher - Use chunksize instead of blocksize

Ard Biesheuvel <ardb@kernel.org>
    crypto: virtio - implement missing support for output IVs

Yunfeng Ye <yeyunfeng@huawei.com>
    crypto: arm64/aes-neonbs - add return value of skcipher_walk_done() in __xts_crypt()

Zhou Wang <wangzhou1@hisilicon.com>
    crypto: hisilicon - select NEED_SG_DMA_LENGTH in qm Kconfig

Phani Kiran Hemadri <phemadri@marvell.com>
    crypto: cavium/nitrox - fix firmware assignment to AE cores

Can Guo <cang@codeaurora.org>
    scsi: ufs: Give an unique ID to each ufs-bsg

Diego Calleja <diegocg@gmail.com>
    dm: add dm-clone to the documentation index

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix oops in Receive handler after device removal

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix completion wait during device removal

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix create_qp crash on device unload

Vadim Pasternak <vadimp@mellanox.com>
    Documentation/ABI: Add missed attribute for mlxreg-io sysfs interfaces

Vadim Pasternak <vadimp@mellanox.com>
    Documentation/ABI: Fix documentation inconsistency for mlxreg-io sysfs interfaces

Mike Rapoport <rppt@linux.ibm.com>
    asm-generic/nds32: don't redefine cacheflush primitives

Hans de Goede <hdegoede@redhat.com>
    platform/x86: GPD pocket fan: Use default values when wrong modparams are given

Jian-Hong Pan <jian-hong@endlessm.com>
    platform/x86: asus-wmi: Fix keyboard brightness cannot be set to 0

Liming Sun <lsun@mellanox.com>
    platform/mellanox: fix potential deadlock in the tmfifo driver

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: sd: Clear sdkp->protection_type if disk is reformatted without PI

James Bottomley <James.Bottomley@HansenPartnership.com>
    scsi: enclosure: Fix stale device oops with hot replug

David Howells <dhowells@redhat.com>
    keys: Fix request_key() cache

David Howells <dhowells@redhat.com>
    afs: Fix afs_lookup() to not clobber the version on a new dentry

David Howells <dhowells@redhat.com>
    afs: Fix use-after-loss-of-ref

Andrii Nakryiko <andriin@fb.com>
    libbpf: Fix Makefile' libbpf symbol mismatch diagnostic

Stanislav Fomichev <sdf@google.com>
    bpf: Support pre-2.25-binutils objcopy for vmlinux BTF

John Fastabend <john.fastabend@gmail.com>
    bpf: skmsg, fix potential psock NULL pointer dereference

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Make use of probe_user_write in probe write helper

Daniel Borkmann <daniel@iogearbox.net>
    uaccess: Add non-pagefault user-space write function

Bart Van Assche <bvanassche@acm.org>
    RDMA/srpt: Report the SCSI residual to the initiator

Leon Romanovsky <leon@kernel.org>
    RDMA/mlx5: Return proper error value

Jason Gunthorpe <jgg@ziepe.ca>
    rdma: Remove nes ABI header

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Bugfix for qpc/cqc timer configuration

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Fix to support 64K page for srq

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Close window between waking RPC senders and posting Receives

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Fix MR list handling

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Connection becomes unstable after a reconnect

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Add unique trace points for posting Local Invalidate WRs

Yangyang Li <liyangyang20@huawei.com>
    RDMA/hns: Release qp resources when failed to destroy qp

Arnd Bergmann <arnd@arndb.de>
    RDMA/hns: Fix build error again

Bart Van Assche <bvanassche@acm.org>
    RDMA/siw: Fix port number endianness in a debug message

Mark Zhang <markz@mellanox.com>
    RDMA/counter: Prevent QP counter manual binding in auto mode

Lang Cheng <chenglang@huawei.com>
    RDMA/hns: Modify return value of restrack functions

Weihang Li <liweihang@hisilicon.com>
    RDMA/hns: remove a redundant le16_to_cpu

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/hns: Prevent undefined behavior in hns_roce_set_user_sq_size()

Nilkanth Ahirrao <anilkanth@jp.adit-jv.com>
    ASoC: rsnd: fix DALIGN register for SSIU

Takashi Iwai <tiwai@suse.de>
    ASoC: core: Fix compile warning with CONFIG_DEBUG_FS=n

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: Broadwell: clarify mutual exclusion with legacy driver

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_esai: Add spin lock to protect reset, stop and start

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: simple_card_utils.h: Add missing include

Tzung-Bi Shih <tzungbi@google.com>
    ASoC: dt-bindings: mt8183: add missing update

Arnd Bergmann <arnd@arndb.de>
    netfilter: nft_meta: use 64-bit time arithmetic

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables_offload: release flow_rule on error from commit path

Goldwyn Rodrigues <rgoldwyn@suse.com>
    btrfs: simplify inode locking for RWF_NOWAIT

Taehee Yoo <ap420073@gmail.com>
    hsr: fix slab-out-of-bounds Read in hsr_debugfs_rename()

Sami Tolvanen <samitolvanen@google.com>
    syscalls/x86: Fix function types in COND_SYSCALL

Sami Tolvanen <samitolvanen@google.com>
    syscalls/x86: Use the correct function type for sys_ni_syscall

Sami Tolvanen <samitolvanen@google.com>
    syscalls/x86: Use COMPAT_SYSCALL_DEFINE0 for IA32 (rt_)sigreturn

Andy Lutomirski <luto@kernel.org>
    syscalls/x86: Wire up COMPAT_SYSCALL_DEFINE0

Ed Maste <emaste@freebsd.org>
    perf vendor events s390: Remove name from L1D_RO_EXCL_WRITES description

David Howells <dhowells@redhat.com>
    afs: Fix missing cell comparison in afs_test_super()

Florian Fainelli <f.fainelli@gmail.com>
    reset: brcmstb: Remove resource checks

Florian Fainelli <f.fainelli@gmail.com>
    dt-bindings: reset: Fix brcmstb-reset example

Marc Kleine-Budde <mkl@pengutronix.de>
    can: j1939: fix address claim code example

Christian Lamparter <chunkeey@gmail.com>
    ath9k: use iowrite32 over __raw_writel

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    MAINTAINERS: Append missed file to the database

Paul Menzel <pmenzel@molgen.mpg.de>
    scsi: smartpqi: Update attribute name to `driver_version`

Nathan Chancellor <natechancellor@gmail.com>
    cifs: Adjust indentation in smb2_open_file

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix initialization on old HW

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: vnicc Fix init to default

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: Fix vnicc_is_in_use if rx_bcast not set

Alexandra Winter <wintera@linux.ibm.com>
    s390/qeth: fix false reporting of VNIC CHAR config failure

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qeth: fix qdio teardown after early init error

Taehee Yoo <ap420073@gmail.com>
    hsr: reset network header when supervision frame is created

Taehee Yoo <ap420073@gmail.com>
    hsr: rename debugfs file when interface name is changed

Taehee Yoo <ap420073@gmail.com>
    hsr: add hsr root debugfs directory

Thierry Reding <treding@nvidia.com>
    drm/tegra: Fix ordering of cleanup code

Neil Armstrong <narmstrong@baylibre.com>
    PCI: amlogic: Fix probed clock names

Arnd Bergmann <arnd@arndb.de>
    PM / devfreq: tegra: Add COMMON_CLK dependency

Geert Uytterhoeven <geert+renesas@glider.be>
    gpio: Fix error message on out-of-range GPIO in lookup table

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: mpt3sas: Fix double free in attach error handling

Ming Lei <ming.lei@redhat.com>
    fs: move guard_bio_eod() after bio_set_op_attrs

Roman Gushchin <guro@fb.com>
    bpf: cgroup: prevent out-of-order release of cgroup bpf

Jon Derrick <jonathan.derrick@intel.com>
    iommu: Remove device link to group on failure

Jon Derrick <jonathan.derrick@intel.com>
    iommu/vt-d: Unlink device if failed to add to group

Hangbin Liu <liuhangbin@gmail.com>
    selftests: loopback.sh: skip this test if the driver does not support

Qianggui Song <qianggui.song@amlogic.com>
    pinctrl: meson: Fix wrong shift value when get drive-strength

Swapna Manupati <swapna.manupati@xilinx.com>
    gpio: zynq: Fix for bug in zynq_gpio_restore_context API

Peter Ujfalusi <peter.ujfalusi@ti.com>
    mtd: onenand: omap2: Pass correct flags for prep_dma_memcpy

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: SOF: imx8: Fix dsp_box offset

wenxu <wenxu@ucloud.cn>
    netfilter: nft_flow_offload: fix underflow in flowtable reference counter

Arnd Bergmann <arnd@arndb.de>
    pinctrl: lochnagar: select GPIOLIB

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix input pin state management

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix race condition in irq handler

Olivier Moysan <olivier.moysan@st.com>
    ASoC: stm32: spdifrx: fix inconsistent lock state

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: soc-core: Set dpcm_playback / dpcm_capture

Colin Ian King <colin.king@canonical.com>
    ASoC: SOF: imx8: fix memory allocation failure check on priv->pd_dev

Stefan Wahren <wahrenst@gmx.net>
    i2c: bcm2835: Store pointer to bus clock

Christophe Kerello <christophe.kerello@st.com>
    mtd: rawnand: stm32_fmc2: avoid to lock the CPU bus

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Don't cancel unused work item

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Fix Send Work Entry state check while polling completions

Selvin Xavier <selvin.xavier@broadcom.com>
    RDMA/bnxt_re: Avoid freeing MR resources if dereg fails

Tony Lindgren <tony@atomide.com>
    phy: mapphone-mdm6600: Fix uninitialized status value regression

Ran Bi <ran.bi@mediatek.com>
    rtc: mt6397: fix alarm register overwrite

Jiri Kosina <jkosina@suse.cz>
    HID: hidraw, uhid: Always report EPOLLOUT


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-driver-mlxreg-io    |  13 +-
 Documentation/ABI/testing/sysfs-bus-mei            |   2 +-
 Documentation/admin-guide/device-mapper/index.rst  |   1 +
 .../bindings/reset/brcm,brcmstb-reset.txt          |   2 +-
 .../sound/mt8183-mt6358-ts3a227-max98357.txt       |   4 +-
 Documentation/networking/j1939.rst                 |   2 +-
 Documentation/scsi/smartpqi.txt                    |   2 +-
 MAINTAINERS                                        |   1 +
 Makefile                                           |   4 +-
 arch/arm/kernel/smp.c                              |   4 +
 arch/arm/kernel/topology.c                         |  10 +-
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi       |   2 +
 arch/arm64/crypto/aes-neonbs-glue.c                |   2 +-
 arch/hexagon/include/asm/atomic.h                  |   8 +-
 arch/hexagon/include/asm/bitops.h                  |   8 +-
 arch/hexagon/include/asm/cmpxchg.h                 |   2 +-
 arch/hexagon/include/asm/futex.h                   |   6 +-
 arch/hexagon/include/asm/spinlock.h                |  20 +-
 arch/hexagon/kernel/stacktrace.c                   |   4 +-
 arch/hexagon/kernel/vm_entry.S                     |   2 +-
 arch/mips/boot/compressed/Makefile                 |   3 +
 arch/mips/include/asm/vdso/gettimeofday.h          |  13 -
 arch/mips/kernel/cacheinfo.c                       |  27 +-
 arch/mips/pci/pci-xtalk-bridge.c                   |   5 +-
 arch/mips/sgi-ip27/ip27-irq.c                      |   4 +
 arch/mips/vdso/vgettimeofday.c                     |  20 +
 arch/nds32/include/asm/cacheflush.h                |  11 +-
 arch/powerpc/platforms/powernv/pci.c               |  17 +
 arch/riscv/mm/cacheflush.c                         |   1 +
 arch/x86/entry/syscall_32.c                        |   8 +-
 arch/x86/entry/syscall_64.c                        |  14 +-
 arch/x86/entry/syscalls/syscall_32.tbl             |   8 +-
 arch/x86/ia32/ia32_signal.c                        |   5 +-
 arch/x86/include/asm/syscall_wrapper.h             |  53 ++-
 block/bio.c                                        |  12 +-
 crypto/algif_skcipher.c                            |   2 +-
 drivers/clk/clk.c                                  |   1 +
 drivers/clk/imx/clk-pll14xx.c                      |  40 +-
 drivers/clk/meson/axg-audio.c                      |   2 +-
 drivers/clk/samsung/clk-exynos5420.c               |   2 +
 drivers/crypto/cavium/nitrox/nitrox_main.c         |   9 +-
 drivers/crypto/geode-aes.c                         | 440 +++++++--------------
 drivers/crypto/geode-aes.h                         |  15 +-
 drivers/crypto/hisilicon/Kconfig                   |   1 +
 drivers/crypto/virtio/virtio_crypto_algs.c         |   9 +
 drivers/devfreq/Kconfig                            |   1 +
 drivers/dma/dw/platform.c                          |   2 +-
 drivers/dma/ioat/dma.c                             |   3 +-
 drivers/dma/k3dma.c                                |  12 +-
 drivers/gpio/gpio-mpc8xxx.c                        |   1 +
 drivers/gpio/gpio-zynq.c                           |   8 +-
 drivers/gpio/gpiolib.c                             |   5 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu.h                |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c      |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.h      |   2 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |  61 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h         |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  85 +---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  99 ++---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |  15 +-
 drivers/gpu/drm/amd/include/discovery.h            |   1 -
 drivers/gpu/drm/arm/malidp_mw.c                    |   2 +-
 drivers/gpu/drm/tegra/drm.c                        |  14 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  28 +-
 drivers/hid/hidraw.c                               |   7 +-
 drivers/hid/uhid.c                                 |   5 +-
 drivers/i2c/busses/i2c-bcm2835.c                   |  17 +-
 drivers/iio/imu/adis16480.c                        |   6 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   7 +-
 drivers/infiniband/core/counters.c                 |  12 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c           |   4 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |  12 +-
 drivers/infiniband/hw/hfi1/iowait.c                |   4 +-
 drivers/infiniband/hw/hns/Kconfig                  |  17 +-
 drivers/infiniband/hw/hns/Makefile                 |   8 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  18 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |   4 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c            |  10 +-
 drivers/infiniband/hw/hns/hns_roce_restrack.c      |   2 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +-
 drivers/infiniband/sw/siw/siw_cm.c                 |   9 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  24 ++
 drivers/iommu/intel-iommu.c                        |  13 +-
 drivers/iommu/iommu.c                              |   1 +
 drivers/iommu/mtk_iommu.c                          |  25 +-
 drivers/iommu/mtk_iommu.h                          |   1 +
 drivers/media/i2c/ov6650.c                         |  79 ++--
 drivers/media/platform/aspeed-video.c              |   3 +-
 drivers/media/platform/cadence/cdns-csi2rx.c       |   2 +-
 drivers/media/platform/coda/coda-common.c          |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   3 +-
 drivers/memory/mtk-smi.c                           |   4 +
 drivers/misc/enclosure.c                           |   3 +-
 drivers/mtd/nand/onenand/omap2.c                   |   3 +-
 drivers/mtd/nand/raw/stm32_fmc2_nand.c             |  38 +-
 drivers/mtd/spi-nor/spi-nor.c                      |   4 +-
 .../net/wireless/ath/ath9k/ath9k_pci_owl_loader.c  |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   7 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   2 +-
 drivers/pci/controller/dwc/pci-meson.c             |   6 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |  11 +-
 drivers/pci/controller/pci-aardvark.c              |  42 +-
 drivers/pci/hotplug/pciehp_core.c                  |  25 +-
 drivers/pci/pci-driver.c                           |   3 +-
 drivers/pci/pcie/ptm.c                             |   2 +-
 drivers/pci/probe.c                                |   1 +
 drivers/phy/motorola/phy-mapphone-mdm6600.c        |  11 +-
 drivers/pinctrl/cirrus/Kconfig                     |   1 +
 drivers/pinctrl/intel/pinctrl-lewisburg.c          | 171 ++++----
 drivers/pinctrl/meson/pinctrl-meson.c              |   1 +
 drivers/pinctrl/sh-pfc/core.c                      |  16 +-
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |   4 +-
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c            |   2 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c           |  19 +-
 drivers/platform/mips/cpu_hwmon.c                  |   2 +-
 drivers/platform/x86/asus-wmi.c                    |   8 +-
 drivers/platform/x86/gpd-pocket-fan.c              |  25 +-
 drivers/reset/reset-brcmstb.c                      |   6 -
 drivers/rtc/rtc-bd70528.c                          |   1 +
 drivers/rtc/rtc-brcmstb-waketimer.c                |   1 +
 drivers/rtc/rtc-msm6242.c                          |   3 +-
 drivers/rtc/rtc-mt6397.c                           |  47 ++-
 drivers/s390/net/qeth_core_main.c                  |  29 +-
 drivers/s390/net/qeth_l2_main.c                    |  10 +-
 drivers/s390/net/qeth_l3_main.c                    |   2 +-
 drivers/s390/net/qeth_l3_sys.c                     |  40 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   1 -
 drivers/scsi/sd.c                                  |  18 +-
 drivers/scsi/ufs/ufs_bsg.c                         |   2 +-
 drivers/spi/spi-atmel.c                            |  10 +-
 drivers/spi/spi-fsl-lpspi.c                        |   2 +-
 drivers/spi/spi-pxa2xx.c                           |   7 +
 drivers/spi/spi-rspi.c                             |   8 +-
 drivers/spi/spi-sprd.c                             |   2 +-
 drivers/staging/media/hantro/hantro_g1_h264_dec.c  |   2 +-
 drivers/staging/media/hantro/hantro_h264.c         |  73 ++--
 drivers/staging/media/ipu3/include/intel-ipu3.h    |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c   |   4 +-
 drivers/target/target_core_iblock.c                |   4 +-
 drivers/tty/serial/imx.c                           |   2 +-
 drivers/tty/serial/pch_uart.c                      |   5 +-
 fs/affs/super.c                                    |   6 -
 fs/afs/dir.c                                       |  18 +-
 fs/afs/super.c                                     |   1 +
 fs/btrfs/file.c                                    |   5 +-
 fs/buffer.c                                        |   8 +-
 fs/cifs/smb2file.c                                 |   2 +-
 fs/f2fs/data.c                                     |   2 +-
 fs/f2fs/file.c                                     |   2 +-
 fs/gfs2/file.c                                     |  30 ++
 fs/internal.h                                      |   2 +-
 fs/mpage.c                                         |   2 +-
 fs/nfs/nfs2xdr.c                                   |   2 +-
 fs/nfs/nfs4proc.c                                  |  38 +-
 fs/nfsd/Kconfig                                    |   2 +-
 fs/nfsd/nfs4proc.c                                 |   3 +-
 fs/nfsd/nfs4recover.c                              |  12 +-
 fs/ocfs2/journal.c                                 |   8 +
 fs/ubifs/journal.c                                 |   2 +-
 fs/ubifs/orphan.c                                  |  17 +-
 fs/ubifs/super.c                                   |   4 +-
 include/asm-generic/cacheflush.h                   |  33 +-
 include/crypto/internal/skcipher.h                 |  30 --
 include/crypto/skcipher.h                          |  30 ++
 include/linux/uaccess.h                            |  12 +
 include/sound/simple_card_utils.h                  |   1 +
 include/trace/events/afs.h                         |  12 +-
 include/trace/events/rpcrdma.h                     |  25 ++
 include/uapi/rdma/nes-abi.h                        | 115 ------
 kernel/bpf/cgroup.c                                |  11 +-
 kernel/cred.c                                      |   4 +-
 kernel/trace/bpf_trace.c                           |   6 +-
 mm/maccess.c                                       |  45 ++-
 net/core/skmsg.c                                   |  13 +-
 net/hsr/hsr_debugfs.c                              |  36 +-
 net/hsr/hsr_device.c                               |   2 +
 net/hsr/hsr_main.c                                 |   5 +
 net/hsr/hsr_main.h                                 |  10 +
 net/hsr/hsr_netlink.c                              |   1 +
 net/netfilter/nf_tables_offload.c                  |  26 +-
 net/netfilter/nft_flow_offload.c                   |   3 -
 net/netfilter/nft_meta.c                           |  10 +-
 net/rxrpc/ar-internal.h                            |  10 +-
 net/rxrpc/call_accept.c                            |  60 +--
 net/rxrpc/conn_event.c                             |  16 +-
 net/rxrpc/conn_service.c                           |   4 +
 net/rxrpc/input.c                                  |  18 -
 net/rxrpc/rxkad.c                                  |   5 +-
 net/rxrpc/security.c                               |  70 ++--
 net/sched/sch_cake.c                               |   1 +
 net/socket.c                                       |   1 +
 net/sunrpc/xprtrdma/frwr_ops.c                     |   4 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   1 +
 net/sunrpc/xprtrdma/transport.c                    |   3 +
 net/sunrpc/xprtrdma/verbs.c                        | 103 +++--
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   3 +
 net/unix/af_unix.c                                 |  19 +
 scripts/link-vmlinux.sh                            |   7 +-
 scripts/package/mkdebian                           |   2 +-
 security/tomoyo/common.c                           |   9 +-
 security/tomoyo/domain.c                           |  15 +-
 security/tomoyo/group.c                            |   9 +-
 security/tomoyo/util.c                             |   6 +-
 sound/soc/fsl/fsl_esai.c                           |  12 +
 sound/soc/intel/Kconfig                            |   3 +
 sound/soc/sh/rcar/core.c                           |  20 +-
 sound/soc/soc-core.c                               |   2 +
 sound/soc/soc-pcm.c                                |   2 +
 sound/soc/sof/imx/imx8.c                           |   5 +-
 sound/soc/sof/intel/Kconfig                        |  10 +-
 sound/soc/stm/stm32_spdifrx.c                      |  40 +-
 tools/lib/bpf/Makefile                             |   2 +-
 tools/pci/pcitest.c                                |   1 +
 .../perf/pmu-events/arch/s390/cf_z14/extended.json |   2 +-
 tools/testing/selftests/firmware/fw_lib.sh         |   6 +
 tools/testing/selftests/net/forwarding/loopback.sh |   8 +
 tools/testing/selftests/rseq/settings              |   1 +
 222 files changed, 1849 insertions(+), 1423 deletions(-)


