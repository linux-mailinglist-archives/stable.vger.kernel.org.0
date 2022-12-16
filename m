Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C9A64E6B5
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 05:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiLPEcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 23:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLPEcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 23:32:14 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7FC13D26;
        Thu, 15 Dec 2022 20:32:13 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f9so1001281pgf.7;
        Thu, 15 Dec 2022 20:32:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oHCCuw298uC7S+tMrUZ1Er7Xg3PYJV4C5yb/JEiVNoA=;
        b=RnCrxue86DUp4v/CQ/uLrjdjijleouqzV6EAFoAhsHkyHDnTmpVG22/LV6jN79czkX
         jOPjexWjtesLSQs1oO+KVWYLoHaEGTg63vqv7y59pk6dhq2NP7BtmZLMzzVuzym46i+J
         kAzIDljQls6r470dBtCWp+68vxHbFa7Cuama6FQFwLdZG5uBMHkhbVWJzFlY4W/Htx4m
         Dyn7xtnKKGvlrdGX361WzhAxae8AS8PFQKzVqqRDPwPwH0/RX2ZMaFw6mQQSFontIsUC
         mQbM1B+xVYZW1GAyUeQTGxUk+lJq0WPmhEcxmuJseqnTp4MeoeFeaA4xx4AUK097vR8g
         p8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHCCuw298uC7S+tMrUZ1Er7Xg3PYJV4C5yb/JEiVNoA=;
        b=D7XiQ40a0R2sdpIlJ/u0wbquZsDIQzHV93CYfUucY61m4DtsIe4oKJUVH4M5zo85Wa
         26qGLs0i0dI/p2sV2+TKzcIuQ9M7X+3CWui0Z5+vV4aCl7fn9ap7nCzPtm1BN3crTJH3
         L9npY48bf3d9HJTSclgs0j+q0fac55s8QVFVr6fPnQifvx/cHKDY+xhfJ4ZmpUgOeUHW
         euStJymAFJPDAN+IH5RYwzDNwBAddrul/1HPIjus7xQmUFvnuqSY6DrzoDW1V5SrhTO6
         5o4g/wAs2lx3jj5MCejd+d5Tl4CU3I+Ft0VBtUy0Rae8GeZdS5O863U1UBZnOZZK2lEV
         citQ==
X-Gm-Message-State: ANoB5plWHnB7b9knQ+mPFhPYIwUyjr7nc8USefBN7BUWAvYp4f75zQbP
        FpWJ3wH6TRPejVEqhrVx78g=
X-Google-Smtp-Source: AA0mqf7EThoZQ2V9zANsJYr1MDcCbwdh92xbEddue3cfypQWSUeGf4ZBkho2m4H38b77I1g166xTxA==
X-Received: by 2002:a62:188d:0:b0:578:777e:7f18 with SMTP id 135-20020a62188d000000b00578777e7f18mr22783552pfy.3.1671165132698;
        Thu, 15 Dec 2022 20:32:12 -0800 (PST)
Received: from debian.me (subs09a-223-255-225-73.three.co.id. [223.255.225.73])
        by smtp.gmail.com with ESMTPSA id z29-20020aa79e5d000000b0057524960947sm442027pfq.39.2022.12.15.20.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 20:32:11 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id F0D14103CCF; Fri, 16 Dec 2022 11:32:07 +0700 (WIB)
Date:   Fri, 16 Dec 2022 11:32:07 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Message-ID: <Y5v0x5wIRbNj5TEB@debian.me>
References: <20221215172906.338769943@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="R180pMqcGnsqKwiS"
Content-Disposition: inline
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--R180pMqcGnsqKwiS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2022 at 07:10:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--R180pMqcGnsqKwiS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5v0vgAKCRD2uYlJVVFO
o19nAP93ROelBBB1P6C+ieeJtlERdLdkjdze3O1tkcqWnTdnPwEApXh94oshE1FZ
+zFALVEoatEiqZ45KBu38BY9mUG3aAA=
=1cFY
-----END PGP SIGNATURE-----

--R180pMqcGnsqKwiS--
