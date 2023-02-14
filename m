Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8D3695712
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 04:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbjBNDFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 22:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjBNDFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 22:05:33 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1681C5BB;
        Mon, 13 Feb 2023 19:04:55 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id r9-20020a17090a2e8900b00233ba727724so390863pjd.1;
        Mon, 13 Feb 2023 19:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BLeZPtMHf3JMYrRnDoKN8Adh6wZfHafqCrlDoQdGyUg=;
        b=AHgdOKQ4VAwC5odmRl1gZwqDYGasucGiufWH935kf9/Q+eBeVwJ4sqVpCipGSo/Fuq
         w5g2YPBJp9KFDF3KsZO/iCXO+QahQU1tVynBHRHtTAvvrNlA88BVNeFpYJ5YORN4EB23
         mKa6f4JXtuiGQfalom9qOJmZBv0hSCu6cX/YtTnur+sHbCFc7TULHFVA7QshDkL+z2dd
         z5byYZdT6Xi69clqlAFSEY9vEMBIURlh4GberERPNVmFmf4L1M59HXluoYtuOUt6cJij
         sC97myVEA5g4LVWZp3t0ZguvavkIzuAe6uci4Yujbq54LFPZnWMI+mxF0Y42vzx6+clZ
         jx5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BLeZPtMHf3JMYrRnDoKN8Adh6wZfHafqCrlDoQdGyUg=;
        b=MsDVJXoCf6xjQEmRPLc3Fk4bVh4CHKgkTCWu92edzvINiahSSHMDKizGN4Cs/luyYY
         snxxX6XPekN9e0L/s7jmjhblsnWl2JeOlKyFWgN0tgj+57LXBMVooie5/tiEMH3S4ZO9
         kllS+7iJJkbeCl6NGL6FExTN6RkeUD8KBaiC3qv/r0Gr2K45gersxg2uHIJjFjMVl9oc
         CMeyVEI1JruSi1qdpbOSaLsmS8akrOvujpooa5jo3FQ24HhQpxl603RxJuE5ovs39nSq
         ig+jVDQWu86LajqhFLoAMnngJTia4P++yvrgjLTsV5j0r44UvpF9lmtQAyTVjzFtOHUf
         /c/Q==
X-Gm-Message-State: AO0yUKUp0W0r/Dw+pkiuhcDuRA2TVIx7LSeB7q2RsKLlIAL1A3Db6cPc
        ucLS6uaAXRyB2PP0E3fpR1A=
X-Google-Smtp-Source: AK7set+b1nJIxt9rzoS4iHh75uptaPxw7B+uKvt3OMzH38KdM2xcgQGzJYg+CuiCflWEp6QENuoJiw==
X-Received: by 2002:a17:90b:1808:b0:22c:932:2870 with SMTP id lw8-20020a17090b180800b0022c09322870mr753025pjb.33.1676343894358;
        Mon, 13 Feb 2023 19:04:54 -0800 (PST)
Received: from debian.me (subs28-116-206-12-37.three.co.id. [116.206.12.37])
        by smtp.gmail.com with ESMTPSA id l21-20020a17090aec1500b00230a3b016fcsm5658069pjy.10.2023.02.13.19.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 19:04:53 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 8F2FC105423; Tue, 14 Feb 2023 10:04:51 +0700 (WIB)
Date:   Tue, 14 Feb 2023 10:04:51 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
Message-ID: <Y+r6U0WGARzIIwVN@debian.me>
References: <20230213144732.336342050@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YueW8T+Y9YHwfDOD"
Content-Disposition: inline
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YueW8T+Y9YHwfDOD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 03:48:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--YueW8T+Y9YHwfDOD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+r6UwAKCRD2uYlJVVFO
oyUeAQDQpI8CxBKqL+KdTOc/2eQWJ06RdkHSVJWDLUhOCP3W6gEAwZ74cmNdzzIF
7a7RvQe4u5gYQgUebltx9XtTBSA2hAQ=
=i7tR
-----END PGP SIGNATURE-----

--YueW8T+Y9YHwfDOD--
