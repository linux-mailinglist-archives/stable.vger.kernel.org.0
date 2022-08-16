Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B6059569E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiHPJgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiHPJgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:36:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860567C527;
        Tue, 16 Aug 2022 00:58:51 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a22so8122139pfg.3;
        Tue, 16 Aug 2022 00:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Pgdn9/K/AEvoxC94fa7Lnq0paBMzAMlSw0UYFlts4Io=;
        b=naCxKB8AxV/sHNgv9mx5nPFcF9TSfqyaPBF5a4vZIUwuhIG6YTN+v/82X/5VnbFmQy
         e7kuTBOECi8KBqgh1UqlMOfPoG1vwcwPoXIu9hlElMS4uqZ+uWsct1E2Ai2ba7NQNZyy
         gj70WcdWLnQNJJXbb8oqcpwvI445RTJeqlJzn3YIQjLFhVQt7NdNuBqVBfWZWvwjHq87
         Z700PCbfoY5vkInD6GD6Way7vwrN3SaBBOuV0vecyzY/mswvASvEpbHbv0mtGC+8YPZH
         4dI41ZH9hkmDgRp+/Iq/XRfMHef+quvz7pk3IYfn+VvhyC9IJGQS5iCiV3AQltYHJHOk
         IeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Pgdn9/K/AEvoxC94fa7Lnq0paBMzAMlSw0UYFlts4Io=;
        b=Z10wtrrNjAhbH8mf/1TdURVrFRDctCCZ/uIIRvGSKBcO3qBOH788jNtde+ywZDeBAr
         3PfcwqRcDe0V2KzzhBOUK5D0uJxSnoidglu1TCAQq+4bLOg8uQC9NcJfeOfqyqKOwLCk
         JVU1G4ZaEpMwWAF8ZxHsc+EaFzEC75Oia5rRv3WoP5t6WvQG+EDmMNNZjzgSN2fg0VMt
         ipr1OHNnTSEdikWDof4DTuJH222GzKXwmYqruKdwoSDh+S0GegDlF0WodIGExj6Xif6X
         982LNn+VhCf0ZiDJjCl0Db022lfC3SlMk0jrOHrzwW7J4f4yBLO1QwXZ3Ddn3fp0qsyb
         krow==
X-Gm-Message-State: ACgBeo0FtKMyWFnS1dYZLekebEGL1GkKM0RVIlfCrVwkz7T8VFYFISKO
        hor2WxE3/n0qQXtpyxDMvMU=
X-Google-Smtp-Source: AA6agR7TYrXmuwcnENT/h8E8CwTeCIZLAmCTOT3Btg9cIrbXde8D04uGD+zcMbXS4YJhbHvWZGA69g==
X-Received: by 2002:a05:6a00:1745:b0:52f:83ad:22cf with SMTP id j5-20020a056a00174500b0052f83ad22cfmr20276957pfc.68.1660636724843;
        Tue, 16 Aug 2022 00:58:44 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-42.three.co.id. [116.206.28.42])
        by smtp.gmail.com with ESMTPSA id c83-20020a624e56000000b005251f4596f0sm7747304pfb.107.2022.08.16.00.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 00:58:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id AB397103124; Tue, 16 Aug 2022 14:58:40 +0700 (WIB)
Date:   Tue, 16 Aug 2022 14:58:40 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/779] 5.15.61-rc1 review
Message-ID: <YvtOMJquQHz3ddnL@debian.me>
References: <20220815180337.130757997@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mQmvaP/tevZ0EIjX"
Content-Disposition: inline
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mQmvaP/tevZ0EIjX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2022 at 07:54:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.61 release.
> There are 779 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--mQmvaP/tevZ0EIjX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYvtOIgAKCRD2uYlJVVFO
o1LoAP4qeJ1bwt5qBz9qkOcceAoaNPEw8L+lxV7ri3WMjMnlFwD/UX2UyOb54YuL
lYKbF6b1Avwa9m/qlOgknXGoSV2HiQg=
=O1cU
-----END PGP SIGNATURE-----

--mQmvaP/tevZ0EIjX--
