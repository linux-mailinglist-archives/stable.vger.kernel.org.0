Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AE63CB57A
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhGPJzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 05:55:40 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51600 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhGPJzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 05:55:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7E9641C0B82; Fri, 16 Jul 2021 11:52:44 +0200 (CEST)
Date:   Fri, 16 Jul 2021 11:52:43 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 5.10 140/215] mm,hwpoison: return -EBUSY when migration
 fails
Message-ID: <20210716095243.GA12505@amd>
References: <20210715182558.381078833@linuxfoundation.org>
 <20210715182624.294004469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20210715182624.294004469@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Oscar Salvador <osalvador@suse.de>
>=20
> commit 3f4b815a439adfb8f238335612c4b28bc10084d8

Another format of marking upstream commits. How are this is number 8
or so. I have scripts trying to parse this, and I don't believe I'm
the only one.

> Link: https://lkml.kernel.org/r/20201209092818.30417-1-osalvador@suse.de
> Signed-off-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Could se simply place Upstream: <hash> tag here? That should
discourage such "creativity"... plus it will make it clear who touched
patch in mainline context and who in stable context.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDxVusACgkQMOfwapXb+vL/ywCaA9AxmEi/0e539yr6i76sbWx0
PTYAoJr3uwgDGvyh8EZtZtKkqxlbnvni
=4+Fo
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
