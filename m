Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA6643E88
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 09:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiLFI1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 03:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbiLFI07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 03:26:59 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4C9FAE5;
        Tue,  6 Dec 2022 00:26:59 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id z8-20020a17090abd8800b00219ed30ce47so3110096pjr.3;
        Tue, 06 Dec 2022 00:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xW0qv9B5+yGxi1H2usCQCP9mQhDaha3ttXysqpYFwiM=;
        b=RWqjk/BXFmfFYxDsYol04Jmm0CeChfX2tO64fKfWjMuGG5AxcA9H8uf4Ksnf//U/qH
         HckTmJT+rsecvvKOSoTVktuED/KpsSE0gr9OAHrVl3WcNNWOrkH9QXBdh4U52YI6X0X4
         YgPMbCfCD0X5WDhBoA/XIsbUs/nyz9SIAx08tfv4gCc9p86CgJTN1toSswKThMRLwLyp
         4/+r64DJgyQU5hknC7ty6rna8kIBffaz0xvYepM7cImKaUFPXpF2ws9Zih9fmTB1RhIP
         GRrnt/L9GLLRQOygyCzplUN8Xq94QyBUYDvS0a/22OV5yxCh06qe8hByy+6RBVcfkBBW
         41bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xW0qv9B5+yGxi1H2usCQCP9mQhDaha3ttXysqpYFwiM=;
        b=hU3kpd5g12XpgV5qur8GqTSPkcQ3Be2/h5/D7Xa7l5xBpkpOuK0mZ/RZIvnv8OyYyT
         Bu1sSzNmsDcbBO7ffIXR/hfPkTp8lA31ICIA7umRQ9pFgjuoOSu1IRT237Nucng48ZAv
         r3Pq7XjFrrUgfmxNcSSYvijOMHRem7qH55cn68Ii5+OpLMzByBh7cYehI8FLKPF9iOZP
         +eZj+RbqG5AbK3ln77bcgrzQIq3kWmsDpqBaxjeqeFM9QjY8bJTpDEDw5zJRPNeRniTy
         DPCoc52IOh36UgqF9oMy1rZ6jJf7CkaO7ud3EKVdKeXYcH7UtKCOo2fKAC3KbNdJV6qM
         FvDg==
X-Gm-Message-State: ANoB5pm7CVdT4YpPYwr21LzHYB18/bLtEXq7Nz4+U5RU0E2TvAKKV2IR
        TL2ubIdyNLl5s4MdYTq4NZU=
X-Google-Smtp-Source: AA0mqf50xOkxd2Tqua6cu4Vr1W0k+sVXxQvVw2wZ2VyWld8NR8SBV/KcCxbR24+f0y2w8HOrWguVNQ==
X-Received: by 2002:a17:903:2681:b0:189:7e2f:d66b with SMTP id jf1-20020a170903268100b001897e2fd66bmr46941097plb.110.1670315218711;
        Tue, 06 Dec 2022 00:26:58 -0800 (PST)
Received: from debian.me (subs03-180-214-233-3.three.co.id. [180.214.233.3])
        by smtp.gmail.com with ESMTPSA id jf1-20020a170903268100b00186b7443082sm11936428plb.195.2022.12.06.00.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:26:58 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 8DF511044D3; Tue,  6 Dec 2022 15:26:54 +0700 (WIB)
Date:   Tue, 6 Dec 2022 15:26:54 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
Message-ID: <Y478znRWhzjlTdHN@debian.me>
References: <20221205190808.422385173@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JCUFucPrhAkQEawz"
Content-Disposition: inline
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JCUFucPrhAkQEawz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 08:08:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--JCUFucPrhAkQEawz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY478xwAKCRD2uYlJVVFO
o4hNAP0a2W+sqrN0HF7z0dWZ4Fad9dSGfr3X+ISCc66H50xZiQEAg1sQzBXK7+yL
6bgCKeWFAQrUeNzsjEZzY0NcDORFNgQ=
=ILX0
-----END PGP SIGNATURE-----

--JCUFucPrhAkQEawz--
