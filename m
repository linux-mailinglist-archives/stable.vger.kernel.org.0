Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724E06A7A78
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 05:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjCBE1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 23:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBE1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 23:27:23 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2F441084;
        Wed,  1 Mar 2023 20:27:22 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id x34so15654233pjj.0;
        Wed, 01 Mar 2023 20:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677731242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A8sq97E4LLj418sQlGio/HhmJSoILHKR0ZewV5pABeQ=;
        b=ZXaj9stBfP59NXhlrT4eSv3OR0T27ii6EnM3aWoGLdyG5LcFXPPTafX3o7hBshR/3M
         0NdpveDViNLFyH5cRB4HLAVomNw7jrbouwryny+rH0ENrWNP4yFXNZElL7WPhwiBKFtK
         HZTcQoIGlcinarKTfbS0BvksI9M8Wf1PeNze1zfdcWoWqcLxybw3DhGq81gPL9J1Gjx2
         vAiFD598tQ6Ls9cvnLaJgagWljnCGlCNMSL6YOz5AB3E/M0d76nPY/JFa9o1exR7+DLI
         jaqbgLloijr33H/Fa6HNwxrh1XCTrke4CiKvnSt/43Z+757RjBoAg83yvNeKva7cBjWV
         kdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677731242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A8sq97E4LLj418sQlGio/HhmJSoILHKR0ZewV5pABeQ=;
        b=krctxuCfNfUlO/ooWh1m7llL9WHDg0YXgS26HIMPq2CZdK3Ufjfiq2sAra4sL4GNqH
         KF6eJGxvS36ZulsgD/Gn8egFdjHgG8qBqxJ3OycnE91dFmeDIIUhPZywI6JTF8S1yADb
         l+fIIVwFLaRQLu0E2hVtIpx9hB05K1rSn0gUA/aUJrG0ftz/ZYnpp/2Z0qgq3xBQcJOA
         QmFbvIocyXskAoPYCDfPaN1sb5taOwPazzy+gDbE4wkvcYXWuFxkQW2hYyLNOjw7Avl8
         44dZX8pc5MqCOPUGa/36uRrsq8cTLSAAG6KVxms5kUScmspRTa9vU27mzgpYi/T/uiff
         D+Mw==
X-Gm-Message-State: AO0yUKWwrX4WPeHbXZb69LQ3pmURdKJOr9eGD8e+2Dhm8ubqriMiNrt8
        LvpFUaQmAB7txGxZZWxLvEQ=
X-Google-Smtp-Source: AK7set9oCDyq9E0UIU80iSzEKydP+3Vg+K+pewr2hrWawInDgMGoTmjWIbJTaHrAhkWf/vETMtzHfQ==
X-Received: by 2002:a17:902:c407:b0:19c:d0c9:8fdd with SMTP id k7-20020a170902c40700b0019cd0c98fddmr10870118plk.52.1677731242186;
        Wed, 01 Mar 2023 20:27:22 -0800 (PST)
Received: from debian.me (subs32-116-206-28-17.three.co.id. [116.206.28.17])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902eb4600b00196251ca124sm9213881pli.75.2023.03.01.20.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 20:27:21 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 4DF3E100634; Thu,  2 Mar 2023 11:27:17 +0700 (WIB)
Date:   Thu, 2 Mar 2023 11:27:16 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <ZAAlpHB87vVbOV3z@debian.me>
References: <20230301180657.003689969@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kNky+vExhl07LyK6"
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kNky+vExhl07LyK6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kNky+vExhl07LyK6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAAlnwAKCRD2uYlJVVFO
oycIAP9uweOOeMpxQk+Az3hTQIepVpAWbU6zo3sQmBmF6clWWAEArGy3atPJXcvn
QLRaMSGriCUwhsv8TaZK4dMnsk93SAU=
=pCie
-----END PGP SIGNATURE-----

--kNky+vExhl07LyK6--
