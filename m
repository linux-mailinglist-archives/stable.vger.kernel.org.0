Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C03756CAEE
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 19:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiGIRbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 13:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiGIRbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 13:31:50 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F91B3F323
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 10:31:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so4687953pjl.5
        for <stable@vger.kernel.org>; Sat, 09 Jul 2022 10:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20210112.gappssmtp.com; s=20210112;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=KL6cszwQ1n4+pMpxi6qoFjY0IY62/iCUs9yze7dGhDs=;
        b=BpEja3lF/iGXYoVMTY8EzFxOJXNp18kBVgrKTyafVNp/M1uQY6K5BEO7G0h1tL2rg+
         /rA8P8plP9e5GMXiKAe0GZ4bKcIRWkg5phzTsgjKTEaqxkLxvQ/zMA8mT2zRdzJ6kvAE
         XCxIlt5+4g0A+Qncn1UY6s1k7QFZQxBY/szbZmNHhOAhRdERlyFOemzQnWmpjsBDChDn
         YRXBU+YQfH7x/cegNpDmNRulyd+f5amQ5lTGzYSvQafLvmy/y57K2EW/dWXqpiZ6PsvL
         2RzSWkqGmQ1MqUH/83TIgcDwv8CTzzltqE0JnPDBrvZx2PmUVeHgu3BnfiO8aOne1JO9
         0Xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=KL6cszwQ1n4+pMpxi6qoFjY0IY62/iCUs9yze7dGhDs=;
        b=Q4M7vNrat/97DXuBLKD+NuChSbduItj0qV3WlLDISKU4A6ZFeJ6VOiGwU2cRQ3OhSp
         tZRXCkQQvKROgPmgX9lACm1ODwZ6i1m3CNYc/vjrLX+Cfubj3ttHqtX0qTeM099mTLV3
         6RiDeCcXICkyAslW8SKuBDLh25u2bloB3C3oKXCAyGw2Jg+cwiqWGbqzra1CQXX1jnQx
         7J336Hhp2fZ9EzhbfH5EHuUaKqj+hwf6kAxgo9D3K7WwLLYayn4OPaS9Weroqm43naVK
         Zuu4dwB5aHMa0LvuhE2Cv46fg7/CbXpcK7NZqlXJWqHHB+jpAVvVvYVXFff1dy3uPD0J
         Qaog==
X-Gm-Message-State: AJIora9X/7bZvxKiGwuSmokljV+BDSU8ZqtFn0jt8JMwfScKgwukxdg2
        nuay9OQ4lqW4Jvaa04CNR4r+176WBUWdvtem
X-Google-Smtp-Source: AGRyM1vZIXW+GOPJXAd+bva4M+w/tjL8jk5hmkurHrStD0B5vXdMl2f+vUd0qfNzqGRqcM4IZvpd/Q==
X-Received: by 2002:a17:902:bf01:b0:16b:e24e:1d2f with SMTP id bi1-20020a170902bf0100b0016be24e1d2fmr10079869plb.46.1657387907863;
        Sat, 09 Jul 2022 10:31:47 -0700 (PDT)
Received: from cabot.adilger.int (S01061cabc081bf83.cg.shawcable.net. [70.77.221.9])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b0016bfa097927sm1566100pln.249.2022.07.09.10.31.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Jul 2022 10:31:47 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <EEF59072-2BFA-4757-92D7-7A9B6CF134EC@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_A90B0E2B-1702-46BA-A230-75E02BBAFE54";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 1/2] ext4: check if directory block is within i_size
Date:   Sat, 9 Jul 2022 11:31:44 -0600
In-Reply-To: <20220704142721.157985-1-lczerner@redhat.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To:     Lukas Czerner <lczerner@redhat.com>
References: <20220704142721.157985-1-lczerner@redhat.com>
X-Mailer: Apple Mail (2.3273)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Apple-Mail=_A90B0E2B-1702-46BA-A230-75E02BBAFE54
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 4, 2022, at 8:27 AM, Lukas Czerner <lczerner@redhat.com> wrote:
>=20
> Currently ext4 directory handling code implicitly assumes that the
> directory blocks are always within the i_size. In fact ext4_append()
> will attempt to allocate next directory block based solely on i_size =
and
> the i_size is then appropriately increased after a successful
> allocation.
>=20
> However, for this to work it requires i_size to be correct. If, for =
any
> reason, the directory inode i_size is corrupted in a way that the
> directory tree refers to a valid directory block past i_size, we could
> end up corrupting parts of the directory tree structure by overwriting
> already used directory blocks when modifying the directory.
>=20
> Fix it by catching the corruption early in __ext4_read_dirblock().
>=20
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Addresses Red-Hat-Bugzilla: #2070205
> Cc: stable@vger.kernel.org
> ---
> fs/ext4/namei.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index db4ba99d1ceb..cf460aa4f81d 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -110,6 +110,13 @@ static struct buffer_head =
*__ext4_read_dirblock(struct inode *inode,
> 	struct ext4_dir_entry *dirent;
> 	int is_dx_block =3D 0;
>=20
> +	if (block >=3D inode->i_size) {
> +		ext4_error_inode(inode, func, line, block,
> +		       "Attempting to read directory block (%u) that is =
past i_size (%llu)",
> +		       block, inode->i_size);
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}
> +
> 	if (ext4_simulate_fail(inode->i_sb, EXT4_SIM_DIRBLOCK_EIO))
> 		bh =3D ERR_PTR(-EIO);
> 	else
> --
> 2.35.3
>=20


Cheers, Andreas






--Apple-Mail=_A90B0E2B-1702-46BA-A230-75E02BBAFE54
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAmLJu4EACgkQcqXauRfM
H+BPfw/9FT299eRUI735N4gf9Ox11RqcFsE2l/Norm1oi0Gn09FT/MKqtr5wDI80
YunuxWNcw3WDT686PsEWIcxlBaoFYeDQ0vE76bWb5BUHJbUCqOV42uTM+P3DUji8
pMntepS4plKLktMoI1jB0u9+QxM6jy0sKr6r3kPWuyQscCvCCpzvxPsDPuBUThmz
fZlwSmR1Jrc+yhSZWoesg22w+XkQ+Qd0GG3NNLV6tumQYLSkBQoZGiqaFEwJ8Fpv
K3pxi168aoLQDckBRzNTIQJdPC+XvqBUL+JMDnG+hJt3QDWFSP2Nnkt7IYQ5fqpr
3z45Be6Eilo5k3Xnb5tby6khsTNyojuTzceGXRpiATafScTHO1iHHLsZzxAscd2+
6kTZoWbVSaGeLJ8bQIWMUlJQDFVMTq5Q31bnMAzyZpn2SLzE+xxoswkXgG9LvXUI
p4tltNfAzUScHKNK87hWf+8zMZr9QL9MhmZFECM4rFKcdMO3I6uz4yQV5O1W/77d
qi4R+HD2iWz645HFKFLQbGNL4LZf1bBPw1jkqiEmowj2CKOq+gMUUtovxdUbKk+R
73T7BbywYNWWul0KbMuf5pC8zvpLhfjEOfHbdSrKJtsmqMSx2r7NKTGnJ4DfvY2e
VyHTYWRd7BGa9PA4lC22tLl8fBwAzaGC8UK8dZz8sGdV3ksdVac=
=/Ts3
-----END PGP SIGNATURE-----

--Apple-Mail=_A90B0E2B-1702-46BA-A230-75E02BBAFE54--
