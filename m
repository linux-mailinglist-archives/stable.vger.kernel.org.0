Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA826222F0
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 05:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKIEHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 23:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiKIEHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 23:07:13 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE421E70F;
        Tue,  8 Nov 2022 20:07:13 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id s196so15175296pgs.3;
        Tue, 08 Nov 2022 20:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9cxfSVmbmWsxCHrTZOKpUFB/FL5cKrbFfx0U8vbtN7I=;
        b=as+PJwEKrKD5Vm3Ud8GM5AaZN8T5UpXkoRDEfM3GKXfbOt9qwUSitBVVnFHjSaRQPs
         FTCLTnfJIIUVW31tk+kvaShLFZy4CrPnTKRzVB89l+f3cvToYNzDr5+K8f5qOLqumKj5
         6KqKSBsry50Jgaj9wdfGJyk2pD8m6U6isNgvggZN8CKIcib+0nRxJpdO9/oCObC+5w77
         xap6jCTdsZWHmP+eYcPg9cCScmKAZRd85ivj+oQWOtuKoL9WHYMIteizvxhgcPpLyoWv
         KoE5J5a8GoNOOnPeEk82gwqQA4RXSJw81CL31fu6Mz1ocJy2Cr7YfeHKDO3H4GslXtoh
         MNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cxfSVmbmWsxCHrTZOKpUFB/FL5cKrbFfx0U8vbtN7I=;
        b=ZRe/Wyu7YWzvzZ1ZoisHvvAEf4wqp+Orrk9HFBfFms8CuvyOsL44NedghEPje9aT8t
         W2iXpZrhQmCv+7DL9DJrhWa+8iTpwb82YxL5nYsfikdIReWkklsUSdQ7ITCvMZBoPv5f
         +OPRYNA9PNjzLD4+1SCPd5SNi+5hdq7HXUTJsjbhVau/4QS+u9cKOBJFtR/m4QRWDvFr
         hg/5582+IL0bEwwIsmm3ITL0cJv2lGrv0SuggwwkJEC6a8n7BzCndvL/+mcwEdySw+bD
         9KF4YYgIg3Aa34e/hN/v+pHzoC8kFDYe7PjezCEEXDwPr1sjQKUX0RebMVRN6j8HLJo3
         6vag==
X-Gm-Message-State: ACrzQf2wN9ZpB223lsatUExZ3notz8xHmMCtn0FvX/hSAdNbWCBwH/CZ
        +YUWV9tbp0Jkslw0XnrdmHQ=
X-Google-Smtp-Source: AMsMyM6pwFyzxpO0ah2SgZNV7gtmpimAyctL8DPEQLg/3+WAAwxMmq6zZNF1rk6yMtbR3jFpFdP4aw==
X-Received: by 2002:a05:6a02:20c:b0:461:74e5:ce9f with SMTP id bh12-20020a056a02020c00b0046174e5ce9fmr51693821pgb.294.1667966832593;
        Tue, 08 Nov 2022 20:07:12 -0800 (PST)
Received: from debian.me (subs02-180-214-232-69.three.co.id. [180.214.232.69])
        by smtp.gmail.com with ESMTPSA id p6-20020a63e646000000b0046b2ebb0a52sm6445288pgj.17.2022.11.08.20.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 20:07:11 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 486F5103FF6; Wed,  9 Nov 2022 11:07:08 +0700 (WIB)
Date:   Wed, 9 Nov 2022 11:07:07 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Message-ID: <Y2sna4FGm0GTpkaY@debian.me>
References: <20221108133345.346704162@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FW1QZkd9vEGJgjOV"
Content-Disposition: inline
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FW1QZkd9vEGJgjOV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2022 at 02:37:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20
--=20
An old man doll... just what I always wanted! - Clara

--FW1QZkd9vEGJgjOV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2snYwAKCRD2uYlJVVFO
o8CkAP9ayGb+ZIf+Dkxj4ZDcvBbJqyilffSkG6cbkcKORGmpWgEA5+DAaRS9faTs
7fqEw6sOLcA4/itykQVT2T9ABvcLXQM=
=Gopu
-----END PGP SIGNATURE-----

--FW1QZkd9vEGJgjOV--
