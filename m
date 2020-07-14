Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656F621EC88
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 11:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGNJUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 05:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgGNJT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 05:19:59 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E71C061755;
        Tue, 14 Jul 2020 02:19:59 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a1so20747555ejg.12;
        Tue, 14 Jul 2020 02:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aABLyhbhtvw8FafkChmgdm2LhwAHxmqBZPtM1x4GBxo=;
        b=JjpUcWI8m6kuIybqZUI/GOO/wPGpFv1Gx+F6fStEj+NmEVY/Wq4EmHH5pcjOJjSexM
         lCS2kEPIEQXICbr3YOIZaPt/VQv29bspkMvtbsp0NYIemBppbYb9APdbg/Rh6Flh+HcJ
         CpRiYO+eMM2f7tHbsFhvoMx+RwZAuPJW7nB/mdgQOqdgxh59CTEl3Of7FrSnVAZwJfKu
         XMXSk16AnFe7jodB+PWOS6ihas3F2ALzgXTs5d1TKnj4uXTaOkm8o6XTie79NuI5cgp3
         QyvqOJz5s2IcGY/C6SHcti1C/9i7gpBad4/3R1eSP5mLiz0qEYnqpQN6EgGemyTb54Aw
         3enw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aABLyhbhtvw8FafkChmgdm2LhwAHxmqBZPtM1x4GBxo=;
        b=rJdhsbBRTSNgMd6pz0tmb1onz1z+xL3/qboiFDu7oGKdrdTRkOfIeMj9nNlxOXCGO9
         4VgsyUJPc1rizYKrrs3WxxARlYnx6rXefwSkr2sE24d6d6uhIgYlWY4fH9G9nMDP7ygz
         TS8jVii1cnRjDh5Pv8U3y4XDtsyV01ddPim8rNJ+8JrFG/0Thk5Pc6atmgA0a2+AqcQJ
         5dbQLEQdiUGu4hm3ycf0mVeR0BA3ihUTg4T7MaQiQJ144oPaWaIWlLdYY7bu6pLZEHWf
         v2t8pULZQ+2zrc/qlvKTd5Hx12Epzc4m0zPU1DOVeeFSDTeq4v5vQ8eOtmj8Zubl48Bt
         7wzA==
X-Gm-Message-State: AOAM530KCG5HQdPwPd4rmC1fBGfNv3NOsnOzyqyJ22gUpu0Jj3Xz1qNH
        HWmqLpwHTCN2OLqeqRuXk/Q=
X-Google-Smtp-Source: ABdhPJyAFGBGrwMRW4/F2b6w7vtgLIBEpYbjMzVZkbeebuSlo5W0Zg+iHimkWSzc07+Q9PFi5BlpVg==
X-Received: by 2002:a17:906:1403:: with SMTP id p3mr3545377ejc.106.1594718397911;
        Tue, 14 Jul 2020 02:19:57 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id z25sm11856923ejd.38.2020.07.14.02.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 02:19:56 -0700 (PDT)
Date:   Tue, 14 Jul 2020 11:19:55 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: tegra: Fix allocation for the FPCI context
Message-ID: <20200714091955.GF141356@ulmo>
References: <20200712102837.24340-1-jonathanh@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DEueqSqTbz/jWVG1"
Content-Disposition: inline
In-Reply-To: <20200712102837.24340-1-jonathanh@nvidia.com>
User-Agent: Mutt/1.14.4 (2020-06-18)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DEueqSqTbz/jWVG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2020 at 11:28:36AM +0100, Jon Hunter wrote:
> Commit 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB
> context save/restore") is using the IPFS 'num_offsets' value when
> allocating memory for FPCI context instead of the FPCI 'num_offsets'.
> We have not observed any specific issues because of this, but could
> cause too much memory or too little memory to be allocated. Fix this
> by using the FPCI 'num_offsets' for allocating the FPCI memory for
> storing the FPCI state.
>=20
> Cc: stable@vger.kernel.org
>=20
> Fixes: 5c4e8d3781bc ("usb: host: xhci-tegra: Add support for XUSB context=
 save/restore")
>=20
> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
> ---
>  drivers/usb/host/xhci-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Good catch!

Acked-by: Thierry Reding <treding@nvidia.com>

--DEueqSqTbz/jWVG1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAl8NeLsACgkQ3SOs138+
s6G7cg/9FTvsISm0svIWmK3kAgMVZkVea+cESYFM2UwbzPvCuznYAXuObClSzmKY
/s7hMh3A5gUvn1Y0j1dYgb5oc8zrf9GHWr3T3aCODdBnQk6HrDyFBUP5sTYA+wfR
684PfsyxG47Ei18zAWtSNlbgGdd0pk0uLRGsrKqxHA+bbooHwO4+Ci6AO242Wovr
V7yBsNxTwgdLtZI2Bx70XSf9Kao4m+zRsaPorS96gnWoJKNtHXWTz4JUWHYSkBtw
B1FJ+YjlBQEaXhdSXtU3VOXaFGJGAm/uPkAXU0pK3YuZvJXkzC224Tgi4BaYK9/c
WDCaMgRhF5V7auBeDKt1xh+nxBAjG8eaMJHuBpKsN1dnRZdXjJG/c+evHFce9noM
VR9jMR6cmg7EJBM9/QfvDA54MGsanmSrDit0Tg//Ba2BtiqQQv8jgl5bkPP8ZSBv
1caFyAn74JoJd/tjPOYoDsgXbhjN64o5eez2z66fXLfvxesfEQMeLKykBnrwEJAE
gXZ7OaOnHsjyWnf+Nd2zYVY8zc48P2NLb8GLYaWboNeVekWSkFK/+VmQ5J6ayDrn
mNJfZ7eNijZlbPz2pkDah47Jta2NzHfjS/zYuiYT/pOa+6UbxsEV7wWOl28mneTO
EpjAS3lJAFSZLiA/Px0WjNwYE+H/iJ8P3BP3RH9ghMu4zCo1Qvg=
=Jwud
-----END PGP SIGNATURE-----

--DEueqSqTbz/jWVG1--
