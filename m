Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9327F2A3604
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 22:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKBVdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 16:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgKBVdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 16:33:03 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59983C0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 13:33:02 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w4so1673047pgg.13
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 13:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=GDcKw+qqVKSI21MY7F3hRGjD3Q4OuR+vQvg5noEYSh8=;
        b=jhGcwOg47+zV7o8xt4hQ6Huidr9VOglsti6uNMpzIa85RgOEC1Hp4n2H1k2/V7v2F0
         KtAsZ5m0B49jO5Dex8h6aed5meJNcGjhHcmYMYcnoYx9I5uOiQ4qIgjqZsFDON3IZA85
         nWkG6FHddOJqHnpsRlEq/qKQlKSraG3+D0aCakwW5E3eGaJIliNWJ30SzouU9RICWsq/
         AJM2KNvRHf3xQA2koS/36NS8loaZr9ePuEf+ZY93+oINmdY4mwUwQvKpJB5xTIUTaNrJ
         SWYngp52k5yVHao/BmvXyRDvrM8S0E+NFlWFehhlemDIL+i6hdqRpnB8Juojbn8t7BQc
         mceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=GDcKw+qqVKSI21MY7F3hRGjD3Q4OuR+vQvg5noEYSh8=;
        b=huTSkON1vNIEZHDPy8hXvF+SjBeiVp1iKCQxvVjA0X842nLqE1CoYVSDwtPOE108lo
         JhZnPvdq0karB/jbkj/axfGeFMxqQXNJr47w2QrxtfznEDNwJscvigI7PXpcq7Cj9nc7
         3RHfuHAHr1gp88NhurvuL6wCjZnuc7sO8yeRIlKk4XJ1KstzgivWEbnWNR8GyNCif3M1
         mbYj9mko05Sr72maxktimr/6SfbTi1ED6tz5fdfaVDGlf1/bcS0/srL7gri3kboegP/D
         JQZePFCAtWvwvCsqnmVsVGCn8qwV7wuqlvU6L0OweJ8mV5WdFEfcQnM1eg/NTyLjGVqy
         zhvQ==
X-Gm-Message-State: AOAM5303/VR+D+eIh7j+8XEfuPaIvoK8q4m33vkqs3gC7K6BY1fbOPcV
        sQHvvmCLti/d2EJNA2x+/nzVbjE30c+4KLrj
X-Google-Smtp-Source: ABdhPJzJG6NvztWZ/pLxxAdKe+eSw0RfaB/LnZLYy9xMQn1Kc9i6wazzrg3SUU/6Ea/h6dTA1cVvsw==
X-Received: by 2002:a62:dd16:0:b029:18a:b228:649 with SMTP id w22-20020a62dd160000b029018ab2280649mr11657996pff.33.1604352781928;
        Mon, 02 Nov 2020 13:33:01 -0800 (PST)
Received: from [192.168.10.160] (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id jy19sm446275pjb.9.2020.11.02.13.33.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Nov 2020 13:33:01 -0800 (PST)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <97FAFCC7-C12E-408A-A53C-8914C0472046@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D12A7FF8-F7AD-4798-8693-73699021FF96";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 2/2] quota: Sanity-check quota file headers on load
Date:   Mon, 2 Nov 2020 14:32:59 -0700
In-Reply-To: <20201102172733.23444-3-jack@suse.cz>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
To:     Jan Kara <jack@suse.cz>
References: <20201102172733.23444-1-jack@suse.cz>
 <20201102172733.23444-3-jack@suse.cz>
X-Mailer: Apple Mail (2.3273)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_D12A7FF8-F7AD-4798-8693-73699021FF96
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 2, 2020, at 10:27 AM, Jan Kara <jack@suse.cz> wrote:
>=20
> Perform basic sanity checks of quota headers to avoid kernel crashes =
on
> corrupted quota files.
>=20
> CC: stable@vger.kernel.org
> Reported-by: syzbot+f816042a7ae2225f25ba@syzkaller.appspotmail.com
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks reasonable.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/quota/quota_v2.c | 19 +++++++++++++++++++
> 1 file changed, 19 insertions(+)
>=20
> diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
> index e69a2bfdd81c..c21106557a37 100644
> --- a/fs/quota/quota_v2.c
> +++ b/fs/quota/quota_v2.c
> @@ -157,6 +157,25 @@ static int v2_read_file_info(struct super_block =
*sb, int type)
> 		qinfo->dqi_entry_size =3D sizeof(struct =
v2r1_disk_dqblk);
> 		qinfo->dqi_ops =3D &v2r1_qtree_ops;
> 	}
> +	ret =3D -EUCLEAN;
> +	/* Some sanity checks of the read headers... */
> +	if ((loff_t)qinfo->dqi_blocks << qinfo->dqi_blocksize_bits >
> +	    i_size_read(sb_dqopt(sb)->files[type])) {
> +		quota_error(sb, "Number of blocks too big for quota file =
size (%llu > %llu).",
> +		    (loff_t)qinfo->dqi_blocks << =
qinfo->dqi_blocksize_bits,
> +		    i_size_read(sb_dqopt(sb)->files[type]));
> +		goto out;
> +	}
> +	if (qinfo->dqi_free_blk >=3D qinfo->dqi_blocks) {
> +		quota_error(sb, "Free block number too big (%u >=3D =
%u).",
> +			    qinfo->dqi_free_blk, qinfo->dqi_blocks);
> +		goto out;
> +	}
> +	if (qinfo->dqi_free_entry >=3D qinfo->dqi_blocks) {
> +		quota_error(sb, "Block with free entry too big (%u >=3D =
%u).",
> +			    qinfo->dqi_free_entry, qinfo->dqi_blocks);
> +		goto out;
> +	}
> 	ret =3D 0;
> out:
> 	up_read(&dqopt->dqio_sem);
> --
> 2.16.4
>=20


Cheers, Andreas






--Apple-Mail=_D12A7FF8-F7AD-4798-8693-73699021FF96
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl+gewsACgkQcqXauRfM
H+ALTg/9GWmMTMkOn/bz014uzOxCaToWVNMRzlcath0V9HftVKT2aY50SVXW/+Gg
gvTVIGrpVEk/wbyels5zOpymMKNuoVUP9TEUdwobPLkoaskjU4Q/5xXcGKahB/4d
DBZhSWxXOWF806NNU3aLOPEn8o/GpatB13RKzd10iI7ImI9ijWOR7Mg3EO/7vjQm
yyeoTXlXSVdqOHbwjudmlhUZDgjS7Q/G55sSt3/Xu5fAcHvIAX6C3yGFlbTMDzSI
pZ8tUxLiCpJCulhWDUKeh8d7NU3c7I9RPPEXT6XuhNMN3yfpawlcof7AQNFr7kxk
JsfiXvaQ8Sobezq2EfRvtWEJoT10QU0+/OqXQE/ZxAvzpLih3IpwLm+H7/KR2wDr
WadeCKqP+rv1/CJ3KRcv6dyHoS5g5f78MuTmaY7+e6EaFi8Px+2Xdi1HndHYMnO3
gbt7kqmH8o60PcogIiCWGRmieMAakZs+Ah87J/YCK2K1hBkGqBaTlfMBWLKvxL/6
5UuB7cGn3ocODRLxWqsovodVv/7a5wr+N3dXaid9qhFWWK0AMltIXW4MmIntkrdZ
7oVKMK7oh4S5/NnbkrY2y4W0dUskRCUk9ilZVYRjHEzWuL9tVTDrL9kkm8P4UMNz
79C6o6v31XIXGA+Ki7jDZgWL/WSzurLHfVtYYFTHEtbzkhmbBOc=
=pChP
-----END PGP SIGNATURE-----

--Apple-Mail=_D12A7FF8-F7AD-4798-8693-73699021FF96--
