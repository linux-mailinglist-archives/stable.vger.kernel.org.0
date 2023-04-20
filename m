Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEE16E87CB
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 04:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbjDTCE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 22:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjDTCE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 22:04:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F40D49C5;
        Wed, 19 Apr 2023 19:04:20 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b73203e0aso3668987b3a.1;
        Wed, 19 Apr 2023 19:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956260; x=1684548260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zdT5mleDLeq0ZPRxrhxbPyAgxYivgHjWjRIUkuvyouQ=;
        b=NYb+HEH/B4I3YJB/R0nUbVpY5JuWHjVGGikvy4lMljQ0Vp4o6ZD4tep/cxFZ7bQXbK
         7MPS+CMpVd3wNd3HJ1s5G01yFxgEJHbiPoz8v8nMEjBQ9OZlm4VW+8fT7kWJL7zx4PEm
         eMDGEQ949lvb5WD4+EUyH5TOlF8G4XUQS1lawZY4yWlBDjyUaG7PUO8edykgrXHCz0VB
         FrqfWmyqrwyBMoYTU7beZdKiSYArQFEASTW2w8gcJJAeU2clSCpvja+yXu+ncQb9u0m3
         RAHwwZ9VG9FkZY9ekrkm9btyPS5j4LV3jVFcCIaFm3SZQ+IZbUpXpiOEH6wPI5q4wuhr
         9Bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956260; x=1684548260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdT5mleDLeq0ZPRxrhxbPyAgxYivgHjWjRIUkuvyouQ=;
        b=JlZ9bXyUf8HKSONdPiC6mpLTLIGsCiDg1TSRJOMwTa4RrQ+HA1Kp3VnhXXxVNhtH31
         tBcasw9V94gcxmmMq7QJ9Fo7NBHkyFqY/b9qp1zE85TFFVhPqci+7++9UNqSvVEz2WGX
         +CaAjTGrgkPm0PuW74FDdvxof83ikpWHbwPhtuq0sYbgnFFyXszhIW+QYboVjExVQ9VV
         NpwNVCk97oXCVHfY9HTfr9zfrhuHn9Esl5C93CoNts28KmBtxJTaOQBhOkqcGSfpd5Ut
         7KYvxaJb6ZKFzSouPjUk9yjGUpf1TOSj6ew4baXQUQ5g4GSyW8ARdjD0JIqNV8PdBC+m
         QILQ==
X-Gm-Message-State: AAQBX9eG6dVMstkq9hhB/W3cuWnAjhzVufWrJM+It2u3lTBlYIqUkKFU
        Z0YYZbi3RNGN85QX8d6rO2I=
X-Google-Smtp-Source: AKy350aq3aOeOGvu/GOH4k02123owFbWfWKPfYp31iKKfKhvq0JMcObFOyHWJTZ8MszR65QFdJvaPQ==
X-Received: by 2002:a17:902:c40f:b0:1a6:6edc:c884 with SMTP id k15-20020a170902c40f00b001a66edcc884mr5781597plk.16.1681956259923;
        Wed, 19 Apr 2023 19:04:19 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id jj21-20020a170903049500b001a69e002c7esm102312plb.178.2023.04.19.19.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:04:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 30D101068A9; Thu, 20 Apr 2023 09:04:13 +0700 (WIB)
Date:   Thu, 20 Apr 2023 09:04:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/87] 5.15.108-rc3 review
Message-ID: <ZECdneXReDmEBNzI@debian.me>
References: <20230419093700.102927265@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UKBJ1PY6MeZaw2yI"
Content-Disposition: inline
In-Reply-To: <20230419093700.102927265@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UKBJ1PY6MeZaw2yI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 11:40:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--UKBJ1PY6MeZaw2yI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZECdnAAKCRD2uYlJVVFO
o5tnAP0eFqKZOpGnOKB9KJdGm4jYst2JXduaWa+622gU4aGMjgD/Vp+GS0SFpI7d
walqISenpBJtHqcAtL1K60AIL4KCowI=
=tO8f
-----END PGP SIGNATURE-----

--UKBJ1PY6MeZaw2yI--
