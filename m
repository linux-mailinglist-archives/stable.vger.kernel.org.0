Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCAD2ABA42
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733096AbgKINRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:17:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732047AbgKINRL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:17:11 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C26320663;
        Mon,  9 Nov 2020 13:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927830;
        bh=goyvsbJCkz954ZdqQpp22nr9BdLm5gCVkgfA7Ka2Vrc=;
        h=From:To:Cc:Subject:Date:From;
        b=P5hhAYKWtIVml9ZE5b1a8Kaaxe3rJoRpkA/R+zAllfxymgFt4ijsK20M0Ei/LH+yY
         eg47E/9i3FUNLJpV1kYhVnAXVMz+BtiKk305mSu752blqkYRjaUzDnEcGleMyiUrFc
         eJXJBNUg92Kbu4H+ssF8aWSIb2KJNPpuWhPZWxeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.9 000/133] 5.9.7-rc1 review
Date:   Mon,  9 Nov 2020 13:54:22 +0100
Message-Id: <20201109125030.706496283@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.9.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.9.7-rc1
X-KernelTest-Deadline: 2020-11-11T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.9.7 release.
There are 133 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.7-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.9.7-rc1

kiyin(尹亮) <kiyin@tencent.com>
    perf/core: Fix a memory leak in perf_event_parse_addr_filter()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Use the local HWSP offset during submission

Imre Deak <imre.deak@intel.com>
    drm/i915: Fix encoder lookup during PSR atomic check

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Resume the device earlier in __device_release_driver()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Drop pm_runtime_clean_up_links()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Drop runtime PM references to supplier on link removal

Vineet Gupta <vgupta@synopsys.com>
    ARC: stack unwinding: avoid indefinite looping

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Fix a deadlock between the shrinker and madvise path

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: fix regression where EAPOL frames were sent in plaintext

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix link lookup racing with link timeout

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix panic in mtu3_gadget_stop()

Alan Stern <stern@rowland.harvard.edu>
    USB: Add NO_LPM quirk for Kingston flash drive

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Fix delay status handling

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit FN980 composition 0x1055

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231

Ziyi Cao <kernel@septs.pw>
    USB: serial: option: add Quectel EC200T module support

Johan Hovold <johan@kernel.org>
    USB: serial: cyberjack: fix write-URB completion race

Qinglang Miao <miaoqinglang@huawei.com>
    serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Claire Chang <tientzu@chromium.org>
    serial: 8250_mtk: Fix uart_get_baud_rate warning

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/40x: Always fault when _PAGE_ACCESSED is not set

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/8xx: Always fault when _PAGE_ACCESSED is not set

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: fix paes selftest failure with paes and pkey static build

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/mm: make pmd/pud_deref() large page aware

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: fix hot-plug of PCI function missing bus

Thomas Gleixner <tglx@linutronix.de>
    entry: Fix the incorrect ordering of lockdep and RCU check

Eddy Wu <itseddy0402@gmail.com>
    fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Matthias Reichl <hias@horus.com>
    tty: fix crash in release_tty if tty->port is not set

Lucas Stach <l.stach@pengutronix.de>
    tty: serial: imx: enable earlycon by default if IMX_SERIAL_CONSOLE is enabled

Daniel Vetter <daniel.vetter@ffwll.ch>
    vt: Disable KD_FONT_OP_COPY

Qian Cai <cai@redhat.com>
    arm64/smp: Move rcu_cpu_starting() earlier

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/gem: fix "refcount_t: underflow; use-after-free"

Ralph Campbell <rcampbell@nvidia.com>
    drm/nouveau/nouveau: fix the start/end range for migration

Peter Chen <peter.chen@nxp.com>
    usb: cdns3: gadget: suspicious implicit sign extension

Zhang Qilong <zhangqilong3@huawei.com>
    ACPI: NFIT: Fix comparison to '-ENXIO'

Hoegeun Kwon <hoegeun.kwon@samsung.com>
    drm/vc4: drv: Add error handding for bind

Seung-Woo Kim <sw0312.kim@samsung.com>
    staging: mmal-vchiq: Fix memory leak for vchiq_instance

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: fix a NULL pointer dereference when tracing the flush command

zhenwei pi <pizhenwei@bytedance.com>
    nvme-rdma: handle unexpected nvme completion data length

Jeff Vander Stoep <jeffv@google.com>
    vsock: use ns_capable_noaudit() on socket create

Martin Leung <martin.leung@amd.com>
    drm/amd/display: adding ddc_gpio_vga_reg_list to ddc reg def'ns

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Fix potential race after loss of transport

David Galiffi <David.Galiffi@amd.com>
    drm/amd/display: Fixed panic during seamless boot.

Tianci.Yin <tianci.yin@amd.com>
    drm/amdgpu: add DID for navi10 blockchain SKU

Tianci.Yin <tianci.yin@amd.com>
    drm/amdgpu: disable DCN and VCN for navi10 blockchain SKU(v3)

Ming Lei <ming.lei@redhat.com>
    scsi: core: Don't start concurrent async scan on same host

Josef Bacik <josef@toxicpanda.com>
    btrfs: add a helper to read the tree_root commit root for backref lookup

Josef Bacik <josef@toxicpanda.com>
    btrfs: drop the path before adding qgroup items when enabling qgroups

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Fix memleak on error path

Dan Carpenter <dan.carpenter@oracle.com>
    drm/v3d: Fix double free in v3d_submit_cl_ioctl()

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: frontend: Fix the scaler phase on A33

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: frontend: Reuse the ch0 phase for RGB formats

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: frontend: Rework a bit the phase data

Lubomir Rintel <lkundrak@v3.sk>
    ARM: dts: mmp3: Add power domain for the camera

Vincent Whitchurch <vincent.whitchurch@axis.com>
    of: Fix reserved-memory overlap detection

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: don't miss setting IO_WQ_WORK_CONCURRENT

Anand Moon <linux.amoon@gmail.com>
    arm64: dts: amlogic: add missing ethernet reset ID

Kairui Song <kasong@redhat.com>
    hyperv_fb: Update screen_info after removing old framebuffer

Kairui Song <kasong@redhat.com>
    x86/kexec: Use up-to-dated screen_info copy to fill boot params

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    arm64: dts: amlogic: meson-g12: use the G12A specific dwmac compatible

Scott K Logan <logans@cottsay.net>
    arm64: dts: meson: add missing g12 rng clock

Clément Péron <peron.clem@gmail.com>
    ARM: dts: sun4i-a10: fix cpu_alert temperature

Fangrui Song <maskray@google.com>
    x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S

Mike Galbraith <efault@gmx.de>
    futex: Handle transient "ownerless" rtmutex state correctly

Qiujun Huang <hqjagain@gmail.com>
    tracing: Fix out of bounds write in get_trace_buf

Martin Hundebøll <martin@geanix.com>
    spi: bcm2835: fix gpio cs level inversion

Michał Mirosław <mirq-linux@rere.qmqm.pl>
    regulator: defer probe when trying to get voltage from unresolved supply

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Handle tracing when switching between context

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ftrace: Fix recursion check for NMI test

Alexander Sverdlin <alexander.sverdlin@nokia.com>
    mtd: spi-nor: Don't copy self-pointing struct around

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix kernel NULL pointer dereference in find_domain()

John Clements <john.clements@amd.com>
    drm/amdgpu: resolved ASD loading issue on sienna

Likun Gao <Likun.Gao@amd.com>
    drm/amdgpu: update golden setting for sienna_cichlid

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Fix recursion protection transitions between interrupt context

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Don't call cancel_delayed_work_sync from within delete work function

Alexander Aring <aahringo@redhat.com>
    gfs2: Wake up when sd_glock_disposal becomes zero

Song Liu <songliubraving@fb.com>
    perf hists browser: Increase size of 'buf' in perf_evsel__hists_browse()

Jason Gunthorpe <jgg@ziepe.ca>
    mm: always have io_remap_pfn_range() set pgprot_decrypted()

Zqiang <qiang.zhang@windriver.com>
    kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

Vasily Gorbik <gor@linux.ibm.com>
    lib/crc32test: remove extra local_irq_disable/enable

Shijie Luo <luoshijie1@huawei.com>
    mm: mempolicy: fix potential pte_unmap_unlock pte error

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb_cgroup: fix reservation accounting

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add implicit feedback quirk for MODX

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: Add implicit feedback quirk for Qu-16

Artem Lapkin <art@khadas.com>
    ALSA: usb-audio: add usb vendor id as DSD-capable for Khadas devices

Keith Winstein <keithw@cs.stanford.edu>
    ALSA: usb-audio: Add implicit feedback quirk for Zoom UAC-2

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Enable headphone for ASUS TM420

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Fixed HP headset Mic can't be detected

Lee Jones <lee.jones@linaro.org>
    Fonts: Replace discarded const qualifier

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Fix clock checking algorithm in nv50_dp_mode_valid()

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Get rid of bogus nouveau_conn_mode_valid()

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: work around short packet hw bug on RTL8125

Eelco Chaudron <echaudro@redhat.com>
    net: openvswitch: silence suspicious RCU usage warning

Jonathan McDowell <noodles@earth.li>
    net: dsa: qca8k: Fix port MTU setting

Davide Caratti <dcaratti@redhat.com>
    mptcp: token: fix unititialized variable

Greg Ungerer <gerg@linux-m68k.org>
    net: fec: fix MDIO probing for some FEC hardware blocks

Alexander Ovechkin <ovov@yandex-team.ru>
    ip6_tunnel: set inner ipproto before ip6_tnl_encap

YueHaibing <yuehaibing@huawei.com>
    sfp: Fix error handing in sfp_probe()

Petr Malat <oss@malat.biz>
    sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    powerpc/vnic: Extend "failover pending" window

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

Grygorii Strashko <grygorii.strashko@ti.com>
    net: ethernet: ti: cpsw: disable PTPv1 hw timestamping advertisement

wenxu <wenxu@ucloud.cn>
    ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags

Shannon Nelson <snelson@pensando.io>
    ionic: check port ptr before use

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Account for Tx PTP timestamp in the skb headroom

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP

Camelia Groza <camelia.groza@nxp.com>
    dpaa_eth: fix the RX headroom size alignment

Camelia Groza <camelia.groza@nxp.com>
    dpaa_eth: update the buffer layout for non-A050385 erratum scenarios

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix always leaking ctrl_skb

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix memory leaks caused by a race

Mark Deneen <mdeneen@saucontech.com>
    cadence: force nonlinear buffers to be cloned

Oleg Nesterov <oleg@redhat.com>
    ptrace: fix task_join_group_stop() for the case when current is traced

Karol Herbst <kherbst@redhat.com>
    drm/nouveau/device: fix changing endianess code to work on older GPUs

Lyude Paul <lyude@redhat.com>
    drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Restore ILK-M RPS support

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Reject 90/270 degree rotated initial fbs

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Use the active reference on the vma while capturing

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Mark ininitial fb obj as WT on eLLC machines to avoid rcu lockup during fbdev init

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Exclude low pages (128KiB) of stolen from use

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Drop runtime-pm assert from vgpu io accessors

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Delay execlist processing for tgl

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Undo forced context restores after trivial preemptions

Ayaz A Siddiqui <ayaz.siddiqui@intel.com>
    drm/i915/gt: Initialize reserved and unspecified MOCS indices

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Fix TGL DKL PHY DP vswing handling

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Avoid mixing integer types during batch copies

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Cancel outstanding work after disabling heartbeats on an engine

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Break up error capture compression loops with cond_resched()

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Always send a pulse down the engine after disabling heartbeat

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Always test execution status on closing the context

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Prevent using pgprot_writecombine() if PAT is not supported

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gem: Avoid implicit vmap for highmem on x86-32

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free in tipc_bcast_get_mode

Taehee Yoo <ap420073@gmail.com>
    net: core: use list_del_init() instead of list_del() in netdev_run_todo()


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/kernel/stacktrace.c                       |   7 +-
 arch/arm/boot/dts/mmp3.dtsi                        |   2 +
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   2 +-
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi         |   2 +
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   6 +-
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi          |   3 +
 arch/arm64/kernel/smp.c                            |   1 +
 arch/powerpc/kernel/head_40x.S                     |   8 -
 arch/powerpc/kernel/head_8xx.S                     |  14 +-
 arch/s390/include/asm/pgtable.h                    |  52 +++---
 arch/s390/pci/pci_event.c                          |   4 +
 arch/x86/kernel/kexec-bzimage64.c                  |   3 +-
 arch/x86/lib/memcpy_64.S                           |   4 +-
 arch/x86/lib/memmove_64.S                          |   4 +-
 arch/x86/lib/memset_64.S                           |   4 +-
 block/blk-cgroup.c                                 |  15 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/base/core.c                                |   6 +-
 drivers/base/dd.c                                  |   9 +-
 drivers/base/power/runtime.c                       |  57 +++---
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   2 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c             |   4 +
 drivers/gpu/drm/amd/amdgpu/nv.c                    |  14 +-
 .../gpu/drm/amd/display/dc/dce/dce_clock_source.c  |   3 +-
 .../amd/display/dc/gpio/dcn30/hw_factory_dcn30.c   |  12 ++
 drivers/gpu/drm/i915/Kconfig.debug                 |   1 +
 drivers/gpu/drm/i915/display/intel_ddi.c           |   2 +-
 drivers/gpu/drm/i915/display/intel_display.c       |  12 ++
 drivers/gpu/drm/i915/display/intel_psr.c           |   2 +-
 drivers/gpu/drm/i915/gem/i915_gem_context.c        |  48 ++---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |   7 +-
 drivers/gpu/drm/i915/gem/i915_gem_pages.c          |  30 +++-
 drivers/gpu/drm/i915/gem/i915_gem_stolen.c         |   6 +-
 drivers/gpu/drm/i915/gem/i915_gem_stolen.h         |   2 +
 drivers/gpu/drm/i915/gt/intel_engine.h             |   9 +
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c   | 106 +++++++----
 drivers/gpu/drm/i915/gt/intel_lrc.c                |  35 ++--
 drivers/gpu/drm/i915/gt/intel_mocs.c               |  16 +-
 drivers/gpu/drm/i915/gt/intel_timeline.c           |  18 +-
 drivers/gpu/drm/i915/gt/intel_timeline_types.h     |   2 +
 drivers/gpu/drm/i915/gt/selftest_reset.c           | 196 +++++++++++++++++++++
 drivers/gpu/drm/i915/i915_cmd_parser.c             |  10 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   4 +-
 drivers/gpu/drm/i915/i915_gpu_error.c              |   6 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   1 +
 drivers/gpu/drm/i915/i915_request.c                |   5 +
 drivers/gpu/drm/i915/intel_uncore.c                |  27 ++-
 drivers/gpu/drm/nouveau/dispnv50/core.h            |   2 +
 drivers/gpu/drm/nouveau/dispnv50/core507d.c        |  41 ++++-
 drivers/gpu/drm/nouveau/dispnv50/core907d.c        |  36 +++-
 drivers/gpu/drm/nouveau/dispnv50/core917d.c        |   2 +-
 .../gpu/drm/nouveau/include/nvhw/class/cl507d.h    |   5 +-
 .../gpu/drm/nouveau/include/nvhw/class/cl907d.h    |   4 +
 drivers/gpu/drm/nouveau/nouveau_connector.c        |  36 ++--
 drivers/gpu/drm/nouveau/nouveau_dp.c               |  21 ++-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |  14 +-
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c  |  39 ++--
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   4 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   2 +-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c   |  14 +-
 drivers/gpu/drm/sun4i/sun4i_frontend.c             |  36 ++--
 drivers/gpu/drm/sun4i/sun4i_frontend.h             |   6 +-
 drivers/gpu/drm/v3d/v3d_gem.c                      |   1 -
 drivers/gpu/drm/vc4/vc4_drv.c                      |   1 +
 drivers/iommu/intel/iommu.c                        |   3 +
 drivers/mtd/spi-nor/core.c                         |   5 +-
 drivers/net/dsa/qca8k.c                            |   4 +-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  28 +--
 drivers/net/ethernet/freescale/fec.h               |   6 +
 drivers/net/ethernet/freescale/fec_main.c          |  29 +--
 drivers/net/ethernet/freescale/gianfar.c           |  14 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  36 +++-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   5 +
 drivers/net/ethernet/realtek/r8169_main.c          |  14 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |   1 -
 drivers/net/ethernet/ti/cpsw_priv.c                |   5 +-
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nvme/host/rdma.c                           |   8 +
 drivers/nvme/target/core.c                         |   4 +-
 drivers/nvme/target/trace.h                        |  21 +--
 drivers/of/of_reserved_mem.c                       |  13 +-
 drivers/regulator/core.c                           |   2 +
 drivers/s390/crypto/pkey_api.c                     |  30 ++--
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |  36 ++--
 drivers/scsi/scsi_scan.c                           |   7 +-
 drivers/spi/spi-bcm2835.c                          |  12 --
 .../staging/vc04_services/vchiq-mmal/mmal-vchiq.c  |  19 +-
 drivers/tty/serial/8250/8250_mtk.c                 |   2 +-
 drivers/tty/serial/Kconfig                         |   1 +
 drivers/tty/serial/serial_txx9.c                   |   3 +
 drivers/tty/tty_io.c                               |   6 +-
 drivers/tty/vt/vt.c                                |  24 +--
 drivers/usb/cdns3/gadget.h                         |   2 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/ep0.c                             |   3 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |   1 +
 drivers/usb/serial/cyberjack.c                     |   7 +-
 drivers/usb/serial/option.c                        |  10 ++
 drivers/video/fbdev/hyperv_fb.c                    |   9 +-
 fs/btrfs/backref.c                                 |  13 +-
 fs/btrfs/disk-io.c                                 | 139 ++++++++++-----
 fs/btrfs/disk-io.h                                 |   3 +
 fs/btrfs/qgroup.c                                  |  18 ++
 fs/gfs2/glock.c                                    |   3 +-
 fs/gfs2/inode.c                                    |   3 +-
 fs/io_uring.c                                      |  26 ++-
 include/linux/mm.h                                 |   9 +
 include/linux/pgtable.h                            |   4 -
 include/linux/pm_runtime.h                         |   6 +-
 kernel/entry/common.c                              |   4 +-
 kernel/events/core.c                               |  12 +-
 kernel/fork.c                                      |  10 +-
 kernel/futex.c                                     |  16 +-
 kernel/kthread.c                                   |   3 +-
 kernel/signal.c                                    |  19 +-
 kernel/trace/ring_buffer.c                         |  58 ++++--
 kernel/trace/trace.c                               |   2 +-
 kernel/trace/trace.h                               |  26 ++-
 kernel/trace/trace_selftest.c                      |   9 +-
 lib/crc32test.c                                    |   4 -
 lib/fonts/font_10x18.c                             |   2 +-
 lib/fonts/font_6x10.c                              |   2 +-
 lib/fonts/font_6x11.c                              |   2 +-
 lib/fonts/font_7x14.c                              |   2 +-
 lib/fonts/font_8x16.c                              |   2 +-
 lib/fonts/font_8x8.c                               |   2 +-
 lib/fonts/font_acorn_8x8.c                         |   2 +-
 lib/fonts/font_mini_4x6.c                          |   2 +-
 lib/fonts/font_pearl_8x8.c                         |   2 +-
 lib/fonts/font_sun12x22.c                          |   2 +-
 lib/fonts/font_sun8x16.c                           |   2 +-
 lib/fonts/font_ter16x32.c                          |   2 +-
 mm/hugetlb.c                                       |  20 ++-
 mm/mempolicy.c                                     |   6 +-
 net/core/dev.c                                     |   2 +-
 net/ipv4/ip_tunnel.c                               |   3 -
 net/ipv6/ip6_tunnel.c                              |   4 +-
 net/mac80211/tx.c                                  |   7 +-
 net/mptcp/token.c                                  |   2 +-
 net/openvswitch/datapath.c                         |  14 +-
 net/openvswitch/flow_table.c                       |   2 +-
 net/sctp/sm_sideeffect.c                           |   4 +-
 net/tipc/core.c                                    |   5 +
 net/vmw_vsock/af_vsock.c                           |   2 +-
 sound/pci/hda/patch_realtek.c                      |  67 +++++--
 sound/usb/pcm.c                                    |   6 +
 sound/usb/quirks.c                                 |   1 +
 tools/perf/ui/browsers/hists.c                     |   2 +-
 155 files changed, 1361 insertions(+), 638 deletions(-)


