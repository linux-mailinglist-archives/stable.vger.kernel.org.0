Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7481EB073
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 22:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFAUt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 16:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgFAUt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 16:49:58 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94B3C03E97C
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 13:49:57 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so409531plv.9
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 13:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=Zsfe/CY3WqqlXja6vLHgdVguHtH9LaqYn6H1ozFlCfw=;
        b=xEK4RLm1kVQWM2G1DQesS0K1Jdldy89Pmf787MqRCT1k1W25neEsNIbvL+WF/9iaQK
         6dOlZusQISFuIZIvkqY9zyUzsiJbHez0y0TlR0CIMXdEzKeNInglgBXWxwKd5GmEZrcB
         lnRmci334m1aC5r9QXhX2isN+Yzlirk+Prf+hD82XqBZBoOV56raIbiecVKLnc1VYYFH
         vdot39BKY7LClpwzrpMPDWN7MQWyvzz8B0gY5Sq8y6rYMa0wyly8MptrFk3xileKVnJo
         /wmHTDXkj8Z/m6QfZnCOKqXMykpS5Q0aprSZnw4Q9t3B3lGEry1MujAwSZ3S7NHtri0o
         1Kzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=Zsfe/CY3WqqlXja6vLHgdVguHtH9LaqYn6H1ozFlCfw=;
        b=gY/dwlMY6H2uy/vNdgTdY0bwtPxtNrOrPsGGsVhsb3cqW15pyPVCpApTVeaQT2gvaJ
         XCMz0nom3P/2FI0A8kjZkjP75UkdiQxGghmkK5lE6NZpR8BcAd1Wvmu3AIiV2+ZM8cWo
         b7AO47WoTKNM9lpi+DGhmnq9DJ8KOmwqlV6cX6mseF2GINBJ+kqDeXDXuByQ0qdsqjX8
         rXF2A2sQDPGBw6CIM5XxWai6SQHbAfze6SPcqZAgUW5p9Ffe1T3QZwEGQFtqV17Vtudd
         B/ZXj1DuZBCJpfgR1+749TxgtLWS1TwNqj6uv9QTThmL/9HBsmEXZscApyxKYi05vQmz
         Tjlw==
X-Gm-Message-State: AOAM533Ts0qoYwlWHtSOv+8DJkLMpUdfkOmfFlYxYpBmNa410JzAk4ml
        f+PGMVU8s8AAL7OeELbBWpyL/g==
X-Google-Smtp-Source: ABdhPJythQhc7Usfey0VfyIV23ZnegR0Mv4dJcSKz7nL6FaA5R3MwD0eg+Cxa1MdrSNdyD/naH7Pzg==
X-Received: by 2002:a17:902:8541:: with SMTP id d1mr792724plo.234.1591044597184;
        Mon, 01 Jun 2020 13:49:57 -0700 (PDT)
Received: from [192.168.10.160] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id u61sm402013pjb.7.2020.06.01.13.49.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jun 2020 13:49:56 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <E876FECB-300E-471B-A790-D44F2F1A3F9A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_2CC2D8B3-5855-40C9-B329-6585736A68A7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v2] ext4: avoid utf8_strncasecmp() with unstable name
Date:   Mon, 1 Jun 2020 14:49:51 -0600
In-Reply-To: <20200601200543.59417-1-ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To:     Eric Biggers <ebiggers@kernel.org>
References: <20200601200543.59417-1-ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3273)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_2CC2D8B3-5855-40C9-B329-6585736A68A7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 1, 2020, at 2:05 PM, Eric Biggers <ebiggers@kernel.org> wrote:
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> If the dentry name passed to ->d_compare() fits in dentry::d_iname, =
then
> it may be concurrently modified by a rename.  This can cause undefined
> behavior (possibly out-of-bounds memory accesses or crashes) in
> utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
> that may be concurrently modified.
>=20
> Fix this by first copying the filename to a stack buffer if needed.
> This way we get a stable snapshot of the filename.
>=20
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name =
lookups")
> Cc: <stable@vger.kernel.org> # v5.2+
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Daniel Rosenberg <drosen@google.com>
> Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

LGTM.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
>=20
> v2: use memcpy() + barrier() instead of a byte-by-byte copy.
>=20
> fs/ext4/dir.c | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
>=20
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index c654205f648dd..1d82336b1cd45 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -675,6 +675,7 @@ static int ext4_d_compare(const struct dentry =
*dentry, unsigned int len,
> 	struct qstr qstr =3D {.name =3D str, .len =3D len };
> 	const struct dentry *parent =3D READ_ONCE(dentry->d_parent);
> 	const struct inode *inode =3D READ_ONCE(parent->d_inode);
> +	char strbuf[DNAME_INLINE_LEN];
>=20
> 	if (!inode || !IS_CASEFOLDED(inode) ||
> 	    !EXT4_SB(inode->i_sb)->s_encoding) {
> @@ -683,6 +684,21 @@ static int ext4_d_compare(const struct dentry =
*dentry, unsigned int len,
> 		return memcmp(str, name->name, len);
> 	}
>=20
> +	/*
> +	 * If the dentry name is stored in-line, then it may be =
concurrently
> +	 * modified by a rename.  If this happens, the VFS will =
eventually retry
> +	 * the lookup, so it doesn't matter what ->d_compare() returns.
> +	 * However, it's unsafe to call utf8_strncasecmp() with an =
unstable
> +	 * string.  Therefore, we have to copy the name into a temporary =
buffer.
> +	 */
> +	if (len <=3D DNAME_INLINE_LEN - 1) {
> +		memcpy(strbuf, str, len);
> +		strbuf[len] =3D 0;
> +		qstr.name =3D strbuf;
> +		/* prevent compiler from optimizing out the temporary =
buffer */
> +		barrier();
> +	}
> +
> 	return ext4_ci_compare(inode, name, &qstr, false);
> }
>=20
> --
> 2.26.2
>=20


Cheers, Andreas






--Apple-Mail=_2CC2D8B3-5855-40C9-B329-6585736A68A7
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl7Vae8ACgkQcqXauRfM
H+A0SA/+Lqr0KRKEEI89LdIVUAM1EoellMMlQ+pGubMR5C0rPx80xNgbPuivmJYz
eKxzdkV7t+QTC56lQISbjriAsf9HxILXtWKMRrhlBSqtkFAu28s1W/5he2ooasoe
Xw8IyMQASbKCZAiP22MZGwT8t7H9xUOS1X4IcATloFUQMZx8/39ihY+5l6j5a5QV
N4Rv34EyIqGODvQEXz6O9hdVFRdKJrxedCRQ/yY3QcBd6e4qpQKufGYM1U77dF1H
mUJ+bEPaD+7niHchFcw9E7qsoWjKy8nm6yMxzzHRrx6sW1XIw6tSFR4t6SGHnktp
84dL5FLtGlQ7jvySZdp4IJXpuJOpUMMQnrcVUhnmvhYrMnfobooueg2eA+2zUBSW
1+W3HmjMWOE1enjyLXel8HuT5YPrmuNLu8qLn5twQRlsfzauOTlmFyk5Omq7tGt4
70DWSXUN6AjM7zBO6JP47e5EwK1US6XpFl3QSFgCA32hfoja2q457ngf+XNIAGCr
At2e1QKuBdcm5H6MxP6ge2K2sSSjA0J9nbubRE0ddWrsVvDsgEjCqfodLPVqxt0R
Ynq2Zp5PQNanluObBv8XrZkLl9e2zlgG+N65B7hD2HvX1yK+Ld2N0cwdGhnprTBY
WpFVZ7XfNIGN1mpJKgBRG74vfekTDXcoG3evy4/rwkp/emcVOjM=
=YlTr
-----END PGP SIGNATURE-----

--Apple-Mail=_2CC2D8B3-5855-40C9-B329-6585736A68A7--
