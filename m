Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0FD10E134
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLAJk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbfLAJk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:40:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23B3A2146E;
        Sun,  1 Dec 2019 09:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193226;
        bh=bBEx30937oQWTklC9HqpFSRNgSEVmxypDVKCqn4dI4o=;
        h=Date:From:To:Cc:Subject:From;
        b=rv8JEtNbLgHMI6+qrdeH31+JsvHadILm+vEPC7TEw8vEphchhKtrTqz4ert+uDpQO
         o1q99LdqDzjdNL+FAkksOSyHeBxDeU8Z7tYtpohLYfCNkhPlGQrwLkLmWwq5ulPXVC
         w56fXvcVBEOo6XBmuppa53xpOUPdHzFe5Grau/zE=
Date:   Sun, 1 Dec 2019 10:40:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.205
Message-ID: <20191201094024.GA3788378@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.9.205 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile        |    2 +-
 net/core/sock.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

Greg Kroah-Hartman (2):
      Revert "sock: Reset dst when changing sk_mark via setsockopt"
      Linux 4.9.205


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3jiogACgkQONu9yGCS
aT6plBAAwBYbBJQMyxAa1mEJzZIFWGrqorQpZH/uaT0mSjZd2FsobI7j0fTpSOCQ
iYq3EBXHsfpr/bJJexEmblsdiCxIlOsIe72JQ0DqLZDnFM9CGBzl//4ArKIvliNl
X5XCPeV2vAKaBMQwdll8sadtEP46WIht4FB3umnHvnQ/igIHuyKtJPrYsi/UvisF
sqtwZ3BcjOWLrRYctXTlVDcZxWGHdy4lNSwXqstv9sb79r8VNJz3dRa0ecoSvuJO
XOmlyTrzBGkUD4m2bna8UcNDmsE+JbWjEJm2bU0s0WiCSGriipU6LGIhENuaYhWq
FPlTAh54SlMHDPAcHqlykbsxO7g9fgMzq6jf3L4Xafku9xJpOseTk9OBzxM/Id1i
jz4gTDDONbxtUgdf3RUZ+JhcoS9cqybR0JH4C8q/c7dByyqupgLNs0NR79hsbMJJ
2gQTPnMxBqVRmy7AnOq9n7EMzLPvCnzFUo41bos7jHP1eAR+TwYG888wSDr7I8fA
EUxoCQpexovMyzSrwXA1gkFMqyDG0pY2dZBeNa+FqdCrKZuOUuF8KeNAmVEdKOpk
EZwjbOci7aZDJX/GeWtfO/JTmmYhaNKPtsnwOvGq7qEvbouTpRiGSaJtbeafU0jc
YDG9lvTcVS00f3RO69KqBn7F0Yiw0U2oKoEXI5OiIAeNZk8Txw0=
=CQPX
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
