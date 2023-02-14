Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDBD695710
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 04:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjBNDFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 22:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjBNDFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 22:05:16 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241D1BDEA;
        Mon, 13 Feb 2023 19:04:46 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o13so13837163pjg.2;
        Mon, 13 Feb 2023 19:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FDSS6wHw9ey9wN//WaBYBsKB8pK0RtnNk3ZwfF++dV8=;
        b=bjhwSFd+U4KV/bzWiA3ZoQNrADpYg7eEZ/YV9sHK4AmcZDig1/wNYCop7CuTM+jxSZ
         5IiD8iLdluBFtnl7Z8Rto3qK7XUgZG0Zz+TMQBX8N5fZDaLTPgYBVmL0PRKxOWDrvnag
         OVuCyb/Qey90ifvHOfLGcSK85Y1oa6O8aihv1nM27EG+HjqR+J3486MkQcdccXIVXTXM
         8UOJqHxa+jPzC1tspt84IgBBIKTSH5SxgvXqxkoWW0OkP9KSA3Da7F5E59hZOcA5e1hB
         ZQo1ckxfg4Tw2OLhCQQ6FEXxcOlFlBTXxc+NUerMJq2RhmWktZTt1T1kvYp5KBX/V7ja
         QbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDSS6wHw9ey9wN//WaBYBsKB8pK0RtnNk3ZwfF++dV8=;
        b=kjs/os61MWMXC0jVGZCb/T57UqDgg41Zmu5g5MKm4NIvcFsMBygph+DU101AthzsIq
         +6gW77CD6VCo3TL4SWPAZ2eTMb/aB1tj0+Qna0GrUwj4bnPcYiVno8GhfzeWD4KIeGXB
         HWy5QSjfVjkzO99Je0vEF/xvwtol5+5LTv1kp736z9oExlKNkOHmPvTOBIj5uoiTuiGy
         k+CeagDjMAZNNcVIyCVVjERwaKQKTydc7R/9JHrUPwa4qW0FwBfPBZqcWaUgmXbZW7e2
         GXeBBvRqPa4qhI4ouV4hMr9GOvBUrxTNc31fj+2RAHYxYu1I7fPpGglhNg2SW2gHVsX/
         pMvQ==
X-Gm-Message-State: AO0yUKXJsc4t2kZ5xQm6Ie/w+Jq6ZY2SFydjjQm67k2EidMMg3LzaA+y
        b3bd6R6lRFnfSaak84fCKiM=
X-Google-Smtp-Source: AK7set8+8A4GdRfomRat52Sxyuo/pYMtcyROWiFqW34b7AF2S/3Nc6zunxbqUArZwbqJL9aC5IdkkQ==
X-Received: by 2002:a17:90b:1c8e:b0:234:2579:e25c with SMTP id oo14-20020a17090b1c8e00b002342579e25cmr615273pjb.44.1676343862976;
        Mon, 13 Feb 2023 19:04:22 -0800 (PST)
Received: from debian.me (subs28-116-206-12-37.three.co.id. [116.206.12.37])
        by smtp.gmail.com with ESMTPSA id cl14-20020a17090af68e00b00230ab56a1f3sm4327816pjb.51.2023.02.13.19.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 19:04:22 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id A5088105423; Tue, 14 Feb 2023 10:04:18 +0700 (WIB)
Date:   Tue, 14 Feb 2023 10:04:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Message-ID: <Y+r6Mhv6PS1EPELd@debian.me>
References: <20230213144742.219399167@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JMoLuklacFO66+7l"
Content-Disposition: inline
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JMoLuklacFO66+7l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 03:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--JMoLuklacFO66+7l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+r6KQAKCRD2uYlJVVFO
o9JqAP9m9IoW25yZ/rhfeSuiyGtKyh3KDcyBoqKWyI5lbtrtWQEAnDI0idIcoNtC
Mod99G5KHML/9xFQPhJsntmDfxCuMQI=
=RYbc
-----END PGP SIGNATURE-----

--JMoLuklacFO66+7l--
