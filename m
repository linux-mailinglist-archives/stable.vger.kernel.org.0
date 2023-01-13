Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45F5668AC8
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 05:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235058AbjAMEUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 23:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjAMET6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 23:19:58 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B3B6535E;
        Thu, 12 Jan 2023 20:15:25 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso25833133pjt.0;
        Thu, 12 Jan 2023 20:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=owGrdmD6M5GkWkPONhYAnjTsh6hbHgml7pZ6gSujKuw=;
        b=EE/ouegsY6Ipuhx5f8V5bwezV4hjMFmr2EvwSqRrP79fiFqTnxPYmzKBpPu8s+1Ll8
         lW0pcs833q5DjLgyoWDRuXhfi6ZSRuZKi8kZfIlqUSSoMSqmIft4mW6ygrKCm69iSwXL
         PCUj81A+jXvKlxkOikMbvc8Ynq6EHHEmoy2MTaxMUoX+axArK402EZRKvs49WKPR62Hp
         h7ZHk62lF/U4UZZ77c0BZKfNymRF8tN88H7vqP9hfWCSKwW0GzwIBQLum9C9Weh7hT3X
         EGXe2qg6XZ+b6DFuprWdVKTGXWQgm3sGYSgsrpASKc8EJVYw0hUOumNFVAnrTKX5lpde
         QvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owGrdmD6M5GkWkPONhYAnjTsh6hbHgml7pZ6gSujKuw=;
        b=2QerWavxZC9H/XLfFuuUOcY+PmsrNDoU+YTz1YM8TmPQ5KtX1oUIH7Pd7DKkswq2ny
         F+noCQy1ubec281cA+gBPXuMBYRJEIpxLvRXIXYH9ttu4RmoMV5ziIlam8BYv4636a0K
         uoWg/u3n+LydbpscumDt7Gjau4WxJ1xHxQB9sUWYiIEViaOve18/HlkiJuBgQd+FvIzn
         xS0n81AZCPk8Xu5mpOOpHZ6LucRXaDizNZJS4aQPYMYP1vjqYkY5bNKsUDuh08yZk3c+
         IwJokSIUTSUR2GSA/w0ufQtsQDP7SgK6mTSIkDo39Z62UzezhWGZwICT7exsZozWV3YC
         nTtw==
X-Gm-Message-State: AFqh2koQs0wb54ZvQICz+PwHbEV/Ch/6HaiQgnjoF2Q4qx4VhuI9ERTx
        bJH4L7zpAQREy+sbRDhF+Pk=
X-Google-Smtp-Source: AMrXdXs2lDdkOntcs6E+HrRmEt8fujkeEJ2OP1c6TmntKOMz1NsdpbYm/P55TzkysVtlxQE1iAdBRg==
X-Received: by 2002:a17:902:8b88:b0:192:b2d3:4fc8 with SMTP id ay8-20020a1709028b8800b00192b2d34fc8mr9136045plb.1.1673583324917;
        Thu, 12 Jan 2023 20:15:24 -0800 (PST)
Received: from debian.me (subs03-180-214-233-19.three.co.id. [180.214.233.19])
        by smtp.gmail.com with ESMTPSA id cp12-20020a170902e78c00b0019276616eb0sm13024781plb.83.2023.01.12.20.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 20:15:24 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 221E7104A90; Fri, 13 Jan 2023 11:15:21 +0700 (WIB)
Date:   Fri, 13 Jan 2023 11:15:20 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/10] 5.15.88-rc1 review
Message-ID: <Y8Da2By1yzk/5rs9@debian.me>
References: <20230112135326.689857506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v+IuJdQt9LwIUu9M"
Content-Disposition: inline
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v+IuJdQt9LwIUu9M
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 02:56:37PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.88 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--v+IuJdQt9LwIUu9M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8Da0QAKCRD2uYlJVVFO
o1XqAP9ODDgyzKJbSBYvnY3h+M8uXFioTwKcYYOWrKQJNo1zywD8DzaL64rLDIMS
tYr5sI/wIdokXkcn6F2ci46+02TKbgE=
=5AkB
-----END PGP SIGNATURE-----

--v+IuJdQt9LwIUu9M--
