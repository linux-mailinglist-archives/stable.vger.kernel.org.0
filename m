Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777D96518DD
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 03:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLTCkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 21:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiLTCkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 21:40:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD09B11C0D;
        Mon, 19 Dec 2022 18:40:00 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso49412pjb.1;
        Mon, 19 Dec 2022 18:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wny72aPReRMnCd0XeW2CGKHfoxhgRZf/niDzIS7HIgw=;
        b=gvwqRB/LB6onoVmMSOgniy1P3V78tygXvZsXL9aS1YUTqPKdvrbGyHZLh+Gl3HiN9q
         7rldTqoKcXP8q53NKDikwI7acQTxJcPdVFL97twHOP7TowYYTsWfDXrkdUdwA2dNyIcI
         Qicwf6Aa2IqNFT9IYM1EnWDCT/9J327669kv72RVXIsjSDM+fddzXcdRDBUhp0JNCZq0
         4oobvNd/IMextn6OrDRV5Z7GjWKbYFeqae0tiq5TZy1YbbUf0xCe4edfnhrWvNWhlNMB
         sC+SG1ihYQQ6DxXMX3y1LG70f2F24LQ4BP+Ki1kgQBYUI65qXg8+JEjQrQ7H9kcPEOGJ
         3dFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wny72aPReRMnCd0XeW2CGKHfoxhgRZf/niDzIS7HIgw=;
        b=vatjLmPpw1vd2o4QxHxONCkPhkA63MrOCUtTuwLj70j1HVPiR0RK7O+FG9cA0ASA7q
         A1SS7xHK+XMNA7Nh8KJ8COklntmooGMUIs//V9bbkptAtva1wimBAlJHEdKgvqXfNsZr
         JCobNmxaeqmX1fzRckJx7QU8kRJVY+r99UHbaLhdd6wuZulG9rOb+sG5ElPIKTROsL1Y
         cNJenGHBAG0IyAw3kw1+XBd+GEnjeOdbI4xYk06nRSVo4zCyiHrKtj4FKT2MOkTgrHpc
         8B7yXPqfsSnqadQGbhHQmwbbG0aCMk0DMBREbYcP9cieqJBZXAiJJc99dx8B2fW/z465
         7zOw==
X-Gm-Message-State: ANoB5pmeM3YyvYplrBfVc/J1sk+OmSLcnQ5CCe+fTaL2B1gx9avVhmHx
        1/7PdPFzqP1lbZVDCuIPhl8=
X-Google-Smtp-Source: AA0mqf5kAXoy+VUHSK32qiFpAkFGSdd6KsTYnWzXlk2u6Dg4ThI58wlhv2zF4gUEobM85yJoJonAuA==
X-Received: by 2002:a17:902:d650:b0:189:f86:f00 with SMTP id y16-20020a170902d65000b001890f860f00mr41234131plh.16.1671504000279;
        Mon, 19 Dec 2022 18:40:00 -0800 (PST)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b001869efb722csm7914388plb.215.2022.12.19.18.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 18:39:59 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 000021013F6; Tue, 20 Dec 2022 09:39:55 +0700 (WIB)
Date:   Tue, 20 Dec 2022 09:39:55 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <Y6Ege+tgN/m7CDkc@debian.me>
References: <20221219182940.739981110@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Rrk8ZYsz6jCGEj0V"
Content-Disposition: inline
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Rrk8ZYsz6jCGEj0V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Rrk8ZYsz6jCGEj0V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6EgcQAKCRD2uYlJVVFO
oxZPAQDwlWNKOn75ziDIolWJ5XWOsr4sf3kYt8TYiNxbKzPKHgD/XefvnqTXWM6X
0ATr5wznDHThjrbX/8n19Gaalz7n3ww=
=QFob
-----END PGP SIGNATURE-----

--Rrk8ZYsz6jCGEj0V--
