Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4B1C644C
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 01:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgEEXMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 19:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbgEEXMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 19:12:12 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9830CC061A0F;
        Tue,  5 May 2020 16:12:11 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so4691924wra.7;
        Tue, 05 May 2020 16:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5nCJ70q6OrlsQs6J0gSq3Rwu8I1zCE+Jl2YwAdQlPNo=;
        b=jhRV68V1BWkaeYFDVHBkeAYHqLuJC0/f4h1ReJijnx+ZItov5jdwfT05XcBfcUetfv
         PXYO2+tbZCam9dqETbyWzBUoUONNo3kfSBZ2dxujzNJh0MZvSs2yQEPSFXqk6gLTHtSN
         LRKkuaER46B8ADSCjz3pUbfNx0rnqxjbcXJwtmHrcz74h87/tXPzZbij0McQDXTXoFFP
         0Gv9MWevJDZVHQZfruUjJFDVNP+/9K/8jLc2fGbEJwdD/0QqhMzNFWK9q0XZcSGoXiLS
         V9L2F0oFuvY6d0DzlcSv5z1uQ8w9YjNroxEBzN5sdIi3+iN7WNTuhg1+mkuInifqLtDy
         Z0DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5nCJ70q6OrlsQs6J0gSq3Rwu8I1zCE+Jl2YwAdQlPNo=;
        b=Kl8yWbLqldZVSDCqSTFG9sDnNl8MsptJUiq3c2wz6CMoE4m05sDgk+Q/dZ1WsS/CUq
         gGTNQ8fPIVy2lqDVjf6BjfC0cQ8oGQ0nMzt9d/Ne4RT3MkTWMCGyPZvX/w4yVzEy0vWk
         5O/wBKhqwBix/iwpQIJ2qCuZUVm7TjTETWufqN1LAkKXN0ZVmOB+CikE9LMoQcN8cWDb
         iwA4mFbCEsTZsPbBSYfRFfjDWknNN5vlyEVQ0jGIuYVOQoJu2cOld5rv/8nhqKMse0U7
         aNniukCP5RteKQkM1jILcdZ8zUkw/2WBDfa68Y5a7fwYNKh8Oj+mwvTlD+w8l9MBhNC4
         qQmg==
X-Gm-Message-State: AGi0PuY3/N96yNFlGNkXW5VeQotgGpZBGeO+8XUC9BFBer9DJ17Dg4Ok
        go36lfhVA43dFKCFxEaIwuo=
X-Google-Smtp-Source: APiQypLVljBZkbjWKlDFFTM1aT8j4lcKSwyon9q9hMwYVKmrIlQZFEqUiRoqJmuhy2mjP/qcKlYT9Q==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr4933591wrn.22.1588720329521;
        Tue, 05 May 2020 16:12:09 -0700 (PDT)
Received: from localhost (p2E5BE57B.dip0.t-ipconnect.de. [46.91.229.123])
        by smtp.gmail.com with ESMTPSA id w6sm106310wrt.39.2020.05.05.16.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 16:12:07 -0700 (PDT)
Date:   Wed, 6 May 2020 01:12:05 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        Peter Robinson <pbrobinson@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: tegra: Fix ethernet phy-mode for Jetson Xavier
Message-ID: <20200505231205.GA2682073@ulmo>
References: <20200501072756.25348-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20200501072756.25348-1-jonathanh@nvidia.com>
User-Agent: Mutt/1.13.1 (2019-12-14)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 01, 2020 at 08:27:56AM +0100, Jon Hunter wrote:
> The 'phy-mode' property is currently defined as 'rgmii' for Jetson
> Xavier. This indicates that the RGMII RX and TX delays are set by the
> MAC and the internal delays set by the PHY are not used.
>=20
> If the Marvell PHY driver is enabled, such that it is used and not the
> generic PHY, ethernet failures are seen (DHCP is failing to obtain an
> IP address) and this is caused because the Marvell PHY driver is
> disabling the internal RX and TX delays. For Jetson Xavier the internal
> PHY RX and TX delay should be used and so fix this by setting the
> 'phy-mode' to 'rgmii-id' and not 'rgmii'.
>=20
> Cc: stable@vger.kernel.org
>=20
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  arch/arm64/boot/dts/nvidia/tegra194-p2888.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Added a Fixes: tag and applied to for-5.8/arm64/dt, thanks.

Thierry

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl6x8q4ACgkQ3SOs138+
s6Hj4A//bZzyUQMMk8z/OhSarJzGUzrOqlYlezjQWrmfuCIkygHuWvV/VxPmaHPK
PHCC9sdUBqlv2ZLRSlOxwMDYiZGCI8cht26eZwYSteHvaVm/IbIPs24y/nLf+FDB
GXAN0dGim6OwcwHvJ1UiGzSbmwvp51YIdqTujH8UgQgjfUjHcf5ZQZ95cmXLi6gd
RSSVQ5Pmmk/FG2wYq9y8w/wgBP0NQXegb0wsQ8U4AMP9EetQL1k+L5BlBIEvhCrp
9NHvPovmlyzCPic7qEPD637LNJViCT+It7lE46V2y1FWlKeFdFPwwmzipDwxX6i5
wKGx9x9QMCcg9s50uRRtbSrN81PNUZfR8bE2AITRqrLMF1i1u4wd9ERveLq3qMla
c2WxvcfTOA2/MCHj62Qq+/WglXw31bzm7FbJyjIdjIz5jNM8oK5E15TWJShSc0MN
/DGt0YQkZeoeqlzlyYsr1UMeAi087ToBvxA4KgfIX9kx093kM/YOUIvllqUn3GD7
eqYaoygiMJSQIHLqvHvpPvMLuS3PLBHucJozOjL7E47yzPrkuOZ8rWIQTQZiI4d6
g1Iyt5CSG5ZZ+XJUpTYuVMPdcTnBp0bdo+AmS6U3sVnpwT22Dr6BnsHKYyweci2A
c89pQBxfY3quf7jj9XmPX2d8Zf0nQjDkoqAxQbP12CgD5UCUQr0=
=dj8D
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
