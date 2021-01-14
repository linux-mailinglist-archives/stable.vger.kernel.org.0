Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F0B2F5D2F
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 10:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbhANJWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 04:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbhANJWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 04:22:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B25923A05;
        Thu, 14 Jan 2021 09:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610616091;
        bh=Xg+Nb7sW7RlMhBK1L0mV7+DrrI+r1gMKsDrYK5yTTBI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SnCuI9YnOVaqEMf6iWH/Yd/vSCtCZU/F0K2GMT9r4OTbmJbW9FL5ThFoSWn/Kr7Ya
         G8m4mf6s/FCq+os708ckhRPbLaVk7FjI8hfJrOXuP2mM8FkkJAjbxm3gGVdILVR4Jo
         czFhx0D7eO50FR4UYnbds0KztcfBp6p0TChpQTEE/Ug85hL8cJLTBUn1za46wRuner
         e5LV1PD07czU7arTct9GDo5NNM2x7jJUWXI0gBakE1yxRXXTAW04lHUyT+a2P4tKnL
         bomm4WxwDdjZxSeL3LJiAXZO5yWjWE28fFdldAnp3PBMODPtTmfsKg03IQXgvw9ZYK
         Iik8c4qxG4KRQ==
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
Subject: Re: [PATCH v3] usb: udc: core: Use lock when write to soft_connect
In-Reply-To: <338ea01fbd69b1985ef58f0f59af02c805ddf189.1610611437.git.Thinh.Nguyen@synopsys.com>
References: <338ea01fbd69b1985ef58f0f59af02c805ddf189.1610611437.git.Thinh.Nguyen@synopsys.com>
Date:   Thu, 14 Jan 2021 11:21:23 +0200
Message-ID: <87bldr3mcs.fsf@kernel.org>
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

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> Use lock to guard against concurrent access for soft-connect/disconnect
> operations when writing to soft_connect sysfs.
>
> Cc: stable@vger.kernel.org
> Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

this does look better than v2 :-p

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmAADRMRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQafDBAAnq0BJv+hBqwh25lXNBrUOl+VvDUu1RrN
5qJH7t8M3r5N/l+r061Pq6EhdymblxPFtvnPTOvmqZH9LJMbJUrUB51dXgjOB3Uv
Cn0Vf8aInJK0PzTEXGbBcSK06/EQrCJFxI5GlUD7h4q1vwrYQ4h8k51tSVPJv8sx
nfPzUqKXmbtMiXDwyHAWlm1QAxK1R1m4eE17sRTZUz1kz9ENwdzueZeZ3e2ScytR
vdh2XelxW42qrx1/0IgwK0wXABf7cdQXtXluGKEzibje/XhHwHzedflRqvetnPvx
scUyaR1U19loZTnz3NZOLpRZrFr8DtH2NiFUp07ZpLtQ5CimP+f6OpRLyuGrBJdK
ujL3OQA8Tw4BxGufoShWch7tqhDKwKz1vacB4UKY5vl3meYeKpi6LsrlOCjnSQyc
h8bE8Ev7eLaVWvWueXrTtybzSE+FuWkLCzGWK/UNqflSvVsZKgw7PotdU0Wr8G2q
YcliBiS4DFhYUUFqQtq0dkAwGSKVTf8jGtk4C5xpZqZQouV3/jxAjkzGMiDmD9LR
s+O2Ug3ew34skwQL0Aw40U8L3McyC1lkKPfr3v+4zAi/k7vJUWRg9B4Etf19ihMO
QmzGTdRKfghNiLbLAVWYzUaduJ3rN7FltJysV9BkDDinxfeGfWJNG3SHbvnb35hb
9GggHt0iznk=
=VKbr
-----END PGP SIGNATURE-----
--=-=-=--
