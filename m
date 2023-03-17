Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C271D6BDF0D
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 03:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjCQCuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 22:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCQCue (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 22:50:34 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA4A6C188;
        Thu, 16 Mar 2023 19:50:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p20so3809640plw.13;
        Thu, 16 Mar 2023 19:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679021423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eqOf+CxGj15FfKuwcu74lHhmDEBF3KHOJ76Xs74tsCo=;
        b=JZvwoa5Ef9PAedLtfmTHXeMTJSaerdQAhIIO/0fM1fEVLJfU+DpZEa07vrhzguD0VS
         oxzTUa/8Pd1FAnN/4TXZlRLDidiegGz4h5qANU9ymG9MiPmjtyybYohl3G5jWp4+K4Th
         5mlr3xZJXHv+lxvrR/V+vji6H+P24Dr+SqW38X1FRgT9joDR4JzpFoM5h+9MSyFuYGBG
         hOpj5AlSsWcfG1UNKE+p9JCaHhFWkuIz2bZvvqsMXTyzkq0PI4TL+OHaifyi34M6XKbH
         3ub1Ai+wXMa0Shh8GzCvyHWw3jimj71KuyVDnQZmdQZ3Bg5ZrwKWQ7zWBYLg37H+xkDX
         6NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679021423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqOf+CxGj15FfKuwcu74lHhmDEBF3KHOJ76Xs74tsCo=;
        b=28Ao31zobZ8LDD3tLkx4CUg3zkZc9DPTeaG0tLJ59Vg3Gq2NtWr+49L0pov0wZtPKV
         OdTwzWNfybSiV75EVHB1917GML+NBLjE1eIWhBqNnZOdZSLsGK1QHIfoAj+OSUVWLzP3
         mOizW2+t9anvmYrlWbI3uw4PXls3hhdFhuEci/JkQvga6gmEqxmER89v6klajaVFg5Q0
         SjByiqDjzin3yj4/1HgNL4SdvKdCcVwMEjzWLM4DjCUCbCyE+nBRSwBKsKPLkWJHeQbw
         xtfXYAHtpEEiQVZTjpsxhJLX6scfpdpdt2thzAeKkDT33LmwFjoY96NlhgbEED5HrFON
         9Xqw==
X-Gm-Message-State: AO0yUKUcqUrejluHD30TsLb646G3Gw7Q4Ufv34tlf0wdLb9ewbwQfhJv
        tOC8jRBnxsVdk0TU5+rVB+I=
X-Google-Smtp-Source: AK7set+v4mVgYo7xq5UuvP/+1h15xes5JpADeaNqzsp2Wtx8siW6JkXm09m4A5J0xbYsRG9n+d2Vtg==
X-Received: by 2002:a05:6a20:4320:b0:d0:45c0:1421 with SMTP id h32-20020a056a20432000b000d045c01421mr7271059pzk.48.1679021422972;
        Thu, 16 Mar 2023 19:50:22 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-44.three.co.id. [116.206.28.44])
        by smtp.gmail.com with ESMTPSA id x17-20020aa784d1000000b005dc70330d9bsm398175pfn.26.2023.03.16.19.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:50:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E3F24106830; Fri, 17 Mar 2023 09:50:19 +0700 (WIB)
Date:   Fri, 17 Mar 2023 09:50:19 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <ZBPVa6Bjb8MycqR7@debian.me>
References: <20230316083443.411936182@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="G5gDks0r2/4k1sM6"
Content-Disposition: inline
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G5gDks0r2/4k1sM6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--G5gDks0r2/4k1sM6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBPVawAKCRD2uYlJVVFO
o1JlAQDmo1xyFn0bF+wqbHTfjl5EH4NqrNB5OIqt0w9tkkjzjQD/YLXBymEElPyV
D7qJStL1c9hx06Vio0druOR2et9UxwQ=
=2EUh
-----END PGP SIGNATURE-----

--G5gDks0r2/4k1sM6--
