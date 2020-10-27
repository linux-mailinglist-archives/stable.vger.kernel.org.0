Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2EE29A7D0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 10:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509912AbgJ0J15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 05:27:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509909AbgJ0J15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 05:27:57 -0400
Received: from saruman (88-113-213-94.elisa-laajakaista.fi [88.113.213.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 249E12224E;
        Tue, 27 Oct 2020 09:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603790876;
        bh=xLpY00QRyysW1CVoq8SDBtYpKUyQlBzmXUhPDo9kuV0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=XEDL1/LKZQWVlC4TR25CSXBKtlnS663MLObEU8LOCzKzzYvcCJYE6/G6rTjq0PsRS
         y0p7r3yZbLyUPJks0YuevCrbbDlQ2WR0icJlaotCTdCZOQ1ISzEHALLHAuo2o0KatO
         C6HxiZTEvrtGezl/fT9KHTjOTVv90F8A7yZUXaCY=
From:   Felipe Balbi <balbi@kernel.org>
To:     Peter Chen <peter.chen@nxp.com>, pawell@cadence.com, rogerq@ti.com
Cc:     linux-usb@vger.kernel.org, linux-imx@nxp.com,
        gregkh@linuxfoundation.org, jun.li@nxp.com, stable@vger.kernel.org,
        Peter Chen <peter.chen@nxp.com>
Subject: Re: [PATCH v2 3/3] usb: cdns3: Fix on-chip memory overflow issue
In-Reply-To: <20201022005505.24167-4-peter.chen@nxp.com>
References: <20201022005505.24167-1-peter.chen@nxp.com>
 <20201022005505.24167-4-peter.chen@nxp.com>
Date:   Tue, 27 Oct 2020 11:27:48 +0200
Message-ID: <878sbsc92j.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Hi,

Peter Chen <peter.chen@nxp.com> writes:
> From: Pawel Laszczak <pawell@cadence.com>
>
> Patch fixes issue caused setting On-chip memory overflow bit in usb_sts
> register. The issue occurred because EP_CFG register was set twice
> before USB_STS.CFGSTS was set. Every write operation on EP_CFG.BUFFERING
> causes that controller increases internal counter holding the number
> of reserved on-chip buffers. First time this register was updated in
> function cdns3_ep_config before delegating SET_CONFIGURATION request
> to class driver and again it was updated when class wanted to enable
> endpoint.  This patch fixes this issue by configuring endpoints
> enabled by class driver in cdns3_gadget_ep_enable and others just
> before status stage.
>
> Cc: <stable@vger.kernel.org> #v5.8+
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Reported-and-tested-by: Peter Chen <peter.chen@nxp.com>
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>

comment from previous thread is still valid. Far too extensive change to
qualify for stable or -rc. Sure there isn't a minimal patch possible?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl+X6BQRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbOdhAA0uKvvWlsT8JXyiYhL6z2ceF18SuOUf3N
kCqSCAjUHvB7+MLRNHhOz0iJ6B2GWlY8XsarQBuGG3FyWpTcTkD32B9mtXPTYIFp
tyR12NTA70EJiRhPn+h8H4et0/hlOqlB3fKI/FfjqngLswYKfM2aokfiL74ae1iU
npsqnCx+pcitD7xxUcKVJQHe801BTDJdX97ouT32TiSWRcv2SjEU5lb45grWUsYo
NvIUlry8452ROmByI4YilRm2ssTo3En9BJXk39TDDj7/nsnXmzJQLTxkhvD7jaME
XhudigHx8V/rWV3dDykG5xpUCm9IDIarWdLEyfiu4Y6mxxRUg+bAZZkAF0E9L5MP
ATfw0lqp0C04iXmr5x1HOzEDk0mDhQCp+rQNngBaRjJhZg2kjwfs7bGjqhJYgUFj
dc8wZtrmq75gH2nDEY+QPrwxP678tW/46BceNEt4dr9DS4x5RHlJDWh+CpUrUOW3
HD0G2/K4prPK01uy2nu5jKznAmRv42Vjyyia9rW4AGraKx9upt7Ndks0Pwyelsqo
Ymc0/b3nqA2LUXP9YsCjdAVz4FSBKKty/MAc1YojkZA8ziLqB9Z6vxN+B32IYM8n
7482sGpzmBjCBUpx3yqHfb5nquxLMuovvWQRNQFnb9bs91OZFTcEl0k0NHf7pZz3
1NQumhv1jR0=
=G3T8
-----END PGP SIGNATURE-----
--=-=-=--
