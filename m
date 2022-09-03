Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFA15ABCC0
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 06:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiICEKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 00:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiICEKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 00:10:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563A23C8EF;
        Fri,  2 Sep 2022 21:10:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l5so3672804pjy.5;
        Fri, 02 Sep 2022 21:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=r84HFZkccUaYxXvM6ffE71pSzkEJB1JiTaWDdFI/JxQ=;
        b=C5MfrO1BY1KiK8U6JzLrqfVebZxALepPdQ9593bpS5te1fjZQabFuGphOSYrnOin+n
         MUM6zDFeyfoyPRN8Z5Q0P+aS2p0PeRqyjZubCQgHgshZV5OrAQjW9lfc1HdwkQCT3gg8
         KvaA3fWjLXjFT1QtQf/EGxlb2edpQgmnbK0OBtWPrhCI85xmIWvyGE5AKg/3UfKXAaVx
         fLUi9KmlN6NzMCiCyrsPw0Td/nIi+T0YSTZuFzRbIa6Nifz5wmHcYTEqf6yjsX8G7Qz4
         j9hD4pKRUqnLMKDbzi4gkYKpvXP4550VbR7cjFofTGsj6OFN0NHK5qgJzkuS+jtQim5a
         BEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=r84HFZkccUaYxXvM6ffE71pSzkEJB1JiTaWDdFI/JxQ=;
        b=wT0AqLOFMrHevpE2sgNm4HOFaHs/83ZTHa0cegHSrX36cLTZfyNfxkBdGNwe6fcqia
         IHcNsai+TAEAsLuGcdr6btX59PfBVN6TndynkBOcfrL6JrAa5+her3xfSXfttDRKEb05
         lOjV9wqI2mv+5qdTf+0RbpkruSsiUIbfsxSknrOx7eKAT61lwf0/e2aPSiEKpB5bgzKR
         K4k219qs3t5+w+jXHlUUv5Kg+83EqHcaaPO6RrYmy2mNM0w7sV6x96vIKWna9sqlr5GW
         B/9NhRBkX9bmYIhNMMDIJWAvOD/UxbXz3IonK12mfxthWAX//aGWFxuRV/cGCSnJiTM2
         knPQ==
X-Gm-Message-State: ACgBeo3RoP++IFPGZK+Lu4t+GSrOaGTWi7GYRgBgANEqZFsAUmse/663
        o+TGA/BKc6h9sQ/G7s3M3N8=
X-Google-Smtp-Source: AA6agR6tQ3PDFiAsBa8QPuN9Q/RtdDLNaMAKvO12FPgGta6FIq3eXB7290w1VSBf0uqyz6Fd6KUiIA==
X-Received: by 2002:a17:90b:1b0f:b0:1fd:e29c:d8e1 with SMTP id nu15-20020a17090b1b0f00b001fde29cd8e1mr8294675pjb.118.1662178210092;
        Fri, 02 Sep 2022 21:10:10 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-88.three.co.id. [180.214.232.88])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903120f00b0017508d2665dsm2525538plh.34.2022.09.02.21.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 21:10:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E576410024C; Sat,  3 Sep 2022 11:10:05 +0700 (WIB)
Date:   Sat, 3 Sep 2022 11:10:05 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
Message-ID: <YxLTnTHpP6YxpNPi@debian.me>
References: <20220902121404.435662285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="34utSIO2zxgtLw/3"
Content-Disposition: inline
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--34utSIO2zxgtLw/3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 02, 2022 at 02:18:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--34utSIO2zxgtLw/3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYxLTmAAKCRD2uYlJVVFO
oxRCAQCFJR64NLywovtHbRPHxPWQNa/V4GEraKGLpD1qeKzJ/AEApxfGuD9K/G4C
bkWjTn502cRfrshJPkAXvltKFnXWQww=
=ph7l
-----END PGP SIGNATURE-----

--34utSIO2zxgtLw/3--
