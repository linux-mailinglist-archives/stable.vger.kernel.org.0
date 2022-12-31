Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07865A29B
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 04:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiLaDrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 22:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLaDrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 22:47:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F295B854;
        Fri, 30 Dec 2022 19:47:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o2so18640803pjh.4;
        Fri, 30 Dec 2022 19:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WZ17yhKWFDqZ+SHQRDJxc5imX3OxMscf0OQsvoIBMJ0=;
        b=YUUeuIyRPRAiwZ4Uj1PPCzN5xynaLcmz4yhKPneT65KMv4YTOyNIXneP+AH9L8Gp7p
         Q0OsMo7knRuYGCDy1RlxdzyDi9Ct0pBvhRzKkWguf7o40xsHPKUvLWg1D6gHpxNrw/xQ
         y/8e2BVgTHcpM1rtjYQa6LOnZW0jBdg9qGKxrm1XbAReYxivRO2HPE5SNb9L2FmDCuIq
         o0CCXaOBN8fbU2PQvCmaJw877fnBT6jyLSWwepyhzvN+MhaS/XLDjFKGLsn1mbgiFUHG
         XNkRa+A8NlW9YyYieOfMDcfSTR9NLyA6rFtjKcJqcokKd1LFLvN+0YcBAi3jSeYuj+lJ
         h/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZ17yhKWFDqZ+SHQRDJxc5imX3OxMscf0OQsvoIBMJ0=;
        b=P0EVuGQDxBK/1sbZvD7Gg5Arb0wab9qTjJPnfI0YaetkAJ/V/t2WJFBakh6aLcILOD
         me2hfEuJK/2CvMIkwpFxf9bmIwh7D4+dVpX73lNd3R0xlf3tSU+VxNZqihwi6Gufyvj+
         18ri0GlTC3X4Cas80iiuezy3lQ6yCm2YvGGqlRzg6Vs/1ShEYAS/Tk36zy9K8IlN1CF6
         9EfUil4UHA9BB8VUkn7uavaXbKAvR4Hy+3Mn4jYXa1OTV2B4Y4BkLll14FrBO2KXhRpP
         EYhi5cI/X1AJ98Hc2YrXhkZbFyMtP9Ytggkid0Hm8TMWjye95K85mDKX7btbp8iuslei
         PUsA==
X-Gm-Message-State: AFqh2ko0bSCfkL5XKobqxJu6O4jR20CGduVnxYZhBJJH+knD6ioXY9qP
        /dWy+wXigiqRYKiHu1V3fQM=
X-Google-Smtp-Source: AMrXdXuJwqh6YlF5u+ffcokw3pTMt9MRkwVQOwRHLfVqRrCDcstzwf/lM31BpGjcW2vUs4wqSiKpiA==
X-Received: by 2002:a17:90a:a594:b0:225:fa96:c744 with SMTP id b20-20020a17090aa59400b00225fa96c744mr20670478pjq.37.1672458437822;
        Fri, 30 Dec 2022 19:47:17 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id m7-20020a17090a668700b0020aacde1964sm12129432pjj.32.2022.12.30.19.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 19:47:17 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id DAE2F10403B; Sat, 31 Dec 2022 10:47:13 +0700 (WIB)
Date:   Sat, 31 Dec 2022 10:47:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <Y6+wwW5qSFrsqFg3@debian.me>
References: <20221230094059.698032393@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aczY2dE2gsUMA0vR"
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aczY2dE2gsUMA0vR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--aczY2dE2gsUMA0vR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6+wuQAKCRD2uYlJVVFO
o5xzAQDrZbiTSMDPBdNuyLOv+1ad51pMftpgbo5ghiSqKTInBAEAzqf+jwoFvsE+
lSfOx2NeuzSSl+7m/BD/O+RaIZrBjA8=
=xQX4
-----END PGP SIGNATURE-----

--aczY2dE2gsUMA0vR--
