Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD422280C8
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUNRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgGUNRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:17:11 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B9AC061794;
        Tue, 21 Jul 2020 06:17:11 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so15255076edr.9;
        Tue, 21 Jul 2020 06:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=89PH6o6sIsfZydCWux7gl3t6nRnroW7UX38O9xXW/Tc=;
        b=gkT0Q4evUEUG1qzdb03CEAo035TdaBbMR3Ggj6LMf6MmrD5hHCJq59NDw0eZo7Nw2n
         jALRBDkDRnsseeHSqLxXCMdrSq/7lwvhd/icW2a9svov5c+AxVNjqcyHLpdqFNu2+CON
         dyT6QGn16cIVXGA1NkuufJsSClWLCLX2UftGbnBASrietd9750SKHbyXOmSqLTgyD5tO
         CnXcP0UD7XWJzrShtmYB3zTB9fjf1HqtlZf/lZYwCMamcAlIZ+uS6HZ4UutQ2rc7tZn8
         83HRRqWzs5Npzs1C+HPrhaGzfTbZSCJ26tJ1i6YSGAPkDInmpIv9Q+S6j5vYOlfu/man
         6ihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=89PH6o6sIsfZydCWux7gl3t6nRnroW7UX38O9xXW/Tc=;
        b=hdCf0qaPW9Le7O4M7WAaZxk+U9FYgb3BeSlbmus7ttxlOQHPjAcqcLrMzjzCDVHDsb
         6yQm0oll0lu3nLps82exyc+OSMF6/s94ua7ExlZd5/uIB0K4g72BeOdAa3oy8LFpesM1
         G90CXnvjgRPfft5jnJG1G2HFXl7nhpDdz2sm9ITrgkVRyaN69vxZXTg1DiMqIN76ePtP
         DdCGA0ImJa4LuIrN7gAvlfH75ulxWqL0N634yMzn8Kh4aVVRCSnglW3PPAsw1k1Jd+oI
         /kKXJBr7/A9nnlwnHSZFTBqJURFKoCSsuBjxO+lrU3yhGH5/j/nd/o/Eakz3eSCwgEgo
         9YRA==
X-Gm-Message-State: AOAM5339bEO+RRpTwAyiT6KoibqPM7qSFKorxk/uesOst2Z9cQ+yNyCs
        X1iIo7meF02JM3Yzy5tjpPA=
X-Google-Smtp-Source: ABdhPJzvhQncAO+Ogod9ZMtj38UliZWx+k7N33PQxNY92gk2Ft9UZ6yacdP8guYr0aNVOvilu/EoYA==
X-Received: by 2002:a50:cf43:: with SMTP id d3mr26993046edk.40.1595337430350;
        Tue, 21 Jul 2020 06:17:10 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id g21sm17267771edu.2.2020.07.21.06.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:17:09 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:17:08 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.7 000/243] 5.7.10-rc2 review
Message-ID: <20200721131708.GH44604@ulmo>
References: <20200720191523.845282610@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYYhpFXgKVw71fwr"
Content-Disposition: inline
In-Reply-To: <20200720191523.845282610@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mYYhpFXgKVw71fwr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 09:16:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.10 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 19:14:36 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.10-=
rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-5.7.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.7:
    11 builds:  11 pass, 0 fail
    26 boots:   26 pass, 0 fail
    56 tests:   56 pass, 0 fail

Linux version:  5.7.10-rc2-g7d2e5723ce4a
Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers,
Thierry

--mYYhpFXgKVw71fwr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6tMACgkQ3SOs138+
s6F21A/+OmjoI5u3XrXQaGIJYUcB0XPSU30JDeTdhaLVPnZyB9zbz9tQYGc97UU/
QUHrKBPPqg9VEImgYK3xCb70uW2KGHSn9ug5Oyk33LccgrttQVdkviNoZBoIt5ZD
K/jLAGXO1tHc2tbzQiV+bEeyB+/n+2HMOIpbdhKAeaXPUMUEAkMiS8djZlyiZYTw
6b+2Y7Q93qKiswfwWswX3BJzPTEfR4ijQQSv5wEne6MztDrU5Q+CoQj9EKJRgKYD
y1AX5w7OSiwysGK8c3CUmEf80cIKm+dQOabuiUUmrNKbfrqcg632t6Fj14Ihd4M8
7vQZpmlMJko4088u2vU5HQk1eieJFVOp7vsgvtk1G/Dngx9BN8DzYkPw62Xp5kvk
zgtpjNGB7jd31RJzLEfb7gA6F/xw6Zltgw72UNX4yzB0wDtsvNKrGCGTjyeTwJdm
f/F23r3EjyFionvJrQY0uXlrB4jQhdkweI2r8LIfL2kn/yWKqHGeu3yuf1UQYccn
EZuDYRIjvhu1NIOfjHPVSW9pNeLh5JZWY6sS+QR6vk47kYDtW5UnwgS8NQ3OkMqf
BGKjpoyZdZHcnqdZNduX8hdMm707Jx0F6I+Tc8QDnhtitHg/5aNHu3uPR3CCZ0VK
clcLflckiOMCD48VFiIN8IznbcBwa2Hbv2iYwOiYAFKGkudI6D4=
=tCj0
-----END PGP SIGNATURE-----

--mYYhpFXgKVw71fwr--
