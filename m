Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00F35B00E9
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 11:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiIGJwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 05:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiIGJw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 05:52:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAB0B531E;
        Wed,  7 Sep 2022 02:52:25 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z9-20020a17090a468900b001ffff693b27so12796416pjf.2;
        Wed, 07 Sep 2022 02:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=2Xt+s9pZmyK8kJR/5ao4BTJRlHavZXBHHxxDv06w1W4=;
        b=B3nbx38M9KFZEVmLEvtcwKOIpcJanNg25LA87nnswZ4PtaYeIoYsO42YHrpNaoqphn
         5Cx5C+6ZOkLmf4hLePGi/05xuN8a5OVQ7LMBSmEzBYg/iCRhP4nqi9vWzT7v/40Vs/3p
         e8DtaLaukAwuh5XRDOXv0fSzZ4KZe4NTcq/1FtdlVE0QhQ29mrGQBB75Rp2oM9ah3whP
         0WBeZ/yerSbHxtr0UKJwhA2qbrXxfSe7N6I3udbgAEqdTwhoWgyUc9Nqwxjcz9TA81Kk
         xy4Vovi+o4zou4EFG9OhKXCR2hE3kB/jD3KnvrIgy/VCTG0TneKI5E5DjOjZe0wJ/ZbV
         0zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=2Xt+s9pZmyK8kJR/5ao4BTJRlHavZXBHHxxDv06w1W4=;
        b=FWi6eVZU8ziopRnTn1w/93Bs0uN3n07paEzjEBBJqtmZOMJiXZnRmJtymDIUMys/Op
         j/rgeAIY5s4mHBrExjhk9A2ZMM/QVaqoIQDCUFJ7CqmbBgKQe4DLBT8Wf4G4rQWzWCDH
         EQGSNvkAMYm6uLTnYXBXiWfnLogP6sDgPgkA/1h8T5BNO3wUgMn64xg/mpRHF9Gulf6g
         43W3+BWs1V3Wjf6sdnjakkiEXXj0R8VWHDJZF6EPxU6uEiuZIf/jyx9/67FXQ4EgdsRo
         bw3yM+bRvgMTPvfNAPcwflwAJBgazTYJ623BO2gKrEKQPpxr38uFjKp1xv31pg1M31Rg
         p38Q==
X-Gm-Message-State: ACgBeo2Q0gQWrsAlIaJu8hORr6XCjh/+1mPhgyPNbUeX0AtPCNqK4sck
        5SWlNK/+HmPmfXfLintnZ9I=
X-Google-Smtp-Source: AA6agR5R7/SEzfwCpCLnMXzTOxB7KbAENFIbEXMFpJvUUNZBsKRdmy2dIcrqx4zi3haOZlshZaCcGw==
X-Received: by 2002:a17:902:6542:b0:172:95d8:a777 with SMTP id d2-20020a170902654200b0017295d8a777mr3084572pln.61.1662544344313;
        Wed, 07 Sep 2022 02:52:24 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-14.three.co.id. [180.214.233.14])
        by smtp.gmail.com with ESMTPSA id t4-20020a1709027fc400b001745662d568sm11532084plb.278.2022.09.07.02.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 02:52:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id CEA5F103CC0; Wed,  7 Sep 2022 16:52:19 +0700 (WIB)
Date:   Wed, 7 Sep 2022 16:52:19 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
Message-ID: <Yxhp06l71ryJSkpp@debian.me>
References: <20220906132821.713989422@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/IZusFX4poMm2E86"
Content-Disposition: inline
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/IZusFX4poMm2E86
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 06, 2022 at 03:29:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

However, Florian reported permission issue on pahole script [1]. The issue
is also appeared on my builds.

Thanks.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

[1]: https://lore.kernel.org/lkml/814a334f-c2dc-3880-8d57-8267ee4911a1@gmai=
l.com/

--=20
An old man doll... just what I always wanted! - Clara

--/IZusFX4poMm2E86
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYxhpzAAKCRD2uYlJVVFO
oxgQAQCL9/qs240dUhWxVumqIOx3ZPGy7Z6E8bGVfmkrodeVigEAuq+W0cLdre+M
OZzaAey7zJ87OS9Njrr/HONpw/1dlAg=
=XagU
-----END PGP SIGNATURE-----

--/IZusFX4poMm2E86--
