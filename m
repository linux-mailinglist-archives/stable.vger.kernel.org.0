Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37043B87A0
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 19:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhF3RZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 13:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhF3RZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 13:25:24 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD57C061756;
        Wed, 30 Jun 2021 10:22:55 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id v20so5474573eji.10;
        Wed, 30 Jun 2021 10:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x3G7MiV5V2WdgmDfEaf+poT5Ff4jZJNN34iHyEUEQQ8=;
        b=T/zxIJ+8ByUaZxl0o6bR9v9nVaY3hvk/gowTvjDv41wla/b2xpQewCjoDDFglJYyKO
         rbrlJJAb5LsMkxOIU+AT/xcrRsDeL8FAUjclT1SKnAZz6A5bCSYQ4cmJc/zp22ALFOvk
         w598NjL0/IhZKj6QZ2CsFFpO2d1bEotLkwn5bjkcOfNR2I4rvRO3/hsc9LrUEffgHpnq
         v98Y4twgN84bXCoNe8d7Dxhd5h7YdnGrFx/ZafUHqSJlpqMVeApprOPT2gwkwoBlElCh
         NP8YucnA+sikZSXzrFvR1J1v0jkFTeGC4sJi99LDUb34IDcNLRVt2KcNf6j6vkbhmHud
         +Nkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x3G7MiV5V2WdgmDfEaf+poT5Ff4jZJNN34iHyEUEQQ8=;
        b=n2Chz+JPiQB2dxsZ+BJFDNuysTWsP6QfXBbj8EGr3hmGMGHAQY/LLS5DfYvQQ+BZNq
         oS1LIEzc0+/tl5gzzcOQnK0Jm2Okp7erRxxDCRjCVmGms+2KVm4WhrWBKvYUYAg+jeOE
         xPLTpNp8yxKNsyhOilw2N7Z+VWnVqgvz5PdUICcA8qltSXnV1VafjzRYGFBTRbyuGdtF
         65ebjRs5u8Ib3uTVES2PVbjeEPQN42/Itis6vTwkexTynFdgRgmH7ZxWWVRalP7D8Rdi
         w0ygyhgy3UJI8JTIhgxHaXfRnCnJRXHNUCLNCdBaIhmj0VZqHdi4Xpq9jmXoPe3JaGDX
         K/RA==
X-Gm-Message-State: AOAM530W5vNN9Uv6YnIk3CjBXO6VTXN3C8ISTE7v9rJxxf1yogPNQyl+
        dOzeJGPiSfhtaSi16AOz7nk=
X-Google-Smtp-Source: ABdhPJxw8XKvm5N9B4ADmcFDV5l1D5SuWBu4ewRoPwnWmcErr/SQbhos3WmTbCRVrxx8QLNj5bDs6A==
X-Received: by 2002:a17:907:c08:: with SMTP id ga8mr35920759ejc.314.1625073773608;
        Wed, 30 Jun 2021 10:22:53 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id c6sm12781228ede.17.2021.06.30.10.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 10:22:52 -0700 (PDT)
Date:   Wed, 30 Jun 2021 19:25:08 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Yarlagadda <kyarlagadda@nvidia.com>,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2] serial: tegra: Only print FIFO error message when an
 error occurs
Message-ID: <YNyo9JAjJCVVl2iC@orome.fritz.box>
References: <20210630125643.264264-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vjh4mPMZnT7OMIpk"
Content-Disposition: inline
In-Reply-To: <20210630125643.264264-1-jonathanh@nvidia.com>
User-Agent: Mutt/2.1 (4b100969) (2021-06-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vjh4mPMZnT7OMIpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 30, 2021 at 01:56:43PM +0100, Jon Hunter wrote:
> The Tegra serial driver always prints an error message when enabling the
> FIFO for devices that have support for checking the FIFO enable status.
> Fix this by displaying the error message, only when an error occurs.
>=20
> Finally, update the error message to make it clear that enabling the
> FIFO failed and display the error code.
>=20
> Fixes: 222dcdff3405 ("serial: tegra: check for FIFO mode enabled status")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
> Changes since V1:
> - Updated the error message to make it more meaningful.
>=20
> drivers/tty/serial/serial-tegra.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Looks good:

Acked-by: Thierry Reding <treding@nvidia.com>

--vjh4mPMZnT7OMIpk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmDcqPQACgkQ3SOs138+
s6G7xw/9GRGVCOUsYk3BUSpq/oKQuMg3Sn7vO7otfOt4kJHxfGO+XiRmi3hOcd/s
PHk9S58U0cGyGm4Z/UZtMv/27RTPddZ0+Xhbjce+gp+vukGkb/8lcXrRMstgu4xQ
//6thljEuz94hXgZRdzDdBoOYqyJkKkR2IG9Dg/Ptw9QSoVfhMdddjEq/A2deACv
6cVjT18dJzhhUx/weO0jM17iu7N/hrFTqqxKtej/Po/gpBjJ9sQRETdbukXNA5mn
eWWQr7InTFY7nrLjTOx9ofOoCfyKmGELsQA7NablqXonpCoOMcg4uWyaZi0J6/nt
7d26mjxRfMsRaglGH5RECX+W+rLRc0D0tyjR2BOC8ZNzzKABjuWEkeGUTo0aDV0b
cejERUKjWjsHQ9oxx4r6eJTKhLDWzOT7pRnFL9XkzRAoTR47G/9vpW5PyxGsZcUl
Md5x9yObrNDpATXeemPeKgFVBwzCcHwS7Do+cJ/BtUxDE8f3c6gh/1/p4yX45bFQ
+Wq8mYbVDQ8hdV4nZinV66VFKJAVe4OlqtYNArFhXnh07CBKG1dJEhMd8GnmpHh9
4nsKY/QvNsoCuV2y4+a9Y0cXbPiw2ObTz/T54404Ra59tdCIFtbuH4VvBW3totSC
fYC/NgGxdlHJdm08ttsIlYwGv/R0hHslNf1V8VCoQFTF2k4EOSg=
=rxYn
-----END PGP SIGNATURE-----

--vjh4mPMZnT7OMIpk--
