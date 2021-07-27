Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7385C3D7120
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 10:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhG0IXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 04:23:45 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33638 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbhG0IXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 04:23:42 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A83B21C0B76; Tue, 27 Jul 2021 10:22:39 +0200 (CEST)
Date:   Tue, 27 Jul 2021 10:22:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Lobakin <alobakin@pm.me>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 029/167] net: do not reuse skbuff allocated from
 skbuff_fclone_cache in the skb cache
Message-ID: <20210727082238.GA10177@amd>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153840.350300456@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20210726153840.350300456@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 28b34f01a73435a754956ebae826e728c03ffa38 ]

Mainline is significantly different here. Patch makes no sense in
5.10, as both branches of if are same.

Best regards,
								Pavel

> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6100,6 +6100,8 @@ static gro_result_t napi_skb_finish(struct napi_str=
uct *napi,
>  	case GRO_MERGED_FREE:
>  		if (NAPI_GRO_CB(skb)->free =3D=3D NAPI_GRO_FREE_STOLEN_HEAD)
>  			napi_skb_free_stolen_head(skb);
> +		else if (skb->fclone !=3D SKB_FCLONE_UNAVAILABLE)
> +			__kfree_skb(skb);
>  		else
>  			__kfree_skb(skb);
>  		break;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmD/wk4ACgkQMOfwapXb+vKHeQCgn8SEVAaKKz+YvbuQGLKERu6V
+4MAoKWPV/nsE2p1C0dHZ9MN8HFUhj8n
=sUvV
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
