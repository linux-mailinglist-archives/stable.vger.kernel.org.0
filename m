Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A2B6BE03D
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 05:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCQEmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 00:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCQEmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 00:42:01 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7534839B90;
        Thu, 16 Mar 2023 21:42:00 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o11so4089446ple.1;
        Thu, 16 Mar 2023 21:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679028120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3oQztqU78ZT+tQqAztj2/Sep9u0A1fhNGYG5/eDPvQQ=;
        b=ogeZfnLsVIaIST03i51847uLuChbd4rUYQXHvcP8zkQUNHhXRasziBP8SiQS2aM0OQ
         nO9bP5sigHc3SvMCU/Aa5GEhTptjfZg+3xGn4QHoH92pstpIclP8fXcdBwSEXNQ6yHKU
         WqJBoInir0sFl+SUA/qxxMO9El7KlXMs/M/vNt8xs71xxxSViQIU31pMJezxlkWcrDS8
         9HGYcDlv/Ep3QiyyYobCikR//rPTTrxvY70azXXZOketS4a1NuKgAbIXLd1sVdEeBF26
         mKDVdDS5zkpy6u9Y9ncJ9ZMxw5IGM3DInNrrmuu8cyV0F5S/7oBOlFwPyxRmFnXAfrqo
         SKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679028120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oQztqU78ZT+tQqAztj2/Sep9u0A1fhNGYG5/eDPvQQ=;
        b=YO0I8ejo40qA7j9o0GhCzuaNuE8tQw/XX50E8t7H+CFGl3p7YuChgqUTAyUbqb0ksZ
         hdM0xRSIWUo/VbrTZ4r82aprsUVqfgkO8/TepswGoAp6cEer+CLYh/3YBFseHhVWUckl
         PSTDpycEp0b0KwObi5mMf44G8y5rsxOZz5jX8kRaZC6eCNQEDs6nrUomguJsRpTXSMEM
         69Uu42+w6OTYKHLvF5Vhx4+2saB8liF0N7MPquqNt1zxOLobnBqy+cbJSiV2fQYyOT02
         52ZpCnK3BNzjqnNC0XlexO7A5zr8eVnPalWhAW54szTO792LU29+gh5ljW76GC/t079o
         VBig==
X-Gm-Message-State: AO0yUKV4VmNv08cEGzOg+N9m6UnU1EApfX3cjggUWykt5AHFQLnPgNLa
        83ICg6dtv0JhcZ6+tlREGQw=
X-Google-Smtp-Source: AK7set86Aq4DKVfNN16hZY5NYjUMmeTEfvIfcpE3APKapY81xbPAVdTDh1PpgLqvClfg7SbsvPR3OA==
X-Received: by 2002:a17:902:fa8b:b0:19d:14c:e590 with SMTP id lc11-20020a170902fa8b00b0019d014ce590mr4761933plb.9.1679028119966;
        Thu, 16 Mar 2023 21:41:59 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id d1-20020a170902728100b0019a7f427b79sm518231pll.119.2023.03.16.21.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 21:41:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 0E7E0105FAD; Fri, 17 Mar 2023 11:41:55 +0700 (WIB)
Date:   Fri, 17 Mar 2023 11:41:55 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/137] 6.2.7-rc2 review
Message-ID: <ZBPvk+qsO1SNWRZ6@debian.me>
References: <20230316083443.733397152@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hI0+/BKgqinWJgLM"
Content-Disposition: inline
In-Reply-To: <20230316083443.733397152@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hI0+/BKgqinWJgLM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 09:50:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--hI0+/BKgqinWJgLM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBPvjgAKCRD2uYlJVVFO
o0CvAQDJcWVbAMlyRpDPQpIY8SCVINyhjyV4HtUqAMlr0rQhDQD9GXqEjZp3Mvvg
YoUbCKs8wCCgHMfjI1D461zvgZh4zAc=
=7HGc
-----END PGP SIGNATURE-----

--hI0+/BKgqinWJgLM--
