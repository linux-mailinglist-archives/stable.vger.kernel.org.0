Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA896A46FB
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 17:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjB0Q34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 11:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjB0Q34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 11:29:56 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F351E59E0;
        Mon, 27 Feb 2023 08:29:54 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B526D1C0AB2; Mon, 27 Feb 2023 17:29:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1677515393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NQbYegTqpVvOuzrl6CGg+wKGpNEYEfrXdeHiRTSQnuw=;
        b=VHi10S63mdijGoE96HfLZBU4d7S9boaoFJsmJG33iBaQY9HK02aJ7k8S9E0aMUM0Uh63GY
        gaW9K7cwyQzPizUFimeVkMVoSSAy/Shnd++AHToGubKuBdhZxm/XqW5wmRmN3whS4MeBPw
        66DHIglDZFU7mIHQUfOmTZQ96nbgn1A=
Date:   Mon, 27 Feb 2023 17:29:53 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, jack@suse.com
Subject: Re: [PATCH AUTOSEL 4.19 1/3] udf: Define EFSCORRUPTED error code
Message-ID: <Y/zagTBm650KPnur@duo.ucw.cz>
References: <20230226034424.776084-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="It2fVVJVqdj8I/iS"
Content-Disposition: inline
In-Reply-To: <20230226034424.776084-1-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--It2fVVJVqdj8I/iS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jan Kara <jack@suse.cz>
>=20
> [ Upstream commit 3d2d7e61553dbcc8ba45201d8ae4f383742c8202 ]
>=20
> Similarly to other filesystems define EFSCORRUPTED error code for
> reporting internal filesystem corruption.

Does not fix a bug, AFAICT, and should not be in stable.

If we need it in future, this should go in as a dependency.

Best regards,
								Pavel
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -57,6 +57,8 @@
>  #define MF_DUPLICATE_MD		0x01
>  #define MF_MIRROR_FE_LOADED	0x02
> =20
> +#define EFSCORRUPTED EUCLEAN
> +
>  struct udf_meta_data {
>  	__u32	s_meta_file_loc;
>  	__u32	s_mirror_file_loc;

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--It2fVVJVqdj8I/iS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY/zagQAKCRAw5/Bqldv6
8mKLAJ0b03f5tSZwWw7dqeyqaXu376G4/wCfYMOlaYDZBUWEl2WUgCkVZcgn5/E=
=4piR
-----END PGP SIGNATURE-----

--It2fVVJVqdj8I/iS--
