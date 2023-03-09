Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EE66B1F02
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 09:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCII5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 03:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbjCII4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 03:56:50 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAB2E1C80;
        Thu,  9 Mar 2023 00:55:45 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so5375362pjh.0;
        Thu, 09 Mar 2023 00:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678352136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IRZaWnJB5vKW3N2Mua12lagbvIC7r/iyFdNI4IaoiuQ=;
        b=BBZzoMQ3w9bQ3vLFHXfRS44zOBrJC/xI2AbmCSVJeOcBgGF5veYAHJRqPsQvRHy9/1
         v2NdRp9sgy0+iBx9v7uy5VOpyvVw5rNldqmm+RRwoQ6XdsE+kPyZViKjTjOBiP3vmA9d
         syQ/fv4OAFYRr3bCaMWoaLJxsjcIq8c8Asjoph3F/7GnFlXTU8OONk44FT3ywCmp0l0I
         dEEDd0pdjLG1PrV70JdlDanlHYqU19Htb8QIY2XKu0C3doXVIc3BKsXeBT3ygSm+rwmu
         JOw0jE84E9iYcjoM/oIaaPfIDilkSw6sEi1Nq92SFtmEhNEwFOQc+b0kBNcOaXlC6MQn
         VGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678352136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRZaWnJB5vKW3N2Mua12lagbvIC7r/iyFdNI4IaoiuQ=;
        b=sh9RJT7bO6fSmDYF5kR0lysfBphKvwx4g946kZ/zMRztgJN+CpIQ1kp3N7G8BeMqwY
         C+6L71upaQom4xy0CZz6RJGFB4iYT/OdYQ25VzsU4uz7R4lI3BPwMQ6CG8XFJUo6LgBB
         pzonchVf8tQk98I34GSsqwchT0YL66b6Csx7KNtSMNJ1PAwD/p+twADrjb5TGnV2xgTq
         mrWKAIZoOLhGh/fw5gPw8CjxyRmhjc/0rrAZgo1pC3wGsCjCD79C71Zjyhda0wKiHH6y
         px+pRmDoYDReFz2fMcGNS0sCEJxpl5a/GdtnihRLsPzGWXBI6BmDU/O6lCZpaFDt1S08
         qOgg==
X-Gm-Message-State: AO0yUKXhuKhVAZ6YyhL/jYpNW7BdozMVTLDrCev1NpBaV/pFBVNrHnES
        4tB9HwKAZtTcdGyg60gR+qc=
X-Google-Smtp-Source: AK7set+tQ4jp7msyrp3ExUaTYg6lGPvNXwRx5LSIfV9xuodx01WnmUsSFo0ttefd3LpfP5SKXdpRDA==
X-Received: by 2002:a17:90b:350f:b0:235:31e9:e793 with SMTP id ls15-20020a17090b350f00b0023531e9e793mr24965090pjb.13.1678352136064;
        Thu, 09 Mar 2023 00:55:36 -0800 (PST)
Received: from debian.me (subs02-180-214-232-4.three.co.id. [180.214.232.4])
        by smtp.gmail.com with ESMTPSA id o2-20020a17090aac0200b00234465cd2a7sm1080812pjq.56.2023.03.09.00.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 00:55:35 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 266FC106581; Thu,  9 Mar 2023 15:55:31 +0700 (WIB)
Date:   Thu, 9 Mar 2023 15:55:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Message-ID: <ZAmfA5jbm8jLsiOq@debian.me>
References: <20230308091912.362228731@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tHH3FCFqzz59BMt0"
Content-Disposition: inline
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tHH3FCFqzz59BMt0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 10:29:21AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--tHH3FCFqzz59BMt0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAme/AAKCRD2uYlJVVFO
oyEbAQCkIDTxCCWCEO7I2IiLpOWMjx/peDuICNJ2SDuAQxjBXwEApQH+G5Cet4TB
rcPy0cGeVv9uHG+W+bq0WgCIq/JaUQw=
=uYxE
-----END PGP SIGNATURE-----

--tHH3FCFqzz59BMt0--
