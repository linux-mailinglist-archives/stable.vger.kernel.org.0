Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4559569DC99
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 10:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbjBUJLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 04:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbjBUJLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 04:11:37 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CCE23858;
        Tue, 21 Feb 2023 01:11:36 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p6so2048195pga.0;
        Tue, 21 Feb 2023 01:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nCmHgfpMxViqDLmcKLWqNfQ12zWvq/2JIFuWMxvapXQ=;
        b=MWkrpyphbx/NrCFrs5ZMCOvEEG5BIfRP8jMfr005eA2qt8qndOWDmCB8xLqi3f8r4w
         zcsdehUJnwdujJWWg3iD1ZW2HJp6hbMzPsxwGMUy4+M4L8k2wTbYvNSFvKzvj/8ulcGJ
         7XGJGT6yhcUFJ4fyH4yJb4ICj/54rpKbPxPNWjpm841PMtPMJKNh7bFPAH9NmD8lSidE
         RZwOnc30LMMcrSt083cqsKj9MTuYtgTrkSKZeVc8qTYg7ISqkGeSR6B2eD0TTPZKGhb8
         24+7s0GDV3o807NOSx4drLpjSF3k+GyZgFX5GZh8zSHr16tYqfpl7PPY6yz7FxjVdjGX
         aFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCmHgfpMxViqDLmcKLWqNfQ12zWvq/2JIFuWMxvapXQ=;
        b=Opd6SlalzRiNz+UJcpCqvkwr36cYqd3FGcRrFSYoY3llni+WvqcNkIyn24bE6uxlLe
         as0wrueFD4FyGjXXZNEnsoxlHu2jelsIC6IFOfbAfVxpBcSfxkoEVmkkukXD2sdMWFZZ
         RFFPtP5tCAw3GGgGnQBroinY0agMJY8rvSKo6Wx0NXSB+NNVQ5BGvV+N9Lw5Zmm9i4Zk
         BIf+N37Uqvmlyuo1X4/gZ+ThDcN5/IfRbaXWZVIqFfrIZ2YOt+isoJrHc/NIVPAXa1/m
         tC2vOy5Y1pQlQfhi/9VA+ZhKZSXnyheaGyzQU4weGG8wWh7kOeWRYDPg+BVFJUM1YpUE
         gDdQ==
X-Gm-Message-State: AO0yUKVlhufLVvc+VAJLRc7FyQqetQPjQxWHVF1I7b43y8mafZvn79c9
        Eh2MN69fWB4BDkg+kBCnDDU=
X-Google-Smtp-Source: AK7set+QdnNzvwjiS0tviDr7Iw8v5hHFa9TJdJSdE7XorejlWIBvoeszUhC5GyqfQXAK8UpWQoJtnQ==
X-Received: by 2002:aa7:8ecc:0:b0:5a9:b910:6d98 with SMTP id b12-20020aa78ecc000000b005a9b9106d98mr4648297pfr.13.1676970695558;
        Tue, 21 Feb 2023 01:11:35 -0800 (PST)
Received: from debian.me (subs02-180-214-232-76.three.co.id. [180.214.232.76])
        by smtp.gmail.com with ESMTPSA id e1-20020a62ee01000000b00594235980e4sm1728168pfi.181.2023.02.21.01.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:11:35 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 93421103DE1; Tue, 21 Feb 2023 16:11:29 +0700 (WIB)
Date:   Tue, 21 Feb 2023 16:11:29 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Message-ID: <Y/SKwVOIgDUxcxyH@debian.me>
References: <20230220133600.368809650@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VbTdTAdj2F7p+sKI"
Content-Disposition: inline
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbTdTAdj2F7p+sKI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2023 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--VbTdTAdj2F7p+sKI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY/SKsAAKCRD2uYlJVVFO
o9BKAP9QNyO0YV+M4mXbjoH+4Mszm/LoyYxVJYpVf+fEi7KbgQD/fgd1mnVA3URL
PE2wFsr+sw5nAsb2trMBbRcz/mteLQs=
=Osl3
-----END PGP SIGNATURE-----

--VbTdTAdj2F7p+sKI--
