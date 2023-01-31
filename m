Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A756822B9
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 04:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjAaDWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 22:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjAaDWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 22:22:54 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58042916F;
        Mon, 30 Jan 2023 19:22:51 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d3so13709501plr.10;
        Mon, 30 Jan 2023 19:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vG4HRPGwHOheVVf/QPtVzGGTxbkGE8FSy7eSh3uTxcA=;
        b=eHDZcFPLyZOm5E1L9sYIUGfqk2aeslWuBQgkI9k+9MSz+9mCLxVGeHS+NDyeUGEyjc
         JVuwe4AWhX6ncqv3hBcvMPbLkoTX5RGXx1iq3rPw4V9nCdaIxWkqHcAOkQPRFJ6IAJVb
         gy5t28VggcNRzV7s/jgwoH9dHsB1e9XjbwjE3O8WpQY3QAyKnVyqi6xV6YOB24N31sJt
         gVzq0/poTz30G438VNM6SIpb5Phmiw5GfqCb2JJ+jq+awG2yHZ/TD9I9SFrhrAFPr4h7
         hLH3SG5jGkNeaz1moc4UjZcAQBwJ+GyMEreprCKk4YIPUq0bhie9ICAc6kuEB87aVZZt
         GwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vG4HRPGwHOheVVf/QPtVzGGTxbkGE8FSy7eSh3uTxcA=;
        b=MbddXkdMoH0hv5if7OuZSgdYs9gO7kvD8Y0TGlq46WyLEcp0sOu8nOCgvENSGLs2IM
         bfusvb81Rl5QK3ucdFy9bNoCS9jMILgEFaCvIRoXapdo9IsSPNp12rCXX51Ad6Wz5Gil
         0ZWAvSIid+MDhNFEemtHJGt9jPb1k262lTJt/8tfdJ6FitssQksZn07aru1VTfD7WvIQ
         5icapg9qsR0XI2pB9OUE2eUfowlOSEs+HmtYoeRuZt6j8JBFM5inExfR+ueXfuX4a9UH
         LtbmJWCouWbHqmCTGr+Otqfmb0Da2K69IibfGKAhStA5zU1xmqOX5L0gqWxM0ZNaZDnX
         9EsQ==
X-Gm-Message-State: AFqh2krEtMtNwBrJJTiueo1Ec9P3u1eBv6o9XuzMvUddbUhJzfr3p6+l
        JlmUvtrCv1m3u6v7PKQshEo=
X-Google-Smtp-Source: AMrXdXv7M7/voezgO+LIkFY7sVQESvlLf3yCrzfKpuNTCWH0Jd1xN2jr/T64dYhDfF+GEkz7Nt+5+A==
X-Received: by 2002:a17:903:2292:b0:195:ea0e:3226 with SMTP id b18-20020a170903229200b00195ea0e3226mr47240068plh.31.1675135371294;
        Mon, 30 Jan 2023 19:22:51 -0800 (PST)
Received: from debian.me (subs32-116-206-28-47.three.co.id. [116.206.28.47])
        by smtp.gmail.com with ESMTPSA id jc7-20020a17090325c700b00192588bcce7sm8556591plb.125.2023.01.30.19.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:22:49 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 516D61051B2; Tue, 31 Jan 2023 10:22:47 +0700 (WIB)
Date:   Tue, 31 Jan 2023 10:22:47 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Message-ID: <Y9iJh8u2QpRfsg60@debian.me>
References: <20230130134316.327556078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iLese16q615lvexf"
Content-Disposition: inline
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--iLese16q615lvexf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 02:49:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20

--=20
An old man doll... just what I always wanted! - Clara

--iLese16q615lvexf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY9iJhwAKCRD2uYlJVVFO
oz0OAQDhuo9JyToQsD1sMx4rGrCsr8yE6wTEaAKDxvsnqzBOogD+PqReVsSWFB8x
bm8NeCQCKGZnjnVtEz8jagNa86REEQk=
=F3d5
-----END PGP SIGNATURE-----

--iLese16q615lvexf--
