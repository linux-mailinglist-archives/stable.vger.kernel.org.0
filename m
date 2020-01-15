Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDB313C633
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 15:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgAOOfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 09:35:22 -0500
Received: from mout-p-101.mailbox.org ([80.241.56.151]:22240 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbgAOOfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 09:35:21 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 47yVGv2gWTzKmbK;
        Wed, 15 Jan 2020 15:35:19 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id P4dLfi4K-_0D; Wed, 15 Jan 2020 15:35:13 +0100 (CET)
Date:   Thu, 16 Jan 2020 01:34:59 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ian Kent <raven@themaw.net>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200115143459.l4wurqyetkmptsdm@yavin>
References: <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
 <20200114045733.GW8904@ZenIV.linux.org.uk>
 <20200114200150.ryld4npoblns2ybe@yavin>
 <20200115142517.GI8904@ZenIV.linux.org.uk>
 <20200115142906.saagd2lse7i7njux@yavin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u4mn5eoypdaexxxf"
Content-Disposition: inline
In-Reply-To: <20200115142906.saagd2lse7i7njux@yavin>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u4mn5eoypdaexxxf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-16, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2020-01-15, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Wed, Jan 15, 2020 at 07:01:50AM +1100, Aleksa Sarai wrote:
> >=20
> > > Yes, there were two patches I sent a while ago[1]. I can re-send them=
 if
> > > you like. The second patch switches open_how->mode to a u64, but I'm
> > > still on the fence about whether that makes sense to do...
> >=20
> > IMO plain __u64 is better than games with __aligned_u64 - all sizes are
> > fixed, so...
> >=20
> > > [1]: https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar@cypha=
r.com/
> >=20
> > Do you want that series folded into "open: introduce openat2(2) syscall"
> > and "selftests: add openat2(2) selftests" or would you rather have them
> > appended at the end of the series.  Personally I'd go for "fold them in"
> > if it had been about my code, but it's really up to you.
>=20
> "fold them in" would probably be better to avoid making the mainline
> history confusing afterwards. Thanks.

Also (if you prefer) I can send a v3 which uses u64s rather than
aligned_u64s.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--u4mn5eoypdaexxxf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXh8jEAAKCRCdlLljIbnQ
EgAQAQC483OrZyiBJYG/79I435iT1B2imv4w4itecQxjDIotqQEA4j43Ly9wivoP
vlgdPGsgRV9piX8BxAvqQHyRKdQcdww=
=q/o9
-----END PGP SIGNATURE-----

--u4mn5eoypdaexxxf--
