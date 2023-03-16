Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073396BC3A8
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 03:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCPCPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 22:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCPCPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 22:15:10 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA70FF1B;
        Wed, 15 Mar 2023 19:15:08 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id bj12so285595pfb.8;
        Wed, 15 Mar 2023 19:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678932908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B7bwEIX4vuGYFkEKBEddYbRrI/6fE8qsxCOF1TIjz78=;
        b=MZ03RBEKnQleGIRX0tFf/7aAsgCg0aOEi+allnDD0ps5aEj/LL5by9oSiYzg3X5BoS
         7Eh/WxIWa1d03oXwQzKQrUpcJ/x55Cr+RIzzaW4jOBtsaVZrDTzHbEuXrx0DqVmmV+BC
         sf6f1nGnIG2HFe/1683wMFhM8F+FjPNWvGCOiTW4XB4OiekKhz31SJrKy3N5KjFmgZnX
         TrnCO5akLu1r3YaSVEhhu/pXEDzemJZJL28r5PhfA4MujgIOLY1VXcjOrYmNy6LO5BiB
         UGEp50KUbok0U9FHZyqFgdzg/WBIhYDt8yAKmktJP9quFNjOhSnj38cIiFRDQEamR4rx
         /NPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678932908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B7bwEIX4vuGYFkEKBEddYbRrI/6fE8qsxCOF1TIjz78=;
        b=LxkER4+S8WBFxtIE8vwAqHU7o/VMGHmvKpvQaTGK7w4t2cK0YqzhVWJxiQuINN1db8
         zzv5apMfVuoMD5i+tDGafjH05u81S4N7I5fZqGOp+ItYOkImsWin5gXHYQ41pyrr1TrR
         dKhpPWMSBEkgaP++bcLgCRwOqKCHfoCSHfXUlR6rzsAfeHr4V7gSaezEW/AUlWPG0zHM
         cJXh66hacX/sC8ri7ic9w2R7mC4epFEV1NZZKlb6oWrTMu2r40gxXPQtn1ue3dWNpGyL
         TU79iRK6CbhqP+6cfO4h5w7+QlUZYgTjaG8rCPCDPXeGUbmJVo5AIlmuR0ai8AR6HS4A
         Az4A==
X-Gm-Message-State: AO0yUKUGX47eB31QERDQGdtz5pqpnjo6+KL6ajN8uS1FCd6tYeknaqT/
        wINHpkL+DuE+PuQe8h3Ewlg=
X-Google-Smtp-Source: AK7set9oNZv8zbpLYiKmMBPaOe/q31opMo3qYB0nAKKtSzmYV91xcpAYYxunESUE8BeohVrmbjmZHw==
X-Received: by 2002:a62:3803:0:b0:624:894d:c494 with SMTP id f3-20020a623803000000b00624894dc494mr1440829pfa.19.1678932908244;
        Wed, 15 Mar 2023 19:15:08 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-41.three.co.id. [116.206.12.41])
        by smtp.gmail.com with ESMTPSA id c26-20020aa78e1a000000b005809d382016sm4192302pfr.74.2023.03.15.19.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 19:15:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id B407D106570; Thu, 16 Mar 2023 09:15:03 +0700 (WIB)
Date:   Thu, 16 Mar 2023 09:15:03 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/145] 5.15.103-rc1 review
Message-ID: <ZBJ7p7JqL8q8fo92@debian.me>
References: <20230315115738.951067403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iU1vQcO7kNtDkCfI"
Content-Disposition: inline
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--iU1vQcO7kNtDkCfI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 01:11:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--iU1vQcO7kNtDkCfI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBJ7ngAKCRD2uYlJVVFO
o6ISAP0ahzMlGtsVKbIpNmx9d++6FDsnvWf++vafRF30NHWxaAEAn43WKgFXKDS4
NSgPoTG3I7q9IbunBDnucYR/ErVq/gI=
=kfKo
-----END PGP SIGNATURE-----

--iU1vQcO7kNtDkCfI--
