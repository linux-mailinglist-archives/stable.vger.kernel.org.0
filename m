Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDB5228091
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgGUNG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgGUNG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:06:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07495C061794;
        Tue, 21 Jul 2020 06:06:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n22so18640529ejy.3;
        Tue, 21 Jul 2020 06:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FNRQDpB/C0DSiAzcHNO6kb9FGeqlHGnvw2Idc2qF2xA=;
        b=VP4XLs2WMesH3mwrJ2TWgXivOWcsMmLW8nE78luEosgHipsHAAZmHzYquXSDi7qvZY
         ZciITN8ijBNwp9oCjrpCamOReyd3csPYMkf16WPfGk7zJaZxbaD3nOStP0QBGZnL0+Aq
         aUTAkHpJTzKUHpRMerSv5vEwqXsdSIbPDYyIaWbYUab1ncX4clBtIqb1LAc+dk6jmmmg
         4vcUyITofP9ibQhX7YgnE/TEPi1bvYMxRFVBFoXF68vzFaoLz1g2Y4FgU/nbU+ySnsFd
         ptcENq+C6Pu04WPvsUiXu0p5XeExCRn1+NPCDjMmaaTIaeYst3/rIEN6rP/2Ce5bkwWC
         y9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FNRQDpB/C0DSiAzcHNO6kb9FGeqlHGnvw2Idc2qF2xA=;
        b=tLgza4K65xRzjuxE86bffSiIs9jzTnStz0fsUPOnHUnJBAdzkV7s1Vh6fBSQ7/y9CL
         cuEAUwRXbSoPR45de6jxGnwsRdNs+oCy1FwMTrWkHFtWRzpcOp4+g1FLeKNHqRGfiqq4
         WOJHYRe95bn/OKxguGO9THGGs9k7Nxyr5Oz9B0k2QCddDIpMJ12fVhKjtfT91CxHrxz4
         NhaCmzlD+zmFUzzeSrGlPBp+5si86h0cdj4XgB9kyc2v4Paw1LRWqxQamrTEFkIMHOvR
         iZchzk5Zg0mCCeBW/v2VpNZwNyv7bgeXrhqL+eK1cvcsh5kjTqIvCZuhEfoj2QPm0OUX
         aThQ==
X-Gm-Message-State: AOAM531wDxQNdRSNYV7//8RN/8FELWI6LMOTBIwOqkTpvR2aZBmdz2Z+
        mWB6Evj+0endEjo8i6Z4FRQ=
X-Google-Smtp-Source: ABdhPJwcf/sxQxk530R/py0pX12PmvV9iHPrBfHCQ+2PQNz834i+xPdHKN0AXZSBZ3aNgIp8dXvmzg==
X-Received: by 2002:a17:906:cecf:: with SMTP id si15mr24731498ejb.508.1595336816764;
        Tue, 21 Jul 2020 06:06:56 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id j19sm17340714edt.44.2020.07.21.06.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:06:55 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:06:52 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/244] 5.7.10-rc1 review
Message-ID: <20200721130652.GA44604@ulmo>
References: <20200720152825.863040590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 05:34:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.10 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.10-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-5.7.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.7:
    11 builds:  11 pass, 0 fail
    26 boots:   26 pass, 0 fail
    56 tests:   56 pass, 0 fail

Linux version:  5.7.10-rc1-gd3c98742b46c
Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers,
Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6FYACgkQ3SOs138+
s6HL/g//Xv6WI4vKPskHudJHwPp1V1YJ2OZY1Y+ZcNgFkOL4gJS036ce4MFCiFn6
73b9kGpAoc0WmgUUcc4J0e5zaRhSfxQMnH63BMk3FVlDVFoKL+Q2Km/TO0ys9hP3
mpNc5UWDS/KyVRt4Wl7/YCz7Bg1eqQ79hLP+PgeGCahRa+tRJHIxQ4HHvPkHYinj
DfHEekF7jindM1/Ghdrr5yR0qEmYp+KPGvNDYpNbmUauVNd1W/ovBw+zvrowbsrz
3JeaYesRkkNYdhbLLb9USUOGkpQ4iBhiCNMFMJb2ZiN42w3D90LCglhQO/1BuuRC
vFP+CoRUQUqBN0E+UmDbjbnYkWJuSi5VuA+FV8Js/g6MfC2dqpm9k2j9hrl2Sy/o
n9ys8kWjqhRP9aresAT7F7/Rd1UBX7/3DUIAsLK05Ug4dUWgl3NUdgQW4BYnF3sV
5N7twG8W8NemnLArWCLOW90sGgmY5XJJnMUduxW2Cz1AAP3L2ywP7zEh5In/Q3nm
ejUkMeiNeoo7uCmDCWN8vz/H7895ZIWcYd+9LLLfqhMqOkvEx+I7qkmQMU32s1FN
GW52Me+d2rNbQ5igGd886kBPvMeQmPahRANi7iTFyIPaVspuOdtAJLPx4OKxT9sw
/l5bhUoD1nsKZnk/HsmyJBw2ybKLCQpHRCmIB/IfhTsKCe7IiLw=
=AON/
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
