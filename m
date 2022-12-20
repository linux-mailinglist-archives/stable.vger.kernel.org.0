Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1DC651A11
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 05:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiLTEpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 23:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiLTEp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 23:45:28 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7024513CCA;
        Mon, 19 Dec 2022 20:45:27 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so10935360pjo.3;
        Mon, 19 Dec 2022 20:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOeTTXb5u9hnasLHrrUspCoXmjGY8ZJBIUXqDr3S45Y=;
        b=g/cp0aBoXYspAuaHZNL+dWHI0ch9F5RYPvkLQAxzjaHsj7uyrIyu8gOXRJX1Mp4MUT
         s4zKRXT4Oi3VoTepOW+m4mlc+RQcAOZYIjsv63oIlnPLaxV/E+eRIedesfC6IuqQrHx6
         kpeYLzm7pLB7DegV/yVFDYnGc4DYGrjo/TxXlwZNtUWMmtfJUNVJKqhNlUy/O9WU3S1g
         Be8BWwb77KxLWhETyE4z/qhM4+v6j2iZGSgyV5gmhp0GAjSRQg3EffYvbs0Vl7aY4XmA
         7hdMLFu1mWziCR8yIX62ngOk+jCPp4H9nt/Eeym+96AACjVNRH3tEPhadgEZME7Xw3Da
         De4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOeTTXb5u9hnasLHrrUspCoXmjGY8ZJBIUXqDr3S45Y=;
        b=UKUOsgncF2dFgOVuqVGVXmLaJRkikWi7v+zWVld5myavt6nJ1wNO2oZRb/TUTRYToI
         bMZVd9H5JfD7u6jydk3ibQCCog0rj5GjL3pL4COVYlMFcSzjlxLixPydvuXFsJ/1YTav
         n6GSqLaJ+/TQzE9Mt9aBmpvtHHx+ETBpbwgWQ+JyG0DfQnHjTe7lUGxjffF2aIhZyNXw
         yAk/sZCG3NjsbKbl9UV1EJiBukXne0HXZXVrAyaUPXd0gbqF8wlY7sn2B/GGWn+GFXzu
         gxiySKrVizSPzSa0vza4xiHVSeX8mr17qNT8nlqPq3g7Nw0Rh7hiNZg+s5F65aNUD5iY
         H9ew==
X-Gm-Message-State: ANoB5plD/NmF1F+JrUnMBE9xaY7vFPUnL5+EEttkO064NDgb8sSNeEgU
        Ifqyh874eukkJQCZl2sti4I=
X-Google-Smtp-Source: AA0mqf5DijY95PNQc1ctcVyWjlHZmLaJnUxCvBkO72zafsU1LpxqIyWvV0/JN5zt9vLPFPqun4L8uQ==
X-Received: by 2002:a17:902:ca14:b0:189:bbd3:a5a7 with SMTP id w20-20020a170902ca1400b00189bbd3a5a7mr37757934pld.51.1671511526918;
        Mon, 19 Dec 2022 20:45:26 -0800 (PST)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b0017f756563bcsm8125599plx.47.2022.12.19.20.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:45:26 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id F2E70103E99; Tue, 20 Dec 2022 11:45:23 +0700 (WIB)
Date:   Tue, 20 Dec 2022 11:45:23 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Message-ID: <Y6E9405o6FuJaIzc@debian.me>
References: <20221219182943.395169070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kkANSztESN5M85yf"
Content-Disposition: inline
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kkANSztESN5M85yf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kkANSztESN5M85yf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6E94wAKCRD2uYlJVVFO
o5WkAQD6ytjGIzQaUDvMZxCmrEbW6UpI/8g3WPkfIL6YrklMHgD+K67qbgqQTXiV
Az6d3qdjZRX3805CUQ2LuHt4o9/ZSwg=
=SRV4
-----END PGP SIGNATURE-----

--kkANSztESN5M85yf--
