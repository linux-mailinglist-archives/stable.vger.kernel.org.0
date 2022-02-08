Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8C4AD7A5
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiBHLi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356384AbiBHLfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 06:35:47 -0500
X-Greylist: delayed 603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 03:30:58 PST
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBDFC03CA4B
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 03:30:58 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 214925C00E0;
        Tue,  8 Feb 2022 06:20:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 08 Feb 2022 06:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d7RS28//0ruM0Q55s
        H7s2j4TekvjwqskaG8l3o1lxzo=; b=ihW/Y8snH6aDQ9BEd8pFdh5V5racXFvxv
        LLSdjantrGQeeHNhUnLZ1VaY45d013rqG6NURq3jKKusrvdovx4pwX7Z9S/vzDMJ
        cVE/zHApa+dwp/LS0yK3ygXV2L68f0jJzyYC5rWj8zL5cSx9D5NRZ56W1kZpPIEe
        WeGWjhiWU03HYYLGXJ/D/epUEsfUweNOsiAPLAhmQjUPGmk6Uhg1pIcbzTZS0slp
        3pcdWpHmWaoe/I4Xx5RN6atybY3fwiUxl/zV4IGPLSSLrsu2VF7qa5C+gWyTRSBF
        iE0RzMhOXiJg7R8BAuhy5KphTCoH7KwTPudCdXdkPpJFHT0A1Grig==
X-ME-Sender: <xms:FFICYvjrOqevvMb7mvta7jppA9r9DwJWZC8F0XyqrsZi-uF3uWZRAw>
    <xme:FFICYsBkrQTiNKHYWRurBmFJV1ztsnl3kYd6Z5klAMtMoUMKCqs2lWFsLnijij9tI
    9iTLTUft4xgZw>
X-ME-Received: <xmr:FFICYvG9uB60agCtb2lcPiBucfcz4b97pFmOtHOWzAIK0gc-tcAgj-I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgvkhcu
    ofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinhhvih
    hsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepteevffei
    gffhkefhgfegfeffhfegveeikeettdfhheevieehieeitddugeefteffnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghksehi
    nhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:FFICYsTRXmzaNzrNfuLMz5YhFILZ-E6jeF-b8ZF5HmrGTY4fYMIeAA>
    <xmx:FFICYswsyel-9aFcCMeTtu8xbLYiaE42jpdb7pD4Hv4fTtVmxYiijA>
    <xmx:FFICYi733f0mi-dNzbxaPqeThMmIgw1Z6vNXw5RR8sFvolwXBq5rPw>
    <xmx:FVICYrrXDIXkX699tU2uujjfdlX72GZ-QvZE7gFZ0XeCsjngcpZbTw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 06:20:51 -0500 (EST)
Date:   Tue, 8 Feb 2022 12:20:46 +0100
From:   Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        Wolfgang Walter <linux@stwm.de>,
        Jason Self <jason@bluehome.net>,
        Dominik Behr <dominik@dominikbehr.com>
Subject: Re: [PATCH] iwlwifi: fix use-after-free
Message-ID: <YgJSEEmRDKKG+3lT@mail-itl>
References: <20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Rj3/8RxUIYFHdmTV"
Content-Disposition: inline
In-Reply-To: <20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Rj3/8RxUIYFHdmTV
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 8 Feb 2022 12:20:46 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
	stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
	Wolfgang Walter <linux@stwm.de>, Jason Self <jason@bluehome.net>,
	Dominik Behr <dominik@dominikbehr.com>
Subject: Re: [PATCH] iwlwifi: fix use-after-free

On Tue, Feb 08, 2022 at 11:47:30AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> If no firmware was present at all (or, presumably, all of the
> firmware files failed to parse), we end up unbinding by calling
> device_release_driver(), which calls remove(), which then in
> iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
> the new code I added will still erroneously access it after it
> was freed.
>=20
> Set 'failure=3Dfalse' in this case to avoid the access, all data
> was already freed anyway.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Stefan Agner <stefan@agner.ch>
> Reported-by: Wolfgang Walter <linux@stwm.de>
> Reported-by: Jason Self <jason@bluehome.net>
> Reported-by: Dominik Behr <dominik@dominikbehr.com>
> Reported-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab=
=2Ecom>
> Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware l=
oad")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Tested-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblethingslab.com>

Thanks!

> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/w=
ireless/intel/iwlwifi/iwl-drv.c
> index 83e3b731ad29..6651e78b39ec 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -1707,6 +1707,8 @@ static void iwl_req_fw_callback(const struct firmwa=
re *ucode_raw, void *context)
>   out_unbind:
>  	complete(&drv->request_firmware_complete);
>  	device_release_driver(drv->trans->dev);
> +	/* drv has just been freed by the release */
> +	failure =3D false;
>   free:
>  	if (failure)
>  		iwl_dealloc_ucode(drv);
> --=20
> 2.34.1
>=20

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--Rj3/8RxUIYFHdmTV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmICUhAACgkQ24/THMrX
1ywGRgf/YiqF+79qOU1oFpLynQ3coyrojc0nCj9bFdMf0PVwfbSDXggH7a3gHzaC
oq5FTdMGbeWysH7dmO/Hea9ppxwMfaVhcopzWmeCpvbPTTse1fpjbYlCwjA8KNHN
mLa5Yz1koLxDLnynovAj9+UiJ4ILFnPJ4/IiVC77Fc862TsEooM/cpnmxoJaVCSD
9HGmlxdoGBq/o5h1t49C4dsJwMoW7gyCHi2KkfHfjZixUaNv26Ta/sDvUvBnoh8R
j+HKSIkGdsJOZn3Z7gU84x6RCcZKRUmBZc6Z/9NSSoN0KZHr3JavIMOjoVl1z2Ca
PIBGTs7aBARQTSJg2ATt08jXXqOG9g==
=HjcN
-----END PGP SIGNATURE-----

--Rj3/8RxUIYFHdmTV--
