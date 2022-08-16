Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE2359599F
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 13:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiHPLOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 07:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbiHPLOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 07:14:21 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75919DAEEE;
        Tue, 16 Aug 2022 02:41:09 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d20so8879964pfq.5;
        Tue, 16 Aug 2022 02:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XAji5dFlNQFQWahbNRREQHmDQtikwT9DRIeLUoCkeLs=;
        b=Ij2QFrQXg03xhTVvtVxG+eQWkM12omRmP/YNZ42GdnxUnaoluyCVbQEV/hWLxrEspU
         g7AtQ+yeAdXBcx/ywtIJcLNfDz57pQVfa7Kxdf+9zENuCZkB/hNAlNl8FtzZUooryagI
         3vjhu26Vh9/b4J7JmUL9nS5DvXAvOaeIBeLQLIxEj72rN12zRY9i0szK1Ju4vn9XN1c2
         0027+K51g8LEn0lq37E0CpEUdQApuHRbqLMamtJwQN93254DAoBD7b0mRZ3fzxkETOaa
         XRFvn2j3veQa/6f9lGCTwgTARFX3xzODJrezHeP7ooC2iVQhTTHBEkPVpt4Bot38rzjJ
         TJ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XAji5dFlNQFQWahbNRREQHmDQtikwT9DRIeLUoCkeLs=;
        b=TmY0I7hVgTAG0hGLOhVXxTLFYo/0KDFvU19AiqHtc9ZNF2kb9F1Tr5LPIayu+LAt7D
         iiNn8fELUsW2CAY0E03FNRkYqzHI57wmRA7wD3lVNv2uyOSGPNmVTrhSi/vtSjBP43ch
         krbONDqQo7rhNHsFrYUodxdIydfETI1AiGha99cH2U4+xA0Nee7WkSRcNID6nFjTne8/
         HTlNuvuYq31gjdMeE5Jb/g5M1D0EGlKke30e2MQ/PozaYpesTKhMBAaWk7R9zFYzkjoq
         QDfhSmGamUKU8GB3lJHKlJ+8/zsqHNkV0IGNDtg2vfS59skgQhDk9smYOP7Y4a+iZc9O
         QY0Q==
X-Gm-Message-State: ACgBeo0VvnJmeqvfnKfF4bm8QeSwPp1vcMEuJeO5x36z6qe7uMa4yCHq
        EE2dBgGvG8M3BHQOl0pjaXk=
X-Google-Smtp-Source: AA6agR5RAbPBjQacdQ87QX377mESsYQw2wttKhNQwDh4PgHFtB5OEK4cRlSE2Qz9AtEDdLafnH5KMA==
X-Received: by 2002:aa7:8890:0:b0:52e:de90:7338 with SMTP id z16-20020aa78890000000b0052ede907338mr20392883pfe.46.1660642868951;
        Tue, 16 Aug 2022 02:41:08 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-27.three.co.id. [180.214.233.27])
        by smtp.gmail.com with ESMTPSA id t9-20020a17090a0d0900b001f559e00473sm5845428pja.43.2022.08.16.02.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 02:41:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id F366C103124; Tue, 16 Aug 2022 16:41:04 +0700 (WIB)
Date:   Tue, 16 Aug 2022 16:41:04 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
Message-ID: <YvtmMDIf0Gjo+NjS@debian.me>
References: <20220815180439.416659447@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0AkYoTkr7vUl7vTi"
Content-Disposition: inline
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0AkYoTkr7vUl7vTi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2022 at 07:49:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.2 release.
> There are 1157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--0AkYoTkr7vUl7vTi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYvtmKAAKCRD2uYlJVVFO
o1KSAQCZMdxc9MkhaWeeD3fJRLkx3JQsA9oz+2c31cQEv11oEAD/ZzFy0Sftzshy
eqhf9+MvBHX/6X8DZkwWxGLpJN1HWgA=
=7n1x
-----END PGP SIGNATURE-----

--0AkYoTkr7vUl7vTi--
