Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA481BE5C2
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD2SBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 14:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2SBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Apr 2020 14:01:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E0620B1F;
        Wed, 29 Apr 2020 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588183275;
        bh=+L3JteKnXNbAFSt03j/98g1aoMGDXh5bjaN8mHB7ZgM=;
        h=Date:From:To:Cc:Subject:From;
        b=LSELAF0gluH0KHBPvwUQkrliJIXRYayWa+v/P3Ip7MJZH7GdaTomBEB2+MP2lGYgZ
         5+WWWtgBBr7y4xLKS7vf/YVgvebIBQrTs374pjvescYOxnrPZnwzyH66s9oBgy2NuH
         sjv7vKy6MQ0IqH34bAuY9U8UaC8rq/vCCeJIkTH8=
Date:   Wed, 29 Apr 2020 20:01:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.119
Message-ID: <20200429180113.GA2336605@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.119 kernel.

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

 Documentation/arm64/silicon-errata.txt                      |    1=20
 Makefile                                                    |    2=20
 arch/arm/mach-imx/Makefile                                  |    2=20
 arch/arm64/Kconfig                                          |   16 +
 arch/arm64/include/asm/cache.h                              |    3=20
 arch/arm64/include/asm/cpucaps.h                            |    3=20
 arch/arm64/include/asm/cputype.h                            |    2=20
 arch/arm64/kernel/cpu_errata.c                              |   22 +
 arch/arm64/kernel/sys_compat.c                              |   11=20
 arch/arm64/kernel/traps.c                                   |    9=20
 arch/powerpc/kernel/setup_64.c                              |    2=20
 arch/powerpc/kernel/time.c                                  |   44 +--
 arch/s390/kvm/kvm-s390.c                                    |    3=20
 arch/s390/lib/uaccess.c                                     |    4=20
 arch/s390/mm/pgalloc.c                                      |   16 +
 arch/x86/include/asm/kvm_host.h                             |    4=20
 arch/x86/kvm/vmx.c                                          |   27 +-
 arch/x86/kvm/x86.c                                          |   66 +++--
 drivers/block/loop.c                                        |   42 ++-
 drivers/block/virtio_blk.c                                  |    9=20
 drivers/char/tpm/tpm_ibmvtpm.c                              |  136 +++++--=
---
 drivers/char/tpm/tpm_tis_core.c                             |    8=20
 drivers/crypto/mxs-dcp.c                                    |    4=20
 drivers/gpu/drm/amd/display/dc/core/dc.c                    |   23 +
 drivers/gpu/drm/msm/msm_gem.c                               |    4=20
 drivers/iio/adc/stm32-adc.c                                 |   31 ++
 drivers/iio/adc/xilinx-xadc-core.c                          |   95 +++++--
 drivers/iio/common/st_sensors/st_sensors_core.c             |    2=20
 drivers/infiniband/core/addr.c                              |    7=20
 drivers/infiniband/sw/rxe/rxe_net.c                         |    8=20
 drivers/net/dsa/b53/b53_common.c                            |   37 ++
 drivers/net/dsa/b53/b53_regs.h                              |    8=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c              |    3=20
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c              |   27 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c              |   27 --
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h                |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c             |   11=20
 drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c    |    4=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c          |    3=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr_tcam.c      |    4=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c         |    1=20
 drivers/net/geneve.c                                        |    4=20
 drivers/net/macsec.c                                        |   12=20
 drivers/net/macvlan.c                                       |    2=20
 drivers/net/team/team.c                                     |    4=20
 drivers/net/vrf.c                                           |   10=20
 drivers/net/vxlan.c                                         |    8=20
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                 |    9=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c           |    3=20
 drivers/nvme/host/multipath.c                               |    4=20
 drivers/pci/pcie/aspm.c                                     |   18 -
 drivers/pwm/pwm-bcm2835.c                                   |    1=20
 drivers/pwm/pwm-rcar.c                                      |   10=20
 drivers/pwm/pwm-renesas-tpu.c                               |    9=20
 drivers/s390/cio/device.c                                   |   13 -
 drivers/scsi/lpfc/lpfc_nvme.c                               |   14 -
 drivers/scsi/lpfc/lpfc_sli.c                                |    2=20
 drivers/scsi/scsi_transport_iscsi.c                         |    4=20
 drivers/scsi/smartpqi/smartpqi_sas_transport.c              |    2=20
 drivers/staging/comedi/comedi_fops.c                        |    4=20
 drivers/staging/comedi/drivers/dt2815.c                     |    3=20
 drivers/staging/vt6656/int.c                                |    3=20
 drivers/staging/vt6656/key.c                                |   14 -
 drivers/staging/vt6656/main_usb.c                           |   31 +-
 drivers/tty/hvc/hvc_console.c                               |   23 +
 drivers/tty/rocket.c                                        |   25 +-
 drivers/tty/serial/sh-sci.c                                 |   13 -
 drivers/tty/vt/vt.c                                         |    7=20
 drivers/usb/class/cdc-acm.c                                 |   36 ++
 drivers/usb/class/cdc-acm.h                                 |    5=20
 drivers/usb/core/hub.c                                      |   14 +
 drivers/usb/core/message.c                                  |    9=20
 drivers/usb/core/quirks.c                                   |    4=20
 drivers/usb/dwc3/gadget.c                                   |   12=20
 drivers/usb/early/xhci-dbc.c                                |    8=20
 drivers/usb/early/xhci-dbc.h                                |   18 +
 drivers/usb/gadget/function/f_fs.c                          |    4=20
 drivers/usb/host/xhci-hub.c                                 |   20 +
 drivers/usb/misc/sisusbvga/sisusb.c                         |   20 -
 drivers/usb/misc/sisusbvga/sisusb_init.h                    |   14 -
 drivers/usb/storage/uas.c                                   |   46 +++
 drivers/usb/storage/unusual_devs.h                          |    7=20
 drivers/watchdog/watchdog_dev.c                             |    1=20
 fs/ceph/caps.c                                              |    8=20
 fs/ceph/export.c                                            |    5=20
 fs/ext4/extents.c                                           |   47 ++-
 fs/f2fs/xattr.c                                             |   15 +
 fs/namespace.c                                              |    2=20
 fs/proc/vmcore.c                                            |    5=20
 fs/xfs/xfs_inode.c                                          |   85 +++---
 include/linux/blkdev.h                                      |    2=20
 include/linux/blktrace_api.h                                |   18 +
 include/linux/iio/iio.h                                     |    2=20
 include/linux/kvm_host.h                                    |   35 ++
 include/linux/kvm_types.h                                   |    9=20
 include/linux/vmalloc.h                                     |    2=20
 include/net/addrconf.h                                      |    6=20
 include/net/ipv6.h                                          |    2=20
 include/net/tcp.h                                           |    2=20
 ipc/util.c                                                  |    2=20
 kernel/audit.c                                              |    3=20
 kernel/events/core.c                                        |    9=20
 kernel/gcov/fs.c                                            |    2=20
 kernel/trace/blktrace.c                                     |  117 ++++++-=
--
 mm/hugetlb.c                                                |   14 -
 mm/ksm.c                                                    |   12=20
 mm/vmalloc.c                                                |   16 +
 net/dccp/ipv6.c                                             |    6=20
 net/ipv4/ip_vti.c                                           |    4=20
 net/ipv4/xfrm4_output.c                                     |    2=20
 net/ipv6/addrconf_core.c                                    |   11=20
 net/ipv6/af_inet6.c                                         |    4=20
 net/ipv6/datagram.c                                         |    2=20
 net/ipv6/inet6_connection_sock.c                            |    4=20
 net/ipv6/ip6_output.c                                       |    8=20
 net/ipv6/ipv6_sockglue.c                                    |   13 -
 net/ipv6/raw.c                                              |    2=20
 net/ipv6/syncookies.c                                       |    2=20
 net/ipv6/tcp_ipv6.c                                         |    4=20
 net/ipv6/xfrm6_output.c                                     |    2=20
 net/l2tp/l2tp_ip6.c                                         |    2=20
 net/mpls/af_mpls.c                                          |    7=20
 net/netrom/nr_route.c                                       |    1=20
 net/sched/sch_etf.c                                         |    7=20
 net/sctp/ipv6.c                                             |    4=20
 net/tipc/udp_media.c                                        |    9=20
 net/x25/x25_dev.c                                           |    4=20
 samples/vfio-mdev/mdpy.c                                    |    2=20
 scripts/kconfig/qconf.cc                                    |   13 -
 security/keys/internal.h                                    |   12=20
 security/keys/keyctl.c                                      |   58 +++-
 sound/pci/hda/hda_intel.c                                   |    1=20
 sound/pci/hda/patch_realtek.c                               |   11=20
 sound/soc/intel/atom/sst-atom-controls.c                    |    2=20
 sound/soc/intel/boards/bytcr_rt5640.c                       |   11=20
 sound/soc/soc-dapm.c                                        |   20 +
 sound/usb/format.c                                          |   52 ++++
 sound/usb/mixer.c                                           |   37 ++
 sound/usb/mixer.h                                           |   10=20
 sound/usb/mixer_maps.c                                      |   37 ++
 sound/usb/mixer_quirks.c                                    |   12=20
 sound/usb/quirks-table.h                                    |   14 +
 sound/usb/usx2y/usbusx2yaudio.c                             |    2=20
 tools/bpf/bpftool/btf_dumper.c                              |    2=20
 tools/testing/selftests/ftrace/settings                     |    1=20
 tools/testing/selftests/kmod/kmod.sh                        |   13 -
 tools/vm/Makefile                                           |    2=20
 virt/kvm/kvm_main.c                                         |  149 +++++++=
++++-
 149 files changed, 1590 insertions(+), 597 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=3Dy

Alan Stern (3):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary
      USB: hub: Fix handling of connect changes during sleep
      usb-storage: Add unusual_devs entry for JMicron JMS566

Alexander Tsoy (1):
      ALSA: usb-audio: Filter out unsupported sample rates on Focusrite dev=
ices

Andrew Melnychenko (1):
      tty: hvc: fix buffer overflow during hvc_alloc().

Boris Ostrovsky (4):
      x86/kvm: Introduce kvm_(un)map_gfn()
      x86/kvm: Cache gfn to pfn translation
      x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
      x86/KVM: Clean up host's steal time structure

Catalin Marinas (1):
      arm64: Silence clang warning on mismatched value/register sizes

Cengiz Can (1):
      blktrace: fix dereference after null check

Changming Liu (1):
      USB: sisusbvga: Change port variable from signed to unsigned

Chris Packham (1):
      powerpc/setup_64: Set cache-line-size based on cache-block-size

Christian Borntraeger (2):
      kvm: fix compile on s390 part 2
      s390/mm: fix page table upgrade vs 2ndary address mode accesses

Cornelia Huck (1):
      s390/cio: avoid duplicated 'ADD' uevents

Dan Carpenter (1):
      mlxsw: Fix some IS_ERR() vs NULL bugs

David Ahern (3):
      vrf: Fix IPv6 with qdisc and xfrm
      xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
      vrf: Check skb for XFRM_TRANSFORMED flag

Dmitry Monakhov (1):
      ext4: fix extent_status fragmentation for plain files

Doug Berger (1):
      net: bcmgenet: correct per TX/RX ring statistics

Eric Biggers (1):
      selftests: kmod: fix handling test numbers above 9

Eric Dumazet (2):
      sched: etf: do not assume all sockets are full blown
      tcp: cache line align MAX_TCP_HEADER

Evan Green (1):
      loop: Better discard support for block devices

Florian Fainelli (5):
      pwm: bcm2835: Dynamically allocate base
      net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
      net: dsa: b53: Fix ARL register definitions
      net: dsa: b53: Rework ARL bin logic
      net: dsa: b53: b53_arl_rw_op() needs to select IVL or SVL

Geert Uytterhoeven (2):
      pwm: rcar: Fix late Runtime PM enablement
      pwm: renesas-tpu: Fix late Runtime PM enablement

George Wilson (1):
      tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()

Greg Kroah-Hartman (1):
      Linux 4.19.119

Gyeongtaek Lee (1):
      ASoC: dapm: fixup dapm kcontrol widget

Halil Pasic (1):
      virtio-blk: improve virtqueue error to BLK_STS

Hans de Goede (2):
      ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_s=
lot_map()
      ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN MPWIN895CL tablet

Heiner Kallweit (1):
      PCI/ASPM: Allow re-enabling Clock PM

Ian Abbott (1):
      staging: comedi: dt2815: fix writing hi byte of analog output

James Morse (3):
      arm64: errata: Hide CTR_EL0.DIC on systems affected by Neoverse-N1 #1=
542419
      arm64: Fake the IminLine size on systems affected by Neoverse-N1 #154=
2419
      arm64: compat: Workaround Neoverse-N1 #1542419 for compat user-space

James Smart (2):
      scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login
      scsi: lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNR=
EG

Jan Kara (1):
      blktrace: Protect q->blk_trace with RCU

Jann Horn (2):
      USB: early: Handle AMD's spec-compliant identifiers, too
      vmalloc: fix remap_vmalloc_range() bounds checks

Jarkko Sakkinen (1):
      tpm/tpm_tis: Free IRQ if probing fails

Jeremy Sowden (1):
      vti4: removed duplicate log message.

Jiri Olsa (1):
      perf/core: Disable page faults when getting phys address

Jiri Slaby (1):
      tty: rocket, avoid OOB access

Johannes Berg (1):
      iwlwifi: pcie: actually release queue memory in TVQM

John Haxby (1):
      ipv6: fix restrict IPV6_ADDRFORM operation

Jonathan Cox (1):
      USB: Add USB_QUIRK_DELAY_CTRL_MSG and USB_QUIRK_DELAY_INIT for Corsai=
r K70 RGB RAPIDFIRE

Kai-Heng Feng (1):
      xhci: Ensure link state is U3 after setting USB_SS_PORT_LS_U3

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC245

KarimAllah Ahmed (2):
      KVM: Introduce a new guest mapping API
      KVM: Properly check if "page" is valid in kvm_vcpu_unmap

Kazuhiro Fujita (1):
      serial: sh-sci: Make sure status register SCxSR is read in correct se=
quence

Lars Engebretsen (1):
      iio: core: remove extra semi-colon from devm_iio_device_register() ma=
cro

Lars-Peter Clausen (4):
      iio: xilinx-xadc: Fix ADC-B powerdown
      iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
      iio: xilinx-xadc: Fix sequencer configuration for aux channels in sim=
ultaneous mode
      iio: xilinx-xadc: Make sure not exceed maximum samplerate

Lary Gibaud (1):
      iio: st_sensors: rely on odr mask to know if odr can be set

Longpeng (1):
      mm/hugetlb: fix a addressing exception caused by huge_pte_offset

Lucas Stach (1):
      tools/vm: fix cross-compile build

Malcolm Priestley (5):
      staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by default.
      staging: vt6656: Fix calling conditions of vnt_set_bss_mode
      staging: vt6656: Fix drivers TBTT timing counter.
      staging: vt6656: Fix pairwise key entry save.
      staging: vt6656: Power save stop wake_up_count wrap around.

Marc Zyngier (2):
      arm64: Add part number for Neoverse N1
      net: stmmac: dwmac-meson8b: Add missing boundary to RGMII TX clock ar=
ray

Martin KaFai Lau (1):
      bpftool: Fix printing incorrect pointer in btf_dump_ptr

Mathias Nyman (1):
      xhci: prevent bus suspend if a roothub port detected a over-current c=
ondition

Mauro Carvalho Chehab (1):
      kconfig: qconf: Fix a few alignment issues

Mordechay Goodstein (1):
      iwlwifi: mvm: beacon statistics shouldn't go backwards

Muchun Song (1):
      mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

Murthy Bhat (1):
      scsi: smartpqi: fix call trace in device discovery

Nicholas Piggin (1):
      Revert "powerpc/64: irq_work avoid interrupt when called with hardwar=
e irqs enabled"

Nicolas Pitre (2):
      vt: don't hardcode the mem allocation upper bound
      vt: don't use kmalloc() for the unicode screen buffer

Oliver Neukum (4):
      cdc-acm: close race betrween suspend() and acm_softint
      cdc-acm: introduce a cool down
      UAS: no use logging any details in case of ENODEV
      UAS: fix deadlock in error handling and PM flushing work

Olivier Moysan (1):
      iio: adc: stm32-adc: fix sleep in atomic context

Paolo Bonzini (2):
      kvm: fix compilation on aarch64
      kvm: fix compilation on s390

Paul Moore (1):
      audit: check the length of userspace generated audit records

Piotr Krysiuk (1):
      fs/namespace.c: fix mountpoint reference counter race

Qiujun Huang (1):
      ceph: return ceph_mdsc_do_request() errors from __get_parent()

Rahul Lakkireddy (1):
      cxgb4: fix large delays in PTP synchronization

Randall Huang (1):
      f2fs: fix to avoid memory leakage in f2fs_listxattr

Rob Clark (1):
      drm/msm: Use the correct dma_sync calls harder

Sabrina Dubroca (2):
      net: ipv6: add net argument to ip6_dst_lookup_flow
      net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

Sagi Grimberg (1):
      nvme: fix deadlock caused by ANA update wrong locking

Sean Christopherson (4):
      KVM: VMX: Zero out *all* general purpose registers after VM-Exit
      KVM: nVMX: Always sync GUEST_BNDCFGS when it comes from vmcs01
      KVM: s390: Return last valid slot if approx index is out-of-bounds
      KVM: Check validity of resolved slot when searching memslots

Steven Rostedt (VMware) (1):
      tracing/selftests: Turn off timeout setting

Taehee Yoo (3):
      macsec: avoid to set wrong mtu
      macvlan: fix null dereference in macvlan_device_event()
      team: fix hang in team_mode_get()

Takashi Iwai (5):
      ALSA: hda: Remove ASUS ROG Zenith from the blacklist
      ALSA: usb-audio: Add static mapping table for ALC1220-VB-based mobos
      ALSA: usb-audio: Add connector notifier delegation
      ALSA: usx2y: Fix potential NULL dereference
      ALSA: hda/realtek - Fix unexpected init_amp override

Tero Kristo (1):
      watchdog: reset last_hw_keepalive time at start

Thinh Nguyen (1):
      usb: dwc3: gadget: Fix request completion check

Udipto Goswami (1):
      usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_re=
set()

Uros Bizjak (1):
      KVM: VMX: Enable machine check support for 32bit targets

Vasily Averin (2):
      kernel/gcov/fs.c: gcov_seq_next() should increase position index
      ipc/util.c: sysvipc_find_ipc() should increase position index

Vishal Kulkarni (1):
      cxgb4: fix adapter crash due to wrong MC size

Waiman Long (1):
      KEYS: Avoid false positive ENOMEM error on key read

Wei Yongjun (1):
      crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash=
' static

Wu Bo (1):
      scsi: iscsi: Report unbind session event when the target has been rem=
oved

Xiyu Yang (4):
      net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
      net/x25: Fix x25_neigh refcnt leak when receiving frame
      ALSA: usb-audio: Fix usb audio refcnt leak when getting spdif
      staging: comedi: Fix comedi_device refcnt leak in comedi_open

Yan, Zheng (1):
      ceph: don't skip updating wanted caps when cap is stale

Yongqiang Sun (1):
      drm/amd/display: Not doing optimize bandwidth if flip pending.

kaixuxia (1):
      xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6pwOYACgkQONu9yGCS
aT5Z0w//X8f0Lgq4G51xt7BXiFKAlGlvtCiI7A2WkQZj28DBzF45HW7MCOBexbp6
c9T1NASkE6vr7TKgnoSfkUK7r0s0kQ9PYnqUUBk0pXHbIHTZ5ufj3R9N92JT9NCB
/xllt+Gkvn6CINtVQH/iI/flqrmHMhGTQKxwG95MBTCjMTHPjtK5yQ2FVFYjtRTu
bzhiMLIt4jHnIm7x/AuhXOpFPvaZZa9Ki+u3KV1UQ2fDcwLm/4ql7bFpOkdgPAkJ
Y1lVvMQtOgYCQS9UAQdXsfKbOp7XPw7hUaGsJFQhT6hiAXcFVdhw1mMiblj79uaq
N9Z0UhbDNGfiClCNuxv4T4XRCUjTmdYumgdpw+6J/6N4Y8unICMglpBERijKpapY
QxT+vYtiPLpeZgY2dxPlWBnPB3SqAAQvsYTShwEwu/7+D3998hkinEmVF8+y9xKL
MYSrDYMRNTMo1HUs2H/jVM9fUjup9FiM/hG5ORIYestXfFFZutaM0zCa+4vHVVAu
SRVcnqQmumlWpipvO5PGCQPlOPYy8R9Jjf3p5j7c3fx6WKqIHU36I1nrLGB/MYRQ
l0X7F/F5K/tZsdpENtKqxq0LcapFt/8VF6OQn6XI21g7OnbYICS83ZE1r8+h21tL
Fooqs4cMSA7eZH9HuJ+yJYRSJ3347sgy8g2kuMNArx101S0ENko=
=PD9y
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
