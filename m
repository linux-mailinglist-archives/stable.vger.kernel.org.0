Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AAB1C36B7
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgEDKWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727088AbgEDKWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 06:22:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 306F6206E6;
        Mon,  4 May 2020 10:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588587739;
        bh=TFCgqqWEUYbR62c2iQwGv0ocgHIS9aZDIvs0XkVvamk=;
        h=Date:From:To:Cc:Subject:From;
        b=g/SmzOv+cY2EKQkdWrUUaI0ghwj2zfuv+VmHw1BwHOMQO703Ec8OleqPXlvBmZF/o
         CxUG8isaIUka/KbDuTP/oZomVOSXrIdb85iuQLqjGMnDcbda7cR4mU93Ao1uj3GXSx
         vFrRbTtLsu1hjxlHzESHOMFcuekSmDR2nw1GSsSU=
Date:   Mon, 4 May 2020 12:22:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.178
Message-ID: <20200504102217.GA1450422@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.178 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/bcm283x.dtsi                    |    1=20
 arch/arm/mach-imx/Makefile                        |    2=20
 arch/arm64/include/asm/sysreg.h                   |    4=20
 arch/powerpc/kernel/setup_64.c                    |    2=20
 arch/x86/kernel/cpu/mshyperv.c                    |    4=20
 arch/x86/kvm/vmx.c                                |    2=20
 arch/x86/net/bpf_jit_comp.c                       |   18 ++
 drivers/android/binder_alloc.c                    |    8 -
 drivers/char/tpm/tpm_ibmvtpm.c                    |  136 +++++++++++------=
-----
 drivers/char/tpm/tpm_tis_core.c                   |    8 +
 drivers/crypto/mxs-dcp.c                          |    4=20
 drivers/gpu/drm/msm/msm_gem.c                     |    4=20
 drivers/hwmon/jc42.c                              |    2=20
 drivers/i2c/busses/i2c-altera.c                   |    9 -
 drivers/iio/adc/ad7793.c                          |    2=20
 drivers/iio/adc/stm32-adc.c                       |   31 ++++-
 drivers/iio/adc/xilinx-xadc-core.c                |   17 ++
 drivers/mtd/chips/cfi_cmdset_0002.c               |    6=20
 drivers/net/dsa/b53/b53_regs.h                    |    4=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c    |    3=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c    |   27 ----
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c        |    2=20
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h      |    3=20
 drivers/net/ethernet/qlogic/qed/qed_dev.c         |   38 ++----
 drivers/net/macsec.c                              |   12 +
 drivers/net/macvlan.c                             |    2=20
 drivers/net/team/team.c                           |    4=20
 drivers/net/vrf.c                                 |    6=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |    3=20
 drivers/pci/pcie/aspm.c                           |   18 +-
 drivers/pwm/pwm-bcm2835.c                         |    1=20
 drivers/pwm/pwm-rcar.c                            |   10 +
 drivers/pwm/pwm-renesas-tpu.c                     |    9 -
 drivers/remoteproc/remoteproc_core.c              |    2=20
 drivers/s390/cio/device.c                         |   13 +-
 drivers/scsi/lpfc/lpfc_sli.c                      |    2=20
 drivers/scsi/scsi_transport_iscsi.c               |    4=20
 drivers/staging/comedi/comedi_fops.c              |    4=20
 drivers/staging/comedi/drivers/dt2815.c           |    3=20
 drivers/staging/vt6656/int.c                      |    3=20
 drivers/staging/vt6656/key.c                      |   14 --
 drivers/staging/vt6656/main_usb.c                 |   31 ++---
 drivers/target/target_core_fabric_lib.c           |    2=20
 drivers/tty/hvc/hvc_console.c                     |   23 ++-
 drivers/tty/rocket.c                              |   25 ++--
 drivers/tty/serial/sh-sci.c                       |   13 +-
 drivers/tty/vt/vt.c                               |    2=20
 drivers/usb/class/cdc-acm.c                       |   36 +++++
 drivers/usb/class/cdc-acm.h                       |    5=20
 drivers/usb/core/hub.c                            |   14 ++
 drivers/usb/core/message.c                        |    9 +
 drivers/usb/core/quirks.c                         |    4=20
 drivers/usb/dwc3/gadget.c                         |    8 -
 drivers/usb/early/xhci-dbc.c                      |    8 -
 drivers/usb/early/xhci-dbc.h                      |   18 ++
 drivers/usb/gadget/function/f_fs.c                |    4=20
 drivers/usb/gadget/udc/bdc/bdc_ep.c               |    2=20
 drivers/usb/misc/sisusbvga/sisusb.c               |   20 +--
 drivers/usb/misc/sisusbvga/sisusb_init.h          |   14 +-
 drivers/usb/storage/uas.c                         |   46 ++++++-
 drivers/usb/storage/unusual_devs.h                |    7 +
 drivers/watchdog/watchdog_dev.c                   |    1=20
 drivers/xen/xenbus/xenbus_client.c                |    9 +
 fs/ceph/caps.c                                    |    8 -
 fs/ceph/export.c                                  |    5=20
 fs/ext4/block_validity.c                          |   54 ++++++++
 fs/ext4/ext4.h                                    |   15 ++
 fs/ext4/extents.c                                 |   59 +++++----
 fs/ext4/ialloc.c                                  |    4=20
 fs/ext4/inode.c                                   |   55 ++++++--
 fs/ext4/ioctl.c                                   |    2=20
 fs/ext4/mballoc.c                                 |    6=20
 fs/ext4/namei.c                                   |    4=20
 fs/ext4/resize.c                                  |    5=20
 fs/ext4/super.c                                   |   22 +--
 fs/ext4/xattr.c                                   |    5=20
 fs/namespace.c                                    |    2=20
 fs/nfsd/nfs4state.c                               |    2=20
 fs/pnode.c                                        |    9 -
 fs/proc/vmcore.c                                  |    2=20
 fs/xfs/xfs_inode.c                                |   85 ++++++-------
 fs/xfs/xfs_log.c                                  |   14 ++
 fs/xfs/xfs_reflink.c                              |    1=20
 include/linux/kvm_host.h                          |    2=20
 include/linux/overflow.h                          |   31 +++++
 include/linux/qed/qed_chain.h                     |   24 ++-
 include/linux/vmalloc.h                           |    2=20
 include/net/tcp.h                                 |    2=20
 include/uapi/linux/keyctl.h                       |    7 -
 include/uapi/linux/swab.h                         |    4=20
 ipc/util.c                                        |    2=20
 kernel/audit.c                                    |    3=20
 kernel/events/core.c                              |   22 ++-
 kernel/gcov/fs.c                                  |    2=20
 mm/hugetlb.c                                      |   14 +-
 mm/ksm.c                                          |   12 +
 mm/shmem.c                                        |    4=20
 mm/slub.c                                         |    3=20
 mm/vmalloc.c                                      |   16 ++
 net/ipv4/ip_vti.c                                 |    4=20
 net/ipv4/raw.c                                    |    4=20
 net/ipv4/route.c                                  |    3=20
 net/ipv4/xfrm4_output.c                           |    2=20
 net/ipv6/ipv6_sockglue.c                          |   13 --
 net/ipv6/xfrm6_output.c                           |    2=20
 net/netrom/nr_route.c                             |    1=20
 net/x25/x25_dev.c                                 |    4=20
 security/keys/internal.h                          |   12 +
 security/keys/keyctl.c                            |   58 ++++++---
 sound/pci/hda/hda_intel.c                         |    1=20
 sound/pci/hda/patch_realtek.c                     |    3=20
 sound/soc/intel/atom/sst-atom-controls.c          |    2=20
 sound/soc/soc-dapm.c                              |   20 ++-
 sound/usb/format.c                                |   52 ++++++++
 sound/usb/mixer_quirks.c                          |   12 +
 sound/usb/usx2y/usbusx2yaudio.c                   |    2=20
 tools/objtool/check.c                             |   17 ++
 tools/objtool/orc_dump.c                          |   44 ++++---
 tools/testing/selftests/kmod/kmod.sh              |   13 +-
 tools/vm/Makefile                                 |    2=20
 121 files changed, 1046 insertions(+), 484 deletions(-)

Ahmad Fatoum (1):
      ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=3Dy

Al Viro (1):
      propagate_one(): mnt_set_mountpoint() needs mount_lock

Alan Stern (3):
      USB: core: Fix free-while-in-use bug in the USB S-Glibrary
      USB: hub: Fix handling of connect changes during sleep
      usb-storage: Add unusual_devs entry for JMicron JMS566

Alexander Tsoy (1):
      ALSA: usb-audio: Filter out unsupported sample rates on Focusrite dev=
ices

Andrew Melnychenko (1):
      tty: hvc: fix buffer overflow during hvc_alloc().

Arnd Bergmann (1):
      net: ipv4: avoid unused variable warning for sysctl

Bodo Stroesser (1):
      scsi: target: fix PR IN / READ FULL STATUS for FC

Changming Liu (1):
      USB: sisusbvga: Change port variable from signed to unsigned

Chris Packham (1):
      powerpc/setup_64: Set cache-line-size based on cache-block-size

Christian Borntraeger (1):
      include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LON=
G for swap

Clement Leger (1):
      remoteproc: Fix wrong rvring index computation

Colin Ian King (1):
      ext4: unsigned int compared against zero

Cornelia Huck (1):
      s390/cio: avoid duplicated 'ADD' uevents

Darrick J. Wong (2):
      xfs: validate sb_logsunit is a multiple of the fs blocksize
      xfs: fix partially uninitialized structure in xfs_reflink_remap_extent

David Ahern (2):
      xfrm: Always set XFRM_TRANSFORMED in xfrm{4,6}_output_finish
      vrf: Check skb for XFRM_TRANSFORMED flag

David Howells (1):
      keys: Fix the use of the C++ keyword "private" in uapi/linux/keyctl.h

Dmitry Monakhov (1):
      ext4: fix extent_status fragmentation for plain files

Doug Berger (1):
      net: bcmgenet: correct per TX/RX ring statistics

Eric Biggers (1):
      selftests: kmod: fix handling test numbers above 9

Eric Dumazet (1):
      tcp: cache line align MAX_TCP_HEADER

Fangrui Song (1):
      arm64: Delete the space separator in __emit_inst

Florian Fainelli (2):
      pwm: bcm2835: Dynamically allocate base
      net: dsa: b53: Fix ARL register definitions

Geert Uytterhoeven (2):
      pwm: rcar: Fix late Runtime PM enablement
      pwm: renesas-tpu: Fix late Runtime PM enablement

George Wilson (1):
      tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()

Greg Kroah-Hartman (1):
      Linux 4.14.178

Gyeongtaek Lee (1):
      ASoC: dapm: fixup dapm kcontrol widget

Hans de Goede (1):
      ASoC: Intel: atom: Take the drv->lock mutex before calling sst_send_s=
lot_map()

Heiner Kallweit (1):
      PCI/ASPM: Allow re-enabling Clock PM

Ian Abbott (1):
      staging: comedi: dt2815: fix writing hi byte of analog output

Ian Rogers (1):
      perf/core: fix parent pid/tid in task exit events

James Smart (1):
      scsi: lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login

Jann Horn (2):
      USB: early: Handle AMD's spec-compliant identifiers, too
      vmalloc: fix remap_vmalloc_range() bounds checks

Jarkko Sakkinen (1):
      tpm/tpm_tis: Free IRQ if probing fails

Jason Gunthorpe (2):
      overflow.h: Add arithmetic shift helper
      net/cxgb4: Check the return from t4_query_params properly

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

Josh Poimboeuf (2):
      objtool: Fix CONFIG_UBSAN_TRAP unreachable warnings
      objtool: Support Clang non-section symbols in ORC dump

Juergen Gross (1):
      xen/xenbus: ensure xenbus_map_ring_valloc() returns proper grant stat=
us

Kailang Yang (1):
      ALSA: hda/realtek - Add new codec supported for ALC245

Kazuhiro Fujita (1):
      serial: sh-sci: Make sure status register SCxSR is read in correct se=
quence

Lars-Peter Clausen (3):
      iio: xilinx-xadc: Fix ADC-B powerdown
      iio: xilinx-xadc: Fix clearing interrupt when enabling trigger
      iio: xilinx-xadc: Fix sequencer configuration for aux channels in sim=
ultaneous mode

Liu Jian (1):
      mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer

Longpeng (1):
      mm/hugetlb: fix a addressing exception caused by huge_pte_offset

Lucas Stach (1):
      tools/vm: fix cross-compile build

Luke Nelson (1):
      bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX BPF_B

Malcolm Priestley (5):
      staging: vt6656: Don't set RCR_MULTICAST or RCR_BROADCAST by default.
      staging: vt6656: Fix calling conditions of vnt_set_bss_mode
      staging: vt6656: Fix drivers TBTT timing counter.
      staging: vt6656: Fix pairwise key entry save.
      staging: vt6656: Power save stop wake_up_count wrap around.

Muchun Song (1):
      mm/ksm: fix NULL pointer dereference when KSM zero page is enabled

Nathan Chancellor (1):
      usb: gadget: udc: bdc: Remove unnecessary NULL checks in bdc_req_comp=
lete

Nicolai Stange (1):
      net: ipv4: emulate READ_ONCE() on ->hdrincl bit-field in raw_sendmsg()

Nicolas Pitre (1):
      vt: don't hardcode the mem allocation upper bound

Nicolas Saenz Julienne (1):
      ARM: dts: bcm283x: Disable dsi0 node

Olaf Hering (1):
      x86: hyperv: report value of misc_features

Oliver Neukum (4):
      cdc-acm: close race betrween suspend() and acm_softint
      cdc-acm: introduce a cool down
      UAS: no use logging any details in case of ENODEV
      UAS: fix deadlock in error handling and PM flushing work

Olivier Moysan (1):
      iio: adc: stm32-adc: fix sleep in atomic context

Paul Moore (1):
      audit: check the length of userspace generated audit records

Piotr Krysiuk (1):
      fs/namespace.c: fix mountpoint reference counter race

Qiujun Huang (1):
      ceph: return ceph_mdsc_do_request() errors from __get_parent()

Rahul Lakkireddy (1):
      cxgb4: fix large delays in PTP synchronization

Ritesh Harjani (1):
      ext4: check for non-zero journal inum in ext4_calculate_overhead

Rob Clark (1):
      drm/msm: Use the correct dma_sync calls harder

Sascha Hauer (1):
      hwmon: (jc42) Fix name to have no illegal characters

Sean Christopherson (1):
      KVM: Check validity of resolved slot when searching memslots

Taehee Yoo (3):
      macsec: avoid to set wrong mtu
      macvlan: fix null dereference in macvlan_device_event()
      team: fix hang in team_mode_get()

Takashi Iwai (2):
      ALSA: hda: Remove ASUS ROG Zenith from the blacklist
      ALSA: usx2y: Fix potential NULL dereference

Tero Kristo (1):
      watchdog: reset last_hw_keepalive time at start

Theodore Ts'o (6):
      ext4: increase wait time needed before reuse of deleted inode numbers
      ext4: convert BUG_ON's to WARN_ON's in mballoc.c
      ext4: avoid declaring fs inconsistent due to invalid file handles
      ext4: protect journal inode's blocks using block_validity
      ext4: don't perform block validity checks on the journal inode
      ext4: fix block validity checks for journal inodes using indirect blo=
cks

Thinh Nguyen (1):
      usb: dwc3: gadget: Do link recovery for SS and SSP

Tyler Hicks (1):
      binder: take read mode of mmap_sem in binder_alloc_free_page()

Udipto Goswami (1):
      usb: f_fs: Clear OS Extended descriptor counts to zero in ffs_data_re=
set()

Uros Bizjak (1):
      KVM: VMX: Enable machine check support for 32bit targets

Vasily Averin (3):
      kernel/gcov/fs.c: gcov_seq_next() should increase position index
      ipc/util.c: sysvipc_find_ipc() should increase position index
      nfsd: memory corruption in nfsd4_lock()

Vlastimil Babka (1):
      mm, slub: restore the original intention of prefetch_freepointer()

Waiman Long (1):
      KEYS: Avoid false positive ENOMEM error on key read

Wei Yongjun (1):
      crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash=
' static

Wolfram Sang (1):
      i2c: altera: use proper variable to hold errno

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

Yang Shi (1):
      mm: shmem: disable interrupt when acquiring info->lock in userfaultfd=
_copy path

YueHaibing (1):
      iio:ad7797: Use correct attribute_group

Yuval Basson (1):
      qed: Fix use after free in qed_chain_free

kaixuxia (1):
      xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT

yangerkun (1):
      ext4: use matching invalidatepage in ext4_writepage


--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6v7NkACgkQONu9yGCS
aT4W0hAAgTDUiFvfaPrN7ijk1YPaDKaQu/iiZ95OYNm2uYGMMUeveHg5U3KMf8kf
yXXK2OTDYoB159p36IS4oVioZ75tVKPnMabmpecxMcIbsAP49yMnq5y5TOt3KnLt
Gqjb6PHrGDfxTdvES9OxDBgkeo45vR/bxjfGlC/0HVex0jDtZ4t9OW43IjRl8LNH
vCT12ocrP4WCLYW3F6g0uBRs5SayZ+rOA3BxnMS/OLZaWozBHsQ3k6AU9kuTvKos
IVtqzk4abivzesVbbadlzHZn0fbH0hwD+gZBvWINiJpDzMvWlzC8LQyCo+IQPsFS
qj9APtipMsJxa5PwAnr0R0jwkjVAXt3UwaoO9s26KtVbkzf5du/C6Zxb8axwjGIP
NyEXQyzfZ3Zvz1TBvDGWRbxOkstwfpd6gKwGaN0VNy6euHg2QegVAAN9PA/UtAqf
m9YE6X24DKZB+OFWQ4kcSeC0HcRL48cEZm56slCjEnbxq/lD6rHfwBRe3ncszWeM
7uO71imNkrQ6tC69cjN/bgcaPd/2ko4jJ4oT4mhZWA2MPd5lbSEoxz4+ISzIUggV
UshSfmmDXqxnkvqtn+6zgSwsKZ/0meYna4CnbchSjMynMUYU8OLT0lIBbmoP6ztk
UqZyeg5TXJdMAE/gJBdVzIL8Z1e0C1OSBgIFu7+0nrWWlG+MT7s=
=peBh
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
