Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C234F4F4E9
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfFVJq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfFVJq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:46:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B09E2084E;
        Sat, 22 Jun 2019 09:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196816;
        bh=c3uSUpzbtmB+F+6cRqYZKCrSq+yiEnG2Ypq3Pyt8Dp0=;
        h=Date:From:To:Cc:Subject:From;
        b=L8uRaBRcO3SPga05E82kE/+t8jB2Oe8kx/+K2L9lAPgbpX8MwRgvqMCzG5iLtzNz6
         khhZn+vctXXcVrKu3PAwUb/xwDggucRC4ot1PQSH1ozMP8jYUuxLBv5HPVn2JGcVaE
         ijVlx7FJSa5V4I1ayAA3UT0QlBNAGWBCpRJOYRzI=
Date:   Sat, 22 Jun 2019 11:46:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.55
Message-ID: <20190622094654.GA12459@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.19.55 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
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
      Linux 4.19.55


--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl0N+Q4ACgkQONu9yGCS
aT5xfA//W1aR2Fx8onp0xyiTdAbqrFaEZcpPb+aKG0V3O9jvfd1zm7bUrcGbpmE5
YuBfMmHr10TLeYUE5ek/trxGGPZlXV/07bNLY4NVY7QdIEWFHzGa/FK5hP2Tpn4b
84R5ZXlSsxQ9P4788i/g/pao7UIY8hxmAlydqEb9tM1etmTEm7rtP4/sMy2ggH7a
rPeNNkhWl55P3JPaA3zrV1RWu0OW1BEts9y1MfnTTu05/YWg+LjOkmMo/vKlaD7T
pIrGOly1bt6KOY85Bixp1cmXCeox/PC7uTFpBbSJvLigNA/jc+ObZ1WDF/bM7zWw
ZPUSbEMKtBV3jSb9JAwzVb2kK+vDuiNcFtm935Q4R33BG5Ii6AnV/3WCYodiN16p
mfr0z2m72wiqi539n6LF5st474Ty9zLKCtFg7H2NK7AGP5rtJN4mf4lMR4RbnJj0
6darzaAcnFS1DxipaHaBTzxZa+HQKrJmbvlXg/L1hHD3jFbO9KnGBjlJnx3aguo1
eSmTHeakdpgILFFkh5aU6a7Kt7MV2qhqOc4hSkQhv2NUhA/Dm2gmQoRCnWzipsdG
44FJ2G7W556r/nlAj78idEgBEngL7o3sXeQF/rsXWStRRwxqUrrXtSnTWcz+R/JX
ZjrzH8A7+d7+0fRryFu7Uyx9GFbzYp3RfiMbtoRhYecXcBFWSpU=
=RVG5
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
