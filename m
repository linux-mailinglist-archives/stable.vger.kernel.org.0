Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8741E2280C3
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGUNQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGUNQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:16:30 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D2C061794;
        Tue, 21 Jul 2020 06:16:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a21so21587504ejj.10;
        Tue, 21 Jul 2020 06:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YNXV9tkdmTmrCB5DMMTE/U71qFugIfo+5OI0FNVfnJI=;
        b=XE4fJeihSUd8Y4ED4QaOLYySe02dxy5IEkqaY5RN7eTMPELb01Goj2wLgXcw9YNqbc
         HjYf/7bgcc3oNgI/2QI4Wj9Vd7auicowMRTSZ/ZHuxG6Dl6n9GDKbQuBuLaoDS/VEUCe
         wgTx/OnGWfoI0iYfJFOtvd8H9TUQ3TlRZLft7QgSFR1Z7xPS5gwrY3xSxK/ui8OJEVTC
         hgf3FkTh0senWSix+/EiZBEWJvp4lgxpY0gfaH6vUdEsfr6tE/N306yJys7Mw93Pn/AM
         jWcThN3BxFfQfBfc7TkzlexFrLjY9K6sSn7x/2vTuybrDpPGe7VmLcjG98FcjdUnz3TX
         Jcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YNXV9tkdmTmrCB5DMMTE/U71qFugIfo+5OI0FNVfnJI=;
        b=CJP/QXcYvJg4aI1GVM/MqRflFHGRH0D/+iE9WDQs7B5qe41Dj+3P+JCpt/YgcUNHTN
         I7gGeDI5t1/FfbBWugSxzecPYilhULurB/b9/I7eKj2cnPhHdmsdgUiwDB5UZBkyclak
         vBsdSPbOna5fh3ghMM6Od7w8ZWxjFxDrJfAuEqNJoJs+lH29/jjqGyrc1ujeLgKOr2K5
         Y7SA7GOhrsBTem5rcKXanzF3mLxmmsp3qwb4pi2WlC7/3mG0g44vPYttB7RaUkYRWb8I
         ZWZcdCsR8ib72d8yBDjn1PsyAGj0WxdKle1/oJem6rXv0rZTvl1nt4gemfLFHvyPjsWN
         Hviw==
X-Gm-Message-State: AOAM533oetyZeKEzZZV7L42LHDSM8Ksxb3fj0awi9nFJMZc57+2mDSGt
        Vi0eAY4+/0uX4cM2CwUfBcc=
X-Google-Smtp-Source: ABdhPJzCR0aP6DvJFVz8cZiCQYKFgMCMGIW3gFH0SeqtRmVJB+RK0pHMG/ENREgeG9yRlRu1GAW/bg==
X-Received: by 2002:a17:906:3984:: with SMTP id h4mr26846581eje.254.1595337389226;
        Tue, 21 Jul 2020 06:16:29 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id 92sm17253780edg.78.2020.07.21.06.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:16:28 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:16:27 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.4 00/58] 4.4.231-rc1 review
Message-ID: <20200721131627.GG44604@ulmo>
References: <20200720152747.127988571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kadn00tgSopKmJ1H"
Content-Disposition: inline
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kadn00tgSopKmJ1H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 05:36:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.231 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.231=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.4.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:   6 pass, 0 fail
    12 boots:   12 pass, 0 fail
    25 tests:   25 pass, 0 fail

Linux version:  4.4.231-rc1-gecea46f88646
Boards tested:  tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04


Cheers,
Thierry

--kadn00tgSopKmJ1H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6qoACgkQ3SOs138+
s6Gudw//R5Dde4AlZJtDzRiLDKG4R2BLWgxHmBiCohxv+4FUHF/4e77Y4cRgGoMi
uldQPQkSW9KgV46PoC4tNCoyLpNtGrhkfp2qZrByUudLE+Yxs9H8C9E9nZImlTcK
G2so7z96daZQ9u1SUrqX9yzW5J2p4qXzcyJLB2TQgJmPV4ixC5LXW1i/wg/HF2Qz
gRWdX5SsOmr4U9DKH6/+rs+Mxi4EZrRL9bLOzaVlYYlbbQgQ9W24hfvAD0JT6FQv
1atiFRnwz6laEDouViPKVU29EqOCD9jrdHu+ngBvqltUCHRRRgfTphTaz+E8Usx9
VKeBACuX6e4YlCFQX/Mi5WQctwUt/5D1CWtYdsWDYYOS3qpgyBxXCw1zs8yTyX1o
Dfxch1+SchXtfFyute8SDyut3WX4YhzVBqYkwdkKag3PNUQAvdgciRMTIjZF28kr
Trrz1VcNm+5Sc3cNuh5vGmHr3EYT5Fq4B29fnaVR4Az+wSgznW1I1qxz32dUYhDP
x3Wn+LGkpRVQszWlx2hVXrGCSrqh8i5QV3wroSThP3TY1gESvnjEWv13Jb6f/Nt2
ze50Y3hKLRmbfOvFlrXH6A1jedfh/ZChv6jgwyI8VehVnzUtc7/QOTBlTNG0EXKB
5lXe8S7ya+r5+hY4eU184NDUiNTnqwMEdpfMlqhaq8BBCZxdNxM=
=EfOB
-----END PGP SIGNATURE-----

--kadn00tgSopKmJ1H--
