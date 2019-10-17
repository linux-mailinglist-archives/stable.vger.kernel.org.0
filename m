Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33064DAAF7
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 13:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502042AbfJQLL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 07:11:27 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:60324 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406102AbfJQLL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 07:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JFprVoPpkgaAGAB4gXvv60NaxuxrEcKD8hZaujbII1s=; b=MATSBVnLJJmcSrBYqPKWMobPb
        lXJMRcsMzsJNZ1Zuc20JI2ExUws2agfcGMGIpPmsw3BjpqPxn6dWf4NN04T14QoashvEuwFliSWuY
        wgMjRRwR4jk0TXRl13p49vNH8d0GXCPvHtCS3FppHkdOMHaw0n+Veu75Doa/eNpkzj2d4=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iL3gi-0000mL-DX; Thu, 17 Oct 2019 11:11:24 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 16A7C2742BAC; Thu, 17 Oct 2019 12:11:23 +0100 (BST)
Date:   Thu, 17 Oct 2019 12:11:22 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: Re: Fw: [PATCH 5.3 112/112] ASoC: sgtl5000: add ADC mute control
Message-ID: <20191017111122.GA4976@sirena.co.uk>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191016214907.599726506@linuxfoundation.org>
 <20191016220044.GB11473@sirena.co.uk>
 <20191016221025.GA990599@kroah.com>
 <20191016223518.GC11473@sirena.co.uk>
 <20191016232358.GA994597@kroah.com>
 <de9630e5-341f-b48d-029a-ef1a516bf820@skidata.com>
 <AM6PR05MB653568E379699EE907E146BDF96D0@AM6PR05MB6535.eurprd05.prod.outlook.com>
 <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <CAGgjyvFQQ4E5VfZ3nwFu+7UiGOmkyXK-n9PHjo1p=iYNX5JrPw@mail.gmail.com>
X-Cookie: Shut off engine before fueling.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2019 at 09:49:27AM +0000, Oleksandr Suvorov wrote:

> Mark, obviously this is not a NEW feature. This patch adds LOST
> standard control.

It's a new feature for this CODEC to have control over the capture mute,
other devices have of course had control over it for a long time but for
this device it's a new feature.

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2oTFcACgkQJNaLcl1U
h9AlWQgAg2tRoS6Bb16HDOK01wJuFCOKAb9IHvRx0zrxfmWbgHBPOH+A7Svac15b
X1NyAs+V8KIIJaWu/dNw7rC6XrI87gYqaEsc+3NeUl/+yTyozr7zgUTI1c15Gt00
WcxZd63e7vcBHazS7Bssu98qV8+SpVJ4JEr6/Bmw5DCu61Kn2IJbsBKaMzsAbSVm
rqnsZyk/ecd02u+AF9J1vIBAHholE77LPwx28/EGkG8UC86FH1S9Wzrg7ouY6gO4
O4nVeX0hAwAaeqc6/7W5OoemvzwyK3CQL3eUDRWxBCyMK4C8jeIIQiAkcvjmM0qp
BiVqjpgVsYQV79iflBBrH+aPhZf1ew==
=v3UL
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
