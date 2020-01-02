Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7CA12E43E
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 10:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgABJJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 04:09:51 -0500
Received: from mout-p-201.mailbox.org ([80.241.56.171]:20516 "EHLO
        mout-p-201.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbgABJJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 04:09:50 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 47pMgJ3j5zzQlBc;
        Thu,  2 Jan 2020 10:09:48 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id froh9y1uxPey; Thu,  2 Jan 2020 10:09:43 +0100 (CET)
Date:   Thu, 2 Jan 2020 20:09:20 +1100
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        stable <stable@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Serge Hallyn <serge@hallyn.com>,
        "dev@opencontainers.org" <dev@opencontainers.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Message-ID: <20200102090920.gmvq45gqopbzmrgk@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
 <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
 <20191230072959.62kcojxpthhdwmfa@yavin.dot.cyphar.com>
 <CAHk-=whxNw7hYT6bJn9mVrB_a=7Y-irmpaPsp1R4xbHHkicv7g@mail.gmail.com>
 <20191230083224.sbk2jspqmup43obs@yavin.dot.cyphar.com>
 <e1066da936244de99e7ee827695d6583@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aavym7oejblostsf"
Content-Disposition: inline
In-Reply-To: <e1066da936244de99e7ee827695d6583@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aavym7oejblostsf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-02, David Laight <David.Laight@ACULAB.COM> wrote:
> From: Aleksa Sarai
> > Sent: 30 December 2019 08:32
> ...
> > I'm not sure I agree -- as I mentioned in my other mail, re-opening
> > through /proc/self/fd/$n works *very* well and has for a long time (in
> > fact, both LXC and runc depend on this working).
>=20
> I thought it was marginally broken because it is followed as a symlink?
> On, for example, NetBSD /proc/<n>/fd/<n> is a real reference to the
> filesystem inode and can be used to link the file back into the filesystem
> if all the directory entries have been removed.

That is also the case on Linux. It (strictly speaking) isn't a symlink
in the normal sense of the word, it's a magic-link (nd_jump_link
switches the nd->path to the actual 'struct file' in the case of
/proc/self/fd/$n).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--aavym7oejblostsf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXg2zPQAKCRCdlLljIbnQ
EvDUAQD/miJLSU0UGR24uJ4vorUDe6zn8CWjBhcDBgK2ejycbgD/RUnnLLzg2tDG
DxDaMXQZ+/wUmmG8jNkAC1kHBVf3PAY=
=PoFx
-----END PGP SIGNATURE-----

--aavym7oejblostsf--
