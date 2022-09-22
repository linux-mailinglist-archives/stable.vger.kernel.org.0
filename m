Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97135E5A08
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 06:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiIVEID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 00:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiIVEHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 00:07:42 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C14B1B94;
        Wed, 21 Sep 2022 21:06:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d24so7633226pls.4;
        Wed, 21 Sep 2022 21:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=6dB2S/sZUaTFjTdxFO8rQ+foHYbjpvQ1FYodQpGLqtE=;
        b=X/Orp/fi8+eVfqSuSIyivUe5yWAUKYF55niV5ayYyP00LpYGctI0Wq4EUCCFwDmJEM
         /a3wwKMkPVv1SLifch7DZSYFgkW359rqt6pb/Cdg03SF6Yxi9uMIjzySTplianUvB30T
         uRSfDo9cTafmyAtUs/w1P0gsogfHm30cR4aShqUFcHDkytKEGmqxHvdMY1WzX+A55xnD
         W8VTC1HBs255kE5UW9wRmb6AML6LIXcs/mgGmgJKs9ZIgUc0QM7OaJovHUu60N0Qbrte
         PrU5iREUyKhLgHXCRi9iudQllNqmws5Ai/hSBOKaStQ4xZPPA2KBUxGvQ1hUYNc6wyiJ
         FZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6dB2S/sZUaTFjTdxFO8rQ+foHYbjpvQ1FYodQpGLqtE=;
        b=mc1tlTvXYCL9SkzB33H036j7uzNt/pDYV5pRLJaQ69m/Bq0K3CuLK1cS230Dq7S5Mg
         6T6zzcAH1wxXqpvkdxfk/kUIFtQp4g+gbEdrRy7EAaK46Q/dEtyrpI64paKE7PvOZMB7
         Zkjtou2S4mBFjrAv+uCdyN6+byMt3pdfK4LjJiP2uKXBCHkFj7A9V7YlA/3zI2Dmzgcg
         VGb29NyfG+zP1osFCeJMPpWVW6Pb/EAYP0BrPDkJeG0HWqao+3PXmcOJag+JOc7TCVTi
         Age2Hi+9FPY3XHiS798Tb4onmTkrrvHSSA35pIKR8xv38ujd1Q7YEDR/DlSFHj0vZ3e+
         +ONw==
X-Gm-Message-State: ACrzQf0uJ+xoiQR8d9s9TBBtq9UBdTE/qvBebcPPuMkw8Y8p+vAMhA51
        HqSRFXGWUB6rWNd8df6Y+fc=
X-Google-Smtp-Source: AMsMyM7/Aifkgl9VHuqXDGnLg0qQkcZfSaMunAwDbPNYI7EVQMRIqeDoVofrst3CYzPwbpxuciiKDA==
X-Received: by 2002:a17:90a:71c9:b0:203:c9b0:3722 with SMTP id m9-20020a17090a71c900b00203c9b03722mr1586154pjs.119.1663819555096;
        Wed, 21 Sep 2022 21:05:55 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-54.three.co.id. [116.206.12.54])
        by smtp.gmail.com with ESMTPSA id jc6-20020a17090325c600b00176b63535adsm2790794plb.260.2022.09.21.21.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 21:05:53 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 2D8AC1038F1; Thu, 22 Sep 2022 11:05:50 +0700 (WIB)
Date:   Thu, 22 Sep 2022 11:05:49 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/45] 5.15.70-rc1 review
Message-ID: <YyvfHSBe5ui8PQ6+@debian.me>
References: <20220921153646.931277075@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MJhhS+EG0jqWe+Rr"
Content-Disposition: inline
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MJhhS+EG0jqWe+Rr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2022 at 05:45:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.70 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--MJhhS+EG0jqWe+Rr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYyvfGAAKCRD2uYlJVVFO
oyZtAQCagZo86cpuqmwuPCh/xItGMtiS1NKE3EnQ78PFbkeNjQD/YfWZhRN+j6YY
AIZBjK5N0QQUDr6ARczt8Xhug+ve0w4=
=1Fhu
-----END PGP SIGNATURE-----

--MJhhS+EG0jqWe+Rr--
