Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42751615FB7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 10:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKBJaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 05:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKBJaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 05:30:04 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D681C9;
        Wed,  2 Nov 2022 02:30:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gw22so2754662pjb.3;
        Wed, 02 Nov 2022 02:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5nsIzuIYmRPwf1ZuO4FYaaeeY7t1Mz4FhjUozOEED1E=;
        b=liDPQwXxbtN8tnlF928S6zo7C5ZUgOLaTZSYzJ9uugzNzBBd9S3RIcwNRPrZje2WEK
         F+WZ6zrQ74pDDX7CKEp61Eqt0a8kBY+Enfm+/QJZqjgynN3ZR5TN8QbCptzp2ff2v5gb
         Eh+//Yqp1ogIeXLLTrPKfqkUiz02f3S4rRb2fjJotHxm5XybNVWdWUMp2jXiu+aM95yl
         0XACOE8khe1AqTP8YPEPLUJCPiAoeputnKTdByMuWINvdjIFES7OWcXhrJkcpIjwa7xJ
         TTBLxy9t+7m3zaLZKTaHOw65+/pjfGqen5ktXrA/jzqDWyutdCALBVEGt4/SEOWFuMW8
         x5iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5nsIzuIYmRPwf1ZuO4FYaaeeY7t1Mz4FhjUozOEED1E=;
        b=XK6PIRzCpNAO7MlnqEebQ10u8clr/peTuNjMUM9Dt3Qr6vdrvzNOkThYBb05KI3soV
         sjBsRKDpkFyszVK4dx3JIgMzbUZde5PL0AyuhCN5bObeYuQuzx582Usd4NLzzvppyN05
         97XxHzH+sqfcM+TfdGiLh4RmQ1zOVAMmgeSkd5P6qLCLwhFWh+hD4VpLIKceWrjDzOt8
         V1xQq/dFeNuSA5b6J1Bvx8rk3ZKV6fisTog4OiDwRNY2fz11LNlQ9zYxyTnCucBc1x+h
         otJa8yOTlPmW+2H2DAZCoB6wqp3d2mdV8tuiVnFAoMYwHxJlGNKHapmCIi9+lnR6xVgN
         DCGQ==
X-Gm-Message-State: ACrzQf36F78MmBWajZFGSlluy0mHa6EodNymavn1E1RKMAVj/IqcWJFk
        S1MCSKPNNuWnAqLQM2iCx5g=
X-Google-Smtp-Source: AMsMyM5dVQhGtDNhyEZljMRIGBm1i3pVK/RxrQ5m6KQv13h3Z6dE975UeuFZluCHGrZ66+AO8Dtn6Q==
X-Received: by 2002:a17:902:ecd0:b0:187:791:ae9f with SMTP id a16-20020a170902ecd000b001870791ae9fmr21909964plh.32.1667381402490;
        Wed, 02 Nov 2022 02:30:02 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-74.three.co.id. [180.214.233.74])
        by smtp.gmail.com with ESMTPSA id k76-20020a62844f000000b0056bbba4302dsm7994036pfd.119.2022.11.02.02.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 02:30:01 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 577F910415C; Wed,  2 Nov 2022 16:29:58 +0700 (WIB)
Date:   Wed, 2 Nov 2022 16:29:57 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/132] 5.15.77-rc1 review
Message-ID: <Y2I4lc3+R7duLVM6@debian.me>
References: <20221102022059.593236470@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JTBO09mxtFwK9BL0"
Content-Disposition: inline
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JTBO09mxtFwK9BL0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2022 at 03:31:46AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.77 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20

--=20
An old man doll... just what I always wanted! - Clara

--JTBO09mxtFwK9BL0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2I4jwAKCRD2uYlJVVFO
o8hKAQCG6KVJzVo38x3ygZsO5CnlD+SIg5aqrvVmUylKTXrltgEAt6cI3ZLhA/jN
XZKXmifVD79C2XscJWyMl0pSfbIPkwI=
=0Uva
-----END PGP SIGNATURE-----

--JTBO09mxtFwK9BL0--
