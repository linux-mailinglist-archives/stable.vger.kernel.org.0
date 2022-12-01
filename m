Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C2863ECCE
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 10:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiLAJqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 04:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiLAJpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 04:45:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFC82FC15;
        Thu,  1 Dec 2022 01:45:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b21so1122504plc.9;
        Thu, 01 Dec 2022 01:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7FY3m0J87ZzLJkiHzwIpufYx2gFmq04N8hHPLTqvKGg=;
        b=KXqfMg1mrvMyvG9oM/BZlung2T7UMa2bWbZAEoc42vDa8WDlX0Xg7Wd5XrjDYj+9P6
         /kfRj8bkucwHn8BW8leMcqCd32JGbT9M1BRJnjitDe81HbFC/3m+H4n82kKF4K0VzFno
         eGkatFuUkGK6zrP/gqD7yYnYVdMLx5qklXXynKtu+khKtgv6TXrI1qmrqSBw5xA4uZcI
         5g0mL/O63K7f+CIzKwSl2UzOeSt9fDSii0N2cg2acJrQPUrt3eBx1MghpRUP0FTdBSum
         nNIcJrVjtfZyLeVYOYrr/6WTgFtjjFDnfCiqkNLlDJP4F+8G3g8uQHlGBm96wPWSat9t
         JgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7FY3m0J87ZzLJkiHzwIpufYx2gFmq04N8hHPLTqvKGg=;
        b=JJgHFltiIi6DKXHyI76B6DAaiSKos/A9C67uzAl0ZvOQ7OzIniN90tXVzJrgtOE6no
         ajlLITWVBEuQQ0PbaemAPn0myOFxy16iNQS9pOq2xm1jeUtL0aOyrXAhGNO3RtXu+xot
         qKT1ZPtDpYCC19GzwXCVx1y+IDrKxMfiyaYtN/ngrS8QPbuWViLuWJWtfgJ1Gu6pLslS
         XSNoyoEBHSDVYKrCNZBJDcs7sHENtU82OugJ1D9o+IeZLvJhlS5xVO9Nbfe0Kv34gIju
         nFrudEeS3xnGoQ4erO+9p6QVWoPLDJNfQqztCqTnYbRHmO51cBF9RHjEZrcZ+Ps6JV1L
         VjPg==
X-Gm-Message-State: ANoB5pmMrkYTJcu26xZU8k+NJvIhgOK2ebRhf3JDhPiLACYJaBZEfJ8Y
        Tv80uFOvc4n4WbKDc/8M+S4=
X-Google-Smtp-Source: AA0mqf4K5HvvV3YlI7E9UROPf8++mkkrbI1mZJwPkQu0VXp3qKY8kqJDqrjbvHitUS9CE8Te6D+ngQ==
X-Received: by 2002:a17:90a:d34d:b0:218:a0ce:9d5e with SMTP id i13-20020a17090ad34d00b00218a0ce9d5emr59555308pjx.96.1669887950130;
        Thu, 01 Dec 2022 01:45:50 -0800 (PST)
Received: from debian.me (subs03-180-214-233-92.three.co.id. [180.214.233.92])
        by smtp.gmail.com with ESMTPSA id l7-20020a63da47000000b0046f56534d9fsm2216518pgj.21.2022.12.01.01.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:45:49 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 99A691042B7; Thu,  1 Dec 2022 16:45:46 +0700 (WIB)
Date:   Thu, 1 Dec 2022 16:45:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4h3yoWdmPYWgg6r@debian.me>
References: <20221130180544.105550592@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SSFCZBvgNejQsstI"
Content-Disposition: inline
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--SSFCZBvgNejQsstI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 30, 2022 at 07:19:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--SSFCZBvgNejQsstI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4h3wAAKCRD2uYlJVVFO
owtHAQCD6EmoGeC67qmz6lBjjKF13d5CwE2CB1nB5p4MjSIQ1wD9GxFcVjt8ncHh
n3UwlWl8ZvL/X9utWU8qpTPQEbd7ogs=
=B9Uh
-----END PGP SIGNATURE-----

--SSFCZBvgNejQsstI--
