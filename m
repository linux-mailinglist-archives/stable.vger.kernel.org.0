Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D0F2BB96E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 23:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgKTWvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 17:51:17 -0500
Received: from mout.gmx.net ([212.227.17.21]:35727 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgKTWvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 17:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605912673;
        bh=eH/vd85SNsgQW1o87tHH3hAggLjXnB+QPH/fkkZBhGI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=VSjVcTqNnHl3xpXYz0FtEjT/EnOYvts6lyGMtBJMSVvPl9wKcSmQKWr1zrZWckUvF
         hbNMTOeL/QRgN1xlK76UNndvSQBaKcMyedlz2GVNZWVPn4NlsVhFUmJmpi5P+jJd2V
         7uY82on2DLCJsgdSVZs64+saGxKq4DeitJ5E+4eI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MmULx-1jyhDV30a1-00iW8Z; Fri, 20
 Nov 2020 23:51:13 +0100
Subject: Re: [PATCH] btrfs: tree-checker: add missing returns after data_ref
 alignment checks
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20201120155558.29684-1-dsterba@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAU4EEwEIADgCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1oQAKCRDC
 PZHzoSX+qCY6CACd+mWu3okGwRKXju6bou+7VkqCaHTdyXwWFTsr+/0ly5nUdDtT3yEVggPJ
 3VP70wjlrxUjNjFb6iIvGYxiPOrop1NGwGYvQktgRhaIhALG6rPoSSAhGNjwGVRw0km0PlIN
 D29BTj/lYEk+jVM1YL0QLgAE1AI3krihg/lp/fQT53wLhR8YZIF8ETXbClQG1vJ0cllPuEEv
 efKxRyiTSjB+PsozSvYWhXsPeJ+KKjFen7ebE5reQTPFzSHctCdPnoR/4jSPlnTlnEvLeqcD
 ZTuKfQe1gWrPeevQzgCtgBF/WjIOeJs41klnYzC3DymuQlmFubss0jShLOW8eSOOWhLRuQEN
 BFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcgaCbPEwhLj
 1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj/IrRUUka
 68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fNGSsRb+pK
 EKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0q1eW4Jrv
 0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEvABEBAAGJ
 ATwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCXZw1rgUJCWpOfwAKCRDCPZHz
 oSX+qFcEB/95cs8cM1OQdE/GgOfCGxwgckMeWyzOR7bkAWW0lDVp2hpgJuxBW/gyfmtBnUai
 fnggx3EE3ev8HTysZU9q0h+TJwwJKGv6sUc8qcTGFDtavnnl+r6xDUY7A6GvXEsSoCEEynby
 72byGeSovfq/4AWGNPBG1L61Exl+gbqfvbECP3ziXnob009+z9I4qXodHSYINfAkZkA523JG
 ap12LndJeLk3gfWNZfXEWyGnuciRGbqESkhIRav8ootsCIops/SqXm0/k+Kcl4gGUO/iD/T5
 oagaDh0QtOd8RWSMwLxwn8uIhpH84Q4X1LadJ5NCgGa6xPP5qqRuiC+9gZqbq4Nj
Message-ID: <2575a8c4-7898-1d72-191a-832c59629fbb@gmx.com>
Date:   Sat, 21 Nov 2020 06:51:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201120155558.29684-1-dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XsxSs3whPKWw2smBDWeoSOCv04s0eU2Az"
X-Provags-ID: V03:K1:v9r5RX8LCaJwDVYThpLXb83/MaVKOV6NL04AxVCuKM3nJhEHG+3
 kTUvr4uPgDuYNkpCm8ZdMKA/h8PJsOmCKd2i2ouC+FCAUKH+6oJziOXKk9p9DDXGTvtM6AW
 cBsBKl6+0d7mlNiCJxOIh1nIP+pVypFbCzs/w71RkJBPfUC0xpMzrsZ2/N+Oum00snjc+pK
 SO0KrMTItV4x0dFn6bDwQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cGpxLTZjJ2k=:isOL0vlxhBiwe0htER7BOd
 ZIpvFdSITMc2C2KtNhKslm80uVV6sr2/snzI76jKQEonBhQcsbVoDyziy6+txVKaGrbumCje/
 fPqm7IpMT6TtLvcDhThgetikYS8VB1an2hTYE07Hhab4MZVsaKE72StmX6tXpg3HhFcDNokoP
 MyUMxww9IU1/MJejk0OYqXy9iBHJ+g0iVMnFST/Yf2eYTYyskB+6k+4Dt6noCj78Q0+z9cJcS
 do3fWOIwjqubeucNFB9RpB4RMUUvQI/cfDLfFJ5ilotdAUUxbCOoMVbR+DMkLxpcpvSPZfwhl
 RhKOfYiTLpJRJs1KT8cZjAntpCi9fqEyVkv3rE8NKl5rIADVMcgtPfb+oSU4dMx+eQzSR51kS
 d8XrNawI6xbJ/ltstPISOU0A0H0OwRuBhnYQ2PEhW+W1bip4a0hL54g2RDgU1GG08RK9OS4bK
 mwrk6pOQPm/JEYakgrK/7HaLhoyn6vSjje4xtTWTwas7gnk2h5qHdGZOQiWQY30s1MBIFBgi9
 CYJTyV6YKttlJmmF6hlZjE44TD8HSFcdrQLoCnpNaiW8be2zlNEJbNYFaBbcz9KjHwX70R4ft
 U1KjLIbXMGKtQUG+kMi/UnzaaWviC+LzZAu2iYtHDzXkfr+xPfQSzMiXJqoeCga0WkRD+z2Xl
 rKVgEyO4t7hy/KsRpH3wL8jIeobdhLelNipn0RgkmfUZj0IKMiEaEGhXluvfbVSqeddiGB8MC
 JX/pnVg7PoDTXEZsC/p7L831GOssbLo0qAHaoNeYq0FT17q1MkuH4M+5jP4PmLJXziSRmIH/L
 cjyT9XKXMv3qGDjr7Jk2jjRRXZP3Zywowz66H67Vyb4g0McrP5yRk9UXZbb7bUQbmpec7Ebwx
 Hszf9vyuhYcCQqorRGwA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XsxSs3whPKWw2smBDWeoSOCv04s0eU2Az
Content-Type: multipart/mixed; boundary="UmpehlsP4fL6JK1lPMj8apBMLvs77lqZ8"

--UmpehlsP4fL6JK1lPMj8apBMLvs77lqZ8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2020/11/20 =E4=B8=8B=E5=8D=8811:55, David Sterba wrote:
> There are sectorsize alignment checks that are reported but then
> check_extent_data_ref continues. This was not intended, wrong alignment=

> is not a minor problem and we should return with error.
>=20
> CC: stable@vger.kernel.org # 5.4+
> Fixes: 0785a9aacf9d ("btrfs: tree-checker: Add EXTENT_DATA_REF check")
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>  fs/btrfs/tree-checker.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 1b27242a9c0b..f3f666b343ef 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1424,6 +1424,7 @@ static int check_extent_data_ref(struct extent_bu=
ffer *leaf,
>  	"invalid item size, have %u expect aligned to %zu for key type %u",
>  			    btrfs_item_size_nr(leaf, slot),
>  			    sizeof(*dref), key->type);
> +		return -EUCLEAN;
>  	}
>  	if (!IS_ALIGNED(key->objectid, leaf->fs_info->sectorsize)) {
>  		generic_err(leaf, slot,
> @@ -1452,6 +1453,7 @@ static int check_extent_data_ref(struct extent_bu=
ffer *leaf,
>  			extent_err(leaf, slot,
>  	"invalid extent data backref offset, have %llu expect aligned to %u",=

>  				   offset, leaf->fs_info->sectorsize);
> +			return -EUCLEAN;
>  		}
>  	}
>  	return 0;
>=20


--UmpehlsP4fL6JK1lPMj8apBMLvs77lqZ8--

--XsxSs3whPKWw2smBDWeoSOCv04s0eU2Az
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl+4SF0ACgkQwj2R86El
/qiUyAf9G5Uf8BfodoYBxSMyF58y6EzaVebpIcc2xjpbkmG4ys2TQ8Xy3fHD0tMx
/zkx4WWeALpc+24g/qYQdeaPquhj5gxobUjRdzPIMWoCPY120mfhszO+WEZlAPr6
ESGuwiy3/2zNQHrq4ed48edF21NdECPAF8ikjlK89pdLGITfFOJ8fhyvQ+WESSBN
QEAtuevCER46ml8O7KEOG0ultaAFBUm7MJLh54IxuUNltdRPNyeeG1o7KbjXQwai
bLDQ69rAk0rX7X1ZSyTRDkeeGysqy+XCB9FHO7ss/E622RpHanZ73PwvlYY5uQzF
HJDwd9G1oBsrw4N1PRIXh0PeYv2EwQ==
=Uu+I
-----END PGP SIGNATURE-----

--XsxSs3whPKWw2smBDWeoSOCv04s0eU2Az--
