Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D54E513C43F
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 14:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgAON5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 08:57:32 -0500
Received: from mout-p-101.mailbox.org ([80.241.56.151]:20812 "EHLO
        mout-p-101.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbgAON5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 08:57:31 -0500
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 47yTRD1PgRzKmfm;
        Wed, 15 Jan 2020 14:57:28 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id kTcyfk68cgcH; Wed, 15 Jan 2020 14:57:21 +0100 (CET)
Date:   Thu, 16 Jan 2020 00:57:04 +1100
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
Message-ID: <20200115135704.eh4atya6fwnikyll@yavin>
References: <20200101005446.GH4203@ZenIV.linux.org.uk>
 <20200101030815.GA17593@ZenIV.linux.org.uk>
 <20200101144407.ugjwzk7zxrucaa6a@yavin.dot.cyphar.com>
 <20200101234009.GB8904@ZenIV.linux.org.uk>
 <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
 <20200114045733.GW8904@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3nfjay3o6o7sfgzp"
Content-Disposition: inline
In-Reply-To: <20200114045733.GW8904@ZenIV.linux.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3nfjay3o6o7sfgzp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2020-01-14, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 1) do you see any problems on your testcases with the current #fixes?
> That's commit 7a955b7363b8 as branch tip.

I just finished testing the few cases I reported earlier and they both
appear to be fixed with the current #work.namei branch. And I don't have
any troubles booting whatsoever.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--3nfjay3o6o7sfgzp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXh8aLQAKCRCdlLljIbnQ
El7BAP4mVcB8EHkVpb1BiYmM6aGj6dmCburCpsIPyRObtfW53wD9GQvyGsKlZef1
tVRXIsFXbnwRaq5E9oXLf8yZ1F1nuAc=
=l76M
-----END PGP SIGNATURE-----

--3nfjay3o6o7sfgzp--
