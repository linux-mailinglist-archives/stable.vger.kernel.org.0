Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2636CD10D
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 06:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjC2EKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 00:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2EKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 00:10:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6FAC4;
        Tue, 28 Mar 2023 21:10:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w4so13713613plg.9;
        Tue, 28 Mar 2023 21:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680063035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gdJ67JL/BYKEZD41B62DqWcZtXZjhSsBusSQCh2eK7U=;
        b=OVfBbYd06oGJNclR2POSs2edkFbDfXaO50bJXon+CXUggrNECCiWRqeyBpcJMbjT1B
         VKajJQlj/U3XjF/z0rQeMLfn6l6/jSOxxa4anSQj+Dz1OeEJqj+Lx50tYV3yg/yRBHhz
         TyJBkVsor2Xf4MXHwYA1QB46E+KFZbiuiqyepQoAQl/gCvm9uKePs+XJCVaW1R5ApEY6
         LUlXjOBRU+CNbAKd8s/V1fUYCW11Sg50K4JIZjPYIaVk3GEv278hm/tNbIHvs3n8Xih2
         YcXionyZhZtBjebiMURtdC4P/GQa0RCWI0EBxMY3zDvM1A1M924MK2eCjFYtp5o5NxUU
         fAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680063035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gdJ67JL/BYKEZD41B62DqWcZtXZjhSsBusSQCh2eK7U=;
        b=TDwZrx3VlDSKMf3yY4DlPf4lCRFCxoZPy7v5aiYXzFE9f6LC4vYadGx/z8Yzsrmk2z
         qhaYrcwfTqhxXcWiOZg1EX1NRJzWn1R3c+KtoGiN2My4TndDfCbaig/Qk0jw6ZKwdhnj
         qKVKWQxeK2dJ/cvoGO1wMFg/0rKnqlcCReA3Fm9UonUO0WmvX6PyMZPhn6HSoQwe6OfD
         4IMhLSQ2V/RIKoQNNfXg4vdsnevWmMJJCuv3aGpcAz/sxI82exrBh5EYSZ3PDf6x4Smu
         DiE2p7KdgnK7eotnNJRSteBBTOdZCoe/54eXNawMRv8+n/ENdkK79m53WTkMdl66FCOy
         hH4Q==
X-Gm-Message-State: AAQBX9cz3EvssjqwAGeWvmwWz/7PsHnSfdhS+0lPUu/3eByuji9o6TLY
        Ee5R1mb1sTbXHl/EOnRdv2g=
X-Google-Smtp-Source: AKy350ZdrRD+us05IF6DLSKbywx29W4cWSq/R/z9UbuG/7zsxP5GY4sTwHnsfB2S+BQCfjW00V6rXw==
X-Received: by 2002:a17:902:fa10:b0:19f:2b42:5d01 with SMTP id la16-20020a170902fa1000b0019f2b425d01mr15486452plb.9.1680063035522;
        Tue, 28 Mar 2023 21:10:35 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001a1a18a678csm21925184plk.148.2023.03.28.21.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:10:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 537AF1066F7; Wed, 29 Mar 2023 11:10:32 +0700 (WIB)
Date:   Wed, 29 Mar 2023 11:10:32 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <ZCO6OHxvy1ygyVlg@debian.me>
References: <20230328142617.205414124@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ub9ZE1zAU21X5pnf"
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
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


--Ub9ZE1zAU21X5pnf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Ub9ZE1zAU21X5pnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCO6OAAKCRD2uYlJVVFO
o2xPAQCMFNnVidWn670etNza5biPUhkU2mliAmg1HVIyOlo8WAD+NsjmxbsNBzHr
8wOTssFX85vjwIf9q5MigaG5LHP98wU=
=gX97
-----END PGP SIGNATURE-----

--Ub9ZE1zAU21X5pnf--
