Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49666D7343
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 06:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbjDEEQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 00:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbjDEEPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 00:15:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F696588;
        Tue,  4 Apr 2023 21:13:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso3184236pjf.0;
        Tue, 04 Apr 2023 21:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680668038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g+eDgVmaMNqTGd/qimf7inW6PM2Odulp3OAAIGSep28=;
        b=iNrh8MwpZTJp1/VsSUuhHD+RWSZIhffT6gnBL4keUujDn73PLiWdZVcqoHqe/CUT/Q
         jUfSwd63M2+sJxGA9h92ZbVUubUN/0TDw35v3a66VhYAUZPB7p5ZImgHeP9ap1quYSTY
         7qUKmyUhjxCEIxetgg7OxZkE9YuFUjp9lQToDJlOdfvnvj6CdzDbTjmDw6vCwaUolZOG
         Hfy8jyorhQRmUgxkTWHoEPfsxf2YxwB/BpA4b6KGlCJk3FxSGxcIWuEUYLERuSVC6xtX
         S1ehtHMD2EabPwFGrFRyjWbpdytFU2tzvbL9zuwm7GenTGV41Htdxe+NJux5TYw32foo
         xuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680668038;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g+eDgVmaMNqTGd/qimf7inW6PM2Odulp3OAAIGSep28=;
        b=hxO/I52yG0KIXnJ2KqZe70mV1n5Tw0TpRZJEQwYAQG+b++llUrqJUJCxx5n7o9nxNv
         dO1kRTjmiRizb6qVq3apWS6zoo7E5L0MXH9cXd64zH8X7mRfOlAHgadSGC9KtwWqSrEi
         WvZJJDopc+WBri0Nb1bpLYIE/LkTKOp9QCYELgsj8gKKmBAKZafdOQeyOl6C8WV8iP9W
         vshOnJaFWjdcPJ8WXQW8Od8tNCmCCmnecRZdcRQKtXMTBuCCYV+xANZ4NokmolORvFs/
         LEPv7xZEqTUNWAh0CMDYeIeyGmYecWNsGLncyeeLbnuQ7AXFRR3WXQfimY7ny3plad7a
         lEEQ==
X-Gm-Message-State: AAQBX9dNM9I9ZqYsHyC3KGgFrYGMkUXcL5j6ojlP5T5Dg9miB5JGBTOK
        8IYaIsK131ZojwBPDN1QUk4=
X-Google-Smtp-Source: AKy350aa0WqEYXIb7klDnyPc0BJYiDHt2ptboBEKE+V8VXGw8wdHA/4o0VizGL/mUTbK4owxRMvojA==
X-Received: by 2002:a05:6a20:4b1d:b0:db:6d42:118b with SMTP id fp29-20020a056a204b1d00b000db6d42118bmr1513649pzb.0.1680668037817;
        Tue, 04 Apr 2023 21:13:57 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-25.three.co.id. [180.214.232.25])
        by smtp.gmail.com with ESMTPSA id x22-20020aa79196000000b005ac419804d5sm9752051pfa.98.2023.04.04.21.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 21:13:57 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id CF32B1067AD; Wed,  5 Apr 2023 11:13:53 +0700 (WIB)
Date:   Wed, 5 Apr 2023 11:13:53 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/179] 6.1.23-rc2 review
Message-ID: <ZCz1gTqDN2/ffy5E@debian.me>
References: <20230404183150.381314754@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4IS1w0E7de1Z9A85"
Content-Disposition: inline
In-Reply-To: <20230404183150.381314754@linuxfoundation.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4IS1w0E7de1Z9A85
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 08:32:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4IS1w0E7de1Z9A85
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCz1eQAKCRD2uYlJVVFO
o69uAQCpbQD9fVGkO3TpA4q6Gx0Z7bzIoYtj5AbQ7vW3/U1EhQD8CNhpANnWuz7p
CPowXnqXRENGZN1w/ZYe0vydh9IYpgw=
=k1b5
-----END PGP SIGNATURE-----

--4IS1w0E7de1Z9A85--
