Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B316EDAEF
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 06:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjDYEmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 00:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDYEmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 00:42:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C257ECA;
        Mon, 24 Apr 2023 21:42:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b50a02bffso4474684b3a.2;
        Mon, 24 Apr 2023 21:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682397772; x=1684989772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7FfxH82wxvv5V9KhGGoclWmqzeRQCv+GM3JH+/f8Q0=;
        b=clE6zXGNxgKEHJPOTPI5O4LIMVQvCYWIQOA0TtkQEIK3G7ODher4816Viort/IHma2
         WWYd+eZW/AWHJcj+/zw+OMkhpDmIrzV/EzhRb8rnbVY5LN4kwIvSAnu5kJ3ye6pZkQty
         zVy7QmcUt0AG9w+o9jEsLKLEpuNwxQEo8+gxZDsS3Cfnqz8pj/Flhmgg5QchBleO6Rb0
         Z81PSGBVH5cK3g+4NWN7/gFJEOB6Jr7t6/AATN2mHEUPypj/YYg9xDOhCubef11aCDyR
         t+q+jOi/nhSY4sbbhpINMx8Vn0/A5ZS9l2HVdJIexnrhSt0d+6fhN1SrLZL9xvTYZ/Ra
         b13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682397772; x=1684989772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7FfxH82wxvv5V9KhGGoclWmqzeRQCv+GM3JH+/f8Q0=;
        b=YJxufe1xgNskxUYJ0aBwKUpujrQ9hZ2NLzt3M6qsMuAiZth807KZFg624DxBvpkGGv
         3M3HFeXqpY09kua/jRDhNRa3OPOSqa8JjpasVWcp/QAJCQ94JkpgpeHZ9xVKVEprt2xQ
         0/gIAZJn02LCnn+TgrWijwUmY6R0KU/tJ8nfDAgpnCsQqZLqtSBEecrqT2GGE8951EbI
         Tfl1QTrTHG8fEiRIBX6ZvtYWssyIMmlOkkgp0lImKY7BudVrnkfwSovWwoXJtnmg3DPG
         AvDHi04rmhp1KSOU+HBwduBmK2gD/WCbMakzhKPx3EcS8TOEU8JucCogIcx/GAFnyqoH
         NZqg==
X-Gm-Message-State: AAQBX9c+3eQrE5KrhVFOGhTo4pQfoC5zig1Ak0A3C9BKtb3+Nr73yeMF
        X6toaoA/oilQlAvazSzLG18=
X-Google-Smtp-Source: AKy350ab4VRIeXYwtCmfhdNTEuYriqiifMOr3U9PNPGljqYxXAY8fPygi8tR2GHsKXbELi0/DlFoYg==
X-Received: by 2002:a05:6a20:269f:b0:f0:7b8:c77b with SMTP id h31-20020a056a20269f00b000f007b8c77bmr15526885pze.59.1682397771680;
        Mon, 24 Apr 2023 21:42:51 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id f7-20020a056a00228700b0062d7c0ccb3asm8237996pfe.103.2023.04.24.21.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 21:42:51 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 91C4710692E; Tue, 25 Apr 2023 11:42:47 +0700 (WIB)
Date:   Tue, 25 Apr 2023 11:42:47 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <ZEdaR5cqTR5TQdyK@debian.me>
References: <20230424131136.142490414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ho/MHdgnWOqCg2wr"
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ho/MHdgnWOqCg2wr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

--=20
An old man doll... just what I always wanted! - Clara

--Ho/MHdgnWOqCg2wr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEdaPAAKCRD2uYlJVVFO
o9TgAP41PVwOfew6DBkCTW+29CJaxW6tgRpXMGI+ZxwAPZNpkAD+I2OCkWQg59i9
4IoZ+lxvicBrrbb4rUjPJI0zpEjCFww=
=kvIF
-----END PGP SIGNATURE-----

--Ho/MHdgnWOqCg2wr--
