Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D2D2280C0
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 15:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgGUNPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 09:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgGUNPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 09:15:21 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB2FC061794;
        Tue, 21 Jul 2020 06:15:20 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so21578316ejb.11;
        Tue, 21 Jul 2020 06:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rpNcso4FiZ0VgYMzJb8S6nTj0r9gAUQrkBaNd4gwDHA=;
        b=JQHipRJtczmpsWM2PB2Lu6iohktywcYxbZ8VzaJ6R96Ye1YVNrf5i8Okaf6E5Vxp9Q
         9XeH0QkPDVtt78UZiGXlwO5lM6L+QzABtva6wiDhLikhh7ZgrHhEvEWDC5FUFqRGo4JZ
         n/MQ5dTNsZANGwWpdPUvBr5K9zR3Sfbxm/c4ccmcJIZYMjnieFYivEkU9JPj/quK9oac
         1ZxsldNU2XPLEpD3s4TM+v5zr0f8n/IBWJrXF/Jn6UxSXQOzjGMISSXheYQiuPxsuZqy
         gHtO8d12dtIG+InGuPBwAanxiXK8fBdWn0eMlTd1wQ2cUvrcH8Vw02eD4dUFQx8oNoqD
         ni9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rpNcso4FiZ0VgYMzJb8S6nTj0r9gAUQrkBaNd4gwDHA=;
        b=qN4C7D96ZVAFInq7qfZGZi3r/xDqaoDj27uz8mWFUfRSTZbRhMnpBIm8APfoYoWWac
         rZOZYy3g26c2eOrB0apSNE+5xW4+ODW/PXz3w/WlnQG0c7k/1lVhgUfhLC15H0N2qTMJ
         xnw5Sg2uFpdCYvFsXu0zx0HaMCOIPdk8fru7GgA5lChw4ol7IETLjVY1xKHMGZqFsB5R
         bqeJ160cf5fePYiOW7a7lZfC1kuxNeW3uWIIjMNKCWAkQ7JdrUhOM7MrkmHKQTPQwKXB
         vxo34JIKwxCaK1htQKvltINGPnVS1olZTmVdqar3EQ+EwU0VsyfPJ2v77ZIs8JEn076b
         H9jw==
X-Gm-Message-State: AOAM5324i4gofbwsqt63gPrjZptIMhKUVxdb6NAfugPnAdrPCTjoP0Yn
        S3FItRN7iI8PGd9NwmeUYqw=
X-Google-Smtp-Source: ABdhPJxdH1QQU2ZL+hn/t7AtY0ohuRYQ4Z51s3xvhzi59W02wy1ycZ/BW9dA4eKSfZpm39kPLz9Oyw==
X-Received: by 2002:a17:906:945:: with SMTP id j5mr24642655ejd.436.1595337319718;
        Tue, 21 Jul 2020 06:15:19 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id c9sm17228678edv.8.2020.07.21.06.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 06:15:18 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:15:17 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.9 00/86] 4.9.231-rc1 review
Message-ID: <20200721131517.GF44604@ulmo>
References: <20200720152753.138974850@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kR3zbvD4cgoYnS/6"
Content-Disposition: inline
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kR3zbvD4cgoYnS/6
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

--kR3zbvD4cgoYnS/6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8W6mUACgkQ3SOs138+
s6Hzbg/8Db7TRvvS6mFdcVCqgRLT+5AsqsXXDPsFfye6bobj8gzQF22cXYglYbDd
6MZ8qAuh3d+XmQOJ//Nzg7oRk2L64XHv1Z7wwnKe6394JMDD4ww3cDSdbs/XMyoU
nsXxpTFOmrXaDIOQkMdyvRji3oAzXfBTsQ/pjAEWImQGThYnsCBPp3e7oClBUL+Y
qElTtaKcE5vq1dBiT9p9wX/fnEurOJxPmsH4RwUSxyfnTzZGo17sR1Rr4X6BUd1s
yguxysNH9XnYqIknpYVGnFAjMkoFRQjlqE8Z+AXjQtuig7RuVF862+4wU5YK49tj
vAK2LYKEGE5LKgyejTGx+0V4Cx5eUUmX4nkl++ERg0ZT2Jyrf8skx6xTmoaKIJmC
FGRvkR6Fo1aJ4nANb4N/vK8f/Pws/0t08x9hiT6TdEw0cqmSyt+467V2loMPvr7H
MIiL77yllmLYHk/dUnHMN3ZmjAsCByyt2sxpnGRYIoyfZcqbDnajlKbocJgO7gMK
KZtFHNsY+NQjfKNznDVPFnxM8vZhnDMdxbpVc7kksLyER0jgVQDGQQvf0Oua1rdO
Za9pMoaPNdLNS+ViWlHVeqw7xI4+wklPz/vVK1UKTeH+PJ0ctlVTiFnCnBcaXjRl
BAtg0Dssh9eeXwGC2B8rzY6kPF3thm2J0Kff6VJgdNIMop4Ahk0=
=HyEW
-----END PGP SIGNATURE-----

--kR3zbvD4cgoYnS/6--
