Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522E6B386B
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbfIPKmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:42:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfIPKmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 06:42:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EE42214AF;
        Mon, 16 Sep 2019 10:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568630535;
        bh=i6bT0XIAm4fxnkgDFRF1QytPZAQ4A0vVm09BqMS2vmY=;
        h=Date:From:To:Cc:Subject:From;
        b=cmm4IrBqN6+4gXgczkM2FHdtrdVIu/edjIYRw6TbGNFZE15aTGM1tT6rPctloWphp
         LMKM9Vd256GWyUgTCrkzkB/5Yb10rP+4sUsqp9ZRudc9xxx6Yv+5XuzWS0KsFhzU6G
         n3eJ9Lf2zR7mq3ajPKorLEbOWzrErkQnV+j28g4g=
Date:   Mon, 16 Sep 2019 12:42:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.193
Message-ID: <20190916104213.GA1386724@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.9.193 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 +-
 arch/powerpc/kernel/process.c       |    3 ++-
 drivers/clk/clk-s2mps11.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c |    8 +++-----
 drivers/vhost/test.c                |   13 +++++++++----
 drivers/vhost/vhost.c               |    4 ++--
 include/net/ipv6_frag.h             |    1 -
 include/net/xfrm.h                  |   17 +++++++++++++++++
 kernel/sched/fair.c                 |    5 +++++
 net/batman-adv/bat_iv_ogm.c         |   20 +++++++++++++-------
 net/batman-adv/netlink.c            |    2 +-
 net/key/af_key.c                    |    4 +++-
 net/xfrm/xfrm_state.c               |    2 +-
 net/xfrm/xfrm_user.c                |   14 +-------------
 scripts/decode_stacktrace.sh        |    2 +-
 sound/pci/hda/hda_auto_parser.c     |    4 ++--
 sound/pci/hda/hda_generic.c         |    3 ++-
 sound/pci/hda/hda_generic.h         |    1 +
 sound/pci/hda/patch_realtek.c       |    2 ++
 19 files changed, 67 insertions(+), 42 deletions(-)

Cong Wang (1):
      xfrm: clean up xfrm protocol checks

Dan Carpenter (1):
      drm/vmwgfx: Fix double free in vmw_recv_msg()

Eric Dumazet (2):
      ip6: fix skb leak in ip6frag_expire_frag_queue()
      batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

Greg Kroah-Hartman (1):
      Linux 4.9.193

Gustavo Romero (1):
      powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction

Liangyan (1):
      sched/fair: Don't assign runtime for throttled cfs_rq

Nathan Chancellor (1):
      clk: s2mps11: Add used attribute to s2mps11_dt_match

Nicolas Boichat (1):
      scripts/decode_stacktrace: match basepath using shell prefix operator, not regex

Sven Eckelmann (1):
      batman-adv: Only read OGM tvlv_len after buffer len check

Takashi Iwai (2):
      ALSA: hda - Fix potential endless loop at applying quirks
      ALSA: hda/realtek - Fix overridden device-specific initialization

Tiwei Bie (1):
      vhost/test: fix build for vhost test

yongduan (1):
      vhost: make sure log_num < in_num


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1/ZwIACgkQONu9yGCS
aT6c+xAArfLFGtxRj9RjJryN6Z5HSBFN6N7MyQCG6x4zV+O2A4lb+d7rHAV8/LJD
ukLSoDD5CmZg38d/e0m/ZUO+nFKlpbdwwAYsRL4vGhwUp5SnVYp/xhpTAPp3VqQs
r8QUsCagW9yCV0rAUcB+q1oMzY8qNMorNyI09V2StN0OCShfPXZrxjbytJMA+GaI
9j4vUkNnA+uF7+DXNtXWl18hutMHH+2/zwE3n5NyGBScZKN9wJuLlJTKuCbZQHDE
rDyMeLkwrdqn9mag3vsM7gQq5zD4UOqVXxUj1JB1mO0M6jRml/lEmcDtZYVSEZDO
run5TxfG/L+pga7wkjAIcFm8csNUxgq438A5GwCA32Rw9C2U9S21HF8qhHLzPUOz
W8MyE+dRUrsUbIYawz5PuY6BOLQJTgDBjyElU4sDP7u6cg/da4rZDWRHPCIS73R9
D/l/YZCzBtA9XGGD5DbTssYHSnVUeH49ggK/ScXqigzWSmkbjoKhJaLs8385vvXg
AEPrOsFjpJNeUIJE7eIIAOWF9HYEjMXbYytN6Bk1TzyokTmUOT9BT21tKNV9t3cy
vNK0Xvfu8e6bFlhJEpbCbNl7H45ZABPU8obmebhcPczFlEKugmbqOwRr77Vd//Wq
iwk78H/qJHgtAH01sWWTYRDr98of8LqnjEbYOfP0DLp4dkLF6WQ=
=diI3
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
