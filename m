Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CE65A33E
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 09:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLaIb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 03:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLaIbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 03:31:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4AA2660;
        Sat, 31 Dec 2022 00:31:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id p4so24564498pjk.2;
        Sat, 31 Dec 2022 00:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qyj2rgBFpnRPFUlJLTEsD7ZQxIggwzsrs3Z/jAozoGs=;
        b=YQP0nrh5V+KeSIJ68OIdNF/0SiC4Jmh4QZmhuUwcXtSfQzl0dXBn142QhkQ9r7tdeQ
         yyFY87dvKVIBDnSXHSyLHug55mxB0yDMiRwS+Ol5q5yoU4st2DuN0O7U9GD8gGfF/p5H
         /78N+v6KGSmdeTDnOYY1plBpToQw+EWYPQwBke43LRzUnrrLoApVH30MPkCbKdXTb4Y5
         sYl3gpcpZp/0smVEeAx99G9RYPTV0vrD3vQYMzleyAOKZDFvHjtYO++Ay03EafCtCBwQ
         qjR+qRa8BXI2SFGYO+RAsipP+zqR0/3dHrlxZ79R6km38zjW98NadPzYGUd7RfAViYgP
         qBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qyj2rgBFpnRPFUlJLTEsD7ZQxIggwzsrs3Z/jAozoGs=;
        b=e3/fM6vv/dsBA1SvjFXOA6HQgWdv8R3/JqnKr0Rjhz2U9QXlNuynMX5LtBgf+SjB6I
         nyf8/WfOgdTjZt8x1I5mqp96yozZHThM1n1WP1oYsPHyT+H4S7qVl5XrNNYLhnkrtUbF
         u/ptS/Ya9yweF4rT6diyjQ/kKlgonxeTIg4oY8QZEPjV6pRoWq+yLhj2+nUr1i6JaUQ5
         EDbMsHdmi6D5CmqIJ9kz087aPdEsWUdLe2v0FkbhJG7nPV2GpAgfxV1IkNwBfJafYyVO
         Z0tfCuXl3j8WSgDhf3GVrozuLoPQDJ0L7AqANQbpj5hoS6u2KL5buPgrG0hH1PwcCfDE
         OOkA==
X-Gm-Message-State: AFqh2kojAdFvr1f4jnWFbMQ5FcIAEmJS/iHLCxrWATgExWzvx+FXyW+D
        fN6X+u08loVX5PrHf796dPM=
X-Google-Smtp-Source: AMrXdXtOHN4azErC+YEw2kfd3lU2BAPDkYn89mJl4iSoprjWXvTA3BwXBhJEJTVclwPiKT5amDnAdQ==
X-Received: by 2002:a17:902:d3cc:b0:192:9141:ace5 with SMTP id w12-20020a170902d3cc00b001929141ace5mr14868542plb.13.1672475514218;
        Sat, 31 Dec 2022 00:31:54 -0800 (PST)
Received: from debian.me (subs28-116-206-12-54.three.co.id. [116.206.12.54])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b0017d97d13b18sm16272758pln.65.2022.12.31.00.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 00:31:53 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 6C6151017FB; Sat, 31 Dec 2022 15:31:48 +0700 (WIB)
Date:   Sat, 31 Dec 2022 15:31:48 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
Message-ID: <Y6/zdJ722IxFptkB@debian.me>
References: <20221230094107.317705320@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="djV721w+vT9VwHqn"
Content-Disposition: inline
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--djV721w+vT9VwHqn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 10:49:32AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--djV721w+vT9VwHqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6/zbAAKCRD2uYlJVVFO
o5WaAP4lJgxhIHBXpTKQTc8hbvRoFqWRaniEzbD1cUKdMkwOGAD9FpY4v6iKmJgg
xjrsMCGEigSsg5YF0tDEkBLyEfjhkwQ=
=cKJS
-----END PGP SIGNATURE-----

--djV721w+vT9VwHqn--
