Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328362280AF
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGUNMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgGUNMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:12:32 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B842C061794;
        Tue, 21 Jul 2020 06:12:32 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a1so15223961edt.10;
        Tue, 21 Jul 2020 06:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nBossCmsWHPL8MggqjHAug4Bmu5ZUdQEBmNCEtFn8zM=;
        b=or+3pvwTt1vOhuGz040GR32tZvLpKotZUd3iYPsgZS1wFzpE/enxKyLGRSXdqTApok
         cvlOa9UFJjNGbP3FQHLDSsF2+iF8ugwDE8GS4sE9MI0rsicHyWklDjs4ik5ZXs21L7mL
         Tjy+h1UFO8qF7sOS9DjA6W8wKpBIs5aEHkNwoLApZq04MQh77GZxQ1PaN1YjL6QzEIxw
         bOxzCPTt+QGFK+nYhRJ/a8HN0xcS6eTqmDPNOyTDannpf9MuUsk/VH2ybEjTzVrXu+Tm
         pWEqTetNc7k75CY08ockS2TlQ3RLS371uFCPvNgEcSCrm5VgpPZvM1T8hrSseHtfGFPJ
         NzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nBossCmsWHPL8MggqjHAug4Bmu5ZUdQEBmNCEtFn8zM=;
        b=CKcn+hn9ESqN5rD+YP7Edbti4vvz8mGHb2HrczU/6MkuYhzaIi5PXOcZKfhb1y3184
         VCMYEE64SDRnv5FcbwIXGZ1SMYp9gx+kTQjin13vA6z4mhIvRgB9b98fm+ZI/emcHQI6
         BltgTkX0CNiBlioNqJw/0Pz5qs+X4tAPkC+tlXZ8lKbI56yWQxIqvkeDe2daJH0rZi/c
         /rdYjzO05Nr0nKLivOE8kowcKuX14ZQCcAMKmAYJNch1MNzz81DCtGNmANP9mT3jVezd
         LirgfJgL5JTd92no86ngSsIW4gxKBS/piB64P+SoYTaUwEHPtQPcPCEEGkTm4pL9UITz
         UVRg==
X-Gm-Message-State: AOAM532qFlaIQlX4ZpZ3927JpwrieeE7mIFBmqSmMch3X+glQf3JFvxk
        M0F1lzI6oxkT4/QZk0ZQNQw=
X-Google-Smtp-Source: ABdhPJyDkXpVtFsNCRmAEWk5XLwB2YGiXnrpKPXO/+POrQPjsQZh9RwMNFkINqkAeIXrnKXeHdk+Bg==
X-Received: by 2002:a05:6402:b23:: with SMTP id bo3mr26500295edb.331.1595337150742;
        Tue, 21 Jul 2020 06:12:30 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id d23sm16287991ejj.74.2020.07.21.06.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:12:29 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:12:28 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/215] 5.4.53-rc1 review
Message-ID: <20200721131228.GC44604@ulmo>
References: <20200720152820.122442056@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sr1nOIr3CvdE5hEN"
Content-Disposition: inline
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Sr1nOIr3CvdE5hEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 05:34:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.53 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.53-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-5.4.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    11 builds:  11 pass, 0 fail
    26 boots:   26 pass, 0 fail
    56 tests:   56 pass, 0 fail

Linux version:  5.4.53-rc1-g95f1079149bd
Boards tested:  tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers,
Thierry

--Sr1nOIr3CvdE5hEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6bwACgkQ3SOs138+
s6HPEhAArSagNcoTsjy+Qa6lyYFHrcbGEIlpHKO6hSLhXV6XywzCwfPgtWjg/Vgi
+3Pnd+rxfgjlx/OzU+UFN8QwNobVEO5TAajoNI+8nCqSTOyGFZkVXlaL6gdeMA8P
SH/LSuSNmMsa6U28wEhyi5Eo5mmIkRg3+RP9B+CSZiAJn4CxBY5wlOtDd+qOzyMw
8Fbph4GOGG+hrWl6L1bLJ1/RBLrybpXdOStHso+M7K0U2UYb80nz0BfBKAw0FebQ
yrNE4lUhed50vWAtKdhnWQn6cvkPsOP71BgUOHd1EC1PzvHNFVX44+BqZ9aKCz4D
Kj0UAiCI/OwhahMoLeCcv/b7rWboZG6ny2wWPzSnHvXGNKZ/jYfkfxHW04jrjXGH
XMkmjzASbIqkQQyaXcRF7FQeSTCkgE1+mnsKvFj0IR6x/XQaX0f4EtCdwrlZAOWD
B1ccmr/m3DgF1wXwy5nlPkZ0HYPlElBUzczRSTeBFum9Ib2FaOc4r3G1RCjJgDDj
4HQdu7lszduPvilu62b36o9u24xmtIIa3vDvoOq74uso6UPQUNSSvcfnIzllxQTW
p1Q907wEGflhNIrHKd1ux+UKLgAt7Q+w/ur6dX2L45EFWbOoZNqy/fJCLJx8VVVA
keEZZ3gQHoXGhDmjUbvAr794d+l5IAuLSTD10Anth+OW4+5jEpU=
=555I
-----END PGP SIGNATURE-----

--Sr1nOIr3CvdE5hEN--
