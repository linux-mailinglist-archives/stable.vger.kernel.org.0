Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A319C481
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 16:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfHYOtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 10:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728375AbfHYOtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 10:49:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A3E20870;
        Sun, 25 Aug 2019 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566744589;
        bh=MQ1LD+oJRtDT2DelXlKLP9mdAKJwYQ4N2eDmf/q4MtI=;
        h=Date:From:To:Cc:Subject:From;
        b=b2giEBqsdke/N4qjOVrq4Y4sMJSy+sFLIoXlFthY/3NmY245ekUpC6R13GlvJ3/7M
         txyPYqhsuAizXD/+9lwMwypPp78DXZ+wAGyeqKCDMnJVzXAdGCLX0FB4nYnhz7Sgtw
         /zwB8+UN5PIQFMq7D9H4LCrrRzV30lJFFXGnf0Hs=
Date:   Sun, 25 Aug 2019 16:49:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.190
Message-ID: <20190825144947.GA30080@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.190 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/siphash.txt                            |  175 ++++++
 Documentation/sysctl/net.txt                         |    8=20
 MAINTAINERS                                          |    7=20
 Makefile                                             |    2=20
 arch/arm/mach-davinci/sleep.S                        |    1=20
 arch/arm/net/bpf_jit_32.c                            |    2=20
 arch/arm64/include/asm/efi.h                         |    6=20
 arch/arm64/include/asm/pgtable.h                     |    4=20
 arch/arm64/kernel/hw_breakpoint.c                    |    7=20
 arch/arm64/net/bpf_jit_comp.c                        |    2=20
 arch/mips/net/bpf_jit.c                              |    2=20
 arch/powerpc/net/bpf_jit_comp.c                      |    2=20
 arch/powerpc/net/bpf_jit_comp64.c                    |    2=20
 arch/s390/net/bpf_jit_comp.c                         |    2=20
 arch/sh/kernel/hw_breakpoint.c                       |    1=20
 arch/sparc/net/bpf_jit_comp.c                        |    2=20
 arch/x86/mm/fault.c                                  |   15=20
 arch/x86/net/bpf_jit_comp.c                          |    2=20
 arch/xtensa/kernel/setup.c                           |    1=20
 drivers/acpi/arm64/iort.c                            |    4=20
 drivers/ata/libahci_platform.c                       |    3=20
 drivers/ata/libata-zpodd.c                           |    2=20
 drivers/block/drbd/drbd_receiver.c                   |   14=20
 drivers/cpufreq/pasemi-cpufreq.c                     |   23=20
 drivers/firmware/Kconfig                             |    5=20
 drivers/firmware/iscsi_ibft.c                        |    4=20
 drivers/hid/hid-holtek-kbd.c                         |    9=20
 drivers/hid/usbhid/hiddev.c                          |   12=20
 drivers/hwmon/nct6775.c                              |    3=20
 drivers/hwmon/nct7802.c                              |    6=20
 drivers/infiniband/core/mad.c                        |   20=20
 drivers/infiniband/core/user_mad.c                   |    6=20
 drivers/input/joystick/iforce/iforce-usb.c           |    5=20
 drivers/input/mouse/trackpoint.h                     |    3=20
 drivers/input/tablet/kbtab.c                         |    6=20
 drivers/iommu/amd_iommu_init.c                       |    2=20
 drivers/irqchip/irq-imx-gpcv2.c                      |    1=20
 drivers/net/bonding/bond_main.c                      |    4=20
 drivers/net/can/usb/peak_usb/pcan_usb_core.c         |    8=20
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c           |    2=20
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c          |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |    7=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h      |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c     |   17=20
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c    |   97 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    3=20
 drivers/net/team/team.c                              |    4=20
 drivers/net/usb/pegasus.c                            |    2=20
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c         |    2=20
 drivers/net/wireless/marvell/mwifiex/main.h          |    1=20
 drivers/net/wireless/marvell/mwifiex/scan.c          |    3=20
 drivers/net/xen-netback/netback.c                    |    2=20
 drivers/s390/cio/qdio_main.c                         |   12=20
 drivers/scsi/device_handler/scsi_dh_alua.c           |    7=20
 drivers/scsi/hpsa.c                                  |   12=20
 drivers/scsi/ibmvscsi/ibmvfc.c                       |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c            |    3=20
 drivers/scsi/mpt3sas/mpt3sas_base.c                  |   12=20
 drivers/staging/comedi/drivers/dt3000.c              |    8=20
 drivers/tty/tty_ldsem.c                              |    5=20
 drivers/usb/class/cdc-acm.c                          |   12=20
 drivers/usb/core/devio.c                             |    2=20
 drivers/usb/core/file.c                              |   10=20
 drivers/usb/core/message.c                           |    4=20
 drivers/usb/misc/iowarrior.c                         |    7=20
 drivers/usb/misc/yurex.c                             |    2=20
 drivers/usb/serial/option.c                          |   10=20
 drivers/vhost/net.c                                  |   34 -
 drivers/vhost/scsi.c                                 |   15=20
 drivers/vhost/vhost.c                                |   20=20
 drivers/vhost/vhost.h                                |    6=20
 drivers/vhost/vsock.c                                |   12=20
 drivers/xen/xen-pciback/conf_space_capability.c      |    3=20
 fs/cifs/smb2pdu.c                                    |    7=20
 fs/ocfs2/xattr.c                                     |    3=20
 include/asm-generic/getorder.h                       |   50 -
 include/linux/filter.h                               |    1=20
 include/linux/siphash.h                              |  145 +++++
 include/net/netfilter/nf_conntrack.h                 |    2=20
 include/net/netns/ipv4.h                             |    2=20
 include/sound/compress_driver.h                      |    5=20
 kernel/bpf/core.c                                    |   73 ++
 kernel/events/core.c                                 |    2=20
 lib/Kconfig.debug                                    |    6=20
 lib/Makefile                                         |    5=20
 lib/siphash.c                                        |  551 ++++++++++++++=
+++++
 lib/test_siphash.c                                   |  223 +++++++
 mm/memcontrol.c                                      |   39 +
 mm/usercopy.c                                        |    2=20
 mm/vmalloc.c                                         |    9=20
 net/core/sysctl_net_core.c                           |   71 ++
 net/ipv4/route.c                                     |   12=20
 net/ipv6/output_core.c                               |   30 -
 net/mac80211/driver-ops.c                            |   13=20
 net/mac80211/mlme.c                                  |   10=20
 net/netfilter/nf_conntrack_core.c                    |   35 +
 net/netfilter/nf_conntrack_netlink.c                 |   34 +
 net/netfilter/nfnetlink.c                            |    2=20
 net/packet/af_packet.c                               |    7=20
 net/sctp/sm_sideeffect.c                             |    2=20
 net/socket.c                                         |    9=20
 scripts/Makefile.modpost                             |    2=20
 sound/core/compress_offload.c                        |   60 +-
 sound/firewire/packets-buffer.c                      |    2=20
 sound/pci/hda/hda_controller.c                       |    6=20
 sound/pci/hda/hda_generic.c                          |   21=20
 sound/pci/hda/hda_generic.h                          |    1=20
 sound/pci/hda/patch_conexant.c                       |   15=20
 sound/pci/hda/patch_realtek.c                        |   11=20
 sound/sound_core.c                                   |    3=20
 tools/perf/arch/s390/util/machine.c                  |   14=20
 tools/perf/builtin-probe.c                           |   10=20
 tools/perf/util/header.c                             |    9=20
 tools/perf/util/machine.c                            |    7=20
 tools/perf/util/machine.h                            |    2=20
 tools/perf/util/symbol-elf.c                         |    2=20
 tools/perf/util/symbol.c                             |   21=20
 tools/perf/util/symbol.h                             |    2=20
 tools/perf/util/thread.c                             |   12=20
 119 files changed, 1893 insertions(+), 382 deletions(-)

Adrian Hunter (1):
      perf db-export: Fix thread__exec_comm()

Alan Stern (1):
      USB: core: Fix races in character device registration and deregistrai=
on

Arnaldo Carvalho de Melo (1):
      perf probe: Avoid calling freeing routine multiple times for same poi=
nter

Arnd Bergmann (2):
      drbd: dynamically allocate shash descriptor
      ARM: davinci: fix sleep.S build error on ARMv4

Bj=C3=B6rn Gerhart (1):
      hwmon: (nct6775) Fix register address and added missed tolerance for =
nct6106

Bob Ham (1):
      USB: serial: option: add the BroadMobi BM818 card

Brian Norris (3):
      mac80211: don't warn about CW params when not using them
      mac80211: don't WARN on short WMM parameters from AP
      mwifiex: fix 802.11n/WPA detection

Charles Keepax (4):
      ALSA: compress: Fix regression on compressed capture streams
      ALSA: compress: Prevent bypasses of set_params
      ALSA: compress: Don't allow paritial drain operations on capture stre=
ams
      ALSA: compress: Be more restrictive about when a drain is allowed

Daniel Borkmann (4):
      bpf: get rid of pure_initcall dependency to enable jits
      bpf: restrict access to core bpf sysctls
      bpf: add bpf_jit_limit knob to restrict unpriv allocations
      bpf: fix bpf_jit_limit knob for PAGE_SIZE >=3D 64K

Denis Kirjanov (1):
      net: usb: pegasus: fix improper read if get_registers() fail

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Don Brace (1):
      scsi: hpsa: correct scsi command status issue after reset

Emmanuel Grumbach (1):
      iwlwifi: don't unmap as page memory that was mapped as single

Eric Dumazet (2):
      inet: switch IP ID generator to siphash
      net/packet: fix race in tpacket_snd()

Florian Westphal (2):
      netfilter: nfnetlink: avoid deadlock due to synchronous request_module
      netfilter: ctnetlink: don't use conntrack/expect object addresses as =
id

Gavin Li (1):
      usb: usbfs: fix double-free of usb memory upon submiturb error

Greg Kroah-Hartman (1):
      Linux 4.9.190

Guenter Roeck (1):
      hwmon: (nct7802) Fix wrong detection of in4 presence

Gustavo A. R. Silva (1):
      sh: kernel: hw_breakpoint: Fix missing break in switch statement

Hannes Reinecke (1):
      scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG

Hillf Danton (2):
      HID: hiddev: avoid opening a disconnected device
      HID: hiddev: do cleanup in failure of opening a device

Hui Wang (2):
      ALSA: hda - Add a generic reboot_notify
      ALSA: hda - Let all conexant codec enter D3 when rebooting

Huy Nguyen (1):
      net/mlx5e: Only support tx/rx pause setting for port owner

Ian Abbott (2):
      staging: comedi: dt3000: Fix signed integer overflow 'divider * base'
      staging: comedi: dt3000: Fix rounding up of timer divisor

Isaac J. Manjarres (1):
      mm/usercopy: use memory range to be accessed for wraparound check

Jack Morgenstein (1):
      IB/mad: Fix use-after-free in ib mad completion handling

Jason A. Donenfeld (2):
      siphash: add cryptographically secure PRF
      siphash: implement HalfSipHash1-3 for hash tables

Jason Wang (4):
      vhost_net: introduce vhost_exceeds_weight()
      vhost: introduce vhost_exceeds_weight()
      vhost_net: fix possible infinite loop
      vhost: scsi: add weight support

Joerg Roedel (4):
      x86/mm: Check for pfn instead of page in vmalloc_sync_one()
      x86/mm: Sync also unmappings in vmalloc_sync_all()
      mm/vmalloc: Sync unmappings in __purge_vmap_area_lazy()
      iommu/amd: Move iommu_init_pci() to .init section

Julian Wiedmann (1):
      s390/qdio: add sanity checks to the fast-requeue path

Junxiao Bi (1):
      scsi: megaraid_sas: fix panic on loading firmware crashdump

Kees Cook (1):
      libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Leonard Crestez (1):
      perf/core: Fix creating kernel counters for PMUs that override event-=
>cpu

Lorenzo Pieralisi (1):
      ACPI/IORT: Fix off-by-one check in iort_dev_find_its_id()

Lucas Stach (1):
      irqchip/irq-imx-gpcv2: Forward irq type to parent

Manish Chopra (1):
      bnx2x: Fix VF's VLAN reconfiguration in reload.

Masahiro Yamada (1):
      kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules

Max Filippov (1):
      xtensa: add missing isync to the cpu_reset TLB code

Maxim Mikityanskiy (1):
      net/mlx5e: Use flow keys dissector to parse packets for ARFS

Miles Chen (1):
      mm/memcontrol.c: fix use after free in mem_cgroup_iter()

Miquel Raynal (1):
      ata: libahci: do not complain in case of deferred probe

Numfor Mbiziwo-Tiapo (1):
      perf header: Fix use of unitialized value warning

Oliver Neukum (6):
      usb: iowarrior: fix deadlock on disconnect
      HID: holtek: test for sanity of intfdata
      Input: kbtab - sanity check for endpoint type
      Input: iforce - add sanity checks
      usb: cdc-acm: make sure a refcount is taken early enough
      USB: CDC: fix sanity checks in CDC union parser

Paolo Abeni (1):
      vhost_net: use packet weight for rx handler, too

Pavel Shilovsky (1):
      SMB3: Fix deadlock in validate negotiate hits reconnect

Peter Zijlstra (1):
      tty/ldsem, locking/rwsem: Add missing ACQUIRE to read_failed sleep lo=
op

Qian Cai (3):
      arm64/efi: fix variable 'si' set but not used
      arm64/mm: fix variable 'pud' set but not used
      asm-generic: fix -Wtype-limits compiler warnings

Rogan Dawes (1):
      USB: serial: option: add D-Link DWM-222 device ID

Ross Lagerwall (1):
      xen/netback: Reset nr_frags before freeing skb

Stephane Grosjean (1):
      can: peak_usb: fix potential double kfree_skb()

Steve French (1):
      smb3: send CAP_DFS capability during session setup

Suganath Prabu (1):
      scsi: mpt3sas: Use 63-bit DMA addressing on SAS35 HBA

Suzuki K Poulose (1):
      usb: yurex: Fix use-after-free in yurex_delete

Takashi Iwai (1):
      ALSA: hda - Don't override global PCM hw info flag

Thomas Richter (2):
      perf record: Fix wrong size in perf_record_mmap for last kernel module
      perf record: Fix module size on s390

Thomas Tai (1):
      iscsi_ibft: make ISCSI_IBFT dependson ACPI instead of ISCSI_IBFT_FIND

Tomas Bortoli (2):
      can: peak_usb: pcan_usb_pro: Fix info-leaks to USB devices
      can: peak_usb: pcan_usb_fd: Fix info-leaks to USB devices

Tony Lindgren (1):
      USB: serial: option: Add Motorola modem UARTs

Tony Luck (1):
      IB/core: Add mitigation for Spectre V1

Tyrel Datwyler (1):
      scsi: ibmvfc: fix WARN_ON during event pool release

Vince Weaver (1):
      perf header: Fix divide by zero error if f_header.attr_size=3D=3D0

Wen Yang (1):
      cpufreq/pasemi: fix use-after-free in pas_cpufreq_cpu_init()

Wenwen Wang (3):
      sound: fix a memory leak bug
      ALSA: firewire: fix a memory leak bug
      ALSA: hda - Fix a memory leak bug

Will Deacon (1):
      arm64: compat: Allow single-byte watchpoints on all addresses

Xin Long (1):
      sctp: fix the transport error_count check

Yoshiaki Okamoto (1):
      USB: serial: option: Add support for ZTE MF871A

YueHaibing (5):
      xen/pciback: remove set but not used variable 'old_state'
      ocfs2: remove set but not used variable 'last_hash'
      Input: psmouse - fix build error of multiple definition
      team: Add vlan tx offload to hw_enc_features
      bonding: Add vlan tx offload to hw_enc_features

haibinzhang(=E5=BC=A0=E6=B5=B7=E6=96=8C) (1):
      vhost-net: set packet weight of tx polling to 2 * vq size


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1ioAgACgkQONu9yGCS
aT5KZg/9H8i1Xdul/lxZ6W3v/N4dpworOUhQgMhEGHVF2E4hx9sMV/tFEVotTPqh
w9QQlWHHyeGNj+vRIj42sY7AXNic06+1m/BrUSJhUBSWgseC2YZr4vky2qh/5zXE
qjsK/syeX/qVcUkeV/+k10Fmjqex38fxKbWMzYGRGAwhbji2fWuNObqyvZGJpdEF
jwoXX+yib3EPz3MUDBwgIbEUWXdwMfQM2PJUgHI++WC87U1SIHvaLIjYFPZ17eHF
VwpNA1hlhLhAayz6I1BcIW2tTsmUPRXyppp+WOrhkAF7SletgXh/P4r1thA6ceRi
28xaSbqEPBteStHDyC+QoYCBVTcAH+4dBJjYsUEAj4NfX1yJKQoMzmwugkuFjFrO
OD+jK/CUfyV8uuTp6m4jZwjmxlNz5Xe556LE+CcHM8+a3r2cy74qxnUxuIFNGHT9
qrbKj943NiqOMySyGaPiky1DnUdCdsgJ5bvQGCwMdGKw5C18DjQQih01g7GBupLo
z8G/NUBEdZxDRuJIPphrb8oTY2bvlhKHIiBlsPLGsw9rK50tHKfhTUbxFu0HseZ4
/SmU0Mk7N/AmnTX508jRKbX8/i87hMsiiO4iCsFxQLhnOHm/M/Wt/RmYsutpcQJ1
0SarkQgJltqf371JVTff8TixMNI2biBKamlu408IO3pR1W+dSA0=
=uZ6O
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
