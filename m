Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D06E7224
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 06:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjDSENA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 00:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbjDSEM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 00:12:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF0E6E8E;
        Tue, 18 Apr 2023 21:12:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id z11-20020a17090abd8b00b0024721c47ceaso324086pjr.3;
        Tue, 18 Apr 2023 21:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681877574; x=1684469574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fUpoLAyaBnHoLBaSwM9qtf9/wGXRRRACC5BoxLWeyNw=;
        b=EojCyYsat/ZZOwGfDI2eEqUVJUYOnPwystmFz4xB/MPWuI5lkbgjnw/2cIdPK6syN3
         jqat81AgUkOjErKJjeZRTAEou4oYofjhzWajAqx50gojTF9jlY0SDDb92pckxL+3w79E
         tBVRCzDKbuS7z+QOk/T9lpRAx4de6qkkegq54Otf1zw3Cc5aWMKny5QyYhz1ONugjqeW
         BltJ4SlXLPz1G6MYH9FWKkixMHb2pjV1vdxe4FEXX8Avz4XOl28YJgJ33Y5TIb4AVKrR
         TKc3u7kNBbJoeyCehuQ19BroyasUHjt+qtGZLyJj2rpfkZqIBj79jXhmrmOupp4KeCly
         djqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681877574; x=1684469574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUpoLAyaBnHoLBaSwM9qtf9/wGXRRRACC5BoxLWeyNw=;
        b=UTbqDrLQaTjYDn8A9VkzEUSg4MiIHSLw/4JJbXcslYZmSpDgDNpoXyj5k0DNWULOCs
         OXKew50+MQAcMJRvflGMDLgVLvGHtL7gb+qa0KI3JfgmJfrnvDXFxg7No8zL8qSnkMh9
         xnSSjAQXeXkAS8NF1p7yY6oEMigIyQYABMXfTxbtJxTtC15V1j7Rpnt1hhsAEZmWDa6n
         7D7KTlmDMytzIrnr3FGhLqf7q3OgFj5FlJPkph9fvaK93zkuQv8S4Wqw+6povn4i9oCh
         qFrNU8L4mxL5tUsnOYUnzHLwB3Q7Fb7tYTPesWLIYe+2F1HyfvUNREZDt6ka52ut9NhD
         ZENQ==
X-Gm-Message-State: AAQBX9eZbaPmNhwBauNMi9iNkBqZWhBTOmW7OdCIiGau7Ee7XHp4rV/g
        kVR+7hLMBB8yu7n4519v928=
X-Google-Smtp-Source: AKy350YeRvMFKD1SJf6/b3CkhkM4LUy3zGF5EMcN1AhXtI2rivOaOGq2H+4LZ7fvvWaW3A4jHjeCvA==
X-Received: by 2002:a05:6a20:8f27:b0:e8:825a:7af5 with SMTP id b39-20020a056a208f2700b000e8825a7af5mr2184734pzk.14.1681877574398;
        Tue, 18 Apr 2023 21:12:54 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id t24-20020aa79398000000b0062bada5db75sm8730797pfe.172.2023.04.18.21.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:12:53 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 232A31067CE; Wed, 19 Apr 2023 11:12:51 +0700 (WIB)
Date:   Wed, 19 Apr 2023 11:12:51 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Message-ID: <ZD9qQ4mPYGSnCmJY@debian.me>
References: <20230418120313.725598495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6dj4q6pLaDyjfhcg"
Content-Disposition: inline
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6dj4q6pLaDyjfhcg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:21:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--6dj4q6pLaDyjfhcg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9qQgAKCRD2uYlJVVFO
o5PiAP4mOO92addYIrSq+MlTAsfM9ovT6jn+wdG5XCUVAEKMIgEAq9tN0Oedt9IE
pOOGwqivlz6Q0zFV5zeXy+2Zqj+ZcgQ=
=yFq9
-----END PGP SIGNATURE-----

--6dj4q6pLaDyjfhcg--
