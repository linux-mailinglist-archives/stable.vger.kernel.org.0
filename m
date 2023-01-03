Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709E565BFA2
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 13:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbjACMI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 07:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbjACMI0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 07:08:26 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDF2E022;
        Tue,  3 Jan 2023 04:08:23 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id y19so13359914plb.2;
        Tue, 03 Jan 2023 04:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BQHkYadhZlgGM+Zbgat2QdSFubzEiShLu9c6oAOmKWQ=;
        b=Ovx/SV6IEb+qUTBf1d4gefA1pI3yO7x9d1P2vpqNLit5EPnPrgWevmMR9U78HMd3gG
         w/FueeSuxFoYQbLgNk9XJZqiaBvHiitOSRREPkQzdGSNJyj+0wzcThw6TaNfZhGtAAKK
         G4VF0bql3TrL2fWdeijkkxyAQo7uRkWUCtiQeW6BRSXYr1QvoDjFzGin03FKP3Y6eggg
         uVw+bRaIg8l6xH3kFGEEsJN4Qq/LUaV9G9rvVU1fOGMMmR22+YK6UVgF0YNTXRYZUAaV
         XTHXXl0F4DIsuLLFAmvRdsUB2AvXttzO4o/ea7y8LLpE6xNS1oBoMVaKOu5NAdVvFPz8
         WvfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQHkYadhZlgGM+Zbgat2QdSFubzEiShLu9c6oAOmKWQ=;
        b=cf9WP5+jn8p+3v8pnT0fY8rY98btzi7ujrW2prnlNiHPDpOffVdEuprSW4TiEykBWo
         4zXpMHxdMgaoUgljQy2ch98L33lNGT1mO+mU03gdvvu7n+aibIJtQEsmRtD612abyeWN
         log+W7/FpbE2NvuOyPMjGX2ZCmtmh3yONWJsrFZTenZHaHJjnkhow/T2nvIW6HFK2ZN+
         VxJ/3p4ZtdcMZWhsIK0MnPFRSdGURSegcgF3lgP9lCILEdIeOO/U3e6FJKkUYRGgip1T
         Q83PbqE6+mJPNDB9wMT/Aqz9+LtCsjSl4lpjaTgwH8URSScJsfW0YIFc7QuxrLWAAdWV
         ud2g==
X-Gm-Message-State: AFqh2kq0gqoWio54qZWQhzS/C0xFdUJqtR1Xzft+QB/4BXyr3bDgxZaX
        Cama1UGnS56YC8gIRMV+1a4=
X-Google-Smtp-Source: AMrXdXsrkli71JgCcoKUx5P/GVjUrOn6OrtNPJ+Tj8aUIncXPuVtPXD3PPQvcKPztAxRlliQXt9wBw==
X-Received: by 2002:a05:6a21:32a1:b0:aa:6efd:1883 with SMTP id yt33-20020a056a2132a100b000aa6efd1883mr71763197pzb.37.1672747702996;
        Tue, 03 Jan 2023 04:08:22 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id b20-20020aa79514000000b00581c4b4c15bsm10014258pfp.142.2023.01.03.04.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 04:08:22 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 7B297104F4F; Tue,  3 Jan 2023 19:08:18 +0700 (WIB)
Date:   Tue, 3 Jan 2023 19:08:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <Y7QashBMUr8HrQNE@debian.me>
References: <20230102110551.509937186@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="13ETcmKU9UnxuBi+"
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--13ETcmKU9UnxuBi+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--13ETcmKU9UnxuBi+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7QasgAKCRD2uYlJVVFO
o6I3AP42ieSvz711PkLm2XKvEzpekcOx7z785Qk1q7+gXYSU5gD/eoGr+p4OJiUe
ZxlhK0CZg0g+997ECbYuRr8bbuJtdQQ=
=VFyj
-----END PGP SIGNATURE-----

--13ETcmKU9UnxuBi+--
