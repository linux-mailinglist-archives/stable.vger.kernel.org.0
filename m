Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81761AB9B7
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404573AbfIFNt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404571AbfIFNt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 09:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F0F9206B8;
        Fri,  6 Sep 2019 13:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567777767;
        bh=TeHdu5CRT6r2GVj18MWT5zlC3OYB2+IkxRx/h7oFjpw=;
        h=Date:From:To:Cc:Subject:From;
        b=NyvF/0QsEW8a9F8fF7iTfVNjNC728mB/knT6i0OCgPsymvAxNQR5fAfpA+4IXbH1m
         puNKdNKY2WrqNLkxtich0//nz7KlZV9kubmzsTGAjUBcvyvR8RV6NIYmU/M0mxEBFz
         FmJ7QrAbBs80kkvb70UgE0zIPTZGTCZ8QSovzVZU=
Date:   Fri, 6 Sep 2019 15:49:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.13
Message-ID: <20190906134925.GA7628@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.2.13 kernel.

Only users of the elantech driver need to update to fix a regression in
a previous release.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.2.y
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
      Linux 5.2.13


--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1yY+UACgkQONu9yGCS
aT5XIBAAvk2Fx4xJxuu1EM8GhIFQ0SYQlvQNQVwmuJwQirCoe5kHayI/wEnX/RkB
O6jEaErVE+ZstDREPJsqDjx7JFCkjbqSAas+sKv5sCa5Nyj/kpskg4Z/AAuFbB/O
b3qeTxQjyp13djUBrQ+KWRz1Km5oKtN4LJqRnBEt5XI5YKh0IT9kKuFGBgq1jB5K
wFMhuzhMmqHPXCmU3xiHJJpMJo/7NGK7ww0VUg67N8WpmGbTIAADXSal5Oj0t+Fu
Na40V7ChviNnKKBpcpfW3mhFujsZYA91DsHxaCN05E/nsbd5jMfU9N7EXUIeIAIJ
6+zo8sqlSoJWnsktauliZKgLsz4SgApdYP1+wxr0LYQQYkI5hSH0AdGMbUPF2PFM
p8gT2IqVPWzb48ELqw3rKhOt5kPpb7jL3A3TUj/M8NkvcyaHGpCbqTAEIA2z+iWj
xaFJAqZ/A5RiD0QDC3P4JW7qDEbtBcWqUqtOSJF32LiV3WZ5ttUUIWrSIaElTPsP
hm7c+SVy8mFadnSuCxX/Bhuvm0voM7SOUzv7dbteN0kA508ib5oSG2OA5opK85k0
JxvJNGLPgbAPqMwWIx2DuojpfMONz8zrxb1PP1xlXEDKUNEIAu2CRtvug+E/N7bB
UgH/EsKPLXM2ri4R5wO17hkxrKrjyF8N76udr3hh8dKq4WbKmSI=
=b3se
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
