Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0ED05BB9BA
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 19:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiIQRMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Sep 2022 13:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiIQRMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Sep 2022 13:12:20 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B742ED53;
        Sat, 17 Sep 2022 10:12:18 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id F2C1732009E6;
        Sat, 17 Sep 2022 13:12:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 17 Sep 2022 13:12:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1663434735; x=1663521135; bh=bArj9BjU9M
        rWjWVcoZXDDd7XqFxEELIP2Z5TIthfYVk=; b=SVGA9qYmWZbvg6SUImGujYkUDc
        xnKDdzssqV1lEo+Vv3k1w06oU+RrET8ycLGUot7lBJVmHrBZKGxb3MmJ82/Anw88
        AJb1NAnf4CU2KSzGSIuKpDYpIfSueYA7lpcUvuo+Ofi/1ZUQDCk32eRYlfWl0PgN
        AHfaecunke3hHsRJ/3Dys0lWJXCdKbI09kOKszbXZgoPwwRu4FG6SSGSoZHMMHcu
        UZz+8xCP4ZE7I1RBBSUCRSu1MSXRyVsR2iPzfOfzbgO30b3xcQhQyGhAJ4mV3ylU
        HJWTYmJtH1cGvX6jBUTlZl75KtC2ORHAiwB3l+LHj9U+tSb3VfzyA0qZ9YEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1663434735; x=1663521135; bh=bArj9BjU9MrWjWVcoZXDDd7XqFxE
        ELIP2Z5TIthfYVk=; b=BJhLKL6NlxKbNVJxypIbE3jKTF7sfLW56JLUJFeSnFDr
        fRUzuxJUXoQraEHKuT7ErRqq5Q8dQp8C5vyBnRb5/8KLvcXvQU4h/0pSrIOj4OjA
        0AkTCUljOMov1uS+4lhmDtz0Wv2YqxxsBW9B6PYv8DgkNM5WSlKxLwPfFGpHqJPZ
        rUiz8sm+tkMpD6z3mZqT2s5B3zSlEFJ3Nj65Swm3KoTO3ToDZDCif+n3WQhPaGj5
        VnoTZsg/aqVuWtcjF/85IxPGdijHWC6S9DodVhsHDGlVJM0C/EoDyTWF58zFtiDy
        UW0VJ87HV9GT1iEpJpuqkF1nsnPPLUWpOLC8QfDW9Q==
X-ME-Sender: <xms:7_8lY-MX254mTeZTPWhIxRp7v_MFTrEIUMxioNRczaqxUrlR0PYcQQ>
    <xme:7_8lY885-aEo8IOMt9ray5X1Kn2W4cPIczz3APS-jkLzRvg_c4Mpo7xCL049MCGLp
    lQSoB_C-bGFNBHDyA>
X-ME-Received: <xmr:7_8lY1TvQaWlqQo9_gKZAnrsZ_xjSC3brIeR-ybeg6bqOm0HQKmRTeJFYSpA8rOdOJPv0FkBkhVwe5Vx8pdCyovc90CkujtrzIpKbcmrH8SH8b__Xxoc2_TwVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvvddgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfvvehfhffujggtsehgtderredtfeejnecuhfhrohhmpefurghm
    uhgvlhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeffjedtgedvtefgfeffhfekffffueeuudeltdehtdfguefggfet
    leffteeiueeuueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhl
    rghnugdrohhrgh
X-ME-Proxy: <xmx:7_8lY-vKa1g8ro9PZg1AG1EkpjfUHwJzpD3CES2nxQqNwOPpk2Cudg>
    <xmx:7_8lY2dMHJX7WKShJVCTt-NL3QmcbmGV1QB8WD91vk3wnEIc6-Y3Fg>
    <xmx:7_8lYy2uiytYWNn-BOnqlyWSW7C9aSWOiQMGqjQV9VzmUalH7jK2Sg>
    <xmx:7_8lY9xUW6M35mv7pLTaPShGomL97Ksfy5nNtzihtrzotmx7EOlp3w>
Feedback-ID: i0ad843c9:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Sep 2022 13:12:14 -0400 (EDT)
Message-ID: <6779635c-a162-0b7e-d124-d88d1ed9e162@sholland.org>
Date:   Sat, 17 Sep 2022 12:12:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux ppc64le; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Mikhail Rudenko <mike.rudenko@gmail.com>
Cc:     stable@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Peter Geis <pgwipeout@gmail.com>
References: <20220917165820.2304306-1-mike.rudenko@gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Subject: Re: [PATCH] phy: rockchip-inno-usb2: Fix otg port initialization
In-Reply-To: <20220917165820.2304306-1-mike.rudenko@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------K0GA3G7afvU1bjxDRtbK6COJ"
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------K0GA3G7afvU1bjxDRtbK6COJ
Content-Type: multipart/mixed; boundary="------------wRWlrcMGJnKXP60IyA87aQ0o";
 protected-headers="v1"
From: Samuel Holland <samuel@sholland.org>
To: Mikhail Rudenko <mike.rudenko@gmail.com>
Cc: stable@vger.kernel.org, linux-phy@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
 Vinod Koul <vkoul@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Peter Geis <pgwipeout@gmail.com>
Message-ID: <6779635c-a162-0b7e-d124-d88d1ed9e162@sholland.org>
Subject: Re: [PATCH] phy: rockchip-inno-usb2: Fix otg port initialization
References: <20220917165820.2304306-1-mike.rudenko@gmail.com>
In-Reply-To: <20220917165820.2304306-1-mike.rudenko@gmail.com>

--------------wRWlrcMGJnKXP60IyA87aQ0o
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 9/17/22 11:58, Mikhail Rudenko wrote:
> There are two issues in rockchip_usb2phy_otg_port_init(): (1) even if
> devm_extcon_register_notifier() returns error, the code proceeds to
> the next if statement and (2) if no extcon is defined in of_node, the
> return value of property_enabled() is reused as the return value of
> the whole function. If the return value of property_enable() is
> nonzero, (2) results in an unexpected probe failure and kernel panic
> in delayed work:

This should be fixed by the following patch which is accepted already:

https://lore.kernel.org/lkml/20220902184543.1234835-1-pgwipeout@gmail.com=
/

>=20
>     Unable to handle kernel NULL pointer dereference at virtual address=
 00000000
>     Mem abort info:
>       ESR =3D 0x0000000086000006
>       EC =3D 0x21: IABT (current EL), IL =3D 32 bits
>       SET =3D 0, FnV =3D 0
>       EA =3D 0, S1PTW =3D 0
>       FSC =3D 0x06: level 2 translation fault
>     user pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000019dc000
>     [0000000000000000] pgd=3D080000000131a003, p4d=3D080000000131a003, =
pud=3D080000000
>     Internal error: Oops: 86000006 [#1] PREEMPT SMP
>     Modules linked in: ipv6
>     CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.0.0-rc5 #114
>     Hardware name: FriendlyElec NanoPi M4 (DT)
>     pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>     pc : 0x0
>     lr : call_timer_fn.constprop.0+0x24/0x80
>     sp : ffff80000a40ba40
>     x29: ffff80000a40ba40 x28: 0000000000000000 x27: ffff80000a40baf0
>     x26: ffff800009e779c0 x25: ffff00007fb28070 x24: ffff00007fb28028
>     x23: ffff80000a40baf0 x22: 0000000000000000 x21: 0000000000000101
>     x20: ffff0000006ad880 x19: 0000000000000000 x18: 0000000000000006
>     x17: ffff8000761af000 x16: ffff80000800c000 x15: 0000000000004000
>     x14: ffff0000006ad880 x13: 000000000000030a x12: 0000000000000000
>     x11: ffff8000761af000 x10: ffff80000800bf40 x9 : ffff00007fb2d038
>     x8 : 0000000000000001 x7 : 0000000000000009 x6 : 0000000000000240
>     x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000200
>     x2 : 000000003fffffff x1 : 0000000000000000 x0 : ffff0000016c9710
>     Call trace:
>      0x0
>      __run_timers+0x220/0x264
>      run_timer_softirq+0x20/0x40
>      __do_softirq+0x10c/0x298
>      __irq_exit_rcu+0xec/0xf4
>      irq_exit_rcu+0x10/0x1c
>      el1_interrupt+0x38/0x70
>      el1h_64_irq_handler+0x18/0x24
>      el1h_64_irq+0x64/0x68
>      cpuidle_enter_state+0x130/0x2fc
>      cpuidle_enter+0x38/0x50
>      do_idle+0x22c/0x2c0
>      cpu_startup_entry+0x24/0x30
>      secondary_start_kernel+0x130/0x14c
>      __secondary_switched+0xb0/0xb4
>     Code: bad PC value
>     ---[ end trace 0000000000000000 ]---
>     Kernel panic - not syncing: Oops: Fatal exception in interrupt
>     SMP: stopping secondary CPUs
>     Kernel Offset: disabled
>     CPU features: 0x4000,0820b021,00001086
>     Memory Limit: none
>     ---[ end Kernel panic - not syncing: Oops: Fatal exception in inter=
rupt ]---
>=20
> Refactor the control flow to avoid both issues. Since the code below
> out: label does no cleanup, return error codes immediately instead of
> using gotos and return success at the end of the function.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 8dc60f8da22f ("phy: rockchip-inno-usb2: Sync initial otg state")=

> Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
> ---
>  drivers/phy/rockchip/phy-rockchip-inno-usb2.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/ph=
y/rockchip/phy-rockchip-inno-usb2.c
> index 0b1e9337ee8e..d31b35d55927 100644
> --- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
> +++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
> @@ -1144,8 +1144,7 @@ static int rockchip_usb2phy_otg_port_init(struct =
rockchip_usb2phy *rphy,
>  	rport->mode =3D of_usb_get_dr_mode_by_phy(child_np, -1);
>  	if (rport->mode =3D=3D USB_DR_MODE_HOST ||
>  	    rport->mode =3D=3D USB_DR_MODE_UNKNOWN) {
> -		ret =3D 0;
> -		goto out;
> +		return 0;
>  	}
> =20
>  	INIT_DELAYED_WORK(&rport->chg_work, rockchip_chg_detect_work);
> @@ -1154,7 +1153,7 @@ static int rockchip_usb2phy_otg_port_init(struct =
rockchip_usb2phy *rphy,
>  	ret =3D rockchip_usb2phy_port_irq_init(rphy, rport, child_np);
>  	if (ret) {
>  		dev_err(rphy->dev, "failed to init irq for host port\n");
> -		goto out;
> +		return ret;
>  	}
> =20
>  	if (!IS_ERR(rphy->edev)) {
> @@ -1162,8 +1161,10 @@ static int rockchip_usb2phy_otg_port_init(struct=
 rockchip_usb2phy *rphy,
> =20
>  		ret =3D devm_extcon_register_notifier(rphy->dev, rphy->edev,
>  					EXTCON_USB_HOST, &rport->event_nb);
> -		if (ret)
> +		if (ret) {
>  			dev_err(rphy->dev, "register USB HOST notifier failed\n");
> +			return ret;
> +		}
> =20
>  		if (!of_property_read_bool(rphy->dev->of_node, "extcon")) {
>  			/* do initial sync of usb state */
> @@ -1172,8 +1173,7 @@ static int rockchip_usb2phy_otg_port_init(struct =
rockchip_usb2phy *rphy,
>  		}
>  	}
> =20
> -out:
> -	return ret;
> +	return 0;
>  }
> =20
>  static int rockchip_usb2phy_probe(struct platform_device *pdev)


--------------wRWlrcMGJnKXP60IyA87aQ0o--

--------------K0GA3G7afvU1bjxDRtbK6COJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE239ji78XkgB1UE6WE858W20av4sFAmMl/+0ACgkQE858W20a
v4trmRAAjRhkWM61wmmM8tkmQuQfmQKYSxd5s0MqBALmXZnXsW449QkhSP27DZk9
hN013x3eHaWfIwjm7jIf1kLgEL2etLkpD+5Fa/Hc7TgQ68hKUkGBAE1UPsTtGmNn
b7hyLbzVu1K1Uv/jHcgFZ1nxQ6QecGukvU+T7HTMCQ+v2dpxy5VfZyaANrUv1jxI
2vpsGXYXUr7iH0zGBmpwhNJvR1rA1kzO79q+ovcIWefuJgI2MkmMmeRZYpzWwCjm
a70nSW7O70XJZFFMiHWasKsw0P7Zin/rDShKea3x7tKpukFzOx4c6BwSOKm9N6JH
Cl5EQvSgPpiW5YO317TmOLrIXt3fqbtRsFRE6IDCsO+4vOdvVcB7/drghZqjmTmk
N8J99QcJfQfeMk+CRRHD+aCTic7URa3IhxLs63Ny5Iv8WnuNyFQg2fo+CRnvOipp
436T9wgICVNHiugpTTY8LOdbYTRd2FnppWORS65wyACqUzUhDPiFKUSKfEc2wPAc
fQ6R8pBgggculq9YjPzAuHbOWXaUzHDBLP6KdEcZN3XBk1z1LbrjsgEQmf8msUES
C6Lm7ioUVXAUY2/Pys4oq+R27pRXq8wfgFMRhS+bmkBEoYtsOj63GNbrGSy6nvCA
1Pgtm9A7OOwBgZvZZI+FJEirbUFD3BJ3PceApBlUo9MZcqBqz+A=
=5Ert
-----END PGP SIGNATURE-----

--------------K0GA3G7afvU1bjxDRtbK6COJ--
