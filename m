Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658004FE771
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354062AbiDLRtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 13:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiDLRtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 13:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7677A5D5CE;
        Tue, 12 Apr 2022 10:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7BF5619AC;
        Tue, 12 Apr 2022 17:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F730C385A5;
        Tue, 12 Apr 2022 17:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649785631;
        bh=lnIqoGuV4YmNrwaRHHT5gMvusIWQt/GgHSIHzLweLyQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IyiTwWzLLAwghoLm9Qqys/so5PK5lmWaaJnqbXJ8WiqmA94bckGlivzTw+8EZf+ZT
         mZ0d+r3vTLwcxWrcUbSgj8g/xXnQJ2uJh5h/wZ5lMJEYrTzWdGqzDmjM5dBdR+LcN5
         eiW4XuCXybkFw6zFSH9lj5e3OtC80AW/vtzT+MzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/277] 5.15.34-rc2 review
Date:   Tue, 12 Apr 2022 19:47:07 +0200
Message-Id: <20220412173836.126811734@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.34-rc2
X-KernelTest-Deadline: 2022-04-14T17:38+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.34 release.
There are 277 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 14 Apr 2022 17:37:56 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.34-rc2

Marco Elver <elver@google.com>
    stacktrace: move filter_irq_stacks() to kernel/stacktrace.c

Kefeng Wang <wangkefeng.wang@huawei.com>
    powerpc: Fix virt_addr_valid() for 64-bit Book3E & 32-bit

Christophe Leroy <christophe.leroy@csgroup.eu>
    static_call: Don't make __static_call_return0 static

Waiman Long <longman@redhat.com>
    mm/sparsemem: fix 'mem_section' will never be NULL gcc 12 warning

Andre Przywara <andre.przywara@arm.com>
    irqchip/gic, gic-v3: Prevent GSI to SGI translations

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64: Fix build failure with allyesconfig in book3s_64_entry.S

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v4: Wait for GICR_VPENDBASER.Dirty to clear before descheduling

Peter Zijlstra <peterz@infradead.org>
    x86,static_call: Fix __static_call_return0 for i386

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    sched: Teach the forced-newidle balancer about CPU affinity limitation.

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    x86/bug: Prevent shadowing in __WARN_FLAGS

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Replace smp_store_mb() with virt_store_mb()

Peter Xu <peterx@redhat.com>
    mm: don't skip swap entry even if zap_details specified

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Test open-time cgroup namespace usage for migration checks

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Test open-time credential usage for migration checks

Tejun Heo <tj@kernel.org>
    selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644

Kees Cook <keescook@chromium.org>
    ubsan: remove CONFIG_UBSAN_OBJECT_SIZE

dann frazier <dann.frazier@canonical.com>
    Revert "net/mlx5: Accept devlink user input after driver initialization complete"

Paolo Bonzini <pbonzini@redhat.com>
    KVM: avoid NULL pointer dereference in kvm_dirty_ring_push

Vinod Koul <vkoul@kernel.org>
    dmaengine: Revert "dmaengine: shdma: Fix runtime PM imbalance on error"

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Use $(shell ) instead of `` to get embedded libperl's ccopts

Arnaldo Carvalho de Melo <acme@redhat.com>
    tools build: Filter out options and warnings not supported by clang

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf python: Fix probing for some clang command line options

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf build: Don't use -ffat-lto-objects in the python feature test when building with clang-13

Jens Axboe <axboe@kernel.dk>
    Revert "nbd: fix possible overflow on 'first_minor' in nbd_dev_add()"

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Don't call connect() more than once on a TCP socket

Dan Carpenter <dan.carpenter@oracle.com>
    rtc: mc146818-lib: fix signedness bug in mc146818_get_time()

Jakub Sitnicki <jakub@cloudflare.com>
    selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide

Jakub Kicinski <kuba@kernel.org>
    Revert "selftests: net: Add tls config dependency for tls selftests"

Dust Li <dust.li@linux.alibaba.com>
    net/smc: send directly on setting TCP_NODELAY

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu: don't use BACO for reset in S3

Lee Jones <lee.jones@linaro.org>
    drm/amdkfd: Create file descriptor after client is added to smi_clients list

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/pmu: Add missing callbacks for Tegra devices

Emily Deng <Emily.Deng@amd.com>
    drm/amdgpu/vcn: Fix the register setting for vcn1

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/smu10: fix SoC/fclk units in auto mode

Benjamin Marty <info@benjaminmarty.ch>
    drm/amdgpu/display: change pipe policy for DCN 2.1

Daniel Mack <daniel@zonque.org>
    drm/panel: ili9341: fix optional regulator handling

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Prevent immediate close+reconnect

Shirish S <shirish.s@amd.com>
    amd/display: set backlight only if required

Thomas Zimmermann <tzimmermann@suse.de>
    fbdev: Fix unregistering of framebuffers without device

Marc Zyngier <maz@kernel.org>
    irqchip/gic-v3: Fix GICR_CTLR.RWP polling

Namhyung Kim <namhyung@kernel.org>
    perf/core: Inherit event_caps

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    perf: qcom_l2_pmu: fix an incorrect NULL check on list iterator

Christian Lamparter <chunkeey@gmail.com>
    ata: sata_dwc_460ex: Fix crash due to OOB write

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Don't extend the pseudo-encoding to GP counters

Dave Hansen <dave.hansen@linux.intel.com>
    x86/mm/tlb: Revert retpoline avoidance approach

Reto Buerki <reet@codelabs.ch>
    x86/msi: Fix msi message data shadow struct

Shreeya Patel <shreeya.patel@collabora.com>
    gpio: Restrict usage of GPIO chip irq members before initialization

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Fix use-after-free bug for mm struct

Guo Ren <guoren@linux.alibaba.com>
    arm64: patch_text: Fixup last cpu should be master

Vinod Koul <vkoul@kernel.org>
    spi: core: add dma_map_dev for __spi_unmap_msg()

Kaiwen Hu <kevinhu@synology.com>
    btrfs: prevent subvol with swapfile from being deleted

Ethan Lien <ethanlien@synology.com>
    btrfs: fix qgroup reserve overflow the qgroup limit

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Update the FRONTEND MSR mask on Sapphire Rapids

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/speculation: Restore speculation related MSRs during S3 resume

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/pm: Save the MSR validity status at context setup

Jens Axboe <axboe@kernel.dk>
    io_uring: fix race between timeout flush and removal

Eugene Syromiatnikov <esyr@redhat.com>
    io_uring: implement compat handling for IORING_REGISTER_IOWQ_AFF

Jens Axboe <axboe@kernel.dk>
    io_uring: defer splice/tee file validity check until command issue

Jens Axboe <axboe@kernel.dk>
    io_uring: don't check req->file in io_fsync_prep()

Miaohe Lin <linmiaohe@huawei.com>
    mm/mempolicy: fix mpol_new leak in shared_policy_replace

Paolo Bonzini <pbonzini@redhat.com>
    mmmremap.c: avoid pointless invalidate_range_start/end on mremap(old_size=0)

Max Filippov <jcmvbkbc@gmail.com>
    highmem: fix checks in __kmap_local_sched_{in,out}

Guo Xuenan <guoxuenan@huawei.com>
    lz4: fix LZ4_decompress_safe_partial read out of bound

Michael Wu <michael@allwinnertech.com>
    mmc: core: Fixup support for writeback-cache for eMMC and SD

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: don't overwrite TAP settings when HS400 tuning is complete

Yann Gautier <yann.gautier@foss.st.com>
    mmc: mmci: stm32: correctly check all elements of sg list

Christian Löhle <CLoehle@hyperstone.com>
    mmc: block: Check for errors after write on SPI

Pali Rohár <pali@kernel.org>
    Revert "mmc: sdhci-xenon: fix annoying 1.8V regulator warning"

Adrian Hunter <adrian.hunter@intel.com>
    scsi: ufs: ufs-pci: Add support for Intel MTL

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: mpt3sas: Fix use after free in _scsih_expander_node_remove()

Chanho Park <chanho61.park@samsung.com>
    arm64: Add part number for Arm Cortex-A78AE

Denis Nikitin <denik@chromium.org>
    perf session: Remap buf if there is no space for event

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix perf's libperf_print callback

James Clark <james.clark@arm.com>
    perf: arm-spe: Fix perf report --mem-mode

Tony Lindgren <tony@atomide.com>
    iommu/omap: Fix regression in probe for NULL pointer dereference

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: svc_tcp_sendmsg() should handle errors from xdr_alloc_bvec()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Handle low memory situations in call_status()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Handle ENOMEM in call_transmit_status()

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't touch scm_fp_list after queueing skb

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: nospec index for tags on files update

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    scsi: ufs: ufshpb: Fix a NULL check on list iterator

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drbd: Fix five use after free bugs in get_initial_state

Maxim Mikityanskiy <maximmi@nvidia.com>
    bpf: Support dual-stack sockets in bpf_tcp_check_syncookie

Kamal Dasu <kdasu.kdev@gmail.com>
    spi: bcm-qspi: fix MSPI only access with bcm_qspi_exec_mem_op()

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    qede: confirm skb is allocated before using

Michael Walle <michael@walle.cc>
    net: phy: mscc-miim: reject clause 45 register accesses

Taehee Yoo <ap420073@gmail.com>
    net: sfc: fix using uninitialized xdp tx_queue

Eric Dumazet <edumazet@google.com>
    rxrpc: fix a race in rxrpc_exit_net()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: fix leak of nested actions

Andrew Lunn <andrew@lunn.ch>
    net: ethernet: mv643xx: Fix over zealous checking of_get_mac_address()

Ilya Maximets <i.maximets@ovn.org>
    net: openvswitch: don't send internal clone attribute to the userspace.

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: xsk: fix VSI state check in ice_xsk_wakeup()

Maciej Fijalkowski <maciej.fijalkowski@intel.com>
    ice: synchronize_rcu() when terminating rings

David Ahern <dsahern@kernel.org>
    ipv6: Fix stats accounting in ip6_pkt_drop

Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
    ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

Anatolii Gerasymenko <anatolii.gerasymenko@intel.com>
    ice: Set txq_teid to ICE_INVAL_TEID on ring creation

Miaoqian Lin <linmq006@gmail.com>
    dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe

Jamie Bainbridge <jamie.bainbridge@gmail.com>
    sctp: count singleton chunks in assoc user stats

Niels Dossche <dossche.niels@gmail.com>
    IB/rdmavt: add lock to call to rvt_error_qp to prevent a race condition

Mark Zhang <markzhang@nvidia.com>
    IB/cm: Cancel mad on the DREQ event when the state is MRA_REP_RCVD

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Add a missing update of cache->last_add

Aharon Landau <aharonl@nvidia.com>
    RDMA/mlx5: Don't remove cache MRs when a delay is needed

Martin Habets <habetsm.xilinx@gmail.com>
    sfc: Do not free an empty page_ring

Ray Jui <ray.jui@broadcom.com>
    bnxt_en: Prevent XDP redirect from running when stopping TX queue

Andy Gospodarek <gospo@broadcom.com>
    bnxt_en: reserve space inside receive page for skb_shared_info

Pavan Chebbi <pavan.chebbi@broadcom.com>
    bnxt_en: Synchronize tx when xdp redirects happen on same ring

Phil Auld <pauld@redhat.com>
    arch/arm64: Fix topology initialization for core scheduling

Axel Lin <axel.lin@ingics.com>
    regulator: atc260x: Fix missing active_discharge_on setting

Axel Lin <axel.lin@ingics.com>
    regulator: rtq2134: Fix missing active_discharge_on setting

Liu Ying <victor.liu@nxp.com>
    drm/imx: dw_hdmi-imx: Fix bailout in error cases of probe

José Expósito <jose.exposito89@gmail.com>
    drm/imx: Fix memory leak in imx_pd_connector_get_modes

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm/imx: imx-ldb: Check for null pointer after calling kmemdup

Chen-Yu Tsai <wens@csie.org>
    net: stmmac: Fix unset max_speed difference between DT and non-DT platforms

Nikolay Aleksandrov <razor@blackwall.org>
    net: ipv4: fix route with nexthop object delete warning

Matt Johnston <matt@codeconstruct.com.au>
    mctp: Fix check for dev_hard_header() result

Ivan Vecera <ivecera@redhat.com>
    ice: Clear default forwarding VSI during VSI release

Jean-Philippe Brucker <jean-philippe@linaro.org>
    skbuff: fix coalescing for page_pool fragment recycling

Eyal Birger <eyal.birger@gmail.com>
    vrf: fix packet sniffing for traffic originating from ip tunnels

Ziyang Xuan <william.xuanziyang@huawei.com>
    net/tls: fix slab-out-of-bounds bug in decrypt_internal

Taehee Yoo <ap420073@gmail.com>
    net: sfc: add missing xdp queue reinitialization

Jason Wang <jasowang@redhat.com>
    vdpa: mlx5: prevent cvq work from hogging CPU

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Propagate link status from device to vdpa driver

Eli Cohen <elic@nvidia.com>
    vdpa/mlx5: Rename control VQ workqueue to vdpa wq

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()

John Garry <john.garry@huawei.com>
    scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()

Kevin Groeneveld <kgroeneveld@lenbrook.com>
    scsi: sr: Fix typo in CDROM(CLOSETRAY|EJECT) handling

ChenXiaoSong <chenxiaosong2@huawei.com>
    NFSv4: fix open failure with O_ACCMODE flag

ChenXiaoSong <chenxiaosong2@huawei.com>
    Revert "NFSv4: Handle the special Linux file open access mode"

Guilherme G. Piccoli <gpiccoli@igalia.com>
    Drivers: hv: vmbus: Fix potential crash on module unload

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: fix RTC presence check

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: Check return value from mc146818_get_time()

Mateusz Jończyk <mat.jonczyk@o2.pl>
    rtc: mc146818-lib: change return values of mc146818_get_time()

Mauricio Faria de Oliveira <mfo@canonical.com>
    mm: fix race between MADV_FREE reclaim and blkdev direct IO read

John David Anglin <dave.anglin@bell.net>
    parisc: Fix patch code locking and flushing

Helge Deller <deller@gmx.de>
    parisc: Fix CPU affinity for Lasi, WAX and Dino chips

Naresh Kamboju <naresh.kamboju@linaro.org>
    selftests: net: Add tls config dependency for tls selftests

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Avoid writeback threads getting stuck in mempool_alloc()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: nfsiod should not block forever in mempool_alloc()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Fix socket waits for write buffer space

Haimin Zhang <tcs_kernel@tencent.com>
    jfs: prevent NULL deref in diFree

Randy Dunlap <rdunlap@infradead.org>
    virtio_console: eliminate anonymous module_init & module_exit

Jiri Slaby <jirislaby@kernel.org>
    serial: samsung_tty: do not unlock port->lock for uart_write_wakeup()

Nathan Chancellor <nathan@kernel.org>
    x86/Kconfig: Do not allow CONFIG_X86_X32_ABI=y with llvm-objcopy

Peter Zijlstra <peterz@infradead.org>
    x86: Annotate call_on_stack()

NeilBrown <neilb@suse.de>
    NFS: swap-out must always use STABLE writes.

NeilBrown <neilb@suse.de>
    NFS: swap IO handling is slightly different for O_DIRECT IO

NeilBrown <neilb@suse.de>
    SUNRPC: remove scheduling boost for "SWAPPER" tasks.

NeilBrown <neilb@suse.de>
    SUNRPC/xprt: async tasks mustn't block waiting for memory

NeilBrown <neilb@suse.de>
    SUNRPC/call_alloc: async tasks mustn't block waiting for memory

Maxime Ripard <maxime@cerno.tech>
    clk: Enforce that disjoints limits are invalid

Tony Lindgren <tony@atomide.com>
    clk: ti: Preserve node in ti_dt_clocks_register()

Dongli Zhang <dongli.zhang@oracle.com>
    xen: delay xen_hvm_init_time_ops() if kdump is boot on vcpu>=32

Ohad Sharabi <osharabi@habana.ai>
    habanalabs: fix possible memory leak in MMU DR fini

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Protect the state recovery thread against direct reclaim

Xin Xiong <xiongx18@fudan.edu.cn>
    NFSv4.2: fix reference count leaks in _nfs42_proc_copy_notify()

Lucas Denefle <lucas.denefle@converge.io>
    w1: w1_therm: fixes w1_seq for ds28ea00 sensors

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: wfx: fix an error handling in wfx_init_common()

Viresh Kumar <viresh.kumar@linaro.org>
    opp: Expose of-node's name in debugfs

Pierre Gondois <Pierre.Gondois@arm.com>
    cpufreq: CPPC: Fix performance/frequency conversion

Sascha Hauer <s.hauer@pengutronix.de>
    clk: rockchip: drop CLK_SET_RATE_PARENT from dclk_vop* on rk3568

Amjad Ouled-Ameur <aouledameur@baylibre.com>
    phy: amlogic: meson8b-usb2: fix shared reset control use

Amjad Ouled-Ameur <aouledameur@baylibre.com>
    phy: amlogic: meson8b-usb2: Use dev_err_probe()

Amjad Ouled-Ameur <aouledameur@baylibre.com>
    phy: amlogic: phy-meson-gxl-usb2: fix shared reset controller use

Stefan Wahren <stefan.wahren@i2se.com>
    staging: vchiq_core: handle NULL result of find_service_by_handle

Stefan Wahren <stefan.wahren@i2se.com>
    staging: vchiq_arm: Avoid NULL ptr deref in vchiq_dump_platform_instances

Adam Wujek <dev_public@wujek.eu>
    clk: si5341: fix reported clk_rate when output divider is 2

Qinghua Jin <qhjin.dev@gmail.com>
    minix: fix bug when opening a file with O_DIRECT

Randy Dunlap <rdunlap@infradead.org>
    init/main.c: return 1 from handled __setup() functions

Feng Tang <feng.tang@intel.com>
    lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option

Xiubo Li <xiubli@redhat.com>
    ceph: fix memory leak in ceph_readdir when note_last_dentry returns error

Xiubo Li <xiubli@redhat.com>
    ceph: fix inode reference leakage in ceph_get_snapdir()

Wang Yufen <wangyufen@huawei.com>
    netlabel: fix out-of-bounds memory accesses

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: revisit gc autotuning

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix use after free in hci_send_acl

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    MIPS: ingenic: correct unit node address

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix DTC warning unit_address_format

Deren Wu <deren.wu@mediatek.com>
    mt76: fix monitor mode crash with sdio driver

H. Nikolaus Schaller <hns@goldelico.com>
    usb: dwc3: omap: fix "unbalanced disables for smps10_out1" on omap5evm

Michael Walle <michael@walle.cc>
    net: sfp: add 2500base-X quirk for Lantech SFP module

Gal Pressman <gal@nvidia.com>
    net/mlx5e: Remove overzealous validations in netlink EEPROM query

Jakub Kicinski <kuba@kernel.org>
    net: limit altnames to 64k total

Jakub Kicinski <kuba@kernel.org>
    net: account alternate interface name memory

Michael T. Kloos <michael@michaelkloos.com>
    riscv: Fixed misaligned memory access. Fixed pointer comparison.

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: isotp: set default value for N_As to 50 micro seconds

Jianglei Nie <niejianglei2021@163.com>
    scsi: libfc: Fix use after free in fc_exch_abts_resp()

Hangyu Hua <hbh25y@gmail.com>
    powerpc/secvar: fix refcount leak in format_show()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: Tie PPC_BOOK3E_64 to PPC_FSL_BOOK3E

Alexander Lobakin <alobakin@pm.me>
    MIPS: fix fortify panic when copying asm exception handlers

Li Chen <lchen@ambarella.com>
    PCI: endpoint: Fix misused goto label

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Eliminate unintended link toggle during FW reset

Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
    Bluetooth: use memset avoid memory leaks

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}

Harold Huang <baymaxhuang@gmail.com>
    tuntap: add sanity checks about msg_controllen in sendmsg

Sven Eckelmann <sven@narfation.org>
    macvtap: advertise link netns via netlink

Hangyu Hua <hbh25y@gmail.com>
    mips: ralink: fix a refcount leak in ill_acc_of_setup()

Dust Li <dust.li@linux.alibaba.com>
    net/smc: correct settings of RMB window update limit

Xiang Chen <chenxiang66@hisilicon.com>
    scsi: hisi_sas: Limit users changing debugfs BIST count value

Qi Liu <liuqi115@huawei.com>
    scsi: hisi_sas: Free irq vectors in order for v3 HW

Randy Dunlap <rdunlap@infradead.org>
    scsi: aha152x: Fix aha152x_setup() __setup handler return value

Yang Li <yang.lee@linux.alibaba.com>
    mt76: mt7615: Fix assigning negative values to unsigned variable

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s/hash: Make hash faults work in NMI context

Johan Almbladh <johan.almbladh@anyfinetworks.com>
    mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix memory leak in pm8001_chip_fw_flash_update_req()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix tag leaks on error

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix task leak in pm8001_send_abort_all()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix pm8001_mpi_task_abort_resp()

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: pm8001: Fix pm80xx_pci_mem_copy() interface

Alex Williamson <alex.williamson@redhat.com>
    vfio/pci: Stub vfio_pci_vga_rw when !CONFIG_VFIO_PCI_VGA

Alex Deucher <alexander.deucher@amd.com>
    drm/amdkfd: make CRAT table missing message informational only

Mike Snitzer <snitzer@redhat.com>
    dm: requeue IO if mapping table not yet available

Jordy Zomer <jordy@jordyzomer.github.io>
    dm ioctl: prevent potential spectre v1 gadget

Ido Schimmel <idosch@nvidia.com>
    ipv4: Invalidate neighbour for broadcast address upon address addition

Daniel Thompson <daniel.thompson@linaro.org>
    drm/msm/dsi: Remove spurious IRQF_ONESHOT flag

Miri Korenblit <miriam.rachel.korenblit@intel.com>
    iwlwifi: mvm: move only to an enabled channel

Ilan Peer <ilan.peer@intel.com>
    iwlwifi: mvm: Correctly set fragmented EBS

Hans de Goede <hdegoede@redhat.com>
    usb: dwc3: pci: Set the swnode from inside dwc3_pci_quirks()

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Disable TX queues before registering the netdev

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288-charger: Set Vhold to 4.4V

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/set_memory: Avoid spinlock recursion in change_page_attr()

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Fix memory leaks

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpi3mr: Fix reporting of actual data transfer size

Manivannan Sadhasivam <mani@kernel.org>
    PCI: pciehp: Add Qualcomm quirk for Command Completed erratum

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.

Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
    PCI: endpoint: Fix alignment fault error in copy tests

Neal Liu <neal_liu@aspeedtech.com>
    usb: ehci: add pci device support for Aspeed platforms

Zhou Guanghui <zhouguanghui1@huawei.com>
    iommu/arm-smmu-v3: fix event handling soft lockup

Pali Rohár <pali@kernel.org>
    PCI: aardvark: Fix support for MSI interrupts

Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
    scsi: smartpqi: Fix kdump issue when controller is locked up

Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
    drm/amdgpu: Fix recursive locking warning

Sourabh Jain <sourabhjain@linux.ibm.com>
    powerpc: Set crashkernel offset to mid of RMA region

Eric Dumazet <edumazet@google.com>
    net: initialize init_net earlier

Eric Dumazet <edumazet@google.com>
    ipv6: make mc_forwarding atomic

Yonghong Song <yhs@fb.com>
    libbpf: Fix build issue with llvm-readelf

Avraham Stern <avraham.stern@intel.com>
    cfg80211: don't add non transmitted BSS to 6GHz scanned channels

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: dma: initialize skip_unmap in mt76_dma_rx_fill

Ben Greear <greearb@candelatech.com>
    mt76: mt7921: fix crash when startup fails.

Evgeny Boger <boger@wirenboard.com>
    power: supply: axp20x_battery: properly report current when discharging

Yongzhi Liu <lyz_cs@pku.edu.cn>
    drm/v3d: fix missing unlock

Yang Guang <yang.guang5@zte.com.cn>
    scsi: bfa: Replace snprintf() with sysfs_emit()

Yang Guang <yang.guang5@zte.com.cn>
    scsi: mvsas: Replace snprintf() with sysfs_emit()

Jakub Sitnicki <jakub@cloudflare.com>
    bpf: Make dst_port field in struct bpf_sock 16-bit wide

Yongzhi Liu <lyz_cs@pku.edu.cn>
    drm/bridge: Add missing pm_runtime_put_sync

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Send directly when TCP_CORK is cleared

Kalle Valo <quic_kvalo@quicinc.com>
    ath11k: mhi: use mhi_sync_power_up()

Kalle Valo <quic_kvalo@quicinc.com>
    ath11k: pci: fix crash on suspend if board file is not found

Venkateswara Naralasetty <quic_vnaralas@quicinc.com>
    ath11k: fix kernel panic during unload/load ath11k modules

Maxim Kiselev <bigunclemax@gmail.com>
    powerpc: dts: t104xrdb: fix phy type for FMAN 4/5

Philip Yang <Philip.Yang@amd.com>
    drm/amdkfd: Don't take process mutex for svm ioctls

Yang Guang <yang.guang5@zte.com.cn>
    ptp: replace snprintf with sysfs_emit

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix cdnsp_decode_trb function to properly handle ret value

Wayne Chang <waynec@nvidia.com>
    usb: gadget: tegra-xudc: Fix control endpoint's definitions

Wayne Chang <waynec@nvidia.com>
    usb: gadget: tegra-xudc: Do not program SPARAM

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Use PSR version selected during set_psr_caps

Yongzhi Liu <lyz_cs@pku.edu.cn>
    drm/amd/display: Fix memory leak

Xin Xiong <xiongx18@fudan.edu.cn>
    drm/amd/amdgpu/amdgpu_cs: fix refcount leak of a dma_fence obj

Dale Zhao <dale.zhao@amd.com>
    drm/amd/display: Add signal type check when verify stream backends same

Zekun Shen <bruceshenzk@gmail.com>
    ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Anisse Astier <anisse@astier.eu>
    drm: Add orientation quirk for GPD Win Max

Hou Wenlong <houwenlong.hwl@antgroup.com>
    KVM: x86/emulator: Emulate RDPID only if it is enabled in guest

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Fix and isolate TSX-specific performance event logic

Jim Mattson <jmattson@google.com>
    KVM: x86/svm: Clear reserved bits written to PerfEvtSeln MSRs

Peter Gonda <pgonda@google.com>
    KVM: SVM: Fix kvm_cache_regs.h inclusions for is_guest_mode()

Jim Mattson <jmattson@google.com>
    KVM: x86/pmu: Use different raw event masks for AMD and Intel

Marco Elver <elver@google.com>
    kfence: limit currently covered allocations when pool nearly full

Marco Elver <elver@google.com>
    kfence: move saving stack trace of allocations into __kfence_alloc()

Marco Elver <elver@google.com>
    kfence: count unexpectedly skipped allocations

Zhang Wensheng <zhangwensheng5@huawei.com>
    nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

Ye Bin <yebin10@huawei.com>
    nbd: Fix hungtask when nbd_config_put

Ye Bin <yebin10@huawei.com>
    nbd: Fix incorrect error handle when first_minor is illegal in nbd_dev_add

Luis Chamberlain <mcgrof@kernel.org>
    nbd: add error handling support for add_disk()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    rtc: wm8350: Handle error for wm8350_register_irq

Benjamin Beichler <benjamin.beichler@uni-rostock.de>
    um: fix and optimize xor select template for CONFIG64 and timetravel mode

Johannes Berg <johannes.berg@intel.com>
    lib/logic_iomem: correct fallback config references


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/alpha/kernel/rtc.c                            |   7 +-
 arch/arm64/include/asm/cputype.h                   |   2 +
 arch/arm64/kernel/patching.c                       |   4 +-
 arch/arm64/kernel/proton-pack.c                    |   1 +
 arch/arm64/kernel/smp.c                            |   2 +-
 arch/mips/boot/dts/ingenic/jz4780.dtsi             |   2 +-
 arch/mips/include/asm/setup.h                      |   2 +-
 arch/mips/kernel/traps.c                           |  22 +-
 arch/mips/ralink/ill_acc.c                         |   1 +
 arch/parisc/kernel/patch.c                         |  25 +-
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi            |   4 +-
 arch/powerpc/include/asm/interrupt.h               |   2 +-
 arch/powerpc/include/asm/page.h                    |   6 +-
 arch/powerpc/kernel/rtas.c                         |   6 +
 arch/powerpc/kernel/secvar-sysfs.c                 |   9 +-
 arch/powerpc/kexec/core.c                          |  15 +-
 arch/powerpc/kvm/book3s_64_entry.S                 |  10 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |  54 +-
 arch/powerpc/mm/pageattr.c                         |  32 +-
 arch/powerpc/perf/callchain.h                      |   9 +-
 arch/powerpc/perf/callchain_64.c                   |  27 -
 arch/powerpc/platforms/Kconfig.cputype             |   3 +-
 arch/riscv/lib/memmove.S                           | 368 +++++++++++---
 arch/um/include/asm/xor.h                          |   4 +-
 arch/x86/Kconfig                                   |   5 +
 arch/x86/events/intel/core.c                       |   8 +-
 arch/x86/include/asm/bug.h                         |   4 +-
 arch/x86/include/asm/irq_stack.h                   |   3 +-
 arch/x86/include/asm/kvm_host.h                    |   1 +
 arch/x86/include/asm/msi.h                         |  19 +-
 arch/x86/include/asm/perf_event.h                  |   5 +
 arch/x86/kernel/hpet.c                             |   8 +-
 arch/x86/kernel/static_call.c                      |   5 +-
 arch/x86/kvm/emulate.c                             |   4 +-
 arch/x86/kvm/kvm_emulate.h                         |   1 +
 arch/x86/kvm/pmu.c                                 |  18 +-
 arch/x86/kvm/svm/avic.c                            |   7 +-
 arch/x86/kvm/svm/pmu.c                             |   9 +-
 arch/x86/kvm/svm/svm.h                             |   4 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |   1 -
 arch/x86/kvm/vmx/pmu_intel.c                       |  14 +-
 arch/x86/kvm/x86.c                                 |   6 +
 arch/x86/mm/tlb.c                                  |  37 +-
 arch/x86/power/cpu.c                               |  21 +-
 arch/x86/xen/smp_hvm.c                             |   6 +
 arch/x86/xen/time.c                                |  24 +-
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi        |   8 +-
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi         |   8 +-
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi          |   4 +-
 drivers/ata/sata_dwc_460ex.c                       |   6 +-
 drivers/base/power/trace.c                         |   6 +-
 drivers/block/drbd/drbd_int.h                      |   8 +-
 drivers/block/drbd/drbd_nl.c                       |  41 +-
 drivers/block/drbd/drbd_state.c                    |  18 +-
 drivers/block/drbd/drbd_state_change.h             |   8 +-
 drivers/block/nbd.c                                |  40 +-
 drivers/char/virtio_console.c                      |   8 +-
 drivers/clk/clk-si5341.c                           |  16 +-
 drivers/clk/clk.c                                  |  24 +
 drivers/clk/rockchip/clk-rk3568.c                  |   6 +-
 drivers/clk/ti/clk.c                               |  13 +-
 drivers/cpufreq/cppc_cpufreq.c                     |  43 +-
 drivers/dma/sh/shdma-base.c                        |   4 +-
 drivers/gpio/gpiolib.c                             |  19 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c         |   3 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   4 +-
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c           |   4 -
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c              |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c        |  24 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   7 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   6 +
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  |  80 ++-
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c  |   6 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   3 +
 .../gpu/drm/amd/display/dc/dcn21/dcn21_resource.c  |   2 +-
 drivers/gpu/drm/amd/pm/amdgpu_dpm.c                |  11 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c   |   8 +-
 drivers/gpu/drm/bridge/nwl-dsi.c                   |  18 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |   6 +
 drivers/gpu/drm/imx/dw_hdmi-imx.c                  |   8 +-
 drivers/gpu/drm/imx/imx-ldb.c                      |   2 +
 drivers/gpu/drm/imx/parallel-display.c             |   4 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c    |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c    |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c    |   1 +
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h     |   1 +
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c       |   4 +-
 drivers/gpu/drm/v3d/v3d_gem.c                      |   6 +-
 drivers/hv/channel_mgmt.c                          |   6 +-
 drivers/hv/vmbus_drv.c                             |   9 +-
 drivers/infiniband/core/cm.c                       |   3 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                |   6 +
 drivers/infiniband/hw/mlx5/mr.c                    |   5 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |   1 +
 drivers/iommu/omap-iommu.c                         |   2 +-
 drivers/irqchip/irq-gic-v3-its.c                   |  28 +-
 drivers/irqchip/irq-gic-v3.c                       |  14 +-
 drivers/irqchip/irq-gic.c                          |   6 +
 drivers/md/dm-ioctl.c                              |   2 +
 drivers/md/dm-rq.c                                 |   7 +-
 drivers/md/dm.c                                    |  11 +-
 drivers/misc/habanalabs/common/mmu/mmu_v1.c        |   2 +-
 drivers/mmc/core/block.c                           |  46 +-
 drivers/mmc/host/mmci_stm32_sdmmc.c                |   6 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   4 +-
 drivers/mmc/host/sdhci-xenon.c                     |  10 -
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |   3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   7 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |  14 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h      |   2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   4 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   6 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  23 -
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   2 -
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   3 +
 drivers/net/ethernet/sfc/efx_channels.c            | 148 +++---
 drivers/net/ethernet/sfc/rx_common.c               |   3 +
 drivers/net/ethernet/sfc/tx.c                      |   3 +
 drivers/net/ethernet/sfc/tx_common.c               |   2 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   3 +-
 drivers/net/macvtap.c                              |   6 +
 drivers/net/mdio/mdio-mscc-miim.c                  |   6 +
 drivers/net/phy/sfp-bus.c                          |   6 +
 drivers/net/tap.c                                  |   3 +-
 drivers/net/tun.c                                  |   3 +-
 drivers/net/vrf.c                                  |  15 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   2 +
 drivers/net/wireless/ath/ath11k/mhi.c              |   2 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  10 +
 drivers/net/wireless/ath/ath5k/eeprom.c            |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   5 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   1 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   1 +
 drivers/opp/debugfs.c                              |   5 +
 drivers/opp/opp.h                                  |   1 +
 drivers/parisc/dino.c                              |  41 +-
 drivers/parisc/gsc.c                               |  31 ++
 drivers/parisc/gsc.h                               |   1 +
 drivers/parisc/lasi.c                              |   7 +-
 drivers/parisc/wax.c                               |   7 +-
 drivers/pci/controller/pci-aardvark.c              |  16 +-
 drivers/pci/endpoint/functions/pci-epf-test.c      |  14 +-
 drivers/pci/hotplug/pciehp_hpc.c                   |   2 +
 drivers/perf/qcom_l2_pmu.c                         |   6 +-
 drivers/phy/amlogic/phy-meson-gxl-usb2.c           |   5 +-
 drivers/phy/amlogic/phy-meson8b-usb2.c             |   9 +-
 drivers/power/supply/axp20x_battery.c              |  13 +-
 drivers/power/supply/axp288_charger.c              |  14 +-
 drivers/ptp/ptp_sysfs.c                            |   4 +-
 drivers/regulator/atc260x-regulator.c              |   1 +
 drivers/regulator/rtq2134-regulator.c              |   1 +
 drivers/rtc/rtc-cmos.c                             |  19 +-
 drivers/rtc/rtc-mc146818-lib.c                     |  42 +-
 drivers/rtc/rtc-wm8350.c                           |  11 +-
 drivers/scsi/aha152x.c                             |   6 +-
 drivers/scsi/bfa/bfad_attr.c                       |  26 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  68 ++-
 drivers/scsi/libfc/fc_exch.c                       |   1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                    |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                    |   2 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   5 +-
 drivers/scsi/mvsas/mv_init.c                       |   4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  27 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  17 +-
 drivers/scsi/scsi_scan.c                           |   5 +
 drivers/scsi/smartpqi/smartpqi_init.c              |  39 +-
 drivers/scsi/sr.c                                  |   2 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |  17 +
 drivers/scsi/ufs/ufshpb.c                          |  11 +-
 drivers/scsi/zorro7xx.c                            |   2 +
 drivers/spi/spi-bcm-qspi.c                         |   4 +-
 drivers/spi/spi.c                                  |   4 +
 .../vc04_services/interface/vchiq_arm/vchiq_arm.c  |   3 +
 .../vc04_services/interface/vchiq_arm/vchiq_core.c |   6 +
 drivers/staging/wfx/main.c                         |   7 +-
 drivers/tty/serial/samsung_tty.c                   |   5 +-
 drivers/usb/cdns3/cdnsp-debug.h                    | 305 ++++++------
 drivers/usb/dwc3/dwc3-omap.c                       |   2 +-
 drivers/usb/dwc3/dwc3-pci.c                        |  11 +-
 drivers/usb/gadget/udc/tegra-xudc.c                |  20 +-
 drivers/usb/host/ehci-pci.c                        |   9 +
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  | 121 ++++-
 drivers/vfio/pci/vfio_pci_rdwr.c                   |   2 +
 drivers/vhost/net.c                                |   1 +
 drivers/video/fbdev/core/fbmem.c                   |   9 +-
 drivers/w1/slaves/w1_therm.c                       |   8 +-
 fs/btrfs/extent_io.h                               |   2 +-
 fs/btrfs/inode.c                                   |  22 +
 fs/ceph/dir.c                                      |  11 +-
 fs/ceph/inode.c                                    |  10 +-
 fs/io_uring.c                                      |  79 +--
 fs/jfs/inode.c                                     |   3 +-
 fs/minix/inode.c                                   |   3 +-
 fs/nfs/dir.c                                       |  10 -
 fs/nfs/direct.c                                    |  48 +-
 fs/nfs/file.c                                      |   4 +-
 fs/nfs/inode.c                                     |   1 -
 fs/nfs/internal.h                                  |  17 +
 fs/nfs/nfs42proc.c                                 |   9 +-
 fs/nfs/nfs4file.c                                  |   6 +-
 fs/nfs/nfs4state.c                                 |  12 +
 fs/nfs/pagelist.c                                  |  10 +-
 fs/nfs/pnfs_nfs.c                                  |   8 +-
 fs/nfs/write.c                                     |  34 +-
 include/linux/gpio/driver.h                        |   9 +
 include/linux/ipv6.h                               |   2 +-
 include/linux/mc146818rtc.h                        |   3 +-
 include/linux/mmzone.h                             |  11 +-
 include/linux/nfs_fs.h                             |  10 +-
 include/linux/stackdepot.h                         |   2 -
 include/linux/stacktrace.h                         |   1 +
 include/linux/static_call.h                        |   5 +-
 include/linux/sunrpc/xprtsock.h                    |   1 +
 include/linux/vfio_pci_core.h                      |   9 +
 include/net/arp.h                                  |   1 +
 include/net/bluetooth/bluetooth.h                  |  14 +-
 include/net/net_namespace.h                        |   6 +
 include/uapi/linux/bpf.h                           |   6 +-
 include/uapi/linux/can/isotp.h                     |  28 +-
 init/main.c                                        |   8 +-
 kernel/Makefile                                    |   3 +-
 kernel/events/core.c                               |   3 +
 kernel/sched/core.c                                |   2 +-
 kernel/stacktrace.c                                |  30 ++
 kernel/static_call.c                               | 542 +-------------------
 kernel/static_call_inline.c                        | 543 +++++++++++++++++++++
 lib/Kconfig.debug                                  |   3 +-
 lib/Kconfig.ubsan                                  |  13 -
 lib/logic_iomem.c                                  |   8 +-
 lib/lz4/lz4_decompress.c                           |   8 +-
 lib/stackdepot.c                                   |  24 -
 lib/test_ubsan.c                                   |  22 -
 mm/highmem.c                                       |   4 +-
 mm/kfence/core.c                                   | 156 +++++-
 mm/kfence/kfence.h                                 |   2 +
 mm/memory.c                                        |  25 +-
 mm/mempolicy.c                                     |   1 +
 mm/mremap.c                                        |   3 +
 mm/rmap.c                                          |  25 +-
 net/batman-adv/multicast.c                         |   2 +-
 net/bluetooth/hci_event.c                          |   3 +-
 net/bluetooth/l2cap_core.c                         |   1 +
 net/bpf/test_run.c                                 |   4 +-
 net/can/isotp.c                                    |  12 +-
 net/core/dev.c                                     |   3 +-
 net/core/filter.c                                  |  30 +-
 net/core/net_namespace.c                           |  17 +-
 net/core/rtnetlink.c                               |  13 +-
 net/core/skbuff.c                                  |  15 +-
 net/ipv4/arp.c                                     |   9 +-
 net/ipv4/fib_frontend.c                            |   5 +-
 net/ipv4/fib_semantics.c                           |   7 +-
 net/ipv4/inet_hashtables.c                         |  53 +-
 net/ipv6/addrconf.c                                |   4 +-
 net/ipv6/inet6_hashtables.c                        |   5 +-
 net/ipv6/ip6_input.c                               |   2 +-
 net/ipv6/ip6mr.c                                   |   8 +-
 net/ipv6/route.c                                   |   2 +-
 net/mctp/route.c                                   |   2 +-
 net/netfilter/nf_conntrack_core.c                  |  85 +++-
 net/netlabel/netlabel_kapi.c                       |   2 +
 net/openvswitch/actions.c                          |   2 +-
 net/openvswitch/flow_netlink.c                     |  99 +++-
 net/rxrpc/net_ns.c                                 |   2 +-
 net/sctp/outqueue.c                                |   6 +-
 net/smc/af_smc.c                                   |   8 +-
 net/smc/smc_core.c                                 |   2 +-
 net/smc/smc_tx.c                                   |  25 +-
 net/smc/smc_tx.h                                   |   1 +
 net/sunrpc/clnt.c                                  |   7 +
 net/sunrpc/sched.c                                 |  11 +-
 net/sunrpc/svcsock.c                               |   4 +-
 net/sunrpc/xprt.c                                  |  19 +-
 net/sunrpc/xprtrdma/transport.c                    |   6 +-
 net/sunrpc/xprtsock.c                              |  73 ++-
 net/tls/tls_sw.c                                   |   2 +-
 net/wireless/scan.c                                |   9 +-
 scripts/Makefile.ubsan                             |   1 -
 tools/build/feature/Makefile                       |   9 +-
 tools/lib/bpf/Makefile                             |   4 +-
 tools/perf/Makefile.config                         |   6 +
 tools/perf/arch/arm64/util/arm-spe.c               |   6 +
 tools/perf/perf.c                                  |   2 +-
 tools/perf/util/session.c                          |  15 +-
 tools/perf/util/setup.py                           |   8 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |   3 +-
 tools/testing/selftests/cgroup/cgroup_util.c       |   2 +-
 tools/testing/selftests/cgroup/test_core.c         | 165 +++++++
 virt/kvm/kvm_main.c                                |   2 +-
 310 files changed, 3565 insertions(+), 1909 deletions(-)


