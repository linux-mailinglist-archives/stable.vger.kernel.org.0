Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7AB1F198C
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 15:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgFHNAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 09:00:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729002AbgFHNAz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 09:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591621253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=smClL9MNx5dmbsURmN/I6y5n/kHtT+SYrTqz4fFY4K8=;
        b=SK9eoMVzvmAe/mxFA/lEfPrpO3V6KWoGKkW9lZ7wUvXz41RkHD6uirJ/RqdPnmPdRnfE9B
        NVoBUt2kv74Co0qeaND2uGcsskjB1Rll66QLbj4SoygDyNp+V05f2/P+pnCH7lGW+oEVDd
        V4QFYnXNSH71fR6z9WZaDYkEWXEYONM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-WNG0CMDFPKGz4ZMvXG_1Kg-1; Mon, 08 Jun 2020 09:00:25 -0400
X-MC-Unique: WNG0CMDFPKGz4ZMvXG_1Kg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0040102CC32;
        Mon,  8 Jun 2020 13:00:23 +0000 (UTC)
Received: from localhost (ovpn-116-92.gru2.redhat.com [10.97.116.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A14E4768B4;
        Mon,  8 Jun 2020 13:00:21 +0000 (UTC)
Date:   Mon, 8 Jun 2020 10:00:20 -0300
From:   Bruno Meneguele <bmeneg@redhat.com>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     torvalds@linux-foundation.org, zohar@linux.ibm.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH] ima: Remove __init annotation from ima_pcrread()
Message-ID: <20200608130020.GA655567@glitch>
References: <20200607210029.30601-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
In-Reply-To: <20200607210029.30601-1-roberto.sassu@huawei.com>
X-PGP-Key: http://keys.gnupg.net/pks/lookup?op=get&search=0x3823031E4660608D
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 11:00:29PM +0200, Roberto Sassu wrote:
> Commit 6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in
> ima_eventdigest_init()") added a call to ima_calc_boot_aggregate() so tha=
t
> the digest can be recalculated for the boot_aggregate measurement entry i=
f
> the 'd' template field has been requested. For the 'd' field, only SHA1 a=
nd
> MD5 digests are accepted.
>=20
> Given that ima_eventdigest_init() does not have the __init annotation, al=
l
> functions called should not have it. This patch removes __init from
> ima_pcrread().
>=20
> Cc: stable@vger.kernel.org
> Fixes:  6cc7c266e5b4 ("ima: Call ima_calc_boot_aggregate() in ima_eventdi=
gest_init()")
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/ima/ima_crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima=
/ima_crypto.c
> index ba5cc3264240..220b14920c37 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -786,7 +786,7 @@ int ima_calc_buffer_hash(const void *buf, loff_t len,
>  =09return calc_buffer_shash(buf, len, hash);
>  }
> =20
> -static void __init ima_pcrread(u32 idx, struct tpm_digest *d)
> +static void ima_pcrread(u32 idx, struct tpm_digest *d)
>  {
>  =09if (!ima_tpm_chip)
>  =09=09return;
> --=20
> 2.17.1
>=20

Reviewed-by: Bruno Meneguele <bmeneg@redhat.com>

thanks Roberto.

--=20
bmeneg=20
PGP Key: http://bmeneg.com/pubkey.txt

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEdWo6nTbnZdbDmXutYdRkFR+RokMFAl7eNmQACgkQYdRkFR+R
okN8Xwf/e4bCIbSvzmJh44G85XHrB+tA9X0A070MnWKQ5Bksf6v4kZPmxy4eZ39+
nknWp1a8QMTjS08aNfibFGJbjPROPgXX909VaIOwr18K5GcdTbQLVYF8qhWkDn2E
Z8GW9bDLd7wIct3O1JQIIwaSEUVyReKiclYsITbznjoPnt+RExChTNG2NhkEki+d
yhXXkhaNXpr+EbUHKs/WZFPFX6dK0FsoYD/QA2xnDaPlRvDKjiIE01ojeCOg/hXz
e4tgAWWan1w4Ak8tJeNWBhf7E9Qf+vMEHOCB0uPtnQ8VJRYpxJCkVyQEQ9Ys2LHX
Hh+1816UmnycrQd4Ez8EgOjhpB1ZHQ==
=7AaN
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--

