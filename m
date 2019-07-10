Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A1364698
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 14:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfGJM7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 08:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfGJM7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jul 2019 08:59:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9DBA20651;
        Wed, 10 Jul 2019 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562763557;
        bh=S2dBxdbrDMt+fut8ItjnVElw7HSilYtXA/3qP/GqGYU=;
        h=Date:From:To:Cc:Subject:From;
        b=Ukcj0vuQGENXuckKwUhMqYvRl8o+rVQN/AAWOLa3xt60ikZe1MtXKjPuVdG2+YUA6
         0VKqO5DQBqwua9CiHzXbTs6jhspdTcZkAICUIaLh5lEq7MxlaKRr/JsLoF/pG/YYNP
         xs3ouLu8qzpHLGdIAKjParB6XM3+v4ockwUSFV9w=
Date:   Wed, 10 Jul 2019 14:59:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.185
Message-ID: <20190710125914.GA11555@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.185 kernel.

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

 Makefile                                              |    4 +-
 arch/arc/Kconfig                                      |    2 -
 arch/arc/include/asm/bug.h                            |    3 +
 arch/arc/include/asm/cmpxchg.h                        |   14 +++++--
 arch/arc/kernel/traps.c                               |    8 ++++
 arch/arc/mm/tlb.c                                     |   13 ++++--
 arch/arm/mach-imx/cpuidle-imx6sx.c                    |    3 +
 arch/arm64/kernel/module.c                            |    8 +++-
 arch/arm64/kernel/vdso.c                              |   10 ++---
 arch/ia64/include/asm/bug.h                           |    6 ++-
 arch/m68k/include/asm/bug.h                           |    3 +
 arch/mips/Kconfig                                     |    1=20
 arch/mips/include/asm/compiler.h                      |   35 +++++++++++++=
+++++
 arch/mips/include/asm/netlogic/xlr/fmn.h              |    2 -
 arch/mips/kernel/uprobes.c                            |    3 -
 arch/mips/math-emu/cp1emu.c                           |    4 +-
 arch/mips/mm/tlbex.c                                  |   29 ++++++++++----
 arch/parisc/math-emu/cnv_float.h                      |    8 ++--
 arch/powerpc/include/asm/ppc-opcode.h                 |    1=20
 arch/powerpc/net/bpf_jit.h                            |    2 -
 arch/powerpc/net/bpf_jit_comp64.c                     |    8 ++--
 arch/sparc/include/asm/bug.h                          |    6 ++-
 arch/sparc/kernel/perf_event.c                        |    4 ++
 arch/x86/kernel/cpu/bugs.c                            |   11 +++++
 arch/x86/kvm/lapic.c                                  |    2 -
 arch/x86/kvm/x86.c                                    |    6 +--
 crypto/crypto_user.c                                  |    3 +
 drivers/clk/sunxi/clk-sun8i-bus-gates.c               |    4 ++
 drivers/dma/imx-sdma.c                                |    4 +-
 drivers/gpu/drm/arm/hdlcd_crtc.c                      |    3 +
 drivers/gpu/drm/i915/intel_csr.c                      |   18 +++++++++
 drivers/gpu/drm/imx/ipuv3-crtc.c                      |    6 +--
 drivers/gpu/drm/mediatek/mtk_dsi.c                    |    2 +
 drivers/hwmon/pmbus/pmbus_core.c                      |   34 +++++++++++++=
++--
 drivers/infiniband/hw/hfi1/chip.c                     |    1=20
 drivers/infiniband/hw/hfi1/sdma.c                     |    9 +---
 drivers/infiniband/hw/hfi1/user_sdma.c                |   13 ++----
 drivers/infiniband/hw/hfi1/verbs.c                    |    2 -
 drivers/infiniband/hw/hfi1/verbs_txreq.c              |    2 -
 drivers/infiniband/hw/hfi1/verbs_txreq.h              |    3 +
 drivers/infiniband/hw/qib/qib_verbs.c                 |    2 -
 drivers/infiniband/sw/rdmavt/mr.c                     |    2 +
 drivers/infiniband/sw/rdmavt/qp.c                     |    3 +
 drivers/input/misc/uinput.c                           |   22 ++++++++++-
 drivers/mfd/omap-usb-tll.c                            |    4 +-
 drivers/net/bonding/bond_main.c                       |    2 -
 drivers/net/can/flexcan.c                             |    2 -
 drivers/net/dsa/mv88e6xxx/chip.c                      |    2 -
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c      |    4 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           |   15 ++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c |    2 -
 drivers/net/team/team.c                               |    2 -
 drivers/net/tun.c                                     |   19 ++++-----
 drivers/nvme/host/core.c                              |    3 +
 drivers/parport/share.c                               |    2 +
 drivers/s390/net/qeth_l2_main.c                       |    2 -
 drivers/scsi/hpsa.c                                   |    7 +++
 drivers/scsi/hpsa_cmd.h                               |    1=20
 drivers/scsi/ufs/ufshcd-pltfrm.c                      |   11 ++---
 drivers/scsi/ufs/ufshcd.c                             |    3 +
 drivers/scsi/vmw_pvscsi.c                             |    6 ++-
 drivers/spi/spi-bitbang.c                             |    2 -
 drivers/tty/rocket.c                                  |    2 -
 drivers/usb/chipidea/udc.c                            |   20 ++++++++++
 drivers/usb/gadget/udc/fusb300_udc.c                  |    5 ++
 drivers/usb/gadget/udc/lpc32xx_udc.c                  |    3 -
 fs/9p/acl.c                                           |    2 -
 fs/binfmt_flat.c                                      |   23 +++--------
 fs/btrfs/dev-replace.c                                |   29 +++++++++-----
 fs/btrfs/reada.c                                      |    5 ++
 fs/btrfs/volumes.c                                    |    2 +
 fs/btrfs/volumes.h                                    |    5 ++
 fs/nfs/flexfilelayout/flexfilelayoutdev.c             |    2 -
 fs/proc/array.c                                       |    2 -
 include/asm-generic/bug.h                             |    1=20
 include/linux/compiler-gcc.h                          |   15 +++++++
 include/linux/compiler.h                              |    5 ++
 include/net/bluetooth/hci_core.h                      |    3 +
 kernel/cpu.c                                          |    3 +
 kernel/ptrace.c                                       |    4 --
 kernel/trace/trace.c                                  |    6 ---
 kernel/trace/trace.h                                  |   18 +++++++++
 kernel/trace/trace_kdb.c                              |    6 ---
 lib/mpi/mpi-pow.c                                     |    6 +--
 mm/mlock.c                                            |    4 +-
 mm/page_idle.c                                        |    4 +-
 net/9p/protocol.c                                     |   12 ++++--
 net/9p/trans_common.c                                 |    1=20
 net/9p/trans_rdma.c                                   |    7 +--
 net/bluetooth/hci_conn.c                              |   10 ++++-
 net/bluetooth/l2cap_core.c                            |   33 +++++++++++++=
+--
 net/can/af_can.c                                      |    1=20
 net/core/dev.c                                        |    5 ++
 net/ipv4/raw.c                                        |    2 -
 net/ipv4/udp.c                                        |    6 ++-
 net/ipv6/udp.c                                        |    4 +-
 net/mac80211/rx.c                                     |    2 +
 net/mac80211/wpa.c                                    |    7 +++
 net/packet/af_packet.c                                |   20 ++++++++--
 net/packet/internal.h                                 |    1=20
 net/sctp/endpointola.c                                |    8 ++--
 net/tipc/core.c                                       |   12 +++---
 net/tipc/netlink_compat.c                             |   18 +++++++--
 net/tipc/udp_media.c                                  |    8 +---
 net/wireless/core.c                                   |    2 -
 scripts/checkstack.pl                                 |    2 -
 scripts/decode_stacktrace.sh                          |    2 -
 security/apparmor/policy_unpack.c                     |    2 -
 sound/core/seq/oss/seq_oss_ioctl.c                    |    2 -
 sound/core/seq/oss/seq_oss_rw.c                       |    2 -
 sound/firewire/amdtp-am824.c                          |    2 -
 sound/soc/codecs/cs4265.c                             |    2 -
 sound/soc/codecs/max98090.c                           |   16 ++++++++
 sound/soc/soc-pcm.c                                   |    3 +
 sound/usb/line6/pcm.c                                 |    5 ++
 sound/usb/mixer_quirks.c                              |    4 +-
 tools/perf/builtin-help.c                             |    2 -
 tools/perf/ui/tui/helpline.c                          |    2 -
 tools/perf/util/header.c                              |    2 -
 119 files changed, 567 insertions(+), 233 deletions(-)

Adeodato Sim=F3 (1):
      net/9p: include trans_common.h to fix missing prototype warning.

Alejandro Jimenez (1):
      x86/speculation: Allow guests to use SSBD even if host does not

Alexandra Winter (1):
      s390/qeth: fix VLAN attribute in bridge_hostnotify udev event

Alexandre Belloni (1):
      usb: gadget: udc: lpc32xx: allocate descriptor with GFP_ATOMIC

Andrey Smirnov (1):
      Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD

Ard Biesheuvel (1):
      arm64: kaslr: keep modules inside module region when KASAN is enabled

Arnaldo Carvalho de Melo (3):
      perf ui helpline: Use strlcpy() as a shorter form of strncpy() + expl=
icit set nul
      perf help: Remove needless use of strncpy()
      perf header: Fix unchecked usage of strncpy()

Arnd Bergmann (3):
      mfd: omap-usb-tll: Fix register offsets
      bug.h: work around GCC PR82365 in BUG()
      clk: sunxi: fix uninitialized access

Avri Altman (1):
      scsi: ufs: Check that space was properly alloced in copy_query_respon=
se

Colin Ian King (3):
      mm/page_idle.c: fix oops because end_pfn is larger than max_pfn
      ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
      ALSA: usb-audio: fix sign unintended sign extension on left shifts

Dmitry Korotin (1):
      MIPS: Add missing EHB in mtc0 -> mfc0 sequence.

Dominique Martinet (4):
      9p/rdma: do not disconnect on down_interruptible EAGAIN
      9p: acl: fix uninitialized iattr access
      9p/rdma: remove useless check in cm_event_handler
      9p: p9dirent_read: check network-provided name length

Don Brace (1):
      scsi: hpsa: correct ioaccel2 chaining

Eric Biggers (2):
      cfg80211: fix memory leak of wiphy device name
      crypto: user - prevent operating on larval algorithms

Fabio Estevam (1):
      ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX

Fei Li (1):
      tun: wake up waitqueues after IFF_UP is set

Geert Uytterhoeven (1):
      cpu/speculation: Warn on unsupported mitigations=3D parameter

George G. Davis (1):
      scripts/checkstack.pl: Fix arm64 wrong or unknown architecture

Greg Kroah-Hartman (1):
      Linux 4.9.185

Helge Deller (1):
      parisc: Fix compiler warnings in float emulation code

Herbert Xu (1):
      lib/mpi: Fix karactx leak in mpi_powm

Hsin-Yi Wang (1):
      drm/mediatek: fix unbind functions

Jaesoo Lee (1):
      nvme: Fix u32 overflow in the number of namespace list calculation

Jan Kara (1):
      scsi: vmw_pscsi: Fix use-after-free in pvscsi_queue_lck()

Jann Horn (3):
      apparmor: enforce nullbyte at end of tag string
      fs/binfmt_flat.c: make load_flat_shared_library() work
      ptrace: Fix ->ptracer_cred handling for PTRACE_TRACEME

Joakim Zhang (1):
      can: flexcan: fix timeout when set small bitrate

Johannes Berg (1):
      mac80211: drop robust management frames from unknown TA

John Ogness (1):
      fs/proc/array.c: allow reporting eip/esp for all coredumping threads

Josh Elsasser (1):
      net: check before dereferencing netdev_ops during busy poll

Jouni Malinen (1):
      mac80211: Do not use stack memory with scatterlist for GMAC

Kees Cook (1):
      arm64, vdso: Define vdso_{start,end} as array

Libin Yang (1):
      ASoC: soc-pcm: BE dai needs prepare when pause release after resume

Linus Torvalds (2):
      gcc-9: silence 'address-of-packed-member' warning
      tty: rocket: fix incorrect forward declaration of 'rp_init()'

Lucas De Marchi (1):
      drm/i915/dmc: protect against reading random memory

Manuel Lauss (1):
      MIPS: math-emu: do not use bools for arithmetic

Manuel Traut (1):
      scripts/decode_stacktrace.sh: prefix addr2line with $CROSS_COMPILE

Marcel Holtmann (2):
      Bluetooth: Align minimum encryption key size for LE and BR/EDR connec=
tions
      Bluetooth: Fix regression with minimum encryption key size alignment

Martin KaFai Lau (2):
      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err

Matias Karhumaa (1):
      Bluetooth: Fix faulty expression for minimum encryption key size check

Matt Flax (1):
      ASoC : cs4265 : readable register too low

Miguel Ojeda (1):
      tracing: Silence GCC 9 array bounds warning

Mike Marciniszyn (6):
      IB/hfi1: Silence txreq allocation warnings
      IB/rdmavt: Fix alloc_qpn() WARN_ON()
      IB/hfi1: Insure freeze_work work_struct is canceled on shutdown
      IB/{qib, hfi1, rdmavt}: Correct ibv_devinfo max_mr value
      IB/hfi1: Avoid hardlockup with flushlist_lock
      IB/hfi1: Close PSM sdma_progress sleep window

Naohiro Aota (1):
      btrfs: start readahead also in seed devices

Naveen N. Rao (1):
      powerpc/bpf: use unsigned division instruction for 64-bit operations

Neil Horman (1):
      af_packet: Block execution of tasks waiting for transmit to complete =
in AF_PACKET

Nikita Yushchenko (1):
      net: dsa: mv88e6xxx: avoid error message on remove from VLAN 0

Nikolay Borisov (1):
      btrfs: Ensure replaced device doesn't have pending chunk allocation

Paolo Bonzini (1):
      KVM: x86: degrade WARN to pr_warn_ratelimited

Paul Burton (2):
      MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()
      MIPS: Workaround GCC __builtin_unreachable reordering bug

Peter Chen (1):
      usb: chipidea: udc: workaround for endpoint conflict issue

Robert Beckett (2):
      drm/imx: notify drm core before sending event during crtc disable
      drm/imx: only send event on crtc disable if kept disabled

Robert Hancock (1):
      hwmon: (pmbus/core) Treat parameters as paged if on multiple pages

Robin Gong (1):
      dmaengine: imx-sdma: remove BD_INTR for channel0

Robin Murphy (1):
      drm/arm/hdlcd: Allow a bit of clock tolerance

Roland Hii (1):
      net: stmmac: fixed new system time seconds value calculation

Sean Wang (2):
      net: ethernet: mediatek: Use hw_feature to judge if HWLRO is supported
      net: ethernet: mediatek: Use NET_IP_ALIGN to judge if HW RX_2BYTE_OFF=
SET is enabled

Stanley Chu (1):
      scsi: ufs: Avoid runtime suspend possibly being blocked forever

Stephen Suryaputra (1):
      ipv4: Use return value of inet_iif() for __raw_v4_lookup in the while=
 loop

Takashi Iwai (1):
      ALSA: line6: Fix write on zero-sized buffer

Takashi Sakamoto (1):
      ALSA: firewire-lib/fireworks: fix miss detection of received MIDI mes=
sages

Trond Myklebust (1):
      NFS/flexfiles: Use the correct TCP timeout for flexfiles I/O

Vineet Gupta (3):
      ARC: fix build warnings with !CONFIG_KPROBES
      ARC: fix allnoconfig build warning
      ARC: handle gcc generated __builtin_trap for older compiler

Wanpeng Li (1):
      KVM: LAPIC: Fix pending interrupt in IRR blocked by software disable =
LAPIC

Willem de Bruijn (1):
      can: purge socket error queue on sock destruct

Xin Long (4):
      sctp: change to hold sk after auth shkey is created successfully
      tipc: change to use register_pernet_device
      tipc: check msg->req data len in tipc_nl_compat_bearer_disable
      tipc: pass tunnel dev as NULL to udp_tunnel(6)_xmit_skb

Yonglong Liu (1):
      net: hns: Fix loopback test failed at copper ports

Young Xiao (2):
      sparc: perf: fix updated event period in response to PERF_EVENT_IOC_P=
ERIOD
      usb: gadget: fusb300_udc: Fix memory leak of fusb300->ep[i]

Yu-Hsuan Hsu (1):
      ASoC: max98090: remove 24-bit format support if RJ is 0

YueHaibing (5):
      parport: Fix mem leak in parport_register_dev_model
      MIPS: uprobes: remove set but not used variable 'epc'
      team: Always enable vlan tx offload
      bonding: Always enable vlan tx offload
      spi: bitbang: Fix NULL pointer dereference in spi_unregister_master

swkhack (1):
      mm/mlock.c: change count_mm_mlocked_page_nr return type


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0l4R8ACgkQONu9yGCS
aT435xAAt2aqS1l/RH6nBZ32PHGHEesR22yWoYutezR8hfgg4JBXkJlDHdIh3Ijy
xJ6L5N0S8s0gVXw8o8WJRdtrJTEuwEXzpwPpXMjGWD4vvVxFa/VX4mchLuv+W0e3
hI0/m3te9APaTzU5fsBVsRWlR2YnYBJUpFjtjUcKrgwOk162KARRwBbZZJePvTJX
yt9y+iT8xGP39Qy69KyDVj0GCWkLDMg7wN8GAvYERHJQc91zlf7bZtLMQzLfBS2c
D1QLPzG2TVqT4hFOcvTvBxsUo6CysLuAtRpHEnYhfAZWCI2nPaKpbW0p+OZSCKHh
CGgCfaFdb6rO8Csh8LYwlJQ5ixLBpy/dZeJfTgh7xN1uFFJnvfKYAFJjCdWn8u0v
3IU0KiBgohPpXQE4KRwg/lMCHLjNNsmw5OdEN0ZR4ZBD8hf8tXhR+8wZ7y3oyuK/
Lkt8PPl9XDYssRwbP4DvVnuNI97mw0f0wMZqBXHwzB9lquN65VSgIvOr4ePUM5Fg
hhueT47+u+MmegJtSaVE8BFRa1H+XRPq/B4jvxacvmw7a4/T8WEyMPWlyTTgcldK
4S+JOg6p1A6QMybbfe9Ikcx+/Dz874iorv0Ony61g3wpFFZsjumI9fjkosQCz66E
sqzMW0h/C8hM5LDCwMLNiA6/6GLtIFsKXv7ofb5ZYootJlAu0PA=
=oIg/
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
