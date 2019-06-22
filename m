Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29FE4F4F1
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfFVJrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfFVJrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:47:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F6552063F;
        Sat, 22 Jun 2019 09:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196865;
        bh=y+3S2MmtYwobdHsgsM90oZ11uxCzHwR+iYZai4G2Cbw=;
        h=Date:From:To:Cc:Subject:From;
        b=L6r2HHQjU3H5n4fDsc8kihvmR8kfnG3rq0ECLQC5B7+sgMTLKVDLfJM74zfdOg6K2
         vbyb1U7fjn+gq2/zWxCff1iFiSIkAOWFjyNSH/QYU60Okunj8ydUtUG91gT7q9+5Lu
         pigLfhtPadHltvy+fVzsP8H15jEmlF6IgFJp8FFc=
Date:   Sat, 22 Jun 2019 11:47:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.14
Message-ID: <20190622094743.GA12599@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.1.14 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.1.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile              |    2 +-
 net/ipv4/tcp_output.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

Eric Dumazet (1):
      tcp: refine memory limit test in tcp_fragment()

Greg Kroah-Hartman (1):
      Linux 5.1.14


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0N+T8ACgkQONu9yGCS
aT5cTw//RUJ3fvphPvdp6GNGhu4N9eyhJibYADsHz0LGwR3dr6gtvCQHcjsuqQCs
jis2edRGx4lIx3g6AncMXkhaFFjbVu77n58zCEdJHt3QVjCCwVUTSmcnBfEeLoQT
xPSF4HOoQS03h6A36x+r8bPzAIwId/KxBic8vX/ALBvui3Je1M8HIlgiwKggQ8Zx
9epscuKHZOAk4+6jMpblcJu68LK/UAPOv02vkb/zbi3xSDxdtIquryASEcmkgv94
E0anQg9zxfk7J3qNsso1uO7/kp6uw8Rz5sM/ny2/J7UiMjswtvwWPpIuMIzrrgMf
HWnKwFqDwqUby72GVVguc1tVqzJ9d8wjZNJ7E1gsVYnzpJhxWwdh55z3QBXqsmwb
vPK+d0DM5m+hliWXT8unifqpumvn4cRfyleboLdOyh0gs3xavpWIvXTbpQNtqW1X
7wwLX28OV8i0nfgMNLAPvlW0GUDUybnfugene2jNxqOB8cWVWTcH/0SBqGkfWA/t
fSk4Z0htMGa56aHh6M2uD48wNCPQxeMcmyx1bKYJWIqU4XZHZ4Bj+SUfOy91RuQs
j0nb/Enb6QXS62/PT7Y8wTHdz7R8sU1o266ZFIFakQ+IriTR/A7+59RQ8wMo+l6a
/jJiy/XaP/aA2RzTRWNx37s/U2+ZDrGZ0nqky9JyGYDCSbjC8kI=
=CMt1
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
