Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6CA13FCC
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 15:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfEENlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 09:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfEENlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 09:41:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C237A2082F;
        Sun,  5 May 2019 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557063695;
        bh=79NTgNoz8SQkwccEkC5HVo2r4Z5Oe6ZR/yhpw2UOkZU=;
        h=Date:From:To:Cc:Subject:From;
        b=YDLQPTY+c/JHmCRxqgDh3QRAPhfkEQMULVZfq0y4vDnYrwr1TSlQpJTWGUN9QKxSG
         cClvc6KXMUhQHZJw5HmdWRayT8B50LZNGD3qpVmMCgCUPvjaWQgT4aJTTO/yLaTDxd
         gpHDBaoVH1sgi6pbi9KzLjQGqSfOn9KtT/tdqt+c=
Date:   Sun, 5 May 2019 15:41:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.40
Message-ID: <20190505134127.GA4626@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.40 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/x86/include/uapi/asm/kvm.h               |    1=20
 arch/x86/kvm/vmx.c                            |    4 -
 arch/x86/kvm/x86.c                            |   21 ++++++++-
 drivers/net/dsa/bcm_sf2_cfp.c                 |    6 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   19 ++++++--
 drivers/net/phy/marvell.c                     |    6 +-
 drivers/net/wireless/ath/ath10k/mac.c         |    2=20
 include/net/sctp/command.h                    |    1=20
 net/ipv4/ip_output.c                          |    1=20
 net/ipv6/ip6_fib.c                            |    4 -
 net/ipv6/ip6_flowlabel.c                      |   22 ++++++---
 net/ipv6/route.c                              |   47 ++++++++------------
 net/l2tp/l2tp_core.c                          |   10 ++--
 net/packet/af_packet.c                        |   24 ++++++----
 net/rxrpc/call_object.c                       |   32 ++++++-------
 net/sctp/sm_sideeffect.c                      |   29 ------------
 net/sctp/sm_statefuns.c                       |   35 +++++++++++----
 net/tls/tls_device.c                          |   39 ++++++++++++----
 net/tls/tls_device_fallback.c                 |    3 -
 sound/usb/line6/driver.c                      |   60 +++++++++++++++------=
-----
 sound/usb/line6/podhd.c                       |   21 +++++----
 sound/usb/line6/toneport.c                    |   24 +++++++---
 tools/testing/selftests/net/fib_rule_tests.sh |    6 ++
 24 files changed, 247 insertions(+), 172 deletions(-)

Andrew Lunn (1):
      net: phy: marvell: Fix buffer overrun with stats counters

Dan Carpenter (1):
      net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc

David Howells (1):
      rxrpc: Fix net namespace cleanup

Eric Dumazet (4):
      ipv6: fix races in ip6_dst_destroy()
      ipv6/flowlabel: wait rcu grace period before put_pid()
      l2ip: fix possible use-after-free
      l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()

Greg Kroah-Hartman (2):
      ALSA: line6: use dynamic buffers
      Linux 4.19.40

Hangbin Liu (1):
      selftests: fib_rule_tests: print the result and return 1 if any tests=
 failed

Jakub Kicinski (3):
      net/tls: avoid NULL pointer deref on nskb->sk in fallback
      net/tls: don't copy negative amounts of data in reencrypt
      net/tls: fix copy to fragments in reencrypt

Jim Mattson (1):
      KVM: nVMX: Fix size checks in vmx_set_nested_state

Martin KaFai Lau (1):
      ipv6: A few fixes on dereferencing rt->from

Michael Chan (2):
      bnxt_en: Improve multicast address setup logic.
      bnxt_en: Fix uninitialized variable usage in bnxt_rx_pkt().

Rafael J. Wysocki (1):
      ath10k: Drop WARN_ON()s that always trigger during system resume

Sean Christopherson (1):
      KVM: x86: Whitelist port 0x7e for pre-incrementing %rip

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Vasundhara Volam (1):
      bnxt_en: Free short FW command HWRM memory in error path in bnxt_init=
_one()

Willem de Bruijn (2):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: validate msg_namelen in send directly

Xin Long (1):
      sctp: avoid running the sctp state machine recursively


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzO6AMACgkQONu9yGCS
aT4MbhAAziI65tixN/LX2seOLjHPdnxBZK7LT32EScO0dVgtd0XERdzrr2su+68A
cmhmtcXc7rjdRNLv1D3n9PK2INQHowkQowPBkP4Z3btW8jtan8qTzDfMD1voAUHU
v5KYxGNu9Oj6sv5RoNLFneyBVwChNXVj8msc/uCW26CnX+hZlW3Xyz3kNkR4043B
iI7n3+2LIy48HpPqhh/nlq5yuaI6ijrg69KDtn6GMgxFrdn5nnELO7lDIuHMifLp
DEeh0jSQRzkf25N51eDv3cvOaOusi/KGqBP2D14S2u7APa9SOpWIkU8Fl/HXQ+KI
53HS9MBrAy2sdCeLgZZGG3T9NTUAPXlsNUpoN4We/d4+tB293+PzqQEuH00Cqi7c
HkA42YV+wU6aCmVumkswTGIW9WzA8AyCpGJL8tCh7KlrKjWFSRPYXfnAZG+sGw95
9kjuV2NZps32lMGce5cdD3dE+RP3TaAEwafvh9cl/5sS9nRCDh5srGiOu9QayFjo
rv2FjgYJAi3/qgzuTRRLX4f5/kxUOCcWvFeNHXXrhhZzT4O2MjDu9cF2AbQ5vmzI
JWrQiJbKjx8rxdi4rDPgfKoPG0h4X00QsTp+LJbZ0B3wM+6iM1qDI+0dobJYsORp
26E7jPBEjK+AG/2/7vfyMrTLV+H/kFaJnXsikQZsijXHQ9B56D8=
=rkvZ
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
