Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4392D22809D
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgGUNKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbgGUNKz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:10:55 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8898C061794;
        Tue, 21 Jul 2020 06:10:54 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n26so21629655ejx.0;
        Tue, 21 Jul 2020 06:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UspCEUKKntGVrAvJln8sV8cJn+MtvW60MDv5uJ278pY=;
        b=IsEuky7qsWKxla86BSugpUsvVOg8tmt3M1HDn+Uc6Xvv09+aAShmYBOI3mP05HPaxa
         4JsJp9K8AzMlIF9enlA7JHgyTozRUYYoK7M8HJLzz8GR6o+hc9DlLLuhkl0dMC3DVP9Y
         pX3gIA6VD/nHVnaNWVibRYZdJ35Qdm/SHiEcLIMM8ZrhAxG0ibMmQO0pDQwGiH0lo+tc
         IG3Gkn8h0IOEDtPlxN7L0CZ1r4M6uWtPO+N5Jv3b2LljLUq/WiLcJaD/i3JwJRk7ab3Z
         7JoPD9ycseeieEcmyLUtSJkuBitAEMd5+AYBS6tQcs9GEHmPLqJNunlV93a/ewEcNKpS
         RfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UspCEUKKntGVrAvJln8sV8cJn+MtvW60MDv5uJ278pY=;
        b=TXs8gwuaBNZeJYGmwfkjk8B9qyoysShQqJWHRWEFtEYiUSQ32txVrWr6XUTiAtQv0I
         NMONghd3Lw+BVNE5BJNQ8nSdI3+jmOBDD9jVTBCmlzYPOxqc0f/uwlqS37RH7dBFmPOw
         BWVYogFivUWCFCWtSgt5VGAnRlZbzm4rpTFCVO2Yi603H+OJfxw9xBP/1F3DZzbFf7M9
         SGgxbyCrBdPwTMsZU4qY9GHv2II1Eae9w9/f4GUaSg2/AonL+qn8a/LdESqKI+kFDABD
         wSJWc/unyfAFNaMoVVBepoZuvUowrjEVcCUYh75lKkDNmKnc2oF4H4ixyHQscyqNJtCn
         5FZg==
X-Gm-Message-State: AOAM530OQY5Q5QX0pUeqPey9UsdazVUepNr8nFFeBEUhrHm8mXSEtTin
        UEa9yBV2FxoqjKA0OC3TK1g=
X-Google-Smtp-Source: ABdhPJzcmF5L2aR3yjodBcFiE4f1TdBlzsDNXt6PtuYRZxeZtAC9eOAXkTNT1GQHOE8EE6OlgjjMnQ==
X-Received: by 2002:a17:906:d963:: with SMTP id rp3mr24135477ejb.54.1595337053676;
        Tue, 21 Jul 2020 06:10:53 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id q17sm16619830ejd.20.2020.07.21.06.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:10:52 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:10:51 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/86] 4.9.231-rc1 review
Message-ID: <20200721131051.GB44604@ulmo>
References: <20200720152753.138974850@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aM3YZ0Iwxop3KEKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 05:35:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.231 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.231=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.9.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.9:
    8 builds:   8 pass, 0 fail
    16 boots:   16 pass, 0 fail
    30 tests:   30 pass, 0 fail

Linux version:  4.9.231-rc1-g8c3f33eeb0cc
Boards tested:  tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers,
Thierry

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6VsACgkQ3SOs138+
s6EJnxAAnyshar2aayeddVUNnsWbYqvxeOqNzp6ukeoWExDBz7WVQNBa3mVf6yXN
mAUvZaW2IR3k+xtjdaNk7f6ubaK3ec6GkfXssChc5PWic+eoVj+33JB6gmpmk8Yo
N01+0woddAS6neXdaBYcwQliQmcduhx+x1Wwrvr6G7GuW8ELtBiipnMXXWuKo8ll
KWueojmZncfd3Jy4bwTHb0ZDGS4H+GBYurM61ywiqceEZZ2opdjqV93n3AiMurdS
Vg1umglEn0s859S+iZJ7rm5/aSMgVmvAp9UhbDs6XAIxCy7zNJb1g5s+Nb5acdI6
FNylm39OHjqduQhkny/o5F+s80LMdo8LTjXdpvCxa3YEw5ZRzxrub7GOTn5KfdhR
FJ9VV+aF6eChVUgeka/Aohf1J8+e+EYFW/pLMMi4EEszJB6RwVwCejAFJkitTsp+
bGVtX4arOct+3Q5KUQrv1obbXzhMIu6ip9OT+OiPIRPEqrPy+E1QlgLBKHNdSPgN
F3ZamUmCGqRuTYgXzXzmE/b5Smu85fRCUWz3lVSTabknWw2UfXyO2aJykIni5RsJ
DpcaJG23h6DuaOpAM/LF3ensJBwGTXtYJQ84KT21dLO6oLIdk4iIHsurYAZmk9qc
c2Xy4ELyHjNTZJj2sGzg+163ThH1VDaM86u8vBJ9KRfLCCiHL9A=
=OJ4b
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
