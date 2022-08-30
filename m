Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0169D5A62F2
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 14:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiH3MMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 08:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiH3MMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 08:12:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B19114FC8C;
        Tue, 30 Aug 2022 05:12:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id h11-20020a17090a470b00b001fbc5ba5224so11634826pjg.2;
        Tue, 30 Aug 2022 05:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9ZJVi3T7yioB+01wpdRTRwpFSnwWRJwEo+YjPGZHIUY=;
        b=Fy1e+jRbBk9i4wB7o5zmfn1pzAWhgSzW0Hsr6NW3t3EnsFJZZNDW7VWkd4/oKY8OiR
         8+CWsA4a1qoIc7bwqJIdeIBmuMUXKHa9nxQGdjeM94S7CX1PJm4Anr9xbVUVyg3X/xLz
         bJavl0SW4vLp9NUbgqq/l6IOZE/THna9iMFOGAOmSgnt3l72eJY+p6LWtyixbE90gkOr
         f2bExEcfvsI3wGciH4JkZvNYAidpZGWwBS8/pz+0S5PRhddJw6d5RuWw/mTG/vYAV8EF
         q1aXklNWwah+MvGp96SlkS3z8QlICwAC2MYxLdQNtcaTPfCF0Mc0F+zdMiPt2b9mP4En
         kfcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9ZJVi3T7yioB+01wpdRTRwpFSnwWRJwEo+YjPGZHIUY=;
        b=TOnAn2uv6WC2ibAYJogR9o+5As0P+Izt/KwQH7KuNbQLGJbdgE61IwPWJuS5iqWZII
         2RrsldJ5A0+f7Xucz5hRdJ7MSGrDK988Vm8QN1tDoW3hbiFTq3qJ9FnWcdnf4DBJoCVH
         9G98GtbwXMzj46yGPTnTOXhWdFeC9WRwcch02bO7aTl4S2uguZJo5+fkVaKS43mFx2Z4
         AdJg1iCMh/XCpzshPwJUnlAxelPSit3ASJymNYOFu9/BtPv6o/hh1gGaRdBWU1/82aFC
         atHxMuwNW7ewqDaW/otflDnGt/sFWy+sjS0+gWs9q1OVMb+6azGeYXPSnPCdZmeBPWNm
         VeFQ==
X-Gm-Message-State: ACgBeo3k0JK6w4ZErEy7JFw+49kiOauR/MkOmcBHgb/fVzGiCPw7jbpq
        QNXIGeCWF0ZN4SBxnpOa6k8=
X-Google-Smtp-Source: AA6agR51/0kuiIgZ0yLcpSEG6ufNSp0NbqKqFaQ30Y/DhtTVIMQGZuFkoolKj4urYHAESA1t2xchvA==
X-Received: by 2002:a17:902:e98c:b0:174:4f67:890a with SMTP id f12-20020a170902e98c00b001744f67890amr17727391plb.44.1661861566021;
        Tue, 30 Aug 2022 05:12:46 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-68.three.co.id. [180.214.233.68])
        by smtp.gmail.com with ESMTPSA id i196-20020a6287cd000000b00537dde5ff7csm8006398pfe.176.2022.08.30.05.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 05:12:45 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 3FE9E103C71; Tue, 30 Aug 2022 19:12:41 +0700 (WIB)
Date:   Tue, 30 Aug 2022 19:12:41 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/158] 5.19.6-rc1 review
Message-ID: <Yw3+uWtj7oEQaMvJ@debian.me>
References: <20220829105808.828227973@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BZ8yMHVNqGRI6kc9"
Content-Disposition: inline
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BZ8yMHVNqGRI6kc9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 29, 2022 at 12:57:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.6 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--BZ8yMHVNqGRI6kc9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYw3+uAAKCRD2uYlJVVFO
oxIFAQCw5KTFWDcLrd/VenbHI+0KPEabT4dQczRCwf9ATbxf6wEA99Dm3LbXsmao
Uw/UJsN7L+Y3pTfgrKqjeXmyEZwDGg8=
=z/Qe
-----END PGP SIGNATURE-----

--BZ8yMHVNqGRI6kc9--
