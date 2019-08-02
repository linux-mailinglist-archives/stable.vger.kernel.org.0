Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 437037FBA2
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406644AbfHBN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:59:17 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37321 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406638AbfHBN7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 09:59:17 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so72525973eds.4;
        Fri, 02 Aug 2019 06:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ToWrIn0UrLCeB4O+yknNl+FqGHjrstRxnZtuAwoDSWY=;
        b=a3+xTCfnBhxcnkBGCFzCnaKs1WDB2YiQOo/Ju1c4mEfx3uwGMJ+rQyi+diTtcVVx6K
         EXX9nDGjGo8Doq4Ers0HVr39t/mwzHeupFEhHo1ong0h1mcuGWxm2fFW1lxQUXtMqFY1
         qbIIbAcBs74p2gzyg973DmloWTLRhy7H37jSacrObC67sCYWzISOaHQkOULgwAwWgdK3
         8R6Zgyqi+cxHLlde8DVTDPd5qEfGhQbVUuRctng93gYmwi9azqY5GDNNXS4kwcDrsH42
         WismNF3TNTjmYOZLK+jvx+dGR4eJ0XHUnKe8C/n6od7Jh2BIpDMMLmcnit+kQgKHtvNx
         mJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ToWrIn0UrLCeB4O+yknNl+FqGHjrstRxnZtuAwoDSWY=;
        b=DiMx7NqZXQYAUX7dBH3l/kSYBxpSYhzoK64Y3J7RG6+XlkUoSd7UUBQJb65G7gPAoy
         Ibi8Rmm1pUU+dbWDtuqARd4Mt7Xga7GZ1abC5P8VlF2zwVXlQ8Tjgn9H6kxD0OntwyEZ
         WPlGW/gt/nh1SP6i69sfKbd33KowUZTLokms7RnEpOvvA2/y9AvuFEaoO+fkd004nb+w
         3ob2H9owTca1eZpcFg/4kt6En7Eore3i/h6rDWFFDovDzq38/vIcm0g4fhf5hQXMjiMU
         DiWVifC88FXliRU3JqN/SPeaJut9wn0ArLykS72m39d8ma749p8kF6igxxoi/biGCv1Y
         00xQ==
X-Gm-Message-State: APjAAAUEyIOSTI0T2BqpC4CK9oFTonh9idoFRPrVCWdYuGEq4WdpQ6/J
        cMkm1Wa0DroZVexSSZow530=
X-Google-Smtp-Source: APXvYqwdz2cNIcN4gAxdwqpRhwJEbu/WlvmlrXDBcLjXHeG0nx8ype3YC7KHJGWg+ZEQNSyEGtUkuQ==
X-Received: by 2002:a17:907:20db:: with SMTP id qq27mr104912399ejb.30.1564754355133;
        Fri, 02 Aug 2019 06:59:15 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id j7sm18646749eda.97.2019.08.02.06.59.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 06:59:14 -0700 (PDT)
Date:   Fri, 2 Aug 2019 15:59:13 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        Jon Hunter <jonathanh@nvidia.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.14 00/25] 4.14.136-stable review
Message-ID: <20190802135913.GA10544@ulmo>
References: <20190802092058.428079740@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2019 at 11:39:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.136 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.13=
6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.14.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra...

Test results for stable-v4.14:
    8 builds:   8 pass, 0 fail
    16 boots:   16 pass, 0 fail
    24 tests:   24 pass, 0 fail

Linux version:  4.14.136-rc1-g0931704b8bef
Boards tested:  tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl1EQa4ACgkQ3SOs138+
s6FqaQ//QwDVemUgZZZSPpH1Mx6S6gLbCNUpIcskAuNt1bzH+Dj4qc5fRtt1F1nC
Oc7BRPDXLcTp+zpjAi0OU4igDk3dZ4d/H2m63d7DAxPfLA22gFiGGK3u4SeL44dj
MVlaJz0SygZHrVP/N6+6BB6GXVz30O3GoO/dKlRaXJZZLSPowjyvlzHpf6oJFb85
mWzz8LdeQRstd64Zhw0D7RsqQ3V7AaKVeqHCY9MdFqtrgF/yE/FbwXHzGTZzuowo
tpjJJuddOHyVlU4H7fHKZFrOgmt8S8rsrwDiTi6n4q6LwG0ucz1JTR4NIFdN9jHQ
l6cEifZthZPMM0YZukW+RKTk5jxRtBQJApePyMNmCxXyKCoPLjAei/ROjt6Z95nH
E3Ds5BJqZFPshVm9A2Z2L9Y3BiH+c1rm4qVwB5OQmv6UsXT3ZPSIyBbqByWje5uL
LIsduGQ/9BH3EZixQmBkv/khYdJZEqdP4P8Zhn9AGFNfcWozp0I8Mq3pzRJ4fUMN
Bh1wkhi1G56/Oip8fIhGbXO0PqzMC8cD1bty2lyz2tfUt02ZzZp693TgUg4C53lm
9iiqABQHmuSWY0Can0/w6bsyMI0OnUc9Zqi8MnOx2wzONJtIINTQWKkEO19p6QLm
qXvEaL30VMeeYQ/ohkvdIVlj25zbIDycIpuGGwhgbLOGxq/xr6M=
=Hxi+
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
