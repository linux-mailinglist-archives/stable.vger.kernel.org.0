Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37BCEEEA9
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389598AbfKDWEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388947AbfKDWEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:15 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23B112084D;
        Mon,  4 Nov 2019 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905053;
        bh=HpqTcu7F9eUdO70VgkACFNSOT4dWhIUsQhOC3J/JIjs=;
        h=From:To:Cc:Subject:Date:From;
        b=CWgBdWwNIYPrJhHwMwv0GUas51AxuaQT5B/q521XmBgCBI0sd1Kq1fGzABZ6bZuA/
         UipBb+h9dBYTCoJnawHTD7XLj2flutYrY89n13Et8Q6sSU9Ptkjj1riO/j/e8Q4sSb
         hU997K3ITqX5g8k6l9mYxGxdQ0LEgH8cPzeaMous=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.3 000/163] 5.3.9-stable review
Date:   Mon,  4 Nov 2019 22:43:10 +0100
Message-Id: <20191104212140.046021995@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.3.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.3.9-rc1
X-KernelTest-Deadline: 2019-11-06T21:21+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.3.9 release.
There are 163 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 06 Nov 2019 09:14:04 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.3.9-rc1

Qian Cai <cai@lca.pw>
    sched/fair: Fix -Wunused-but-set-variable warnings

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Use irq xarray locking for mkey_table

Justin Song <flyingecar@gmail.com>
    ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB Interface

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: Update DSD support quirks for Oppo and Rotel

Jussi Laako <jussi@sonarnerd.net>
    ALSA: usb-audio: DSD auto-detection for Playback Designs

Dave Chiluk <chiluk+linux@indeed.com>
    sched/fair: Fix low cpu usage with high throttling by removing expiration of cpu-local slices

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: exclude GEO SAR support for 3168

Vlad Buslov <vladbu@mellanox.com>
    net: sched: sch_sfb: don't call qdisc_put() while holding tree lock

Eric Dumazet <edumazet@google.com>
    sch_netem: fix rcu splat in netem_enqueue()

Valentin Vidic <vvidic@valentin-vidic.from.hr>
    net: usb: sr9800: fix uninitialized local variable

Eric Dumazet <edumazet@google.com>
    netfilter: conntrack: avoid possible false sharing

Eric Dumazet <edumazet@google.com>
    bonding: fix potential NULL deref in bond_update_slave_arr

Johan Hovold <johan@kernel.org>
    NFC: pn533: fix use-after-free and memleaks

David Howells <dhowells@redhat.com>
    rxrpc: Fix trace-after-put looking at the put peer record

David Howells <dhowells@redhat.com>
    rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record

David Howells <dhowells@redhat.com>
    rxrpc: Fix call ref leak

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff leak in llc_conn_service()

Eric Biggers <ebiggers@google.com>
    llc: fix sk_buff leak in llc_sap_state_process()

Sven Eckelmann <sven@narfation.org>
    batman-adv: Avoid free/alloc race when handling OGM buffer

John Donnelly <John.P.Donnelly@Oracle.com>
    iommu/vt-d: Fix panic after kexec -p for kdump

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure we clear io_kiocb->result before each issue

Trond Myklebust <trondmy@gmail.com>
    NFS: Fix an RCU lock leak in nfs4_refresh_delegation_stateid()

chen gong <curry.gong@amd.com>
    drm/amdgpu: Fix SDMA hang when performing VKexample test

Pelle van Gils <pelle@vangils.xyz>
    drm/amdgpu/powerplay/vega10: allow undervolting in p7

Tianci.Yin <tianci.yin@amd.com>
    drm/amdgpu/gfx10: update gfx golden settings

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix PCH reference clock for FDI on HSW/BDW

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc10: properly set BANK_SELECT and FRAGMENT_SIZE

Tony Lindgren <tony@atomide.com>
    dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Robin Gong <yibin.gong@nxp.com>
    dmaengine: imx-sdma: fix size check for sdma script_number

Sameer Pujar <spujar@nvidia.com>
    dmaengine: tegra210-adma: fix transfer failure

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    dmaengine: qcom: bam_dma: Fix resource leak

Paolo Bonzini <pbonzini@redhat.com>
    KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active

Laura Abbott <labbott@redhat.com>
    rtlwifi: Fix potential overflow on P2P code

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl_pci: Fix problem of too small skb->len

Marvin Liu <yong.liu@intel.com>
    virtio_ring: fix stalls for packed rings

Bjorn Andersson <bjorn.andersson@linaro.org>
    arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata 1003

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Avoid excessive retry for TID RDMA READ request

Alexey Brodkin <Alexey.Brodkin@synopsys.com>
    ARC: perf: Accommodate big-endian CPU

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/idle: fix cpu idle time calculation

Yihui ZENG <yzeng56@asu.edu>
    s390/cmm: fix information leak in cmm_timeout_handler()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/unwind: fix mixing regs and sp

Anton Ivanov <anton.ivanov@cambridgegreys.com>
    um-ubd: Entrust re-queue to the upper layers

Andrey Smirnov <andrew.smirnov@gmail.com>
    HID: logitech-hidpp: do all FF cleanup in hidpp_ff_destroy()

Andrey Smirnov <andrew.smirnov@gmail.com>
    HID: logitech-hidpp: rework device validation

Andrey Smirnov <andrew.smirnov@gmail.com>
    HID: logitech-hidpp: split g920_get_config()

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    HID: fix error message in hid_open_report()

Alan Stern <stern@rowland.harvard.edu>
    HID: Fix assumption that devices have inputs

Hans de Goede <hdegoede@redhat.com>
    HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Bart Van Assche <bvanassche@acm.org>
    scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Quinn Tran <qutran@marvell.com>
    scsi: qla2xxx: Fix partial flash write of MBI

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix use-after-free regression in xhci clear hub TT implementation

Johan Hovold <johan@kernel.org>
    USB: serial: whiteheat: fix line-speed endianness

Johan Hovold <johan@kernel.org>
    USB: serial: whiteheat: fix potential slab corruption

Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
    usb: xhci: fix __le32/__le64 accessors in debugfs code

Samuel Holland <samuel@sholland.org>
    usb: xhci: fix Immediate Data Transfer endianness

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix control-message timeout

Johan Hovold <johan@kernel.org>
    USB: ldusb: fix ring-buffer locking

Alan Stern <stern@rowland.harvard.edu>
    usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_boundary_mask to avoid SG overflows")

Alan Stern <stern@rowland.harvard.edu>
    USB: gadget: Reject endpoints with 0 maxpacket value

Markus Theil <markus.theil@tu-ilmenau.de>
    nl80211: fix validation of mesh path nexthop

Alan Stern <stern@rowland.harvard.edu>
    UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gather segments")

Miaoqing Pan <miaoqing@codeaurora.org>
    ath10k: fix latency issue for QCA988x

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add support for ALC623

Aaron Ma <aaron.ma@canonical.com>
    ALSA: hda/realtek - Fix 2 front mics of codec 0x623

Takashi Iwai <tiwai@suse.de>
    ALSA: timer: Fix mutex deadlock at releasing card

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: Fix prototype of helper function to return negative value

Miklos Szeredi <mszeredi@redhat.com>
    fuse: truncate pending writes on O_TRUNC

Miklos Szeredi <mszeredi@redhat.com>
    fuse: flush dirty data/metadata before non-truncate setattr

Hui Peng <benquike@gmail.com>
    ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Use 32-bit writes when writing ring producer/consumer

Mika Westerberg <mika.westerberg@linux.intel.com>
    thunderbolt: Correct path indices for PCIe tunnel

Sebastian Ott <sebott@linux.ibm.com>
    s390/pci: fix MSI message data

Joe Perches <joe@perches.com>
    rtw88: Fix misuse of GENMASK macro

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    arm64: dts: qcom: Add Asus NovaGo TP370QL

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    arm64: dts: qcom: Add HP Envy x2

Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
    arm64: dts: qcom: Add Lenovo Miix 630

Mike Christie <mchristi@redhat.com>
    nbd: verify socket is supported during setup

Dan Carpenter <dan.carpenter@oracle.com>
    USB: legousbtower: fix a signedness bug in tower_probe()

Thomas Richter <tmricht@linux.ibm.com>
    perf/aux: Fix tracking of auxiliary trace buffer allocation

Gustavo A. R. Silva <gustavo@embeddedor.com>
    perf annotate: Fix multiple memory and file descriptor leaks

Petr Mladek <pmladek@suse.com>
    tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/uaccess: avoid (false positive) compiler warnings

Benjamin Coddington <bcodding@redhat.com>
    SUNRPC: fix race to sk_err after xs_error_report

Chuck Lever <chuck.lever@oracle.com>
    NFSv4: Fix leak of clp->cl_acceptor string

Xiubo Li <xiubli@redhat.com>
    nbd: fix possible sysfs duplicate warning

Navid Emamdoost <navid.emamdoost@gmail.com>
    virt: vbox: fix memory leak in hgcm_call_preprocess_linaddr

Halil Pasic <pasic@linux.ibm.com>
    s390/cio: fix virtio-ccw DMA without PV

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: fw: sni: Fix out of bounds init of o32 stack

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: include: Mark __xchg as __always_inline

Lorenzo Bianconi <lorenzo@kernel.org>
    iio: imu: st_lsm6dsx: fix waitime for st_lsm6dsx i2c controller

Navid Emamdoost <navid.emamdoost@gmail.com>
    iio: imu: adis16400: fix memory leak

Navid Emamdoost <navid.emamdoost@gmail.com>
    iio: imu: adis16400: release allocated memory on failure

Nirmoy Das <nirmoy.das@amd.com>
    drm/amdgpu: fix memory leak

Tom Lendacky <thomas.lendacky@amd.com>
    perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp

Song Liu <songliubraving@fb.com>
    perf/core: Fix corner case in perf_rotate_context()

Song Liu <songliubraving@fb.com>
    perf/core: Rework memory accounting in perf_mmap()

Frederic Weisbecker <frederic@kernel.org>
    sched/vtime: Fix guest/system mis-accounting on task switch

Xuewei Zhang <xueweiz@google.com>
    sched/fair: Scale bandwidth quota and period without losing quota/period ratio precision

Kan Liang <kan.liang@linux.intel.com>
    x86/cpu: Add Comet Lake to the Intel CPU models header

Yunfeng Ye <yeyunfeng@huawei.com>
    arm64: armv8_deprecated: Checking return value for memory allocation

Austin Kim <austindh.kim@gmail.com>
    btrfs: silence maybe-uninitialized warning in clone_range

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan_inode_alloc()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end_nolock()

Jia-Ju Bai <baijiaju1990@gmail.com>
    fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare_entry()

Jia Guo <guojia12@huawei.com>
    ocfs2: clear zero in unaligned direct IO

Boris Ostrovsky <boris.ostrovsky@oracle.com>
    x86/xen: Return from panic notifier

Vincent Chen <vincent.chen@sifive.com>
    riscv: Correct the handling of unexpected ebreak in do_trap_break()

Vincent Chen <vincent.chen@sifive.com>
    riscv: avoid sending a SIGTRAP to a user thread trapped in WARN()

Vincent Chen <vincent.chen@sifive.com>
    riscv: avoid kernel hangs when trapped in BUG()

Thomas Bogendoerfer <tbogendoerfer@suse.de>
    MIPS: include: Mark __cmpxchg as __always_inline

Dave Young <dyoung@redhat.com>
    efi/x86: Do not clean dummy variable in kexec path

Lukas Wunner <lukas@wunner.de>
    efi/cper: Fix endianness of PCIe class code

Will Deacon <will@kernel.org>
    arm64: vdso32: Don't use KBUILD_CPPFLAGS unconditionally

Will Deacon <will@kernel.org>
    arm64: Default to building compat vDSO with clang when CONFIG_CC_IS_CLANG

Adam Ford <aford173@gmail.com>
    serial: 8250_omap: Fix gpio check for auto RTS/CTS

Adam Ford <aford173@gmail.com>
    serial: mctrl_gpio: Check for NULL pointer

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: vdso32: Detect binutils support for dmb ishld

Vincenzo Frascino <vincenzo.frascino@arm.com>
    arm64: vdso32: Fix broken compat vDSO build warnings

Austin Kim <austindh.kim@gmail.com>
    fs: cifs: mute -Wunused-const-variable message

Thierry Reding <treding@nvidia.com>
    gpio: max77620: Use correct unit for debounce times

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Add missing synchronize_srcu() for MW cases

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Order num_pending_prefetch properly with synchronize_srcu

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Do not allow rereg of a ODP MR

Leon Romanovsky <leon@kernel.org>
    RDMA/nldev: Reshuffle the code to avoid need to rebind QP in error path

Jack Morgenstein <jackm@dev.mellanox.co.il>
    RDMA/cm: Fix memory leak in cm_add/remove_one

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    RDMA/core: Fix an error handling path in 'res_get_common_doit()'

Navid Emamdoost <navid.emamdoost@gmail.com>
    misc: fastrpc: prevent memory leak in fastrpc_dma_buf_attach

Randy Dunlap <rdunlap@infradead.org>
    tty: n_hdlc: fix build on SPARC

Christoph Hellwig <hch@lst.de>
    serial/sifive: select SERIAL_EARLYCON

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: rda: Fix the link time qualifier of 'rda_uart_exit()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'

James Morse <james.morse@arm.com>
    arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1542419

James Morse <james.morse@arm.com>
    arm64: Fix incorrect irqflag restore for priority masking for compat

Julien Grall <julien.grall@arm.com>
    arm64: cpufeature: Effectively expose FRINT capability to userspace

ZhangXiaoxu <zhangxiaoxu5@huawei.com>
    nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request

Kees Cook <keescook@chromium.org>
    selftests/kselftest/runner.sh: Add 45 second timeout per test

Cristian Marussi <cristian.marussi@arm.com>
    kselftest: exclude failed TARGETS from runlist

Dexuan Cui <decui@microsoft.com>
    HID: hyperv: Use in-place iterator API in the channel callback

Bart Van Assche <bvanassche@acm.org>
    RDMA/iwcm: Fix a lock inversion issue

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/iw_cxgb4: fix SRQ access from dump_qp()

Navid Emamdoost <navid.emamdoost@gmail.com>
    RDMA/hfi1: Prevent memory leak in sdma_init

Krishnamraju Eraparaju <krishna2@chelsio.com>
    RDMA/siw: Fix serialization issue in write_space()

Connor Kuehl <connor.kuehl@canonical.com>
    staging: rtl8188eu: fix null dereference when kzalloc fails

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Don't return -1 for error when doing BPF disassembly

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Return appropriate error code for allocation failures

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Fix arch specific ->init() failure errors

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Propagate the symbol__annotate() error return

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Fix the signedness of failure returns

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf annotate: Propagate perf_env__arch() error

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf tools: Propagate get_cpuid() error

Andi Kleen <ak@linux.intel.com>
    perf jevents: Fix period for Intel fixed counters

Andi Kleen <ak@linux.intel.com>
    perf script brstackinsn: Fix recovery from LBR/binary mismatch

Steve MacLean <Steve.MacLean@microsoft.com>
    perf map: Fix overlapped map handling

Ian Rogers <irogers@google.com>
    perf tests: Avoid raising SEGV using an obvious NULL dereference

Ian Rogers <irogers@google.com>
    libsubcmd: Make _FORTIFY_SOURCE defines dependent on the feature

Pascal Bouwmann <bouwmann@tau-tec.de>
    iio: fix center temperature of bmc150-accel-core

Remi Pommarel <repk@triplefau.lt>
    iio: adc: meson_saradc: Fix memory allocation order

Qu Wenruo <wqu@suse.com>
    btrfs: qgroup: Always free PREALLOC META reserve in btrfs_delalloc_release_extents()

Filipe Manana <fdmanana@suse.com>
    Btrfs: fix inode cache block reserve leak on failure to allocate data space

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: rework COW throttling to fix deadlock

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: introduce account_start_copy() and account_end_copy()

Jens Axboe <axboe@kernel.dk>
    io_uring: fix up O_NONBLOCK handling for sockets


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |   4 +
 Documentation/scheduler/sched-bwc.rst              |  74 ++++--
 Makefile                                           |   4 +-
 arch/arc/kernel/perf_event.c                       |   4 +-
 arch/arm64/Kconfig                                 |   2 +-
 arch/arm64/Makefile                                |  22 +-
 arch/arm64/boot/dts/qcom/Makefile                  |   3 +
 .../boot/dts/qcom/msm8998-asus-novago-tp370ql.dts  |  47 ++++
 arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi    | 240 ++++++++++++++++++++
 arch/arm64/boot/dts/qcom/msm8998-hp-envy-x2.dts    |  30 +++
 .../boot/dts/qcom/msm8998-lenovo-miix-630.dts      |  30 +++
 arch/arm64/include/asm/pgtable-prot.h              |  15 +-
 arch/arm64/include/asm/vdso/compat_barrier.h       |   2 +-
 arch/arm64/kernel/armv8_deprecated.c               |   5 +
 arch/arm64/kernel/cpu_errata.c                     |   1 +
 arch/arm64/kernel/cpufeature.c                     |   1 +
 arch/arm64/kernel/entry.S                          |   1 +
 arch/arm64/kernel/ftrace.c                         |  12 +-
 arch/arm64/kernel/vdso32/Makefile                  |  17 +-
 arch/mips/fw/sni/sniprom.c                         |   2 +-
 arch/mips/include/asm/cmpxchg.h                    |   9 +-
 arch/riscv/kernel/traps.c                          |  14 +-
 arch/s390/include/asm/uaccess.h                    |   4 +-
 arch/s390/include/asm/unwind.h                     |   1 +
 arch/s390/kernel/idle.c                            |  29 ++-
 arch/s390/kernel/unwind_bc.c                       |  18 +-
 arch/s390/mm/cmm.c                                 |  12 +-
 arch/s390/pci/pci_irq.c                            |   2 +-
 arch/um/drivers/ubd_kern.c                         |   8 +-
 arch/x86/events/amd/core.c                         |  30 +--
 arch/x86/include/asm/intel-family.h                |   3 +
 arch/x86/kvm/svm.c                                 |  10 +-
 arch/x86/kvm/vmx/vmx.c                             |  14 +-
 arch/x86/platform/efi/efi.c                        |   3 -
 arch/x86/xen/enlighten.c                           |  28 ++-
 drivers/block/nbd.c                                |  25 ++-
 drivers/dma/imx-sdma.c                             |   8 +
 drivers/dma/qcom/bam_dma.c                         |  19 ++
 drivers/dma/tegra210-adma.c                        |   7 +
 drivers/dma/ti/cppi41.c                            |  21 +-
 drivers/firmware/efi/cper.c                        |   2 +-
 drivers/gpio/gpio-max77620.c                       |   6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |  14 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c           |   9 +
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c            |   9 +
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c             |   1 +
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c |   4 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  11 +-
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c      |  15 ++
 drivers/gpu/drm/i915/i915_drv.h                    |   2 +
 drivers/hid/hid-axff.c                             |  11 +-
 drivers/hid/hid-core.c                             |   7 +-
 drivers/hid/hid-dr.c                               |  12 +-
 drivers/hid/hid-emsff.c                            |  12 +-
 drivers/hid/hid-gaff.c                             |  12 +-
 drivers/hid/hid-holtekff.c                         |  12 +-
 drivers/hid/hid-hyperv.c                           |  56 +----
 drivers/hid/hid-lg2ff.c                            |  12 +-
 drivers/hid/hid-lg3ff.c                            |  11 +-
 drivers/hid/hid-lg4ff.c                            |  11 +-
 drivers/hid/hid-lgff.c                             |  11 +-
 drivers/hid/hid-logitech-hidpp.c                   | 248 ++++++++++++---------
 drivers/hid/hid-microsoft.c                        |  12 +-
 drivers/hid/hid-sony.c                             |  12 +-
 drivers/hid/hid-tmff.c                             |  12 +-
 drivers/hid/hid-zpff.c                             |  12 +-
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |  19 ++
 drivers/iio/accel/bmc150-accel-core.c              |   2 +-
 drivers/iio/adc/meson_saradc.c                     |  10 +-
 drivers/iio/imu/adis_buffer.c                      |  10 +-
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c       |   4 +-
 drivers/infiniband/core/cm.c                       |   3 +
 drivers/infiniband/core/cma.c                      |   3 +-
 drivers/infiniband/core/nldev.c                    |  12 +-
 drivers/infiniband/hw/cxgb4/device.c               |   7 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  10 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |   5 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c              |   5 -
 drivers/infiniband/hw/mlx5/devx.c                  |  58 ++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   1 -
 drivers/infiniband/hw/mlx5/mr.c                    |  32 ++-
 drivers/infiniband/sw/siw/siw_qp.c                 |  15 +-
 drivers/iommu/intel-iommu.c                        |   2 +-
 drivers/md/dm-snap.c                               |  94 ++++++--
 drivers/misc/fastrpc.c                             |   1 +
 drivers/net/bonding/bond_main.c                    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |   8 +-
 drivers/net/usb/sr9800.c                           |   2 +-
 drivers/net/wireless/ath/ath10k/core.c             |  15 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   8 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  16 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   3 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   6 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   2 +-
 drivers/nfc/pn533/usb.c                            |   9 +-
 drivers/s390/cio/cio.h                             |   1 +
 drivers/s390/cio/css.c                             |   7 +-
 drivers/s390/cio/device.c                          |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   7 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   6 +-
 drivers/target/iscsi/cxgbit/cxgbit_cm.c            |   3 +-
 drivers/thunderbolt/nhi.c                          |  22 +-
 drivers/thunderbolt/tunnel.c                       |   4 +-
 drivers/tty/n_hdlc.c                               |   5 +
 drivers/tty/serial/8250/8250_omap.c                |   5 +-
 drivers/tty/serial/Kconfig                         |   1 +
 drivers/tty/serial/owl-uart.c                      |   2 +-
 drivers/tty/serial/rda-uart.c                      |   2 +-
 drivers/tty/serial/serial_mctrl_gpio.c             |   3 +
 drivers/usb/gadget/udc/core.c                      |  11 +
 drivers/usb/host/xhci-debugfs.c                    |  24 +-
 drivers/usb/host/xhci-ring.c                       |   2 +
 drivers/usb/host/xhci.c                            |  54 ++++-
 drivers/usb/misc/ldusb.c                           |   6 +-
 drivers/usb/misc/legousbtower.c                    |   2 +-
 drivers/usb/serial/whiteheat.c                     |  13 +-
 drivers/usb/serial/whiteheat.h                     |   2 +-
 drivers/usb/storage/scsiglue.c                     |  10 -
 drivers/usb/storage/uas.c                          |  20 --
 drivers/virt/vboxguest/vboxguest_utils.c           |   3 +-
 drivers/virtio/virtio_ring.c                       |   7 +-
 fs/btrfs/ctree.h                                   |   3 +-
 fs/btrfs/delalloc-space.c                          |   6 +-
 fs/btrfs/file.c                                    |   7 +-
 fs/btrfs/inode-map.c                               |   5 +-
 fs/btrfs/inode.c                                   |  12 +-
 fs/btrfs/ioctl.c                                   |   6 +-
 fs/btrfs/relocation.c                              |   9 +-
 fs/btrfs/send.c                                    |   2 +-
 fs/cifs/netmisc.c                                  |   4 -
 fs/fuse/dir.c                                      |  13 ++
 fs/fuse/file.c                                     |  10 +-
 fs/io_uring.c                                      |  58 +++--
 fs/nfs/delegation.c                                |   2 +-
 fs/nfs/nfs4proc.c                                  |   1 +
 fs/nfs/write.c                                     |   5 +-
 fs/ocfs2/aops.c                                    |  25 ++-
 fs/ocfs2/ioctl.c                                   |   2 +-
 fs/ocfs2/xattr.c                                   |  56 ++---
 include/linux/platform_data/dma-imx-sdma.h         |   3 +
 include/linux/sunrpc/xprtsock.h                    |   1 +
 include/net/llc_conn.h                             |   2 +-
 include/net/sch_generic.h                          |   5 +
 include/trace/events/rxrpc.h                       |   6 +-
 kernel/events/core.c                               |  45 +++-
 kernel/sched/cputime.c                             |   6 +-
 kernel/sched/fair.c                                | 127 +++--------
 kernel/sched/sched.h                               |   4 -
 kernel/trace/trace.c                               |   1 +
 net/batman-adv/bat_iv_ogm.c                        |  61 ++++-
 net/batman-adv/hard-interface.c                    |   2 +
 net/batman-adv/types.h                             |   3 +
 net/llc/llc_c_ac.c                                 |   8 +-
 net/llc/llc_conn.c                                 |  32 +--
 net/llc/llc_s_ac.c                                 |  12 +-
 net/llc/llc_sap.c                                  |  23 +-
 net/netfilter/nf_conntrack_core.c                  |   4 +-
 net/rxrpc/peer_object.c                            |  16 +-
 net/rxrpc/sendmsg.c                                |   1 +
 net/sched/sch_netem.c                              |   2 +-
 net/sched/sch_sfb.c                                |   7 +-
 net/sunrpc/xprtsock.c                              |  17 +-
 net/wireless/nl80211.c                             |   2 +-
 sound/core/timer.c                                 |  24 +-
 sound/firewire/bebob/bebob_stream.c                |   3 +-
 sound/pci/hda/patch_realtek.c                      |  11 +
 sound/usb/quirks.c                                 |  13 +-
 tools/lib/subcmd/Makefile                          |   8 +-
 tools/perf/arch/arm/annotate/instructions.c        |   4 +-
 tools/perf/arch/arm64/annotate/instructions.c      |   4 +-
 tools/perf/arch/powerpc/util/header.c              |   3 +-
 tools/perf/arch/s390/annotate/instructions.c       |   6 +-
 tools/perf/arch/s390/util/header.c                 |   9 +-
 tools/perf/arch/x86/annotate/instructions.c        |   6 +-
 tools/perf/arch/x86/util/header.c                  |   3 +-
 tools/perf/builtin-kvm.c                           |   7 +-
 tools/perf/builtin-script.c                        |   6 +-
 tools/perf/pmu-events/jevents.c                    |  12 +-
 tools/perf/tests/perf-hooks.c                      |   3 +-
 tools/perf/util/annotate.c                         |  35 ++-
 tools/perf/util/annotate.h                         |   4 +
 tools/perf/util/map.c                              |   3 +
 tools/testing/selftests/Makefile                   |   4 +
 tools/testing/selftests/kselftest/runner.sh        |  36 ++-
 tools/testing/selftests/rtc/settings               |   1 +
 186 files changed, 1848 insertions(+), 880 deletions(-)


