Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC11531239B
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 11:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhBGKk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 05:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGKkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 05:40:24 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0383FC06174A;
        Sun,  7 Feb 2021 02:39:44 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id g9so10145909ilc.3;
        Sun, 07 Feb 2021 02:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YMMIyTCki+9i32Ez9wobGW2ITQ3cFhfvrhoAKi9gJ9I=;
        b=kyVZS4o+EwwglVoW4YSIjB50Uevqa56z9lcybkJ00BYz5CYIXW/z2PPzbde6GwrJks
         34BDNnBHPC88GMj0cEdzyYRMgXVo19UCRYDpnz3SNPAnH5WU0ge/Fl5DZuHOUgVrRk+l
         /FD/hy/+jF0ZqtUL+it+zXB+G6HwBq/29lEJ1qUhPmb406TKWr5kRxXMohUEfw9FkvAx
         pUovz2smEMn8aJZDaFH4sCyNXPZppXgMS2uxXLbdP4v4sviP+8vFPAE0JDxABYw33UxI
         pVb4PgKcOGk4wRBvh3e/pmntkv1KbQm+GK2AwDSkQEQ/Tn1kdR2vSMwFTTYvKTLJoWyg
         +rEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YMMIyTCki+9i32Ez9wobGW2ITQ3cFhfvrhoAKi9gJ9I=;
        b=gq+wW0MTzM+BNR5FeBh6fTSeKRb/JU/fAEwqHmyvoObVnawZy4LonzbZFB6/2n/m3j
         50wN4XWBw91zIyBZAYgVm6P7Gr646TCS7MAgCBtW37BNoCUafSzBRA6oB03W5wLHqNIY
         2/ESLnTI86NpMG2soooASKh50MHr43xVspVVkbr/mO0G+Zcj0jbtnCV9VJOl02qG50nQ
         W7OM7Bsj2AdMqrdyPubDVGg4MUqBEmjyArcB0OONxg1bL47ygff1bTjempsYupDwwnCy
         TIBGVbq5VL9L55QI/0IGT/2JxfmJ63n15FS6RCOnfyv+bA+5ut0NJZ3Lw1a5htPBxBse
         coTA==
X-Gm-Message-State: AOAM531QIP4Eis8JWaeDkMLRl1yzYXdMIIBuJ6phLQb4h2V2zBcUVzkd
        SQgrFUg6Vf2zk1EhZc/GJwVZVfng9qV/Sg==
X-Google-Smtp-Source: ABdhPJwL6gJQYwooDIA5ACcAluWtS3lRvylDyl4i/jDckcrCLkTF19lSmKW8O7UOr6Tq2hs/8uVoEw==
X-Received: by 2002:a92:400a:: with SMTP id n10mr12120388ila.212.1612694383510;
        Sun, 07 Feb 2021 02:39:43 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id r9sm7208942ill.72.2021.02.07.02.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 02:39:42 -0800 (PST)
Date:   Sun, 7 Feb 2021 18:39:36 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 04/57] net: octeontx2: Make sure the buffer is 128
 byte aligned
Message-ID: <20210207103936.GD170970@pek-khao-d2.corp.ad.wrs.com>
References: <20210205140655.982616732@linuxfoundation.org>
 <20210205140656.168305608@linuxfoundation.org>
 <20210207092015.GA32297@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
Content-Disposition: inline
In-Reply-To: <20210207092015.GA32297@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 07, 2021 at 10:20:15AM +0100, Pavel Machek wrote:
> Hi!
>=20
> > commit db2805150a0f27c00ad286a29109397a7723adad upstream.
> >=20
> > The octeontx2 hardware needs the buffer to be 128 byte aligned.
> > But in the current implementation of napi_alloc_frag(), it can't
> > guarantee the return address is 128 byte aligned even the request size
> > is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> > use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
> >=20
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -473,10 +473,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2
> >  	dma_addr_t iova;
> >  	u8 *buf;
> > =20
> > -	buf =3D napi_alloc_frag(pool->rbsize);
> > +	buf =3D napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
> >  	if (unlikely(!buf))
> >  		return -ENOMEM;
> > =20
> > +	buf =3D PTR_ALIGN(buf, OTX2_ALIGN);
>=20
> So we allocate a buffer, then change it, and then pass modified
> pointer to the page_frag_free(buf); in the error path. That... can't
> be right, right?

It doesn't matter. It will work as far as the address we passed to page_fra=
g_free()
is in the range of buf ~ (buf + rbsize).

>=20
> >  	iova =3D dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
> >  				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> >  	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
>=20
> BTW otx2_alloc_rbuf and __otx2_alloc_rbuf should probably return s64,
> as they return negative error code...

It does seem buggy to return dma_addr_t for these two functions, I will coo=
k up
a patch to fix this issue.

Thanks,
Kevin

>=20
> Best regards,
> 							Pavel
>=20
> --=20
> http://www.livejournal.com/~pavelmachek



--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAfw2gACgkQk1jtMN6u
sXGDYQf/Y6Lodxjvr+c0ps/RsUBkxfoJSRHOD/tsQlq6GDCpqyRgpF3rIpqVXtzZ
WWYhqa5AbxtM5sep/tkQLKIO60zFiqMqpY219DaogN4a5K14sBrXEGIF88dBXIJ2
6BYcE/2ICZyZGht3oQ/ExbqQee3g3Z132RGpmmRJlQrarB12hjEFtag4pS39UiD0
ik1tAsRupeI6PhIlcsb3xZE8pfeu/eggdV+VJwIccapQBW/4SaHJnTZ/PIxbXOu6
ZF0kkQz9RY25xee1kwYZmiLNH1/8lQ98pLOyONJWpPQAZE4sT4i6JeMlryyi8JU4
ht0hFU2t+PNrPfNoMt3BveSPts19iA==
=H+c6
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
