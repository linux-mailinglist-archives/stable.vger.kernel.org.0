Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B24713FCF
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 15:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfEENl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 09:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbfEENl5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 May 2019 09:41:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9215B2082F;
        Sun,  5 May 2019 13:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557063717;
        bh=KGVrrkdMLhOO6/l3aCvofw0Vd1u0OSIKDiXrLorb9Q0=;
        h=Date:From:To:Cc:Subject:From;
        b=jtrlejK0KlF3voDP35tIvlB4qDzuxry+dQc01IwKAV20iwcpcS39cwGsbQTGGArfC
         31UQCzaRKspTErpC7ZplPfp67eYKWUdMkzT8nPl7NVjfoN1+zvAASAxpsWp4HPKKsW
         Ih1P7tL0kPcTIN+x4juBORuxSXrNjaZNY9tWzSqA=
Date:   Sun, 5 May 2019 15:41:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.13
Message-ID: <20190505134151.GA8399@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.13 kernel.

All users of the 5.0 kernel series must upgrade.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/x86/include/uapi/asm/kvm.h                      |    1=20
 arch/x86/kvm/vmx/nested.c                            |    4 -
 arch/x86/kvm/x86.c                                   |   21 ++++++
 drivers/net/dsa/bcm_sf2_cfp.c                        |    6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |   53 ++++++++++----=
--
 drivers/net/phy/marvell.c                            |    6 +
 drivers/net/wireless/ath/ath10k/mac.c                |    4 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |    5 +
 include/net/sctp/command.h                           |    1=20
 net/ipv4/ip_output.c                                 |    1=20
 net/ipv4/tcp_ipv4.c                                  |   13 +++-
 net/ipv4/udp_offload.c                               |   16 +++--
 net/ipv6/ip6_fib.c                                   |    4 -
 net/ipv6/ip6_flowlabel.c                             |   22 ++++--
 net/ipv6/route.c                                     |   47 ++++++--------
 net/l2tp/l2tp_core.c                                 |   10 +--
 net/packet/af_packet.c                               |   37 +++++++----
 net/rxrpc/call_object.c                              |   32 +++++-----
 net/sctp/sm_sideeffect.c                             |   29 ---------
 net/sctp/sm_statefuns.c                              |   35 ++++++++---
 net/tls/tls_device.c                                 |   39 ++++++++----
 net/tls/tls_device_fallback.c                        |    3=20
 sound/usb/line6/driver.c                             |   60 +++++++++++---=
-----
 sound/usb/line6/podhd.c                              |   21 +++---
 sound/usb/line6/toneport.c                           |   24 +++++--
 tools/testing/selftests/net/fib_rule_tests.sh        |   10 ++-
 27 files changed, 308 insertions(+), 198 deletions(-)

Andrew Lunn (1):
      net: phy: marvell: Fix buffer overrun with stats counters

Dan Carpenter (1):
      net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc

David Ahern (1):
      selftests: fib_rule_tests: Fix icmp proto with ipv6

David Howells (1):
      rxrpc: Fix net namespace cleanup

Eric Dumazet (6):
      ipv6: fix races in ip6_dst_destroy()
      ipv6/flowlabel: wait rcu grace period before put_pid()
      l2ip: fix possible use-after-free
      l2tp: use rcu_dereference_sk_user_data() in l2tp_udp_encap_recv()
      tcp: add sanity tests in tcp_add_backlog()
      udp: fix GRO packet of death

Greg Kroah-Hartman (3):
      ALSA: line6: use dynamic buffers
      iwlwifi: mvm: properly check debugfs dentry before using it
      Linux 5.0.13

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

Michael Chan (5):
      bnxt_en: Improve multicast address setup logic.
      bnxt_en: Fix possible crash in bnxt_hwrm_ring_free() under error cond=
itions.
      bnxt_en: Pass correct extended TX port statistics size to firmware.
      bnxt_en: Fix statistics context reservation logic.
      bnxt_en: Fix uninitialized variable usage in bnxt_rx_pkt().

Paolo Abeni (1):
      udp: fix GRO reception in case of length mismatch

Rafael J. Wysocki (1):
      ath10k: Drop WARN_ON()s that always trigger during system resume

Sean Christopherson (1):
      KVM: x86: Whitelist port 0x7e for pre-incrementing %rip

Shmulik Ladkani (1):
      ipv4: ip_do_fragment: Preserve skb_iif during fragmentation

Vasundhara Volam (1):
      bnxt_en: Free short FW command HWRM memory in error path in bnxt_init=
_one()

Willem de Bruijn (3):
      ipv6: invert flowlabel sharing check in process and user mode
      packet: validate msg_namelen in send directly
      packet: in recvmsg msg_name return at least sizeof sockaddr_ll

Xin Long (1):
      sctp: avoid running the sctp state machine recursively


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzO6B8ACgkQONu9yGCS
aT5mvA/+O3gHdoBkIKuh2EC/4p1yWjXu7fORqWXO0C1FetWOwsu5TDJA9fw21ckx
jO27B1SRX3DgWPWe9ICflp41x1qpmzyGdSx0jwSegtyMmLfNS0KXUsSNMbUjSBE2
7eXMJb79AqDh9CeNHDIABhv6OzP9zf+sStk5XtUYASHX/CDx/mx7DdvNDNU2Wa5l
S9wgWtajf8j+4uiuDXBLbU/4peUSEubrd8xBFh4xSJmHTgEW+it5v6HSgLEKUNyy
eziikxBR/2xe2qHv/duD85XnLS1PMZraZ+XgkciPiF3ZRqluBJVLLhKa4lHmshJk
Weqyt2IE4YROrFpF2liL8qEhsDrYxlg2ze7bDlj1kyFYzAUv/pNrRDnpP/DXvYIf
/hoKXq41bGuHIJfwEXwPzbMFDG1TZcwK2p3AqOu4VRjMJLenLb0a0Yrx8Xu2nIcW
txlDpRxYaZUOCnJQ5xRGK0QFo+JD4j1mVK7nPtAfCo6ffgAZUis2zeRl3oBOCK6J
o8SQOPf16IJsDyGeJuS7e9x4W71FSz8SJwpOR3UHZnDTER5OUoIuM1S96fFocgb4
wxRLw3wTfWWFbzH1Qft8LhdvGILiDcwp+yu+ub1gKhEJvEoXm5OHEgeB5VSythuI
AEwOuU3GM+K8QDP8fah4q46lBfqMflnEdqZsLfZCE/eEhDxrzIQ=
=hL3i
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
