Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81C4354370
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 17:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbhDEP3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 11:29:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43580 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhDEP3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 11:29:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1F06D1C0B81; Mon,  5 Apr 2021 17:29:09 +0200 (CEST)
Date:   Mon, 5 Apr 2021 17:29:08 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 004/126] ext4: shrink race window in
 ext4_should_retry_alloc()
Message-ID: <20210405152908.GA32232@amd>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085031.189492366@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20210405085031.189492366@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Whitney <enwlinux@gmail.com>

> A per filesystem percpu counter exported via sysfs is added to allow
> users or developers to track the number of times the retry limit is
> exceeded without resorting to debugging methods.  This should provide
> some insight into worst case retry behavior.

This adds new counter exported via sysfs, but no documentation of that
counter...

Best regards,
								Pavel

> @@ -257,6 +259,7 @@ static struct attribute *ext4_attrs[] =3D {
>  	ATTR_LIST(session_write_kbytes),
>  	ATTR_LIST(lifetime_write_kbytes),
>  	ATTR_LIST(reserved_clusters),
> +	ATTR_LIST(sra_exceeded_retry_limit),
>  	ATTR_LIST(inode_readahead_blks),
>  	ATTR_LIST(inode_goal),
>  	ATTR_LIST(mb_stats),

--=20
http://www.livejournal.com/~pavelmachek

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBrLMQACgkQMOfwapXb+vKcZQCfeKMu/0dzWL9OYyGgoiXHOWP0
OqsAn271Mi6QBmSukEo/oVgWp8apPipj
=a/GM
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
