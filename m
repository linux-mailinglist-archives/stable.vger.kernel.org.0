Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927F86F377
	for <lists+stable@lfdr.de>; Sun, 21 Jul 2019 15:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfGUNsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 09:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbfGUNsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 09:48:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA55420823;
        Sun, 21 Jul 2019 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563716884;
        bh=npxcMZrvMi+8DEa9tgBAtslOAUdtepCKtW/9fpL6+4A=;
        h=Date:From:To:Cc:Subject:From;
        b=q1Y9TYLSIR5t7MoLaCWKCnShuyulJrZG0vEcP4meqy9CXuCV4YfCuJKwVPAQrOSd/
         FYSrIlQJ5VBBcTM2zx060JgDHngAp728JYTsHlBXDqQEVw+KbDa/nlqaUVQt9yVF4X
         jQ2jh43oFJFKoWmnnsSYjGJCDkdahDoOMS1UK2s8=
Date:   Sun, 21 Jul 2019 15:48:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.186
Message-ID: <20190721134801.GA23081@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.186 kernel.

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

 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt |    1=20
 Makefile                                                        |    2=20
 arch/arc/kernel/unwind.c                                        |    9=20
 arch/arm/boot/dts/imx6ul.dtsi                                   |    8=20
 arch/arm/mach-davinci/board-da850-evm.c                         |    2=20
 arch/arm/mach-davinci/devices-da8xx.c                           |    3=20
 arch/arm/mach-omap2/prm3xxx.c                                   |    2=20
 arch/arm64/crypto/sha256-core.S                                 | 2061 ---=
-------
 arch/arm64/crypto/sha512-core.S                                 | 1085 ---=
--
 arch/mips/include/uapi/asm/sgidefs.h                            |    8=20
 arch/s390/include/asm/facility.h                                |   21=20
 arch/x86/kernel/ptrace.c                                        |    5=20
 arch/x86/kernel/tls.c                                           |    9=20
 drivers/crypto/talitos.c                                        |   16=20
 drivers/input/keyboard/imx_keypad.c                             |   18=20
 drivers/input/mouse/elantech.c                                  |    2=20
 drivers/md/dm-verity-target.c                                   |    4=20
 drivers/md/md.c                                                 |   36=20
 drivers/misc/vmw_vmci/vmci_context.c                            |   80=20
 drivers/misc/vmw_vmci/vmci_handle_array.c                       |   38=20
 drivers/misc/vmw_vmci/vmci_handle_array.h                       |   29=20
 drivers/net/can/spi/Kconfig                                     |    5=20
 drivers/net/can/spi/mcp251x.c                                   |   25=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c             |    3=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                |    1=20
 drivers/net/ethernet/emulex/benet/be_ethtool.c                  |   28=20
 drivers/net/ethernet/intel/e1000e/netdev.c                      |   21=20
 drivers/net/ethernet/mellanox/mlxsw/reg.h                       |    2=20
 drivers/net/ethernet/sis/sis900.c                               |   16=20
 drivers/net/ppp/ppp_mppe.c                                      |    1=20
 drivers/net/wireless/ath/carl9170/usb.c                         |   39=20
 drivers/net/wireless/intersil/p54/p54usb.c                      |   43=20
 drivers/net/wireless/marvell/mwifiex/fw.h                       |   12=20
 drivers/net/wireless/marvell/mwifiex/ie.c                       |   45=20
 drivers/net/wireless/marvell/mwifiex/scan.c                     |   31=20
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c                |    4=20
 drivers/net/wireless/marvell/mwifiex/wmm.c                      |    2=20
 drivers/s390/cio/qdio_setup.c                                   |    2=20
 drivers/s390/cio/qdio_thinint.c                                 |    5=20
 drivers/staging/comedi/drivers/amplc_pci230.c                   |    3=20
 drivers/staging/comedi/drivers/dt282x.c                         |    3=20
 drivers/staging/iio/cdc/ad7150.c                                |   19=20
 drivers/tty/serial/8250/8250_port.c                             |    3=20
 drivers/usb/gadget/function/u_ether.c                           |    6=20
 drivers/usb/renesas_usbhs/fifo.c                                |   34=20
 drivers/usb/serial/ftdi_sio.c                                   |    1=20
 drivers/usb/serial/ftdi_sio_ids.h                               |    6=20
 drivers/usb/serial/option.c                                     |    1=20
 fs/crypto/policy.c                                              |    2=20
 fs/udf/inode.c                                                  |   93=20
 include/linux/vmw_vmci_defs.h                                   |   11=20
 include/net/ip6_tunnel.h                                        |    9=20
 include/uapi/linux/nilfs2_ondisk.h                              |   24=20
 kernel/events/core.c                                            |    2=20
 net/ipv6/netfilter/nf_conntrack_reasm.c                         |   22=20
 net/mac80211/ieee80211_i.h                                      |    2=20
 net/mac80211/mesh.c                                             |    6=20
 net/sunrpc/clnt.c                                               |    1=20
 samples/bpf/bpf_load.c                                          |    2=20
 virt/kvm/arm/vgic/vgic-its.c                                    |    1=20
 60 files changed, 515 insertions(+), 3460 deletions(-)

Aaron Ma (1):
      Input: elantech - enable middle button support on 2 ThinkPads

Alan Stern (1):
      p54usb: Fix race between disconnect and firmware loading

Andreas Fritiofson (1):
      USB: serial: ftdi_sio: add ID for isodebug v1

Anson Huang (1):
      Input: imx_keypad - make sure keyboard can always wake up system

Arnd Bergmann (2):
      ARM: omap2: remove incorrect __init annotation
      ARC: hide unused function unw_hdr_alloc

Bartosz Golaszewski (2):
      ARM: davinci: da850-evm: call regulator_has_full_constraints()
      ARM: davinci: da8xx: specify dma_coherent_mask for lcdc

Brian Norris (1):
      mwifiex: Don't abort on small, spec-compliant vendor IEs

Chang-Hsien Tsai (1):
      samples, bpf: fix to change the buffer size for read()

Christian Lamparter (1):
      carl9170: fix misuse of device driver API

Christophe Leroy (1):
      crypto: talitos - rename alternative AEAD algos.

Dave Martin (1):
      KVM: arm/arm64: vgic: Fix kvm_device leak in vgic_its_destroy

Dianzhang Chen (2):
      x86/ptrace: Fix possible spectre-v1 in ptrace_get_debugreg()
      x86/tls: Fix possible spectre-v1 in do_get_thread_area()

Greg Kroah-Hartman (1):
      Linux 4.9.186

Guillaume Nault (2):
      netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
      netfilter: ipv6: nf_defrag: accept duplicate fragments again

Heiko Carstens (1):
      s390: fix stfle zero padding

Hongjie Fang (1):
      fscrypt: don't set policy for a dead directory

Ian Abbott (2):
      staging: comedi: dt282x: fix a null pointer deref on interrupt
      staging: comedi: amplc_pci230: fix null pointer deref on interrupt

Ido Schimmel (1):
      mlxsw: spectrum: Disallow prio-tagged packets when PVID is removed

Julian Wiedmann (2):
      s390/qdio: (re-)initialize tiqdio list entries
      s390/qdio: don't touch the dsci in tiqdio_add_input_queues()

J=F6rgen Storvist (1):
      USB: serial: option: add support for GosunCn ME3630 RNDIS mode

Kiruthika Varadarajan (1):
      usb: gadget: ether: Fix race between gether_disconnect and rx_submit

Konstantin Khlebnikov (2):
      Revert "e1000e: fix cyclic resets at link up with active tx"
      e1000e: start network tx queue only when link is up

Lin Yi (1):
      net :sunrpc :clnt :Fix xps refcount imbalance on the error path

Mariusz Tkaczyk (1):
      md: fix for divide error in status_resync

Mark Rutland (1):
      arm64: crypto: remove accidentally backported files

Masahiro Yamada (1):
      nilfs2: do not use unexported cpu_to_le32()/le32_to_cpu() in uapi hea=
der

Mauro S. M. Rodrigues (1):
      bnx2x: Check if transceiver implements DDM before access

Melissa Wen (1):
      staging:iio:ad7150: fix threshold mode config bit

Milan Broz (1):
      dm verity: use message limit for data block corruption message

Oliver Barta (1):
      Revert "serial: 8250: Don't service RX FIFO if interrupts are disable=
d"

Peter Zijlstra (1):
      perf/core: Fix perf_sample_regs_user() mm check

Petr Oros (1):
      be2net: fix link failure after ethtool offline test

Pradeep Kumar Chitrapu (1):
      mac80211: free peer keys before vif down in mesh

Sean Nyekjaer (2):
      dt-bindings: can: mcp251x: add mcp25625 support
      can: mcp251x: add support for mcp25625

Sean Young (1):
      MIPS: Remove superfluous check for __linux__

Sergej Benilov (1):
      sis900: fix TX completion

Steven J. Magnani (1):
      udf: Fix incorrect final NOT_ALLOCATED (hole) extent length

S=E9bastien Szymanski (1):
      ARM: dts: imx6ul: fix PWM[1-4] interrupts

Takashi Iwai (4):
      mwifiex: Fix possible buffer overflows at parsing bss descriptor
      mwifiex: Abort at too short BSS descriptor element
      mwifiex: Fix heap overflow in mwifiex_uap_parse_tail_ies()
      ppp: mppe: Add softdep to arc4

Thomas Pedersen (1):
      mac80211: mesh: fix RCU warning

Vishnu DASA (1):
      VMCI: Fix integer overflow in VMCI handle arrays

Xin Long (1):
      ip6_tunnel: allow not to count pkts on tstats by passing dev as NULL

Yibo Zhao (1):
      mac80211: only warn once on chanctx_conf being NULL

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: add a workaround for a race condition of workqueue


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl00bQ4ACgkQONu9yGCS
aT46BBAAgWJaORrK/JNeZ6qQUld8nOtq654mcFHGwW+9ILipUorozoSVZ8daBYO+
uz60iudicmpEyg7IfSXG/BBeiEJ8JRo4SM7c/yvqZuMR2VO1Y2WVzrHoMmqMWXqS
u0cp+C00zBojoLWKuSchV87Xkb1KJRiln9Z+4X4TJrZgy5vsfxGtBGtoOeZFDDjw
b8Su+RL2EmI9KE2ebhGRon8NElp3HMQNkdldMBKy1iB18BGpDWpJW7QZUDs+hMsj
CR2RC4O4R3QoH4R3GtFsVU6toCkIAByzx899nU2H1924B/TyNbsWquZYQa+ekgl+
u6sDwNmFFXw5B0WddWX1Bp1enpq71djk09ySehMCAeShu9z6fodDu+V3vX61X18L
wfEpUq1tBsJJkuafmXXPx5i8kMzw6efdIZyF4+eCmUcxQKiIfKhnq2KYkfXwHjE+
gzKirH2RdnVKzHDtmi6uBcZIuL72x93eu0CJ5/R7kKUd9R/A7N8J56Ym/uuxGiBu
K1UINY/3wQWA1bXnrH/wDC91PDifOSH0hhzW8og4ou/GH6UCO5dTARoPcYqnesHg
g+DVw9Ocb5fSqEpoPLxABzlIZtzBJbnCGRhKFpSyBcMxTBnTgojKa2oVJcBy8awQ
TMrPr7EPGJ57TVujkJPEYf8tHxYlQcbz9QKsA0EgzgDmLta8rTI=
=eBro
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
