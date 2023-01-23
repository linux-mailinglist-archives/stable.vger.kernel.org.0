Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548ED6776F9
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 10:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjAWJDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 04:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjAWJDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 04:03:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A719112F31;
        Mon, 23 Jan 2023 01:03:52 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so5946996pjq.1;
        Mon, 23 Jan 2023 01:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WESsZuzJV1dAx7+aN9jSf7iCBxgIoRzQOZDBKmCzdtw=;
        b=RR3ViW5YU1+SQdjA4chAIWv7hcdqlUCrzpD9Xt9VqPnJoqMF9sECkRg45umfIKVfoA
         ufED1owxsRzO0IXg+qGSedaqwcWHZqCwHzzrXvEOswlaox/DTwQbz3hm+tpti/DtXKkh
         w8+WxmWFWiaNY+CT9+y/tEB0lpBrOyuJCLkF3wudp+2ZaVcf3IdVjDVAAku7QFWU6uUK
         5wpsED6tsAtBksz5hYSAqKXrMmU2nUloDxu+CfMXdxLn2NsEJdF3tyZGqHKXrjlhJFJt
         ipuPuI71hafA8F6a10RTUQdqKs7WcsKm9NI6YpDnRrinSr+QaOtpKxIfetv3XJ0wOeFz
         HeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WESsZuzJV1dAx7+aN9jSf7iCBxgIoRzQOZDBKmCzdtw=;
        b=hYVOLoNOoyNigrPK9hO8Rfee+M9Hg5SHgyqwRKzqunJd2f2O26zrxlMPHQqdnHaT8h
         b0MyX3EljvQjsxiHn+kfLZxGotQwg3NDfl5A5QUHjNBI1/ibJcPYO0LwPb+EPKOQmTUf
         PLba/KPU8hK/U2mD0AhRV4j/qqy3A8mfNIuhvFCW9KGfB7vUWBKfZaOf5DRiCVibI5hK
         5eq6oZWT67QpxjmqxMAX/EmeUJQgRC11LCBFGLSdINAdbvk8DPcdlC962z3qvD8pEiGe
         LzlQcAnpiAGCmef4r+c3i906+Bd+DBYLIPjvj2uSiGpesP6H/Gk10SOiPLLz6lJ1bdVx
         ppTA==
X-Gm-Message-State: AFqh2kq7ebf4douJ8CLQh+1VnmR54rfOY78jxHXw11wptHtnidl/vPYv
        +AibIlBYGmRqiJo8C5xJuV8=
X-Google-Smtp-Source: AMrXdXuqFbGb1Mh2D0G/HFfZD7JQY2VbSVrp7/K5OHmhOpCnnOL6+m5uED29yN2dpwJ6c+aiZyWG6Q==
X-Received: by 2002:a05:6a20:6913:b0:b8:8027:13bc with SMTP id q19-20020a056a20691300b000b8802713bcmr25021230pzj.8.1674464631967;
        Mon, 23 Jan 2023 01:03:51 -0800 (PST)
Received: from debian.me (subs32-116-206-28-53.three.co.id. [116.206.28.53])
        by smtp.gmail.com with ESMTPSA id m7-20020a170902db0700b001947b3ec2d7sm17309364plx.307.2023.01.23.01.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 01:03:51 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id E61E710504D; Mon, 23 Jan 2023 16:03:47 +0700 (WIB)
Date:   Mon, 23 Jan 2023 16:03:47 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <Y85Nc09Soi4VIj5Y@debian.me>
References: <20230122150246.321043584@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zGnh1QnuMJs+SKK2"
Content-Disposition: inline
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zGnh1QnuMJs+SKK2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 22, 2023 at 04:02:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20
--=20
An old man doll... just what I always wanted! - Clara

--zGnh1QnuMJs+SKK2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY85NbwAKCRD2uYlJVVFO
ow8AAP9JsIEYbc2FDcGb7BU9sSq7AxlqBDwy1eB0vaFt2MjpzgEAq3HCLRURsCbG
4IJLuJ7bXZgwRGT+AZ8aWvfy+WFqOAQ=
=yCuM
-----END PGP SIGNATURE-----

--zGnh1QnuMJs+SKK2--
