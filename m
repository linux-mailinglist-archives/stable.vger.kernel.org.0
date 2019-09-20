Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EEDB8D85
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 11:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408420AbfITJTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 05:19:18 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:31670 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405672AbfITJTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 05:19:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1568971153;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=4d7XAVg6DONdnNsY6p2GCEVU1wMuRTgvgCjcdHJpTVA=;
        b=fqFWSVnfHJ/dhj6MDc32JoqUosFcsrNDY8XcPSNcrlxcIuHrrq9wd7QhfqQeEXBwP5
        2jJNXdXZFtiUIbc/71eZpzTGUKTOgdl1/RfpoIX0kVCtiuA73AnPnwmu7ZrhFvNGjDo9
        co2ou3I+w5N0uEclme2T3qP1aQsyQQ6+txxYughePV0PSXLiczNd13aRFlfplDzsEktv
        F1c4mAk3T8uIcsK8Plbfn4NxwMCdsXEzx/cxp20tugczbTe/tIBV0qrO+6eG7luNbtOh
        kj0ntt0cLWaeW8TNC8pVD8fyAVkKAoET42pA/O679xScOJGC1atEmbZWqc+HFqTlF+mm
        f9Sg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrpwDCpeWQ="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.27.0 DYNA|AUTH)
        with ESMTPSA id u036f9v8K9JBmCZ
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 20 Sep 2019 11:19:11 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [Letux-kernel] [PATCH 2/2] DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CACRpkdZvpPOM1Ug-=GHf7Z-2VEbJz3Cuo7+0yDFuNm5ShXK8=Q@mail.gmail.com>
Date:   Fri, 20 Sep 2019 11:19:11 +0200
Cc:     Discussions about the Letux Kernel <letux-kernel@openphoenux.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7DF102BC-C818-4D27-988F-150C7527E6CC@goldelico.com>
References: <cover.1562597164.git.hns@goldelico.com> <8ae7cf816b22ef9cecee0d789fcf9e8a06495c39.1562597164.git.hns@goldelico.com> <20190724194259.GA25847@bogus> <2EA06398-E45B-481B-9A26-4DD2E043BF9C@goldelico.com> <CAL_JsqLe_Y9Z6MRt7ojgSVKAb9n95S8j=eGidSVNz2T83j-zPQ@mail.gmail.com> <CACRpkdY0AVnkRa8sV_Z54qfX9SYufvaYYhU0k2+LitXo0sLx2w@mail.gmail.com> <20190831084852.5e726cfa@aktux> <ED6A6797-D1F9-473B-ABFF-B6951A924BC1@goldelico.com> <CACRpkdZQgPVvB=78vOFsHe5n45Vwe4N6JJOcm1_vz5FbAw9CYA@mail.gmail.com> <1624298A-C51B-418A-96C3-EA09367A010D@goldelico.com> <CACRpkdZvpPOM1Ug-=GHf7Z-2VEbJz3Cuo7+0yDFuNm5ShXK8=Q@mail.gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 20.09.2019 um 10:55 schrieb Linus Walleij =
<linus.walleij@linaro.org>:
>=20
> On Tue, Sep 17, 2019 at 4:26 PM H. Nikolaus Schaller =
<hns@goldelico.com> wrote:
>>> Am 17.09.2019 um 00:52 schrieb Linus Walleij =
<linus.walleij@linaro.org>:
>>> On Mon, Sep 16, 2019 at 12:59 PM H. Nikolaus Schaller =
<hns@goldelico.com> wrote:
>>>=20
>>>> ping.
>>>>=20
>>>> Device omap3-gta04 is neither working with v5.3 nor linux-next =
quite a while and we need a solution.
>>>=20
>>> Can't we just apply the last part of the patch in this thread:
>>>=20
>>> diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi
>>> b/arch/arm/boot/dts/omap3-gta04.dtsi
>>> index 9a9a29fe88ec..47bab8e1040e 100644
>>> --- a/arch/arm/boot/dts/omap3-gta04.dtsi
>>> +++ b/arch/arm/boot/dts/omap3-gta04.dtsi
>>> @@ -124,6 +124,7 @@
>>>                       spi-max-frequency =3D <100000>;
>>>                       spi-cpol;
>>>                       spi-cpha;
>>> +                       spi-cs-high;
>>>=20
>>>                       backlight=3D <&backlight>;
>>>                       label =3D "lcd";
>>>=20
>>>=20
>>> Surely this fixes the problem?
>>=20
>> yes, it is a workaround, but appears to violate some policies.
>> E.g. the spi-cs-high; is undocumented but DT bindings maintainer
>> seems to be against documenting it as I had proposed in my
>> other patch.
>=20
> It is documented as a boolean in
> Documentation/devicetree/bindings/spi/spi-controller.yaml
> with the following description:
>=20
>      spi-cs-high:
>        $ref: /schemas/types.yaml#/definitions/flag
>        description:
>          The device requires the chip select active high.
>=20
> So I don't think it is about it being undocumented.

Yes, the basic property is documented. But incomplete.

The strange inversion side-effect on the third gpio parameter
is undocumented and not understandable from this description
alone.

>=20
>> Rather he seems to have proposed a white-list in the driver code.
>> So that the legacy mode is only becoming active for those systems
>> which really need the legacy mode instead of everyone.
>=20
> Yeah that seems like a plausible way forward if we want to
> move away from the legacy way of specifying polarity.
>=20
>> Then, we do not need this patch for GTA04.
>=20
> We don't need to implement the perfect solution up front.
> We can aim for that in the long run. I usually go by the IETF
> motto "rough consensus and running code".
>=20
>> So its up to you to decide which way to go. We are happy with
>> any one that makes mainline work again asap...
>=20
> I suggest to go both way:
> apply this oneliner and tag for stable so that GTA04 works
> again.
>=20
> Then for the next kernel think about a possible more abitious
> whitelist solution and after adding that remove *all* "spi-cs-high"
> flags from all device trees in the kernel after fixing them
> all up.

Ok, that looks like a viable path.

BR and thanks,
Nikolaus

