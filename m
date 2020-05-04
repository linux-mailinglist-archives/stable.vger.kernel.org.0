Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379141C36D0
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 12:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgEDKYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 06:24:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgEDKYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 06:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEBC52054F;
        Mon,  4 May 2020 10:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588587850;
        bh=dSqoQ5ITOowvbI3oUWjtiSG2usCSjdl5QvmJfGhNXPk=;
        h=Date:From:To:Cc:Subject:From;
        b=jOsLMaYYNtY0J7NSbBzgupL+q+kutuK2E/LiOwr13T04AByZmi2sO7yk5fo4+aya6
         cxJJ0IzMnQJv9CoshWGR5izLk9SU1WWFQKCJRw24EIGCFJdISoYOiXHw8i/ehaLveu
         ZIvdDYVSo16caXwFzdLvXi71g4JVvSFCaT9+yd+E=
Date:   Mon, 4 May 2020 12:24:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.6.10
Message-ID: <20200504102408.GA1461414@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 5.6.10 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    2 +-
 sound/soc/meson/axg-card.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

Greg Kroah-Hartman (2):
      Revert "ASoC: meson: axg-card: fix codec-to-codec link setup"
      Linux 5.6.10


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6v7UcACgkQONu9yGCS
aT5JOw/9E39o4wjswPNJxI0XLMWCZRyomkjsxprZE/EdVuyrktFv2dAwB7FtZTjP
GuP508JuT9EREM11acztn9TLH0by2T5SH0X2O9h6iLhtMf4VgYnrIfhc5I9PG1+6
DuMOGsmJUyKU3PD0eK3aaS8WhMnhLcuBR8Y/jXgg+j0HZ4kR3jEY1BhN0pbcTq/x
b9N/8LlANXGMukUiBrnDxZlo8xsdFVgIHijneeYtA2SzRaxX830oV1TWuBra+9pc
SdEfRRV6DrDg9+kAq76e/dLkAKez3s/HuUFZd8Y9ktFHoF1JVwuCGFxVwawFy3ur
6Jb2hQq1RatmWtEnFdUcIoIImgprirf4+8CkGywsP2cwQw2kba/F731hXfvw3S0F
3wjrvX5rFkeBeExs/DrpFaWc2vDwCx0vmkhN5QKyBt5gPHdfi5B6MmOq3EICaopi
JaG04CCQdMI3RsZx9rtsZMyo/89VcVTkbO8iOQwGZwWwDbLPM72mQt7T9Vw4jTIo
rbFEb30heui+6S8huskOZMO+LQKWKfmJKUXGqzMmkpCh7SyFaCiBeqkRdSNwI9ev
dfVFaJ12H6l306LhjhH8G6zpRyYRyV00P+8JmUeVGHqYfQP4rsIL507wWMdPWDJr
LIFmfLMqDlBWQXTNesBXM83d17nnhVgBJGrwuoROcva5vziXi1k=
=fnMn
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
