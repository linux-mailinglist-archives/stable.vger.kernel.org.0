Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20E6BC4BE
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 04:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCPDcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 23:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjCPDbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 23:31:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0582FD536;
        Wed, 15 Mar 2023 20:30:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso260734pjb.3;
        Wed, 15 Mar 2023 20:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678937457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YEj5OBECUBzAdwIoI2YKk6Ne6SPKlmrZMcAm1nJzScg=;
        b=fmwUmHqO00Lbpi0eRp2PUAJm70IGVAwXU+H6lxOhMGtU00LVZjuJjiVzMeLBIuoXJP
         2oeh7a+DnYfmWpUwnaRY7hEsAxYenVTSJkAw80njt5Aq3DmcZRkrzmrTrgQtEIBnp9kt
         QjK0w1Zt7652hnFyZNDqqKoUU0E3vzNv7YZX94DHRrwwVGz827cdr68NmLcxCpfSSB/W
         If+JOCgfIDQEWDOGagYg+kkGSRG90rj4xChuj4ufqa/3qfii9zR/8yX3gQatB/rEKXPM
         gfCzeGCj7ykTAaFE/twfk3nLgrOH7VFN1N5fyOLaL3BMqYU/xfl2braNNdYQvgjuTWWt
         UKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678937457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEj5OBECUBzAdwIoI2YKk6Ne6SPKlmrZMcAm1nJzScg=;
        b=mv2DKpxP041t24NWk1fh4f6hVtSz0XXoFvadc0ZsCwvbzTDibcChr4uhXXPjE7xPpq
         mwkadbIVvIUGbmgRRPAOdnXl9teFieaK1cCw1PXtcmK8wKGmCBdumEe+3J1AO6YBFmqg
         GOheSVg9UOvIV37lFQDRvCjkIpAh32dHJOdqY9f52fBsJZhgN/Pkh0CGnZ2dFjbNyE5f
         AOHCx+Yo49pgin3T+dI8B5oQIqn1blJiQS8NoaWVfyLQRMYDlDBOIPZy/uDrO6MTEloa
         quF+cE/46m+oS/Wu3c1jwbwfn9vSHTyQtnj9ib0SxyQAhGFQ/yclqO7Kxc9JvdMDJNiW
         SjJw==
X-Gm-Message-State: AO0yUKVOh4j0hhpVLxM9ugVZNIoatFZg04Qcfy1p3AQLyWav0ppMUH7C
        WZNZ02I8sLl4NMgZ6rTHf1c=
X-Google-Smtp-Source: AK7set+HAbU6lA9U/X2srZ5Xk4qpX5aEt2KI1YecH4Wupgn0JhzGtuCC8dVFOpYr7Zjn5c22QQvlsA==
X-Received: by 2002:a17:90b:38c5:b0:23d:35d9:d03e with SMTP id nn5-20020a17090b38c500b0023d35d9d03emr1888838pjb.48.1678937457414;
        Wed, 15 Mar 2023 20:30:57 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-41.three.co.id. [116.206.12.41])
        by smtp.gmail.com with ESMTPSA id q30-20020a17090a17a100b002349608e80csm2030395pja.47.2023.03.15.20.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:30:56 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id EE4C6106569; Thu, 16 Mar 2023 10:30:52 +0700 (WIB)
Date:   Thu, 16 Mar 2023 10:30:52 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <ZBKNbLP8X05cvm+y@debian.me>
References: <20230315115740.429574234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DmG69jtXaUvq1CLH"
Content-Disposition: inline
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DmG69jtXaUvq1CLH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 01:11:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DmG69jtXaUvq1CLH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBKNZwAKCRD2uYlJVVFO
owPRAQCfREexag1qiZ0BXF0Jn8/mVjc+Uip9feQfZAHWEqThdAEAwTcEvq9eWgdq
0uz12pCm/DgbLfTRyUAqC/1eXbw/IAo=
=9tHI
-----END PGP SIGNATURE-----

--DmG69jtXaUvq1CLH--
