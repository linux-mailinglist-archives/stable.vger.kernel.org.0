Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D000112C389
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfL2Q45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 11:56:57 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41031 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbfL2Q45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 11:56:57 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 80EFB410;
        Sun, 29 Dec 2019 11:56:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Sun, 29 Dec 2019 11:56:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=q18LxX
        ZEJB6VT+kys+/3Us//yTs1a4XTd0qJi6DGFUw=; b=xf3Q+EUG8ZozHVD2vyQ3cR
        10E0QvlUyYRfqBmMKbCNnJQrg5ILNE92ZCcu+4TkyTNQZMGUTlBHHGQKRD2AcEXH
        i5nBQY3acxQW9zf57rIk6EzzqVoWLSTXed9rr605DnsoG4rMcC49g6tPiWGAfj88
        JEJQbiZIh4jJxC3TTkaLs8KBtkZJaM6yyxcibrXtCe/6A7ygPEBarawelC0m8oXP
        cNl6edX+CNVQ2Ux4TtPkAK8+K9/70qnyyQJzALxNpWEvB05i+XHL3eCWfq8ajVJR
        9K9YH9LxkOhmti4OFWFaKOIkjeMeYIVikcHKU0GHUDGASrVaspZhv/H+gQTMYU9w
        ==
X-ME-Sender: <xms:19oIXk208oFb_FrMhrVkmpWdqrUI7l501RFtFXsssJwbjKxk_GApsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesghdtre
    ertddtjeenucfhrhhomhepofgrrhgvkhcuofgrrhgtiiihkhhofihskhhiqdfikphrvggt
    khhiuceomhgrrhhmrghrvghksehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
    eqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepudehuddrvddujedrvddt
    jedrudelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehmrghrmhgrrhgvkhesihhnvhhish
    hisghlvghthhhinhhgshhlrggsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:19oIXsOvZZRoANUM_4j3TyXEnKkRxQYAk6ZEqTHoAaAFkd0cVVOkmg>
    <xmx:19oIXr5h9bC1C3QZN4ksbYuWcnccQAmbOKQNcfv1dY89m6-7m0Zjow>
    <xmx:19oIXu2ZrAOaP-Bit6_Fxm9N5If8iAJN4s46Msn5Rz3iRdaI0Rf36w>
    <xmx:2NoIXtmYDQ4oFm03WaPcSOECXfGY95V-cd_cZNFDkYToiRR1nXpZyA>
Received: from mail-itl (unknown [151.217.207.19])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4490D3060AA8;
        Sun, 29 Dec 2019 11:56:55 -0500 (EST)
Date:   Sun, 29 Dec 2019 17:56:45 +0100
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     gregkh@linuxfoundation.org
Cc:     suwan.kim027@gmail.com, skhan@linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usbip: Fix receive error in vhci-hcd when
 using" failed to apply to 4.4-stable tree
Message-ID: <20191229165645.GG1292@mail-itl>
References: <157762916119642@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HKEL+t8MFpg/ASTE"
Content-Disposition: inline
In-Reply-To: <157762916119642@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HKEL+t8MFpg/ASTE
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: FAILED: patch "[PATCH] usbip: Fix receive error in vhci-hcd when
 using" failed to apply to 4.4-stable tree

On Sun, Dec 29, 2019 at 03:19:21PM +0100, gregkh@linuxfoundation.org wrote:
>=20
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I think the bug this commit fixes (part of ea44d190764b commit) is not
present in 4.4, nor 4.9 branches.
In short: no need to backport it to 4.4 or 4.9 branch.

> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From d986294ee55d719562b20aabe15a39bf8f863415 Mon Sep 17 00:00:00 2001
> From: Suwan Kim <suwan.kim027@gmail.com>
> Date: Fri, 13 Dec 2019 11:30:54 +0900
> Subject: [PATCH] usbip: Fix receive error in vhci-hcd when using
>  scatter-gather
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3DUTF-8
> Content-Transfer-Encoding: 8bit
>=20
> When vhci uses SG and receives data whose size is smaller than SG
> buffer size, it tries to receive more data even if it acutally
> receives all the data from the server. If then, it erroneously adds
> error event and triggers connection shutdown.
>=20
> vhci-hcd should check if it received all the data even if there are
> more SG entries left. So, check if it receivces all the data from
> the server in for_each_sg() loop.
>=20
> Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub dr=
iver")
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
=2Ecom>
> Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.c=
om>
> Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/20191213023055.19933-2-suwan.kim027@gmail=
=2Ecom
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_c=
ommon.c
> index 6532d68e8808..e4b96674c405 100644
> --- a/drivers/usb/usbip/usbip_common.c
> +++ b/drivers/usb/usbip/usbip_common.c
> @@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct =
urb *urb)
> =20
>  			copy -=3D recv;
>  			ret +=3D recv;
> +
> +			if (!copy)
> +				break;
>  		}
> =20
>  		if (ret !=3D size)
>=20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

--HKEL+t8MFpg/ASTE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAl4I2s0ACgkQ24/THMrX
1yxM4gf/QVgCo0WuroMHcPuIuKrqNzYhVzOc/9ijcWPkIY6q5iaW/L/sYmzetFLK
3NW2RQTfSGJA2ZZcZo1ExdU3R8bYw4P6Q4nk+drEqFmVKqNfuJhnoCAhi+bt7dCG
1feSdbLL/nuxctLvEmCj5k14bWC5gy7dHUsDON1ZJBDGVAmYC9SwJKd1rY5MY07F
1pKuJfdqt+nGWjBtvOMzObGEBAepq73Vdj8a/kMW/cHwsnLeRfnrxpRUB99y9qJV
MkteeoLXBKD5zERY7GExkuhhNkQ5XFOH8FR4YUgixblGHlZcKSGmw6xFT3UAmBWI
PdmBRp3KcyREeZUwm0edURpduZDraw==
=3Xna
-----END PGP SIGNATURE-----

--HKEL+t8MFpg/ASTE--
