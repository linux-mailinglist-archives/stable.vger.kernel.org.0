Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2295FAD70
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 09:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJKH0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 03:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJKHZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 03:25:46 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC136CF64;
        Tue, 11 Oct 2022 00:25:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 67so12732609pfz.12;
        Tue, 11 Oct 2022 00:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wd+OsNE6zqh97BOKU0txUIV7KGAtQ5iyptGYKgyWnSw=;
        b=QcRruwiAMxS7K590tgy+ClH5TagGlThX17evPDX8lOp1KEC5sl9GY7X0Z8MqiqOxwM
         v4v2dIbNScfLwu1nV7I3JWv0TG+JjP5r4K2c3ohwSIoK+C6TiK/sSQUtLHMTlUuxnE8l
         xzli+zbZlNbnp2CHdGi88vYQToGBHbksiiFaB1f89/eiGR73xmXewFhrgcm7c/ZWSOgx
         zd7svLOKhZdlV7zpDxtVg8mIUCpYQSVjlFjJQq1F1rJ27/Q1aPUUgqI6lhNVfmgegic+
         Isd9mRbNjaNYpavRq3me0LHEXYU1F+TI0eHNjlao0PoHX9+hiMNM2ziOCFTCXKIUTbik
         xgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wd+OsNE6zqh97BOKU0txUIV7KGAtQ5iyptGYKgyWnSw=;
        b=BxT4pL17mdpi1eRCCC/63vuoMw/vDOAwatG93Viwi8uyfFoP27y/GGdCjnAgSFkDpE
         D004f1TePK22I3PikfAVuF0fhtMaUbEV5QSByLeDCZ0NexRSQ3pRS9C1iXY918IRIFc5
         3omgWIMPDAe6wjrEgZFrQWMQuLYuPjGAeFxFjoLipQcqIEHisI7TUmj/lNicPuwcaTFR
         9SiKFFbWE1ER528dsj5ly1jNa0QQqgalYcR9MAn2FT/mhjqyG4mxD8MJR4y+qt+9pPVt
         COiSSjCepSo6Rli9FI5znPmb8cYBi9vemFf/godEhgKxEF9g6r6IL81VbcZX91pGSlI0
         zRdg==
X-Gm-Message-State: ACrzQf37tTm1TXB74buHCQOM4QWSKDWyT7wZeyq62/LXB7QF1v3rEI/H
        Axr3hNQijC4xhljiQAkxQ4g=
X-Google-Smtp-Source: AMsMyM7ciCGClD3hIDJnmHnwHUkwGrhO9dzEQsE0FcIMtS612OIRipaha9kj3gieBMFiRmFoBTRfNw==
X-Received: by 2002:a05:6a00:4093:b0:563:2d96:8f44 with SMTP id bw19-20020a056a00409300b005632d968f44mr12698175pfb.4.1665473143601;
        Tue, 11 Oct 2022 00:25:43 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-84.three.co.id. [180.214.233.84])
        by smtp.gmail.com with ESMTPSA id n12-20020a170902e54c00b0017ca9f4d22fsm7891197plf.209.2022.10.11.00.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 00:25:42 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1CDBD10381D; Tue, 11 Oct 2022 14:25:36 +0700 (WIB)
Date:   Tue, 11 Oct 2022 14:25:36 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/48] 5.19.15-rc1 review
Message-ID: <Y0UacPPulRDKZFpg@debian.me>
References: <20221010070333.676316214@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FxRAQvLLauovVzdx"
Content-Disposition: inline
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FxRAQvLLauovVzdx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2022 at 09:04:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--FxRAQvLLauovVzdx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0UaaAAKCRD2uYlJVVFO
o4cjAP94keXmukA1+jJJgMNrIJCsr3QjQCKb83BO/vtN/XiHaQEAqCx4FY9N7yOl
RcpttLRUb9JCVjS87Lg+AFAXJpfjdw8=
=k8qT
-----END PGP SIGNATURE-----

--FxRAQvLLauovVzdx--
