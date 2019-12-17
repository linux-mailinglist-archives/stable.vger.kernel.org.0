Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC57123B23
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 00:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLQXvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 18:51:19 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:46597 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfLQXvS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 18:51:18 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47cvzl1j8Rz9sR1;
        Wed, 18 Dec 2019 10:51:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576626676;
        bh=GnAUl3PzTD6UAywDYOK5oZBCRdCtb1Q1Fvz2NZyJwW4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FEDg76Bk1tsPQeXr3u1NZQNYOZrA6PbRIZKko1PfFko37HZicLFhauEfRY7pHiBNN
         3AVfAzKjEUUp9gYrPHXlmgFtC4aPw6SC5MvoVyS7MAbAWKoQIpqiwD3GXW/bk03fOR
         mlXrg5vlq4J/raXu+fL5edfZPAoRt0ekqBMQoOClyw6fpUlOe1Imd+JbvCYUNb4Tsm
         aQBmggN2jrYso14Eajag2u2xFfj5WPXpXy9+saXwLt2FFl+996ZlIrL06yNCgzR7Pe
         FOmSmaqe0QkmjX650wK9PNkqZFHe2e2h1rL5OQOpEuTXzdAAg/VPTEY+AQMGzONakF
         hWwzNe+RsImng==
Date:   Wed, 18 Dec 2019 10:51:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ammy Yi <ammy.yi@intel.com>, stable@vger.kernel.org
Subject: Re: [GIT PULL 4/4] intel_th: msu: Fix window switching without
 windows
Message-ID: <20191218105113.21cc94fb@canb.auug.org.au>
In-Reply-To: <20191217120629.GB3156341@kroah.com>
References: <20191217115527.74383-1-alexander.shishkin@linux.intel.com>
        <20191217115527.74383-5-alexander.shishkin@linux.intel.com>
        <20191217120629.GB3156341@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UIwpCo_nVWJXHjBngfC9MRi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_/UIwpCo_nVWJXHjBngfC9MRi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 17 Dec 2019 13:06:29 +0100 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> On Tue, Dec 17, 2019 at 01:55:27PM +0200, Alexander Shishkin wrote:
> > Commit 6cac7866c2741 ("intel_th: msu: Add a sysfs attribute to trigger
> > window switch") adds a NULL pointer dereference in the case when there =
are
> > no windows allocated: =20
>=20
> Commit ids should only be specified in 12 digits, not 13 :)

It is possible that 13 digits may be necessary to be unambiguous within
a git repo.  In fact, as we continue with a single git repo (Linus'), at
some point 13 digits will become normal.

--=20
Cheers,
Stephen Rothwell

--Sig_/UIwpCo_nVWJXHjBngfC9MRi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl35afEACgkQAVBC80lX
0Gyn5gf9EbgzxPiJZyCJewP+YFS3xms6a67yK8sbNVizB+qvdjP0YmGOdYwYll/u
sKqhu2CLRiTcZrzsqCYR0sGPm5BJ/0K2z7T0ZRvOZzulAS0N+WKilLqdRmsaYuFJ
EC9p+i2Exr4aJldLUDNbLmzcPaXTAHXGEPbzUwgrOAD/edV3CIEydM1/c+HliD9N
ap/6mYV181HvYOG3poYi4E0aGOvk1nWUtMPLubXnRg/2xT7F3bHD+cMGi0zYFJ4T
R+S/lPvWRaCtBcmVnNFI2vpdj1ZkAq+uB07hgVfCAJ2ZRdJHi2KEIaA0XuV+nExC
8peLAA0uvQs1X03M39e2fY1o/z45hQ==
=lBmi
-----END PGP SIGNATURE-----

--Sig_/UIwpCo_nVWJXHjBngfC9MRi--
