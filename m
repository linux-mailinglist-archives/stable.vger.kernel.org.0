Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D992173A0D
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 15:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgB1Okf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 09:40:35 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:30010 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgB1Okf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 09:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582900833;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Jh82InUV2upNUyEKq5fyvNlau0sOPuIK2LHzeIGPEiE=;
        b=hGxPnYVdUwJWRk4xvDAXNqoGO5b0y5LN6A7XCnko5/nYXJn4D3WZVutnKr/GUpwwf5
        SeCyNG4eCEh3rFBMOgRxwtVF84NxqjBm65f6AnphP69W8yKtATVhpnDQRJx6qgTWTIjo
        xrke0aITeQ2nkpRRQfJyKI2fXiYBpIDqPwuLTQ/Z2l0Ps4M8Ys8OJ5TSW4hhoYiFim/i
        5lhBSDWnJGJdWfRghtXH0UN3pZUo9LurViFy/7ywJdVb+xtYGbZpZMdjM7oby3gnpVtM
        zvxAbrsRhDxBb8dgn6agdqhx/Apt6U4pV8J7dK0p7YrXAhzJKxqfpML4COgUfDJMZk2+
        b/2w==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlaYXAcKqg=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw1SEeG1KW
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 28 Feb 2020 15:40:16 +0100 (CET)
Subject: Re: [PATCH v3 3/6] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=iso-8859-1
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1582900444.3.1@crapouillou.net>
Date:   Fri, 28 Feb 2020 15:40:15 +0100
Cc:     Paul Boddie <paul@boddie.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D609AAD9-C068-449C-9CB6-044999A9CC99@goldelico.com>
References: <cover.1581884459.git.hns@goldelico.com> <36aa1e80153fbb29eeb56f65cac9e3672165f7b7.1581884459.git.hns@goldelico.com> <1582900444.3.1@crapouillou.net>
To:     Paul Cercueil <paul@crapouillou.net>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> Am 28.02.2020 um 15:34 schrieb Paul Cercueil <paul@crapouillou.net>:
>=20
> Hi Nikolaus,
>=20
>=20
> Le dim., f=E9vr. 16, 2020 at 21:20, H. Nikolaus Schaller =
<hns@goldelico.com> a =E9crit :
>> There is a ACT8600 on the CI20 board and the bindings of the
>> ACT8865 driver have changed without updating the CI20 device
>> tree. Therefore the PMU can not be probed successfully and
>> is running in power-on reset state.
>> Fix DT to match the latest act8865-regulator bindings.
>> Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>> arch/mips/boot/dts/ingenic/ci20.dts | 48 =
++++++++++++++++++++---------
>> 1 file changed, 33 insertions(+), 15 deletions(-)
>> diff --git a/arch/mips/boot/dts/ingenic/ci20.dts =
b/arch/mips/boot/dts/ingenic/ci20.dts
>> index 59c104289ece..4f48bc16fb52 100644
>> --- a/arch/mips/boot/dts/ingenic/ci20.dts
>> +++ b/arch/mips/boot/dts/ingenic/ci20.dts
>> @@ -153,6 +153,8 @@
>> 	pinctrl-0 =3D <&pins_uart4>;
>> };
>> +#include <dt-bindings/regulator/active-semi,8865-regulator.h>
>=20
> Includes at the beginning of the file please. Keeps it tidy.

Ok.

Well, I am infected by omap boards where this is not uncommon:

=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/ar=
ch/arm/boot/dts/omap3-beagle-xm.dts?h=3Dv5.6-rc3#n294

But it may be historic and not a good style.

BR and thanks,
Nikolaus

