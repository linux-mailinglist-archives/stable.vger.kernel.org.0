Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC3D340C0
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfFDHxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:53:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59348 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfFDHxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 03:53:47 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 183D9802F2; Tue,  4 Jun 2019 09:53:35 +0200 (CEST)
Date:   Tue, 4 Jun 2019 09:53:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Zhang, Baoli" <baoli.zhang@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Weifeng Voon <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 22/32] net: stmmac: dma channel control register
 need to be init first
Message-ID: <20190604075344.GB24856@amd>
References: <20190603090308.472021390@linuxfoundation.org>
 <20190603090314.784323813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20190603090314.784323813@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-06-03 11:08:16, Greg Kroah-Hartman wrote:
> From: Weifeng Voon <weifeng.voon@intel.com>
>=20
> stmmac_init_chan() needs to be called before stmmac_init_rx_chan() and
> stmmac_init_tx_chan(). This is because if PBLx8 is to be used,
> "DMA_CH(#i)_Control.PBLx8" needs to be set before programming
> "DMA_CH(#i)_TX_Control.TxPBL" and "DMA_CH(#i)_RX_Control.RxPBL".

This one misses upstream id, too. It is hash
af8f3fb7fb077c9df9fed97113a031e792163def .

Best regrads,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz2I4gACgkQMOfwapXb+vK4CgCeLZrO3dduXeqF4tPZ88gGIdhy
ChAAn3fShcUval/ahyqwxSZZ8xtnJ8sH
=YHbt
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
