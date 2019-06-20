Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C676D4CA8C
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfFTJTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:19:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47041 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfFTJTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 05:19:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so2181885wrw.13;
        Thu, 20 Jun 2019 02:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qrfEVEYKB9ZhVqkQd492eBjZ3TJrTiRv0Q3SKLGeTvI=;
        b=KcMvOCLAc3mqmSgTvhm1idfbQENy8nFunmTn+KkWxPHYi0VCdcMgPuBXTVcFmqwPES
         9ucVv+1AZZScj2k9l/yZb8Nl+fNrRGGkFK/fJgGVtQMqQMRL3y2k9Fa8uG02kNp84nOv
         qTfIdxtlUnJ9KP3knl8ns4SneMnQpwTZggStWYYaf5TiG73BUeTMVDaDxNHCp99YECK/
         E1s2wwsFFZTqFf8zlRm8vk2uTcQzxsRcHpcQrh1xPfFFCSfR4QZf/S9XlI3XMSJFgTNx
         uglygt69QVNaaC39invn6RoGBQDNbO/jZW+hmCvjEEXDz93tCx801GBCqL5uAJ0No6WU
         XXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qrfEVEYKB9ZhVqkQd492eBjZ3TJrTiRv0Q3SKLGeTvI=;
        b=k025c+nz3/YUXmg2q7cKD7TzdVIh8hkgHjmymPmgeIdlEv/j2GJF9O9HOph+42/v8a
         Mem4NAG5ydb8Kidl6F/yBcEGnaGKdUJfCpCXDmD/cBfHisaD/hqqtThRE9rK67DlvZID
         M+HLD0ZvFERY68lEa4yIB3gEGyNiT5S6/q6bJqqwvwpcoe9SwQldslmiquLMHVVoNKoa
         ++uVKdyp/YhmQ/7u3UPQZDar/CjXfxF1HVHHr6R8WP7ObqDcmJ15xnTcc9edfwfbLtaV
         ers2K5qxx5uWovuNjz1ZwJqh10W+eOz7bd4qIqq0RZG4D2jh7RFJNzc7j5OCajVWbzFQ
         sRSQ==
X-Gm-Message-State: APjAAAV3Cqy4H3UdWYguQW6LRKQBa8L1fZIs7lp0tQ+473VmYdBgwvxs
        2+/Yqx6p+XRJIcwG6BXqc48=
X-Google-Smtp-Source: APXvYqwxb3UesWSy6k03jb80b2NVa05vfpQxwFWJy7sA9x1SSKo3XZ6nj78G8FLiT4Houo5DxDpbvA==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr57715609wrv.180.1561022347015;
        Thu, 20 Jun 2019 02:19:07 -0700 (PDT)
Received: from localhost (p2E5BEF36.dip0.t-ipconnect.de. [46.91.239.54])
        by smtp.gmail.com with ESMTPSA id u6sm4769912wml.9.2019.06.20.02.19.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 02:19:06 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:19:05 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] arm64: tegra: Fix Jetson Nano GPU regulator
Message-ID: <20190620091905.GH26689@ulmo>
References: <20190620081702.17209-1-jonathanh@nvidia.com>
 <20190620081702.17209-4-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7J16OGEJ/mt06A90"
Content-Disposition: inline
In-Reply-To: <20190620081702.17209-4-jonathanh@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7J16OGEJ/mt06A90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2019 at 09:17:02AM +0100, Jon Hunter wrote:
> There are a few issues with the GPU regulator defined for Jetson Nano
> which are:
>=20
> 1. The GPU regulator is a PWM based regulator and not a fixed voltage
>    regulator.
> 2. The output voltages for the GPU regulator are not correct.
> 3. The regulator enable ramp delay is too short for the regulator and
>    needs to be increased. 2ms should be sufficient.
> 4. This is the same regulator used on Jetson TX1 and so make the ramp
>    delay and settling time the same as Jetson TX1.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  .../boot/dts/nvidia/tegra210-p3450-0000.dts   | 21 +++++++++++--------
>  1 file changed, 12 insertions(+), 9 deletions(-)

Applied to for-5.3/arm64/dt and added the following Fixes: line:

Fixes: 6772cd0eacc8 ("arm64: tegra: Add NVIDIA Jetson Nano Developer Kit su=
pport")

Thanks,
Thierry

--7J16OGEJ/mt06A90
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl0LT4kACgkQ3SOs138+
s6G8ww//fjfnWo4vBk0CeWznERPm2coOw07DTPZyJNzlg0LzA4XcvH6c1fDipZ4e
xjc2Qp60EzszmD8jM9N17is+GI9jGWl2+tJ/yAAWdpnV5NzEmimg4JIkvy0ZywcP
OZByfo+P4E5bTVLoZcb/6CVuQqyKrjnI4OWBgWQP8rUofaIeOgBmjO1ve34PzpAQ
alrQN/gZhGZqUVHewqKHMhGkmpODiblGzjgI4Q+e+msYmXw0PMNawDUnz2VqmCS+
wT30hLlHkeoj6p5EUo9R3aQaQdLa2iduYrnoR2QHnvDn3KP6kQBVVDeYNI+LaibJ
Hj+w5kK0RfUg7iUg2wzlXYAR4qfQKxXVZ/7M+UyZi6fO2fvD7lhooqw2F0osQMdB
cv9vh0xsllWUIH4TQVOh12rcDkQdSnYJQ1+DBnB9Qfupih/NIQFAZNWk0BOPjdRj
m1ca4e3Xx5DTPtz82XCICyglXeIpaiXQAa2eyQAqYgTUcaxhpB7kqKD/dPsFiXqB
Nj4HF1t0XD/ppVirkoh6AqBZY/bHomikCdcPU3sa3Xa6HATByI+2bPs4CXmLLTJz
DX9vJ9uf7+gZHUmhbvmkVcK37ruN9BAbjO9Gnf6yCfi8el6uaGxGN2A/Sj7EfIIk
4Jd+Q676PmwEXibG3VCQS//Yw2iuFcWd1F0HuoFQ+/XLNZhzFSw=
=NtW5
-----END PGP SIGNATURE-----

--7J16OGEJ/mt06A90--
