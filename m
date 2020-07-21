Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618772280BB
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgGUNOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgGUNOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:14:32 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D1C061794;
        Tue, 21 Jul 2020 06:14:32 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id h28so15270813edz.0;
        Tue, 21 Jul 2020 06:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qWyarVzCa1uuhNFbtCVqaJTCuBOJPZBJNhnssjGVZPc=;
        b=VcGOSW/fVQheWp4zSKF0CH9c9pGwPElOO5vNEkueubww6PX8qQm5qE6RQ5Qi3IxVDJ
         BF1lwAV93lDuEwF/mGoOzDbbLNNGugOkI/L6fLkYmfaaqFULFxyQT/e5s6Pu30Dsg4dw
         Zr0d8hsTiel9IdrQ8Y3h9yv8GS8QYZu0XUWirFMzhiViZXOAmttiRazXko+YsfXr0OCP
         xhBaZ8VagviEvCmwV8ASjEJOV1QVDCyoC3o+xnUK1UFhtJ91hyrDLElyoF5g0WemllIU
         3jKKrzXO859m+bUZSKW+lkxKTDvsSS4K5hGy2UTQy5MfS6shEJ6y7qCVTJx5bqVyM31Y
         IHCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qWyarVzCa1uuhNFbtCVqaJTCuBOJPZBJNhnssjGVZPc=;
        b=qcrCd+zFzZPNwd24MMpoke0XSFDBEVNGGDLZP668zvNKGfdSQmseOA5S2T9QxloUjt
         lZpOqgBZ0PG66suYfR+3eRGr8dNH7QmbRTMH8ux9lSUM4psOYsP/edOJRM0UHHQNhCc+
         Lc0QlF56zzJ/rydb/liJHXe4pZ2eb8kgAaiAuqDJ+mhnGLnIXU/N8awEaNiTZHxqICGL
         kugiMHk72+vM0C5zu8ZNFoC5scXQILasPa0hdV5pSKyV1nJ8N5eldNgfv5IBBuFJbohP
         lQVkGU2EHZT9Zpfh5xKsYJhZm76SgvtJju8OhovwzH+MqSngCMRVku30ipSGxjQyAVXv
         Bihg==
X-Gm-Message-State: AOAM533+lrkCiQreCgK5S65QCKhRO31fX21irrsE73iQhQWp1SlXL24u
        9Tnbeh1mOq+6vq15bBB7ly8=
X-Google-Smtp-Source: ABdhPJz94pCzoy2F2sabQnicb3+XIiEJPWYWCa3OLQzgGFinaLv+4tVen5VRsBqajjPN/SYY9ovFkw==
X-Received: by 2002:a05:6402:1bdd:: with SMTP id ch29mr25904929edb.134.1595337270831;
        Tue, 21 Jul 2020 06:14:30 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id r19sm17162801edp.79.2020.07.21.06.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:14:29 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:14:28 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.19 000/133] 4.19.134-rc1 review
Message-ID: <20200721131428.GE44604@ulmo>
References: <20200720152803.732195882@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h56sxpGKRmy85csR"
Content-Disposition: inline
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h56sxpGKRmy85csR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 05:35:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.134 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.13=
4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.19.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    11 builds:  11 pass, 0 fail
    22 boots:   22 pass, 0 fail
    38 tests:   38 pass, 0 fail

Linux version:  4.19.134-rc1-g9d319b54cc24
Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers,
Thierry

--h56sxpGKRmy85csR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6jQACgkQ3SOs138+
s6HZuA//YJM+ABgzrc6euDLcUHvP7nC4HSBdh4Yrlv8L3MFMX4ubp95z1hdxG8b0
fWGVrrwykQ6NKtiZdVzbj4DpbSQFw9ek3UJa/25cbAad9mKCup5EwbaQrzvGicvY
Hj4TjhKiij+IOTkUdYzyyJ55nSO2+DB72Lvjb0857aD9OflZpNxQVbtgpn24Tr/X
hqN1MoM+yTOHZnpddiBKVbMz6dPCH/0D3r173h8GliJJtxpCJaKOCfnyCgk85Y6f
DOpbxs/Mycr1uxqJMf0hrz2Jh3Bk1T1azc+5+WLdxypNHAYXuIOATsyaw90fM9Sg
q/ormpZHlWLacFocLMZk+o4uFLnKO7EX630dKc/E1fsWjdCOSaZZnV57p7HTTnvs
+qUGdcf33AiHhweHE07ND3Pj1HAOLLtsElTgcn1spO0WmhYSF5ujrLXVqKUGV1DF
A789Tw68o9AmYFWYXD/ROYjTanC7KOdhKz5gT+lASG6YQJViVK9bhbAuFPFTM/uj
fjlDzrnJy56Sk6GNEYVG6Nfdy/IIzG8MSLzaIZP8xO6qOcQUqxl28DL1gTyWLodZ
v8pWAS3MtOY7+qPpTvVAdFrp9nHvIalUbQjj5ZniQruJTCM3l9ETM5yijjpSo8bj
Y3ooRR5Dp4GJ6QcZKUOFSImi/aT7+DSsOASLrHCifGpUxCpTMSA=
=/sPq
-----END PGP SIGNATURE-----

--h56sxpGKRmy85csR--
