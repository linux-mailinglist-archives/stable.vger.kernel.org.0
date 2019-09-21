Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B7B9CA3
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 08:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407288AbfIUGfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 02:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbfIUGfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 02:35:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7FF208C0;
        Sat, 21 Sep 2019 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569047720;
        bh=6+ZHCGamy/xQ5x0Pm5/POBHIwuvQNbpVSR4iLhACq1s=;
        h=Date:From:To:Cc:Subject:From;
        b=tcz3F/wdAwN2ggO93UJVYS0Y4nRhRFIlQgzNBIaKRVlSVwL4kXpe3n4KCNHc/CapA
         TeRY+vfXYgKgOjjpL12kqt5n5s1zCBV3FbouB6t+dxmqa0cp0HJnKPyzE02V/Vu/P6
         qCdIMUhkNlQdofp89yr/BxqH/B0SU8K5oQKPwHlE=
Date:   Sat, 21 Sep 2019 08:35:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.194
Message-ID: <20190921063517.GA1078543@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.194 kernel.

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

 Makefile                                       |    2=20
 arch/arc/kernel/traps.c                        |    1=20
 arch/arm/mach-omap2/omap4-common.c             |    3 +
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c      |    3 -
 arch/arm/mm/init.c                             |    8 ++
 arch/mips/Kconfig                              |    3 -
 arch/mips/include/asm/smp.h                    |   12 ++++
 arch/mips/sibyte/common/Makefile               |    1=20
 arch/mips/sibyte/common/dma.c                  |   14 -----
 arch/mips/vdso/Makefile                        |    4 +
 arch/powerpc/mm/pgtable-radix.c                |   16 ++---
 arch/s390/kvm/interrupt.c                      |   10 +++
 arch/s390/kvm/kvm-s390.c                       |    2=20
 arch/s390/net/bpf_jit_comp.c                   |   12 ++--
 arch/x86/Makefile                              |    1=20
 arch/x86/events/amd/ibs.c                      |   13 +++-
 arch/x86/events/intel/core.c                   |    6 ++
 arch/x86/include/asm/bootparam_utils.h         |    1=20
 arch/x86/include/asm/perf_event.h              |   12 ++--
 arch/x86/include/asm/uaccess.h                 |    4 +
 arch/x86/kernel/apic/io_apic.c                 |    8 ++
 arch/x86/kvm/vmx.c                             |    7 +-
 arch/x86/kvm/x86.c                             |    7 ++
 drivers/atm/Kconfig                            |    2=20
 drivers/base/core.c                            |   53 +++++++++++++++++++
 drivers/block/floppy.c                         |    4 -
 drivers/clk/rockchip/clk-mmc-phase.c           |    4 -
 drivers/crypto/talitos.c                       |   67 ++++++++++++++++++--=
-----
 drivers/dma/omap-dma.c                         |    4 +
 drivers/dma/ti-dma-crossbar.c                  |    4 +
 drivers/gpio/gpiolib.c                         |   20 +++++--
 drivers/gpu/drm/mediatek/mtk_drm_drv.c         |    5 +
 drivers/iommu/amd_iommu.c                      |   16 ++++-
 drivers/isdn/capi/capi.c                       |   10 +++
 drivers/media/usb/dvb-usb/technisat-usb2.c     |   22 +++-----
 drivers/media/usb/tm6000/tm6000-dvb.c          |    3 +
 drivers/mtd/nand/mtk_nand.c                    |   21 +++----
 drivers/net/ethernet/marvell/sky2.c            |    7 ++
 drivers/net/ethernet/qlogic/qed/qed_main.c     |    4 +
 drivers/net/ethernet/seeq/sgiseeq.c            |    7 +-
 drivers/net/tun.c                              |   16 ++++-
 drivers/net/usb/cdc_ether.c                    |   13 +++-
 drivers/net/usb/r8152.c                        |    5 +
 drivers/net/wireless/marvell/mwifiex/ie.c      |    3 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c |    9 ++-
 drivers/net/xen-netfront.c                     |    2=20
 drivers/nvmem/core.c                           |   15 ++++-
 drivers/tty/serial/atmel_serial.c              |    1=20
 drivers/tty/serial/sprd_serial.c               |    2=20
 drivers/usb/core/config.c                      |   12 ++--
 fs/btrfs/tree-log.c                            |    8 +-
 fs/cifs/connect.c                              |   22 ++++++++
 fs/nfs/nfs4file.c                              |   12 ++--
 fs/nfs/pagelist.c                              |    2=20
 fs/nfs/proc.c                                  |    7 +-
 include/uapi/linux/isdn/capicmd.h              |    1=20
 kernel/irq/resend.c                            |    2=20
 net/batman-adv/bat_v_ogm.c                     |   18 ++++--
 net/bridge/br_mdb.c                            |    2=20
 net/core/dev.c                                 |    2=20
 net/core/skbuff.c                              |   19 +++++++
 net/ipv4/tcp_input.c                           |    2=20
 net/ipv6/ping.c                                |    2=20
 net/netfilter/nf_conntrack_ftp.c               |    2=20
 net/sched/sch_generic.c                        |    6 +-
 net/sched/sch_hhf.c                            |    2=20
 net/sctp/protocol.c                            |    2=20
 net/sctp/sm_sideeffect.c                       |    2=20
 net/tipc/name_distr.c                          |    3 -
 security/keys/request_key_auth.c               |    6 ++
 tools/power/x86/turbostat/turbostat.c          |    2=20
 virt/kvm/coalesced_mmio.c                      |   17 +++---
 72 files changed, 450 insertions(+), 172 deletions(-)

Alan Stern (1):
      USB: usbcore: Fix slab-out-of-bounds bug during device reset

Aneesh Kumar K.V (1):
      powerpc/mm/radix: Use the right page size for vmemmap mapping

Bj=F8rn Mork (1):
      cdc_ether: fix rndis support for Mediatek based smartphones

Christophe JAILLET (4):
      ipv6: Fix the link time qualifier of 'ping_v6_proc_exit_net()'
      sctp: Fix the link time qualifier of 'sctp_ctrlsock_exit()'
      Kconfig: Fix the reference to the IDT77105 Phy driver in the descript=
ion of ATM_NICSTAR_USE_IDT77105
      net: seeq: Fix the function used to release some memory in an error h=
andling path

Christophe Leroy (6):
      crypto: talitos - check AES key size
      crypto: talitos - fix CTR alg blocksize
      crypto: talitos - check data blocksize in ablkcipher.
      crypto: talitos - fix ECB algs ivsize
      crypto: talitos - Do not modify req->cryptlen on decryption.
      crypto: talitos - HMAC SNOOP NO AFEU mode requires SW icv checking.

Chunyan Zhang (1):
      serial: sprd: correct the wrong sequence of arguments

Cong Wang (2):
      sch_hhf: ensure quantum and hhf_non_hh_weight are non-zero
      net_sched: let qdisc_put() accept NULL pointer

Corey Minyard (1):
      x86/boot: Add missing bootparam that breaks boot on some platforms

Dan Carpenter (1):
      cifs: Use kzfree() to zero out the password

Dongli Zhang (1):
      xen-netfront: do not assume sk_buff_head list is empty in error handl=
ing

Doug Berger (1):
      ARM: 8874/1: mm: only adjust sections of valid mm structures

Douglas Anderson (1):
      clk: rockchip: Don't yell about bad mmc phases when getting

Eric Biggers (1):
      isdn/capi: check message length in capi_write()

Filipe Manana (1):
      Btrfs: fix assertion failure during fsync and use of stale transaction

Fuqian Huang (1):
      KVM: x86: work around leak of uninitialized stack contents

Greg Kroah-Hartman (2):
      Revert "MIPS: SiByte: Enable swiotlb for SWARM, LittleSur and BigSur"
      Linux 4.9.194

Hillf Danton (1):
      keys: Fix missing null pointer check in request_key_auth_describe()

Ilya Leoshkevich (2):
      s390/bpf: fix lcgr instruction encoding
      s390/bpf: use 32-bit index for tail calls

Jann Horn (1):
      floppy: fix usercopy direction

Jean Delvare (1):
      nvmem: Use the same permissions for eeprom as for nvmem

Joerg Roedel (1):
      iommu/amd: Fix race in increase_address_space()

Josh Hunt (1):
      perf/x86/intel: Restrict period on Nehalem

Kent Gibson (2):
      gpio: fix line flag validation in linehandle_create
      gpio: fix line flag validation in lineevent_create

Kim Phillips (1):
      perf/x86/amd/ibs: Fix sample bias for dispatched micro-ops

Linus Torvalds (1):
      x86/build: Add -Wnoaddress-of-packed-member to REALMODE_CFLAGS, to si=
lence GCC9 build warning

Matt Delco (1):
      KVM: coalesced_mmio: add bounds checking

Muchun Song (1):
      driver core: Fix use-after-free and double free on glue directory

Naoya Horiguchi (1):
      tools/power turbostat: fix buffer overrun

Neal Cardwell (1):
      tcp: fix tcp_ecn_withdraw_cwr() to clear TCP_ECN_QUEUE_CWR

Nicolas Dichtel (1):
      bridge/mdb: remove wrong use of NLM_F_MULTI

Nishka Dasgupta (1):
      drm/mediatek: mtk_drm_drv.c: Add of_node_put() before goto

Paolo Bonzini (1):
      KVM: nVMX: handle page fault in vmread

Paul Burton (2):
      MIPS: VDSO: Prevent use of smp_processor_id()
      MIPS: VDSO: Use same -m%-float cflag as the kernel proper

Peter Zijlstra (1):
      x86/uaccess: Don't leak the AC flags into __get_user() argument evalu=
ation

Prashant Malani (1):
      r8152: Set memory to all 0xFFs on failed reg reads

Razvan Stefanescu (1):
      tty/serial: atmel: reschedule TX after RX was started

Ronnie Sahlberg (1):
      cifs: set domainName when a domain-key is used in multiuser

Sean Young (2):
      media: tm6000: double free if usb disconnect while streaming
      media: technisat-usb2: break out of loop at end of buffer

Shmulik Ladkani (1):
      net: gso: Fix skb_segment splat when splitting gso_size mangled skb h=
aving linear-headed frag_list

Subash Abhinov Kasiviswanathan (1):
      net: Fix null de-reference of device refcount

Sven Eckelmann (1):
      batman-adv: Only read OGM2 tvlv_len after buffer len check

Takashi Iwai (1):
      sky2: Disable MSI on yet another ASUS boards (P6Xxxx)

Thomas Gleixner (1):
      x86/apic: Fix arch_dynirq_lower_bound() bug for DT enabled machines

Thomas Huth (1):
      KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT io=
ctl

Thomas Jarosch (1):
      netfilter: nf_conntrack_ftp: Fix debug output

Tony Lindgren (2):
      ARM: OMAP2+: Fix missing SYSC_HAS_RESET_STATUS for dra7 epwmss
      ARM: OMAP2+: Fix omap4 errata warning on other SoCs

Trond Myklebust (4):
      NFSv4: Fix return values for nfs4_file_open()
      NFS: Fix initialisation of I/O result struct in nfs_pgio_rpcsetup
      NFSv2: Fix eof handling
      NFSv2: Fix write regression

Vineet Gupta (1):
      ARC: export "abort" for modules

Wen Huang (1):
      mwifiex: Fix three heap overflow at parsing element in cfg80211_ap_se=
ttings

Wenwen Wang (3):
      qed: Add cleanup in qed_slowpath_start()
      dmaengine: ti: dma-crossbar: Fix a memory leak bug
      dmaengine: ti: omap-dma: Add cleanup in omap_dma_probe()

Xiaolei Li (1):
      mtd: rawnand: mtk: Fix wrongly assigned OOB buffer pointer issue

Xin Long (2):
      sctp: use transport pf_retrans in sctp_do_8_2_transport_strike
      tipc: add NULL pointer check before calling kfree_rcu

Yang Yingliang (1):
      tun: fix use-after-free when register netdev failed

Yunfeng Ye (1):
      genirq: Prevent NULL pointer dereference in resend_irqs()

zhaoyang (1):
      ARM: 8901/1: add a criteria for pfn_valid of arm


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl2FxKAACgkQONu9yGCS
aT7ePA//RxPA5gfT/BvEOu+DCawOtCPYkfTpbc+NiA2G4NyN02aPqjuO5BbqHXH4
lJ+DWnyxQFDNcWOfqBS8WHKzKpjJyfna+r/vIryvbEe4QpKr/wXo1hD0iB4WAOeo
7JHMF1+7P2FVPULqKaIKWJetuo9yZrD6XOSMCSSEFB2BdkmUr1LLg7YzZwi/ryJy
KMVQ1EH32JFQ901pAfb8Kiexvga2BIfGgMpP6BLNYdRTa0HQh/wB6bLBh7W3+ZSq
ELvk51mQta+s3Q7hULZHot0JKiOIugUrbtsUx+IqpwYsu2N3v0Bv5hCb0zZ6GKle
hCuplcLmhuULWuu5euPgi4aFE+98bk6Ghx9CQCQf8Av+PIZWZnx+TsCHY9WRAZVu
eWX/2s0vVkpAN5pEKOu5U6aAd3t/BTOGXKju1EUJbkhjjNYq9BJeWFSMiUyD2qmD
TIVLHkBP3q2IA0dw+9DS6YyxTfUB0R8Va2t8VaEYD6bbwdLTqiJTvcf33ZNEv7qj
yitB6XrWMIgqSf5SEPr5BznirOPc+37a+CMyGyoXko1bxHZfDqduR+qDUoLObEqy
glfctFCvagHVkeukAbQT+KnpWrw/wsslGQ8M5YY2juUf70CoEpv8+NptanC+UnrG
1e5Ky4YveFJrcrtany+Q31pvMZ/y2I7ryqfMo3EryJafvfmtv54=
=Xebc
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
