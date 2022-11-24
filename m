Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B5F63714B
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 04:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbiKXDy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 22:54:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKXDy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 22:54:58 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CBA7C467;
        Wed, 23 Nov 2022 19:54:57 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so5025626pjt.0;
        Wed, 23 Nov 2022 19:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FGDchlzjZ9nDfcUMTxD0UYqCVipAmcffFJDXCznLGbg=;
        b=kMBa7450Mqi4GDqf6C0SoSvIT3YNQSLd0LAj4lPYdHxeLZqvfqyG3Lw1WaBS3PkB+C
         hV8S6Oh4k6Xuc19CbipnWJ77NELKQJ5OSejy1DQXMKKsJkCJ9N/bVG3ypLeA8voJY2CZ
         YOgojVUk1K2/zCXG24Vb4oVlmOYW74Mu1CB4/Y8VgVxZJDn7f+CqrhrHzCA47HnExFSm
         aajmeKVKvEgYzp4lMGFTJv1y+62eQHBP0X83RheSgZPkhKMZmIk9lhrOiqTPcNxF4Vsa
         Su5llDhFTl4zc9ZpgXMyV7GvvyNQNTyV2c/vRkbvHZT580eoxf72S3Nw6u3Sd3hnGXPe
         IRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGDchlzjZ9nDfcUMTxD0UYqCVipAmcffFJDXCznLGbg=;
        b=HGJmqMC5pkgXCiBYyUFj3pDGGGl9GEpPhrqkRU5Pv9tXlVpPvk/A5tKALu9vg1asqq
         mVg4os3kvn4CHHXjomeWAJmmXWtcd03YMCHgIOEPkjMyTH31nDYmHLAXMoaEvRgq2F6q
         F38ZCBiuPhebH5kiTBpZvxoBLA8TNTNP9xzDWJ8FhLFEEUwjdRssyiBwDrthCrF5q8YX
         4deHoG9vW5OOk6jkhOKYf9rkdIDVMbv2IwtesqmrtPoyU+3wdeJ4Ksst8Vx+mU524wmm
         ccSuWhDlH8H5yeiius4Da2SnsCZGhjEbIg5YctiI83Nvd0HvlY7BN+FSKg8WbCJmSzC5
         4X3Q==
X-Gm-Message-State: ANoB5pmYRGLY+mANN77nhlGlaAFJbENXGSKnBv901HYjvQpnq6LGBi4W
        KnOX6/UWv4xnQsw45U9K4fg=
X-Google-Smtp-Source: AA0mqf7l1GM+1in+Uo4hp9ulB/JA1vn363dWWJwr6CWQMxFco81Ih0QfK235HeX6iwSbv3baflNMRw==
X-Received: by 2002:a17:902:a616:b0:189:46b1:fe0b with SMTP id u22-20020a170902a61600b0018946b1fe0bmr5265985plq.117.1669262097267;
        Wed, 23 Nov 2022 19:54:57 -0800 (PST)
Received: from debian.me (subs10b-223-255-225-232.three.co.id. [223.255.225.232])
        by smtp.gmail.com with ESMTPSA id mg13-20020a17090b370d00b001faafa42a9esm154817pjb.26.2022.11.23.19.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 19:54:56 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id F20DF103C91; Thu, 24 Nov 2022 10:54:52 +0700 (WIB)
Date:   Thu, 24 Nov 2022 10:54:52 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <Y37rDMB1Q9Gn5g/Y@debian.me>
References: <20221123084602.707860461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m8RHb0XePUCKlKuT"
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--m8RHb0XePUCKlKuT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--m8RHb0XePUCKlKuT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY37rCAAKCRD2uYlJVVFO
o2aKAP90gSYvj507poLMjIQxTK2VLml5E3sz31igtyMEUF58dQD9GELsELsAbxkI
N9O89nMeDAeYaLcdUux5yi1mGOWhTwA=
=8VWb
-----END PGP SIGNATURE-----

--m8RHb0XePUCKlKuT--
