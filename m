Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74AAE6C2945
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 05:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCUEsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 00:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCUEsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 00:48:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDA31FF7;
        Mon, 20 Mar 2023 21:48:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id le6so14826092plb.12;
        Mon, 20 Mar 2023 21:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679374099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hVbAqw/LdnF4B7q1qptxDYLJgQO8iuceCy5zwfXugR0=;
        b=fXQs3M+Dhb9fFSn7V6bEQ7CiuzcP3a84rff2/mp1FifgDYv//VbAM0zTxKjLtLE2P8
         JBjCEBdbrcZJ17TZ/WW2qqk8nI5t/mCFlnxhjbZy3B08UGABZb7r4Rm7eGNzVM8WjqIm
         676XQiahIdUh9xE7ytUQu9VGzewHJSuE+My3K+FsKHBV6Uoa5QCCH5A1oOjjX+tIjYrr
         +1565Kqk9OWrQLIElKDOf2ejk52s5/ikh+sDVR7/9SXQLJJh+6Atfj4SXCeH8pcIAkLn
         Agr9BEyX2EZgwEb6EVCtXgypD6Fhjcctb83PdN6d7SyO8cEj2cRf4W87+SyJK4dxJXeR
         eYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679374099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hVbAqw/LdnF4B7q1qptxDYLJgQO8iuceCy5zwfXugR0=;
        b=cWPO5abV0VA0qmUzd4yWAxdDFOLm521W13Jsg9YKL30AnKbbQbIwTD1q2/U2JfoMM9
         FlugZIoMdl/JW+UwgSBWTq2kAYst6MPCS11pTmC55AKCa0VbSrhBHVTs1ItZ/vRcW8+l
         fp09hTx3Sy0TI8h5ctPQYUvm4AhMDtU0vRjJf+PUMJp7H2vO0y+eqcRwyqnCTt+nf4yL
         f03ycBakuaS6HtA2FxsbYOzeeE5oDyAdy9WmiAE8j2eqW8EF+jI+0Zi0fJ99wqLALIRJ
         CbggBIG+aDvFCa5tn3pebdFAupSUZNIkJdm/oafRx8c1Z6MOiodynVCROpEF6bVwxVyR
         Wazw==
X-Gm-Message-State: AO0yUKVll6v/4oZlX4cGxe9IuJS7dfEgO0K7H1aqLxBQOwjRVXZhUEkb
        4QCRbQqDvlvyiIeU8I1Rp3A=
X-Google-Smtp-Source: AK7set8Vril6rOmAZK4/x/sLA+iWJPepN+L6BDJ8NDL6oiZPoitvnaMqzWh1M1yGAQBKLCA+zxda/w==
X-Received: by 2002:a17:903:41cf:b0:19f:1c79:8b21 with SMTP id u15-20020a17090341cf00b0019f1c798b21mr920351ple.42.1679374099293;
        Mon, 20 Mar 2023 21:48:19 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-8.three.co.id. [180.214.233.8])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902edc200b001a1a18a678csm7604605plk.148.2023.03.20.21.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 21:48:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 7C59210661C; Tue, 21 Mar 2023 11:48:16 +0700 (WIB)
Date:   Tue, 21 Mar 2023 11:48:16 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Message-ID: <ZBk3EHnYKxJFM605@debian.me>
References: <20230320145507.420176832@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CGkXclsmGbFsncfa"
Content-Disposition: inline
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CGkXclsmGbFsncfa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:52:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--CGkXclsmGbFsncfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBk3EAAKCRD2uYlJVVFO
o646AP4+w52xcmXksk1CbKJXTJfuMPckGQWnZ06oqbS6Eklj/QEAk8u/NYufPucH
K0prtOmnPPCt+/jrWPLnQ4JKeQ1rCgQ=
=27Oc
-----END PGP SIGNATURE-----

--CGkXclsmGbFsncfa--
