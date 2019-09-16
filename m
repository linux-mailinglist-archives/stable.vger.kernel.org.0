Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895C4B38F0
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfIPK72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:59:28 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:32054 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfIPK71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 06:59:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1568631562;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=8qBwnSrBAY6WABqgn1MijqgXdh4BqWoFPcRi7n52+qc=;
        b=fV4Bdm1MBqOybpORSj0ui39/Qw+yJN7x/6Y+fX2NFMLLNLQzbW+Ylqii7n8yN5D021
        +4mgis08kH87STWqeUOz0uxYHZllHJINsL3EwkU+13vbubYBBJXkWlTMEW5ikNN8ss3Y
        B7Xe2HdJ47ypYzg8kE/FbPROOmR6TXcrHrhy695cZUI5/od27EZADuthE/pnoaKZMibA
        ldb1BJ5wRDGoq9y2TOJAmy0Tecf4i6AkgfKKYXtTR4Z9VV8TVHFGlFi+OWO+8Z4MNn87
        rr8QRZdl8OvNe/79lg+kLZmPXKi4XWHqPPWYdeVJUluGdsrI3Aq7QxWToRvDPA0PK5Xc
        tadA==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj4Qpw9iZeHmAgw43rXTg="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 44.27.0 DYNA|AUTH)
        with ESMTPSA id u036f9v8GAxJPvu
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 16 Sep 2019 12:59:19 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [Letux-kernel] [PATCH 2/2] DTS: ARM: gta04: introduce legacy spi-cs-high to make display work again
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20190831084852.5e726cfa@aktux>
Date:   Mon, 16 Sep 2019 12:59:19 +0200
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
Message-Id: <ED6A6797-D1F9-473B-ABFF-B6951A924BC1@goldelico.com>
References: <cover.1562597164.git.hns@goldelico.com> <8ae7cf816b22ef9cecee0d789fcf9e8a06495c39.1562597164.git.hns@goldelico.com> <20190724194259.GA25847@bogus> <2EA06398-E45B-481B-9A26-4DD2E043BF9C@goldelico.com> <CAL_JsqLe_Y9Z6MRt7ojgSVKAb9n95S8j=eGidSVNz2T83j-zPQ@mail.gmail.com> <CACRpkdY0AVnkRa8sV_Z54qfX9SYufvaYYhU0k2+LitXo0sLx2w@mail.gmail.com> <20190831084852.5e726cfa@aktux>
To:     Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ping.

Device omap3-gta04 is neither working with v5.3 nor linux-next quite a =
while and we need a solution.

> Am 31.08.2019 um 08:48 schrieb Andreas Kemnade <andreas@kemnade.info>:
>=20
> Hi,
>=20
> On Mon, 5 Aug 2019 12:29:19 +0200
> Linus Walleij <linus.walleij@linaro.org> wrote:
>=20
>> On Fri, Jul 26, 2019 at 12:43 AM Rob Herring <robh@kernel.org> wrote:
>>> On Thu, Jul 25, 2019 at 12:23 AM H. Nikolaus Schaller =
<hns@goldelico.com> wrote: =20
>>=20
>>>> I tried to convince Linus that this is the right way but he =
convinced
>>>> me that a fix that handles all cases does not exist.
>>>>=20
>>>> There seem to be embedded devices with older DTB (potentially in =
ROM)
>>>> which provide a plain 0 value for a gpios definition. And either =
with
>>>> or without spi-cs-high.
>>>>=20
>>>> Since "0" is the same as "GPIO_ACTIVE_HIGH", the absence of
>>>> spi-cs-high was and must be interpreted as active low for these
>>>> devices. This leads to the inversion logic in code.
>>>>=20
>>>> AFAIR it boils down to the question if gpiolib and the bindings
>>>> should still support such legacy devices with out-of tree DTB,
>>>> but force in-tree DTS to add the legacy spi-cs-high property.
>>>>=20
>>>> Or if we should fix the 2 or 3 cases of in-tree legacy cases
>>>> and potentially break out-of tree DTBs. =20
>>>=20
>>> If it is small number of platforms, then the kernel could handle =
those
>>> cases explicitly as needed.
>>>=20
>>>> IMHO it is more general to keep the out-of-tree DTBs working
>>>> and "fix" what we can control (in-tree DTS). =20

>>>=20
>>> If we do this, then we need to not call spi-cs-high legacy because
>>> we're stuck with it forever. =20
>>=20
>> I agree. The background on it is here:
>> https://lkml.org/lkml/2019/4/2/4
>>=20
>> Not using the negatively defined (i.e. if it is no there, the line is
>> by default active low) spi-cs-high would break
>> PowerPC, who were AFAICT using this to ship devices.
>>=20
> is this thing now just waiting for someone to do a s/legacy//?
>=20
> Regards,
> Andreas

