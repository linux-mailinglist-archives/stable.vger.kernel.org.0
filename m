Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BDB9C48B
	for <lists+stable@lfdr.de>; Sun, 25 Aug 2019 16:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfHYOvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Aug 2019 10:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbfHYOvE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 25 Aug 2019 10:51:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 534AF206DD;
        Sun, 25 Aug 2019 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566744662;
        bh=7+R+GV+t0ZUOaTNpzkHofc/wro7C7dvHiA5Zm6gZuvI=;
        h=Date:From:To:Cc:Subject:From;
        b=Frwk6W8oyxZww9tWXjmdW/vvFdLQ4wZuRhLXXQhL+GtM8HdcfUDBmeVRUd7qm7C/v
         YeZ1xukXOAzpD1W+CXzGCEZcCM45RTdm5qY2KenWlqUodozv7/OY7fcv7s6t/IS8yr
         nIDlFp/AD/rPstaIj6ujY+SVS6z7Fav/QQuoe53c=
Date:   Sun, 25 Aug 2019 16:51:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.68
Message-ID: <20190825145100.GA30271@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.68 kernel.

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

 Makefile                                             |    2=20
 arch/arm64/include/asm/efi.h                         |    6 -
 arch/arm64/include/asm/pgtable.h                     |    4=20
 arch/arm64/kernel/ftrace.c                           |   21 ++-
 arch/arm64/kernel/return_address.c                   |    3=20
 arch/arm64/kernel/stacktrace.c                       |    3=20
 arch/arm64/kvm/regmap.c                              |    5=20
 arch/riscv/include/asm/switch_to.h                   |    2=20
 arch/sh/kernel/hw_breakpoint.c                       |    1=20
 arch/xtensa/kernel/setup.c                           |    1=20
 drivers/ata/libahci_platform.c                       |    3=20
 drivers/ata/libata-zpodd.c                           |    2=20
 drivers/clk/at91/clk-generated.c                     |    2=20
 drivers/clk/renesas/renesas-cpg-mssr.c               |   16 ---
 drivers/clk/sprd/Kconfig                             |    1=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c          |    2=20
 drivers/gpu/drm/bridge/Kconfig                       |    1=20
 drivers/gpu/drm/exynos/exynos_drm_scaler.c           |    4=20
 drivers/gpu/drm/msm/msm_drv.c                        |    3=20
 drivers/hid/hid-holtek-kbd.c                         |    9 +
 drivers/hid/usbhid/hiddev.c                          |   12 ++
 drivers/iio/adc/max9611.c                            |    2=20
 drivers/infiniband/core/mad.c                        |   20 +--
 drivers/infiniband/core/user_mad.c                   |    6 -
 drivers/infiniband/hw/mlx5/mr.c                      |   27 +----
 drivers/input/joystick/iforce/iforce-usb.c           |    5=20
 drivers/input/mouse/trackpoint.h                     |    3=20
 drivers/input/tablet/kbtab.c                         |    6 -
 drivers/iommu/amd_iommu_init.c                       |    2=20
 drivers/irqchip/irq-gic-v3-its.c                     |    2=20
 drivers/irqchip/irq-imx-gpcv2.c                      |    1=20
 drivers/md/dm-core.h                                 |    1=20
 drivers/md/dm-rq.c                                   |   11 +-
 drivers/md/dm.c                                      |   20 +++
 drivers/mmc/host/sdhci-of-arasan.c                   |    3=20
 drivers/net/bonding/bond_main.c                      |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |    7 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h      |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c     |   17 ++-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c           |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c    |   97 ++++++--------=
----
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    3=20
 drivers/net/team/team.c                              |    2=20
 drivers/net/usb/pegasus.c                            |    2=20
 drivers/net/xen-netback/netback.c                    |    2=20
 drivers/pwm/sysfs.c                                  |    1=20
 drivers/scsi/hpsa.c                                  |   12 ++
 drivers/scsi/qla2xxx/qla_init.c                      |    2=20
 drivers/staging/comedi/drivers/dt3000.c              |    8 -
 drivers/usb/class/cdc-acm.c                          |   12 +-
 drivers/usb/core/file.c                              |   10 -
 drivers/usb/core/message.c                           |    4=20
 drivers/usb/gadget/udc/renesas_usb3.c                |    5=20
 drivers/usb/serial/option.c                          |   10 +
 drivers/xen/xen-pciback/conf_space_capability.c      |    3=20
 fs/btrfs/backref.c                                   |    2=20
 fs/btrfs/transaction.c                               |   22 +++-
 fs/btrfs/transaction.h                               |    3=20
 fs/ocfs2/xattr.c                                     |    3=20
 fs/seq_file.c                                        |    2=20
 include/asm-generic/getorder.h                       |   50 +++------
 include/drm/i915_pciids.h                            |    1=20
 include/kvm/arm_vgic.h                               |    1=20
 kernel/sched/cpufreq_schedutil.c                     |   14 +-
 mm/kmemleak.c                                        |    2=20
 mm/memcontrol.c                                      |   39 +++++--
 mm/mempolicy.c                                       |  100 +++++++++++++-=
-----
 mm/rmap.c                                            |    8 +
 mm/usercopy.c                                        |    2=20
 net/bridge/netfilter/ebtables.c                      |   28 +++--
 net/dsa/switch.c                                     |    3=20
 net/netfilter/nf_conntrack_core.c                    |   16 +--
 net/packet/af_packet.c                               |    7 +
 net/sctp/sm_sideeffect.c                             |    2=20
 net/sctp/stream.c                                    |    1=20
 net/tipc/addr.c                                      |    1=20
 scripts/Kconfig.include                              |    2=20
 scripts/Makefile.modpost                             |    2=20
 sound/pci/hda/hda_generic.c                          |   21 +++
 sound/pci/hda/hda_generic.h                          |    1=20
 sound/pci/hda/hda_intel.c                            |    3=20
 sound/pci/hda/patch_conexant.c                       |   15 --
 sound/pci/hda/patch_realtek.c                        |   12 --
 sound/usb/mixer.c                                    |   37 +++++--
 tools/perf/util/header.c                             |    9 +
 virt/kvm/arm/arm.c                                   |   11 ++
 virt/kvm/arm/vgic/vgic-v2.c                          |    9 +
 virt/kvm/arm/vgic/vgic-v3.c                          |    7 +
 virt/kvm/arm/vgic/vgic.c                             |   11 ++
 virt/kvm/arm/vgic/vgic.h                             |    2=20
 90 files changed, 550 insertions(+), 315 deletions(-)

Alan Stern (1):
      USB: core: Fix races in character device registration and deregistrai=
on

Anders Roxell (1):
      arm64: KVM: regmap: Fix unexpected switch fall-through

Bob Ham (1):
      USB: serial: option: add the BroadMobi BM818 card

Chen-Yu Tsai (1):
      net: dsa: Check existence of .port_mdb_add callback before calling it

Chris Packham (1):
      tipc: initialise addr_trail_end when setting node addresses

Chunyan Zhang (1):
      clk: sprd: Select REGMAP_MMIO to avoid compile errors

Codrin Ciubotariu (1):
      clk: at91: generated: Truncate divisor to GENERATED_MAX_DIV + 1

Colin Ian King (1):
      drm/exynos: fix missing decrement of retry counter

Denis Kirjanov (1):
      net: usb: pegasus: fix improper read if get_registers() fail

Dirk Morris (1):
      netfilter: conntrack: Use consistent ct id hash calculation

Don Brace (1):
      scsi: hpsa: correct scsi command status issue after reset

Eric Dumazet (1):
      net/packet: fix race in tpacket_snd()

Fabrice Gasnier (1):
      Revert "pwm: Set class for exported channels in sysfs"

Filipe Manana (1):
      Btrfs: fix deadlock between fiemap and transaction commits

Florian Westphal (1):
      netfilter: ebtables: also count base chain policies

Geert Uytterhoeven (1):
      clk: renesas: cpg-mssr: Fix reset control race condition

Greg Kroah-Hartman (1):
      Linux 4.19.68

Gustavo A. R. Silva (1):
      sh: kernel: hw_breakpoint: Fix missing break in switch statement

Guy Levi (1):
      IB/mlx5: Fix MR registration flow to use UMR properly

Hillf Danton (2):
      HID: hiddev: avoid opening a disconnected device
      HID: hiddev: do cleanup in failure of opening a device

Hui Peng (2):
      ALSA: usb-audio: Fix a stack buffer overflow bug in check_input_term
      ALSA: usb-audio: Fix an OOB bug in parse_audio_mixer_unit

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

Jacopo Mondi (1):
      iio: adc: max9611: Fix temperature reading in probe

Jeffrey Hugo (1):
      drm: msm: Fix add_gpu_components

Jia-Ju Bai (1):
      scsi: qla2xxx: Fix possible fcport null-pointer dereferences

Joerg Roedel (1):
      iommu/amd: Move iommu_init_pci() to .init section

Kees Cook (1):
      libata: zpodd: Fix small read overflow in zpodd_get_mech_type()

Lucas Stach (1):
      irqchip/irq-imx-gpcv2: Forward irq type to parent

Manish Chopra (1):
      bnx2x: Fix VF's VLAN reconfiguration in reload.

Marc Zyngier (1):
      KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block

Masahiro Yamada (1):
      kbuild: modpost: handle KBUILD_EXTRA_SYMBOLS only for external modules

Masami Hiramatsu (1):
      arm64: unwind: Prohibit probing on return_address()

Max Filippov (1):
      xtensa: add missing isync to the cpu_reset TLB code

Maxim Mikityanskiy (1):
      net/mlx5e: Use flow keys dissector to parse packets for ARFS

Michal Simek (1):
      mmc: sdhci-of-arasan: Do now show error message in case of deffered p=
robe

Mike Snitzer (1):
      dm: disable DISCARD if the underlying storage no longer supports it

Miles Chen (1):
      mm/memcontrol.c: fix use after free in mem_cgroup_iter()

Miquel Raynal (1):
      ata: libahci: do not complain in case of deferred probe

NeilBrown (1):
      seq_file: fix problem when seeking mid-record

Nianyao Tang (1):
      irqchip/gic-v3-its: Free unused vpt_page when alloc vpe table fail

Numfor Mbiziwo-Tiapo (1):
      perf header: Fix use of unitialized value warning

Oliver Neukum (5):
      HID: holtek: test for sanity of intfdata
      Input: kbtab - sanity check for endpoint type
      Input: iforce - add sanity checks
      usb: cdc-acm: make sure a refcount is taken early enough
      USB: CDC: fix sanity checks in CDC union parser

Qian Cai (3):
      arm64/efi: fix variable 'si' set but not used
      arm64/mm: fix variable 'pud' set but not used
      asm-generic: fix -Wtype-limits compiler warnings

Ralph Campbell (1):
      mm/hmm: fix bad subpage pointer in try_to_unmap_one

Rodrigo Vivi (1):
      drm/i915/cfl: Add a new CFL PCI ID.

Rogan Dawes (1):
      USB: serial: option: add D-Link DWM-222 device ID

Ross Lagerwall (1):
      xen/netback: Reset nr_frags before freeing skb

Stephen Boyd (1):
      kbuild: Check for unknown options with cc-option usage in Kconfig and=
 clang

Takashi Iwai (2):
      ALSA: hda/realtek - Add quirk for HP Envy x360
      ALSA: hda - Apply workaround for another AMD chip 1022:1487

Tony Lindgren (1):
      USB: serial: option: Add Motorola modem UARTs

Tony Luck (1):
      IB/core: Add mitigation for Spectre V1

Vince Weaver (1):
      perf header: Fix divide by zero error if f_header.attr_size=3D=3D0

Vincent Chen (1):
      riscv: Make __fstate_clean() work correctly.

Viresh Kumar (1):
      cpufreq: schedutil: Don't skip freq update when limits change

Wang Xiayang (1):
      drm/amdgpu: fix a potential information leaking bug

Wenwen Wang (2):
      ALSA: hda - Fix a memory leak bug
      net/mlx4_en: fix a memory leak bug

Will Deacon (1):
      arm64: ftrace: Ensure module ftrace trampoline is coherent with I-side

Xin Long (1):
      sctp: fix the transport error_count check

Yang Shi (3):
      mm: mempolicy: make the behavior consistent when MPOL_MF_MOVE* and MP=
OL_MF_STRICT were specified
      mm: mempolicy: handle vma with unmovable pages mapped correctly in mb=
ind
      Revert "kmemleak: allow to coexist with fault injection"

Yoshiaki Okamoto (1):
      USB: serial: option: Add support for ZTE MF871A

Yoshihiro Shimoda (1):
      usb: gadget: udc: renesas_usb3: Fix sysfs interface of "role"

YueHaibing (6):
      xen/pciback: remove set but not used variable 'old_state'
      drm/bridge: lvds-encoder: Fix build error while CONFIG_DRM_KMS_HELPER=
=3Dm
      ocfs2: remove set but not used variable 'last_hash'
      Input: psmouse - fix build error of multiple definition
      bonding: Add vlan tx offload to hw_enc_features
      team: Add vlan tx offload to hw_enc_features

zhengbin (1):
      sctp: fix memleak in sctp_send_reset_streams


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1ioFQACgkQONu9yGCS
aT7j5RAAzdUsaFsc+BUyjFy/Pym7JS9z6Xavqeq4Pxhl1YpiCIdZy8yJzVI7xcbb
lTRed6zwEsE39zs6YlCw1s1vKF2t9fNis8cJQxXQ1eaqaZAk7fuiWwa+V3TVzYyy
R8kW6dUfO1tdrACmnW8pEMErrg21ttbGm2U1ecIM3PVmRaKySrD76K9rajXli3Bn
oAg+OvCjJ31fqoyGQR7s0V5137txG/6UMgm8iuI5VSH4rxvT+NEhzvb2pW2yTXCb
OVpeZiG+ZHCAsrvDedljnOaRrhlpIW/BBnK81xPb6ltW2pjVnd/sTz2IYipkY0wE
u8o3PWgP19XPehxcs0r/qXeL1Dr08wAzY1WkHIzqbQTYw2W4W/YQcBxTA0RLlADZ
2c5ny+rMUzaIg9/qgAY2Qj925salR+D6Typw5tcvP+bGRRTF4bXujZbHQTKm+aYK
jsROlXYcmbNMiAjp/yYuH5lIf4WAxJmBs50BdzGtj1CrVkuKiDsti/q0dWihyRn+
PQxgcN3rnBcXhfKUZtwk69OpJjB81bgIK+80xznOY/VvGI5kiUEdLNCJn3NSOEDu
SJENnXEcXUpeP5yOAbswys9IpGUS8X7GSqkQIWp7OHapYROINWDUjRIUct1KaZG1
NOMlhur8uaE596qO4o7SytSuIrkAOAaertDp7JqAPhTygp73z9g=
=WqW+
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
