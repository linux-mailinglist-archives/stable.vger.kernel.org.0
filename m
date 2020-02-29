Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF0361748C9
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 19:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgB2S6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 13:58:37 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:26536 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgB2S6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 13:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1583002712;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=RWt0DnFLtT3Zn2kRM3ZW1ioOA87GUG1MQf6oAoJiwzU=;
        b=CTHuxgaynO5jfFNz2LNhgJYCJeks7SuMzcY0rO2EgTwnhXwTib5OVQFV9ydkis+UHW
        4bQxFmVuZwtYQ7n/+waWJYFnqbJVql2WuMJ54koiA6nUa7L3sATXAw4+DmRYCBjs9zmN
        EgBONQuATI5QsDU7OOxYEc7WcbpIZSn8GSALVB7NR2NDxs9YCUjIob5mVa44VJqfzZXz
        h8OnJo9AHfhqlvWRY5vMwT6zyM+coGPS9VVARGbu3dc4j4qG9D2+pKUW4ZIlt4XR9P4E
        AUNHaEXX5bfqLpZ5lybrQKf/bo1JmPUdZ+ro7l3QKZ1zpXkUFaxaB+Zii7ZMwo8agzih
        kRiQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlafXAwF5A=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.2.0 DYNA|AUTH)
        with ESMTPSA id y0a02cw1TIwM6hG
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Sat, 29 Feb 2020 19:58:22 +0100 (CET)
Subject: Re: [PATCH v4 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=iso-8859-1
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <1582992575.3.2@crapouillou.net>
Date:   Sat, 29 Feb 2020 19:58:21 +0100
Cc:     Paul Boddie <paul@boddie.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        devicetree@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F5AAAD52-2C1D-4B14-AA7E-590D026C7DBE@goldelico.com>
References: <cover.1582912972.git.hns@goldelico.com> <af70bb34d95746cdbc468e91e531c4576a1855a6.1582912972.git.hns@goldelico.com> <1582992575.3.2@crapouillou.net>
To:     Paul Cercueil <paul@crapouillou.net>
X-Mailer: Apple Mail (2.3124)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

> Am 29.02.2020 um 17:09 schrieb Paul Cercueil <paul@crapouillou.net>:
>=20
> Hi Nikolaus,
>=20
>=20
> Le ven., f=E9vr. 28, 2020 at 19:02, H. Nikolaus Schaller =
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
>> index 59c104289ece..44741e927d2b 100644
>> --- a/arch/mips/boot/dts/ingenic/ci20.dts
>> +++ b/arch/mips/boot/dts/ingenic/ci20.dts
>> @@ -4,6 +4,8 @@
>> #include "jz4780.dtsi"
>> #include <dt-bindings/clock/ingenic,tcu.h>
>> #include <dt-bindings/gpio/gpio.h>
>> +#include <dt-bindings/interrupt-controller/irq.h>
>=20
> This include should be in patch 3/5 where it's first used.

Yes. That is much better.

>=20
> With that fixed:
> Reviewed-by: Paul Cercueil <paul@crapouillou.net>
>=20
> for the whole series.

What is easier: that you fix it during applying somewhere
or should I send a v5?

BR,
Nikolaus

