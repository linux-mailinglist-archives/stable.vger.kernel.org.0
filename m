Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA08AB9B2
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405231AbfIFNsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfIFNsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:48:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614BE206B8;
        Fri,  6 Sep 2019 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777726;
        bh=XjGqsQwGOzLfXmUA0qJ7g0JfY2IRLjG4Dyn2VFqgHKc=;
        h=Date:From:To:Cc:Subject:From;
        b=Yo9bfWt/FgXeGhC4EbCbGmaVAB4+z8qwgVLGSuduGEvP+blbAAkIcjrWtl7vxZ1Uu
         y+LsKdY2Zfv2UbBjstQy8Wdp1fx4f75SK5rG+NS5D/5DKwLATvYI7etKhrtLmYqY1L
         5uva2BE3pV8MBDrldv/wvEvO4YXevZXka7nOOAgA=
Date:   Fri, 6 Sep 2019 15:48:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.71
Message-ID: <20190906134844.GA7458@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 4.19.71 kernel.

Only users of the elantech driver need to upgrade to fix a regression in
a recent release.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                       |    2 -
 drivers/input/mouse/elantech.c |   54 ++++++++++++++++++++++-------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

Benjamin Tissoires (1):
      Revert "Input: elantech - enable SMBus on new (2018+) systems"

Greg Kroah-Hartman (1):
      Linux 4.19.71


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1yY7wACgkQONu9yGCS
aT63yQ/8D9iAmNNgDP5t1tr29JWo+hpUsHgyNGS2BDEPudNPucE6r+la72ZRSJpl
gMqIVLh2q4JjkSeh0KNoJRK7Cxpj+20gXax2K4SRWjntwk6hvDPv+iJz+erGsZmw
XwGvtXbYvA/SKmnGzjH0k151B3anaM8oW3VEhd3IDnbPKKPRwgrnYDOVj9nQEwwK
1YYFd0GXI3XYtDJ2uAxEPx7dDBxbR/XrCYSMXYXGO5/X0OfvP4BKRyzrcYnDa4jy
55C/tycFJuYJ8Z9Z5e1cnc+YDKPRdl7d7W6eKeG9RFEmkEimnamnHcc/TfQrEaXG
ouSVnI2GhX/UYyAjsIOlQFjbXEyGmq52w6BL/QupeLOhNG6MhLDCWVAxgY76BlFB
BA2yoMxIdTLr6AdHkIBxhCBIhyNJuvruBzs3Aje4/8+TwJNQvEPee0EeAyxckGU1
9Pszm5oqrwTVuGj9fGl51/dSY069oThUS2N2Qnhtk3mKRViy+X/SJslyZOrVsMQD
GXHolHqWTtOSOpGMdEddC/cQNeaW2V2g/B1PK4vW6qGisuJ82ny5vX4SXw0RUUvc
E9e85jzhdn4sf8OFIaB1eZIxV4yK31yl4VfQMGaNtUSdzY1weXM2N0B+JqStMt3R
QHCjhLmWtn8SiwXN7irpoTQvpO+PmRged7X5D+UGfcSXwHchfWk=
=QFx9
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
