Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E01A63DF1A
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiK3Snv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiK3Sno (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642141BEAE;
        Wed, 30 Nov 2022 10:43:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD66A61D7C;
        Wed, 30 Nov 2022 18:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897B1C433D6;
        Wed, 30 Nov 2022 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833819;
        bh=pJF6smT7PTg12pa/nQb5HqbvGdM89gn8m0yTl9SMlvA=;
        h=From:To:Cc:Subject:Date:From;
        b=eUMznprEAZtRo7Bhj/7+bKXSTPjJ9192BqbL7qfZO1hBnpgLX8GFLj4X6Ufl4kSXI
         MszX0acg2opjBwxt6vceA4/jAOtzaQQqaBuhMODpgUFwMhN/lGL38P1z2JpGoiubug
         ZF0iioak38hRgzD2cFONnJDf6ufvacLtyn9J/q1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.0 000/289] 6.0.11-rc1 review
Date:   Wed, 30 Nov 2022 19:19:45 +0100
Message-Id: <20221130180544.105550592@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.11-rc1
X-KernelTest-Deadline: 2022-12-02T18:05+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.11 release.
There are 289 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.11-rc1

Andrzej Hajda <andrzej.hajda@intel.com>
    drm/i915: fix TLB invalidation for Gen12 video and compute engines

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: Partially revert "drm/amdgpu: update drm_display_info correctly when the edid is read"

Christian König <christian.koenig@amd.com>
    drm/amdgpu: always register an MMU notifier for userptr

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Update soc bounding box for dcn32/dcn321

Jack Xiao <Jack.Xiao@amd.com>
    drm/amd/amdgpu: reserve vm invalidation engine for firmware

Ramesh Errabolu <Ramesh.Errabolu@amd.com>
    drm/amdgpu: Enable Aldebaran devices to report CU Occupancy

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/psp: don't free PSP buffers on suspend

Tsung-hua Lin <Tsung-hua.Lin@amd.com>
    drm/amd/display: No display after resume from WB/CB

Lyude Paul <lyude@redhat.com>
    drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN

Lyude Paul <lyude@redhat.com>
    drm/display/dp_mst: Fix drm_dp_mst_add_affected_dsc_crtcs() return code

Matthew Auld <matthew.auld@intel.com>
    drm/i915/ttm: never purge busy objects

Filipe Manana <fdmanana@suse.com>
    btrfs: do not modify log tree while holding a leaf from fs tree locked

Zhen Lei <thunder.leizhen@huawei.com>
    btrfs: sysfs: normalize the error handling branch in btrfs_init_sysfs()

Christoph Hellwig <hch@lst.de>
    btrfs: use kvcalloc in btrfs_get_dev_zone_info

Christoph Hellwig <hch@lst.de>
    btrfs: zoned: fix missing endianness conversion in sb_write_pointer

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying subvol info to userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying fspath to userspace

Anand Jain <anand.jain@oracle.com>
    btrfs: free btrfs_path before copying inodes to userspace

Josef Bacik <josef@toxicpanda.com>
    btrfs: free btrfs_path before copying root refs to userspace

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate number of channels

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_CHANNEL_LIST attribute

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate length of IEEE80211_P2P_ATTR_OPER_CHANNEL attribute

Phil Turnbull <philipturnbull@github.com>
    wifi: wilc1000: validate pairwise and authentication suite offsets

Miklos Szeredi <mszeredi@redhat.com>
    fuse: lock inode unconditionally in fuse_fallocate()

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: clear the journal on suspend

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: flush the journal on suspend

Robin Murphy <robin.murphy@arm.com>
    gpu: host1x: Avoid trying to use GART on Tegra20

Zhou Guanghui <zhouguanghui1@huawei.com>
    scsi: iscsi: Fix possible memory leak when device_register() failed

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: mpi3mr: Suppress command reply debug prints

Enrico Sau <enrico.sau@gmail.com>
    net: usb: qmi_wwan: add Telit 0x103a composition

Keith Busch <kbusch@kernel.org>
    dm-log-writes: set dma_alignment limit in io_hints

Keith Busch <kbusch@kernel.org>
    dm-integrity: set dma_alignment limit in io_hints

Keith Busch <kbusch@kernel.org>
    block: make blk_set_default_limits() private

Gleb Mazovetskiy <glex.spb@gmail.com>
    tcp: configurable source port perturb table size

Hans de Goede <hdegoede@redhat.com>
    platform/x86: ideapad-laptop: Add module parameters to match DMI quirk tables

Arnav Rawat <arnavr3@illinois.edu>
    platform/x86: ideapad-laptop: Fix interrupt storm on fn-lock toggle on some Yoga laptops

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp-wmi: Ignore Smart Experience App event

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Laptop 5

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix zone report size in __zonefs_io_error()

Eric Huang <jinhuieric.huang@amd.com>
    drm/amdkfd: Fix a memory limit issue

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: disable BACO support on more cards

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: use uclk pstate latency for fw assisted mclk validation dcn32

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator_registry: Add support for Surface Pro 9

Hans de Goede <hdegoede@redhat.com>
    platform/x86: acer-wmi: Enable SW_TABLET_MODE on Switch V 10 (SW5-017)

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    platform/x86: asus-wmi: add missing pci_dev_put() in asus_wmi_set_xusb2pr()

Lennard Gäher <gaeher@mpi-sws.org>
    platform/x86: thinkpad_acpi: Enable s2idle quirk for 21A1 machine type

ruanjinjie <ruanjinjie@huawei.com>
    xen/platform-pci: add missing free_irq() in error path

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen-pciback: Allow setting PCI_MSIX_FLAGS_MASKALL too

Olivier Moysan <olivier.moysan@foss.st.com>
    ASoC: stm32: dfsdm: manage cb buffers cleanup

Takashi Iwai <tiwai@suse.de>
    Input: i8042 - apply probe defer to more ASUS ZenBook models

Anjana Hari <quic_ahari@quicinc.com>
    pinctrl: qcom: sc8280xp: Rectify UFS reset pins

Hans de Goede <hdegoede@redhat.com>
    Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]

Hans de Goede <hdegoede@redhat.com>
    Input: soc_button_array - add use_low_level_irq module parameter

Zhu Ning <zhuning0077@gmail.com>
    ASoC: sof_es8336: reduce pop noise on speaker

Peter Zijlstra <peterz@infradead.org>
    bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)

Hans de Goede <hdegoede@redhat.com>
    Input: goodix - try resetting the controller when no config is set

Fedor Pchelkin <pchelkin@ispras.ru>
    Revert "tty: n_gsm: replace kicktimer with delayed_work"

Fedor Pchelkin <pchelkin@ispras.ru>
    Revert "tty: n_gsm: avoid call of sleeping functions from atomic context"

Lukas Wunner <lukas@wunner.de>
    serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: ipc3-topology: use old pipeline teardown flow with SOF2.1 and older

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: hda: intel-dsp-config: add ES83x6 quirk for IceLake

Matti Vaittinen <mazziesaccount@gmail.com>
    tools: iio: iio_generic_buffer: Fix read size

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: soc-acpi: add ES83x6 support to IceLake

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcht_es8316: Add quirk for the Nanote UMPC-01

Brent Mendelsohn <mendiebm@gmail.com>
    ASoC: amd: yc: Add Alienware m17 R5 AMD into DMI table

Aman Dhoot <amandhoot12@gmail.com>
    Input: synaptics - switch touchpad on HP Laptop 15-da3001TU to RMI mode

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: SOF: Intel: hda-codec: fix possible memory leak in hda_codec_device_init()

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: Intel: Skylake: fix possible memory leak in skl_codec_device_init()

Gaosheng Cui <cuigaosheng1@huawei.com>
    ASoC: Intel: fix unused-variable warning in probe_codec

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: SOF: Fix compilation when HDA_AUDIO_CODEC config is disabled

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Set _PAGE_DIRTY only if _PAGE_WRITE is set in {pmd,pte}_mkdirty()

Huacai Chen <chenhuacai@kernel.org>
    LoongArch: Clear FPU/SIMD thread info flags for kernel thread

Li Liguang <liliguang@baidu.com>
    mm: correctly charge compressed memory to its memcg

Qi Zheng <zhengqi.arch@bytedance.com>
    mm: fix unexpected changes to {failslab|fail_page_alloc}.attr

Michael Kelley <mikelley@microsoft.com>
    x86/ioremap: Fix page aligned size calculation in __ioremap_caller()

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Add enumeration check before spec MSRs save/restore setup

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Add a feature bit for TSX control MSR support

David Woodhouse <dwmw@amazon.co.uk>
    KVM: Update gfn_to_pfn_cache khva when it moves within the same page

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: remove exit_int_info warning in svm_handle_exit

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: add kvm_leave_nested

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: harden svm_free_nested against freeing vmcb02 while still in use

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: forcibly leave nested mode on vCPU reset

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: nSVM: leave nested mode on vCPU free

Sean Christopherson <seanjc@google.com>
    drm/i915/gvt: Get reference to KVM iff attachment to VM is successful

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Validate port number in SCHEDOP_poll

David Woodhouse <dwmw@amazon.co.uk>
    KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0

Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
    KVM: x86/mmu: Fix race condition in direct_page_fault

Russ Weight <russell.h.weight@intel.com>
    fpga: m10bmc-sec: Fix kconfig dependencies

Johannes Weiner <hannes@cmpxchg.org>
    mm: vmscan: fix extreme overreclaim and swap floods

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    mm/cgroup/reclaim: fix dirty pages throttling on cgroup v1

Mukesh Ojha <quic_mojha@quicinc.com>
    gcov: clang: fix the buffer overflow issue

Chen Zhongjin <chenzhongjin@huawei.com>
    nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty

Jens Axboe <axboe@kernel.dk>
    io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: make poll refs more robust

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: cmpxchg for poll arm refs release

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Clear ep descriptor last

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Return -ESHUTDOWN on ep disable

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: dwc3: gadget: conditionally remove requests

George Shen <george.shen@amd.com>
    drm/amd/display: Fix calculation for cursor CAB allocation

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Update MALL SS NumWays calculation

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Add debug option for allocating extra way for cursor

Lee, Alvin <Alvin.Lee2@amd.com>
    drm/amd/display: Added debug option for forcing subvp num ways

Jay Cornwall <jay.cornwall@amd.com>
    drm/amdkfd: update GFX11 CWSR trap handler

David Belanger <david.belanger@amd.com>
    drm/amdgpu: Enable SA software trap.

Randy Dunlap <rdunlap@infradead.org>
    nios2: add FORCE for vmlinuz.gz

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix reads with a non-zero offset that don't end on a page boundary

Alexandre Belloni <alexandre.belloni@bootlin.com>
    init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: spi-imx: spi_imx_transfer_one(): check for DMA transfer first

Frieder Schrempf <frieder.schrempf@kontron.de>
    spi: spi-imx: Fix spi_bus_clk if requested clock is higher than input clock

Linus Walleij <linus.walleij@linaro.org>
    bus: ixp4xx: Don't touch bit 7 on IXP42x

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: Fix active zone accounting

Wyes Karny <wyes.karny@amd.com>
    cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init

Peter Gonda <pgonda@google.com>
    virt/sev-guest: Prevent IV reuse in the SNP guest driver

SeongJae Park <sj@kernel.org>
    mm/damon/sysfs-schemes: skip stats update if the scheme directory is removed

Billy Tsai <billy_tsai@aspeedtech.com>
    dt-bindings: iio: adc: Remove the property "aspeed,trim-data-valid"

Dong Chenchen <dongchenchen2@huawei.com>
    iio: accel: bma400: Fix memory leak in bma400_get_steps_reg()

Chen Zhongjin <chenzhongjin@huawei.com>
    iio: core: Fix entry not deleted when iio_register_sw_trigger_type() fails

Alejandro Concepción Rodríguez <asconcepcion@acoro.eu>
    iio: light: apds9960: fix wrong register for gesture gain

Billy Tsai <billy_tsai@aspeedtech.com>
    iio: adc: aspeed: Remove the trim valid dts property.

Sam James <sam@gentoo.org>
    kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible

Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
    arm64: dts: rockchip: lower rk3399-puma-haikou SD controller clock frequency

Baokun Li <libaokun1@huawei.com>
    ext4: fix use-after-free in ext4_ext_shift_extents

Dan Carpenter <dan.carpenter@oracle.com>
    cifs: Use after free in debug code

ChenXiaoSong <chenxiaosong2@huawei.com>
    cifs: fix missing unlock in cifs_file_copychunk_range()

Jason Ekstrand <jason@jlekstrand.net>
    dma-buf: Use dma_fence_unwrap_for_each when importing fences

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix issue with Clear Feature Halt Endpoint

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc3: exynos: Fix remove() function

Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>
    can: gs_usb: remove dma allocations

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    lib/vdso: use "grep -E" instead of "egrep"

Lin Ma <linma@zju.edu.cn>
    io_uring/poll: fix poll_refs race with cancelation

Lin Ma <linma@zju.edu.cn>
    io_uring/filetable: fix file reference underflow

Heiko Carstens <hca@linux.ibm.com>
    s390/crashdump: fix TOD programmable field size

Yu Liao <liaoyu15@huawei.com>
    net: thunderx: Fix the ACPI memory leak

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    octeontx2-af: Fix reference count issue in rvu_sdp_init()

Li Zetao <lizetao1@huawei.com>
    virtio_net: Fix probe failed when modprobe virtio_net

Hanjun Guo <guohanjun@huawei.com>
    net: wwan: t7xx: Fix the ACPI memory leak

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    octeontx2-pf: Add check for devm_kcalloc

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: preserve TX ring priority across reconfiguration

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: cache accesses to &priv->si->hw

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: marvell: prestera: add missing unregister_netdev() in prestera_port_create()

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix memory leaks in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION

David Howells <dhowells@redhat.com>
    fscache: fix OOB Read in __fscache_acquire_volume

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: fix no record found for raw_track_access

Wei Yongjun <weiyongjun1@huawei.com>
    s390/ap: fix memory leak in ap_init_qci_info()

Santiago Ruano Rincón <santiago.ruano-rincon@imt-atlantique.fr>
    net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP

Yuan Can <yuancan@huawei.com>
    net: dm9051: Fix missing dev_kfree_skb() in dm9051_loop_rx()

Wang Hai <wanghai38@huawei.com>
    arcnet: fix potential memory leak in com20020_probe()

Ziyang Xuan <william.xuanziyang@huawei.com>
    ipv4: Fix error return code in fib_table_insert()

Yan Cangang <nalanzeyu@gmail.com>
    net: ethernet: mtk_eth_soc: fix resource leak in error path

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: move ppe table hash offset to mtk_soc_data structure

Lorenzo Bianconi <lorenzo@kernel.org>
    net: ethernet: mtk_eth_soc: move gdma_to_ppe and ppe_base definitions in mtk register map

Ziyang Xuan <william.xuanziyang@huawei.com>
    net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()

Kuniyuki Iwashima <kuniyu@amazon.com>
    dccp/tcp: Reset saddr on failure after inet6?_hash_connect().

Li Hua <hucool.lihua@huawei.com>
    test_kprobes: fix implicit declaration error of test_kprobes

Christoph Hellwig <hch@lst.de>
    blk-mq: fix queue reference leak on blk_mq_alloc_disk_for_queue failure

Svyatoslav Feldsherov <feldsherov@google.com>
    fs: do not update freeing inode i_io_list

Felix Fietkau <nbd@nbd.name>
    netfilter: flowtable_offload: add missing locking

Jozsef Kadlecsik <kadlec@netfilter.org>
    netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface

Perry Yuan <Perry.Yuan@amd.com>
    cpufreq: amd-pstate: change amd-pstate driver to be built-in type

Gerhard Engleder <gerhard@engleder-embedded.com>
    tsnep: Fix rotten packets

Dawei Li <set_pte_at@outlook.com>
    dma-buf: fix racing conflict of dma_heap_add()

Yang Yingliang <yangyingliang@huawei.com>
    bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()

Andreas Kemnade <andreas@kemnade.info>
    regulator: twl6030: re-add TWL6032_SUBCLASS

Liu Shixin <liushixin2@huawei.com>
    NFC: nci: fix memory leak in nci_rx_data_packet()

Xin Long <lucien.xin@gmail.com>
    net: sched: allow act_ct to be built without NF_NAT

Liu Jian <liujian56@huawei.com>
    net: sparx5: fix error handling in sparx5_port_open()

Zhang Changzhong <zhangchangzhong@huawei.com>
    sfc: fix potential memleak in __ef100_hard_start_xmit()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    net: wwan: iosm: use ACPI_FREE() but not kfree() in ipc_pcie_read_bios_cfg()

Chen Zhongjin <chenzhongjin@huawei.com>
    xfrm: Fix ignored return value in xfrm6_init()

Thomas Jarosch <thomas.jarosch@intra2net.com>
    xfrm: Fix oops in __xfrm_state_delete()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    zonefs: Fix race between modprobe and mount

YueHaibing <yuehaibing@huawei.com>
    tipc: check skb_linearize() return value in tipc_disc_rcv()

Xin Long <lucien.xin@gmail.com>
    tipc: add an extra conn_get in tipc_conn_alloc

Xin Long <lucien.xin@gmail.com>
    tipc: set con sock in tipc_conn_alloc

Wei Yongjun <weiyongjun1@huawei.com>
    net: phy: at803x: fix error return code in at803x_probe()

Chris Mi <cmi@nvidia.com>
    net/mlx5e: Offload rule only when all encaps are valid

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix sync reset event handler error flow

Roi Dayan <roid@nvidia.com>
    net/mlx5: E-Switch, Set correctly vport destination

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix handling of entry refcount when command is not issued to FW

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: cmdif, Print info on any firmware cmd failure to tracepoint

Shay Drory <shayd@nvidia.com>
    net/mlx5: SF: Fix probing active SFs during driver probe phase

Moshe Shemesh <moshe@nvidia.com>
    net/mlx5: Fix FW tracer timestamp calculation

Roy Novich <royno@nvidia.com>
    net/mlx5: Do not query pci info while pci disabled

Vishwanath Pai <vpai@akamai.com>
    netfilter: ipset: regression in ip_set_hash_ip.c

Yang Yingliang <yangyingliang@huawei.com>
    Drivers: hv: vmbus: fix possible memory leak in vmbus_device_register()

Yang Yingliang <yangyingliang@huawei.com>
    Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix warn in intel_display_power_*_domain() functions

YueHaibing <yuehaibing@huawei.com>
    macsec: Fix invalid error code set

Hangbin Liu <liuhangbin@gmail.com>
    bonding: fix ICMPv6 header handling when receiving IPv6 messages

Jaco Coetzee <jaco.coetzee@corigine.com>
    nfp: add port from netdev validation for EEPROM access

Diana Wang <na.wang@corigine.com>
    nfp: fill splittable of devlink_port_attrs correctly

Yang Yingliang <yangyingliang@huawei.com>
    net: pch_gbe: fix pci device refcount leak while module exiting

Yang Yingliang <yangyingliang@huawei.com>
    octeontx2-af: debugsfs: fix pci device refcount leak

Zhang Changzhong <zhangchangzhong@huawei.com>
    net/qla3xxx: fix potential memleak in ql3xxx_send()

Hui Tang <tanghui20@huawei.com>
    net: mvpp2: fix possible invalid pointer dereference

Peter Kosyh <pkosyh@yandex.ru>
    net/mlx4: Check retval of mlx4_bitmap_init

Liu Jian <liujian56@huawei.com>
    net: ethernet: mtk_eth_soc: fix error handling in mtk_open()

Fabio Estevam <festevam@denx.de>
    ARM: dts: imx6q-prti6q: Fix ref/tcxo-clock-frequency properties

Zheng Yongjun <zhengyongjun3@huawei.com>
    ARM: mxs: fix memory leak in mxs_machine_init()

Slawomir Laba <slawomirx.laba@intel.com>
    iavf: Fix race condition between iavf_shutdown and iavf_remove

Stefan Assmann <sassmann@kpanic.de>
    iavf: remove INITIAL_MAC_SET to allow gARP to work properly

Ivan Vecera <ivecera@redhat.com>
    iavf: Do not restart Tx queues after reset task failure

Ivan Vecera <ivecera@redhat.com>
    iavf: Fix a crash during reset task

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: do not set up extensions for end interval

Daniel Xu <dxu@dxuuu.xyz>
    netfilter: conntrack: Fix data-races around ct mark

Zhengchao Shao <shaozhengchao@huawei.com>
    9p/fd: fix issue of list_del corruption in p9_fd_cancel()

Wang Hai <wanghai38@huawei.com>
    net: pch_gbe: fix potential memleak in pch_gbe_tx_queue()

Lin Ma <linma@zju.edu.cn>
    nfc/nci: fix race with opening and closing

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus

David Howells <dhowells@redhat.com>
    rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]

Mahesh Bandewar <maheshb@google.com>
    ipvlan: hold lower dev to avoid possible use-after-free

Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
    net: neigh: decrement the family specific qlen

Leon Romanovsky <leon@kernel.org>
    net: liquidio: simplify if expression

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: fix mibit vs mbit mix up

Matthieu Baerts <matthieu.baerts@tessares.net>
    selftests: mptcp: run mptcp_sockopt from a new netns

Paolo Abeni <pabeni@redhat.com>
    selftests: mptcp: gives slow test-case more time

Michael Grzeschik <m.grzeschik@pengutronix.de>
    ARM: dts: at91: sam9g20ek: enable udc vbus gpio pinctrl

Krishna Yarlagadda <kyarlagadda@nvidia.com>
    spi: tegra210-quad: Fix duplicate resource error

Yang Yingliang <yangyingliang@huawei.com>
    tee: optee: fix possible memory leak in optee_register_device()

Samuel Holland <samuel@sholland.org>
    bus: sunxi-rsb: Support atomic transfers

Samuel Holland <samuel@sholland.org>
    bus: sunxi-rsb: Remove the shutdown callback

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix UAF in destroy_regulator()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    spi: dw-dma: decrease reference count in dw_spi_dma_init_mfld()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: rt5759: fix OOB in validate_desc()

Zeng Heng <zengheng4@huawei.com>
    regulator: core: fix kobject release warning and memory leak in regulator_register()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: max98373: Add checks for devm_kcalloc

Chen-Yu Tsai <wens@csie.org>
    arm64: dts: rockchip: Fix Pine64 Quartz4-B PMIC interrupt

Dexuan Cui <decui@microsoft.com>
    PCI: hv: Only reuse existing IRTE allocation for Multi-MSI

Michael Kelley <mikelley@microsoft.com>
    scsi: storvsc: Fix handling of srb_status and capacity change events

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/hyperv: Restore VP assist page after cpu offlining/onlining

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: soc-pcm: Don't zero TDM masks in __soc_pcm_open()

Detlev Casanova <detlev.casanova@collabora.com>
    ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove

Junxiao Chang <junxiao.chang@intel.com>
    ASoC: hdac_hda: fix hda pcm buffer overflow issue

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Drop hdac_ext usage for codec device creation

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: SOF: Intel: Introduce HDA codec init and exit routines

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Introduce HDA codec init and exit routines

Dominik Haller <d.haller@phytec.de>
    ARM: dts: am335x-pcm-953: Define fixed regulators in root node

Linus Walleij <linus.walleij@linaro.org>
    power: supply: ab8500: Defer thermal zone probe

Ondrej Jirman <megi@xff.cz>
    power: supply: ip5xxx: Fix integer overflow in current_now calculation

Herbert Xu <herbert@gondor.apana.org.au>
    af_key: Fix send_acquire race with pfkey_register

Christian Langrock <christian.langrock@secunet.com>
    xfrm: replay: Fix ESN wrap around for GSO

Lev Popov <leo@nabam.net>
    arm64: dts: rockchip: fix quartz64-a bluetooth configuration

Eyal Birger <eyal.birger@gmail.com>
    xfrm: fix "disable_policy" on ipv4 early demux

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/poll: lockdep annote io_poll_req_insert_locked

Jason A. Donenfeld <Jason@zx2c4.com>
    MIPS: pic32: treat port as signed integer

Nathan Chancellor <nathan@kernel.org>
    RISC-V: vdso: Do not add missing symbols to version section in linker script

Ai Chao <aichao@kylinos.cn>
    ALSA: usb-audio: add quirk to fix Hamedal C20 disconnect issue

Hamza Mahfooz <hamza.mahfooz@amd.com>
    drm/amd/display: only fill dirty rectangles when PSR is enabled

Philip Yang <Philip.Yang@amd.com>
    drm/amdgpu: Drop eviction lock when allocating PT BO

Asher Song <Asher.Song@amd.com>
    Revert "drm/amdgpu: Revert "drm/amdgpu: getting fan speed pwm for vega10 properly""

Steve Su <steve.su@amd.com>
    drm/amd/display: Fix gpio port mapping issue

Chaitanya Dhere <chaitanya.dhere@amd.com>
    drm/amd/display: Fix FCLK deviation and tool compile issues

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: Zeromem mypipe heap struct before using it

M Chetan Kumar <m.chetan.kumar@linux.intel.com>
    net: wwan: iosm: fix kernel test robot reported errors

Aleksandr Miloserdov <a.miloserdov@yadro.com>
    nvmet: fix memory leak in nvmet_subsys_attr_model_store_locked

Keith Busch <kbusch@kernel.org>
    nvme: quiet user passthrough command errors

Kuniyuki Iwashima <kuniyu@amazon.com>
    arm64/syscall: Include asm/ptrace.h in syscall_wrapper header.

Heiko Carstens <hca@linux.ibm.com>
    s390: always build relocatable kernel

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix null pointer dereference in bfq_bio_bfqg()

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Acer Switch V 10 (SW5-017)

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Nanote UMPC-01

Bart Van Assche <bvanassche@acm.org>
    scsi: scsi_debug: Make the READ CAPACITY response compliant with ZBC

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Avoid path failures during live migration

Ivan Hu <ivan.hu@canonical.com>
    platform/x86/intel/hid: Add some ACPI device IDs

David E. Box <david.e.box@linux.intel.com>
    platform/x86/intel/pmt: Sapphire Rapids PMT errata fix

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the RCA Cambio W101 v2 2-in-1

Manyi Li <limanyi@uniontech.com>
    platform/x86: ideapad-laptop: Disable touchpad_switch

Hans de Goede <hdegoede@redhat.com>
    ACPI: video: Add backlight=native DMI quirk for Dell G15 5515

Sabrina Dubroca <sd@queasysnail.net>
    Revert "net: macsec: report real_dev features when HW offloading is enabled"

Adrien Thierry <athierry@redhat.com>
    selftests/net: give more time to udpgro bg processes to complete startup

Youlin Li <liulin063@gmail.com>
    selftests/bpf: Add verifier test for release_reference()

Sean Nyekjaer <sean@geanix.com>
    spi: stm32: fix stm32_spi_prepare_mbr() that halves spi clk for every run

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: fix warning about field-spanning write

Tyler J. Stachecki <stachecki.tyler@gmail.com>
    wifi: ath11k: Fix QCN9074 firmware boot on x86

Pavel Begunkov <asml.silence@gmail.com>
    selftests/net: don't tests batched TCP io_uring zc

Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
    wifi: mac80211: Fix ack frame idr leak when mesh has no route

Jason A. Donenfeld <Jason@zx2c4.com>
    wifi: airo: do not assign -1 to unsigned char

Gaosheng Cui <cuigaosheng1@huawei.com>
    audit: fix undefined behavior in bit shift for AUDIT_BIT

Emil Renner Berthing <emil.renner.berthing@canonical.com>
    riscv: dts: sifive unleashed: Add PWM controlled LEDs

Jon Hunter <jonathanh@nvidia.com>
    spi: tegra210-quad: Don't initialise DMA if not supported

Jonas Jelonek <jelonek.jonas@gmail.com>
    wifi: mac80211_hwsim: fix debugfs attribute ps with rc table support

Paul Zhang <quic_paulz@quicinc.com>
    wifi: cfg80211: Fix bitrates overflow issue

taozhang <taozhang@bestechnic.com>
    wifi: mac80211: fix memory free error when registering wiphy fail

Xiubo Li <xiubli@redhat.com>
    ceph: fix NULL pointer dereference for req->r_session

Kenneth Lee <klee33@uw.edu>
    ceph: Use kcalloc for allocating multiple elements

Carlos Llamas <cmllamas@google.com>
    binder: validate alloc->mm in ->mmap() handler


-------------

Diffstat:

 .../bindings/iio/adc/aspeed,ast2600-adc.yaml       |   7 -
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-pcm-953.dtsi              |  28 ++-
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi        |   9 +
 arch/arm/boot/dts/imx6q-prti6q.dts                 |   4 +-
 arch/arm/mach-mxs/mach-mxs.c                       |   4 +-
 .../arm64/boot/dts/rockchip/rk3399-puma-haikou.dts |   2 +-
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts |   7 +-
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts |   2 +-
 arch/arm64/include/asm/syscall_wrapper.h           |   2 +-
 arch/loongarch/include/asm/pgtable.h               |   8 +-
 arch/loongarch/kernel/process.c                    |   9 +-
 arch/mips/include/asm/fw/fw.h                      |   2 +-
 arch/mips/pic32/pic32mzda/early_console.c          |  13 +-
 arch/mips/pic32/pic32mzda/init.c                   |   2 +-
 arch/nios2/boot/Makefile                           |   2 +-
 .../riscv/boot/dts/sifive/hifive-unleashed-a00.dts |  38 ++++
 arch/riscv/kernel/vdso/Makefile                    |   3 +
 arch/riscv/kernel/vdso/vdso.lds.S                  |   2 +
 arch/s390/Kconfig                                  |   6 +-
 arch/s390/Makefile                                 |   2 -
 arch/s390/boot/Makefile                            |   3 +-
 arch/s390/boot/startup.c                           |   3 +-
 arch/s390/kernel/crash_dump.c                      |   2 +-
 arch/x86/hyperv/hv_init.c                          |  54 +++---
 arch/x86/include/asm/cpufeatures.h                 |   3 +
 arch/x86/kernel/cpu/tsx.c                          |  38 ++--
 arch/x86/kvm/mmu/mmu.c                             |  13 +-
 arch/x86/kvm/svm/nested.c                          |   6 +-
 arch/x86/kvm/svm/svm.c                             |  16 +-
 arch/x86/kvm/vmx/nested.c                          |   3 -
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/kvm/xen.c                                 |  32 +++-
 arch/x86/mm/ioremap.c                              |   8 +-
 arch/x86/power/cpu.c                               |  23 ++-
 block/bfq-cgroup.c                                 |   4 +
 block/blk-mq.c                                     |   7 +-
 block/blk-settings.c                               |   1 -
 block/blk.h                                        |   1 +
 drivers/acpi/video_detect.c                        |  14 ++
 drivers/android/binder_alloc.c                     |   7 +
 drivers/bus/intel-ixp4xx-eb.c                      |   9 +-
 drivers/bus/sunxi-rsb.c                            |  38 ++--
 drivers/cpufreq/Kconfig.x86                        |   2 +-
 drivers/cpufreq/amd-pstate.c                       |  21 +-
 drivers/dma-buf/dma-buf.c                          |  23 ++-
 drivers/dma-buf/dma-heap.c                         |  28 +--
 drivers/fpga/Kconfig                               |   4 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_aldebaran.c   |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c     |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |   8 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c            |   6 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |  16 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  26 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |  26 +++
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c          |   2 +
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   6 +-
 drivers/gpu/drm/amd/amdkfd/cwsr_trap_handler.h     |  31 +--
 .../gpu/drm/amd/amdkfd/cwsr_trap_handler_gfx10.asm |  27 +++
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  44 ++++-
 drivers/gpu/drm/amd/display/dc/dc.h                |   3 +
 .../drm/amd/display/dc/dce120/dce120_resource.c    |   3 +-
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c | 213 ++++++++++-----------
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c  |   1 +
 .../amd/display/dc/dcn32/dcn32_resource_helpers.c  |  11 +-
 .../drm/amd/display/dc/dcn321/dcn321_resource.c    |   1 +
 .../gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c   |  22 ++-
 .../amd/display/dc/dml/dcn32/display_mode_vba_32.c |   1 +
 .../dc/dml/dcn32/display_mode_vba_util_32.c        |   2 +-
 .../dc/dml/dcn32/display_mode_vba_util_32.h        |   2 +-
 .../gpu/drm/amd/display/dc/dml/dcn321/dcn321_fpu.c |   8 +-
 .../amd/display/dc/gpio/dcn32/hw_factory_dcn32.c   |  14 ++
 drivers/gpu/drm/amd/display/dc/gpio/hw_ddc.c       |   9 +-
 .../drm/amd/pm/powerplay/hwmgr/vega10_thermal.c    |  25 ++-
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |   4 +
 drivers/gpu/drm/display/drm_dp_mst_topology.c      |   2 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  12 ++
 drivers/gpu/drm/i915/display/intel_display_power.c |   8 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |   4 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   5 +
 drivers/gpu/drm/i915/gvt/kvmgt.c                   |   3 +-
 drivers/gpu/drm/tegra/drm.c                        |   4 +
 drivers/gpu/host1x/dev.c                           |   4 +
 drivers/hv/channel_mgmt.c                          |   6 +-
 drivers/hv/vmbus_drv.c                             |   1 +
 drivers/iio/accel/bma400_core.c                    |   4 +-
 drivers/iio/adc/aspeed_adc.c                       |  11 +-
 drivers/iio/industrialio-sw-trigger.c              |   6 +-
 drivers/iio/light/apds9960.c                       |  12 +-
 drivers/input/misc/soc_button_array.c              |  14 +-
 drivers/input/mouse/synaptics.c                    |   1 +
 drivers/input/serio/i8042-x86ia64io.h              |   8 +-
 drivers/input/touchscreen/goodix.c                 |  11 ++
 drivers/md/dm-integrity.c                          |  21 +-
 drivers/md/dm-log-writes.c                         |   1 +
 drivers/net/arcnet/com20020_cs.c                   |  11 +-
 drivers/net/bonding/bond_main.c                    |  17 +-
 drivers/net/can/usb/gs_usb.c                       |  39 +---
 drivers/net/dsa/sja1105/sja1105_mdio.c             |   6 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  12 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |   4 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |   4 +-
 drivers/net/ethernet/davicom/dm9051.c              |   4 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |  57 +++++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  32 ++--
 drivers/net/ethernet/freescale/enetc/enetc.h       |  10 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  77 ++++----
 drivers/net/ethernet/intel/iavf/iavf.h             |   1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  41 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   8 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   3 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_sdp.c    |   7 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   1 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  31 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   5 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  24 ++-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |   4 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  47 ++---
 .../mellanox/mlx5/core/diag/cmd_tracepoint.h       |  45 +++++
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  16 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  17 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   9 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |  88 +++++++++
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |  14 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   3 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |   1 +
 drivers/net/ethernet/sfc/ef100_netdev.c            |   1 +
 drivers/net/ipvlan/ipvlan.h                        |   1 +
 drivers/net/ipvlan/ipvlan_main.c                   |   2 +
 drivers/net/macsec.c                               |  28 +--
 drivers/net/phy/at803x.c                           |   4 +-
 drivers/net/usb/cdc_ncm.c                          |   1 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/virtio_net.c                           |   3 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |   2 +-
 drivers/net/wireless/cisco/airo.c                  |  18 +-
 drivers/net/wireless/mac80211_hwsim.c              |   5 +
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  39 +++-
 drivers/net/wireless/microchip/wilc1000/hif.c      |  21 +-
 drivers/net/wwan/iosm/iosm_ipc_coredump.c          |   1 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c           |   1 +
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |   2 +-
 drivers/net/wwan/t7xx/t7xx_modem_ops.c             |   2 +
 drivers/nfc/st-nci/se.c                            |  49 +++--
 drivers/nvme/host/core.c                           |   3 +-
 drivers/nvme/host/pci.c                            |   2 -
 drivers/nvme/target/configfs.c                     |   7 +-
 drivers/pci/controller/pci-hyperv.c                |  90 +++++++--
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c            |   4 +-
 .../platform/surface/surface_aggregator_registry.c |  37 ++++
 drivers/platform/x86/acer-wmi.c                    |   9 +
 drivers/platform/x86/asus-wmi.c                    |   2 +
 drivers/platform/x86/hp-wmi.c                      |   3 +
 drivers/platform/x86/ideapad-laptop.c              |  62 +++++-
 drivers/platform/x86/intel/hid.c                   |   3 +
 drivers/platform/x86/intel/pmt/class.c             |  31 ++-
 drivers/platform/x86/thinkpad_acpi.c               |   8 +
 drivers/platform/x86/touchscreen_dmi.c             |  25 +++
 drivers/power/supply/ab8500_btemp.c                |   9 +-
 drivers/power/supply/ip5xxx_power.c                |   2 +-
 drivers/regulator/core.c                           |   8 +-
 drivers/regulator/rt5759-regulator.c               |   1 +
 drivers/regulator/twl6030-regulator.c              |   2 +
 drivers/s390/block/dasd_eckd.c                     |   6 +-
 drivers/s390/crypto/ap_bus.c                       |   5 +-
 drivers/s390/crypto/zcrypt_msgtype6.c              |  21 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  14 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   3 +-
 drivers/scsi/scsi_debug.c                          |   7 +
 drivers/scsi/scsi_transport_iscsi.c                |  31 +--
 drivers/scsi/storvsc_drv.c                         |  69 ++++---
 drivers/spi/spi-dw-dma.c                           |   3 +
 drivers/spi/spi-imx.c                              |  13 +-
 drivers/spi/spi-stm32.c                            |   2 +-
 drivers/spi/spi-tegra210-quad.c                    |   9 +-
 drivers/tee/optee/device.c                         |   2 +-
 drivers/tty/n_gsm.c                                |  69 +++----
 drivers/tty/serial/8250/8250_omap.c                |   7 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  12 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |  17 +-
 drivers/usb/dwc3/dwc3-exynos.c                     |  11 +-
 drivers/usb/dwc3/gadget.c                          |  22 +--
 drivers/virt/coco/sev-guest/sev-guest.c            |  84 ++++++--
 drivers/xen/platform-pci.c                         |   7 +-
 drivers/xen/xen-pciback/conf_space_capability.c    |   9 +-
 fs/btrfs/ioctl.c                                   |  23 ++-
 fs/btrfs/sysfs.c                                   |   7 +-
 fs/btrfs/tree-log.c                                |  59 +++++-
 fs/btrfs/zoned.c                                   |   9 +-
 fs/ceph/caps.c                                     |  50 ++---
 fs/cifs/cifsfs.c                                   |   4 +-
 fs/cifs/sess.c                                     |   4 +-
 fs/ext4/extents.c                                  |  18 +-
 fs/fs-writeback.c                                  |  30 +--
 fs/fscache/volume.c                                |   7 +-
 fs/fuse/file.c                                     |  37 ++--
 fs/nfsd/vfs.c                                      |   7 +-
 fs/nilfs2/sufile.c                                 |   8 +
 fs/zonefs/super.c                                  |  60 ++++--
 fs/zonefs/zonefs.h                                 |   6 +-
 include/linux/blkdev.h                             |   1 -
 include/linux/bpf.h                                |  39 +++-
 include/linux/fault-inject.h                       |   7 +-
 include/linux/fscache.h                            |   2 +-
 include/linux/license.h                            |   2 +
 include/linux/mlx5/driver.h                        |   1 +
 include/net/neighbour.h                            |   2 +-
 include/sound/sof/info.h                           |   4 +
 include/uapi/linux/audit.h                         |   2 +-
 init/Kconfig                                       |   2 +-
 io_uring/filetable.c                               |   2 -
 io_uring/io_uring.h                                |   9 +-
 io_uring/poll.c                                    |  49 ++++-
 kernel/bpf/dispatcher.c                            |  22 +--
 kernel/gcov/clang.c                                |   2 +
 lib/Kconfig.debug                                  |   1 +
 lib/fault-inject.c                                 |  13 +-
 lib/vdso/Makefile                                  |   2 +-
 mm/damon/sysfs.c                                   |   4 +
 mm/failslab.c                                      |  12 +-
 mm/memcontrol.c                                    |   2 +-
 mm/page_alloc.c                                    |   7 +-
 mm/vmscan.c                                        |  24 ++-
 net/9p/trans_fd.c                                  |   2 +
 net/core/flow_dissector.c                          |   2 +-
 net/core/neighbour.c                               |  58 +++---
 net/dccp/ipv4.c                                    |   2 +
 net/dccp/ipv6.c                                    |   2 +
 net/ipv4/Kconfig                                   |  10 +
 net/ipv4/esp4_offload.c                            |   3 +
 net/ipv4/fib_trie.c                                |   4 +-
 net/ipv4/inet_hashtables.c                         |  10 +-
 net/ipv4/ip_input.c                                |   5 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   4 +-
 net/ipv4/tcp_ipv4.c                                |   2 +
 net/ipv6/esp6_offload.c                            |   3 +
 net/ipv6/tcp_ipv6.c                                |   2 +
 net/ipv6/xfrm6_policy.c                            |   6 +-
 net/key/af_key.c                                   |  34 ++--
 net/mac80211/main.c                                |   8 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   2 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |   8 +-
 net/netfilter/nf_conntrack_core.c                  |   2 +-
 net/netfilter/nf_conntrack_netlink.c               |  24 ++-
 net/netfilter/nf_conntrack_standalone.c            |   2 +-
 net/netfilter/nf_flow_table_offload.c              |   4 +
 net/netfilter/nf_tables_api.c                      |   6 +-
 net/netfilter/nft_ct.c                             |   6 +-
 net/netfilter/xt_connmark.c                        |  18 +-
 net/nfc/nci/core.c                                 |   2 +-
 net/nfc/nci/data.c                                 |   4 +-
 net/openvswitch/conntrack.c                        |   8 +-
 net/rxrpc/ar-internal.h                            |   1 +
 net/rxrpc/conn_client.c                            |  38 ++--
 net/sched/Kconfig                                  |   2 +-
 net/sched/act_connmark.c                           |   4 +-
 net/sched/act_ct.c                                 |   8 +-
 net/sched/act_ctinfo.c                             |   6 +-
 net/tipc/discover.c                                |   5 +-
 net/tipc/topsrv.c                                  |  20 +-
 net/wireless/util.c                                |   6 +-
 net/xfrm/xfrm_device.c                             |  15 +-
 net/xfrm/xfrm_replay.c                             |   2 +-
 sound/hda/intel-dsp-config.c                       |   5 +
 sound/soc/amd/yc/acp6x-mach.c                      |   7 +
 sound/soc/codecs/hdac_hda.c                        |  26 +--
 sound/soc/codecs/hdac_hda.h                        |   6 +-
 sound/soc/codecs/max98373-i2c.c                    |   4 +
 sound/soc/codecs/sgtl5000.c                        |   1 +
 sound/soc/intel/boards/bytcht_es8316.c             |   7 +
 sound/soc/intel/boards/hda_dsp_common.c            |   2 +-
 sound/soc/intel/boards/skl_hda_dsp_generic.c       |   2 +-
 sound/soc/intel/boards/sof_es8336.c                |  60 ++++--
 sound/soc/intel/common/soc-acpi-intel-icl-match.c  |  13 ++
 sound/soc/intel/skylake/skl.c                      |  49 +++--
 sound/soc/soc-pcm.c                                |   5 -
 sound/soc/sof/intel/hda-codec.c                    |  49 +++--
 sound/soc/sof/ipc3-topology.c                      |  15 +-
 sound/soc/stm/stm32_adfsdm.c                       |  11 ++
 sound/usb/endpoint.c                               |   3 +-
 sound/usb/quirks.c                                 |   2 +
 sound/usb/usbaudio.h                               |   3 +
 tools/iio/iio_generic_buffer.c                     |   4 +-
 .../testing/selftests/bpf/verifier/ref_tracking.c  |  36 ++++
 .../testing/selftests/net/io_uring_zerocopy_tx.sh  |   2 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   6 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |   9 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   5 +-
 tools/testing/selftests/net/udpgro.sh              |   4 +-
 tools/testing/selftests/net/udpgro_bench.sh        |   2 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   2 +-
 virt/kvm/pfncache.c                                |   7 +-
 302 files changed, 2720 insertions(+), 1290 deletions(-)


