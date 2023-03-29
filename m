Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E446CD10A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 06:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjC2EJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 00:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2EJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 00:09:50 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB9C4;
        Tue, 28 Mar 2023 21:09:50 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id iw3so13734601plb.6;
        Tue, 28 Mar 2023 21:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680062989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1k1VpGQcdU01YaRH8iXtop/VWOjOXl1oxQqYfGF1hdI=;
        b=XWOPXensr6BD6UmAN+8486yLuINJtZTYTEYfiOvO+Gtk3NVUN+0ibF0SywkiBjQ57U
         PPn1qAJYewu1H0iBursV2MuHwr/ZS188z6+4gQ6BTq0EYlY3usxZ1MtISOALdufN65Re
         pN5fqXYlNmrhT+pxWO7UWEHzJlfT7BtZc+Vu2V90QqaleKpX0p8SEG551RztYeGoHk95
         W/KdpPizkFsHZjhHn9EIXzIXLQ4rO7U+tgJb9FwXd0KQwN6NQrPogmu1iPzHn6DVW5sf
         Zdd7F82a4R0T8jbvKtKn0L1fikrWlcBY5OOnQyZe/i0Frg3SwosikpK2p6m1g4955l+g
         D/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680062989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1k1VpGQcdU01YaRH8iXtop/VWOjOXl1oxQqYfGF1hdI=;
        b=nvYsbc3xx56no0s4H0i7Mb0ybfRKbSnHX0Gc9shewYDt66KkCbrgcDgTG3m9AGgZsH
         a1hkuekaqZ+jDMIZOSS0yzpkruAjPscoSY6aqynAN4V3ya6pMYaRZZTiDQG+YXDcGRRq
         Q3R2AJWguiiHg1ksuqYZ+mYUjRwxb2kdcc3kWYyKKSDAiVE4IALsTa5EAtjRgXv3GK60
         ayurzWz360JqolqDXULfgNenXGGg6EeBizCf/G4rFDOPK77qADqOfRKJfzLYp9zjF/lw
         F5HeSA0shVc28ybyqUZBUgzH9+qaYyUSR6ZE1lXVRZsdrY898kOqpwDPtBtrbgX33hDt
         PDCQ==
X-Gm-Message-State: AAQBX9dh/Jn0NxZCOMtImUUPL08fusr4QrVhhiPS3HWnM2UinxbRoH/9
        4WbLGCVTAIq6wT2uUa6N/ww=
X-Google-Smtp-Source: AKy350ZzpHzMOSXNdWkrJjZtVmC/YU/MiOn80uzx0niC/Qy/8veIVEn48oe3KeBP0flRzRNlDrZQpA==
X-Received: by 2002:a17:902:cf51:b0:19f:3b86:4715 with SMTP id e17-20020a170902cf5100b0019f3b864715mr15635961plg.8.1680062989642;
        Tue, 28 Mar 2023 21:09:49 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id x6-20020a170902820600b001a1add0d616sm7014361pln.161.2023.03.28.21.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:09:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 40113105187; Wed, 29 Mar 2023 11:09:45 +0700 (WIB)
Date:   Wed, 29 Mar 2023 11:09:44 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Message-ID: <ZCO6CGVdiD58Jz0n@debian.me>
References: <20230328142602.660084725@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="48/u5+Bp6VaoDCJF"
Content-Disposition: inline
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
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


--48/u5+Bp6VaoDCJF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--48/u5+Bp6VaoDCJF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCO5/wAKCRD2uYlJVVFO
oyJ3AQCtkjVM1wR2jDxtWm2o8sA/jypxs+hHA0WNuPlK9PjhxwD+K7jBbOgRUzVd
gl3+exhqQjW/u4HUpipXq7bXKSRKeAk=
=xbdG
-----END PGP SIGNATURE-----

--48/u5+Bp6VaoDCJF--
