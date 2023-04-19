Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C914F6E7221
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 06:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDSEM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 00:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjDSEM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 00:12:27 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22FD10C6;
        Tue, 18 Apr 2023 21:12:26 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso1086390a12.1;
        Tue, 18 Apr 2023 21:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877546; x=1684469546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gjRrX7Cr207/2AFkqWjyBdlIptaOSff/aWSeLnlvosE=;
        b=pSX3tpKO8FmwmX09VpJnXV+I00I7NnIGVPms0waR3IO2mRKG6OqORHQzzJNP3qi+WQ
         LyPyZ5TCXOWHMAq0D32Z6IHXaf3i8FpKlM50i7OD/G5E3nROeAiqtcDGihb0R02DgPa5
         oco7cew2fv4erDMMRCYyCha+/oYZbDnZQK9TJJCUsuEyNUi6/LiJJ8kNLdHwJD72JTOl
         Tv5A3flvsjmBg+MvO16MMFN/o2FhuQlh+5FwR+Tluyg4p4pRarFQ5V4L8oY0bd2lk3Tv
         QfrubJsxhPZnB5r/SQIAgP2DNsEv4s6uvHffR5Q8UbSSv50tHFLdKmbOxtE+jbnGaozi
         ytIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877546; x=1684469546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjRrX7Cr207/2AFkqWjyBdlIptaOSff/aWSeLnlvosE=;
        b=kokH0Wb4EnafMvS8WbvbzRRybl3rAutq7BGmK5Aa59cDmrDYVyibV700oGNc8Nr788
         jqw8qzQrWEHqxYdxWE42MlDfjXX8w0F8+ToJNgldOKNeMLHc1kcla1BhWdybXxbRMIvn
         gB0LymoC1iEOxLYnXHRJBKes5FhyilGR0sTTUuS5/T1BkU+lCHQD7spbb8X5NQO6evsz
         tWduAAwDhEzpH0dFBK2fGBg0Pz0/RwymqjmYwjXJa0SsN+QZm6tmTnTnWPz06F+/jyXy
         nFJZjF1WN7blHJBrT8qZcK5wwr+qFzvF3dVxOV5OuP9ugsXOPZY8uRyW21uVGaPdIRhM
         FkeA==
X-Gm-Message-State: AAQBX9d4C6OaeGscn4k+Ci1ZBXZQsYdMSV+3ugOK9m5e/Rzvg90Qn6ir
        CQJLZEFXHdvu/FYAYIOUK/Y=
X-Google-Smtp-Source: AKy350btQkPuS3Ev/1/TgR6EB9ck80efR3JIIEw8EW+AVP/qR5ng3lMivCW6MxQizDseiv5r1Vf7IQ==
X-Received: by 2002:a17:90a:5415:b0:237:ae7c:15be with SMTP id z21-20020a17090a541500b00237ae7c15bemr1589931pjh.30.1681877545723;
        Tue, 18 Apr 2023 21:12:25 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id i4-20020a1709026ac400b001a1b66af22fsm10337208plt.62.2023.04.18.21.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:12:24 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 76DCA10673E; Wed, 19 Apr 2023 11:12:21 +0700 (WIB)
Date:   Wed, 19 Apr 2023 11:12:20 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
Message-ID: <ZD9qJA4yjfZm40uJ@debian.me>
References: <20230418120313.001025904@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/O/UuFJ8aKeLPfEe"
Content-Disposition: inline
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/O/UuFJ8aKeLPfEe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:20:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/O/UuFJ8aKeLPfEe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9qDQAKCRD2uYlJVVFO
o/nMAQDqu5td2joHEE6hPbbI0+QsBxXHW2LNzFaogzTJEb5uswEAsmj4JGK4Cyw0
cLnLHas2wPN6IbVDbOoIKvLk/u+KCgQ=
=EGr/
-----END PGP SIGNATURE-----

--/O/UuFJ8aKeLPfEe--
