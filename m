Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962C164AE1D
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 04:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbiLMDTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 22:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLMDTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 22:19:44 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5761B9C7;
        Mon, 12 Dec 2022 19:19:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso2153354pjh.1;
        Mon, 12 Dec 2022 19:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p/hZkUjybg3p/GgHdUa/8u76NjJRa/j8RTy9gYjcJN4=;
        b=MKbpjVIGraqYz6MP1vu8a2HEFdT7KeoPN1RyAeSQLhs/5Ympve/5Waw0eiovezy2Zq
         cZv/5w5tS4yG1hoFVsikRaJ9u60ISaSsAx+PjQFxnUH5FaT2v+BtuVVW+hDf4rynU6mi
         tHDtPwKZd7xRU94qxAdLzYzbU5xkXs39SmZhf1JhXjWn9+FECgaNCRf84u0MZJV3mL9F
         uKbUYnrXCyRNpcxJEnv1t0eM7yPnL6kCwdif2CUVEf2BjEP946qi4xX/5+pYgXqYsUHu
         nrts4o1siRV5vPjDm+LeF0fNCfUdd0jDTFyXpeP+/EOqgydyiqgFSbCz40EtXXO3h2VX
         8OBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/hZkUjybg3p/GgHdUa/8u76NjJRa/j8RTy9gYjcJN4=;
        b=PxKBFnzeS4vKMpPVSTQkD9wxwkquQoOS27RegbPxEsu8HtLSb+/Ly0ZrGz1luzp4O8
         R21H9k+RZ81wcFVIoOx/dulp+qiMdRaqdYcj1vX0ZrfoNbuu2svIUKfglykNFAw+EHp/
         tfL3FiPjNBVXZS5LTjBW1x8s5F9lQY+VTmunqggckBiZX37/t65tS9Cs1y+Qd9VDR10x
         3CrOJ/p0BaSMU9CMw4jNfX8tspeQmILxiVR7wtecI5kjNOvXDKO3gkC1QHL8b9JJZ5Bx
         8DZalWfuwalRbVck9FuS1+ZQtkzh9akWm/GuDkp1g0fBAM03IpwF+1gh8Uo2c8kaidN3
         HkPA==
X-Gm-Message-State: ANoB5plr1t9JTge1zU5lOGRAUqLshLU50q90gwyTomsUYF4VxhkIa/HK
        9TGBqeisW5NRdkNZDvDht0o=
X-Google-Smtp-Source: AA0mqf45zJLm3DeeIXQh2Wukx22/xs3HxcgfcytEXCOqxl3U5ISdo0e3fXZ5oGgwn99e28s6udSjcg==
X-Received: by 2002:a17:903:181:b0:189:9007:ecef with SMTP id z1-20020a170903018100b001899007ecefmr26887039plg.25.1670901583527;
        Mon, 12 Dec 2022 19:19:43 -0800 (PST)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00186b8752a78sm7135541pln.80.2022.12.12.19.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 19:19:42 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 6E765100E30; Tue, 13 Dec 2022 10:19:39 +0700 (WIB)
Date:   Tue, 13 Dec 2022 10:19:39 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Message-ID: <Y5fvS8OaGa1V7bcm@debian.me>
References: <20221212130926.811961601@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TlBFzUeYofK757u8"
Content-Disposition: inline
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TlBFzUeYofK757u8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2022 at 02:16:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--TlBFzUeYofK757u8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5fvQQAKCRD2uYlJVVFO
o6tWAQDVrZjPPvgmFh8PrcxmUxyyPFusa2f6Xve943zXmBXslAD6Ayrwdib/RKA0
DW69t2Vxffm7q2rBdLWwpAbLnxiSywk=
=wAiO
-----END PGP SIGNATURE-----

--TlBFzUeYofK757u8--
