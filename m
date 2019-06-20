Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D5C4CA65
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfFTJNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:13:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40159 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfFTJNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 05:13:11 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so2326100wmj.5;
        Thu, 20 Jun 2019 02:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wGXxJqECKz9cySdRUBaO0GlwWrE9CiX7wN8WQeEMVA4=;
        b=jQ86ZolbYH3Y4/PH2mE8qNDk118/dnGikW9LBMwhxzPkZEs6N0I7T2ZBnUl/Me2Zhd
         WAfyVmsVRzDGGrtxuSerIgtvu37yPW6x2NW5c/LVjE+Tl8oNnTPnWaxEqyC3wgO8gPpT
         bnsitRR1WYRtNPJknEmItodaS3lJU1cl7b3sZtbQPVcC585Kl7hA2HLzSMFL2GLMlub2
         zkIEdBOPRNMpR9czW3DzuXLvw1R5VE7ffPF5y2Iz6oUWHRlVimtio5NFLSUXldq/5tr+
         miCi2IcXM+09i3OXe9C955ssP1L7prRhm1hmxkH4wteZt7olnhqsOzCLuLVXfzP1Xcnj
         K1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wGXxJqECKz9cySdRUBaO0GlwWrE9CiX7wN8WQeEMVA4=;
        b=MU3Db0UDsNCKgvK3AoEi8Ife2piyjPUBXSvlGQBEMRMeQjDh36AHCyjmzn3OXTWF6E
         do9UmoofMbxdK1qi6FdrBKhjSUdxlAVSMfmVFTr4W/ZnXZA6a13Ls9zYavt01kRoTDny
         YnSi84mO1a1G5zYmMSEYeMIX07Ye3Fk7R/JdYiA8ufIYiAtyaTDpBqfOfnem7jmCDPP+
         U4cZ5qK6Ku2lH2KgGHDyfzLIKq5DW61JelBDNojPj4veK0XA963EUvXLHsZiX7qYyW9G
         4WnAjp8cGNh0EDt8Ifpo8eCteqThUKsQHj1LVgGCxjovk86a/ekwidVM1CHQzoHgCLf4
         ZRwA==
X-Gm-Message-State: APjAAAVGo9x6tuh3bQ8/Wbu7m+R7EnS5t+vgE6ylrI3f3rejCrZtT2/1
        Bl+yL6SvgMCpB0xWXxDEZns=
X-Google-Smtp-Source: APXvYqxdb65XWtl4WJaYkSAXJ0d5symvMDqq82VznzsRvUOCOO0R7Tcu7Or2GEc3v2auihHgZxk5cw==
X-Received: by 2002:a1c:b6d4:: with SMTP id g203mr1967964wmf.19.1561021988879;
        Thu, 20 Jun 2019 02:13:08 -0700 (PDT)
Received: from localhost (p2E5BEF36.dip0.t-ipconnect.de. [46.91.239.54])
        by smtp.gmail.com with ESMTPSA id 72sm17272000wrk.22.2019.06.20.02.13.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 02:13:08 -0700 (PDT)
Date:   Thu, 20 Jun 2019 11:13:07 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] arm64: tegra: Fix AGIC register range
Message-ID: <20190620091307.GF26689@ulmo>
References: <20190620081702.17209-1-jonathanh@nvidia.com>
 <20190620081702.17209-2-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5CUMAwwhRxlRszMD"
Content-Disposition: inline
In-Reply-To: <20190620081702.17209-2-jonathanh@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5CUMAwwhRxlRszMD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2019 at 09:17:00AM +0100, Jon Hunter wrote:
> The Tegra AGIC interrupt controller is an ARM GIC400 interrupt
> controller. Per the ARM GIC device-tree binding, the first address
> region is for the GIC distributor registers and the second address
> region is for the GIC CPU interface registers. The address space for
> the distributor registers is 4kB, but currently this is incorrectly
> defined as 8kB for the Tegra AGIC and overlaps with the CPU interface
> registers. Correct the address space for the distributor to be 4kB.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  arch/arm64/boot/dts/nvidia/tegra210.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-5.3/arm64/dt, though I also added the following Fixes:
line:

Fixes: bcdbde433542 ("arm64: tegra: Add AGIC node for Tegra210")

Thanks,
Thierry

--5CUMAwwhRxlRszMD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl0LTiIACgkQ3SOs138+
s6GY4w/+MMaim+cU/P4jt3haccBqVOz26dTGf4DqXEF/agrQwv0CwCOuwWjUxzLY
enl2a+nzqXC6UwHRetCeL+En/ul0nbmF8+4OptO+gFd5t6E2T+bcV6KeV7DxrfMp
uTWAwiQctbDqJjRJ2dv1weTTfbpC/hEtd4VmbPW7R62z5FEC+EmUcOFbIQql3XuK
6No6LVFDiCvV+8p4zHpbNEmfm/glVzsoV/CjS/rGVszfGteG1+dNX2gt5ASuxjFB
5XyN9z2NSzkQat9sMKMk56EY1xC+HuHi5ZlZboReTxf9wq/3rpofyalMoeWcm4RV
rzNWNXU5yWoII8L4CR80WsGV4BphyklkzFUgC61Z7MXu/STIGrTPB3U9vbJdBNov
kidAGdL1u+ya9cvrBB3St+G9P+rsYIGAgZY0yePBTlXRSUYbYkfSiyiKiDVdE1LM
riiaB4gqMpxchLlY0AcUf0gGep+1z+eOTmKng2EmEbSAF1D3WW7r48EMyctvhRo/
3jHaWe3K8uzYVT3eYANyAWK3pacyWFPjVSZTbFJ9taLZIKsKXj7LQrclZGZ79NvN
QOxbQepxdHyMgJ+ZeueB+vbspaMpcmAfNhrcmlZ9oeFU2EDTjqCJfy4Tw8yEaKwn
zK39Mhin/EY8vr76fV8k2Oz644MiCxV4zyz31F/b+TRisRf7AI4=
=Gdxk
-----END PGP SIGNATURE-----

--5CUMAwwhRxlRszMD--
