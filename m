Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2A1F16B3
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 14:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKFNIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 08:08:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfKFNIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 08:08:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76F702187F;
        Wed,  6 Nov 2019 13:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573045679;
        bh=+lPt7sLYRZgMKwWvz+LW79A41dudicinsUjvBaGSe24=;
        h=Date:From:To:Cc:Subject:From;
        b=c5cO9RfQjXaEEYk3+lCIz85Aru5ZgARoRAhG4q+gXFalA5yj1iF+essUABJCisIVn
         +v87i7sSIwcKWCUy9hBwYOnFasizdDs76ynoeQf63dxtEbT3YQ1TicKAUqfP7uDpEx
         0oebFNxWg9SQOdGl5sKVRR4CtuEfHUOBY65chyrM=
Date:   Wed, 6 Nov 2019 14:07:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.9
Message-ID: <20191106130756.GA3259103@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.9 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt          |    4=20
 Documentation/scheduler/sched-bwc.rst                    |   74 +++-
 Makefile                                                 |    2=20
 arch/arc/kernel/perf_event.c                             |    4=20
 arch/arm64/Kconfig                                       |    2=20
 arch/arm64/Makefile                                      |   22 -
 arch/arm64/boot/dts/qcom/Makefile                        |    3=20
 arch/arm64/boot/dts/qcom/msm8998-asus-novago-tp370ql.dts |   47 ++
 arch/arm64/boot/dts/qcom/msm8998-clamshell.dtsi          |  240 ++++++++++=
++++
 arch/arm64/boot/dts/qcom/msm8998-hp-envy-x2.dts          |   30 +
 arch/arm64/boot/dts/qcom/msm8998-lenovo-miix-630.dts     |   30 +
 arch/arm64/include/asm/pgtable-prot.h                    |   15=20
 arch/arm64/include/asm/vdso/compat_barrier.h             |    2=20
 arch/arm64/kernel/armv8_deprecated.c                     |    5=20
 arch/arm64/kernel/cpu_errata.c                           |    1=20
 arch/arm64/kernel/cpufeature.c                           |    1=20
 arch/arm64/kernel/entry.S                                |    1=20
 arch/arm64/kernel/ftrace.c                               |   12=20
 arch/arm64/kernel/vdso32/Makefile                        |   17 -
 arch/mips/fw/sni/sniprom.c                               |    2=20
 arch/mips/include/asm/cmpxchg.h                          |    9=20
 arch/powerpc/platforms/powernv/smp.c                     |   53 ++-
 arch/riscv/kernel/traps.c                                |   14=20
 arch/s390/include/asm/uaccess.h                          |    4=20
 arch/s390/include/asm/unwind.h                           |    1=20
 arch/s390/kernel/idle.c                                  |   29 +
 arch/s390/kernel/unwind_bc.c                             |   18 -
 arch/s390/mm/cmm.c                                       |   12=20
 arch/s390/pci/pci_irq.c                                  |    2=20
 arch/um/drivers/ubd_kern.c                               |    8=20
 arch/x86/events/amd/core.c                               |   30 +
 arch/x86/include/asm/intel-family.h                      |    3=20
 arch/x86/kvm/svm.c                                       |   10=20
 arch/x86/kvm/vmx/vmx.c                                   |   14=20
 arch/x86/platform/efi/efi.c                              |    3=20
 arch/x86/xen/enlighten.c                                 |   28 +
 drivers/block/nbd.c                                      |   25 +
 drivers/dma/imx-sdma.c                                   |    8=20
 drivers/dma/qcom/bam_dma.c                               |   19 +
 drivers/dma/tegra210-adma.c                              |    7=20
 drivers/dma/ti/cppi41.c                                  |   21 +
 drivers/firmware/efi/cper.c                              |    2=20
 drivers/gpio/gpio-max77620.c                             |    6=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c              |   14=20
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c                   |    2=20
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c                 |    9=20
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c                  |    9=20
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c                   |    1=20
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c       |    4=20
 drivers/gpu/drm/i915/display/intel_display.c             |   11=20
 drivers/gpu/drm/i915/display/intel_dpll_mgr.c            |   15=20
 drivers/gpu/drm/i915/i915_drv.h                          |    2=20
 drivers/hid/hid-axff.c                                   |   11=20
 drivers/hid/hid-core.c                                   |    7=20
 drivers/hid/hid-dr.c                                     |   12=20
 drivers/hid/hid-emsff.c                                  |   12=20
 drivers/hid/hid-gaff.c                                   |   12=20
 drivers/hid/hid-holtekff.c                               |   12=20
 drivers/hid/hid-hyperv.c                                 |   56 ---
 drivers/hid/hid-lg2ff.c                                  |   12=20
 drivers/hid/hid-lg3ff.c                                  |   11=20
 drivers/hid/hid-lg4ff.c                                  |   11=20
 drivers/hid/hid-lgff.c                                   |   11=20
 drivers/hid/hid-logitech-hidpp.c                         |  248 ++++++++--=
-----
 drivers/hid/hid-microsoft.c                              |   12=20
 drivers/hid/hid-sony.c                                   |   12=20
 drivers/hid/hid-tmff.c                                   |   12=20
 drivers/hid/hid-zpff.c                                   |   12=20
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                 |   19 +
 drivers/iio/accel/bmc150-accel-core.c                    |    2=20
 drivers/iio/adc/meson_saradc.c                           |   10=20
 drivers/iio/imu/adis_buffer.c                            |   10=20
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c             |    4=20
 drivers/infiniband/core/cm.c                             |    3=20
 drivers/infiniband/core/cma.c                            |    3=20
 drivers/infiniband/core/nldev.c                          |   12=20
 drivers/infiniband/hw/cxgb4/device.c                     |    7=20
 drivers/infiniband/hw/cxgb4/qp.c                         |   10=20
 drivers/infiniband/hw/hfi1/sdma.c                        |    5=20
 drivers/infiniband/hw/hfi1/tid_rdma.c                    |    5=20
 drivers/infiniband/hw/mlx5/devx.c                        |   58 ---
 drivers/infiniband/hw/mlx5/mlx5_ib.h                     |    1=20
 drivers/infiniband/hw/mlx5/mr.c                          |   32 +
 drivers/infiniband/sw/siw/siw_qp.c                       |   15=20
 drivers/iommu/intel-iommu.c                              |    2=20
 drivers/md/dm-snap.c                                     |   94 ++++-
 drivers/misc/fastrpc.c                                   |    1=20
 drivers/net/bonding/bond_main.c                          |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/mr.c             |    8=20
 drivers/net/usb/sr9800.c                                 |    2=20
 drivers/net/wireless/ath/ath10k/core.c                   |   15=20
 drivers/net/wireless/ath/ath6kl/usb.c                    |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c              |   16=20
 drivers/net/wireless/realtek/rtlwifi/pci.c               |    3=20
 drivers/net/wireless/realtek/rtlwifi/ps.c                |    6=20
 drivers/net/wireless/realtek/rtw88/rtw8822b.c            |    2=20
 drivers/nfc/pn533/usb.c                                  |    9=20
 drivers/nvme/host/core.c                                 |  108 ------
 drivers/s390/cio/cio.h                                   |    1=20
 drivers/s390/cio/css.c                                   |    7=20
 drivers/s390/cio/device.c                                |    2=20
 drivers/scsi/qla2xxx/qla_attr.c                          |    7=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c              |    6=20
 drivers/target/iscsi/cxgbit/cxgbit_cm.c                  |    3=20
 drivers/thunderbolt/nhi.c                                |   22 +
 drivers/thunderbolt/tunnel.c                             |    4=20
 drivers/tty/n_hdlc.c                                     |    5=20
 drivers/tty/serial/8250/8250_omap.c                      |    5=20
 drivers/tty/serial/Kconfig                               |    1=20
 drivers/tty/serial/owl-uart.c                            |    2=20
 drivers/tty/serial/rda-uart.c                            |    2=20
 drivers/tty/serial/serial_mctrl_gpio.c                   |    3=20
 drivers/usb/gadget/udc/core.c                            |   11=20
 drivers/usb/host/xhci-debugfs.c                          |   24 -
 drivers/usb/host/xhci-ring.c                             |    2=20
 drivers/usb/host/xhci.c                                  |   54 ++-
 drivers/usb/misc/ldusb.c                                 |    6=20
 drivers/usb/misc/legousbtower.c                          |    2=20
 drivers/usb/serial/whiteheat.c                           |   13=20
 drivers/usb/serial/whiteheat.h                           |    2=20
 drivers/usb/storage/scsiglue.c                           |   10=20
 drivers/usb/storage/uas.c                                |   20 -
 drivers/virt/vboxguest/vboxguest_utils.c                 |    3=20
 drivers/virtio/virtio_ring.c                             |    7=20
 fs/btrfs/ctree.h                                         |    3=20
 fs/btrfs/delalloc-space.c                                |    6=20
 fs/btrfs/file.c                                          |    7=20
 fs/btrfs/inode-map.c                                     |    5=20
 fs/btrfs/inode.c                                         |   12=20
 fs/btrfs/ioctl.c                                         |    6=20
 fs/btrfs/relocation.c                                    |    9=20
 fs/btrfs/send.c                                          |    2=20
 fs/cifs/netmisc.c                                        |    4=20
 fs/fuse/dir.c                                            |   13=20
 fs/fuse/file.c                                           |   10=20
 fs/io_uring.c                                            |   58 ++-
 fs/nfs/delegation.c                                      |    2=20
 fs/nfs/nfs4proc.c                                        |    1=20
 fs/nfs/write.c                                           |    5=20
 fs/ocfs2/aops.c                                          |   25 +
 fs/ocfs2/ioctl.c                                         |    2=20
 fs/ocfs2/xattr.c                                         |   56 +--
 include/linux/platform_data/dma-imx-sdma.h               |    3=20
 include/linux/sunrpc/xprtsock.h                          |    1=20
 include/net/llc_conn.h                                   |    2=20
 include/net/sch_generic.h                                |    5=20
 include/trace/events/rxrpc.h                             |    6=20
 include/uapi/linux/nvme_ioctl.h                          |   23 -
 kernel/events/core.c                                     |   45 ++
 kernel/sched/cputime.c                                   |    6=20
 kernel/sched/fair.c                                      |  127 ++-----
 kernel/sched/sched.h                                     |    4=20
 kernel/trace/trace.c                                     |    1=20
 net/batman-adv/bat_iv_ogm.c                              |   61 +++
 net/batman-adv/hard-interface.c                          |    2=20
 net/batman-adv/types.h                                   |    3=20
 net/llc/llc_c_ac.c                                       |    8=20
 net/llc/llc_conn.c                                       |   32 -
 net/llc/llc_s_ac.c                                       |   12=20
 net/llc/llc_sap.c                                        |   23 -
 net/netfilter/nf_conntrack_core.c                        |    4=20
 net/rxrpc/peer_object.c                                  |   16=20
 net/rxrpc/sendmsg.c                                      |    1=20
 net/sched/sch_netem.c                                    |    2=20
 net/sched/sch_sfb.c                                      |    7=20
 net/sunrpc/xprtsock.c                                    |   17 -
 net/wireless/nl80211.c                                   |    2=20
 sound/core/timer.c                                       |   24 +
 sound/firewire/bebob/bebob_stream.c                      |    3=20
 sound/hda/hdac_controller.c                              |    2=20
 sound/pci/hda/hda_intel.c                                |    2=20
 sound/pci/hda/patch_realtek.c                            |   11=20
 sound/usb/quirks.c                                       |   13=20
 tools/lib/subcmd/Makefile                                |    8=20
 tools/perf/arch/arm/annotate/instructions.c              |    4=20
 tools/perf/arch/arm64/annotate/instructions.c            |    4=20
 tools/perf/arch/powerpc/util/header.c                    |    3=20
 tools/perf/arch/s390/annotate/instructions.c             |    6=20
 tools/perf/arch/s390/util/header.c                       |    9=20
 tools/perf/arch/x86/annotate/instructions.c              |    6=20
 tools/perf/arch/x86/util/header.c                        |    3=20
 tools/perf/builtin-kvm.c                                 |    7=20
 tools/perf/builtin-script.c                              |    6=20
 tools/perf/pmu-events/jevents.c                          |   12=20
 tools/perf/tests/perf-hooks.c                            |    3=20
 tools/perf/util/annotate.c                               |   35 +-
 tools/perf/util/annotate.h                               |    4=20
 tools/perf/util/map.c                                    |    3=20
 tools/testing/selftests/Makefile                         |    4=20
 tools/testing/selftests/kselftest/runner.sh              |   36 +-
 tools/testing/selftests/rtc/settings                     |    1=20
 191 files changed, 1901 insertions(+), 1013 deletions(-)

Aaron Ma (1):
      ALSA: hda/realtek - Fix 2 front mics of codec 0x623

Adam Ford (2):
      serial: mctrl_gpio: Check for NULL pointer
      serial: 8250_omap: Fix gpio check for auto RTS/CTS

Alan Stern (4):
      UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gathe=
r segments")
      USB: gadget: Reject endpoints with 0 maxpacket value
      usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_bound=
ary_mask to avoid SG overflows")
      HID: Fix assumption that devices have inputs

Alex Deucher (1):
      drm/amdgpu/gmc10: properly set BANK_SELECT and FRAGMENT_SIZE

Alexey Brodkin (1):
      ARC: perf: Accommodate big-endian CPU

Andi Kleen (2):
      perf script brstackinsn: Fix recovery from LBR/binary mismatch
      perf jevents: Fix period for Intel fixed counters

Andrey Smirnov (3):
      HID: logitech-hidpp: split g920_get_config()
      HID: logitech-hidpp: rework device validation
      HID: logitech-hidpp: do all FF cleanup in hidpp_ff_destroy()

Anton Ivanov (1):
      um-ubd: Entrust re-queue to the upper layers

Arnaldo Carvalho de Melo (7):
      perf tools: Propagate get_cpuid() error
      perf annotate: Propagate perf_env__arch() error
      perf annotate: Fix the signedness of failure returns
      perf annotate: Propagate the symbol__annotate() error return
      perf annotate: Fix arch specific ->init() failure errors
      perf annotate: Return appropriate error code for allocation failures
      perf annotate: Don't return -1 for error when doing BPF disassembly

Austin Kim (2):
      fs: cifs: mute -Wunused-const-variable message
      btrfs: silence maybe-uninitialized warning in clone_range

Bart Van Assche (2):
      RDMA/iwcm: Fix a lock inversion issue
      scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Ben Dooks (Codethink) (1):
      usb: xhci: fix __le32/__le64 accessors in debugfs code

Benjamin Coddington (1):
      SUNRPC: fix race to sk_err after xs_error_report

Bjorn Andersson (1):
      arm64: cpufeature: Enable Qualcomm Falkor/Kryo errata 1003

Boris Ostrovsky (1):
      x86/xen: Return from panic notifier

Catalin Marinas (1):
      arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default

Christian Borntraeger (1):
      s390/uaccess: avoid (false positive) compiler warnings

Christoph Hellwig (1):
      serial/sifive: select SERIAL_EARLYCON

Christophe JAILLET (3):
      tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'
      tty: serial: rda: Fix the link time qualifier of 'rda_uart_exit()'
      RDMA/core: Fix an error handling path in 'res_get_common_doit()'

Chuck Lever (1):
      NFSv4: Fix leak of clp->cl_acceptor string

Connor Kuehl (1):
      staging: rtl8188eu: fix null dereference when kzalloc fails

Cristian Marussi (1):
      kselftest: exclude failed TARGETS from runlist

Dan Carpenter (1):
      USB: legousbtower: fix a signedness bug in tower_probe()

Dave Chiluk (1):
      sched/fair: Fix low cpu usage with high throttling by removing expira=
tion of cpu-local slices

Dave Young (1):
      efi/x86: Do not clean dummy variable in kexec path

David Howells (3):
      rxrpc: Fix call ref leak
      rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record
      rxrpc: Fix trace-after-put looking at the put peer record

Dexuan Cui (1):
      HID: hyperv: Use in-place iterator API in the channel callback

Eric Biggers (2):
      llc: fix sk_buff leak in llc_sap_state_process()
      llc: fix sk_buff leak in llc_conn_service()

Eric Dumazet (3):
      bonding: fix potential NULL deref in bond_update_slave_arr
      netfilter: conntrack: avoid possible false sharing
      sch_netem: fix rcu splat in netem_enqueue()

Filipe Manana (1):
      Btrfs: fix inode cache block reserve leak on failure to allocate data=
 space

Frederic Weisbecker (1):
      sched/vtime: Fix guest/system mis-accounting on task switch

Greg Kroah-Hartman (1):
      Linux 5.3.9

Gustavo A. R. Silva (1):
      perf annotate: Fix multiple memory and file descriptor leaks

Halil Pasic (1):
      s390/cio: fix virtio-ccw DMA without PV

Hans de Goede (1):
      HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Heiko Carstens (1):
      s390/idle: fix cpu idle time calculation

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Ian Rogers (2):
      libsubcmd: Make _FORTIFY_SOURCE defines dependent on the feature
      perf tests: Avoid raising SEGV using an obvious NULL dereference

Ilya Leoshkevich (1):
      s390/unwind: fix mixing regs and sp

Jack Morgenstein (1):
      RDMA/cm: Fix memory leak in cm_add/remove_one

James Morse (2):
      arm64: Fix incorrect irqflag restore for priority masking for compat
      arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1=
542419

Jason Gunthorpe (4):
      RDMA/mlx5: Do not allow rereg of a ODP MR
      RDMA/mlx5: Order num_pending_prefetch properly with synchronize_srcu
      RDMA/mlx5: Add missing synchronize_srcu() for MW cases
      RDMA/mlx5: Use irq xarray locking for mkey_table

Jeffrey Hugo (4):
      arm64: dts: qcom: Add Lenovo Miix 630
      arm64: dts: qcom: Add HP Envy x2
      arm64: dts: qcom: Add Asus NovaGo TP370QL
      dmaengine: qcom: bam_dma: Fix resource leak

Jens Axboe (2):
      io_uring: fix up O_NONBLOCK handling for sockets
      io_uring: ensure we clear io_kiocb->result before each issue

Jia Guo (1):
      ocfs2: clear zero in unaligned direct IO

Jia-Ju Bai (3):
      fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare=
_entry()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end=
_nolock()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan=
_inode_alloc()

Joe Perches (1):
      rtw88: Fix misuse of GENMASK macro

Johan Hovold (5):
      USB: ldusb: fix ring-buffer locking
      USB: ldusb: fix control-message timeout
      USB: serial: whiteheat: fix potential slab corruption
      USB: serial: whiteheat: fix line-speed endianness
      NFC: pn533: fix use-after-free and memleaks

John Donnelly (1):
      iommu/vt-d: Fix panic after kexec -p for kdump

Julien Grall (1):
      arm64: cpufeature: Effectively expose FRINT capability to userspace

Jussi Laako (2):
      ALSA: usb-audio: DSD auto-detection for Playback Designs
      ALSA: usb-audio: Update DSD support quirks for Oppo and Rotel

Justin Song (1):
      ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB Interface

Kaike Wan (1):
      IB/hfi1: Avoid excessive retry for TID RDMA READ request

Kailang Yang (1):
      ALSA: hda/realtek - Add support for ALC623

Kan Liang (1):
      x86/cpu: Add Comet Lake to the Intel CPU models header

Kees Cook (1):
      selftests/kselftest/runner.sh: Add 45 second timeout per test

Krishnamraju Eraparaju (1):
      RDMA/siw: Fix serialization issue in write_space()

Larry Finger (1):
      rtlwifi: rtl_pci: Fix problem of too small skb->len

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Leon Romanovsky (1):
      RDMA/nldev: Reshuffle the code to avoid need to rebind QP in error pa=
th

Lorenzo Bianconi (1):
      iio: imu: st_lsm6dsx: fix waitime for st_lsm6dsx i2c controller

Luca Coelho (1):
      iwlwifi: exclude GEO SAR support for 3168

Lukas Wunner (1):
      efi/cper: Fix endianness of PCIe class code

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Marvin Liu (1):
      virtio_ring: fix stalls for packed rings

Mathias Nyman (1):
      xhci: Fix use-after-free regression in xhci clear hub TT implementati=
on

Miaoqing Pan (1):
      ath10k: fix latency issue for QCA988x

Micha=C5=82 Miros=C5=82aw (1):
      HID: fix error message in hid_open_report()

Mika Westerberg (2):
      thunderbolt: Correct path indices for PCIe tunnel
      thunderbolt: Use 32-bit writes when writing ring producer/consumer

Mike Christie (1):
      nbd: verify socket is supported during setup

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
      fuse: truncate pending writes on O_TRUNC

Mikulas Patocka (2):
      dm snapshot: introduce account_start_copy() and account_end_copy()
      dm snapshot: rework COW throttling to fix deadlock

Navid Emamdoost (5):
      RDMA/hfi1: Prevent memory leak in sdma_init
      misc: fastrpc: prevent memory leak in fastrpc_dma_buf_attach
      iio: imu: adis16400: release allocated memory on failure
      iio: imu: adis16400: fix memory leak
      virt: vbox: fix memory leak in hgcm_call_preprocess_linaddr

Nicholas Piggin (1):
      powerpc/powernv: Fix CPU idle to be called with IRQs disabled

Nirmoy Das (1):
      drm/amdgpu: fix memory leak

Paolo Bonzini (1):
      KVM: vmx, svm: always run with EFER.NXE=3D1 when shadow paging is act=
ive

Pascal Bouwmann (1):
      iio: fix center temperature of bmc150-accel-core

Pelle van Gils (1):
      drm/amdgpu/powerplay/vega10: allow undervolting in p7

Petr Mladek (1):
      tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Potnuri Bharat Teja (1):
      RDMA/iw_cxgb4: fix SRQ access from dump_qp()

Qian Cai (1):
      sched/fair: Fix -Wunused-but-set-variable warnings

Qu Wenruo (1):
      btrfs: qgroup: Always free PREALLOC META reserve in btrfs_delalloc_re=
lease_extents()

Quinn Tran (1):
      scsi: qla2xxx: Fix partial flash write of MBI

Randy Dunlap (1):
      tty: n_hdlc: fix build on SPARC

Remi Pommarel (1):
      iio: adc: meson_saradc: Fix memory allocation order

Robin Gong (1):
      dmaengine: imx-sdma: fix size check for sdma script_number

Sameer Pujar (1):
      dmaengine: tegra210-adma: fix transfer failure

Samuel Holland (1):
      usb: xhci: fix Immediate Data Transfer endianness

Sasha Levin (1):
      Revert "nvme: allow 64-bit results in passthru commands"

Sebastian Ott (1):
      s390/pci: fix MSI message data

Song Liu (2):
      perf/core: Rework memory accounting in perf_mmap()
      perf/core: Fix corner case in perf_rotate_context()

Steve MacLean (1):
      perf map: Fix overlapped map handling

Sven Eckelmann (1):
      batman-adv: Avoid free/alloc race when handling OGM buffer

Takashi Iwai (2):
      ALSA: timer: Fix mutex deadlock at releasing card
      Revert "ALSA: hda: Flush interrupts on disabling"

Takashi Sakamoto (1):
      ALSA: bebob: Fix prototype of helper function to return negative value

Thierry Reding (1):
      gpio: max77620: Use correct unit for debounce times

Thomas Bogendoerfer (3):
      MIPS: include: Mark __cmpxchg as __always_inline
      MIPS: include: Mark __xchg as __always_inline
      MIPS: fw: sni: Fix out of bounds init of o32 stack

Thomas Richter (1):
      perf/aux: Fix tracking of auxiliary trace buffer allocation

Tianci.Yin (1):
      drm/amdgpu/gfx10: update gfx golden settings

Tom Lendacky (1):
      perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp

Tony Lindgren (1):
      dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Trond Myklebust (1):
      NFS: Fix an RCU lock leak in nfs4_refresh_delegation_stateid()

Valentin Vidic (1):
      net: usb: sr9800: fix uninitialized local variable

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Fix PCH reference clock for FDI on HSW/BDW

Vincent Chen (3):
      riscv: avoid kernel hangs when trapped in BUG()
      riscv: avoid sending a SIGTRAP to a user thread trapped in WARN()
      riscv: Correct the handling of unexpected ebreak in do_trap_break()

Vincenzo Frascino (2):
      arm64: vdso32: Fix broken compat vDSO build warnings
      arm64: vdso32: Detect binutils support for dmb ishld

Vlad Buslov (1):
      net: sched: sch_sfb: don't call qdisc_put() while holding tree lock

Will Deacon (2):
      arm64: Default to building compat vDSO with clang when CONFIG_CC_IS_C=
LANG
      arm64: vdso32: Don't use KBUILD_CPPFLAGS unconditionally

Xiubo Li (1):
      nbd: fix possible sysfs duplicate warning

Xuewei Zhang (1):
      sched/fair: Scale bandwidth quota and period without losing quota/per=
iod ratio precision

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()

Yunfeng Ye (1):
      arm64: armv8_deprecated: Checking return value for memory allocation

ZhangXiaoxu (1):
      nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request

chen gong (1):
      drm/amdgpu: Fix SDMA hang when performing VKexample test


--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3CxawACgkQONu9yGCS
aT6ZqBAApR2tyZ2zVWMBV3iKGcmrCSThRkZIrHDqPalVyXvAtBBOGLFj2wyaEuKE
T9cjTvEcL/FrZ2tLHsSVYVxcrpXAqpu6gy4UaKl27SVbfaeJ8K1eI7Ri8Ih4NH/f
uyuRM3HkXJvWEF8715R+pWNZIneyL3GG8Bbx2i7YaNpRjDmF3Fvm2TQTzgI3W5lk
+bTOPBM/2h9j5bPKKLjpK/ky6WTqJIWMhVNBsD9iwcnqUHi7G/pxUKWpPKr5z4UB
szYJlATzZ4n8kxSjj+pKUhxSfmmUiUvxxuNojNYXbR1Mui59bKXvlyTvsGf+7Nnb
y0p0RHKgTPdp97TxEWHN73uPKhRNiUp0oq1rLOhsYDxHTXBtNMsGIbvlEgZHh4uy
LRxo3Tsh+ZJHGsLjC1/nMihZtEIo+QG7ssT1ThRjsBE9tfUyKKEq68i9gUTO9Tjs
XHs4T8URDFB59wv5Q9Qn1EnNED9I9waNIxkx/0D0gyissZpk12Kc1GiWlxi5JcBZ
/R54FS/x8owRBbbsRvCTMzXRH930bU6iKfatjd6pOG7EPjvPqfojz5KRsHGBiCZy
2AnUR0w1sDy4KXy8xPNhIr4fP4hmsF9wfEwiHTOgO9ZRm3XSLzW4QhQ5YFFsuBmb
bdv4cPT44J3c5MEjmZvNGi/YIwPE9vAscpYfcxEFvIjHdLZ9un4=
=9xjM
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
