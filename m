Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B581F16AD
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 14:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfKFNH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 08:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfKFNHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Nov 2019 08:07:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C33D217F4;
        Wed,  6 Nov 2019 13:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573045649;
        bh=aUvuhTtIKZpafjlz1B2n82ACqm2Y3YjFuDHIT0HIGwc=;
        h=Date:From:To:Cc:Subject:From;
        b=nTrK3o8MLalNnwQcKUMmlvXsK0tjBBtDonI/q8jRUF5YL10zS9h1eYGHSasSxoKaU
         Owu8GWKUL1sgs4854RHxP10XiwT2BBCThhvaf392XkSGQhr6UkzbhHM7Po2ZVSV/QP
         eJNVRdN4Hl4SVf4uOaPvdMLR5p2DhRPWTfQft+KA=
Date:   Wed, 6 Nov 2019 14:07:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.82
Message-ID: <20191106130726.GA3251926@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.82 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/admin-guide/kernel-parameters.txt    |    4=20
 Makefile                                           |    2=20
 arch/arm/kernel/head-common.S                      |    5 -
 arch/arm/kernel/head-nommu.S                       |    2=20
 arch/arm/mm/proc-v7m.S                             |    5 -
 arch/arm64/include/asm/cputype.h                   |    4=20
 arch/arm64/include/asm/pgtable-prot.h              |   15 +--
 arch/arm64/kernel/armv8_deprecated.c               |    5 +
 arch/arm64/kernel/cpufeature.c                     |    1=20
 arch/arm64/kernel/ftrace.c                         |   12 ++
 arch/mips/fw/sni/sniprom.c                         |    2=20
 arch/mips/include/asm/cmpxchg.h                    |    9 +-
 arch/powerpc/platforms/powernv/memtrace.c          |    4=20
 arch/powerpc/platforms/powernv/smp.c               |   53 ++++++++----
 arch/s390/include/asm/uaccess.h                    |    4=20
 arch/s390/kernel/idle.c                            |   29 +++++-
 arch/s390/mm/cmm.c                                 |   12 +-
 arch/x86/events/amd/core.c                         |   30 +++----
 arch/x86/include/asm/intel-family.h                |    6 +
 arch/x86/platform/efi/efi.c                        |    3=20
 arch/x86/xen/enlighten.c                           |   28 +++++-
 drivers/block/nbd.c                                |   25 +++++
 drivers/block/zram/zram_drv.c                      |    5 -
 drivers/clk/imgtec/clk-boston.c                    |   18 +++-
 drivers/dma/qcom/bam_dma.c                         |   19 ++++
 drivers/dma/ti/cppi41.c                            |   21 ++++
 drivers/firmware/efi/cper.c                        |    2=20
 drivers/gpio/gpio-max77620.c                       |    6 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c        |   14 +--
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |    6 -
 drivers/gpu/drm/amd/powerplay/hwmgr/vega10_hwmgr.c |    4=20
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   31 ++++---
 drivers/hid/hid-axff.c                             |   11 ++
 drivers/hid/hid-core.c                             |    7 +
 drivers/hid/hid-dr.c                               |   12 ++
 drivers/hid/hid-emsff.c                            |   12 ++
 drivers/hid/hid-gaff.c                             |   12 ++
 drivers/hid/hid-holtekff.c                         |   12 ++
 drivers/hid/hid-hyperv.c                           |   56 ++-----------
 drivers/hid/hid-ids.h                              |    1=20
 drivers/hid/hid-input.c                            |    3=20
 drivers/hid/hid-lg2ff.c                            |   12 ++
 drivers/hid/hid-lg3ff.c                            |   11 ++
 drivers/hid/hid-lg4ff.c                            |   11 ++
 drivers/hid/hid-lgff.c                             |   11 ++
 drivers/hid/hid-logitech-hidpp.c                   |   11 ++
 drivers/hid/hid-sony.c                             |   12 ++
 drivers/hid/hid-steam.c                            |   60 +++++++-------
 drivers/hid/hid-tmff.c                             |   12 ++
 drivers/hid/hid-zpff.c                             |   12 ++
 drivers/hid/i2c-hid/i2c-hid-core.c                 |   11 ++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c           |   35 ++++++++
 drivers/iio/accel/bmc150-accel-core.c              |    2=20
 drivers/iio/adc/meson_saradc.c                     |   10 +-
 drivers/iio/imu/adis_buffer.c                      |    5 -
 drivers/infiniband/core/cma.c                      |    3=20
 drivers/infiniband/hw/hfi1/sdma.c                  |    5 -
 drivers/md/bcache/sysfs.c                          |    4=20
 drivers/md/dm-snap.c                               |   90 ++++++++++++++++=
+----
 drivers/media/platform/vimc/vimc-sensor.c          |    7 -
 drivers/net/bonding/bond_main.c                    |    2=20
 drivers/net/dsa/mv88e6xxx/chip.c                   |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   62 ++++++++++----
 drivers/net/usb/sr9800.c                           |    2=20
 drivers/net/wireless/ath/ath10k/core.c             |    2=20
 drivers/net/wireless/ath/ath6kl/usb.c              |    8 +
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   44 +++-------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   16 ++-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |    6 +
 drivers/nfc/pn533/usb.c                            |    9 +-
 drivers/pci/pcie/pme.c                             |    1=20
 drivers/pci/quirks.c                               |    4=20
 drivers/platform/x86/intel_atomisp2_pm.c           |   69 +++++++++++-----
 drivers/power/supply/max14656_charger_detector.c   |   17 +++
 drivers/rtc/rtc-pcf8523.c                          |   28 ++++--
 drivers/scsi/lpfc/lpfc_nvmet.c                     |    6 +
 drivers/scsi/lpfc/lpfc_nvmet.h                     |    2=20
 drivers/scsi/lpfc/lpfc_scsi.c                      |    2=20
 drivers/staging/mt7621-pinctrl/Kconfig             |    1=20
 drivers/staging/mt7621-pinctrl/pinctrl-rt2880.c    |   41 ---------
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |    6 -
 drivers/target/iscsi/cxgbit/cxgbit_cm.c            |    3=20
 drivers/thunderbolt/nhi.c                          |   22 ++++-
 drivers/tty/n_hdlc.c                               |    5 +
 drivers/tty/serial/owl-uart.c                      |    2=20
 drivers/tty/serial/sc16is7xx.c                     |   28 ++++++
 drivers/tty/serial/serial_mctrl_gpio.c             |    3=20
 drivers/usb/core/hub.c                             |    7 +
 drivers/usb/dwc2/hcd.c                             |   33 ++++++-
 drivers/usb/dwc3/gadget.c                          |   25 ++---
 drivers/usb/gadget/udc/core.c                      |   11 ++
 drivers/usb/host/xhci-debugfs.c                    |   24 ++---
 drivers/usb/misc/ldusb.c                           |    6 -
 drivers/usb/misc/legousbtower.c                    |    2=20
 drivers/usb/serial/whiteheat.c                     |   13 ++-
 drivers/usb/serial/whiteheat.h                     |    2=20
 drivers/usb/storage/scsiglue.c                     |   10 --
 drivers/usb/storage/uas.c                          |   20 ----
 drivers/virt/vboxguest/vboxguest_utils.c           |    3=20
 fs/binfmt_script.c                                 |   57 +++++++++++--
 fs/btrfs/ctree.h                                   |    6 -
 fs/btrfs/extent-tree.c                             |    5 -
 fs/btrfs/file.c                                    |   20 +++-
 fs/btrfs/free-space-cache.c                        |   22 ++++-
 fs/btrfs/inode-map.c                               |    5 -
 fs/btrfs/inode.c                                   |   44 ++++++----
 fs/btrfs/ioctl.c                                   |    6 -
 fs/btrfs/qgroup.c                                  |    4=20
 fs/btrfs/relocation.c                              |    9 --
 fs/cifs/cifssmb.c                                  |    7 -
 fs/cifs/connect.c                                  |   22 +++++
 fs/cifs/netmisc.c                                  |    4=20
 fs/cifs/smb2misc.c                                 |    7 -
 fs/cifs/smb2ops.c                                  |    6 -
 fs/ext4/ioctl.c                                    |    1=20
 fs/f2fs/recovery.c                                 |    3=20
 fs/f2fs/super.c                                    |    6 +
 fs/fuse/dir.c                                      |   13 +++
 fs/fuse/file.c                                     |   10 +-
 fs/nfs/delegation.c                                |    2=20
 fs/nfs/nfs4proc.c                                  |    1=20
 fs/nfs/nfs4state.c                                 |    2=20
 fs/nfs/write.c                                     |    5 -
 fs/ocfs2/aops.c                                    |   25 +++++
 fs/ocfs2/ioctl.c                                   |    2=20
 fs/ocfs2/xattr.c                                   |   56 +++++--------
 include/net/llc_conn.h                             |    2=20
 include/net/sch_generic.h                          |    5 +
 include/trace/events/rxrpc.h                       |    6 -
 kernel/sched/cputime.c                             |    6 -
 kernel/trace/trace.c                               |    1=20
 net/batman-adv/bat_iv_ogm.c                        |   60 +++++++++++---
 net/batman-adv/hard-interface.c                    |    2=20
 net/batman-adv/types.h                             |    3=20
 net/llc/llc_c_ac.c                                 |    8 +
 net/llc/llc_conn.c                                 |   32 ++-----
 net/llc/llc_s_ac.c                                 |   12 ++
 net/llc/llc_sap.c                                  |   23 +----
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |    3=20
 net/netfilter/ipset/ip_set_hash_ipmac.c            |   11 --
 net/rxrpc/peer_object.c                            |   16 ++-
 net/rxrpc/sendmsg.c                                |    1=20
 net/sched/sch_netem.c                              |    2=20
 net/wireless/nl80211.c                             |    3=20
 samples/bpf/bpf_load.c                             |    4=20
 scripts/setlocalversion                            |   12 ++
 sound/core/timer.c                                 |   63 ++++++++------
 sound/firewire/bebob/bebob_stream.c                |    3=20
 sound/hda/hdac_controller.c                        |    2=20
 sound/pci/hda/hda_intel.c                          |    2=20
 sound/pci/hda/patch_realtek.c                      |   39 ++++++++-
 sound/usb/quirks.c                                 |   31 ++-----
 tools/lib/subcmd/Makefile                          |    8 +
 tools/perf/arch/powerpc/util/header.c              |    3=20
 tools/perf/arch/s390/util/header.c                 |    9 +-
 tools/perf/arch/x86/util/header.c                  |    3=20
 tools/perf/builtin-kvm.c                           |    7 -
 tools/perf/builtin-script.c                        |    6 +
 tools/perf/pmu-events/jevents.c                    |   12 +-
 tools/perf/tests/perf-hooks.c                      |    3=20
 tools/perf/util/annotate.c                         |   10 +-
 tools/perf/util/map.c                              |    3=20
 tools/power/x86/turbostat/turbostat.c              |    9 +-
 163 files changed, 1419 insertions(+), 741 deletions(-)

Aaron Ma (1):
      ALSA: hda/realtek - Fix 2 front mics of codec 0x623

Abhishek Ambure (1):
      ath10k: assign 'n_cipher_suites =3D 11' for WCN3990 to enable WPA3

Adam Ford (1):
      serial: mctrl_gpio: Check for NULL pointer

Ahmad Masri (1):
      wil6210: fix freeing of rx buffers in EDMA mode

Alan Stern (4):
      UAS: Revert commit 3ae62a42090f ("UAS: fix alignment of scatter/gathe=
r segments")
      USB: gadget: Reject endpoints with 0 maxpacket value
      usb-storage: Revert commit 747668dbc061 ("usb-storage: Set virt_bound=
ary_mask to avoid SG overflows")
      HID: Fix assumption that devices have inputs

Andi Kleen (2):
      perf script brstackinsn: Fix recovery from LBR/binary mismatch
      perf jevents: Fix period for Intel fixed counters

Andrew Lunn (1):
      net: dsa: mv88e6xxx: Release lock while requesting IRQ

Arnaldo Carvalho de Melo (5):
      perf tools: Propagate get_cpuid() error
      perf annotate: Propagate perf_env__arch() error
      perf annotate: Fix the signedness of failure returns
      perf annotate: Propagate the symbol__annotate() error return
      perf annotate: Return appropriate error code for allocation failures

Austin Kim (1):
      fs: cifs: mute -Wunused-const-variable message

Bart Van Assche (2):
      RDMA/iwcm: Fix a lock inversion issue
      scsi: target: cxgbit: Fix cxgbit_fw4_ack()

Ben Dooks (Codethink) (1):
      usb: xhci: fix __le32/__le64 accessors in debugfs code

Boris Ostrovsky (1):
      x86/xen: Return from panic notifier

Brian Norris (1):
      scripts/setlocalversion: Improve -dirty check with git-status --no-op=
tional-locks

Catalin Marinas (1):
      arm64: Ensure VM_WRITE|VM_SHARED ptes are clean by default

Chao Yu (2):
      f2fs: fix to recover inode's i_gc_failures during POR
      f2fs: fix to recover inode->i_flags of inode block during POR

Christian Borntraeger (1):
      s390/uaccess: avoid (false positive) compiler warnings

Christophe JAILLET (1):
      tty: serial: owl: Fix the link time qualifier of 'owl_uart_exit()'

Chuck Lever (1):
      NFSv4: Fix leak of clp->cl_acceptor string

Coly Li (1):
      bcache: fix input overflow to writeback_rate_minimum

Connor Kuehl (1):
      staging: rtl8188eu: fix null dereference when kzalloc fails

Dan Carpenter (1):
      USB: legousbtower: fix a signedness bug in tower_probe()

Daniel T. Lee (1):
      samples: bpf: fix: seg fault with NULL pointer arg

Dave Young (1):
      efi/x86: Do not clean dummy variable in kexec path

David Hildenbrand (1):
      powerpc/powernv: hold device_hotplug_lock when calling memtrace_offli=
ne_pages()

David Howells (3):
      rxrpc: Fix call ref leak
      rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record
      rxrpc: Fix trace-after-put looking at the put peer record

Dexuan Cui (1):
      HID: hyperv: Use in-place iterator API in the channel callback

Dmytro Laktyushkin (1):
      drm/amd/display: fix odm combine pipe reset

Eric Biggers (2):
      llc: fix sk_buff leak in llc_sap_state_process()
      llc: fix sk_buff leak in llc_conn_service()

Eric Dumazet (2):
      bonding: fix potential NULL deref in bond_update_slave_arr
      sch_netem: fix rcu splat in netem_enqueue()

Fabrice Gasnier (1):
      usb: dwc2: fix unbalanced use of external vbus-supply

Felipe Balbi (2):
      usb: dwc3: gadget: early giveback if End Transfer already completed
      usb: dwc3: gadget: clear DWC3_EP_TRANSFER_STARTED on cmd complete

Filipe Manana (3):
      Btrfs: fix inode cache block reserve leak on failure to allocate data=
 space
      Btrfs: fix memory leak due to concurrent append writes with fiemap
      Btrfs: fix deadlock on tree root leaf when finding free extent

Frederic Weisbecker (1):
      sched/vtime: Fix guest/system mis-accounting on task switch

Greg Kroah-Hartman (1):
      Linux 4.19.82

Hanjun Guo (2):
      arm64: Add MIDR encoding for HiSilicon Taishan CPUs
      arm64: kpti: Whitelist HiSilicon Taishan v110 CPUs

Hans de Goede (2):
      HID: i2c-hid: Add Odys Winbook 13 to descriptor override
      HID: i2c-hid: add Trekstor Primebook C11B to descriptor override

Heiko Carstens (1):
      s390/idle: fix cpu idle time calculation

Hui Peng (1):
      ath6kl: fix a NULL-ptr-deref bug in ath6kl_usb_alloc_urb_from_pipe()

Ian Rogers (2):
      libsubcmd: Make _FORTIFY_SOURCE defines dependent on the feature
      perf tests: Avoid raising SEGV using an obvious NULL dereference

Jaegeuk Kim (1):
      f2fs: flush quota blocks after turnning it off

James Morse (1):
      arm64: ftrace: Ensure synchronisation in PLT setup for Neoverse-N1 #1=
542419

James Smart (2):
      scsi: lpfc: Fix a duplicate 0711 log message number.
      scsi: lpfc: Correct localport timeout duration error

Jan-Marek Glogowski (1):
      usb: handle warm-reset port requests on hub resume

Jeffrey Hugo (1):
      dmaengine: qcom: bam_dma: Fix resource leak

Jeykumar Sankaran (1):
      drm/msm/dpu: handle failures while initializing displays

Jia Guo (1):
      ocfs2: clear zero in unaligned direct IO

Jia-Ju Bai (3):
      fs: ocfs2: fix possible null-pointer dereferences in ocfs2_xa_prepare=
_entry()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_write_end=
_nolock()
      fs: ocfs2: fix a possible null-pointer dereference in ocfs2_info_scan=
_inode_alloc()

Johan Hovold (5):
      USB: ldusb: fix ring-buffer locking
      USB: ldusb: fix control-message timeout
      USB: serial: whiteheat: fix potential slab corruption
      USB: serial: whiteheat: fix line-speed endianness
      NFC: pn533: fix use-after-free and memleaks

Julian Sax (1):
      HID: i2c-hid: add Direkt-Tek DTLAPY133-1 to descriptor override

Jussi Laako (3):
      ALSA: usb-audio: Cleanup DSD whitelist
      ALSA: usb-audio: DSD auto-detection for Playback Designs
      ALSA: usb-audio: Update DSD support quirks for Oppo and Rotel

Justin Song (1):
      ALSA: usb-audio: Add DSD support for Gustard U16/X26 USB Interface

Kai-Heng Feng (3):
      HID: i2c-hid: Disable runtime PM for LG touchscreen
      HID: i2c-hid: Ignore input report if there's no data present on Elan =
touchpanels
      ALSA: hda/realtek: Reduce the Headphone static noise on XPS 9350/9360

Kailang Yang (1):
      ALSA: hda/realtek - Add support for ALC623

Kan Liang (2):
      x86/cpu: Add Atom Tremont (Jacobsville)
      x86/cpu: Add Comet Lake to the Intel CPU models header

Kees Cook (1):
      exec: load_script: Do not exec truncated interpreter path

Laura Abbott (1):
      rtlwifi: Fix potential overflow on P2P code

Len Brown (1):
      tools/power turbostat: fix goldmont C-state limit decoding

Logan Gunthorpe (1):
      PCI: Fix Switchtec DMA aliasing quirk dmesg noise

Luca Coelho (1):
      iwlwifi: exclude GEO SAR support for 3168

Lucas A. M. Magalh=C3=A3es (1):
      media: vimc: Remove unused but set variables

Lukas Wunner (1):
      efi/cper: Fix endianness of PCIe class code

Markus Theil (1):
      nl80211: fix validation of mesh path nexthop

Micha=C5=82 Miros=C5=82aw (1):
      HID: fix error message in hid_open_report()

Mika Westerberg (1):
      thunderbolt: Use 32-bit writes when writing ring producer/consumer

Mike Christie (1):
      nbd: verify socket is supported during setup

Miklos Szeredi (2):
      fuse: flush dirty data/metadata before non-truncate setattr
      fuse: truncate pending writes on O_TRUNC

Mikulas Patocka (2):
      dm snapshot: introduce account_start_copy() and account_end_copy()
      dm snapshot: rework COW throttling to fix deadlock

NOGUCHI Hiroshi (1):
      HID: Add ASUS T100CHI keyboard dock battery quirks

Navid Emamdoost (3):
      RDMA/hfi1: Prevent memory leak in sdma_init
      iio: imu: adis16400: release allocated memory on failure
      virt: vbox: fix memory leak in hgcm_call_preprocess_linaddr

Nicholas Piggin (1):
      powerpc/powernv: Fix CPU idle to be called with IRQs disabled

Nir Dotan (1):
      mlxsw: spectrum: Set LAG port collector only when active

Nirmoy Das (1):
      drm/amdgpu: fix memory leak

Pascal Bouwmann (1):
      iio: fix center temperature of bmc150-accel-core

Pavel Shilovsky (1):
      CIFS: Respect SMB2 hdr preamble size in read responses

Pelle van Gils (1):
      drm/amdgpu/powerplay/vega10: allow undervolting in p7

Petr Mladek (1):
      tracing: Initialize iter->seq after zeroing in tracing_read_pipe()

Phil Elwell (1):
      sc16is7xx: Fix for "Unexpected interrupt: 8"

Qu Wenruo (2):
      btrfs: qgroup: Always free PREALLOC META reserve in btrfs_delalloc_re=
lease_extents()
      btrfs: tracepoints: Fix wrong parameter order for qgroup events

Randy Dunlap (1):
      tty: n_hdlc: fix build on SPARC

Remi Pommarel (1):
      iio: adc: meson_saradc: Fix memory allocation order

Rodrigo Rivas Costa (2):
      HID: steam: fix boot loop with bluetooth firmware
      HID: steam: fix deadlock with input devices.

Ronnie Sahlberg (1):
      cifs: add credits from unmatched responses/messages

Sam Ravnborg (1):
      rtc: pcf8523: set xtal load capacitance from DT

Sasha Levin (1):
      zram: fix race between backing_dev_show and backing_dev_store

Sergio Paracuellos (1):
      staging: mt7621-pinctrl: use pinconf-generic for 'dt_node_to_map' and=
 'dt_free_map'

Stefano Brivio (1):
      netfilter: ipset: Make invalid MAC address checks consistent

Steve MacLean (1):
      perf map: Fix overlapped map handling

Sven Eckelmann (1):
      batman-adv: Avoid free/alloc race when handling OGM buffer

Sven Van Asbroeck (2):
      PCI/PME: Fix possible use-after-free on remove
      power: supply: max14656: fix potential use-after-free

Takashi Iwai (4):
      ALSA: hda/realtek - Apply ALC294 hp init also for S4 resume
      ALSA: timer: Simplify error path in snd_timer_open()
      ALSA: timer: Fix mutex deadlock at releasing card
      Revert "ALSA: hda: Flush interrupts on disabling"

Takashi Sakamoto (1):
      ALSA: bebob: Fix prototype of helper function to return negative value

Theodore Ts'o (1):
      ext4: disallow files with EXT4_JOURNAL_DATA_FL from EXT4_IOC_SWAP_BOOT

Thierry Reding (1):
      gpio: max77620: Use correct unit for debounce times

Thomas Bogendoerfer (3):
      MIPS: include: Mark __cmpxchg as __always_inline
      MIPS: include: Mark __xchg as __always_inline
      MIPS: fw: sni: Fix out of bounds init of o32 stack

Tom Lendacky (1):
      perf/x86/amd: Change/fix NMI latency mitigation to use a timestamp

Tony Lindgren (1):
      dmaengine: cppi41: Fix cppi41_dma_prep_slave_sg() when idle

Trond Myklebust (2):
      NFSv4: Ensure that the state manager exits the loop on SIGKILL
      NFS: Fix an RCU lock leak in nfs4_refresh_delegation_stateid()

Valentin Vidic (1):
      net: usb: sr9800: fix uninitialized local variable

Ville Syrj=C3=A4l=C3=A4 (2):
      platform/x86: Add the VLV ISP PCI ID to atomisp2_pm
      platform/x86: Fix config space access for intel_atomisp2_pm

Vladimir Murzin (1):
      ARM: 8914/1: NOMMU: Fix exc_ret for XIP

Xiubo Li (1):
      nbd: fix possible sysfs duplicate warning

Yi Wang (1):
      clk: boston: unregister clks on failure in clk_boston_setup()

Yihui ZENG (1):
      s390/cmm: fix information leak in cmm_timeout_handler()

Yunfeng Ye (1):
      arm64: armv8_deprecated: Checking return value for memory allocation

ZhangXiaoxu (1):
      nfs: Fix nfsi->nrequests count error on nfs_inode_remove_request


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3CxY4ACgkQONu9yGCS
aT7xTA//R7SMf7r1cC9fjJK8OM374hisD07RgJAcgPG49t8DsGmsC1FHexko0vm3
Iynmzat6vm6WIzNadipYSIwEuEwLrcnTtr7CKBj+5TXQJY9FPieWpZF9G/n+ZL1+
L07V5p4QVt5hanDQ8sH/xp4Oh9Guc416/Hxv5Qy7XqhGdkGW+Irz8XgxN6m1bQRW
JQrP851d18bJbFNlWt2nn16J0bc2B0yOxz5SsPRaCizcZlGJzbYsb9kxnVsewUhC
lhFXCcWoGhjj+3T7HuDODbsOZCyGBOz4aprmCtFpIvu95wDjpHu7b7jld3mc7DaA
6pfSbQB7Q5ItTfU0Io166nZWikigC3kSo276uj6cvKmhHE7/8AQe3cBAxeSMBoBZ
vKOnYQT/px2DxeDdAn6/JbYCre7AbX23QwqVOyDHkG1TZWJXnvuvlgPAzpdFpmqC
WksBS7lFmJGP2bc20PhPRFfT6bgiaoYXuovutxnf1rWMoVkanVmies/Jsxc8IHg4
FXCK1eo2HQCJBPLOYpfj8KDpW2dji6qfkA0EMb70Fm8nHFKw7Ju8gFhBda6z+tHE
8A5Zc8IL56Gk6qZEefbt+gXyzSw5zLEi+jBNbmbyMDB4FAVRxnALPrwkMSgHKq78
XhvhzKOx9UMzUnXFjbVFYVNCI7LyuUlsp10Fy4XEzaGUdcsRzfs=
=zsGP
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
