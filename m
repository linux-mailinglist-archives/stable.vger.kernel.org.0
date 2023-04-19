Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A126E723D
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 06:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDSEX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 00:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDSEXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 00:23:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B9A1705;
        Tue, 18 Apr 2023 21:23:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b14so388718pll.10;
        Tue, 18 Apr 2023 21:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681878232; x=1684470232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/PeCUCoOm5EhpEKpIU7t6XGEzaaPVIfEbFGJ8Ltf0/g=;
        b=jGrreaywInXNQSQYd9Zh+ZtQZFmQDZY9Vj9jRE59f5jpWbUmi9GEPjZUfKjLUALbha
         yTcQKl60yBquQpx4vWNPrvI5IaQ7Tt710qSJu0ShsB9eDVb9MzEXsFpf8J9FsEXOXQk9
         xihZmIGP9uhV6mZiSHg82ucM2AcHHU83uA93TDMlKqtuaetg+QByxt4A9IUDKe2kFXvl
         TCSBa9iTEaYfOjpmmpiVxgw9NhOdGP5xsksxPe2ACcmhG6Eh0ROejElwY0ZCl0sfyVJT
         nFSnZ/bmQSiWT1XGESTrLWNK6/77MMBjvrRQzjxwctlBg/ouUH6bkpB0jkN/fHB9+WeZ
         qSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681878232; x=1684470232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PeCUCoOm5EhpEKpIU7t6XGEzaaPVIfEbFGJ8Ltf0/g=;
        b=QS/kEryvZONJPpO1UEV3mTMpRhwU24Gr4BW9HUauvsGnjCpDaAjuPeVwwV3D2Al/xQ
         7V28g4SAG2bwcfWGC4A+jIgFX9q3MbGUJLwMwyiy99wUl1sjmTKObjUEgGkSNT7BRNnW
         TeooyoZHtFp2LbgkX8I1Vd8pz4W+mVoVjoAgHIvG8X7N0JUzHtJDounjYBFAKn+mpabG
         5gXZh5jR+ANye7lRL6jsn515a6XZikvAAQtvSQeDB0tjmo082R8a3skC9Yhtvqoqj6TH
         0euoBuOy5LzpxRABwlgpEpz+0XqL3NI0cu0nO3QUNhBzhSr1JxjDoqI0Ek4nsvn6B48u
         WD/A==
X-Gm-Message-State: AAQBX9ecSytS9AkJdkIJJlGk+dqV5l9D2NWnFqjhNfmpd2qmIHb86W3f
        3DWzaF858hhpdE0ZtMqwyaQ=
X-Google-Smtp-Source: AKy350Y9AoiopbDgdbaP0ocGGffqIsx9hYk3F9jc6N0Rc+cBsrSb1ZUOXFJfhTMMDISKMGcPH29q8g==
X-Received: by 2002:a05:6a20:5496:b0:ef:bd:3b with SMTP id i22-20020a056a20549600b000ef00bd003bmr1844212pzk.55.1681878232316;
        Tue, 18 Apr 2023 21:23:52 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id i7-20020aa78d87000000b0063d336629e5sm2551262pfr.59.2023.04.18.21.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:23:51 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id EAA53106692; Wed, 19 Apr 2023 11:23:48 +0700 (WIB)
Date:   Wed, 19 Apr 2023 11:23:48 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <ZD9s1Ms7OXVQZb8b@debian.me>
References: <20230418120305.520719816@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oJkdrppsHe4zHKKj"
Content-Disposition: inline
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oJkdrppsHe4zHKKj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:21:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

I have also encountered the same build error as Naresh has reported [1]
when cross-compiling for arm64 (bcm2711_defconfig, GCC 10.2.0).
powerpc (ps3_defconfig, GCC 12.2.0) build isn't affected.

Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>

[1]: https://lore.kernel.org/lkml/CA+G9fYs9sHnfhn4hSFP=3DAmOfgj-zvoK9vmBejR=
vzKPj4uXx+VA@mail.gmail.com/=20

--=20
An old man doll... just what I always wanted! - Clara

--oJkdrppsHe4zHKKj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9s1AAKCRD2uYlJVVFO
o4CEAP9cusbW3XkvfeuE7trwAgRGlAImwmbvNRT/oJEts65tRAEA7rVUc0VrzUVI
aHfUF95MUgi7i2B00d9aziLN7e6WbAI=
=fEN9
-----END PGP SIGNATURE-----

--oJkdrppsHe4zHKKj--
