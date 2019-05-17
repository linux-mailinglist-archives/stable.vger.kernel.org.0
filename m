Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2312147E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 09:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfEQHfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 03:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfEQHfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 May 2019 03:35:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBC3206A3;
        Fri, 17 May 2019 07:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558078539;
        bh=aAwOPRCnvMSzbqy/w8R/9rBM7odsnLsD/14Hh7N96KY=;
        h=Date:From:To:Cc:Subject:From;
        b=wNNoGb0cy5pi9J8us0g37AD9QEgmi8+1hkN9/qi0ab18zE+0c92EIIfvoSZeB1Xg6
         Ai0MCp2x1nhtmMpfq+2205VJuWC4NkzOcY4xMr1LnU6DWZNN3OS10bxJ7IP0fieTpW
         JMtqE0LjsY+7iuumDhZAPTHOmYXmLhyAVqu9tbUo=
Date:   Fri, 17 May 2019 09:35:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.177
Message-ID: <20190517073537.GA27149@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.177 kernel.

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

 Makefile                                                    |    2=20
 arch/mips/ath79/setup.c                                     |    6=20
 arch/powerpc/include/asm/reg_booke.h                        |    2=20
 arch/powerpc/kernel/security.c                              |    1=20
 arch/powerpc/lib/code-patching.c                            |    2=20
 arch/x86/entry/vdso/Makefile                                |    3=20
 arch/x86/kernel/reboot.c                                    |   21=20
 arch/x86/kvm/trace.h                                        |    4=20
 drivers/gpu/drm/sun4i/sun4i_drv.c                           |    2=20
 drivers/gpu/ipu-v3/ipu-dp.c                                 |   12=20
 drivers/hid/hid-input.c                                     |   14=20
 drivers/iio/adc/xilinx-xadc-core.c                          |    2=20
 drivers/input/rmi4/rmi_driver.c                             |    6=20
 drivers/irqchip/irq-ath79-misc.c                            |   11=20
 drivers/isdn/mISDN/socket.c                                 |    4=20
 drivers/md/raid5.c                                          |   19=20
 drivers/net/bonding/bond_options.c                          |    7=20
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c           |    8=20
 drivers/net/phy/spi_ks8995.c                                |    9=20
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c         |    1=20
 drivers/net/wireless/st/cw1200/scan.c                       |    5=20
 drivers/nfc/st95hf/core.c                                   |    7=20
 drivers/nvdimm/btt_devs.c                                   |   18=20
 drivers/nvdimm/namespace_devs.c                             |    5=20
 drivers/platform/x86/sony-laptop.c                          |    8=20
 drivers/s390/block/dasd_eckd.c                              |    6=20
 drivers/s390/char/con3270.c                                 |    2=20
 drivers/s390/char/fs3270.c                                  |    3=20
 drivers/s390/char/raw3270.c                                 |    3=20
 drivers/s390/char/raw3270.h                                 |    4=20
 drivers/s390/char/tty3270.c                                 |    3=20
 drivers/s390/net/ctcm_main.c                                |    1=20
 drivers/usb/serial/generic.c                                |   39 +
 drivers/virt/fsl_hypervisor.c                               |   29 -
 include/linux/efi.h                                         |    7=20
 include/linux/list_nulls.h                                  |    5=20
 include/linux/rculist_nulls.h                               |   14=20
 include/sound/pcm.h                                         |    2=20
 init/main.c                                                 |    4=20
 kernel/bpf/hashtab.c                                        |   99 ++--
 net/8021q/vlan_dev.c                                        |    4=20
 net/bridge/br_if.c                                          |   13=20
 net/core/fib_rules.c                                        |    6=20
 net/ipv4/raw.c                                              |    4=20
 net/ipv6/sit.c                                              |    2=20
 net/mac80211/mesh_pathtbl.c                                 |    2=20
 net/netfilter/ipvs/ip_vs_core.c                             |    2=20
 net/netfilter/x_tables.c                                    |    2=20
 net/packet/af_packet.c                                      |   25 -
 sound/core/pcm_lib.c                                        |    2=20
 sound/core/pcm_native.c                                     |    6=20
 tools/lib/traceevent/event-parse.c                          |    2=20
 tools/testing/selftests/net/run_netsocktests                |    2=20
 tools/testing/selftests/netfilter/Makefile                  |    2=20
 tools/testing/selftests/netfilter/conntrack_icmp_related.sh |  283 +++++++=
+++++
 55 files changed, 604 insertions(+), 153 deletions(-)

Aditya Pakki (1):
      libnvdimm/btt: Fix a kmemdup failure check

Alexei Starovoitov (2):
      bpf: fix struct htab_elem layout
      bpf: convert htab map to hlist_nulls

Alistair Strachan (2):
      x86: vdso: Use $LD instead of $CC to link
      x86/vdso: Pass --eh-frame-hdr to the linker

Arnd Bergmann (1):
      s390: ctcm: fix ctcm_new_device error return code

Breno Leitao (1):
      powerpc/64s: Include cpu header

Christophe Leroy (2):
      net: ucc_geth - fix Oops when changing number of buffers in the ring
      powerpc/lib: fix book3s/32 boot failure due to code patching

Dan Carpenter (2):
      drivers/virt/fsl_hypervisor.c: dereferencing error pointers in ioctl
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Dan Williams (1):
      init: initialize jump labels before command line option parsing

Daniel Gomez (2):
      spi: Micrel eth switch: declare missing of table
      spi: ST ST95HF NFC: declare missing of table

David Ahern (1):
      ipv4: Fix raw socket lookup for local traffic

Dmitry Torokhov (3):
      HID: input: add mapping for Expose/Overview key
      HID: input: add mapping for keyboard Brightness Up/Down/Toggle keys
      HID: input: add mapping for "Toggle Display" key

Felix Fietkau (1):
      mac80211: fix unaligned access in mesh table hash function

Florian Westphal (1):
      selftests: netfilter: check icmp pkttoobig errors are set as related

Francesco Ruggeri (1):
      netfilter: compat: initialize all fields in xt_init

Greg Kroah-Hartman (1):
      Linux 4.9.177

Gustavo A. R. Silva (2):
      platform/x86: sony-laptop: Fix unintentional fall-through
      rtlwifi: rtl8723ae: Fix missing break in switch statement

Hangbin Liu (2):
      fib_rules: return 0 directly if an exactly same rule exists when NLM_=
F_EXCL not supplied
      vlan: disable SIOCSHWTSTAMP in container

Jarod Wilson (1):
      bonding: fix arp_validate toggling in active-backup mode

Jian-Hong Pan (1):
      x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T

Johan Hovold (1):
      USB: serial: fix unthrottle races

Julian Anastasov (1):
      ipvs: do not schedule icmp errors from tunnels

Kangjie Lu (1):
      libnvdimm/namespace: Fix a potential NULL pointer dereference

Laurentiu Tudor (1):
      powerpc/booke64: set RI in default MSR

Lucas Stach (1):
      gpu: ipu-v3: dp: fix CSC handling

Martin Schwidefsky (1):
      s390/3270: fix lockdep false positive on view->lock

Nick Desaulniers (1):
      x86/vdso: Drop implicit common-page-size linker flag

Nigel Croxon (1):
      Don't jump to compute_result state from check_result state

Pan Bian (1):
      Input: synaptics-rmi4 - fix possible double free

Paul Kocialkowski (1):
      drm/sun4i: Set device driver data at bind time for use in unbind

Peter Oberparleiter (1):
      s390/dasd: Fix capacity calculation for large volumes

Petr =C5=A0tetiar (1):
      MIPS: perf: ath79: Fix perfcount IRQ assignment

Po-Hsu Lin (1):
      selftests/net: correct the return value for run_netsocktests

Rikard Falkeborn (1):
      tools lib traceevent: Fix missing equality check for strcmp

Sasha Levin (2):
      Revert "x86/vdso: Drop implicit common-page-size linker flag"
      Revert "x86: vdso: Use $LD instead of $CC to link"

Stephen Suryaputra (1):
      vrf: sit mtu should not be updated when vrf netdev is the link

Sven Van Asbroeck (1):
      iio: adc: xilinx: fix potential use-after-free on remove

Takashi Sakamoto (1):
      ALSA: pcm: remove SNDRV_PCM_IOCTL1_INFO internal command

Tetsuo Handa (1):
      mISDN: Check address length before reading address family

Tobin C. Harding (1):
      bridge: Fix error path for kobject_init_and_add()

Vitaly Kuznetsov (1):
      KVM: x86: avoid misreporting level-triggered irqs as edge-triggered i=
n tracing

Wei Yongjun (1):
      cw1200: fix missing unlock on error in cw1200_hw_scan()

YueHaibing (1):
      packet: Fix error path in packet_init


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzeZEMACgkQONu9yGCS
aT5Mvw/8ClkLNqG8C+DAFlyHT7U6FBMeMDnfQc1sFQY3Wl8Jfjr7YGH5MzUqYSLP
s311beyE/mi2y9qO9kD2kb8UbgRenp870+QbwPhvhAOLaAuUeWMCRB7w6gWih5aH
ZfNbq7wSnR7qadakthtOhbWa9j6wKYS/ch9Ar0KC23qOttwxEby9xXiGz0qhsDBo
jll/qMF7Pw18N/TbFad6uuyWyeIjbCDwZOmRXnbiUYFH3i3dhXXDKUSNXr0r0kbn
sWwE1RCMKg6MuQqXD4JMX5MQ+9IJGPFPS3Bf300lW+SfDTeB82fXEuJ/pkisXdsP
QovHwBxxcd4SlZ3ZZ1VsqNeG0p9ThNfQvklEEFbWV7Xrobqs48KbYR2OKi95aSt5
ULsUoTvyazKkF5TW3JEhoDLqiyBBoo6ES60y0kQqh7IxU3VLh+oSNa4cSp+vsfjB
tG2aVgpg1SmFOxKGxD+Wm0AXn5U2qUsmLrBP3URsp+ySt+EaMzIfKv6+LakIjLIp
bCwgdCV1VyKPSMA2lgjZDfA3JpHN3+82OXgXWkSEc9YhprHNNph5VPhqtp9cXi9x
Z9R3PWZMsxo7rwH5VAZvmycxuqSsIFub6DbJP0xdQmUGy5MG9UEjsHhlqIed8+OX
fpZHyvmT+dTVhEh7JuE4YTe/88UYvxhWoY5w4V7FYjzBQgB51u0=
=4UD7
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
