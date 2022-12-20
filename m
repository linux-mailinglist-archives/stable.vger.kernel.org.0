Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32C9651A0E
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 05:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLTEoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 23:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLTEoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 23:44:54 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583921275A;
        Mon, 19 Dec 2022 20:44:54 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id n3so7710421pfq.10;
        Mon, 19 Dec 2022 20:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jscwxWbGTQh3V/X3HM7yeZTkdq5F9CqnGRpZa3D6+1Y=;
        b=Xmgf/xB/3OC4XMY3JxFpqlKM9ywdNrKN7cOkc3/EydfooJ37CAxHQjZNhSuXccUq+K
         S9xKoVx9z7F36Ii8SdTpZNNlRrFgN+LuwnDmPJhyMlYqgyezFBjYoVDb5tvtTydrxdP6
         kGD/QF8Ffc+kV2Zo7hpAt4e+6Dn5UBCr22x6rzcsCXRypyloE5QwDYIlCe3xkDeO13DG
         QG1VswEDDCcNqLvjIPMNi8JC6I21vMljFUWEMDFwaWgCpG80TgEqxPUIgqtesPLQsZ8f
         0OP6vzy2NDmsmlKYu1UzlOrx5KegYk8fkfy95049oFuEcX3LDCSOQN/A3e8J6/d53ve+
         f78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jscwxWbGTQh3V/X3HM7yeZTkdq5F9CqnGRpZa3D6+1Y=;
        b=TqPbKXxzWUJQ1yDsk95BZ3XwE97bh1NuR6GFq0BG/0QGGwgyaafuHLgQk2+5m6Niau
         12SBZdlDr81tsCgO4qFCjGzJaUzzOi1vwUnosp8QgenyKWGFZANszlH6SDVj4t7+MBMG
         l1VbAkPrsRBXUdioKydGOLa3uAzSJRBnTnF9OGdyQOtHdbfavHqBO7vbgNkUX4C0Ng8o
         46c4JRqrAq5eEBtvnMj4L2yt0KuF7PDOij5GmfBW/8eBS+aTM7XgcolfOB0aQIH7sYs1
         MpXyTYfk5nxfpzopgfI9ltC/+Rkno1pkpH7tbEz3aGKvucWawVOwU9CxPOGGB/jRuXNb
         LBIg==
X-Gm-Message-State: AFqh2kqy0Bda/RwcBeIwKCKBz6ZWUQpEkI3GVKSVE+DRh0hWuO7+egVW
        bxmIcgiRk3a5YnIUQ4RfRRY=
X-Google-Smtp-Source: AMrXdXvgkFWO4kBOJJKM9rtchi8/oud6vBwnPtroYv+0ygbi1rUywEDbaTAws/QRLdvUB+CfQwfDlw==
X-Received: by 2002:a05:6a00:2a06:b0:577:3523:bd23 with SMTP id ce6-20020a056a002a0600b005773523bd23mr12612539pfb.27.1671511493814;
        Mon, 19 Dec 2022 20:44:53 -0800 (PST)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id x123-20020a628681000000b0056d73ef41fdsm7536561pfd.75.2022.12.19.20.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 20:44:53 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id AC79E103D28; Tue, 20 Dec 2022 11:44:49 +0700 (WIB)
Date:   Tue, 20 Dec 2022 11:44:49 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/28] 6.0.15-rc1 review
Message-ID: <Y6E9wVf3X6rMXdm3@debian.me>
References: <20221219182944.179389009@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="G5LYBMy45k6QnfAB"
Content-Disposition: inline
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G5LYBMy45k6QnfAB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 08:22:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.15 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--G5LYBMy45k6QnfAB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6E9tAAKCRD2uYlJVVFO
o5N0AP9FjNJ8lv+hbDpJt7mTlBNmtGcpMStulcA42aUsNvqbKwD/YNsUT7/xQZZn
cJ/+PJz8attRjXNrk0ujTjs75ItuVQk=
=mrG+
-----END PGP SIGNATURE-----

--G5LYBMy45k6QnfAB--
