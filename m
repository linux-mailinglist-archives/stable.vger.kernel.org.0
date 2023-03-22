Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDAA6C411C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 04:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCVDgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 23:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCVDgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 23:36:15 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A1B574F7;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id z10so9810523pgr.8;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cc5DrnEojv7YzJeakKQDE2SxbRr1LRl34O5JQg2M6PA=;
        b=awX3m9vefbZpc3RuCHE7jwwzjw8g250qVtMe4fA0XdztKNV3oF4Qz48I2beLUTlx+Z
         eGFH7EEwbYVEM4Z9x9Lp5BYSqbvMvck1Ql5Y3vhrakrr6vY9qXniDu0uc21psLy6rhaM
         z9dJo/2lKryXLCAP+jN3J4raQyMmb97/xSVUHtfDGWHZF+engVHAu23KPyzOaSNkCzfe
         dEvEcwDJO89ueQVR2kIG1A/Ai3BZd/EHJaQK8Whf9ruaYFCCzkKosxS5RaQyPDPaGk68
         E7zn8A43yoqaO7qJ0G917eUNH40Tgr5hv7uJnyzmAL3Df0gKpX7YADP/oJXWFBLJzQTg
         MZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cc5DrnEojv7YzJeakKQDE2SxbRr1LRl34O5JQg2M6PA=;
        b=1X3LHr+OIFhHe9Hg8SdY1qhqi4C49V/fqGQqftUgckU612jT2JOdLcfSmhUXy6uZ22
         bIxo4If8217wHijyx3nUtrDWYoriND0f4l0p8LyQEYIrR0DjFAd115Zaqi2+NPUbxJ3J
         dpFAJu6Qg/00Wll1dKmGHRtLwKaYngsMiXjG32HY2UrX/35PGPuhU6cJAzEzOiTPgswx
         wB+LgDCO+ul5yGs3wNewzSWQOlb7NRZYXNCI+/8sR7gocBCdxFcfSyYjSux+NL9UG1z9
         YvfBVcGQb02CE6BVW8qZbPFWHqzCCEvnTecjAxyos7cH/Luv1Gq0WUVEKZ+GatPlTz8Q
         2iBg==
X-Gm-Message-State: AO0yUKWN8Z5KEae65RnE9CTmtDZQ6c/cIpXj+/daLlWR55lWOyRDDuxF
        E24GoH3aguDOlDzQlAYF7a4=
X-Google-Smtp-Source: AK7set9xQymjHsWW4dxuyE68uy9S+v5E3RymCn9aJK+gp2C0qZe4RXxZjI1qHxQBmvGQmfONI3RrlQ==
X-Received: by 2002:a62:844e:0:b0:622:ece1:35d3 with SMTP id k75-20020a62844e000000b00622ece135d3mr868953pfd.5.1679456174115;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-30.three.co.id. [180.214.232.30])
        by smtp.gmail.com with ESMTPSA id x16-20020aa784d0000000b006280676b8b4sm3653085pfn.220.2023.03.21.20.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 20:36:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 43A21106772; Wed, 22 Mar 2023 10:27:15 +0700 (WIB)
Date:   Wed, 22 Mar 2023 10:27:15 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
Message-ID: <ZBp1k17eviGPhnnW@debian.me>
References: <20230321180749.921141176@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IKKBsrAChcI1rFR/"
Content-Disposition: inline
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>
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


--IKKBsrAChcI1rFR/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 07:08:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--IKKBsrAChcI1rFR/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBp1kgAKCRD2uYlJVVFO
o+i9AQCnTzbFhfiMLuDyojdMj1c04sIPs6urEuudcbYtprPrPQEAzNZiWhHQNnQl
99rE/5k5fDZCstp+6458xOgtWWZEHAQ=
=8Hhb
-----END PGP SIGNATURE-----

--IKKBsrAChcI1rFR/--
