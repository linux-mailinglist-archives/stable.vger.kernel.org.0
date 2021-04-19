Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C0C363F22
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 11:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhDSJsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 05:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhDSJsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 05:48:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CA7361073;
        Mon, 19 Apr 2021 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618825655;
        bh=o1E5RHmxcI9dlSKj6+xBOO7f51oW5nCHPfPKvH3TTv8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Xl+tjnXrPwG5nI97IDHiXuzVpof212XhS6+AZ/qakDk0jl9J04BHKVzHD28LKL/wf
         izeivERr8KfL8Z3VCb6w0OSMVRi5fsYAU2nFDayWGqRJpbo9fCtMltYILToXiq2M4K
         Lv9rMKgKBFnKeae49Mmt8bN744qQQbJjcDKMDekKtv1KP88eQU9zYpLa1XFFiODy0s
         3iApVFWpmV0bpvxK4ovnfDZ7MSDsx/C6pySVOchVFvShqJ0ESp6sUWvJxXxi/GPvRA
         2WFquKzbwVdbCYIrG3p8fEalI8EEPlLzXdp9k2yfY/BV2BS1CnZjANKam9q6pE2Cyg
         5/JW1jRu19xqg==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Ferry Toth <fntoth@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
In-Reply-To: <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
 <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
 <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com>
 <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
 <09755742-c73b-f737-01c1-8ecd309de551@gmail.com>
 <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
Date:   Mon, 19 Apr 2021 12:47:28 +0300
Message-ID: <87h7k2mwr3.fsf@kernel.org>
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
>> (Issue history:
>> https://urldefense.com/v3/__https://github.com/andy-shev/linux/issues/31=
__;!!A4F2R9G_pg!Oa6XGH3IqY3wwG5KK4FwPuNA0m3q5bRj7N6vdP-y4sAY6mya-96J90NJ0tJ=
nXNc7KgAw$
>> )
>>=20
>> On the PC side this resulted to:
>>=20
>> apr 17 18:17:44 delfion kernel: usb 1-5: new high-speed USB device
>> number 12 using xhci_hcd
>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device found,
>> idVendor=3D1d6b, idProduct=3D0104, bcdDevice=3D 1.00
>> apr 17 18:17:44 delfion kernel: usb 1-5: New USB device strings: Mfr=3D1,
>> Product=3D2, SerialNumber=3D3
>> apr 17 18:17:44 delfion kernel: usb 1-5: Product: USBArmory Gadget
>> apr 17 18:17:44 delfion kernel: usb 1-5: Manufacturer: USBArmory
>> apr 17 18:17:44 delfion kernel: usb 1-5: SerialNumber: 0123456789abcdef
>> apr 17 18:17:49 delfion kernel: usb 1-5: can't set config #1, error -110
>>=20
>>=20
>> Thanks for all your help!
>>=20
>
> Looks like it's LPM related again. To confirm, try this:
> Disable LPM with this property "snps,usb2-gadget-lpm-disable"
> (Note that it's not the same as "snps,dis_enblslpm_quirk")
>
> Make sure that your testing kernel has this patch [1]
> 475e8be53d04 ("usb: dwc3: gadget: Check for disabled LPM quirk")
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit=
/?h=3Dusb-next&id=3D475e8be53d0496f9bc6159f4abb3ff5f9b90e8de
>
>
> The failure you saw was probably due the gadget function attempting
> to start a delayed status stage of the SET_CONFIGURATION request.
> By this time, the host already put the device in low power.
>
> The START_TRANSFER command needs to be executed while the device
> is on "ON" state (or U0 if eSS). We shouldn't use dwc->link_state
> to check for link state because we only enable link state change
> interrupt for some controller versions.
>
> Once you confirms disabling LPM works, try this fix:
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 6227641f2d31..06cdec79244e 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -309,10 +309,14 @@ int dwc3_send_gadget_ep_cmd(struct dwc3_ep *dep, un=
signed int cmd,
>=20=20
>         if (DWC3_DEPCMD_CMD(cmd) =3D=3D DWC3_DEPCMD_STARTTRANSFER) {
>                 int             needs_wakeup;
> +               u8              link_state;
>=20=20
> -               needs_wakeup =3D (dwc->link_state =3D=3D DWC3_LINK_STATE_=
U1 ||
> -                               dwc->link_state =3D=3D DWC3_LINK_STATE_U2=
 ||
> -                               dwc->link_state =3D=3D DWC3_LINK_STATE_U3=
);
> +               reg =3D dwc3_readl(dwc->regs, DWC3_DSTS);
> +               link_state =3D DWC3_DSTS_USBLNKST(reg);
> +
> +               needs_wakeup =3D (link_state =3D=3D DWC3_LINK_STATE_U1 ||
> +                               link_state =3D=3D DWC3_LINK_STATE_U2 ||
> +                               link_state =3D=3D DWC3_LINK_STATE_U3);

this makes sense. We used to track state using the state change
interrupts, but that's long since being disabled. I think, either way,
we need this fix.

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmB9UbARHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQZ0iA/+KMpwBmZEN5QDxOHc5F+mE4sApE6Gc5YR
+2Yfu+hlnw/rmUhA4XwSQgG18+tHCSfR1D3rrQmkYtzKRlroc5ycL3rhqQ9RA1TE
+n/OXPk2Rc+aKF9rLIvj52YWOUDGL3Y6/0kWsBuRgAWkMStIOlmB0xJhG3pOrgOM
MUW18RHgu1y9mN1cC4OOYnK4DvCZrJn2phtWnxwmR7KSEpa9Uq8HTqhgghdbvfIZ
D77/WiTv651QEtONjlP113OCINqXZ3NHnS89rVV1CDMrDPRtwFhxpP5xLTd1FLPM
7KDTSsJg8nsbXna1k0QMul8WyOQNGv8CZYOIQweLGBe3dd+sLVTMmxQx/S7pOGUj
9vDsd3pTSeThNSVNVl/r0fUWY7iaNDJEjFoasmC7LLGgKrpxoNXrMPFAU6lBHDzm
HppotOGXJcLb8WdTrH/EJ4Pg/4r3kNld19aOJQ6xJAxRNpXGqdsz1RQR+KYiIKiJ
zj4QiK78c7g+ymWr0Zc9R/nnvfDGTl0usMT8gzbpDW3hKIFrTuNBHXLEoq0V0Izz
6HkryTTgfvGxeLOkzs1XhUOqxg7UOTI/mvmj+TvKCQL1trDRPig4fGoDFoP0ebyr
lIJ9c3bg7zovql05xbVMCkM2QecXsmA/CWOdc3+3G/WV4v1Z+4ryIWlxAHkk+ZsI
YqSuR5l5cJ4=
=T4Lz
-----END PGP SIGNATURE-----
--=-=-=--
