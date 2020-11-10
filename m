Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315062AD96C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 15:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730070AbgKJO4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 09:56:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732044AbgKJO4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 09:56:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F04E72076E;
        Tue, 10 Nov 2020 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020201;
        bh=OcVq2ldqdVduMRXoyO0LC3FghXPveIBzJLD9BJzl6Gw=;
        h=From:To:Cc:Subject:Date:From;
        b=LiBSwBYw7GYtbKidmFkjx72VZOiM9C3HhU2cmpeSsC5xja+9LsZk7XR8XdZx9Gdwb
         UTTIXJVLXPGy5LccD6+XMnMYaq8OnSvpDH0zRrEYEmYtS/xKI7V+MLitpcf/9bbL58
         rAtwx6cNWYekYty6wJlHONTSfJG9wG8lXe/+DozE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.9.7
Date:   Tue, 10 Nov 2020 15:57:28 +0100
Message-Id: <160502024823596@kroah.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.9.7 kernel.

All users of the 5.9 kernel series must upgrade.

The updated 5.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                     |    2 
 arch/arc/kernel/stacktrace.c                                 |    7 
 arch/arm/boot/dts/mmp3.dtsi                                  |    2 
 arch/arm/boot/dts/sun4i-a10.dtsi                             |    2 
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi                   |    2 
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi            |    6 
 arch/arm64/boot/dts/amlogic/meson-gx.dtsi                    |    3 
 arch/arm64/kernel/smp.c                                      |    1 
 arch/powerpc/kernel/head_40x.S                               |    8 
 arch/powerpc/kernel/head_8xx.S                               |   14 
 arch/s390/include/asm/pgtable.h                              |   52 +-
 arch/s390/pci/pci_event.c                                    |    4 
 arch/x86/kernel/kexec-bzimage64.c                            |    3 
 arch/x86/lib/memcpy_64.S                                     |    4 
 arch/x86/lib/memmove_64.S                                    |    4 
 arch/x86/lib/memset_64.S                                     |    4 
 block/blk-cgroup.c                                           |   15 
 drivers/acpi/nfit/core.c                                     |    2 
 drivers/base/core.c                                          |    6 
 drivers/base/dd.c                                            |    9 
 drivers/base/power/runtime.c                                 |   57 +--
 drivers/crypto/chelsio/chtls/chtls_cm.c                      |    2 
 drivers/crypto/chelsio/chtls/chtls_hw.c                      |    3 
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c                      |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c                      |    1 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                       |    4 
 drivers/gpu/drm/amd/amdgpu/nv.c                              |   14 
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c        |    3 
 drivers/gpu/drm/amd/display/dc/gpio/dcn30/hw_factory_dcn30.c |   12 
 drivers/gpu/drm/i915/Kconfig.debug                           |    1 
 drivers/gpu/drm/i915/display/intel_ddi.c                     |    2 
 drivers/gpu/drm/i915/display/intel_display.c                 |   12 
 drivers/gpu/drm/i915/display/intel_psr.c                     |    2 
 drivers/gpu/drm/i915/gem/i915_gem_context.c                  |   48 --
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c               |    7 
 drivers/gpu/drm/i915/gem/i915_gem_pages.c                    |   30 +
 drivers/gpu/drm/i915/gem/i915_gem_stolen.c                   |    6 
 drivers/gpu/drm/i915/gem/i915_gem_stolen.h                   |    2 
 drivers/gpu/drm/i915/gt/intel_engine.h                       |    9 
 drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c             |  106 +++--
 drivers/gpu/drm/i915/gt/intel_lrc.c                          |   35 +
 drivers/gpu/drm/i915/gt/intel_mocs.c                         |   16 
 drivers/gpu/drm/i915/gt/intel_timeline.c                     |   18 -
 drivers/gpu/drm/i915/gt/intel_timeline_types.h               |    2 
 drivers/gpu/drm/i915/gt/selftest_reset.c                     |  196 +++++++++++
 drivers/gpu/drm/i915/i915_cmd_parser.c                       |   10 
 drivers/gpu/drm/i915/i915_drv.h                              |    4 
 drivers/gpu/drm/i915/i915_gpu_error.c                        |    6 
 drivers/gpu/drm/i915/i915_pci.c                              |    1 
 drivers/gpu/drm/i915/i915_request.c                          |    5 
 drivers/gpu/drm/i915/intel_uncore.c                          |   27 +
 drivers/gpu/drm/nouveau/dispnv50/core.h                      |    2 
 drivers/gpu/drm/nouveau/dispnv50/core507d.c                  |   41 ++
 drivers/gpu/drm/nouveau/dispnv50/core907d.c                  |   36 +-
 drivers/gpu/drm/nouveau/dispnv50/core917d.c                  |    2 
 drivers/gpu/drm/nouveau/include/nvhw/class/cl507d.h          |    5 
 drivers/gpu/drm/nouveau/include/nvhw/class/cl907d.h          |    4 
 drivers/gpu/drm/nouveau/nouveau_connector.c                  |   36 --
 drivers/gpu/drm/nouveau/nouveau_dp.c                         |   21 -
 drivers/gpu/drm/nouveau/nouveau_gem.c                        |    3 
 drivers/gpu/drm/nouveau/nouveau_svm.c                        |   14 
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c            |   39 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c                      |    4 
 drivers/gpu/drm/panfrost/panfrost_gem.h                      |    2 
 drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c             |   14 
 drivers/gpu/drm/sun4i/sun4i_frontend.c                       |   36 --
 drivers/gpu/drm/sun4i/sun4i_frontend.h                       |    6 
 drivers/gpu/drm/v3d/v3d_gem.c                                |    1 
 drivers/gpu/drm/vc4/vc4_drv.c                                |    1 
 drivers/iommu/intel/iommu.c                                  |    3 
 drivers/mtd/spi-nor/core.c                                   |    5 
 drivers/net/dsa/qca8k.c                                      |    4 
 drivers/net/ethernet/cadence/macb_main.c                     |    3 
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c               |   28 +
 drivers/net/ethernet/freescale/fec.h                         |    6 
 drivers/net/ethernet/freescale/fec_main.c                    |   29 -
 drivers/net/ethernet/freescale/gianfar.c                     |   14 
 drivers/net/ethernet/ibm/ibmvnic.c                           |   36 +-
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c          |    5 
 drivers/net/ethernet/realtek/r8169_main.c                    |   14 
 drivers/net/ethernet/ti/cpsw_ethtool.c                       |    1 
 drivers/net/ethernet/ti/cpsw_priv.c                          |    5 
 drivers/net/phy/sfp.c                                        |    3 
 drivers/net/usb/qmi_wwan.c                                   |    1 
 drivers/nvme/host/rdma.c                                     |    8 
 drivers/nvme/target/core.c                                   |    4 
 drivers/nvme/target/trace.h                                  |   21 -
 drivers/of/of_reserved_mem.c                                 |   13 
 drivers/regulator/core.c                                     |    2 
 drivers/s390/crypto/pkey_api.c                               |   30 -
 drivers/scsi/ibmvscsi/ibmvscsi.c                             |   36 +-
 drivers/scsi/scsi_scan.c                                     |    7 
 drivers/spi/spi-bcm2835.c                                    |   12 
 drivers/staging/vc04_services/vchiq-mmal/mmal-vchiq.c        |   19 -
 drivers/tty/serial/8250/8250_mtk.c                           |    2 
 drivers/tty/serial/Kconfig                                   |    1 
 drivers/tty/serial/serial_txx9.c                             |    3 
 drivers/tty/tty_io.c                                         |    6 
 drivers/tty/vt/vt.c                                          |   24 -
 drivers/usb/cdns3/gadget.h                                   |    2 
 drivers/usb/core/quirks.c                                    |    3 
 drivers/usb/dwc3/ep0.c                                       |    3 
 drivers/usb/mtu3/mtu3_gadget.c                               |    1 
 drivers/usb/serial/cyberjack.c                               |    7 
 drivers/usb/serial/option.c                                  |   10 
 drivers/video/fbdev/hyperv_fb.c                              |    9 
 fs/btrfs/backref.c                                           |   13 
 fs/btrfs/disk-io.c                                           |  139 +++++--
 fs/btrfs/disk-io.h                                           |    3 
 fs/btrfs/qgroup.c                                            |   18 +
 fs/gfs2/glock.c                                              |    3 
 fs/gfs2/inode.c                                              |    3 
 fs/io_uring.c                                                |   26 +
 include/linux/mm.h                                           |    9 
 include/linux/pgtable.h                                      |    4 
 include/linux/pm_runtime.h                                   |    6 
 kernel/entry/common.c                                        |    4 
 kernel/events/core.c                                         |   12 
 kernel/fork.c                                                |   10 
 kernel/futex.c                                               |   16 
 kernel/kthread.c                                             |    3 
 kernel/signal.c                                              |   19 -
 kernel/trace/ring_buffer.c                                   |   58 ++-
 kernel/trace/trace.c                                         |    2 
 kernel/trace/trace.h                                         |   26 +
 kernel/trace/trace_selftest.c                                |    9 
 lib/crc32test.c                                              |    4 
 lib/fonts/font_10x18.c                                       |    2 
 lib/fonts/font_6x10.c                                        |    2 
 lib/fonts/font_6x11.c                                        |    2 
 lib/fonts/font_7x14.c                                        |    2 
 lib/fonts/font_8x16.c                                        |    2 
 lib/fonts/font_8x8.c                                         |    2 
 lib/fonts/font_acorn_8x8.c                                   |    2 
 lib/fonts/font_mini_4x6.c                                    |    2 
 lib/fonts/font_pearl_8x8.c                                   |    2 
 lib/fonts/font_sun12x22.c                                    |    2 
 lib/fonts/font_sun8x16.c                                     |    2 
 lib/fonts/font_ter16x32.c                                    |    2 
 mm/hugetlb.c                                                 |   20 -
 mm/mempolicy.c                                               |    6 
 net/core/dev.c                                               |    2 
 net/ipv4/ip_tunnel.c                                         |    3 
 net/ipv6/ip6_tunnel.c                                        |    4 
 net/mac80211/tx.c                                            |    7 
 net/mptcp/token.c                                            |    2 
 net/openvswitch/datapath.c                                   |   14 
 net/openvswitch/flow_table.c                                 |    2 
 net/sctp/sm_sideeffect.c                                     |    4 
 net/tipc/core.c                                              |    5 
 net/vmw_vsock/af_vsock.c                                     |    2 
 sound/pci/hda/patch_realtek.c                                |   67 +++
 sound/usb/pcm.c                                              |    6 
 sound/usb/quirks.c                                           |    1 
 tools/perf/ui/browsers/hists.c                               |    2 
 155 files changed, 1360 insertions(+), 637 deletions(-)

Alan Stern (1):
      USB: Add NO_LPM quirk for Kingston flash drive

Alexander Aring (1):
      gfs2: Wake up when sd_glock_disposal becomes zero

Alexander Ovechkin (1):
      ip6_tunnel: set inner ipproto before ip6_tnl_encap

Alexander Sverdlin (1):
      mtd: spi-nor: Don't copy self-pointing struct around

Anand Moon (1):
      arm64: dts: amlogic: add missing ethernet reset ID

Andreas Gruenbacher (1):
      gfs2: Don't call cancel_delayed_work_sync from within delete work function

Artem Lapkin (1):
      ALSA: usb-audio: add usb vendor id as DSD-capable for Khadas devices

Ayaz A Siddiqui (1):
      drm/i915/gt: Initialize reserved and unspecified MOCS indices

Boris Brezillon (1):
      drm/panfrost: Fix a deadlock between the shrinker and madvise path

Camelia Groza (2):
      dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
      dpaa_eth: fix the RX headroom size alignment

Chaitanya Kulkarni (1):
      nvmet: fix a NULL pointer dereference when tracing the flush command

Chris Wilson (13):
      drm/i915/gem: Avoid implicit vmap for highmem on x86-32
      drm/i915/gem: Prevent using pgprot_writecombine() if PAT is not supported
      drm/i915/gem: Always test execution status on closing the context
      drm/i915/gt: Always send a pulse down the engine after disabling heartbeat
      drm/i915: Break up error capture compression loops with cond_resched()
      drm/i915: Cancel outstanding work after disabling heartbeats on an engine
      drm/i915: Avoid mixing integer types during batch copies
      drm/i915/gt: Undo forced context restores after trivial preemptions
      drm/i915/gt: Delay execlist processing for tgl
      drm/i915: Drop runtime-pm assert from vgpu io accessors
      drm/i915: Exclude low pages (128KiB) of stolen from use
      drm/i915: Use the active reference on the vma while capturing
      drm/i915/gt: Use the local HWSP offset during submission

Christophe Leroy (2):
      powerpc/8xx: Always fault when _PAGE_ACCESSED is not set
      powerpc/40x: Always fault when _PAGE_ACCESSED is not set

Claire Chang (1):
      serial: 8250_mtk: Fix uart_get_baud_rate warning

Claudiu Manoil (2):
      gianfar: Replace skb_realloc_headroom with skb_cow_head for PTP
      gianfar: Account for Tx PTP timestamp in the skb headroom

Clément Péron (1):
      ARM: dts: sun4i-a10: fix cpu_alert temperature

Dan Carpenter (1):
      drm/v3d: Fix double free in v3d_submit_cl_ioctl()

Daniel Vetter (1):
      vt: Disable KD_FONT_OP_COPY

Daniele Palmas (3):
      net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
      USB: serial: option: add LE910Cx compositions 0x1203, 0x1230, 0x1231
      USB: serial: option: add Telit FN980 composition 0x1055

David Galiffi (1):
      drm/amd/display: Fixed panic during seamless boot.

Davide Caratti (1):
      mptcp: token: fix unititialized variable

Eddy Wu (1):
      fork: fix copy_process(CLONE_PARENT) race with the exiting ->real_parent

Eelco Chaudron (1):
      net: openvswitch: silence suspicious RCU usage warning

Fangrui Song (1):
      x86/lib: Change .weak to SYM_FUNC_START_WEAK for arch/x86/lib/mem*_64.S

Gabriel Krisman Bertazi (2):
      blk-cgroup: Fix memleak on error path
      blk-cgroup: Pre-allocate tree node on blkg_conf_prep

Geoffrey D. Bennett (2):
      ALSA: usb-audio: Add implicit feedback quirk for Qu-16
      ALSA: usb-audio: Add implicit feedback quirk for MODX

Gerald Schaefer (1):
      s390/mm: make pmd/pud_deref() large page aware

Greg Kroah-Hartman (1):
      Linux 5.9.7

Greg Ungerer (1):
      net: fec: fix MDIO probing for some FEC hardware blocks

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: disable PTPv1 hw timestamping advertisement

Harald Freudenberger (1):
      s390/pkey: fix paes selftest failure with paes and pkey static build

Heiner Kallweit (1):
      r8169: work around short packet hw bug on RTL8125

Hoang Huu Le (1):
      tipc: fix use-after-free in tipc_bcast_get_mode

Hoegeun Kwon (1):
      drm/vc4: drv: Add error handding for bind

Imre Deak (1):
      drm/i915: Fix encoder lookup during PSR atomic check

Jason Gunthorpe (1):
      mm: always have io_remap_pfn_range() set pgprot_decrypted()

Jeff Vander Stoep (1):
      vsock: use ns_capable_noaudit() on socket create

Johan Hovold (1):
      USB: serial: cyberjack: fix write-URB completion race

John Clements (1):
      drm/amdgpu: resolved ASD loading issue on sienna

Jonathan McDowell (1):
      net: dsa: qca8k: Fix port MTU setting

Josef Bacik (2):
      btrfs: drop the path before adding qgroup items when enabling qgroups
      btrfs: add a helper to read the tree_root commit root for backref lookup

Kailang Yang (2):
      ALSA: hda/realtek - Fixed HP headset Mic can't be detected
      ALSA: hda/realtek - Enable headphone for ASUS TM420

Kairui Song (2):
      x86/kexec: Use up-to-dated screen_info copy to fill boot params
      hyperv_fb: Update screen_info after removing old framebuffer

Karol Herbst (2):
      drm/nouveau/device: fix changing endianess code to work on older GPUs
      drm/nouveau/gem: fix "refcount_t: underflow; use-after-free"

Keith Winstein (1):
      ALSA: usb-audio: Add implicit feedback quirk for Zoom UAC-2

Lee Jones (1):
      Fonts: Replace discarded const qualifier

Likun Gao (1):
      drm/amdgpu: update golden setting for sienna_cichlid

Lu Baolu (1):
      iommu/vt-d: Fix kernel NULL pointer dereference in find_domain()

Lubomir Rintel (1):
      ARM: dts: mmp3: Add power domain for the camera

Lucas Stach (1):
      tty: serial: imx: enable earlycon by default if IMX_SERIAL_CONSOLE is enabled

Lyude Paul (3):
      drm/nouveau/kms/nv50-: Program notifier offset before requesting disp caps
      drm/nouveau/kms/nv50-: Get rid of bogus nouveau_conn_mode_valid()
      drm/nouveau/kms/nv50-: Fix clock checking algorithm in nv50_dp_mode_valid()

Macpaul Lin (1):
      usb: mtu3: fix panic in mtu3_gadget_stop()

Mark Deneen (1):
      cadence: force nonlinear buffers to be cloned

Martin Blumenstingl (1):
      arm64: dts: amlogic: meson-g12: use the G12A specific dwmac compatible

Martin Hundebøll (1):
      spi: bcm2835: fix gpio cs level inversion

Martin Leung (1):
      drm/amd/display: adding ddc_gpio_vga_reg_list to ddc reg def'ns

Mathy Vanhoef (1):
      mac80211: fix regression where EAPOL frames were sent in plaintext

Matthias Reichl (1):
      tty: fix crash in release_tty if tty->port is not set

Maxime Ripard (3):
      drm/sun4i: frontend: Rework a bit the phase data
      drm/sun4i: frontend: Reuse the ch0 phase for RGB formats
      drm/sun4i: frontend: Fix the scaler phase on A33

Michał Mirosław (1):
      regulator: defer probe when trying to get voltage from unresolved supply

Mike Galbraith (1):
      futex: Handle transient "ownerless" rtmutex state correctly

Mike Kravetz (1):
      hugetlb_cgroup: fix reservation accounting

Ming Lei (1):
      scsi: core: Don't start concurrent async scan on same host

Niklas Schnelle (1):
      s390/pci: fix hot-plug of PCI function missing bus

Oleg Nesterov (1):
      ptrace: fix task_join_group_stop() for the case when current is traced

Pavel Begunkov (2):
      io_uring: don't miss setting IO_WQ_WORK_CONCURRENT
      io_uring: fix link lookup racing with link timeout

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

Scott K Logan (1):
      arm64: dts: meson: add missing g12 rng clock

Seung-Woo Kim (1):
      staging: mmal-vchiq: Fix memory leak for vchiq_instance

Shannon Nelson (1):
      ionic: check port ptr before use

Shijie Luo (1):
      mm: mempolicy: fix potential pte_unmap_unlock pte error

Song Liu (1):
      perf hists browser: Increase size of 'buf' in perf_evsel__hists_browse()

Steven Rostedt (VMware) (3):
      ring-buffer: Fix recursion protection transitions between interrupt context
      ftrace: Fix recursion check for NMI test
      ftrace: Handle tracing when switching between context

Sukadev Bhattiprolu (1):
      powerpc/vnic: Extend "failover pending" window

Taehee Yoo (1):
      net: core: use list_del_init() instead of list_del() in netdev_run_todo()

Thinh Nguyen (1):
      usb: dwc3: ep0: Fix delay status handling

Thomas Gleixner (1):
      entry: Fix the incorrect ordering of lockdep and RCU check

Tianci.Yin (2):
      drm/amdgpu: disable DCN and VCN for navi10 blockchain SKU(v3)
      drm/amdgpu: add DID for navi10 blockchain SKU

Tyrel Datwyler (1):
      scsi: ibmvscsi: Fix potential race after loss of transport

Vasily Gorbik (1):
      lib/crc32test: remove extra local_irq_disable/enable

Ville Syrjälä (4):
      drm/i915: Fix TGL DKL PHY DP vswing handling
      drm/i915: Mark ininitial fb obj as WT on eLLC machines to avoid rcu lockup during fbdev init
      drm/i915: Reject 90/270 degree rotated initial fbs
      drm/i915: Restore ILK-M RPS support

Vinay Kumar Yadav (2):
      chelsio/chtls: fix memory leaks caused by a race
      chelsio/chtls: fix always leaking ctrl_skb

Vincent Whitchurch (1):
      of: Fix reserved-memory overlap detection

Vineet Gupta (1):
      ARC: stack unwinding: avoid indefinite looping

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

