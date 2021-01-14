Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB52F2F5CB4
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 09:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbhANI5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 03:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbhANI5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 03:57:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6977239A1;
        Thu, 14 Jan 2021 08:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610614623;
        bh=zsx5nPtADKLjuunMgy8/KCoh2CcAacruI1Wlbf7EFek=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=T1XU1ABZIGJeRd0lUDN7Qz58mIr5ThbTRHwkHAu5Tb8FhpXrE+HzrZ3g6T7KTbqTy
         wgqkUyN/wAm+IH4EDY+nSVWoj0VMtiBDVQzc3f2h9Z8MJWZUylm/bgSaVicvvngV9Y
         Qs3hhuZrmSGjqkfDlGYIR7YsQwfYpfcyidC3SvgBYLsoT6+yYivJOBflppZ/x5laBy
         /INdqHZnW//Tf7IqBnw0nWP4b+ETEM+2CbBZzTdP9gErtLgg5TQI5gV6zdM/DTpjjt
         ERlacjZxetXiuch7pXgY2GzFOqfYdztgHwQU07Q7JY/qnb5rZD4IF1zPl1xz6AKMDH
         8oFxaeSDPn6+w==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Peter Chen <peter.chen@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Michal Nazarewicz <mina86@mina86.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: udc: core: Use lock when write to soft_connect
In-Reply-To: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
References: <311bc6d30b23427420133602c2833308310b7fcb.1610595364.git.Thinh.Nguyen@synopsys.com>
Date:   Thu, 14 Jan 2021 10:56:55 +0200
Message-ID: <87k0sf3nhk.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> Use lock to guard against concurrent access for soft-connect/disconnect
> operations when writing to soft_connect sysfs.
>
> Cc: stable@vger.kernel.org
> Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmAAB1cRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZTDxAAjkYg8B0C4kfry3iSFLT/uXx90OYywx1q
81IZCwAEmCJVAwaQoWGnnvmMIImRnpxIqpAE91C9ZO86toqUNHZvu0SMQOUUgJcm
4LX+JOYY3DQjN6knFpvOaKuaH9DPXZmGKqSQ0Gns994hVhFJ2sLPfSaEgsVqEdha
ZcOqD6yItpIIMWAd4RTm//AMp8UumTcRbyhMdkpScbNAXyPSrxqokHsgOg3rUJ+B
xZlsbq1gCsZlZMBPK2nSfoGfC3WYP/iOik0nf7SRVTt6mwHT0xuufJg7bb5+sxMv
NSSatGCXvER/Kt1zTHatr1j/T3dqgaDleAfZWK+UesA06rh4tNCMStLT93AgJikh
itFTLlunBkesgofytv03KUyxqUByWnppVaGAup2eO++PHYStiMQnYBdl336bagkI
szILyTYkMWI66zXO+vOWJvbs5wjWpQinfekCW5crMTT4wlApFXDOwqzU3wU++/jI
NF3k52isu5zorSb8sG1A9W96CcZJbj4HdGUHJbnkEPC2rTI0sEO8nvSQjjRRnxLb
M+nY9efuyhjl7eR8QhkLgrj0lYOeFbw7P/JLkWW/uPomAUAdMEdMmxCa7H5WtO5K
Ldp2iaY2dNOTq6Z34MTZWNKj+vbtjLqRXUeWn5AS2YANfGePWT1jSB9CcURellif
LO5AED7lJqo=
=ZA5Q
-----END PGP SIGNATURE-----
--=-=-=--
