Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33FF24B23C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgHTJZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgHTJY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:24:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E14222D02;
        Thu, 20 Aug 2020 09:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915498;
        bh=VFTlbxYKEjscsqpSe2YiRzwV7eykUPtEl6inDN17aUE=;
        h=From:To:Cc:Subject:Date:From;
        b=CfA7eQ7RhLrElSnTtO1J2bDQvoaH65pdCIHjjPjDXcewQddmJsPiF3VqclJkIC+71
         NbK9TaKEDahEf0cWlhalQ+Ji+oyEP7IB4jh+G9XsTd8VBj2Vem0uR9zA1mZxAzAkkH
         nM1K2Wi00tKErOMzqbsAsJVvwryUM/SKTG2UuT7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.8 000/232] 5.8.3-rc1 review
Date:   Thu, 20 Aug 2020 11:17:31 +0200
Message-Id: <20200820091612.692383444@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.3-rc1
X-KernelTest-Deadline: 2020-08-22T09:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.3 release.
There are 232 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.3-rc1

hersen wu <hersenxs.wu@amd.com>
    drm/amd/display: dchubbub p-state warning during surface planes switch

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix dmesg warning from setting abm level

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Fix bug where DPM is not enabled after hibernate and resume

Xin Xiong <xiongx18@fudan.edu.cn>
    drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi

Marius Iacob <themariusus@gmail.com>
    drm: Added orientation quirk for ASUS tablet model T103HAF

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/tidss: fix modeset init for DPI panels

Tomi Valkeinen <tomi.valkeinen@ti.com>
    drm/omap: force runtime PM suspend on system suspend

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix the DDC I2C device unregistration of an MST port

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix timeout handling of MST down messages

Imre Deak <imre.deak@intel.com>
    drm/dp_mst: Fix the DDC I2C device registration of an MST port

Denis Efremov <efremov@linux.com>
    drm/panfrost: Use kvfree() to free bo->sgts

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Force the GT reset on shutdown

Denis Efremov <efremov@linux.com>
    drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: fault: Fix duplicate printing of "PC:"

Geert Uytterhoeven <geert+renesas@glider.be>
    sh: landisk: Add missing initialization of sh_io_port_base

Zhang Rui <rui.zhang@intel.com>
    perf/x86/rapl: Fix missing psys sysfs attributes

Daniel Díaz <daniel.diaz@linaro.org>
    tools build feature: Quote CC and CXX for their arguments

Vincent Whitchurch <vincent.whitchurch@axis.com>
    perf bench mem: Always memset source before memcpy

Dinghao Liu <dinghao.liu@zju.edu.cn>
    ALSA: echoaudio: Fix potential Oops in snd_echo_resume()

Ondrej Mosnacek <omosnace@redhat.com>
    crypto: algif_aead - fix uninitialized ctx->init

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    mfd: dln2: Run event handler loop under spinlock

Dhananjay Phadke <dphadke@linux.microsoft.com>
    i2c: iproc: fix race between client unreg and isr

Tiezhu Yang <yangtiezhu@loongson.cn>
    test_kmod: avoid potential double free in trigger_config_run_type()

Colin Ian King <colin.king@canonical.com>
    fs/ufs: avoid potential u32 multiplication overflow

Eric Biggers <ebiggers@google.com>
    fs/minix: remove expected error message in block_to_path()

Eric Biggers <ebiggers@google.com>
    fs/minix: fix block limit check for V1 filesystems

Eric Biggers <ebiggers@google.com>
    fs/minix: set s_maxbytes correctly

Tiezhu Yang <yangtiezhu@loongson.cn>
    lib/test_lockup.c: fix return value of test_lockup_init()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix flexfiles read failover

Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
    nfs: Fix getxattr kernel panic and memory overflow

Wang Hai <wanghai38@huawei.com>
    net: qcom/emac: add missed clk_disable_unprepare in error path of emac_clks_phase1_init

Krzysztof Kozlowski <krzk@kernel.org>
    s390/Kconfig: add missing ZCRYPT dependency to VFIO_AP

Wang Hai <wanghai38@huawei.com>
    s390/test_unwind: fix possible memleak in test_unwind()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Fix two list_for_each loop exit tests

Dan Carpenter <dan.carpenter@oracle.com>
    drm/vmwgfx: Use correct vmw_legacy_display_unit pointer

Dan Carpenter <dan.carpenter@oracle.com>
    vdpa: Fix pointer math bug in vdpasim_get_config()

Christophe Leroy <christophe.leroy@csgroup.eu>
    recordmcount: Fix build failure on non arm64

Michael S. Tsirkin <mst@redhat.com>
    vdpa_sim: init iommu lock

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Fix silent Makefile output

Jin Yao <yao.jin@linux.intel.com>
    perf record: Skip side-band event setup if HAVE_LIBBPF_SUPPORT is not set

Colin Ian King <colin.king@canonical.com>
    Input: sentelic - fix error return when fsp_reg_write fails

Andrii Nakryiko <andriin@fb.com>
    selftests/bpf: Prevent runqslower from racing on building bpftool

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs/multihit: Fix mitigation reporting when VMX is not in use

Dilip Kota <eswara.kota@linux.intel.com>
    x86/tsr: Fix tsc frequency enumeration bug on Lightning Mountain SoC

Muchun Song <songmuchun@bytedance.com>
    kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE

Dan Carpenter <dan.carpenter@oracle.com>
    md-cluster: Fix potential error pointer dereference in resize_bitmaps()

Tero Kristo <t-kristo@ti.com>
    watchdog: rti-wdt: balance pm runtime enable calls

Krzysztof Sobota <krzysztof.sobota@nokia.com>
    watchdog: initialize device before misc_register

Scott Mayhew <smayhew@redhat.com>
    nfs: nfs_file_write() should check for writeback errors

Ewan D. Milne <emilne@redhat.com>
    scsi: lpfc: nvmet: Avoid hang / use-after-free again when destroying targetport

Jin Yao <yao.jin@linux.intel.com>
    perf evsel: Don't set sample_regs_intr/sample_regs_user for dummy event

Stafford Horne <shorne@gmail.com>
    openrisc: Fix oops caused when dumping stack

Jane Chu <jane.chu@oracle.com>
    libnvdimm/security: ensure sysfs poll thread woke up and fetch updated attr

Jane Chu <jane.chu@oracle.com>
    libnvdimm/security: fix a typo

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    clk: bcm2835: Do not use prediv with bcm2711's PLLs

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: hsdk: Fix bad dependency on IOMEM

Zhihao Cheng <chengzhihao1@huawei.com>
    ubifs: Fix wrong orphan node deletion in ubifs_jnl_update|rename

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Free fastmap next anchor peb during detach

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Don't produce the initial next anchor PEB when fastmap is disabled

Scott Mayhew <smayhew@redhat.com>
    nfs: ensure correct writeback errors are returned on close()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: avoid race when unregistering slave

Thomas Hebb <tommyhebb@gmail.com>
    tools build feature: Use CC and CXX from parent

Jiri Olsa <jolsa@kernel.org>
    perf tools: Fix term parsing for raw syntax

Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
    pwm: bcm-iproc: handle clk_get_rate() return

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix a deadlock when enabling uclamp static key

Sagi Grimberg <sagi@grimberg.me>
    nvme: fix deadlock in disconnect during scan_work and/or ana_work

Xu Wang <vulab@iscas.ac.cn>
    clk: clk-atlas6: fix return value check in atlas6_clk_init()

Konrad Dybcio <konradybcio@gmail.com>
    clk: qcom: gcc-sdm660: Fix up gcc_mss_mnoc_bimc_axi_clk

Wei Hu <weh@microsoft.com>
    PCI: hv: Fix a timing issue which causes kdump to fail occasionally

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to update isize when overwriting compressed file

Wolfram Sang <wsa+renesas@sang-engineering.com>
    i2c: rcar: slave: only send STOP event when we have been addressed

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Disable multiple GPASID-dev bind

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Warn on out-of-range invalidation address

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Enforce PASID devTLB field mask

Liu Yi L <yi.l.liu@intel.com>
    iommu/vt-d: Handle non-page aligned address

Jonathan Marek <jonathan@marek.ca>
    clk: qcom: clk-alpha-pll: remove unused/incorrect PLL_CAL_VAL

Jonathan Marek <jonathan@marek.ca>
    clk: qcom: gcc: fix sm8150 GPU and NPU clocks

Colin Ian King <colin.king@canonical.com>
    iommu/omap: Check for failure of a call to omap_iommu_dump_ctx

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: ptrace-pkey: Don't update expected UAMOR value

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: ptrace-pkey: Update the test to mark an invalid pkey correctly

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    selftests/powerpc: ptrace-pkey: Rename variables to make it easier to follow code

Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
    clk: actions: Fix h_clk for Actions S500 SoC

Chao Yu <chao@kernel.org>
    f2fs: compress: fix to avoid memory leak on cc->cpages

Tyler Hicks <tyhicks@linux.microsoft.com>
    ima: Fail rule parsing when appraise_flag=blacklist is unsupportable

Ming Lei <ming.lei@redhat.com>
    dm rq: don't call blk_mq_queue_stopped() in dm_stop_queue()

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Wait for all EOFs before completing a tile

Steve Longerbeam <slongerbeam@gmail.com>
    gpu: ipu-v3: image-convert: Combine rotate/no-rotate irq handlers

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: caam - Remove broken arc4 support

Sudeep Holla <sudeep.holla@arm.com>
    rtc: pl031: fix set_alarm by adding back call to alarm_irq_enable

Yan-Hsuan Chuang <yhchuang@realtek.com>
    rtw88: pci: disable aspm for platform inter-op with module parameter

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    mmc: renesas_sdhi_internal_dmac: clean up the code for dma complete

Mark Zhang <markz@mellanox.com>
    RDMA/counter: Allow manually bind QPs with different pids to same counter

Mark Zhang <markz@mellanox.com>
    RDMA/counter: Only bind user QPs in auto mode

Vladimir Oltean <vladimir.oltean@nxp.com>
    devres: keep both device name and resource name in pretty name

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: af_alg - Fix regression on empty requests

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: fix break and sysrq handling

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: clean up receive processing

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: make process-packet buffer unsigned

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: test_progs avoid minus shell exit codes

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: test_progs use another shell exit on non-actions

Martin KaFai Lau <kafai@fb.com>
    bpf: selftests: Restore netns after each test

Jesper Dangaard Brouer <brouer@redhat.com>
    selftests/bpf: Test_progs indicate to shell on non-actions

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Protect uclamp fast path code with static key

Yishai Hadas <yishaih@mellanox.com>
    IB/uverbs: Set IOVA on IB MR in uverbs layer

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: rockchip: rga: Only set output CSC mode for RGB input

Paul Kocialkowski <paul.kocialkowski@bootlin.com>
    media: rockchip: rga: Introduce color fmt macros and refactor CSC mode logic

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: staging: rkisp1: rsz: set default format if the given format is not RKISP1_ISP_SD_SRC

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: staging: rkisp1: rename macros 'RKISP1_DIR_*' to 'RKISP1_ISP_SD_*'

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: staging: rkisp1: remove macro RKISP1_DIR_SINK_SRC

Sebastian Reichel <sebastian.reichel@collabora.com>
    rtc: cpcap: fix range

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/ipoib: Fix ABBA deadlock with ipoib_reap_ah()

Kamal Heib <kamalheib1@gmail.com>
    RDMA/ipoib: Return void from ipoib_ib_dev_stop()

Chen Tao <chentao107@huawei.com>
    drm/amdgpu/debugfs: fix memory leak when pm_runtime_get_sync failed

Qiushi Wu <wu000273@umn.edu>
    platform/chrome: cros_ec_ishtp: Fix a double-unlock issue

Kamal Dasu <kdasu.kdev@gmail.com>
    mtd: rawnand: brcmnand: ECC error handling on EDU transfers

Boris Brezillon <boris.brezillon@collabora.com>
    mtd: rawnand: fsl_upm: Remove unused mtd var

Eric Dumazet <edumazet@google.com>
    octeontx2-af: change (struct qmem)->entry_sz from u8 to u16

Charles Keepax <ckeepax@opensource.cirrus.com>
    mfd: arizona: Ensure 32k clock is put on driver unbind and error

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_aead - Only wake up when ctx->more is zero

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Fix incorrect assumption about plane->index

Liu Ying <victor.liu@nxp.com>
    drm/imx: imx-ldb: Disable both channels for split mode in enc->disable()

Dan Williams <dan.j.williams@intel.com>
    libnvdimm: Validate command family indices

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Validate modem blob firmware size before load

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Validate MBA firmware size before load

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom: q6v5: Update running state before requesting stop

Bob Peterson <rpeterso@redhat.com>
    gfs2: Never call gfs2_block_zero_range with an open transaction

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix refcount leak in gfs2_glock_poke

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix duplicate branch after CBR

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix FUP packet state

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix memory leakage when the probe point is not found

Masami Hiramatsu <mhiramat@kernel.org>
    perf probe: Fix wrong variable warning when the probe point is not found

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: Fix to find the initargs correctly

Kees Cook <keescook@chromium.org>
    module: Correctly truncate sysfs sections output

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    dm: don't call report zones for more than the user requested

John Dorminy <jdorminy@redhat.com>
    dm ebs: Fix incorrect checking for REQ_OP_FLUSH

Anton Blanchard <anton@ozlabs.org>
    pseries: Fix 64 bit logical memory block panic

Jeff Layton <jlayton@kernel.org>
    ceph: handle zero-length feature mask in session messages

Jeff Layton <jlayton@kernel.org>
    ceph: set sec_context xattr on symlink creation

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: clear watchdog timeout occurred flag

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: remove use of wrong watchdog_info option

Ahmad Fatoum <a.fatoum@pengutronix.de>
    watchdog: f71808e_wdt: indicate WDIOF_CARDRESET support in watchdog_info.options

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Use trace_sched_process_free() instead of exit() for pid tracing

Kevin Hao <haokexin@gmail.com>
    tracing/hwlat: Honor the tracing_cpumask

Muchun Song <songmuchun@bytedance.com>
    kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler

Chengming Zhou <zhouchengming@bytedance.com>
    ftrace: Setup correct FTRACE_FL_REGS flags for module

Jia He <justin.he@arm.com>
    mm/memory_hotplug: fix unpaired mem_hotplug_begin/done

Mike Kravetz <mike.kravetz@oracle.com>
    cma: don't quit at first error when activating reserved areas

Michal Koutný <mkoutny@suse.com>
    mm/page_counter.c: fix protection usage propagation

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: change slot number type s16 to u16

Peter Zijlstra <peterz@infradead.org>
    mm: fix kthread_use_mm() vs TLB invalidate

David Hildenbrand <david@redhat.com>
    mm/shuffle: don't move pages between zones and don't read garbage memmaps

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlbfs: remove call to huge_pte_alloc without i_mmap_rwsem

Hugh Dickins <hughd@google.com>
    khugepaged: retract_page_tables() remember to test exit

Hugh Dickins <hughd@google.com>
    khugepaged: collapse_pte_mapped_thp() protect the pmd lock

Peter Xu <peterx@redhat.com>
    mm/hugetlb: fix calculation of adjust_range_if_pmd_sharing_possible

Hugh Dickins <hughd@google.com>
    khugepaged: collapse_pte_mapped_thp() flush the right range

Mikulas Patocka <mpatocka@redhat.com>
    ext2: fix missing percpu_counter_inc

Mike Rapoport <rppt@kernel.org>
    MIPS: SGI-IP27: always enable NUMA in Kconfig

Paul Cercueil <paul@crapouillou.net>
    MIPS: qi_lb60: Fix routing to audio amplifier

Huacai Chen <chenhc@lemote.com>
    MIPS: CPU#0 is not hotpluggable

Lukas Wunner <lukas@wunner.de>
    driver core: Avoid binding drivers to dead devices

Vincent Duvert <vincent.ldev@duvert.net>
    appletalk: Fix atalk_proc_init() return path

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix misplaced while instead of if

Coly Li <colyli@suse.de>
    bcache: use disk_{start,end}_io_acct() to count I/O for bcache device

Coly Li <colyli@suse.de>
    bcache: fix bio_{start,end}_io_acct with proper device

Coly Li <colyli@suse.de>
    bcache: avoid nr_stripes overflow in bcache_device_init()

Coly Li <colyli@suse.de>
    bcache: fix overflow in offset_to_stripe()

Coly Li <colyli@suse.de>
    bcache: allocate meta data pages as compound pages

ChangSyun Peng <allenpeng@synology.com>
    md/raid5: Fix Force reconstruct-write io stuck in degraded raid5

Kees Cook <keescook@chromium.org>
    selftests/seccomp: Set NNP for TSYNC ESRCH flag test

Kees Cook <keescook@chromium.org>
    net/compat: Add missing sock updates for SCM_RIGHTS

Kees Cook <keescook@chromium.org>
    pidfd: Add missing sock updates for pidfd_getfd()

Zenghui Yu <yuzenghui@huawei.com>
    irqchip/gic-v4.1: Ensure accessing the correct RD when writing INVALLR

Huacai Chen <chenhc@lemote.com>
    irqchip/loongson-liointc: Fix misuse of gc->mask_cache

Jonathan McDowell <noodles@earth.li>
    net: stmmac: dwmac1000: provide multicast filter fallback

Jonathan McDowell <noodles@earth.li>
    net: ethernet: stmmac: Disable hardware multicast filter

Eugeniu Rosca <erosca@de.adit-jv.com>
    media: vsp1: dl: Fix NULL pointer dereference on unbind

Mansur Alisha Shaik <mansur@codeaurora.org>
    media: venus: fix multiple encoder crash

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Properly detect GPIO direction when configured for IRQ

Paul Cercueil <paul@crapouillou.net>
    pinctrl: ingenic: Enhance support for IRQ_TYPE_EDGE_BOTH

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Fix circular dependency between percpu.h and mmu.h

Michael Ellerman <mpe@ellerman.id.au>
    powerpc: Allow 4224 bytes of stack expansion for the signal frame

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/ptdump: Fix build failure in hashpagetable.c

Paul Aurich <paul@darkrain42.org>
    cifs: Fix leak when handling lease break for cached root fid

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix xtensa_pmu_setup prototype

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: add missing exclusive access state management

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: reset hw ts after resume

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: dac: ad5592r: fix unbalanced mutex unlocks in ad5592r_read_raw()

Christian Eggers <ceggers@arri.de>
    dt-bindings: iio: io-channel-mux: Fix compatible string in example code

Shaokun Zhang <zhangshaokun@hisilicon.com>
    arm64: perf: Correct the event index in sysfs

Sibi Sankar <sibis@codeaurora.org>
    arm64: dts: qcom: sc7180: Drop the unused non-MSA SID

Boleyn Su <boleynsu@google.com>
    btrfs: check correct variable after allocation in btrfs_backref_iter_alloc

Pavel Machek <pavel@denx.de>
    btrfs: fix return value mixup in btrfs_get_extent

Josef Bacik <josef@toxicpanda.com>
    btrfs: make sure SB_I_VERSION doesn't get unset by remount

Qu Wenruo <wqu@suse.com>
    btrfs: trim: fix underflow in trim length to prevent access beyond device boundary

Filipe Manana <fdmanana@suse.com>
    btrfs: fix memory leaks after failure to lookup checksums during inode logging

Qu Wenruo <wqu@suse.com>
    btrfs: inode: fix NULL pointer dereference if inode doesn't need compression

Josef Bacik <josef@toxicpanda.com>
    btrfs: only search for left_info if there is no right_info in try_merge_free_space

David Sterba <dsterba@suse.com>
    btrfs: fix messages after changing compression level by remount

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't show full path of bind mounts in subvol=

Filipe Manana <fdmanana@suse.com>
    btrfs: fix race between page release and a fast fsync

Josef Bacik <josef@toxicpanda.com>
    btrfs: don't WARN if we abort a transaction with EROFS

Josef Bacik <josef@toxicpanda.com>
    btrfs: sysfs: use NOFS for device creation

Josef Bacik <josef@toxicpanda.com>
    btrfs: return EROFS for BTRFS_FS_STATE_ERROR cases

Qu Wenruo <wqu@suse.com>
    btrfs: avoid possible signal interruption of btrfs_drop_snapshot() on relocation tree

David Sterba <dsterba@suse.com>
    btrfs: add missing check for nocow and compression inode flags

Qu Wenruo <wqu@suse.com>
    btrfs: relocation: review the call sites which can be interrupted by signal

Josef Bacik <josef@toxicpanda.com>
    btrfs: move the chunk_mutex in btrfs_read_chunk_tree

Josef Bacik <josef@toxicpanda.com>
    btrfs: open device without device_list_mutex

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl

Anand Jain <anand.jain@oracle.com>
    btrfs: don't traverse into the seed devices in show_devname

Filipe Manana <fdmanana@suse.com>
    btrfs: remove no longer needed use of log_writers for the log root tree

Filipe Manana <fdmanana@suse.com>
    btrfs: only commit delayed items at fsync if we are logging a directory

Filipe Manana <fdmanana@suse.com>
    btrfs: stop incremening log_batch for the log root tree when syncing log

Filipe Manana <fdmanana@suse.com>
    btrfs: only commit the delayed inode when doing a full fsync

Tom Rix <trix@redhat.com>
    btrfs: ref-verify: fix memory leak in add_block_entry

Qu Wenruo <wqu@suse.com>
    btrfs: preallocate anon block device at first phase of snapshot creation

Qu Wenruo <wqu@suse.com>
    btrfs: don't allocate anonymous block device for user invisible roots

Qu Wenruo <wqu@suse.com>
    btrfs: free anon block device right after subvolume deletion

David Sterba <dsterba@suse.com>
    btrfs: allow use of global block reserve for balance item deletion

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Add support for tx term offset for rev 2.1.0

Ansuel Smith <ansuelsmth@gmail.com>
    PCI: qcom: Define some PARF params needed for ipq8064 SoC

Rajat Jain <rajatja@google.com>
    PCI: Add device even if driver attach failed

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken

Ashok Raj <ashok.raj@intel.com>
    PCI/ATS: Add pci_pri_supported() to check device or associated PF

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI: hotplug: ACPI: Fix context refcounting in acpiphp_grab_context()

Guenter Roeck <linux@roeck-us.net>
    genirq/PM: Always unlock IRQ descriptor in rearm_wake_irq()

Guenter Roeck <linux@roeck-us.net>
    genirq: Unlock irq descriptor after errors

Thomas Gleixner <tglx@linutronix.de>
    genirq/affinity: Make affinity setting if activated opt-in

Steve French <stfrench@microsoft.com>
    SMB3: Fix mkdir when idsfromsid configured on mount

Steve French <stfrench@microsoft.com>
    smb3: warn on confusing error scenario with sec=krb5

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek - Fix unused variable warning


-------------

Diffstat:

 Documentation/admin-guide/hw-vuln/multihit.rst     |   4 +
 .../bindings/iio/multiplexer/io-channel-mux.txt    |   2 +-
 Makefile                                           |   4 +-
 arch/arm64/boot/dts/qcom/sc7180-idp.dts            |   2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |   2 +-
 arch/arm64/kernel/perf_event.c                     |  13 +-
 arch/mips/Kconfig                                  |   1 +
 arch/mips/boot/dts/ingenic/qi_lb60.dts             |   2 +-
 arch/mips/kernel/topology.c                        |   2 +-
 arch/openrisc/kernel/stacktrace.c                  |  18 ++-
 arch/powerpc/include/asm/percpu.h                  |   4 +-
 arch/powerpc/mm/fault.c                            |   7 +-
 arch/powerpc/mm/ptdump/hashpagetable.c             |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/s390/Kconfig                                  |   1 +
 arch/s390/lib/test_unwind.c                        |   1 +
 arch/sh/boards/mach-landisk/setup.c                |   3 +
 arch/sh/mm/fault.c                                 |   1 -
 arch/x86/events/rapl.c                             |   2 +-
 arch/x86/kernel/apic/vector.c                      |   4 +
 arch/x86/kernel/cpu/bugs.c                         |   8 +-
 arch/x86/kernel/tsc_msr.c                          |   9 +-
 arch/xtensa/include/asm/thread_info.h              |   4 +
 arch/xtensa/kernel/asm-offsets.c                   |   3 +
 arch/xtensa/kernel/entry.S                         |  11 ++
 arch/xtensa/kernel/perf_event.c                    |   2 +-
 crypto/af_alg.c                                    |  11 +-
 crypto/algif_aead.c                                |  10 +-
 crypto/algif_skcipher.c                            |  11 +-
 drivers/acpi/nfit/core.c                           |  11 +-
 drivers/acpi/nfit/nfit.h                           |   1 -
 drivers/base/dd.c                                  |   4 +-
 drivers/clk/Kconfig                                |   2 +-
 drivers/clk/actions/owl-s500.c                     |   2 +-
 drivers/clk/bcm/clk-bcm2835.c                      |  25 +++-
 drivers/clk/qcom/clk-alpha-pll.c                   |   2 -
 drivers/clk/qcom/gcc-sdm660.c                      |   3 +
 drivers/clk/qcom/gcc-sm8150.c                      |   8 +-
 drivers/clk/sirf/clk-atlas6.c                      |   2 +-
 drivers/crypto/caam/caamalg.c                      |  29 -----
 drivers/crypto/caam/compat.h                       |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c        |  11 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  23 ++++
 .../drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr.c |  69 +++++++++-
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |   5 +-
 drivers/gpu/drm/drm_dp_mst_topology.c              |  41 +++---
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/i915/gt/intel_gt.c                 |   5 +
 drivers/gpu/drm/imx/imx-ldb.c                      |   7 +-
 drivers/gpu/drm/ingenic/ingenic-drm.c              |   2 +-
 drivers/gpu/drm/omapdrm/dss/dispc.c                |   1 +
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |   1 +
 drivers/gpu/drm/omapdrm/dss/dss.c                  |   1 +
 drivers/gpu/drm/omapdrm/dss/venc.c                 |   1 +
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   2 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |   2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |   2 +-
 drivers/gpu/drm/tidss/tidss_kms.c                  |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   8 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c                |   5 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c             | 145 +++++++++++++--------
 drivers/i2c/busses/i2c-bcm-iproc.c                 |  13 +-
 drivers/i2c/busses/i2c-rcar.c                      |  15 ++-
 drivers/iio/dac/ad5592r-base.c                     |   4 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h            |   3 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c     |  23 ++--
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c       |   2 +-
 drivers/infiniband/core/counters.c                 |   4 +-
 drivers/infiniband/core/uverbs_cmd.c               |   4 +
 drivers/infiniband/hw/cxgb4/mem.c                  |   1 -
 drivers/infiniband/hw/mlx4/mr.c                    |   1 -
 drivers/infiniband/ulp/ipoib/ipoib.h               |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |  67 +++++-----
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   2 +
 drivers/input/mouse/sentelic.c                     |   2 +-
 drivers/iommu/intel/dmar.c                         |  21 ++-
 drivers/iommu/intel/iommu.c                        |   7 +-
 drivers/iommu/intel/svm.c                          |  22 ++--
 drivers/iommu/omap-iommu-debug.c                   |   3 +
 drivers/irqchip/irq-gic-v3-its.c                   |  15 ++-
 drivers/irqchip/irq-loongson-liointc.c             |  10 +-
 drivers/md/bcache/bcache.h                         |   2 +-
 drivers/md/bcache/bset.c                           |   2 +-
 drivers/md/bcache/btree.c                          |   2 +-
 drivers/md/bcache/journal.c                        |   4 +-
 drivers/md/bcache/request.c                        |  14 +-
 drivers/md/bcache/super.c                          |  14 +-
 drivers/md/bcache/writeback.c                      |  14 +-
 drivers/md/bcache/writeback.h                      |  19 ++-
 drivers/md/dm-ebs-target.c                         |   2 +-
 drivers/md/dm-rq.c                                 |   3 -
 drivers/md/dm.c                                    |   3 +-
 drivers/md/md-cluster.c                            |   1 +
 drivers/md/raid5.c                                 |   3 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |   4 +
 drivers/media/platform/rockchip/rga/rga-hw.c       |  29 +++--
 drivers/media/platform/rockchip/rga/rga-hw.h       |   5 +
 drivers/media/platform/vsp1/vsp1_dl.c              |   2 +
 drivers/mfd/arizona-core.c                         |  18 +++
 drivers/mfd/dln2.c                                 |   4 +
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |  18 ++-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |  26 ++++
 drivers/mtd/nand/raw/fsl_upm.c                     |   1 -
 drivers/mtd/ubi/fastmap-wl.c                       |   5 +
 drivers/mtd/ubi/wl.c                               |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |  17 ++-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |   3 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   9 ++
 drivers/nvdimm/bus.c                               |  16 +++
 drivers/nvdimm/security.c                          |  13 +-
 drivers/nvme/host/core.c                           |  15 +++
 drivers/nvme/host/fabrics.c                        |   2 +-
 drivers/nvme/host/fabrics.h                        |   3 +-
 drivers/nvme/host/fc.c                             |   1 +
 drivers/nvme/host/multipath.c                      |  18 ++-
 drivers/nvme/host/nvme.h                           |   1 +
 drivers/nvme/host/rdma.c                           |  10 +-
 drivers/nvme/host/tcp.c                            |  15 ++-
 drivers/pci/ats.c                                  |  15 +++
 drivers/pci/bus.c                                  |   6 +-
 drivers/pci/controller/dwc/pcie-qcom.c             |  41 +++++-
 drivers/pci/controller/pci-hyperv.c                |  71 +++++-----
 drivers/pci/hotplug/acpiphp_glue.c                 |  14 +-
 drivers/pci/quirks.c                               |   5 +-
 drivers/pinctrl/pinctrl-ingenic.c                  |   9 +-
 drivers/platform/chrome/cros_ec_ishtp.c            |   4 +-
 drivers/pwm/pwm-bcm-iproc.c                        |   9 +-
 drivers/remoteproc/qcom_q6v5.c                     |   2 +
 drivers/remoteproc/qcom_q6v5_mss.c                 |  11 +-
 drivers/rtc/rtc-cpcap.c                            |   2 +-
 drivers/rtc/rtc-pl031.c                            |   1 +
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   2 +-
 drivers/staging/media/rkisp1/rkisp1-common.h       |   3 +
 drivers/staging/media/rkisp1/rkisp1-isp.c          |  46 +++----
 drivers/staging/media/rkisp1/rkisp1-resizer.c      |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  57 ++++----
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |   3 +-
 drivers/watchdog/f71808e_wdt.c                     |  13 +-
 drivers/watchdog/rti_wdt.c                         |   2 +
 drivers/watchdog/watchdog_dev.c                    |  18 +--
 fs/btrfs/backref.c                                 |   2 +-
 fs/btrfs/ctree.h                                   |   4 +-
 fs/btrfs/disk-io.c                                 |  78 ++++++++++-
 fs/btrfs/disk-io.h                                 |   2 +
 fs/btrfs/extent-io-tree.h                          |   2 +
 fs/btrfs/extent-tree.c                             |  23 +++-
 fs/btrfs/extent_io.c                               |  18 ++-
 fs/btrfs/free-space-cache.c                        |   4 +-
 fs/btrfs/inode.c                                   |  20 ++-
 fs/btrfs/ioctl.c                                   |  67 ++++++++--
 fs/btrfs/ref-verify.c                              |   2 +
 fs/btrfs/relocation.c                              |  12 +-
 fs/btrfs/scrub.c                                   |   2 +-
 fs/btrfs/super.c                                   |  51 +++++---
 fs/btrfs/sysfs.c                                   |   3 +
 fs/btrfs/transaction.c                             |   7 +-
 fs/btrfs/transaction.h                             |   2 +
 fs/btrfs/tree-log.c                                |  43 ++----
 fs/btrfs/volumes.c                                 |  48 ++++++-
 fs/ceph/dir.c                                      |   4 +
 fs/ceph/mds_client.c                               |   6 +-
 fs/cifs/smb2inode.c                                |   1 +
 fs/cifs/smb2misc.c                                 |  73 ++++++++---
 fs/cifs/smb2pdu.c                                  |   2 +
 fs/ext2/ialloc.c                                   |   3 +-
 fs/f2fs/compress.c                                 |   2 +
 fs/f2fs/data.c                                     |   4 +
 fs/gfs2/bmap.c                                     |  69 +++++-----
 fs/gfs2/glock.c                                    |   4 +-
 fs/minix/inode.c                                   |  12 +-
 fs/minix/itree_v1.c                                |  12 +-
 fs/minix/itree_v2.c                                |  13 +-
 fs/minix/minix.h                                   |   1 -
 fs/nfs/file.c                                      |  17 ++-
 fs/nfs/flexfilelayout/flexfilelayout.c             |  50 +++++--
 fs/nfs/nfs4file.c                                  |   5 +-
 fs/nfs/nfs4proc.c                                  |   2 -
 fs/nfs/nfs4xdr.c                                   |   6 +-
 fs/nfs/pnfs.c                                      |   4 +-
 fs/nfs/pnfs.h                                      |   2 +-
 fs/ocfs2/ocfs2.h                                   |   4 +-
 fs/ocfs2/suballoc.c                                |   4 +-
 fs/ocfs2/super.c                                   |   4 +-
 fs/ubifs/journal.c                                 |  10 +-
 fs/ufs/super.c                                     |   2 +-
 include/crypto/if_alg.h                            |   4 +-
 include/linux/fs.h                                 |  10 ++
 include/linux/hugetlb.h                            |   8 +-
 include/linux/intel-iommu.h                        |   4 +-
 include/linux/irq.h                                |  13 ++
 include/linux/libnvdimm.h                          |   2 +
 include/linux/pci-ats.h                            |   4 +
 include/net/sock.h                                 |   4 +
 include/uapi/linux/btrfs.h                         |  14 +-
 include/uapi/linux/ndctl.h                         |   4 +
 init/main.c                                        |  14 +-
 kernel/irq/manage.c                                |  13 +-
 kernel/irq/pm.c                                    |   8 +-
 kernel/kprobes.c                                   |  24 +++-
 kernel/kthread.c                                   |   7 +-
 kernel/module.c                                    |  22 +++-
 kernel/pid.c                                       |   7 +-
 kernel/sched/core.c                                |  81 +++++++++++-
 kernel/sched/cpufreq_schedutil.c                   |   2 +-
 kernel/sched/sched.h                               |  47 ++++++-
 kernel/trace/ftrace.c                              |  15 ++-
 kernel/trace/trace_events.c                        |   4 +-
 kernel/trace/trace_hwlat.c                         |   5 +-
 lib/devres.c                                       |  11 +-
 lib/test_kmod.c                                    |   2 +-
 lib/test_lockup.c                                  |   4 +-
 mm/cma.c                                           |  23 ++--
 mm/hugetlb.c                                       |  39 +++---
 mm/khugepaged.c                                    |  70 +++++-----
 mm/memory_hotplug.c                                |   5 +-
 mm/page_counter.c                                  |   6 +-
 mm/rmap.c                                          |   2 +-
 mm/shuffle.c                                       |  18 +--
 net/appletalk/atalk_proc.c                         |   2 +
 net/compat.c                                       |   1 +
 net/core/sock.c                                    |  21 +++
 net/mac80211/sta_info.c                            |   2 +-
 scripts/recordmcount.c                             |   2 +
 security/integrity/ima/ima_policy.c                |  15 ++-
 sound/pci/echoaudio/echoaudio.c                    |   2 -
 sound/pci/hda/patch_realtek.c                      |   2 -
 tools/build/Makefile.feature                       |   2 +-
 tools/build/feature/Makefile                       |   2 -
 tools/perf/bench/mem-functions.c                   |  21 +--
 tools/perf/builtin-record.c                        |   4 +-
 tools/perf/tests/parse-events.c                    |  37 +++++-
 tools/perf/util/evsel.c                            |   6 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |  29 ++---
 tools/perf/util/parse-events.c                     |  28 ++++
 tools/perf/util/parse-events.h                     |   2 +
 tools/perf/util/parse-events.l                     |  19 +--
 tools/perf/util/probe-finder.c                     |   5 +-
 tools/testing/selftests/bpf/Makefile               |  49 +++----
 tools/testing/selftests/bpf/test_progs.c           |  33 ++++-
 tools/testing/selftests/bpf/test_progs.h           |   2 +
 .../testing/selftests/powerpc/ptrace/ptrace-pkey.c |  55 ++++----
 tools/testing/selftests/seccomp/seccomp_bpf.c      |   5 +
 244 files changed, 2095 insertions(+), 909 deletions(-)


