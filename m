Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E56C6A7963
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCBCQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCBCQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:16:12 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D265C22A22;
        Wed,  1 Mar 2023 18:16:11 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y2so15360969pjg.3;
        Wed, 01 Mar 2023 18:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677723371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2VUOzZC8E/+/G5TdOBz+TuCIYP0geCPHncFQohnP1XU=;
        b=FG8tS/nwvLR95cSO1ypWRXq2lEU/1L27rihfn+18Giib1dxqL8ajD2Xz6W6N160iaA
         C771+TUlxxzJzoYh9ROClGNMtMyzcM0C/vzE7xSPiZYmroFE+kvSHjCVP+AqPbDfHeqG
         vEjdJUCBv9Xp9VhTEtVHRItpeN6PCDppfMyRVlpLXwfw4eCUIKDGzJHaC/ym+FHfLJSg
         2h6XAROXUXlOy+bSSD6WD+OhoeK4EnMgOZJ0uV6V27F1OcEat5Zi5ZEjLr//+RjuHmER
         G2k7lAu+8GXBO0dxj0YXJLFlQcrHQhq99VYaFvCh6e4D2PlsKnXBUqFvP1ylR6L2qYwn
         0jgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677723371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VUOzZC8E/+/G5TdOBz+TuCIYP0geCPHncFQohnP1XU=;
        b=mNmMiobuKK/rXRMwpf69Ch6kBIA71QmksTLqSqYGjXZ7hNrOqS9Xa+H2RKosXUacXf
         hX+LCTQzGrJXHvHuyrI7TAibDdEdjqbjymimuCMKbsYrE227eD8xRb1qnPDdXUDCxg+T
         8KkGW7ebH+vsfORB8pVnqBFgNsPQs+nidciQAYJMmV6DTMqhhgndQaS9QmLSps5iaVFw
         iYzTPlWCJqA2cMab7AE1HuwcyMJjWWrsxAP3gdwa8aBnpMHgJOv8AROaqw1BaIdZk0+/
         boLue2/e5uYLTOiH62exGfeFcUPol6hh8sMsARhz/CqjoYEmTWIw/IB/yYXPjgU/bftn
         4oxA==
X-Gm-Message-State: AO0yUKXVrmRs2xu2Ita9k+3oxeeSlxOq0ke9EK7yge6SDl2lZnMgrvMM
        8W7ig9rJjSsf+oDpfCw4rug=
X-Google-Smtp-Source: AK7set9CosDEYV+jEI02TGKSzccsaBi6Jl2hlONAUUUBHRiZaApNZ5arudmNgY3tZrsO+pFa7P3K/w==
X-Received: by 2002:a17:902:c401:b0:19d:297:f30b with SMTP id k1-20020a170902c40100b0019d0297f30bmr10534352plk.19.1677723371216;
        Wed, 01 Mar 2023 18:16:11 -0800 (PST)
Received: from debian.me (subs32-116-206-28-6.three.co.id. [116.206.28.6])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902d70200b001933b4b1a49sm9081758ply.183.2023.03.01.18.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 18:16:10 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 63B96105DB0; Thu,  2 Mar 2023 09:16:04 +0700 (WIB)
Date:   Thu, 2 Mar 2023 09:16:02 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <ZAAG4uXu3hfbEIje@debian.me>
References: <20230301180653.263532453@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="v9pCEYeFrmhTjDUx"
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v9pCEYeFrmhTjDUx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--v9pCEYeFrmhTjDUx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAAGzQAKCRD2uYlJVVFO
ozApAP4ggLOYYBw+vIOsB4quwoCju0gdK8VfzOlf+cRIyA2IEgEAvgfIabfjsRIl
L3IwQqseOaMq+y/9CwOssn1NwOQL9QQ=
=zK56
-----END PGP SIGNATURE-----

--v9pCEYeFrmhTjDUx--
