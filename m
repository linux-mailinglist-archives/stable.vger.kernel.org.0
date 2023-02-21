Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7F069DA09
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 05:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjBUEKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 23:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbjBUEK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 23:10:28 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A28241C8;
        Mon, 20 Feb 2023 20:10:27 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h14so3802280plf.10;
        Mon, 20 Feb 2023 20:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lXyOh2O1dEJnjqw0oc/4l4klbePXdkEgK9fd88+a/14=;
        b=GZVuSZKwNkP6wAXsWXjVlb2muEXBGY9KNOS40zvN1LlFahjUvM+aVuaBRBoLuWbvTl
         Nn1AqEmsqPbsjG1eUpwBWZ0rI1VTfnZjnk78xnMNkxm2n+EQjhIDU575N/6mL+Zb0+8Z
         TTwvp/SXd4fa/LphYvilqnSnSVljNMhTdEZZAif0BYLcmrG55W/eMleJkLXH55J2INP7
         0DFr5ffeSC/Ilvp6iavY6pLoLJUO8+JC/p6oTqGmyhvnW+FSTZCnome5gcIWqZorUufo
         G0fErA/qlrr4khbUQy4FXhSt+NcwBiuJ8KF4HXJqP4nLvFCPhrdVxNdvAFX48ixmoEa/
         iKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXyOh2O1dEJnjqw0oc/4l4klbePXdkEgK9fd88+a/14=;
        b=tDU7/z0wOUas2LYCTDZbXeaB7OWKRUlAan4Z5qW34plcSYvKTlWfMIeXR3FgvFltvP
         EwolPMPs/LGJdLxAmj2IxP9Sj6vqON9C8J3NlC49tMPsg0lImF75lr3WVmEHtO9G5R0R
         /dADdLF0pqfjU8PcBjrhP+gASGPJxBxaMJmcKmMxDjDQQYSsagSJ6Cde4BOG6cDZQuKu
         GQUOpvS52oXR7FGT6Sp8Z6JFZX2HQCQcEqc9J0ZXKWHHkyVZjNha6AJyfPHHikABpyrq
         plxGi8Wii3e8++FHQSK1Q4DPzGavCc+SC1dT9D2dJwW9MMedKmU3AosYwDkToFxKbp5f
         aFIw==
X-Gm-Message-State: AO0yUKXLZ+WToTkUwDXaT3VhWsZVDaRKvz1yt6XOTbVoqRIjxLD3wMBR
        YagTy53VIAI4+9EpRxhj4/U=
X-Google-Smtp-Source: AK7set/7F2MOp2QnZqhMrucReUtUIlX6KUK5DW0wQnKJWjeznQmP3a00u2fH3Uwms5eN+oHRr4T4nQ==
X-Received: by 2002:a17:902:e5d1:b0:19a:b4f1:a847 with SMTP id u17-20020a170902e5d100b0019ab4f1a847mr3143353plf.8.1676952626812;
        Mon, 20 Feb 2023 20:10:26 -0800 (PST)
Received: from debian.me (subs09b-223-255-225-230.three.co.id. [223.255.225.230])
        by smtp.gmail.com with ESMTPSA id c4-20020a170902c1c400b0019a88c1cf63sm108073plc.180.2023.02.20.20.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 20:10:26 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id EB7E5100981; Tue, 21 Feb 2023 11:10:21 +0700 (WIB)
Date:   Tue, 21 Feb 2023 11:10:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Message-ID: <Y/RELV4ktxMGtBEn@debian.me>
References: <20230220133553.669025851@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HK7sqjx6A7ub8tOC"
Content-Disposition: inline
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HK7sqjx6A7ub8tOC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20, 2023 at 02:35:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HK7sqjx6A7ub8tOC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY/REIQAKCRD2uYlJVVFO
o9e4AQDf2EDmOgDW9C8nNuVq2MwBbyrBWCn/2qhVvJ1axc0I/gEA5IFoszDSs0Ps
SqfrQOgTCChE1yLceiroWVWQ7ONAJQ8=
=/vMq
-----END PGP SIGNATURE-----

--HK7sqjx6A7ub8tOC--
