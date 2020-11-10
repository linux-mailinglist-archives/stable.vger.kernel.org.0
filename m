Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B82AD968
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 15:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732423AbgKJO4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 09:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732387AbgKJO43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 09:56:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8F4206F1;
        Tue, 10 Nov 2020 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020188;
        bh=5C8eZmzOU2nsPISE8PO9aiILo4M2k+zzhWqdx/rpLsg=;
        h=From:To:Cc:Subject:Date:From;
        b=Fv0f1kXVwE3wLtrMkY4WmVcl8JKGxxc2RNlxisVjgD9Zp8W1TFpSpWP6N0Cv8RYGz
         4fHrdruc6GKeyvcXatOxjkIwPgyCUCHxFvnsHJ+SK3oZUiKP8oI7fOdetgpWb3NPRP
         TXikbgE4rlo1t80xR7o51ovNYQiktfdNONtVryTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.76
Date:   Tue, 10 Nov 2020 15:57:16 +0100
Message-Id: <160502023621698@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.76 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/asm-annotations.rst                       |  216 ++++++++++++++
 Documentation/index.rst                                 |    8 
 Makefile                                                |    2 
 arch/arc/kernel/stacktrace.c                            |    7 
 arch/arm/boot/dts/sun4i-a10.dtsi                        |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi       |    2 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts |   12 
 arch/arm64/include/asm/assembler.h                      |    1 
 arch/arm64/include/asm/linkage.h                        |   16 +
 arch/arm64/kernel/smp.c                                 |    1 
 arch/arm64/lib/clear_page.S                             |    4 
 arch/arm64/lib/clear_user.S                             |    4 
 arch/arm64/lib/copy_from_user.S                         |    4 
 arch/arm64/lib/copy_in_user.S                           |    4 
 arch/arm64/lib/copy_page.S                              |    4 
 arch/arm64/lib/copy_to_user.S                           |    4 
 arch/arm64/lib/crc32.S                                  |    8 
 arch/arm64/lib/memchr.S                                 |    4 
 arch/arm64/lib/memcmp.S                                 |    4 
 arch/arm64/lib/memcpy.S                                 |    9 
 arch/arm64/lib/memmove.S                                |    9 
 arch/arm64/lib/memset.S                                 |    9 
 arch/arm64/lib/strchr.S                                 |    4 
 arch/arm64/lib/strcmp.S                                 |    4 
 arch/arm64/lib/strlen.S                                 |    4 
 arch/arm64/lib/strncmp.S                                |    4 
 arch/arm64/lib/strnlen.S                                |    4 
 arch/arm64/lib/strrchr.S                                |    4 
 arch/arm64/lib/tishift.S                                |   12 
 arch/x86/include/asm/linkage.h                          |   10 
 arch/x86/kernel/kexec-bzimage64.c                       |    3 
 block/blk-cgroup.c                                      |   15 
 drivers/acpi/nfit/core.c                                |    2 
 drivers/base/core.c                                     |    6 
 drivers/base/dd.c                                       |    9 
 drivers/base/power/runtime.c                            |   57 +--
 drivers/crypto/chelsio/chtls/chtls_cm.c                 |    2 
 drivers/crypto/chelsio/chtls/chtls_hw.c                 |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                 |    1 
 drivers/gpu/drm/i915/gt/intel_lrc.c                     |    3 
 drivers/gpu/drm/i915/i915_gpu_error.c                   |    3 
 drivers/gpu/drm/i915/intel_uncore.c                     |   27 +
 drivers/gpu/drm/nouveau/nouveau_gem.c                   |    3 
 drivers/gpu/drm/nouveau/nouveau_svm.c                   |   14 
 drivers/gpu/drm/panfrost/panfrost_gem.c                 |    4 
 drivers/gpu/drm/panfrost/panfrost_gem.h                 |    2 
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c        |   14 
 drivers/gpu/drm/sun4i/sun4i_frontend.c                  |   36 --
 drivers/gpu/drm/sun4i/sun4i_frontend.h                  |    6 
 drivers/gpu/drm/vc4/vc4_drv.c                           |    1 
 drivers/hwtracing/coresight/coresight-priv.h            |    3 
 drivers/hwtracing/coresight/coresight.c                 |   62 ++--
 drivers/mtd/spi-nor/spi-nor.c                           |    5 
 drivers/net/ethernet/cadence/macb_main.c                |    3 
 drivers/net/ethernet/freescale/gianfar.c                |   14 
 drivers/net/ethernet/ibm/ibmvnic.c                      |   36 ++
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c     |    5 
 drivers/net/phy/sfp.c                                   |    3 
 drivers/net/usb/qmi_wwan.c                              |    1 
 drivers/nvme/host/rdma.c                                |    8 
 drivers/nvme/target/core.c                              |    4 
 drivers/nvme/target/trace.h                             |   21 -
 drivers/of/of_reserved_mem.c                            |   13 
 drivers/regulator/core.c                                |    2 
 drivers/s390/crypto/pkey_api.c                          |   30 +
 drivers/scsi/ibmvscsi/ibmvscsi.c                        |   36 +-
 drivers/scsi/scsi_scan.c                                |    7 
 drivers/spi/spi-bcm2835.c                               |   12 
 drivers/tty/serial/8250/8250_mtk.c                      |    2 
 drivers/tty/serial/fsl_lpuart.c                         |   28 +
 drivers/tty/serial/serial_txx9.c                        |    3 
 drivers/tty/vt/vt.c                                     |   24 -
 drivers/usb/cdns3/gadget.h                              |    2 
 drivers/usb/core/quirks.c                               |    3 
 drivers/usb/dwc3/ep0.c                                  |    3 
 drivers/usb/mtu3/mtu3_gadget.c                          |    1 
 drivers/usb/serial/cyberjack.c                          |    7 
 drivers/usb/serial/option.c                             |   10 
 fs/gfs2/glock.c                                         |    3 
 fs/xfs/xfs_ioctl.c                                      |   26 +
 include/asm-generic/pgtable.h                           |    4 
 include/linux/linkage.h                                 |  245 +++++++++++++++-
 include/linux/mm.h                                      |    9 
 include/linux/pm_runtime.h                              |    6 
 kernel/events/core.c                                    |   12 
 kernel/fork.c                                           |   10 
 kernel/futex.c                                          |   16 -
 kernel/kthread.c                                        |    3 
 kernel/signal.c                                         |   19 -
 kernel/trace/ring_buffer.c                              |   58 +++
 kernel/trace/trace.c                                    |    2 
 kernel/trace/trace.h                                    |   26 +
 kernel/trace/trace_selftest.c                           |    9 
 lib/crc32test.c                                         |    4 
 lib/fonts/font_10x18.c                                  |    2 
 lib/fonts/font_6x10.c                                   |    2 
 lib/fonts/font_6x11.c                                   |    2 
 lib/fonts/font_7x14.c                                   |    2 
 lib/fonts/font_8x16.c                                   |    2 
 lib/fonts/font_8x8.c                                    |    2 
 lib/fonts/font_acorn_8x8.c                              |    2 
 lib/fonts/font_mini_4x6.c                               |    2 
 lib/fonts/font_pearl_8x8.c                              |    2 
 lib/fonts/font_sun12x22.c                               |    2 
 lib/fonts/font_sun8x16.c                                |    2 
 lib/fonts/font_ter16x32.c                               |    2 
 mm/mempolicy.c                                          |    6 
 net/ipv4/ip_tunnel.c                                    |    3 
 net/sctp/sm_sideeffect.c                                |    4 
 net/tipc/core.c                                         |    5 
 net/vmw_vsock/af_vsock.c                                |    2 
 sound/pci/hda/patch_realtek.c                           |   67 +++-
 sound/soc/intel/skylake/skl-topology.c                  |   19 +
 sound/usb/pcm.c                                         |    6 
 sound/usb/quirks.c                                      |    1 
 115 files changed, 1131 insertions(+), 397 deletions(-)

Alan Stern (1):
      USB: Add NO_LPM quirk for Kingston flash drive

Alexander Aring (1):
      gfs2: Wake up when sd_glock_disposal becomes zero

Alexander Sverdlin (1):
      mtd: spi-nor: Don't copy self-pointing struct around

Andy Strohman (1):
      xfs: flush for older, xfs specific ioctls

Artem Lapkin (1):
      ALSA: usb-audio: add usb vendor id as DSD-capable for Khadas devices

Boris Brezillon (1):
      drm/panfrost: Fix a deadlock between the shrinker and madvise path

Chaitanya Kulkarni (1):
      nvmet: fix a NULL pointer dereference when tracing the flush command

Chris Wilson (3):
      drm/i915: Break up error capture compression loops with cond_resched()
      drm/i915/gt: Delay execlist processing for tgl
      drm/i915: Drop runtime-pm assert from vgpu io accessors

Claire Chang (1):
      serial: 8250_mtk: Fix uart_get_baud_rate warning

Claudiu Manoil (2):
      gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
      gianfar: Account for Tx PTP timestamp in the skb headroom

Clément Péron (1):
      ARM: dts: sun4i-a10: fix cpu_alert temperature

Daniel Vetter (1):
      vt: Disable KD_FONT_OP_COPY

Daniele Palmas (3):
      net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
      USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231
      USB: serial: option: add Telit FN980 composition 0x1055

Eddy Wu (1):
      fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Fangrui Song (1):
      arm64: Change .weak to SYM_FUNC_START_WEAK_PI for arch/arm64/lib/mem*.S

Gabriel Krisman Bertazi (2):
      blk-cgroup: Fix memleak on error path
      blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Geoffrey D. Bennett (2):
      ALSA: usb-audio: Add implicit feedback quirk for Qu-16
      ALSA: usb-audio: Add implicit feedback quirk for MODX

Greg Kroah-Hartman (1):
      Linux 5.4.76

Harald Freudenberger (1):
      s390/pkey: fix paes selftest failure with paes and pkey static build

Hoang Huu Le (1):
      tipc: fix use-after-free in tipc_bcast_get_mode

Hoegeun Kwon (1):
      drm/vc4: drv: Add error handding for bind

Jason Gunthorpe (1):
      mm: always have io_remap_pfn_range() set pgprot_decrypted()

Jeff Vander Stoep (1):
      vsock: use ns_capable_noaudit() on socket create

Jiri Slaby (1):
      linkage: Introduce new macros for assembler symbols

Johan Hovold (1):
      USB: serial: cyberjack: fix write-URB completion race

Kailang Yang (2):
      ALSA: hda/realtek - Fixed HP headset Mic can't be detected
      ALSA: hda/realtek - Enable headphone for ASUS TM420

Kairui Song (1):
      x86/kexec: Use up-to-dated screen_info copy to fill boot params

Karol Herbst (1):
      drm/nouveau/gem: fix "refcount_t: underflow; use-after-free"

Keith Winstein (1):
      ALSA: usb-audio: Add implicit feedback quirk for Zoom UAC-2

Lee Jones (1):
      Fonts: Replace discarded const qualifier

Macpaul Lin (1):
      usb: mtu3: fix panic in mtu3_gadget_stop()

Mark Brown (2):
      arm64: asm: Add new-style position independent function annotations
      arm64: lib: Use modern annotations for assembly functions

Mark Deneen (1):
      cadence: force nonlinear buffers to be cloned

Martin Hundebøll (1):
      spi: bcm2835: fix gpio cs level inversion

Mateusz Gorski (1):
      ASoC: Intel: Skylake: Add alternative topology binary name

Maxime Ripard (3):
      drm/sun4i: frontend: Rework a bit the phase data
      drm/sun4i: frontend: Reuse the ch0 phase for RGB formats
      drm/sun4i: frontend: Fix the scaler phase on A33

Michael Walle (1):
      tty: serial: fsl_lpuart: add LS1028A support

Michał Mirosław (1):
      regulator: defer probe when trying to get voltage from unresolved supply

Mike Galbraith (1):
      futex: Handle transient "ownerless" rtmutex state correctly

Ming Lei (1):
      scsi: core: Don't start concurrent async scan on same host

Oleg Nesterov (1):
      ptrace: fix task_join_group_stop() for the case when current is traced

Pali Rohár (1):
      arm64: dts: marvell: espressobin: Add ethernet switch aliases

Peter Chen (1):
      usb: cdns3: gadget: suspicious implicit sign extension

Petr Malat (1):
      sctp: Fix COMM_LOST/CANT_STR_ASSOC err reporting on big-endian platforms

Qian Cai (1):
      arm64/smp: Move rcu_cpu_starting() earlier

Qinglang Miao (1):
      serial: txx9: add missing platform_driver_unregister() on error in serial_txx9_init

Qiujun Huang (1):
      tracing: Fix out of bounds write in get_trace_buf

Rafael J. Wysocki (3):
      PM: runtime: Drop runtime PM references to supplier on link removal
      PM: runtime: Drop pm_runtime_clean_up_links()
      PM: runtime: Resume the device earlier in __device_release_driver()

Ralph Campbell (1):
      drm/nouveau/nouveau: fix the start/end range for migration

Sasha Levin (1):
      Revert "coresight: Make sysfs functional on topologies with per core sink"

Scott K Logan (1):
      arm64: dts: meson: add missing g12 rng clock

Shannon Nelson (1):
      ionic: check port ptr before use

Shijie Luo (1):
      mm: mempolicy: fix potential pte_unmap_unlock pte error

Steven Rostedt (VMware) (3):
      ring-buffer: Fix recursion protection transitions between interrupt context
      ftrace: Fix recursion check for NMI test
      ftrace: Handle tracing when switching between context

Sukadev Bhattiprolu (1):
      powerpc/vnic: Extend "failover pending" window

Thinh Nguyen (1):
      usb: dwc3: ep0: Fix delay status handling

Tianci.Yin (1):
      drm/amdgpu: add DID for navi10 blockchain SKU

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix potential race after loss of transport

Vasily Gorbik (1):
      lib/crc32test: remove extra local_irq_disable/enable

Vinay Kumar Yadav (2):
      chelsio/chtls: fix memory leaks caused by a race
      chelsio/chtls: fix always leaking ctrl_skb

Vincent Whitchurch (1):
      of: Fix reserved-memory overlap detection

Vineet Gupta (1):
      ARC: stack unwinding: avoid indefinite looping

Vladimir Oltean (1):
      tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words, like LS1028A

YueHaibing (1):
      sfp: Fix error handing in sfp_probe()

Zhang Qilong (1):
      ACPI: NFIT: Fix comparison to '-ENXIO'

Ziyi Cao (1):
      USB: serial: option: add Quectel EC200T module support

Zqiang (1):
      kthread_worker: prevent queuing delayed work from timer_fn when it is being canceled

kiyin(尹亮) (1):
      perf/core: Fix a memory leak in perf_event_parse_addr_filter()

wenxu (1):
      ip_tunnel: fix over-mtu packet send fail without TUNNEL_DONT_FRAGMENT flags

zhenwei pi (1):
      nvme-rdma: handle unexpected nvme completion data length

