Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86AB610901
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 05:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiJ1DqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 23:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiJ1DqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 23:46:15 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9C3CD5DA;
        Thu, 27 Oct 2022 20:46:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c2so3748835plz.11;
        Thu, 27 Oct 2022 20:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddozMKzLnmiIVXlU/iNB76qbYgY5HX3Ge5pJ0vqMWKg=;
        b=Vkhfu5qcqCC/j6VMNCJYmIb7edUpEbJbC562p9tZp/+QGQxlSME+mdKdWpou3DyYNp
         MNO5MB8NbO1h3LWGQZNc3uH5Qfu8xKYyd4/qZQYiIylQQ2SXfj1VqjK6gE/83ki7hbQt
         EI7b2IP0Oo5/mzQGEZ/MhRUw6RiBdP0btgWD9iVWyTJD/vdJ+EfEmkHdEeU+gCsU08GN
         xdssrUA99pRmjnsVO90mEqN3+LN4LmSUCAfCxwagmNcfs98as0hDa+agARGwJmoVzJhb
         aKYriUpF2kXRLKDopbRDnx8bgcGEp8wzYgeF4ECcT9RlPoRHVWkSFv0wjzT4yCmUFBPq
         mTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddozMKzLnmiIVXlU/iNB76qbYgY5HX3Ge5pJ0vqMWKg=;
        b=sGaQ0yGIjqpWswVP2raPFZ1Ded4OBlFRpwSs32DX69ZUnZRYM4qH1CW1ahHMTYXjXf
         uFrGp264+VU5QkkkEAmDXMEQXTs9Lz4eED+LQ3PGSN7U1KZAKe1s3REvFcrJwIiCJX5N
         08LWwH3mRLMIfkeeaDgteZqM2GSlHrXfUSevRIJClfWgDRxKFkm+DsYh+hJVj6IhNwy9
         pq6f01TmxhzwdqDxyGU1tNuNHA7Xp0+lfT8bzPCwneqXKpAK+v0/+2EZfkGHEl9uw5YN
         dcc1gzNSrCB1WElSNTrJmSMeQn2rn5yicdoYtka80wLZ8oWhdkC41y6ULLkc+Odransm
         EEBQ==
X-Gm-Message-State: ACrzQf3vOPrkHUO3pizaI9Gy+9rk6qMC9hYpKQPYgX3un47tHk13EzDh
        Hn2KCpvYrccAsnQ/jZBjZnQ=
X-Google-Smtp-Source: AMsMyM6SdE9CLSayTRSvlmTYrySWUyzc1bJlBA2xHPiEHlLa4xpPBnv0LBYV4SXHfxukdvQrQVoFfw==
X-Received: by 2002:a17:90b:3505:b0:20d:ba2e:994b with SMTP id ls5-20020a17090b350500b0020dba2e994bmr14182652pjb.46.1666928772609;
        Thu, 27 Oct 2022 20:46:12 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-58.three.co.id. [116.206.28.58])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79910000000b0056bd4ec964csm1873560pff.194.2022.10.27.20.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 20:46:12 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 4D6E010030A; Fri, 28 Oct 2022 10:46:08 +0700 (WIB)
Date:   Fri, 28 Oct 2022 10:46:07 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
Message-ID: <Y1tQfwsHYPzA7BqZ@debian.me>
References: <20221027165054.917467648@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6AXgGbyqm93EDBa2"
Content-Disposition: inline
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6AXgGbyqm93EDBa2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2022 at 06:54:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--6AXgGbyqm93EDBa2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1tQdwAKCRD2uYlJVVFO
o4pRAQCF7hCFp99vkJuPn32klRg2GNFtmRa+dSiPSdHKRFZlxgD+P3wCrPaJtnzs
fpJkbNMQg372l3usBvhDtfGUE/ymLgM=
=c+HE
-----END PGP SIGNATURE-----

--6AXgGbyqm93EDBa2--
