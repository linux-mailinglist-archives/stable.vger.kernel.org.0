Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 197A7206C34
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 08:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389059AbgFXGKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 02:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387817AbgFXGKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 02:10:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CECC82073E;
        Wed, 24 Jun 2020 06:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592979035;
        bh=3Q+iC/mWF6bLJNIrc46mtJk8DZu9FpAt6tiRxwoxDHU=;
        h=From:To:Cc:Subject:Date:From;
        b=ma3yC+/9T5ev75trX4jVbMuBuwnfFlodoVqnyRVsxZjKNAPrRaPxMDDwpDO+MzDUp
         CXIv5gsiupWyJh3wonpbtZFWCVqG7BtUAbaRERmQd72HYkqz1BLAaAC6qWXszs++eR
         HmkO1wzm7WyO3UirFxbr7O5M8vf3iPTAP1yUVP38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.7 000/474] 5.7.6-rc2 review
Date:   Wed, 24 Jun 2020 08:10:33 +0200
Message-Id: <20200624055938.609070954@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.7.6-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.6-rc2
X-KernelTest-Deadline: 2020-06-26T06:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.7.6 release.
There are 474 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 26 Jun 2020 05:58:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.7.6-rc2

Jon Derrick <jonathan.derrick@intel.com>
    iommu/vt-d: Remove real DMA lookup in find_domain

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: core: device_rename: Use rwsem instead of a seqcount

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    net: octeon: mgmt: Repair filling of RX ring

Chen Yu <yu.c.chen@intel.com>
    e1000e: Do not wake up the system via WOL if device wakeup is disabled

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix KVM interrupt using wrong save area

Jiri Olsa <jolsa@redhat.com>
    kretprobe: Prevent triggering kretprobe from within kprobe_flush_task

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to protect kick_kprobe_optimizer() by kprobe_mutex

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_pipapo: Disable preemption before getting per-CPU pointer

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_rbtree: Don't account for expired elements on insertion

Kefeng Wang <wangkefeng.wang@huawei.com>
    sample-trace-array: Fix sleeping function called from invalid context

Kefeng Wang <wangkefeng.wang@huawei.com>
    sample-trace-array: Remove trace_array 'sample-instance'

Masami Hiramatsu <mhiramat@kernel.org>
    tools/bootconfig: Fix to return 0 if succeeded to show the bootconfig

Masami Hiramatsu <mhiramat@kernel.org>
    tools/bootconfig: Fix to use correct quotes for value

Masami Hiramatsu <mhiramat@kernel.org>
    proc/bootconfig: Fix to use correct quotes for value

Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
    tracing/probe: Fix memleak in fetch_op_data operations

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Make ftrace packed events have align of 1

Eric Biggers <ebiggers@google.com>
    crypto: algboss - don't wait during notifier callback

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: algif_skcipher - Cap recv SG list at ctx->used

Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
    drm/i915/tgl: Make Wa_14010229206 permanent

Harry Wentland <harry.wentland@amd.com>
    Revert "drm/amd/display: disable dcn20 abm feature for bring up"

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Move gen4 GT workarounds from init_clock_gating to workarounds

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Move vlv GT workarounds from init_clock_gating to workarounds

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Move ilk GT workarounds from init_clock_gating to workarounds

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Move snb GT workarounds from init_clock_gating to workarounds

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Move ivb GT workarounds from init_clock_gating to workarounds

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Move hsw GT workarounds from init_clock_gating to workarounds

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Incrementally check for rewinding

Khaled Almahallawy <khaled.almahallawy@intel.com>
    drm/i915/tc: fix the reset of ln0

Imre Deak <imre.deak@intel.com>
    drm/i915/icl+: Fix hotplug interrupt disabling after storm detection

Denis Efremov <efremov@linux.com>
    drm/amd/display: Use kvfree() to free coeff in build_regamma()

Lorenz Brun <lorenz@brun.one>
    drm/amdkfd: Use correct major in devcgroup check

Jeykumar Sankaran <jsanka@codeaurora.org>
    drm/connector: notify userspace on hotplug after register complete

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Whitelist context-local timestamp in the gen9 cmdparser

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Avoid iterating an empty list

Jordan Crouse <jcrouse@codeaurora.org>
    drm/msm: Check for powered down HW in the devfreq callbacks

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix AUX power domain toggling across TypeC mode resets

Dmitry V. Levin <ldv@altlinux.org>
    s390: fix syscall_get_error for compat processes

Eric Biggers <ebiggers@google.com>
    f2fs: avoid utf8_strncasecmp() with unstable name

Eric Biggers <ebiggers@google.com>
    f2fs: split f2fs_d_compare() from f2fs_match_name()

Denis Efremov <efremov@linux.com>
    net/mlx5: DR, Fix freeing in dr_create_rc_qp()

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Increase ACT retry timeout to 3s

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid race conditions when remounting with options that change dax

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: fix possible race condition against REQ_F_NEED_CLEANUP

Jens Axboe <axboe@kernel.dk>
    io_uring: reap poll completions while waiting for refs to drop on exit

Jens Axboe <axboe@kernel.dk>
    io_uring: acquire 'mm' for task_work for SQPOLL

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: add memory barrier to synchronize io_kiocb's result and iopoll_completed

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: don't fail links for EAGAIN error in IOPOLL mode

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    io_uring: fix io_kiocb.flags modification race in IOPOLL mode

Thomas Zimmermann <tzimmermann@suse.de>
    drm/ast: Don't check new mode if CRTC is being disabled

Tom Rix <trix@redhat.com>
    selinux: fix undefined return of cond_evaluate_expr

Tom Rix <trix@redhat.com>
    selinux: fix a double free in cond_read_node()/cond_read_list()

Tom Rix <trix@redhat.com>
    selinux: fix double free

Sandeep Raghuraman <sandy.8925@gmail.com>
    drm/amdgpu: Replace invalid device ID with a valid device ID

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: use blanked rather than plane state for sync groups

Huacai Chen <chenhc@lemote.com>
    drm/qxl: Use correct notify port address when creating cursor ring

Lyude Paul <lyude@redhat.com>
    drm/dp_mst: Reformat drm_dp_check_act_status() a bit

Takashi Iwai <tiwai@suse.de>
    drm/nouveau/kms: Fix regression by audio component transition

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    sh: Convert iounmap() macros to inline functions

Andreas Färber <afaerber@suse.de>
    arm64: dts: realtek: rtd129x: Carve out boot ROM from memory

Andreas Färber <afaerber@suse.de>
    arm64: dts: realtek: rtd129x: Use reserved-memory for RPC regions

zhangyi (F) <yi.zhang@huawei.com>
    ext4, jbd2: ensure panic by fix a race between jbd2 abort and ext4 error handlers

Eric Biggers <ebiggers@google.com>
    ext4: avoid utf8_strncasecmp() with unstable name

Jeffle Xu <jefflexu@linux.alibaba.com>
    ext4: fix partial cluster initialization when splitting extent

Sivaprakash Murugesan <sivaprak@codeaurora.org>
    pinctrl: qcom: ipq6018 Add missing pins in qpic pin group

Wolfram Sang <wsa+renesas@sang-engineering.com>
    drm: encoder_slave: fix refcouting error for modules

Kai-Heng Feng <kai.heng.feng@canonical.com>
    libata: Use per port sync for detach

Will Deacon <will@kernel.org>
    arm64: hw_breakpoint: Don't invoke overflow handler on uaccess watchpoints

Barry Song <song.bao.hua@hisilicon.com>
    arm64: mm: reserve hugetlb CMA after numa_init

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum: Adjust headroom buffers for 8x ports

Martin <martin.varghese@nokia.com>
    bareudp: Fixed configuration to avoid having garbage values

Sven Auhagen <sven.auhagen@voleatech.de>
    mvpp2: remove module bugfix

Jason Yan <yanaijie@huawei.com>
    block: Fix use-after-free in blkdev_get()

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/numa: let NODES_SHIFT depend on NEED_MULTIPLE_NODES

Dinghao Liu <dinghao.liu@zju.edu.cn>
    scsi: ufs-bsg: Fix runtime PM imbalance on error

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix PTP timestamping with large tc-taprio cycles

Vasundhara Volam <vasundhara-v.volam@broadcom.com>
    bnxt_en: Return from timer if interface is not in open state.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix AER reset logic on 57500 chips.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Re-enable SRIOV during resume.

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Simplify bnxt_resume().

David Howells <dhowells@redhat.com>
    afs: Fix the mapping of the UAEOVERFLOW abort code

David Howells <dhowells@redhat.com>
    afs: Remove the error argument from afs_protocol_error()

David Howells <dhowells@redhat.com>
    afs: Set error flag rather than return error from file status decode

David Howells <dhowells@redhat.com>
    afs: Always include dir in bulk status fetch from afs_do_lookup()

David Howells <dhowells@redhat.com>
    afs: Fix EOF corruption

David Howells <dhowells@redhat.com>
    afs: afs_write_end() should change i_size under the right lock

David Howells <dhowells@redhat.com>
    afs: Fix non-setting of mtime when writing into mmap

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc: Fix kernel crash in show_instructions() w/DEBUG_VIRTUAL

Dan Carpenter <dan.carpenter@oracle.com>
    crypto: marvell/octeontx - Fix a potential NULL dereference

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: hisilicon - Cap block size at 2^31

Zhiqiang Liu <liuzhiqiang26@huawei.com>
    bcache: fix potential deadlock problem in btree_gc_coalesce

yangerkun <yangerkun@huawei.com>
    ext4: stop overwrite the errcode in ext4_setup_super

Ian Rogers <irogers@google.com>
    perf parse-events: Fix an incompatible pointer

Sumanth Korikkar <sumanthk@linux.ibm.com>
    perf probe: Fix user attribute access in kprobes

Hongbo Yao <yaohongbo@huawei.com>
    perf stat: Fix NULL pointer dereference

Gaurav Singh <gaurav1086@gmail.com>
    perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()

Qais Yousef <qais.yousef@arm.com>
    usb/ehci-platform: Set PM runtime as active on resume

Qais Yousef <qais.yousef@arm.com>
    usb/xhci-plat: Set PM runtime as active on resume

Andrii Nakryiko <andriin@fb.com>
    bpf: Undo internal BPF_PROBE_MEM in BPF insns dump

Andrii Nakryiko <andriin@fb.com>
    libbpf: Support pre-initializing .bss global variables

Andrey Ignatov <rdna@fb.com>
    bpf: Fix memlock accounting for sock_hash

Lorenz Bauer <lmb@cloudflare.com>
    bpf: sockmap: Don't attach programs to UDP sockets

Alex Elder <elder@linaro.org>
    net: ipa: program upper nibbles of sequencer type

Brett Creeley <brett.creeley@intel.com>
    iavf: fix speed reporting over virtchnl

Li RongQing <lirongqing@baidu.com>
    xdp: Fix xsk_generic_xmit errno

Chuck Lever <chuck.lever@oracle.com>
    NFS: Fix direct WRITE throughput regression

Zheng Bin <zhengbin13@huawei.com>
    nfs: set invalid blocks after NFSv4 writes

Christoph Hellwig <hch@lst.de>
    nvme-pci: use simple suspend when a HMB is enabled

Daniel Wagner <dwagner@suse.de>
    nvme-fc: don't call nvme_cleanup_cmd() for AENs

Tobias Klauser <tklauser@distanz.ch>
    tools, bpftool: Fix memory leak in codegen error cases

YiFei Zhu <zhuyifei1999@gmail.com>
    net/filter: Permit reading NET in load_bytes_relative when MAC not set

Tony Luck <tony.luck@intel.com>
    x86/mce/dev-mcelog: Fix -Wstringop-truncation warning about strncpy()

Vitaly Kuznetsov <vkuznets@redhat.com>
    x86/idt: Keep spurious entries unset in system_vectors

Colin Ian King <colin.king@canonical.com>
    drm/ast: fix missing break in switch statement for format->cpp[0] case 4

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: acornscsi: Fix an error handling path in acornscsi_probe()

Andrii Nakryiko <andriin@fb.com>
    libbpf: Handle GCC noreturn-turned-volatile quirk

Jernej Skrabec <jernej.skrabec@siol.net>
    drm/sun4i: hdmi ddc clk: Fix size of m divider

Jean-Philippe Brucker <jean-philippe@linaro.org>
    tracing/probe: Fix bpf_task_fd_query() for kprobes and uprobes

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockhash: Synchronize delete from bucket list on map free

dihu <anny.hu@linux.alibaba.com>
    bpf/sockmap: Fix kernel panic at __tcp_bpf_recvmsg

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5645: Add platform-data for Asus T101HA

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT10-A tablet

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: nocodec: conditionally set dpcm_capture/dpcm_playback flags

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: core: only convert non DPCM link to DPCM link

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: soc-pcm: dpcm: fix playback/capture checks

Zhihao Cheng <chengzhihao1@huawei.com>
    afs: Fix memory leak in afs_put_sysnames()

Eric Biggers <ebiggers@google.com>
    f2fs: don't return vmalloc() memory from f2fs_kmalloc()

tannerlove <tannerlove@google.com>
    selftests/net: in timestamping, strncpy needs to preserve null byte

Shaokun Zhang <zhangshaokun@hisilicon.com>
    drivers/perf: hisi: Fix wrong value for all counters enable

Joe Perches <joe@perches.com>
    arm64: ftrace: Change CONFIG_FTRACE_WITH_REGS to CONFIG_DYNAMIC_FTRACE_WITH_REGS

Dong Aisheng <aisheng.dong@nxp.com>
    mailbox: imx: Add context save/restore for suspend/resume

Max Staudt <max@enpas.org>
    i2c: icy: Fix build with CONFIG_AMIGA_PCMCIA=n

Logan Gunthorpe <logang@deltatee.com>
    NTB: ntb_test: Fix bug when counting remote files

Logan Gunthorpe <logang@deltatee.com>
    NTB: perf: Fix race condition when run with ntb_test

Logan Gunthorpe <logang@deltatee.com>
    NTB: perf: Fix support for hardware that doesn't have port numbers

Logan Gunthorpe <logang@deltatee.com>
    NTB: perf: Don't require one more memory window than number of peers

Logan Gunthorpe <logang@deltatee.com>
    NTB: Revert the change to use the NTB device dev for DMA allocations

Logan Gunthorpe <logang@deltatee.com>
    NTB: ntb_tool: reading the link file should not end in a NULL byte

Sanjay R Mehta <sanju.mehta@amd.com>
    ntb_tool: pass correct struct device to dma_alloc_coherent

Sanjay R Mehta <sanju.mehta@amd.com>
    ntb_perf: pass correct struct device to dma_alloc_coherent

Dan Murphy <dmurphy@ti.com>
    net: mscc: Fix OF_MDIO config check

Dan Murphy <dmurphy@ti.com>
    net: marvell: Fix OF_MDIO config check

Dan Murphy <dmurphy@ti.com>
    net: dp83867: Fix OF_MDIO config check

Bob Peterson <rpeterso@redhat.com>
    gfs2: fix use-after-free on transaction ail lists

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: selftests: Fix build with "make ARCH=x86_64"

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    blktrace: fix endianness for blk_log_remap()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    blktrace: fix endianness in get_pdu_int()

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    blktrace: use errno instead of bi_status

Ram Pai <linuxram@us.ibm.com>
    selftests/vm/pkeys: fix alloc_random_pkey() to make it really random

Arnd Bergmann <arnd@arndb.de>
    include/linux/bitops.h: avoid clang shift-count-overflow warnings

Jann Horn <jannh@google.com>
    lib/zlib: remove outdated and incorrect pre-increment optimization

Jiri Benc <jbenc@redhat.com>
    geneve: change from tx_error to tx_dropped on missing metadata

Dan Carpenter <dan.carpenter@oracle.com>
    bpf: Fix an error code in check_btf_func()

Kees Cook <keescook@chromium.org>
    pwm: Add missing "CONFIG_" prefix

Tero Kristo <t-kristo@ti.com>
    crypto: omap-sham - add proper load balancing support for multicore

Jens Axboe <axboe@kernel.dk>
    ext4: don't block for O_DIRECT if IOCB_NOWAIT is set

Harshad Shirwadkar <harshadshirwadkar@gmail.com>
    ext4: handle ext4_mark_inode_dirty errors

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Revalidate bandwidth before commiting DC updates

Ka-Cheong Poon <ka-cheong.poon@oracle.com>
    RDMA/cm: Spurious WARNING triggered in cm_destroy_id()

J. Bruce Fields <bfields@redhat.com>
    nfsd: safer handling of corrupted c_type

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pinctrl: freescale: imx: Fix an error handling path in 'imx_pinctrl_probe()'

yu kuai <yukuai3@huawei.com>
    pinctrl: sirf: add missing put_device() call in sirfsoc_gpio_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    pinctrl: imxl: Fix an error handling path in 'imx1_pinctrl_core_probe()'

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix -i (--ignore-errors) MAKEFLAGS detection

Can Guo <cang@codeaurora.org>
    scsi: ufs: Don't update urgent bkops level when toggling auto bkops

Qiushi Wu <wu000273@umn.edu>
    scsi: iscsi: Fix reference count leak in iscsi_boot_create_kobj

Bob Peterson <rpeterso@redhat.com>
    gfs2: Allow lock_nolock mount to specify jid=X

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: imx27: Fix rounding behavior

J. Bruce Fields <bfields@redhat.com>
    nfsd4: make drc_slab global, not per-net

Luis Henriques <lhenriques@suse.com>
    ceph: don't return -ESTALE if there's still an open file

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/disp/gm200-: fix NV_PDISP_SOR_HDMI2_CTRL(n) selection

Stafford Horne <shorne@gmail.com>
    openrisc: Fix issue with argument clobbering for clone/fork

David Howells <dhowells@redhat.com>
    rxrpc: Adjust /proc/net/rxrpc/calls to display call->debug_id not user_ID

Wei Yongjun <weiyongjun1@huawei.com>
    mailbox: zynqmp-ipi: Fix NULL vs IS_ERR() check in zynqmp_ipi_mbox_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    mailbox: imx: Fix return in imx_mu_scu_xlate()

Chuhong Yuan <hslester96@gmail.com>
    rtc: rv3028: Add missed check for devm_regmap_init_i2c()

Qiushi Wu <wu000273@umn.edu>
    vfio/mdev: Fix reference count leak in add_mdev_supported_type

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: hda: fix generic hda codec support

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ASoC: fsl_asrc_dma: Fix dma_chan leak when config DMA channel failed

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    usb: dwc3: meson-g12a: fix error path when fetching the reset line fails

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    extcon: adc-jack: Fix an error handling path in 'adc_jack_probe()'

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/kuap: Add missing isync to KUAP restore paths

huhai <huhai@tj.kylinos.cn>
    powerpc/4xx: Don't unmap NULL mbase

Nathan Chancellor <natechancellor@gmail.com>
    input: i8042 - Remove special PowerPC handling

Arnd Bergmann <arnd@arndb.de>
    ARM: davinci: fix build failure without I2C

Dan Carpenter <dan.carpenter@oracle.com>
    of: Fix a refcounting bug in __of_attach_node_sysfs()

Olga Kornievskaia <olga.kornievskaia@gmail.com>
    NFSv4.1 fix rpc_call_done assignment for BIND_CONN_TO_SESSION

Fedor Tokarev <ftokarev@gmail.com>
    net: sunrpc: Fix off-by-one issues in 'rpc_ntop6'

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: dapm: Move dai_link widgets to runtime to fix use after free

Dan Williams <dan.j.williams@intel.com>
    /dev/mem: Revoke mappings when a driver claims the region

John Hubbard <jhubbard@nvidia.com>
    misc: xilinx-sdfec: improve get_user_pages_fast() error handling

Eddie James <eajames@linux.ibm.com>
    clk: ast2600: Fix AHB clock divider for A1

Chunyan Zhang <chunyan.zhang@unisoc.com>
    clk: sprd: return correct type of value for _sprd_pll_recalc_rate

Laurent Dufour <ldufour@linux.ibm.com>
    KVM: PPC: Book3S HV: Relax check on H_SVM_INIT_ABORT

Qian Cai <cai@lca.pw>
    KVM: PPC: Book3S: Fix some RCU-list locks

Qian Cai <cai@lca.pw>
    KVM: PPC: Book3S HV: Ignore kmemleak false positives

Vignesh Raghavendra <vigneshr@ti.com>
    scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes

Gabriel Krisman Bertazi <krisman@collabora.com>
    scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim

Tejas Patel <tejas.patel@xilinx.com>
    clk: zynqmp: Fix divider2 calculation

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    scsi: ufs-qcom: Fix scheduling while atomic issue

Nathan Chancellor <natechancellor@gmail.com>
    clk: bcm2835: Fix return type of bcm2835_register_gate

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()

Qiushi Wu <wu000273@umn.edu>
    ASoC: fix incomplete error-handling in img_i2s_in_probe.

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Drop CONFIG_8xx_COPYBACK option

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/32s: Don't warn when mapping RO data ROX.

Wei Yongjun <weiyongjun1@huawei.com>
    mfd: wcd934x: Drop kfree for memory allocated with devm_kzalloc

Amelie Delaunay <amelie.delaunay@st.com>
    mfd: stmfx: Disable IRQ in suspend to avoid spurious interrupt

Amelie Delaunay <amelie.delaunay@st.com>
    mfd: stmfx: Fix stmfx_irq_init error path

Amelie Delaunay <amelie.delaunay@st.com>
    mfd: stmfx: Reset chip on resume as supply was disabled

Borislav Petkov <bp@suse.de>
    x86/apic: Make TSC deadline timer detection message visible

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove

Siddharth Gupta <sidgup@codeaurora.org>
    scripts: headers_install: Exit with error on config leak

Tiezhu Yang <yangtiezhu@loongson.cn>
    pinctrl: Fix return value about devm_platform_ioremap_resource()

Pawel Laszczak <pawell@cadence.com>
    usb: gadget: Fix issue with config_ep_by_speed function

Qiushi Wu <wu000273@umn.edu>
    usb: gadget: fix potential double-free in m66592_probe.

Colin Ian King <colin.king@canonical.com>
    usb: gadget: lpc32xx_udc: don't dereference ep pointer before null check

Nathan Chancellor <natechancellor@gmail.com>
    USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in s3c2410_udc_nuke

Fabrice Gasnier <fabrice.gasnier@st.com>
    usb: dwc2: gadget: move gadget resume after the core is in L0 state

Stefan Riedmueller <s.riedmueller@phytec.de>
    watchdog: da9062: No need to ping manually before setting timeout

Andrei Vagin <avagin@gmail.com>
    selftests/timens: handle a case when alarm clocks are not supported

Maor Gottlieb <maorg@mellanox.com>
    IB/cma: Fix ports memory leak in cma_configfs

Jonathan Bakker <xc-racer2@live.ca>
    iio: light: gp2ap002: Take runtime PM reference on light read

Marc Zyngier <maz@kernel.org>
    PCI: amlogic: meson: Don't use FAST_LINK_MODE to set up link

Marc Zyngier <maz@kernel.org>
    PCI: dwc: Fix inner MSI IRQ domain registration

Wei Yongjun <weiyongjun1@huawei.com>
    PCI: dwc: pci-dra7xx: Use devm_platform_ioremap_resource_byname()

Hemant Kumar <hemantk@codeaurora.org>
    bus: mhi: core: Read transfer length from an event properly

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PTM: Inherit Switch Downstream Port PTM settings from Upstream Port

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    xen/cpuhotplug: Fix initial CPU offlining for PV(H) guests

Gal Pressman <galpress@amazon.com>
    RDMA/efa: Fix setting of wrong bit in get/set_feature commands

Hannes Reinecke <hare@suse.de>
    dm zoned: return NULL if dmz_get_zone_for_reclaim() fails to find a zone

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/kasan: Fix error detection on memory allocation

Qian Cai <cai@lca.pw>
    powerpc/64s/pgtable: fix an undefined behaviour

Chen Zhou <chenzhou10@huawei.com>
    powerpc/powernv: add NULL check after kzalloc

Vidya Sagar <vidyas@nvidia.com>
    arm64: tegra: Fix flag for 64-bit resources in 'ranges' property

Jon Hunter <jonathanh@nvidia.com>
    arm64: tegra: Fix ethernet phy-mode for Jetson Xavier

Miklos Szeredi <mszeredi@redhat.com>
    fuse: copy_file_range should truncate cache

Miklos Szeredi <mszeredi@redhat.com>
    fuse: fix copy_file_range cache issues

Wei Yongjun <weiyongjun1@huawei.com>
    firmware: imx: scu: Fix possible memory leak in imx_scu_probe()

Ye Bin <yebin10@huawei.com>
    scsi: core: Fix incorrect usage of shost_for_each_device

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: tcmu: Userspace must not complete queued commands

Lang Cheng <chenglang@huawei.com>
    RDMA/hns: Fix cmdq parameter of querying pf timer resource

Lijun Ou <oulijun@huawei.com>
    RDMA/hns: Bugfix for querying qkey

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: exynos5433: Add IGNORE_UNUSED flag to sclk_i2s1

Souptick Joarder <jrdr.linux@gmail.com>
    fpga: dfl: afu: Corrected error handling levels

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: etm4x: Fix use-after-free of per-cpu etm drvdata

Suzuki K Poulose <suzuki.poulose@arm.com>
    coresight: Fix support for sparsely populated ports

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix bogus i++ in gsm_data_kick

Tang Bin <tangbin@cmss.chinamobile.com>
    USB: host: ehci-mxc: Add error handling in ehci_mxc_drv_probe()

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for Toshiba Encore WT8-A tablet

Roy Spliet <nouveau@spliet.org>
    drm/msm/mdp5: Fix mdp5_init error path for failed mdp5_kms allocation

Bjorn Andersson <bjorn.andersson@linaro.org>
    drm/msm: Fix undefined "rd_full" link error

Qais Yousef <qais.yousef@arm.com>
    usb/ohci-platform: Fix a warning when hibernating

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Mask cap zero

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/arm-smmu-v3: Don't reserve implementation defined register space

Geoff Levand <geoff@infradead.org>
    powerpc/ps3: Fix kexec shutdown hang

Sanket Parmar <sparmar@cadence.com>
    phy: cadence: sierra: Fix for USB3 U1/U2 state

Bharat Gooty <bharat.gooty@broadcom.com>
    drivers: phy: sr-usb: do not use internal fsm for USB2 phy init

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Issue PERST via GPIO

Marek Behún <marek.behun@nic.cz>
    PCI: aardvark: Improve link training

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Train link immediately after enabling training

Nicholas Piggin <npiggin@gmail.com>
    powerpc/pseries/ras: Fix FWNMI_VALID off by one

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/exceptions: Machine check reconcile irq state

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/exception: Fix machine check no-loss idle wakeup

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: codecs: rt*-sdw: fix memory leak in set_sdw_stream()

Feng Tang <feng.tang@intel.com>
    ipmi: use vzalloc instead of kmalloc for user creation

Lars Povlsen <lars.povlsen@microchip.com>
    pinctrl: ocelot: Always register GPIO driver

Marek Behún <marek.behun@nic.cz>
    arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Oded Gabbay <oded.gabbay@gmail.com>
    habanalabs: increase timeout during reset

Mika Westerberg <mika.westerberg@linux.intel.com>
    PCI/PM: Assume ports without DLL Link Active train links in 100 ms

Cristian Klein <cristian.klein@elastisys.com>
    HID: Add quirks for Trust Panora Graphic Tablet

Erwin Burema <e.burema@gmail.com>
    ALSA: usb-audio: Add duplex sound support for USB devices using implicit feedback

Thomas Ebeling <penguins@bollie.de>
    ALSA: usb-audio: fixing upper volume limit for RME Babyface Pro routing crosspoints

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix value of scan timeout

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix waking up upper tty layer when room available

Gregory CLEMENT <gregory.clement@bootlin.com>
    tty: n_gsm: Fix SOF skipping

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Don't initialise init_task->thread.regs

Rob Herring <robh@kernel.org>
    PCI: Fix pci_register_host_bridge() device_register() error handling

Tero Kristo <t-kristo@ti.com>
    clk: ti: composite: fix memory leak

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: c630: Add WiFi node

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: db820c: Fix invalid pm8994 supplies

Wei Yongjun <weiyongjun1@huawei.com>
    USB: ohci-sm501: fix error return code in ohci_hcd_sm501_drv_probe()

Wei Yongjun <weiyongjun1@huawei.com>
    phy: ti: j721e-wiz: Fix some error return code in wiz_probe()

Arnd Bergmann <arnd@arndb.de>
    dlm: remove BUG() before panic()

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: Drop accesses to MPSS PERPH register space

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    pinctrl: rockchip: fix memleak in rockchip_dt_node_to_map

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: ti: omap-mcbsp: Fix an error handling path in 'asoc_mcbsp_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ASoC: ux500: mop500: Fix some refcounted resources issues

Yongbo Zhang <giraffesnn123@gmail.com>
    SoC: rsnd: add interrupt support for SSI BUSIF buffer

Masahiro Yamada <masahiroy@kernel.org>
    unicore32: do not evaluate compiler's library path when cleaning

Masahiro Yamada <masahiroy@kernel.org>
    um: do not evaluate compiler's library path when cleaning

Chao Yu <chao@kernel.org>
    f2fs: compress: fix zstd data corruption

Chao Yu <chao@kernel.org>
    f2fs: fix potential use-after-free issue

YueHaibing <yuehaibing@huawei.com>
    f2fs: Fix wrong stub helper update_sit_info

Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
    scsi: mpt3sas: Fix double free warnings

Bodo Stroesser <bstroesser@ts.fujitsu.com>
    scsi: target: loopback: Fix READ with data and sensebytes

Loic Poulain <loic.poulain@linaro.org>
    arm64: dts: msm8996: Fix CSI IRQ types

Wei Yongjun <weiyongjun1@huawei.com>
    remoteproc/mediatek: fix invalid use of sizeof in scp_ipi_init()

Wei Yongjun <weiyongjun1@huawei.com>
    ASoC: SOF: core: fix error return code in sof_probe_continue()

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    PCI: brcmstb: Assert fundamental reset on initialization

Dmitry Osipenko <digetx@gmail.com>
    power: supply: smb347-charger: IRQSTAT_D is volatile

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    power: supply: lp8788: Fix an error handling path in 'lp8788_charger_probe()'

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: firewire-lib: fix invalid assignment to union data for directional parameter

Viacheslav Dubeyko <v.dubeiko@yadro.com>
    scsi: qla2xxx: Fix warning after FC target reset

Kai-Heng Feng <kai.heng.feng@canonical.com>
    PCI/ASPM: Allow ASPM on links to PCIe-to-PCI/PCI-X Bridges

Andrew Murray <amurray@thegoodpenguin.co.uk>
    PCI: rcar: Fix incorrect programming of OB windows

Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
    drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: pxa: fix i2c_pxa_scream_blue_murder() debug output

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    PCI: v3-semi: Fix a memory leak in v3_pci_probe() error handling paths

Arnd Bergmann <arnd@arndb.de>
    staging: wfx: avoid compiler warning on empty array

Matej Dujava <mdujava@kocurkovo.cz>
    staging: sm750fb: add missing case while setting FB_VISUAL

Oscar Carter <oscar.carter@gmx.com>
    staging: wilc1000: Increase the size of wid_list array

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Properly handle failed kick_transfer

Neil Armstrong <narmstrong@baylibre.com>
    usb: dwc3: meson-g12a: check return of dwc3_meson_g12a_usb_init

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Properly handle ClearFeature(halt)

Arnd Bergmann <arnd@arndb.de>
    HID: intel-ish-hid: avoid bogus uninitialized-variable warning

Andrew Jeffery <andrew@aj.id.au>
    ARM: dts: aspeed: Change KCS nodes to v2 binding

Eddie James <eajames@linux.ibm.com>
    ARM: dts: aspeed: ast2600: Set arch timer always-on

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    soundwire: slave: don't init debugfs on device registration error

Yong Zhi <yong.zhi@intel.com>
    ASoC: max98373: reorder max98373_reset() in resume

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: meson8b: Don't rely on u-boot to init all GP_PLL registers

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ASoC: SOF: Update correct LED status at the first time usage of update_mute_led()

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson: fix leds subnodes name

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-g12b-ugoos-am6: fix board compatible

Arnd Bergmann <arnd@arndb.de>
    ASoC: rt5682: fix I2C/Soundwire dependencies

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR

Arnd Bergmann <arnd@arndb.de>
    ASoC: component: suppress uninitialized-variable warning

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    gpio: pca953x: fix handling of automatic address incrementing

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: meson8b: Fix the vclk_div{1, 2, 4, 6, 12}_en gate bits

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: meson8b: Fix the polarity of the RESET_N lines

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    clk: meson: meson8b: Fix the first parent of vid_pll_in_sel

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    of: property: Do not link to disabled devices

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    of: property: Fix create device links for all child-supplier dependencies

Wei Yongjun <weiyongjun1@huawei.com>
    gpio: mlxbf2: fix return value check in mlxbf2_gpio_get_lock_res()

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    slimbus: ngd: get drvdata from correct device

Raghavendra Rao Ananta <rananta@codeaurora.org>
    tty: hvc: Fix data abort due to race in hvc_open

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix double init of tx_policy_upload_work

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix overflow in frame counters

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: put thinint indicator after early error

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: tear down thinint indicator after early error

Julian Wiedmann <jwi@linux.ibm.com>
    s390/qdio: consistently restore the IRQ handler

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix racy list management in output queue

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Improve frames size computation

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    staging: gasket: Fix mapping refcnt leak when register/store fails

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    staging: gasket: Fix mapping refcnt leak when put attribute fails

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: dts: qcom: sm8250: Fix PDC compatible and reg

Christoph Hellwig <hch@lst.de>
    firmware: qcom_scm: fix bogous abuse of dma-direct internals

Jonathan Marek <jonathan@marek.ca>
    arm64: dts: qcom: fix pm8150 gpio interrupts

Vasily Averin <vvs@virtuozzo.com>
    fuse: BUG_ON correction in fuse_dev_splice_write()

Vivek Goyal <vgoyal@redhat.com>
    virtiofs: schedule blocking async replies in separate worker

Jason Yan <yanaijie@huawei.com>
    pinctrl: rza1: Fix wrong array assignment of rza1l_swio_entries

Alexandru Ardelean <alexandru.ardelean@analog.com>
    iio: buffer-dmaengine: use %zu specifier for sprintf(align)

Chad Dupuis <cdupuis@marvell.com>
    scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: dwapb: Append MODULE_ALIAS for platform driver

Thomas Ebeling <penguins@bollie.de>
    ALSA: usb-audio: RME Babyface Pro mixer patch

Yishai Hadas <yishaih@mellanox.com>
    RDMA/mlx5: Fix udata response upon SRQ creation

Vincent Stehlé <vincent.stehle@laposte.net>
    ARM: dts: sun8i-h2-plus-bananapi-m2-zero: Fix led polarity

Amit Kucheria <amit.kucheria@linaro.org>
    arm64: dts: qcom: msm8916: remove unit name for thermal trip points

Nilesh Javali <njavali@marvell.com>
    scsi: qedi: Do not flush offload work if ARP not resolved

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8173: fix unit name warnings

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    staging: mt7621-pci: fix PCIe interrupt mapping

Chen Zhou <chenzhou10@huawei.com>
    staging: greybus: fix a missing-check bug in gb_lights_light_config()

Andreas Färber <afaerber@suse.de>
    arm64: dts: realtek: rtd129x: Fix GIC CPU masks for RTD1293

Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
    ARM: dts: bcm283x: Use firmware PM driver for V3D

Hans de Goede <hdegoede@redhat.com>
    x86/purgatory: Disable various profiling and sanitizing options

John Johansen <john.johansen@canonical.com>
    apparmor: fix nnp subset test for unconfined

Sabrina Dubroca <sd@queasysnail.net>
    bpf: tcp: Recv() should return 0 when the peer socket is closed

Thomas Falcon <tlfalcon@linux.ibm.com>
    ibmvnic: Flush existing work items before device removal

Jonas Karlman <jonas@kwiboo.se>
    media: v4l2-ctrls: Unset correct HEVC loop filter flag

Marek Szyprowski <m.szyprowski@samsung.com>
    media: s5p-mfc: Properly handle dma_parms for the allocated devices

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Don't send host info in adapter info MAD after LPM

Simon Arlott <simon@octiron.net>
    scsi: sr: Fix sr_probe() missing deallocate of device minor

Simon Arlott <simon@octiron.net>
    scsi: sr: Fix sr_probe() missing mutex_destroy

Jakub Sitnicki <jakub@cloudflare.com>
    bpf, sockhash: Fix memory leak when unlinking sockets in sock_hash_free

Pavel Machek (CIP) <pavel@denx.de>
    ASoC: meson: add missing free_irq() in error path

Chuhong Yuan <hslester96@gmail.com>
    xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()

Chao Yu <chao@kernel.org>
    f2fs: handle readonly filesystem in f2fs_ioc_shutdown()

Mauricio Faria de Oliveira <mfo@canonical.com>
    apparmor: check/put label on apparmor_sk_clone_security()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    net: dsa: lantiq_gswip: fix and improve the unsupported interface error

John Johansen <john.johansen@canonical.com>
    apparmor: fix introspection of of task mode for unconfined tasks

ashimida <ashimida@linux.alibaba.com>
    mksysmap: Fix the mismatch of '.L' symbols in System.map

Logan Gunthorpe <logang@deltatee.com>
    NTB: Fix the default port and peer numbers for legacy drivers

Logan Gunthorpe <logang@deltatee.com>
    NTB: ntb_pingpong: Choose doorbells based on port number

Colin Ian King <colin.king@canonical.com>
    ASoC: meson: fix memory leak of links if allocation of ldata fails

Ahmed S. Darwish <a.darwish@linutronix.de>
    net: mdiobus: Disable preemption upon u64_stats update

Wang Hai <wanghai38@huawei.com>
    yam: fix possible memory leak in yam_init_driver

Tero Kristo <t-kristo@ti.com>
    crypto: omap-sham - huge buffer access fixes

Thierry Reding <treding@nvidia.com>
    drm/nouveau: gr/gk20a: Use firmware version 0

Arnd Bergmann <arnd@arndb.de>
    clk: sprd: fix compile-testing

Will Deacon <will@kernel.org>
    sparc32: mm: Don't try to free page-table pages if ctor() fails

Navid Emamdoost <navid.emamdoost@gmail.com>
    pwm: img: Call pm_runtime_put() in pm_runtime_get_sync() failed case

Pingfan Liu <kernelfans@gmail.com>
    powerpc/crashkernel: Take "mem=" option into account

John Stultz <john.stultz@linaro.org>
    ASoC: qcom: q6asm-dai: kCFI fix

Paulo Alcantara <pc@cjr.nz>
    cifs: set up next DFS target before generic_ip_connect()

Qiushi Wu <wu000273@umn.edu>
    RDMA/core: Fix several reference count leaks.

Jon Derrick <jonathan.derrick@intel.com>
    PCI: vmd: Filter resource type bits from shadow register

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    nfsd: Fix svc_xprt refcnt leak when setup callback client failed

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf/hv-24x7: Fix inconsistent output values incase multiple hv-24x7 events run

Mark Zhang <markz@mellanox.com>
    IB/mlx5: Fix DEVX support for MLX5_CMD_OP_INIT2INIT_QP command

Alain Volmat <avolmat@me.com>
    clk: clk-flexgen: fix clock-critical handling

Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
    scsi: vhost: Notify TCM about the maximum sg entries supported per command

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event

Quanyang Wang <quanyang.wang@windriver.com>
    clk: zynqmp: fix memory leak in zynqmp_register_clocks

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: cxgb3i: Fix some leaks in init_act_open()

Marek Szyprowski <m.szyprowski@samsung.com>
    mfd: wm8994: Fix driver operation if loaded as modules

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/ptdump: Add _PAGE_COHERENT flag

Peter Chen <peter.chen@nxp.com>
    usb: gadget: core: sync interrupt before unbind the udc

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: dwapb: Call acpi_gpiochip_free_interrupts() on GPIO chip de-registration

Dinghao Liu <dinghao.liu@zju.edu.cn>
    usb: cdns3: Fix runtime PM imbalance on error

Omer Shpigelman <oshpigelman@habana.ai>
    habanalabs: don't allow hard reset with open processes

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    m68k/PCI: Fix a memory leak in an error handling path

Jon Derrick <jonathan.derrick@intel.com>
    PCI: pci-bridge-emul: Fix PCIe bit conflicts

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/book3s64/radix/tlb: Determine hugepage flush correctly

Luo Jiaxing <luojiaxing@huawei.com>
    scsi: hisi_sas: Do not reset phy timer to wait for stray phy up

Aharon Landau <aharonl@mellanox.com>
    RDMA/mlx5: Add init2init as a modify command

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    coresight: tmc: Fix TMC mode read in tmc_read_prepare_etb()

Maulik Shah <mkshah@codeaurora.org>
    arm64: dts: qcom: sc7180: Correct the pdc interrupt ranges

Qian Cai <cai@lca.pw>
    vfio/pci: fix memory leaks in alloc_perm_bits()

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: fvp/juno: Fix node address fields

Emmanuel Nicolet <emmanuel.nicolet@gmail.com>
    ps3disk: use the default segment boundary

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Don't blindly enable ASPM L0s and don't write to read-only register

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: fvp: Fix GIC child nodes

Daniel Baluta <daniel.baluta@nxp.com>
    ASoC: SOF: Do nothing when DSP PM callbacks are not set

Geert Uytterhoeven <geert+renesas@glider.be>
    clk: renesas: cpg-mssr: Fix STBCR suspend/resume handling

Lars Povlsen <lars.povlsen@microchip.com>
    pinctrl: ocelot: Fix GPIO interrupt decoding on Jaguar2

Kamal Heib <kamalheib1@gmail.com>
    RDMA/srpt: Fix disabling device management

Yishai Hadas <yishaih@mellanox.com>
    RDMA/uverbs: Fix create WQ to use the given user handle

Andre Przywara <andre.przywara@arm.com>
    arm64: dts: juno: Fix GIC child nodes

Marek Behún <marek.behun@nic.cz>
    arm64: dts: armada-3720-turris-mox: fix SFP binding

Marek Behún <marek.behun@nic.cz>
    arm64: dts: armada-3720-turris-mox: forbid SDR104 on SDIO for FCC purposes

Martin Wilck <mwilck@suse.com>
    dm mpath: switch paths in dm_blk_ioctl() code path

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    misc: fastrpc: fix potential fastrpc_invoke_ctx leak

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    misc: fastrpc: Fix an incomplete memory release in fastrpc_rpmsg_probe()

Michael Auchter <michael.auchter@ni.com>
    nvmem: ensure sysfs writes handle write-protect pin

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    serial: 8250: Fix max baud limit in generic 8250 port

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    usb: roles: Switch on role-switch uevent reporting

Oliver Neukum <oneukum@suse.com>
    usblp: poison URBs upon disconnect

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix output of rx_stats on big endian hosts

Marek Szyprowski <m.szyprowski@samsung.com>
    clk: samsung: Mark top ISP and CAM clocks on Exynos542x as critical

Sibi Sankar <sibis@codeaurora.org>
    remoteproc: qcom_q6v5_mss: map/unmap mpss segments before/after use

Russell King <rmk+kernel@armlinux.org.uk>
    i2c: pxa: clear all master action bits in i2c_pxa_stop_message()

Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
    f2fs: report delalloc reserve as non-free in statfs for project quota

Chao Yu <chao@kernel.org>
    f2fs: compress: let lz4 compressor handle output buffer budget properly

Andreas Klinger <ak@it-klinger.de>
    iio: bmp280: fix compensation of humidity

Qiushi Wu <wu000273@umn.edu>
    rtc: mc13xxx: fix a double-unlock issue

Christophe Leroy <christophe.leroy@c-s.fr>
    powerpc/kasan: Fix stack overflow by increasing THREAD_SHIFT

Jim Quinlan <jquinlan@broadcom.com>
    PCI: brcmstb: Fix window register offset from 4 to 8

Marco Felsch <m.felsch@pengutronix.de>
    Input: edt-ft5x06 - fix get_default register write access

Viacheslav Dubeyko <v.dubeiko@yadro.com>
    scsi: qla2xxx: Fix issue with adapter's stopping state

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    PCI: endpoint: functions/pci-epf-test: Fix DMA channel release

Ard Biesheuvel <ardb@kernel.org>
    PCI: Allow pci_resize_resource() for devices on root bus

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: isa/wavefront: prevent out of bounds write in ioctl

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek - Introduce polarity for micmute LED GPIO

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson: fixup SCP sram nodes

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: qedi: Check for buffer overflow in qedi_set_path()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    scsi: core: free sgtables in case command setup fails

Neil Armstrong <narmstrong@baylibre.com>
    arm64: dts: meson-gxbb-kii-pro: fix board compatible

Arnd Bergmann <arnd@arndb.de>
    ASoC: codecs: wm97xx: fix ac97 dependency

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: Fix IOMMU device node names

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Add missing ethernet PHY reset on AV96

Linus Walleij <linus.walleij@linaro.org>
    ARM: integrator: Add some Kconfig selections

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    ASoC: davinci-mcasp: Fix dma_chan refcnt leak when getting dma type

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    ARM: dts: renesas: Fix IOMMU device node names

Jon Hunter <jonathanh@nvidia.com>
    backlight: lp855x: Ensure regulators are disabled on probe failure

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_esai: Disable exception interrupt before scheduling tasklet

Dan Carpenter <dan.carpenter@oracle.com>
    staging: wfx: check ssidlen and prevent an array overflow

Bryan O'Donoghue <bryan.odonoghue@linaro.org>
    clk: qcom: msm8916: Fix the address location of pll->config_reg

Alex Elder <elder@linaro.org>
    remoteproc: Fix IDR initialisation in rproc_alloc()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    iio: pressure: bmp280: Tolerate IRQ before registering

YueHaibing <yuehaibing@huawei.com>
    ASoC: SOF: imx8: Fix randbuild error

Adam Honse <calcprogrammer1@gmail.com>
    i2c: piix4: Detect secondary SMBus controller on AMD AM4 chipsets

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: rc5t619: Fix an ERR_PTR vs NULL check

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra: tegra_wm8903: Support nvidia, headset property

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    clk: sunxi: Fix incorrect usage of round_down()

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    power: supply: bq24257_charger: Replace depends on REGMAP_I2C with select

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix potential deadlock in wfx_tx_flush()


-------------

Diffstat:

 Makefile                                           |   4 +-
 .../arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts |   4 +-
 arch/arm/boot/dts/aspeed-g5.dtsi                   |  24 +-
 arch/arm/boot/dts/aspeed-g6.dtsi                   |  25 +-
 arch/arm/boot/dts/bcm2835-common.dtsi              |   1 -
 arch/arm/boot/dts/bcm2835-rpi-common.dtsi          |  12 +
 arch/arm/boot/dts/bcm2835.dtsi                     |   1 +
 arch/arm/boot/dts/bcm2836.dtsi                     |   1 +
 arch/arm/boot/dts/bcm2837.dtsi                     |   1 +
 arch/arm/boot/dts/r8a7743.dtsi                     |  12 +-
 arch/arm/boot/dts/r8a7744.dtsi                     |  12 +-
 arch/arm/boot/dts/r8a7745.dtsi                     |  12 +-
 arch/arm/boot/dts/r8a7790.dtsi                     |  12 +-
 arch/arm/boot/dts/r8a7791.dtsi                     |  14 +-
 arch/arm/boot/dts/r8a7793.dtsi                     |  14 +-
 arch/arm/boot/dts/r8a7794.dtsi                     |  12 +-
 arch/arm/boot/dts/stm32mp157a-avenger96.dts        |   3 +
 .../boot/dts/sun8i-h2-plus-bananapi-m2-zero.dts    |   2 +-
 arch/arm/boot/dts/vexpress-v2m-rs1.dtsi            |  10 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |  26 +-
 arch/arm/mach-integrator/Kconfig                   |   7 +-
 arch/arm64/Kconfig.platforms                       |   2 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   6 +-
 .../boot/dts/amlogic/meson-g12b-ugoos-am6.dts      |   2 +-
 .../boot/dts/amlogic/meson-gx-libretech-pc.dtsi    |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |  10 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts |   2 +-
 .../boot/dts/amlogic/meson-gxbb-nanopi-k2.dts      |   2 +-
 .../boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts    |   2 +-
 .../arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts |   2 +-
 .../boot/dts/amlogic/meson-gxbb-vega-s95.dtsi      |   2 +-
 .../boot/dts/amlogic/meson-gxbb-wetek-play2.dts    |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi  |   2 +-
 .../dts/amlogic/meson-gxl-s905x-libretech-cc.dts   |   4 +-
 arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts |   4 +-
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi |   4 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts   |   2 +-
 arch/arm64/boot/dts/arm/foundation-v8-gicv2.dtsi   |   2 +-
 arch/arm64/boot/dts/arm/foundation-v8-gicv3.dtsi   |   8 +-
 arch/arm64/boot/dts/arm/foundation-v8.dtsi         |  92 ++---
 arch/arm64/boot/dts/arm/juno-base.dtsi             |  50 +--
 arch/arm64/boot/dts/arm/juno-motherboard.dtsi      |   6 +-
 .../boot/dts/arm/rtsm_ve-motherboard-rs2.dtsi      |   2 +-
 arch/arm64/boot/dts/arm/rtsm_ve-motherboard.dtsi   |   6 +-
 arch/arm64/boot/dts/marvell/armada-3720-db.dts     |   3 +
 .../boot/dts/marvell/armada-3720-espressobin.dtsi  |   1 +
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   8 +-
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi       |   2 +-
 arch/arm64/boot/dts/mediatek/mt8173.dtsi           |  22 +-
 arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi     |   2 +-
 arch/arm64/boot/dts/nvidia/tegra194.dtsi           |  12 +-
 arch/arm64/boot/dts/qcom/apq8096-db820c.dtsi       |  14 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |   8 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |  20 +-
 arch/arm64/boot/dts/qcom/pm8150.dtsi               |  14 +-
 arch/arm64/boot/dts/qcom/pm8150b.dtsi              |  14 +-
 arch/arm64/boot/dts/qcom/pm8150l.dtsi              |  14 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi               |   3 +-
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      |  11 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   4 +-
 arch/arm64/boot/dts/realtek/rtd1293-ds418j.dts     |   6 +-
 arch/arm64/boot/dts/realtek/rtd1293.dtsi           |  12 +-
 arch/arm64/boot/dts/realtek/rtd1295-mele-v9.dts    |   6 +-
 .../arm64/boot/dts/realtek/rtd1295-probox2-ava.dts |   6 +-
 arch/arm64/boot/dts/realtek/rtd1295-zidoo-x9s.dts  |   4 +-
 arch/arm64/boot/dts/realtek/rtd1295.dtsi           |  21 +-
 arch/arm64/boot/dts/realtek/rtd1296-ds418.dts      |   4 +-
 arch/arm64/boot/dts/realtek/rtd1296.dtsi           |   8 +-
 arch/arm64/boot/dts/realtek/rtd129x.dtsi           |  32 +-
 arch/arm64/boot/dts/renesas/r8a774a1.dtsi          |  18 +-
 arch/arm64/boot/dts/renesas/r8a774b1.dtsi          |  18 +-
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi          |  18 +-
 arch/arm64/boot/dts/renesas/r8a77950.dtsi          |  14 +-
 arch/arm64/boot/dts/renesas/r8a77951.dtsi          |  34 +-
 arch/arm64/boot/dts/renesas/r8a77960.dtsi          |  22 +-
 arch/arm64/boot/dts/renesas/r8a77965.dtsi          |  20 +-
 arch/arm64/boot/dts/renesas/r8a77970.dtsi          |  10 +-
 arch/arm64/boot/dts/renesas/r8a77980.dtsi          |  16 +-
 arch/arm64/boot/dts/renesas/r8a77990.dtsi          |  20 +-
 arch/arm64/boot/dts/renesas/r8a77995.dtsi          |  20 +-
 arch/arm64/kernel/ftrace.c                         |   3 +-
 arch/arm64/kernel/hw_breakpoint.c                  |  44 ++-
 arch/arm64/mm/init.c                               |  15 +-
 arch/m68k/coldfire/pci.c                           |   4 +-
 arch/openrisc/kernel/entry.S                       |   4 +-
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/configs/adder875_defconfig            |   1 -
 arch/powerpc/configs/ep88xc_defconfig              |   1 -
 arch/powerpc/configs/mpc866_ads_defconfig          |   1 -
 arch/powerpc/configs/mpc885_ads_defconfig          |   1 -
 arch/powerpc/configs/tqm8xx_defconfig              |   1 -
 arch/powerpc/include/asm/book3s/64/kup-radix.h     |  11 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h       |  23 +-
 arch/powerpc/include/asm/nohash/32/mmu-8xx.h       |   2 -
 arch/powerpc/include/asm/processor.h               |   1 -
 arch/powerpc/kernel/exceptions-64s.S               |  37 +-
 arch/powerpc/kernel/head_64.S                      |   9 +-
 arch/powerpc/kernel/head_8xx.S                     |  15 +-
 arch/powerpc/kernel/process.c                      |  20 +-
 arch/powerpc/kexec/core.c                          |   8 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |  16 +-
 arch/powerpc/kvm/book3s_64_vio.c                   |  18 +-
 arch/powerpc/kvm/book3s_hv.c                       |  11 +-
 arch/powerpc/mm/book3s32/mmu.c                     |   6 +-
 arch/powerpc/mm/book3s64/radix_tlb.c               |   4 +-
 arch/powerpc/mm/kasan/kasan_init_32.c              |   5 +-
 arch/powerpc/mm/ptdump/shared.c                    |   5 +
 arch/powerpc/perf/hv-24x7.c                        |  10 -
 arch/powerpc/platforms/4xx/pci.c                   |   4 +-
 arch/powerpc/platforms/8xx/Kconfig                 |   9 -
 arch/powerpc/platforms/powernv/opal.c              |   4 +
 arch/powerpc/platforms/ps3/mm.c                    |  22 +-
 arch/powerpc/platforms/pseries/ras.c               |   5 +-
 arch/s390/Kconfig                                  |   1 +
 arch/s390/include/asm/syscall.h                    |  12 +-
 arch/sh/include/asm/io.h                           |   2 +-
 arch/sparc/mm/srmmu.c                              |   1 -
 arch/um/drivers/Makefile                           |   4 +-
 arch/unicore32/lib/Makefile                        |   4 +-
 arch/x86/kernel/apic/apic.c                        |   2 +-
 arch/x86/kernel/cpu/mce/dev-mcelog.c               |   2 +-
 arch/x86/kernel/idt.c                              |   6 +-
 arch/x86/kernel/kprobes/core.c                     |  16 +-
 arch/x86/purgatory/Makefile                        |   5 +-
 crypto/algboss.c                                   |   2 -
 crypto/algif_skcipher.c                            |   6 +-
 drivers/ata/libata-core.c                          |  11 +-
 drivers/base/platform.c                            |   2 +
 drivers/block/ps3disk.c                            |   1 -
 drivers/bus/mhi/core/main.c                        |   9 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   7 +-
 drivers/char/mem.c                                 | 101 ++++-
 drivers/clk/Makefile                               |   2 +-
 drivers/clk/bcm/clk-bcm2835.c                      |  10 +-
 drivers/clk/clk-ast2600.c                          |  31 +-
 drivers/clk/meson/meson8b.c                        | 100 +++--
 drivers/clk/meson/meson8b.h                        |   4 +
 drivers/clk/qcom/gcc-msm8916.c                     |   8 +-
 drivers/clk/renesas/renesas-cpg-mssr.c             |   8 +-
 drivers/clk/samsung/clk-exynos5420.c               |  16 +-
 drivers/clk/samsung/clk-exynos5433.c               |   3 +-
 drivers/clk/sprd/pll.c                             |   2 +-
 drivers/clk/st/clk-flexgen.c                       |   1 +
 drivers/clk/sunxi/clk-sunxi.c                      |   2 +-
 drivers/clk/ti/composite.c                         |   1 +
 drivers/clk/zynqmp/clkc.c                          |  15 +-
 drivers/clk/zynqmp/divider.c                       |  17 +-
 drivers/crypto/hisilicon/sgl.c                     |   3 +-
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c   |  11 +-
 drivers/crypto/omap-sham.c                         |  75 ++--
 drivers/extcon/extcon-adc-jack.c                   |   3 +-
 drivers/firmware/imx/imx-scu.c                     |   1 +
 drivers/firmware/qcom_scm.c                        |   9 +-
 drivers/fpga/dfl-afu-dma-region.c                  |   4 +-
 drivers/gpio/gpio-dwapb.c                          |  34 +-
 drivers/gpio/gpio-mlxbf2.c                         |   4 +-
 drivers/gpio/gpio-pca953x.c                        |  44 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |   3 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  11 +-
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  30 +-
 .../drm/amd/display/modules/color/color_gamma.c    |   2 +-
 drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c   |   2 +-
 drivers/gpu/drm/ast/ast_mode.c                     |   4 +
 drivers/gpu/drm/drm_connector.c                    |   5 +
 drivers/gpu/drm/drm_dp_mst_topology.c              |  58 +--
 drivers/gpu/drm/drm_encoder_slave.c                |   5 +-
 drivers/gpu/drm/drm_sysfs.c                        |   3 -
 drivers/gpu/drm/i915/display/intel_ddi.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   5 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c          |  15 +-
 drivers/gpu/drm/i915/gt/intel_engine_cs.c          |   4 +-
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  21 +-
 drivers/gpu/drm/i915/gt/intel_ring.c               |   4 +
 drivers/gpu/drm/i915/gt/intel_workarounds.c        | 253 ++++++++++++-
 drivers/gpu/drm/i915/gt/selftest_mocs.c            |  18 +-
 drivers/gpu/drm/i915/gt/selftest_ring.c            | 110 ++++++
 drivers/gpu/drm/i915/i915_cmd_parser.c             |   4 +
 drivers/gpu/drm/i915/i915_irq.c                    |   1 +
 drivers/gpu/drm/i915/i915_reg.h                    |   2 +-
 drivers/gpu/drm/i915/intel_pm.c                    | 206 +---------
 .../gpu/drm/i915/selftests/i915_mock_selftests.h   |   1 +
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   6 +
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c              |   8 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   7 +
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   3 +-
 drivers/gpu/drm/msm/msm_rd.c                       |   4 +-
 drivers/gpu/drm/nouveau/dispnv50/disp.c            |  16 +-
 .../gpu/drm/nouveau/nvkm/engine/disp/hdmigm200.c   |   4 +-
 drivers/gpu/drm/nouveau/nvkm/engine/gr/gk20a.c     |   2 +-
 drivers/gpu/drm/qxl/qxl_kms.c                      |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi.h                 |   2 +-
 drivers/gpu/drm/sun4i/sun4i_hdmi_ddc_clk.c         |   2 +-
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hid/hid-quirks.c                           |   1 +
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c        |   2 +
 drivers/hwtracing/coresight/coresight-etm4x.c      |   1 +
 drivers/hwtracing/coresight/coresight-platform.c   |  85 +++--
 drivers/hwtracing/coresight/coresight-tmc-etf.c    |  16 +-
 drivers/hwtracing/coresight/coresight.c            |   7 +-
 drivers/i2c/busses/i2c-icy.c                       |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |   3 +-
 drivers/i2c/busses/i2c-pxa.c                       |  13 +-
 drivers/iio/buffer/industrialio-buffer-dmaengine.c |   2 +-
 drivers/iio/light/gp2ap002.c                       |  19 +-
 drivers/iio/pressure/bmp280-core.c                 |   7 +-
 drivers/infiniband/core/cm.c                       |   4 +-
 drivers/infiniband/core/cma_configfs.c             |  13 +
 drivers/infiniband/core/sysfs.c                    |  10 +-
 drivers/infiniband/core/uverbs_cmd.c               |   3 +-
 drivers/infiniband/hw/cxgb4/device.c               |   1 +
 drivers/infiniband/hw/efa/efa_com_cmd.c            |   4 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |  34 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   5 +
 drivers/infiniband/hw/mlx5/srq.c                   |  10 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   8 +-
 drivers/input/serio/i8042-ppcio.h                  |  57 ---
 drivers/input/serio/i8042.h                        |   2 -
 drivers/input/touchscreen/edt-ft5x06.c             |  12 +-
 drivers/iommu/arm-smmu-v3.c                        |  35 +-
 drivers/iommu/intel-iommu.c                        |   3 -
 drivers/mailbox/imx-mailbox.c                      |  37 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |  20 +-
 drivers/md/bcache/btree.c                          |   8 +-
 drivers/md/dm-mpath.c                              |   2 +-
 drivers/md/dm-zoned-metadata.c                     |   4 +-
 drivers/md/dm-zoned-reclaim.c                      |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   6 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |   2 +-
 drivers/mfd/stmfx.c                                |  22 +-
 drivers/mfd/wcd934x.c                              |   1 -
 drivers/mfd/wm8994-core.c                          |   1 +
 drivers/misc/fastrpc.c                             |  13 +-
 drivers/misc/habanalabs/device.c                   |  17 +-
 drivers/misc/habanalabs/habanalabs.h               |   2 +-
 drivers/misc/xilinx_sdfec.c                        |  27 +-
 drivers/net/bareudp.c                              |   2 +
 drivers/net/dsa/lantiq_gswip.c                     |   3 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c              |   8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  35 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |   5 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |   3 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  14 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |  14 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  14 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  25 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  88 ++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   7 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  13 +
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |   1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   1 +
 drivers/net/geneve.c                               |   7 +-
 drivers/net/hamradio/yam.c                         |   1 +
 drivers/net/ipa/ipa_endpoint.c                     |   6 +-
 drivers/net/ipa/ipa_reg.h                          |   2 +
 drivers/net/phy/dp83867.c                          |   2 +-
 drivers/net/phy/marvell.c                          |   2 +-
 drivers/net/phy/mdio_bus.c                         |   2 +
 drivers/net/phy/mscc/mscc.h                        |   2 +-
 drivers/net/phy/mscc/mscc_main.c                   |   4 +-
 drivers/ntb/core.c                                 |   9 +-
 drivers/ntb/test/ntb_perf.c                        |  30 +-
 drivers/ntb/test/ntb_pingpong.c                    |  14 +-
 drivers/ntb/test/ntb_tool.c                        |   9 +-
 drivers/nvme/host/fc.c                             |   5 +-
 drivers/nvme/host/pci.c                            |   6 +
 drivers/nvmem/core.c                               |  52 +--
 drivers/of/kobj.c                                  |   3 +-
 drivers/of/property.c                              |  16 +-
 drivers/pci/controller/dwc/pci-dra7xx.c            |   8 +-
 drivers/pci/controller/dwc/pci-meson.c             |   4 +-
 drivers/pci/controller/dwc/pcie-designware-host.c  |   2 +
 drivers/pci/controller/pci-aardvark.c              | 158 ++++++--
 drivers/pci/controller/pci-v3-semi.c               |   2 +-
 drivers/pci/controller/pcie-brcmstb.c              |   5 +-
 drivers/pci/controller/pcie-rcar.c                 |   9 +-
 drivers/pci/controller/vmd.c                       |   6 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |   3 +
 drivers/pci/pci-bridge-emul.c                      |   6 +-
 drivers/pci/pci.c                                  |  30 +-
 drivers/pci/pcie/aspm.c                            |  10 -
 drivers/pci/pcie/ptm.c                             |  22 +-
 drivers/pci/probe.c                                |   5 +-
 drivers/pci/setup-res.c                            |   9 +-
 drivers/perf/hisilicon/hisi_uncore_l3c_pmu.c       |   2 +-
 drivers/phy/broadcom/phy-bcm-sr-usb.c              |  55 +--
 drivers/phy/cadence/phy-cadence-sierra.c           |  27 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |   6 +-
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c             |   2 +-
 drivers/pinctrl/freescale/pinctrl-imx.c            |  19 +-
 drivers/pinctrl/freescale/pinctrl-imx1-core.c      |   1 -
 drivers/pinctrl/pinctrl-at91-pio4.c                |   2 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |  33 +-
 drivers/pinctrl/pinctrl-rockchip.c                 |   7 +-
 drivers/pinctrl/pinctrl-rza1.c                     |   2 +-
 drivers/pinctrl/qcom/pinctrl-ipq6018.c             |   3 +-
 drivers/pinctrl/sirf/pinctrl-sirf.c                |  20 +-
 drivers/power/supply/Kconfig                       |   2 +-
 drivers/power/supply/lp8788-charger.c              |  18 +-
 drivers/power/supply/smb347-charger.c              |   1 +
 drivers/pwm/core.c                                 |   2 +-
 drivers/pwm/pwm-img.c                              |   8 +-
 drivers/pwm/pwm-imx27.c                            |  20 +-
 drivers/remoteproc/mtk_scp.c                       |   4 +-
 drivers/remoteproc/qcom_q6v5_mss.c                 | 133 ++-----
 drivers/remoteproc/remoteproc_core.c               |   3 +-
 drivers/rtc/rtc-mc13xxx.c                          |   4 +-
 drivers/rtc/rtc-rc5t619.c                          |   4 +-
 drivers/rtc/rtc-rv3028.c                           |   2 +
 drivers/s390/cio/qdio.h                            |   2 +-
 drivers/s390/cio/qdio_main.c                       |  19 +-
 drivers/s390/cio/qdio_setup.c                      |  21 +-
 drivers/s390/cio/qdio_thinint.c                    |  14 +-
 drivers/scsi/arm/acornscsi.c                       |   4 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |  18 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   5 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   2 +
 drivers/scsi/iscsi_boot_sysfs.c                    |   2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   2 +
 drivers/scsi/mpt3sas/mpt3sas_base.c                |   2 +
 drivers/scsi/qedf/qedf.h                           |   1 +
 drivers/scsi/qedf/qedf_main.c                      |  35 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |   7 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   2 +
 drivers/scsi/scsi_error.c                          |   2 +
 drivers/scsi/scsi_lib.c                            |  20 +-
 drivers/scsi/scsi_transport_iscsi.c                |  64 +++-
 drivers/scsi/sr.c                                  |   7 +-
 drivers/scsi/ufs/ti-j721e-ufs.c                    |  13 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   6 +-
 drivers/scsi/ufs/ufs_bsg.c                         |   4 +-
 drivers/scsi/ufs/ufshcd.c                          |   1 -
 drivers/slimbus/qcom-ngd-ctrl.c                    |   4 +-
 drivers/soundwire/slave.c                          |   2 +
 drivers/staging/gasket/gasket_sysfs.c              |   2 +
 drivers/staging/greybus/light.c                    |   3 +-
 drivers/staging/mt7621-dts/mt7621.dtsi             |   9 +-
 drivers/staging/mt7621-pci/pci-mt7621.c            |  36 +-
 drivers/staging/sm750fb/sm750.c                    |   1 +
 drivers/staging/wfx/bus_sdio.c                     |  19 +-
 drivers/staging/wfx/debug.c                        |  11 +-
 drivers/staging/wfx/hif_tx.c                       |   2 +-
 drivers/staging/wfx/queue.c                        |   2 +
 drivers/staging/wfx/sta.c                          |   5 +-
 drivers/staging/wfx/sta.h                          |   2 +-
 drivers/staging/wilc1000/hif.c                     |   4 +-
 drivers/target/loopback/tcm_loop.c                 |  36 +-
 drivers/target/target_core_user.c                  | 154 ++++----
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   6 +-
 drivers/tty/hvc/hvc_console.c                      |  16 +-
 drivers/tty/n_gsm.c                                |  26 +-
 drivers/tty/serial/8250/8250_port.c                |   4 +-
 drivers/usb/cdns3/cdns3-ti.c                       |   3 +-
 drivers/usb/class/usblp.c                          |   5 +-
 drivers/usb/dwc2/core_intr.c                       |   7 +-
 drivers/usb/dwc3/dwc3-meson-g12a.c                 |   6 +-
 drivers/usb/dwc3/gadget.c                          |  60 ++-
 drivers/usb/gadget/composite.c                     |  78 +++-
 drivers/usb/gadget/udc/core.c                      |   2 +
 drivers/usb/gadget/udc/lpc32xx_udc.c               |  11 +-
 drivers/usb/gadget/udc/m66592-udc.c                |   2 +-
 drivers/usb/gadget/udc/s3c2410_udc.c               |   4 -
 drivers/usb/host/ehci-mxc.c                        |   2 +
 drivers/usb/host/ehci-platform.c                   |   4 +
 drivers/usb/host/ohci-platform.c                   |   5 +
 drivers/usb/host/ohci-sm501.c                      |   7 +-
 drivers/usb/host/xhci-plat.c                       |  10 +-
 drivers/usb/roles/class.c                          |   4 +-
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 drivers/vfio/pci/vfio_pci_config.c                 |  14 +-
 drivers/vhost/scsi.c                               |   1 +
 drivers/video/backlight/lp855x_bl.c                |  20 +-
 drivers/watchdog/da9062_wdt.c                      |   5 -
 drivers/xen/cpu_hotplug.c                          |   8 +-
 fs/afs/cmservice.c                                 |   9 +-
 fs/afs/dir.c                                       |   9 +-
 fs/afs/fsclient.c                                  | 103 ++---
 fs/afs/inode.c                                     |  16 +-
 fs/afs/internal.h                                  |   3 +-
 fs/afs/misc.c                                      |   1 +
 fs/afs/proc.c                                      |   1 +
 fs/afs/rxrpc.c                                     |  10 +-
 fs/afs/vlclient.c                                  |  34 +-
 fs/afs/write.c                                     |   5 +-
 fs/afs/yfsclient.c                                 | 100 ++---
 fs/block_dev.c                                     |  12 +-
 fs/ceph/export.c                                   |   9 +-
 fs/cifs/connect.c                                  |  18 +-
 fs/dlm/dlm_internal.h                              |   1 -
 fs/ext4/acl.c                                      |   2 +-
 fs/ext4/dir.c                                      |  16 +
 fs/ext4/ext4.h                                     |   2 +-
 fs/ext4/ext4_jbd2.h                                |   5 +-
 fs/ext4/extents.c                                  |  36 +-
 fs/ext4/file.c                                     |  17 +-
 fs/ext4/indirect.c                                 |   4 +-
 fs/ext4/inline.c                                   |   6 +-
 fs/ext4/inode.c                                    |  38 +-
 fs/ext4/migrate.c                                  |  12 +-
 fs/ext4/namei.c                                    |  76 ++--
 fs/ext4/super.c                                    |  55 ++-
 fs/ext4/xattr.c                                    |   6 +-
 fs/f2fs/checkpoint.c                               |   4 +-
 fs/f2fs/compress.c                                 |  22 +-
 fs/f2fs/data.c                                     |   8 +-
 fs/f2fs/dir.c                                      |  80 ++--
 fs/f2fs/f2fs.h                                     |  15 +-
 fs/f2fs/file.c                                     |   9 +-
 fs/f2fs/node.c                                     |   8 +-
 fs/f2fs/super.c                                    |   5 +-
 fs/fuse/dev.c                                      |   5 +-
 fs/fuse/file.c                                     |  43 ++-
 fs/fuse/fuse_i.h                                   |   1 +
 fs/fuse/virtio_fs.c                                | 106 ++++--
 fs/gfs2/log.c                                      |  11 +-
 fs/gfs2/ops_fstype.c                               |   2 +-
 fs/io_uring.c                                      | 131 ++++---
 fs/jbd2/journal.c                                  |  17 +-
 fs/nfs/direct.c                                    |   2 +
 fs/nfs/inode.c                                     |  14 +-
 fs/nfs/nfs4proc.c                                  |   2 +-
 fs/nfsd/cache.h                                    |   2 +
 fs/nfsd/netns.h                                    |   1 -
 fs/nfsd/nfs4callback.c                             |   2 +
 fs/nfsd/nfscache.c                                 |  32 +-
 fs/nfsd/nfsctl.c                                   |   6 +
 fs/proc/bootconfig.c                               |  15 +-
 fs/xfs/xfs_inode.c                                 |   4 +-
 include/linux/bitops.h                             |   2 +-
 include/linux/coresight.h                          |  10 +-
 include/linux/ioport.h                             |   6 +
 include/linux/jbd2.h                               |   6 +-
 include/linux/kprobes.h                            |   4 +
 include/linux/libata.h                             |   3 +
 include/linux/mfd/stmfx.h                          |   1 +
 include/linux/nfs_fs.h                             |   1 +
 include/linux/usb/composite.h                      |   3 +
 include/linux/usb/gadget.h                         |   2 +
 include/sound/soc.h                                |   8 +-
 include/trace/events/afs.h                         |  10 +-
 include/uapi/linux/magic.h                         |   1 +
 kernel/bpf/syscall.c                               |  17 +-
 kernel/bpf/verifier.c                              |   2 +-
 kernel/kprobes.c                                   |  27 +-
 kernel/resource.c                                  |   5 +
 kernel/trace/blktrace.c                            |  30 +-
 kernel/trace/trace.h                               |   3 +
 kernel/trace/trace_entries.h                       |  14 +-
 kernel/trace/trace_export.c                        |  16 +
 kernel/trace/trace_kprobe.c                        |   2 +-
 kernel/trace/trace_probe.c                         |   4 +-
 kernel/trace/trace_uprobe.c                        |   2 +-
 lib/zlib_inflate/inffast.c                         |  91 ++---
 net/core/dev.c                                     |  40 +-
 net/core/filter.c                                  |  16 +-
 net/core/sock_map.c                                |  38 +-
 net/ipv4/tcp_bpf.c                                 |   6 +
 net/netfilter/nft_set_pipapo.c                     |   6 +-
 net/netfilter/nft_set_rbtree.c                     |  21 +-
 net/rxrpc/proc.c                                   |   6 +-
 net/sunrpc/addr.c                                  |   4 +-
 net/xdp/xsk.c                                      |   4 +-
 samples/ftrace/sample-trace-array.c                |  24 +-
 scripts/Makefile.modpost                           |   7 +-
 scripts/headers_install.sh                         |  11 +-
 scripts/mksysmap                                   |   2 +-
 security/apparmor/domain.c                         |   9 +-
 security/apparmor/include/label.h                  |   1 +
 security/apparmor/label.c                          |  37 +-
 security/apparmor/lsm.c                            |   5 +
 security/selinux/ss/conditional.c                  |  21 +-
 security/selinux/ss/services.c                     |   4 +
 sound/firewire/amdtp-am824.c                       |   3 +-
 sound/isa/wavefront/wavefront_synth.c              |   8 +-
 sound/pci/hda/patch_realtek.c                      |  14 +-
 sound/soc/codecs/Kconfig                           |   9 +-
 sound/soc/codecs/max98373.c                        |   2 +-
 sound/soc/codecs/rt1308-sdw.c                      |   3 +
 sound/soc/codecs/rt5645.c                          |  14 +
 sound/soc/codecs/rt5682.c                          |   3 +
 sound/soc/codecs/rt700.c                           |   3 +
 sound/soc/codecs/rt711.c                           |   3 +
 sound/soc/codecs/rt715.c                           |   3 +
 sound/soc/fsl/fsl_asrc_dma.c                       |   1 +
 sound/soc/fsl/fsl_esai.c                           |   4 +
 sound/soc/img/img-i2s-in.c                         |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  24 ++
 sound/soc/meson/axg-fifo.c                         |  10 +-
 sound/soc/meson/meson-card-utils.c                 |  17 +-
 sound/soc/qcom/qdsp6/q6asm-dai.c                   |   4 +-
 sound/soc/sh/rcar/gen.c                            |   8 +
 sound/soc/sh/rcar/rsnd.h                           |   9 +
 sound/soc/sh/rcar/ssi.c                            | 145 +++++++
 sound/soc/soc-core.c                               |  22 +-
 sound/soc/soc-dapm.c                               |  12 +-
 sound/soc/soc-pcm.c                                |  44 ++-
 sound/soc/sof/control.c                            |   4 +-
 sound/soc/sof/core.c                               |   1 +
 sound/soc/sof/imx/Kconfig                          |   2 +-
 sound/soc/sof/intel/hda-codec.c                    |  51 ++-
 sound/soc/sof/nocodec.c                            |   6 +-
 sound/soc/sof/pm.c                                 |  10 +-
 sound/soc/sof/sof-audio.h                          |   2 +-
 sound/soc/sof/topology.c                           |   2 +
 sound/soc/tegra/tegra_wm8903.c                     |   6 +-
 sound/soc/ti/davinci-mcasp.c                       |   4 +-
 sound/soc/ti/omap-mcbsp.c                          |   8 +-
 sound/soc/ux500/mop500.c                           |  11 +-
 sound/usb/card.h                                   |   5 +
 sound/usb/endpoint.c                               | 244 +++++++++++-
 sound/usb/endpoint.h                               |   1 +
 sound/usb/mixer_quirks.c                           | 418 +++++++++++++++++++++
 sound/usb/pcm.c                                    |   7 +
 tools/bootconfig/main.c                            |  24 +-
 tools/bpf/bpftool/gen.c                            |   2 +
 tools/lib/bpf/btf_dump.c                           |  33 +-
 tools/lib/bpf/libbpf.c                             |   4 -
 tools/perf/builtin-report.c                        |   3 +-
 tools/perf/util/parse-events.y                     |   2 +-
 tools/perf/util/probe-event.c                      |   7 +-
 tools/perf/util/probe-file.c                       |   2 +-
 tools/perf/util/stat-display.c                     |   4 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |  45 ++-
 tools/testing/selftests/bpf/progs/test_skeleton.c  |  19 +-
 tools/testing/selftests/kvm/Makefile               |   4 +
 tools/testing/selftests/net/timestamping.c         |  10 +-
 tools/testing/selftests/ntb/ntb_test.sh            |   2 +-
 tools/testing/selftests/timens/clock_nanosleep.c   |   2 +-
 tools/testing/selftests/timens/timens.c            |   2 +-
 tools/testing/selftests/timens/timens.h            |  13 +-
 tools/testing/selftests/timens/timer.c             |   5 +
 tools/testing/selftests/timens/timerfd.c           |   5 +
 tools/testing/selftests/x86/protection_keys.c      |   3 +-
 535 files changed, 5327 insertions(+), 2788 deletions(-)


