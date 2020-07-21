Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC472280B2
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgGUNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgGUNNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:13:16 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C58C061794;
        Tue, 21 Jul 2020 06:13:15 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so21612045ejb.2;
        Tue, 21 Jul 2020 06:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TK4oN2cWdMTgyUd064PFfx+ByIVM6HVNCIBkJO1QDYU=;
        b=GGtdkH7CFoiTtcZg6A2xw52zsbShnN6+5G8w2skPz55TWayxfqPm8gzLcgRHvImYvM
         zhs2qeltEZhLYa6Y/YTPfZnW6BnF6S5CMgDwRIkSG2folDqlIX/oLypIcQhEcwDnAe+w
         B+o4iXNXHI9JumAYCSYDmI4tXC/K7cUb5xop7Z7GPhFQntqBanh16mSmc/OjsGpod7lH
         FbBv4KLwhEmm3CXMrxlecpuK0YVYRAjDCPMlAeAxl5tAuuqPbzjrMv33fhwntbYFbqrp
         ZU+ULMIvFiDnOP6+an5tWJQ92azjkWTa01jtNtZ14ee+3LdrA0VJepXVG1GyjvFXkpw5
         OeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TK4oN2cWdMTgyUd064PFfx+ByIVM6HVNCIBkJO1QDYU=;
        b=QhC9b/SmsuUgzUDsGefoIUn8QP5bkChv+x/XwnREBrXN5BCQOxwxGHpMpmavjNreGB
         i5bgXXXTWRF9wtpGDmvtMSNgZwZicAiyPDgoAfJuBMQCqXsYXZyxK0YShtgveeetDb2a
         iDwks0eEza2hVss0CpGIL5SUpg18R8xQAVbqVDGQQNjDcu0KlaHt8hevp+iIorN+QdPc
         BO0qMLAVdH2MBoyzOSMGh5wdCjgCSWiigbh4trYykhNw+pJpXX1AoIBW6ock6Ivqogij
         6fzuH9/cxWMqqk7WQDIK8UPt5XTHDczOgDdlk66QeW1ugLxcohpp1gftjI1ItQgCW0qm
         2dsA==
X-Gm-Message-State: AOAM5320mDme7j4cTff1vXxT4rWK4xpD1yLm0Igy+pojS51Ff4eXHoXN
        sR6I4JLofYkI4d1DHE1x/0g=
X-Google-Smtp-Source: ABdhPJwrZhZEkdLoXiZPe3jMVi/fPEC8GR1kDLFuvmQnZCfSs33o3aQjYYycY6lwO7UqZp17ScXYRg==
X-Received: by 2002:a17:906:2318:: with SMTP id l24mr26632000eja.291.1595337194668;
        Tue, 21 Jul 2020 06:13:14 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id yj16sm16919836ejb.122.2020.07.21.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:13:13 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:13:12 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/125] 4.14.189-rc1 review
Message-ID: <20200721131312.GD44604@ulmo>
References: <20200720152802.929969555@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2020 at 05:35:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.189 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.18=
9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-4.14.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:   8 pass, 0 fail
    16 boots:   16 pass, 0 fail
    30 tests:   30 pass, 0 fail

Linux version:  4.14.189-rc1-g403ad3c8edab
Boards tested:  tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers,
Thierry

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6egACgkQ3SOs138+
s6FBlA/9GpgCTn2LlrvWw0fxjXryfAmA25H1TA7wyB+kf2dw/WGaF22ELFOQQPkV
izXkyF3GxmncF7vUofYsGCiVONw7eOeu1zQkG7tUowwF5ObkZ6H8Za/Y1oH+RFlJ
a2xaFy4iKC0AOFl+9FYMXz9+U1VeKarJHf37sAFJG57STo0OSsCKBUKITg4jCksO
zYgwndKRnCu4De1V7Bs/xfh6LR0WSp1rAvrsl59ICdF124SL+lilqR1m6ShCKmzQ
cbv/DyWRsTJGjTmkwggWTr7rOvKAUAp0ZheMYrtAHCFsFofP1jGeSzSj9kS1YIEE
/p8LRAhjcfOzU/v9KhN1dIQSc5ekL/3DcLz1iOC0SP0wEpfoZVzNpKoPxWbiV+Dt
ZAPCRhh8I28dMFmUq4XDr6o4t8pGG5AHD/YPajEbY4xUG/Jaaw4NRKcg2yXWAOwL
G5yYdW7vhc0O/bimNrfcH8VrA8EqvRXT/rDjuxzKnRj0YvqeuIiMYMPDgnmza7Bg
NJi9OHY1v2QAhH8W15+UShzgVz1gXOJiGew2mTxQp2SbLz6SdFBmj7m9pNocK8wC
QPSWlOvVrjyQVd2VIlJxsnXSsN4kAyPDTYwePl8k9EcNNYyzXLeHqZvXG/wSKhI5
uqe1QO3Y49mVJNq9eH/924T5DsUeNRABjcXFddyL7+CTlsz52/k=
=7Bk2
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
