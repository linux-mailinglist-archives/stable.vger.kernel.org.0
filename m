Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC70F671243
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 04:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjARD4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 22:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjARD4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 22:56:15 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9340953F91;
        Tue, 17 Jan 2023 19:56:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id k18so11598989pll.5;
        Tue, 17 Jan 2023 19:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TLRE2TXuEi0Oi6Py0U1FjTjvdMX6n7zTvdehmRccvQA=;
        b=p+9eUJUJfVS8n33t98G13ynpg+3YLMTqLbo8XZ3+W5aAq0J7WETPVlEbn41TzJcKYn
         kniSfXDzU8fj1Liw9pei1Ql4kWXqPx3BTNENPHUFKwpQ3jymgSqPRG7DaMVu1Cu80FAI
         rVi+ICZpl8NBtsUfoJYIgJI+ulrLmSobPBeF9kDLkkukzqhakrRHmCQhJilpvLDSXuTj
         FAEpKoFREtobxnFQ2uS52hp1HVFlF2CwnggdK3r5ptQNGBz2PiDqeWzbIYE6jh179mlv
         jD38/RK0naUD6lAvAtFNznD1k3Vk648Wi4Si1yirSmUizPOyEKot+GZ8dM6LjLJ8r4qJ
         xeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLRE2TXuEi0Oi6Py0U1FjTjvdMX6n7zTvdehmRccvQA=;
        b=ET5tgWVQEv4zrOvxXfTibZKYGui5FbaMvaiOMtWPZxPFVlChVtAJK8Ya2IsflSsmLe
         sHjYb8jP5uKvWzekpcBLixvoHxGAKnfuXbO2pCE/y6ZgaDfJYIUFfXtXsnfYaL7Ld4/t
         7xeZMK3aU5RV1+6EwDlZG6LhKHEMrQ1z0ubLQ3kxERXS+5R2tx1H772KI7HboqwgWrMK
         3k5f7VxnKlLjaSY2fvYt9ypBsuuArArv8TmkY9kHDhtvEiUBOpY++rKDS6F9VC9TvexH
         ZLOU8BMd7Mr4xaLoxrdGLoEkxZcg/OIVKB/MEGKVqTa6PUqE3Ku7YMWBToJyTx8TbHkQ
         ntmw==
X-Gm-Message-State: AFqh2kopVx9IibdxJpO1aJNnAT0FXCmbPk0N/S5NXAXiufFyAxtGKe4Q
        yghAzw9E/eRSufVOtMLSMm0=
X-Google-Smtp-Source: AMrXdXvBacoD8XHw7bIj3fRtq94ID9PrZm6RO3ZxWkoHc0UM+D1Lv3h0fEeeOeks7HpvCHDMnbHePQ==
X-Received: by 2002:a17:903:557:b0:194:55df:4fe with SMTP id jo23-20020a170903055700b0019455df04femr5883472plb.35.1674014174002;
        Tue, 17 Jan 2023 19:56:14 -0800 (PST)
Received: from debian.me (subs02-180-214-232-66.three.co.id. [180.214.232.66])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm17288666plw.296.2023.01.17.19.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 19:56:13 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 1B48C1016F2; Wed, 18 Jan 2023 10:56:09 +0700 (WIB)
Date:   Wed, 18 Jan 2023 10:56:09 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <Y8dt2efGEPS/JRaP@debian.me>
References: <20230117124546.116438951@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VVLD0i51IZ9bwB+F"
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VVLD0i51IZ9bwB+F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--VVLD0i51IZ9bwB+F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8dt1QAKCRD2uYlJVVFO
o/pYAQCe/RTsz0cS/7QTCzrQqZGbAyAyUSM9I6LaRF19nnvA7AEAmN4tnT/8CkEW
EONq41/MFhUNCcOI3diqIIPDvzHkwwQ=
=7Yo2
-----END PGP SIGNATURE-----

--VVLD0i51IZ9bwB+F--
