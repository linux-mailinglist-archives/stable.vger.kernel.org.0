Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22B1C2AB9D0
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgKINM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732774AbgKINMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E26AF20663;
        Mon,  9 Nov 2020 13:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927574;
        bh=kXfsAInd/08o1TNB/yJ+d5T6EPctOZxTLQiWSB29I24=;
        h=From:To:Cc:Subject:Date:From;
        b=AcvXYvWukc3OKmwrd2PBmXCyJmpJKEPbqFSPeu07wlk1A5WdUv/ojPszc/aVXqTsv
         Btc5+CyubOhjiRoq1w4YduX4IcN0OkoXA6IFJzcn1LAWCm7zNov5GOb8vroY9mIlJw
         vMi8rAsXArVJqI0VlD5sXHdPPXhMxKDTO+4DgMtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.4 00/85] 5.4.76-rc1 review
Date:   Mon,  9 Nov 2020 13:54:57 +0100
Message-Id: <20201109125022.614792961@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.76-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.76-rc1
X-KernelTest-Deadline: 2020-11-11T12:50+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.76 release.
There are 85 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.76-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.76-rc1

Pali Rohár <pali@kernel.org>
    arm64: dts: marvell: espressobin: Add ethernet switch aliases

kiyin(尹亮) <kiyin@tencent.com>
    perf/core: Fix a memory leak in perf_event_parse_addr_filter()

Andy Strohman <astroh@amazon.com>
    xfs: flush for older, xfs specific ioctls

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

Macpaul Lin <macpaul.lin@mediatek.com>
    usb: mtu3: fix panic in mtu3_gadget_stop()

Alan Stern <stern@rowland.harvard.edu>
    USB: Add NO_LPM quirk for Kingston flash drive

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: ep0: Fix delay status handling

Vladimir Oltean <vladimir.oltean@nxp.com>
    tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A

Michael Walle <michael@walle.cc>
    tty: serial: fsl_lpuart: add LS1028A support

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

Harald Freudenberger <freude@linux.ibm.com>
    s390/pkey: fix paes selftest failure with paes and pkey static build

Eddy Wu <itseddy0402@gmail.com>
    fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Daniel Vetter <daniel.vetter@ffwll.ch>
    vt: Disable KD_FONT_OP_COPY

Sasha Levin <sashal@kernel.org>
    Revert "coresight: Make sysfs functional on topologies with per core sink"

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

Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
    nvmet: fix a NULL pointer dereference when tracing the flush command

zhenwei pi <pizhenwei@bytedance.com>
    nvme-rdma: handle unexpected nvme completion data length

Jeff Vander Stoep <jeffv@google.com>
    vsock: use ns_capable_noaudit() on socket create

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsi: Fix potential race after loss of transport

Tianci.Yin <tianci.yin@amd.com>
    drm/amdgpu: add DID for navi10 blockchain SKU

Ming Lei <ming.lei@redhat.com>
    scsi: core: Don't start concurrent async scan on same host

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Gabriel Krisman Bertazi <krisman@collabora.com>
    blk-cgroup: Fix memleak on error path

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: frontend: Fix the scaler phase on A33

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: frontend: Reuse the ch0 phase for RGB formats

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: frontend: Rework a bit the phase data

Vincent Whitchurch <vincent.whitchurch@axis.com>
    of: Fix reserved-memory overlap detection

Kairui Song <kasong@redhat.com>
    x86/kexec: Use up-to-dated screen_info copy to fill boot params

Scott K Logan <logans@cottsay.net>
    arm64: dts: meson: add missing g12 rng clock

Clément Péron <peron.clem@gmail.com>
    ARM: dts: sun4i-a10: fix cpu_alert temperature

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

Steven Rostedt (VMware) <rostedt@goodmis.org>
    ring-buffer: Fix recursion protection transitions between interrupt context

Alexander Aring <aahringo@redhat.com>
    gfs2: Wake up when sd_glock_disposal becomes zero

Jason Gunthorpe <jgg@nvidia.com>
    mm: always have io_remap_pfn_range() set pgprot_decrypted()

Zqiang <qiang.zhang@windriver.com>
    kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

Vasily Gorbik <gor@linux.ibm.com>
    lib/crc32test: remove extra local_irq_disable/enable

Shijie Luo <luoshijie1@huawei.com>
    mm: mempolicy: fix potential pte_unmap_unlock pte error

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

YueHaibing <yuehaibing@huawei.com>
    sfp: Fix error handing in sfp_probe()

Petr Malat <oss@malat.biz>
    sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    powerpc/vnic: Extend "failover pending" window

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

wenxu <wenxu@ucloud.cn>
    ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags

Shannon Nelson <snelson@pensando.io>
    ionic: check port ptr before use

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Account for Tx PTP timestamp in the skb headroom

Claudiu Manoil <claudiu.manoil@nxp.com>
    gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix always leaking ctrl_skb

Vinay Kumar Yadav <vinay.yadav@chelsio.com>
    chelsio/chtls: fix memory leaks caused by a race

Mark Deneen <mdeneen@saucontech.com>
    cadence: force nonlinear buffers to be cloned

Oleg Nesterov <oleg@redhat.com>
    ptrace: fix task_join_group_stop() for the case when current is traced

Hoang Huu Le <hoang.h.le@dektech.com.au>
    tipc: fix use-after-free in tipc_bcast_get_mode

Fangrui Song <maskray@google.com>
    arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S

Mark Brown <broonie@kernel.org>
    arm64: lib: Use modern annotations for assembly functions

Mark Brown <broonie@kernel.org>
    arm64: asm: Add new-style position independent function annotations

Jiri Slaby <jslaby@suse.cz>
    linkage: Introduce new macros for assembler symbols

Mateusz Gorski <mateusz.gorski@linux.intel.com>
    ASoC: Intel: Skylake: Add alternative topology binary name

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Drop runtime-pm assert from vgpu io accessors

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915/gt: Delay execlist processing for tgl

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Break up error capture compression loops with cond_resched()


-------------

Diffstat:

 Documentation/asm-annotations.rst                  | 216 ++++++++++++++++++
 Documentation/index.rst                            |   8 +
 Makefile                                           |   4 +-
 arch/arc/kernel/stacktrace.c                       |   7 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                   |   2 +-
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi  |   2 +
 .../boot/dts/marvell/armada-3720-espressobin.dts   |  12 +-
 arch/arm64/include/asm/assembler.h                 |   1 +
 arch/arm64/include/asm/linkage.h                   |  16 ++
 arch/arm64/kernel/smp.c                            |   1 +
 arch/arm64/lib/clear_page.S                        |   4 +-
 arch/arm64/lib/clear_user.S                        |   4 +-
 arch/arm64/lib/copy_from_user.S                    |   4 +-
 arch/arm64/lib/copy_in_user.S                      |   4 +-
 arch/arm64/lib/copy_page.S                         |   4 +-
 arch/arm64/lib/copy_to_user.S                      |   4 +-
 arch/arm64/lib/crc32.S                             |   8 +-
 arch/arm64/lib/memchr.S                            |   4 +-
 arch/arm64/lib/memcmp.S                            |   4 +-
 arch/arm64/lib/memcpy.S                            |   9 +-
 arch/arm64/lib/memmove.S                           |   9 +-
 arch/arm64/lib/memset.S                            |   9 +-
 arch/arm64/lib/strchr.S                            |   4 +-
 arch/arm64/lib/strcmp.S                            |   4 +-
 arch/arm64/lib/strlen.S                            |   4 +-
 arch/arm64/lib/strncmp.S                           |   4 +-
 arch/arm64/lib/strnlen.S                           |   4 +-
 arch/arm64/lib/strrchr.S                           |   4 +-
 arch/arm64/lib/tishift.S                           |  12 +-
 arch/x86/include/asm/linkage.h                     |  10 +-
 arch/x86/kernel/kexec-bzimage64.c                  |   3 +-
 block/blk-cgroup.c                                 |  15 +-
 drivers/acpi/nfit/core.c                           |   2 +-
 drivers/base/core.c                                |   6 +-
 drivers/base/dd.c                                  |   9 +-
 drivers/base/power/runtime.c                       |  57 ++---
 drivers/crypto/chelsio/chtls/chtls_cm.c            |   2 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c            |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   1 +
 drivers/gpu/drm/i915/gt/intel_lrc.c                |   3 +
 drivers/gpu/drm/i915/i915_gpu_error.c              |   3 +
 drivers/gpu/drm/i915/intel_uncore.c                |  27 ++-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |   3 +-
 drivers/gpu/drm/nouveau/nouveau_svm.c              |  14 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |   4 +-
 drivers/gpu/drm/panfrost/panfrost_gem.h            |   2 +-
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c   |  14 +-
 drivers/gpu/drm/sun4i/sun4i_frontend.c             |  36 +--
 drivers/gpu/drm/sun4i/sun4i_frontend.h             |   6 +-
 drivers/gpu/drm/vc4/vc4_drv.c                      |   1 +
 drivers/hwtracing/coresight/coresight-priv.h       |   3 +-
 drivers/hwtracing/coresight/coresight.c            |  62 +++---
 drivers/mtd/spi-nor/spi-nor.c                      |   5 +-
 drivers/net/ethernet/cadence/macb_main.c           |   3 +-
 drivers/net/ethernet/freescale/gianfar.c           |  14 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  36 ++-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |   5 +
 drivers/net/phy/sfp.c                              |   3 +-
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/nvme/host/rdma.c                           |   8 +
 drivers/nvme/target/core.c                         |   4 +-
 drivers/nvme/target/trace.h                        |  21 +-
 drivers/of/of_reserved_mem.c                       |  13 +-
 drivers/regulator/core.c                           |   2 +
 drivers/s390/crypto/pkey_api.c                     |  30 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |  36 ++-
 drivers/scsi/scsi_scan.c                           |   7 +-
 drivers/spi/spi-bcm2835.c                          |  12 -
 drivers/tty/serial/8250/8250_mtk.c                 |   2 +-
 drivers/tty/serial/fsl_lpuart.c                    |  28 ++-
 drivers/tty/serial/serial_txx9.c                   |   3 +
 drivers/tty/vt/vt.c                                |  24 +-
 drivers/usb/cdns3/gadget.h                         |   2 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/ep0.c                             |   3 +-
 drivers/usb/mtu3/mtu3_gadget.c                     |   1 +
 drivers/usb/serial/cyberjack.c                     |   7 +-
 drivers/usb/serial/option.c                        |  10 +
 fs/gfs2/glock.c                                    |   3 +-
 fs/xfs/xfs_ioctl.c                                 |  26 ++-
 include/asm-generic/pgtable.h                      |   4 -
 include/linux/linkage.h                            | 245 ++++++++++++++++++++-
 include/linux/mm.h                                 |   9 +
 include/linux/pm_runtime.h                         |   6 +-
 kernel/events/core.c                               |  12 +-
 kernel/fork.c                                      |  10 +-
 kernel/futex.c                                     |  16 +-
 kernel/kthread.c                                   |   3 +-
 kernel/signal.c                                    |  19 +-
 kernel/trace/ring_buffer.c                         |  58 ++++-
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
 mm/mempolicy.c                                     |   6 +-
 net/ipv4/ip_tunnel.c                               |   3 -
 net/sctp/sm_sideeffect.c                           |   4 +-
 net/tipc/core.c                                    |   5 +
 net/vmw_vsock/af_vsock.c                           |   2 +-
 sound/pci/hda/patch_realtek.c                      |  67 +++++-
 sound/soc/intel/skylake/skl-topology.c             |  19 +-
 sound/usb/pcm.c                                    |   6 +
 sound/usb/quirks.c                                 |   1 +
 115 files changed, 1132 insertions(+), 398 deletions(-)


