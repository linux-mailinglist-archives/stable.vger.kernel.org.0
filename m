Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891BF6C2943
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 05:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCUEru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 00:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCUErt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 00:47:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51C03019C;
        Mon, 20 Mar 2023 21:47:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so15026249pjp.1;
        Mon, 20 Mar 2023 21:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679374068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+dVj1VzSpbPR2RhwHc8ratBECYHH5UrJY+Fvl7aEWQQ=;
        b=q0zV4KNGMHEREJ/mkfh10VTg0eHVBCosCklEK67UqPRjIUzQ96UVxvxzfsXA7zfxb8
         cgcTl1hxOsOWUWz1FcEYpSeFTng4RTf1F6UdrfMOF8ToyBuNAhl4icjOMvDXOCSB3gCT
         XOfvkGdlisekMf3OfwQCuV7nHYR+azUByiz3V12Q6lfNsOmSKVeUVHh8yIWUq3G3Ev9a
         e7ETEOpFzmNco6HpEtOMDUt5RcJMkoq63aQY/WDbEZuJ2eglEw46Cr6B6ahjaugojU36
         O3nf1owlvqKRyRhhb8YmiSkIQC00ArAszcgANbV8W1IzepCLH5NuE8OuIK/kXZho6r32
         xnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679374068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+dVj1VzSpbPR2RhwHc8ratBECYHH5UrJY+Fvl7aEWQQ=;
        b=dLvs3ToopPaIi6k+BPK5Ks/CAibfPWmXJnvVY/xTiaXYrnVBwNMOrRWw+ReRdkqq+Q
         X/wR1OlTD2p/PB3jt89z40gEiLsd4lXXLvrdwYYsnPJeb2JP5MEKKBQQfkR3f/vqySoM
         Hu5wbR61XSycCD61sXg053tkrwNJt5a58Xvds7Aj78Ojecg0UqBFfi/xPE5VGGfzjs+d
         k9NdMyg+Mz8uJwjfgQWcrfvm9pgBkptHBejQmYcUr0IyPRohNLsCkg88m54mexqjUYgj
         fnCvovJYdgUfDnum7R4kOqUwev3OW/NK3wkTh8/EQJppOp9Wzd4o+Iejp1MEkL5YuupW
         ayTg==
X-Gm-Message-State: AO0yUKUO8ueVFOcc/zmcyO8VVtP5x6TPE3Rfdom0aJL5U/MOO2/AC3F/
        aG3+LtV7x7IMo2ZCY2L5Kjo=
X-Google-Smtp-Source: AK7set/T29DuNDozUngNweIUAsNFbojutISVoEAVh0VL9cR7vuGtLvkeeHlbxFsmH2asPfQfmc/ftg==
X-Received: by 2002:a17:902:e544:b0:1a1:7899:f009 with SMTP id n4-20020a170902e54400b001a17899f009mr14032012plf.17.1679374068164;
        Mon, 20 Mar 2023 21:47:48 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-8.three.co.id. [180.214.233.8])
        by smtp.gmail.com with ESMTPSA id g1-20020a170902868100b0019a593e45f1sm7537103plo.261.2023.03.20.21.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 21:47:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 35C4B106610; Tue, 21 Mar 2023 11:47:43 +0700 (WIB)
Date:   Tue, 21 Mar 2023 11:47:43 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Message-ID: <ZBk27y+w0uRWvJKO@debian.me>
References: <20230320145449.336983711@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QXHSibNFs0lIniMs"
Content-Disposition: inline
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QXHSibNFs0lIniMs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:53:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--QXHSibNFs0lIniMs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBk26gAKCRD2uYlJVVFO
oxbNAP9CygCQn9fglqg4RAltk3neI5NCbaBTaZjzqi9MHSaTvwD+MSSoQbqErrkx
nEVxfwKnopJwUCsHN6sf3kaYn/ATdAQ=
=zAEm
-----END PGP SIGNATURE-----

--QXHSibNFs0lIniMs--
