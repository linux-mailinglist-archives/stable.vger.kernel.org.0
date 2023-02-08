Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FEE68E65E
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 04:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjBHDCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 22:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjBHDCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 22:02:11 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFDCEC51;
        Tue,  7 Feb 2023 19:02:10 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j1so11168956pjd.0;
        Tue, 07 Feb 2023 19:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nlkpngfGvD/yiVPysVUCiWbRJJEon+jqBMZmtnq4MwM=;
        b=ek5FXFElcRs9ejujZlv3HlBxR3Y9EKzX11DkCe1K52VMjYTlN37n2TAtu77PdPnBmt
         6JvygYOx82MhMTJrF34aCl5udCf81cBRGzi6VJN4AwTt6WdusGJhudGxi7O0LD8Mvkrj
         nleA9JZ02gQjfGOD6L3IYxjDaPBgCWmplFBFkV7vxEAzubLVuuYwkMtFKLB72NBT2JkR
         vUQQXaZvtCJESU/sdO7tKDkAq5IhGP3kPnzSgiiVNJy3ywIC9c8z5BFGSFDk4CTdIWT6
         heZxJgXL44VQREYGc67TMOcOOqwTjzu21o4tDyB7m47RXfoMeJjAQB6uYymjWl0Rre0D
         F3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlkpngfGvD/yiVPysVUCiWbRJJEon+jqBMZmtnq4MwM=;
        b=npG2rO7lFXn+ZWCx66O2se9Ml4bxZtGYoWkVyCpUrl5Z5IjZgKX8zFUKP188NZ7pIv
         xKjEO0LK2AWux0IsEB/ESrLKL8p6LzvGnUN60vjZFqvhJttxeGWER1xSo1JujPIywB3O
         XvxV8ctEH5wVayrNJGTlFHDDqt7GzeSqvw7BUGqUVoFDQg66rJZuNrzbToCDtlf1bTzn
         Zn7Ix/cV2RCGD1IHqCfLvjvlPxetK8oXssDqk3cQi5KQJ8telxs7VjM0zZp18nNSnmn2
         C3hwOZrA+dv4UGyvEnChXk9fECJkB5H8qOsWgTIDSkPvS8Y8pivWNk3Vk4AuVmu5e3mM
         S8tA==
X-Gm-Message-State: AO0yUKU+hf9WbgI/xM+Uv7Sxp8XgUZTeuwYljAS0QkuFzLGaaQhzwC4H
        +I7opyRgxPZ5b/1LhPB3AhQ=
X-Google-Smtp-Source: AK7set/Lu7/GmxZwF6rYKdq5yeGObj5e8OHmUfmGFlcldoL0DbWJJALT6tXH2snOJ16bT+/w0fn3Vg==
X-Received: by 2002:a17:902:c40c:b0:199:41a5:1085 with SMTP id k12-20020a170902c40c00b0019941a51085mr1708108plk.33.1675825329410;
        Tue, 07 Feb 2023 19:02:09 -0800 (PST)
Received: from debian.me (subs28-116-206-12-49.three.co.id. [116.206.12.49])
        by smtp.gmail.com with ESMTPSA id ju10-20020a170903428a00b001991594d783sm4982267plb.302.2023.02.07.19.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 19:02:08 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 2CD6A10558B; Wed,  8 Feb 2023 10:02:04 +0700 (WIB)
Date:   Wed, 8 Feb 2023 10:02:04 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
Message-ID: <Y+MQrB33TH8NxK+g@debian.me>
References: <20230207125618.699726054@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5GvqER+TUurvWIAH"
Content-Disposition: inline
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5GvqER+TUurvWIAH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07, 2023 at 01:56:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5GvqER+TUurvWIAH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+MQogAKCRD2uYlJVVFO
o6ARAP9n61msPuqELh0EJq1OflA4UmYoG7WzN4E8R2ejNFECRgEAufEoTChhbKqn
IKCAZYTNPeyuLUPJgB8QSD3U/hwIBwI=
=srVn
-----END PGP SIGNATURE-----

--5GvqER+TUurvWIAH--
