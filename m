Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1FE7FBA8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfHBOAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 10:00:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34227 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbfHBOAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 10:00:15 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so37667114edb.1;
        Fri, 02 Aug 2019 07:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RvYJ60Wjr/M/zIOMvQjrXUZiwsQ2GTyWCMdHSjd4/Co=;
        b=ZDCDnZr3NqupLmRHY8hsuhCdx2vKzIHSPy2mEKhISQ/USsf4pMcAqTetzvSCodpAX/
         HCa5lv8TINyaNQnPLKhNMt7UUuLdACx2W8m9e6Led9Hxabm1Uv0hrL5OMAQNue5J85r6
         cL8jjHHHNQrAZAI7gZjTjGIPbfyEQTPP86jQSZDn/8NmkuB9k+G8pxP/1WgH+3HyTURS
         jhkPwWd/78mFksiTpu6QvcpG55hh9B0d6SBaeuSVZPFdzU8objncOTXYxe5+CfQBMWoN
         Dir+hNV2N7r0iWo13jZe2DgBG9hvtUK3tXSkDup6ULEEWE05B3WwmQshSCicHevSJaw8
         5bLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RvYJ60Wjr/M/zIOMvQjrXUZiwsQ2GTyWCMdHSjd4/Co=;
        b=JdAr0uXZX2gSn7uPhZALkNFlXaPntYpMK4Iu1+TZfkrL/bKzyrZjSnXvboABPOjaPc
         ehfvt05TRE2dT8NDXto0F2FyBD0VLVI8XquxCeyPiLtWprlD2LUtjxF0T4S9MS6jUEDd
         jI3aSCyoKdwBgxeZeKdzAvBxf7W8w9FrS42vr9k3A19Uk0fneKB8w3fMSwm5tFGWFzAc
         hu8GpPSZK6ILESieCk4maQ7BMye9sUBz+5yy5cVcpu4uGMuA54idcKHRL01s4+dbr9Mi
         +odiUqMZOJwUXK+aIaqCnAfKKtdBns1JaW7oV5ZOPWTfZby3ReSmC9iCadflAhy+OoUZ
         7+Ww==
X-Gm-Message-State: APjAAAUXrf64P/t4DUDlzMVWsx405+bkrIujvjo9iQh62K9BxPOPY91A
        AYlI4Zj0q3KXq2V1uuOu8q0=
X-Google-Smtp-Source: APXvYqz+wpnaqXorxi0pTKdX4EBvqcUAOhW51NQpcVtuvViD0NsdAJAJplTXB8QOE1uEiMP5Je/1iw==
X-Received: by 2002:a17:906:5042:: with SMTP id e2mr103088893ejk.220.1564754413937;
        Fri, 02 Aug 2019 07:00:13 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id g7sm18018544eda.52.2019.08.02.07.00.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 07:00:13 -0700 (PDT)
Date:   Fri, 2 Aug 2019 16:00:12 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/158] 4.4.187-stable review
Message-ID: <20190802140012.GB10544@ulmo>
References: <20190802092203.671944552@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 02, 2019 at 11:27:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.187 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.187=
-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.4.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra...

Test results for stable-v4.4:
    6 builds:   6 pass, 0 fail
    12 boots:   12 pass, 0 fail
    19 tests:   19 pass, 0 fail

Linux version:  4.4.187-rc1-g26f755a0d3e0
Boards tested:  tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Thierry

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl1EQewACgkQ3SOs138+
s6HGOg/8CFA12brGOEunkatCGl/ihWvKkX5GXS87AuuIO2Fmk1PlEjCeMdXSycy7
JbJMbb41z3txzlTvYwclTeARiaU7zJHm/H4z9VvgZXC53LWit59P0nlCH9twR21I
6O4MwZ4T/LpoeAZOKoMNDL6pDVjjmg6c/s1KJj7iVWKBI7KDYnAwZtJHfiOujqFx
z0Tze8berBhWO10mHBIYWyzriQYp9EMI3iJHdpQpdiq7Ay37EgcYtwv7onuLF9dj
wB62WFwEYHKngBsv0YragifoT44NKPdaESLWXds7MyIGZMGjhwJawHMqor7AsaH3
N8/WF5VSiDWCZh/dxR3EAMWGsvezVxiUCpx6lGl70Q4mkOsQsKg0jx6dwoBvUOv2
YFLUdWSVA+G3FiFv8W61PIMcyDy6wkaRWg8odhhQDWPHrupKH3OSvDeMp9KltMl2
lQUMar1Eavtbp0wrjk9WThwohFlWFBDpUbnh2wzG1OlNN0RNY65BWVt//ppdW2t7
0OW9J5eKTH6VG6QNZUpW67eK1NmueKrLAdvNWZ8mGqHv6PMZlkUhFC5WElBp3BLt
V2mlyHvUje9YA0m2d4AIvp1xoahDbNlwtern01BmD+XdXFTYNCHPVKK6hVJyO+Ra
ZAaE05/EVESN4tYCo1H7Rap/ALbdJUeP5jDSE1ZcWeuBwl/Ujxs=
=cBRl
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
