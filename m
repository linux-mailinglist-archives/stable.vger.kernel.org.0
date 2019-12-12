Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAED511CC75
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 12:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfLLLpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 06:45:46 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33957 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbfLLLpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 06:45:46 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 87F22730;
        Thu, 12 Dec 2019 06:45:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Thu, 12 Dec 2019 06:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4yy/mf
        yeqp/ssdzr+XsQXJ2B1nLiIhHBkihSE4FidX0=; b=Dol4+AThWANER7tsxzPEIX
        NW95ZDS1On6p0s9gqy4Gl8G1mZiTbgVO6rzJWXH2ZalqRSYzwcnLkPMI4wT2MiiS
        E/GcCfD3vAEX1/uJwYBOUKJVzdZzcAUX0h6Zqw27/XU9zsTQFLjNQ1YUQ6Sjil3g
        Q/8xsSUdABrDLbSF9gCUmCQVcXzBRxkV8ydh1idwRhihFQXhwqavB1CQtQ41Om/j
        t0czsZLMEa//0nvlthshpnPvOxYI4u8L+MGMHKMwfG64YJJMI0D+5Hlbnv/V7NVC
        ijbmm7osCWB4Xgg+ugPxTmgDdU0RykE87CgKy6DvBmVRWRlDKVp5q6mNuCx0Tc4g
        ==
X-ME-Sender: <xms:ZyjyXYT4hKc7n74_Mb1ily2ziyno86CJEyi76_KK4QCDou1WmLhMHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeljedgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeforghrvghk
    ucforghrtgiihihkohifshhkihdqifpkrhgvtghkihcuoehmrghrmhgrrhgvkhesihhnvh
    hishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucfkphepledurdeihedrfeegrdef
    feenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghksehinhhvihhsihgslh
    gvthhhihhnghhslhgrsgdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ZyjyXQN2LSZm3P8Qn-aC1l2ffQQJ-bkZ3XjLdyPCwDHAvcbi1rlQCg>
    <xmx:ZyjyXdVvkNAwKbGOU1RrNtj0xs9PCGz30doeHRp75SXjZt7R50AxCg>
    <xmx:ZyjyXTgdRd2ps4gOzLIcUuLAP6C6LKhm9AoXAOPFBmLK4Oj_D4oCFg>
    <xmx:aCjyXfPswloc9LIWbcxc3IW2s-mqTdxiXJccd0Ri7JflafI9qobXQg>
Received: from mail-itl (ip5b412221.dynamic.kabel-deutschland.de [91.65.34.33])
        by mail.messagingengine.com (Postfix) with ESMTPA id F267C3060130;
        Thu, 12 Dec 2019 06:45:42 -0500 (EST)
Date:   Thu, 12 Dec 2019 12:45:40 +0100
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Suwan Kim <suwan.kim027@gmail.com>
Cc:     shuah@kernel.org, valentina.manea.m@gmail.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] usbip: Fix error path of vhci_recv_ret_submit()
Message-ID: <20191212114540.GV11116@mail-itl>
References: <20191212052841.6734-1-suwan.kim027@gmail.com>
 <20191212052841.6734-3-suwan.kim027@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CMEQapY8OuP5ao1l"
Content-Disposition: inline
In-Reply-To: <20191212052841.6734-3-suwan.kim027@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CMEQapY8OuP5ao1l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 2/2] usbip: Fix error path of vhci_recv_ret_submit()

On Thu, Dec 12, 2019 at 02:28:41PM +0900, Suwan Kim wrote:
> If a transaction error happens in vhci_recv_ret_submit(), event
> handler closes connection and changes port status to kick hub_event.
> Then hub tries to flush the endpoint URBs, but that causes infinite
> loop between usb_hub_flush_endpoint() and vhci_urb_dequeue() because
> "vhci_priv" in vhci_urb_dequeue() was already released by
> vhci_recv_ret_submit() before a transmission error occurred. Thus,
> vhci_urb_dequeue() terminates early and usb_hub_flush_endpoint()
> continuously calls vhci_urb_dequeue().
>=20
> The root cause of this issue is that vhci_recv_ret_submit()
> terminates early without giving back URB when transaction error
> occurs in vhci_recv_ret_submit(). That causes the error URB to still
> be linked at endpoint list without =E2=80=9Cvhci_priv".
>=20
> So, in the case of trasnaction error in vhci_recv_ret_submit(),
                       ^^^ typo

> unlink URB from the endpoint, insert proper error code in
> urb->status and give back URB.
>=20
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
=2Ecom>
> Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>

Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>

> ---
>  drivers/usb/usbip/vhci_rx.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
> index 33f8972ba842..dc26acad6baf 100644
> --- a/drivers/usb/usbip/vhci_rx.c
> +++ b/drivers/usb/usbip/vhci_rx.c
> @@ -77,16 +77,21 @@ static void vhci_recv_ret_submit(struct vhci_device *=
vdev,
>  	usbip_pack_pdu(pdu, urb, USBIP_RET_SUBMIT, 0);
> =20
>  	/* recv transfer buffer */
> -	if (usbip_recv_xbuff(ud, urb) < 0)
> -		return;
> +	if (usbip_recv_xbuff(ud, urb) < 0) {
> +		urb->status =3D -EPIPE;
> +		goto error;
> +	}
> =20
>  	/* recv iso_packet_descriptor */
> -	if (usbip_recv_iso(ud, urb) < 0)
> -		return;
> +	if (usbip_recv_iso(ud, urb) < 0) {
> +		urb->status =3D -EPIPE;
> +		goto error;
> +	}
> =20
>  	/* restore the padding in iso packets */
>  	usbip_pad_iso(ud, urb);
> =20
> +error:
>  	if (usbip_dbg_flag_vhci_rx)
>  		usbip_dump_urb(urb);
> =20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?

--CMEQapY8OuP5ao1l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAl3yKGQACgkQ24/THMrX
1yyGhwf6Ao9XCbDr3/5+tsoBrYZRGAUiFToowB3TYnozElhzWd6C324buzzhKOAI
qQOTLtxe75OamWTSlJgdzPscrPL2e2vmu5zvmJm0qdWaW3+5wOT8SqLt0eXhpLx/
PF9Yyw/cUaXWSlYNZVcYtVC1BaY0Qrnzcb/Pwb90N8QtbUVIexDMZqyJQf9TCxx0
7QppyGr1tA+jT2vtJEEjVpRG978vd4Ma2aNMod3E34pjzGJJ+2p+igdZ9NrIKMwj
+BFIKqLXjsmby0WJskDGFQcVqH8Yw116BshrAiSxNcrrviqonGrif41KcqWG54eQ
m8UwtNUUAleiStYns1hb0D1OoQjXTA==
=+pPz
-----END PGP SIGNATURE-----

--CMEQapY8OuP5ao1l--
