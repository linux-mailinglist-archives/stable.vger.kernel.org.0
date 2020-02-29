Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3641748E7
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 20:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgB2Tdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 14:33:46 -0500
Received: from outils.crapouillou.net ([89.234.176.41]:60244 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbgB2Tdq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 14:33:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1583004823; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3pmaIIz4IWO5Cvqd4//x0wCrBroxzaVqn7Ua9M/d+fM=;
        b=dD3gpeUqqLiw2RU0TENRCfQCPkiALo0x/dQt+L+Ch7pFN2UY+ZfyPMwm8gSOku0GTx7ynK
        6EAbDQOnrq2MGUVRCFnibZYqbFBX35UJZAgz5fuN7y8iY5jIGhSb7ngVVtnYldsLvjipQh
        sNHV0Ap2AwvZ55qftn3oLnWuUGZE+/s=
Date:   Sat, 29 Feb 2020 16:33:21 -0300
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH v4 2/5] MIPS: DTS: CI20: fix PMU definitions for ACT8600
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
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
Message-Id: <1583004801.3.3@crapouillou.net>
In-Reply-To: <F5AAAD52-2C1D-4B14-AA7E-590D026C7DBE@goldelico.com>
References: <cover.1582912972.git.hns@goldelico.com>
        <af70bb34d95746cdbc468e91e531c4576a1855a6.1582912972.git.hns@goldelico.com>
        <1582992575.3.2@crapouillou.net>
        <F5AAAD52-2C1D-4B14-AA7E-590D026C7DBE@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Nikolaus,


Le sam., f=E9vr. 29, 2020 at 19:58, H. Nikolaus Schaller=20
<hns@goldelico.com> a =E9crit :
> Hi Paul,
>=20
>>  Am 29.02.2020 um 17:09 schrieb Paul Cercueil <paul@crapouillou.net>:
>>=20
>>  Hi Nikolaus,
>>=20
>>=20
>>  Le ven., f=E9vr. 28, 2020 at 19:02, H. Nikolaus Schaller=20
>> <hns@goldelico.com> a =E9crit :
>>>  There is a ACT8600 on the CI20 board and the bindings of the
>>>  ACT8865 driver have changed without updating the CI20 device
>>>  tree. Therefore the PMU can not be probed successfully and
>>>  is running in power-on reset state.
>>>  Fix DT to match the latest act8865-regulator bindings.
>>>  Fixes: 73f2b940474d ("MIPS: CI20: DTS: Add I2C nodes")
>>>  Cc: stable@vger.kernel.org
>>>  Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>>>  ---
>>>  arch/mips/boot/dts/ingenic/ci20.dts | 48=20
>>> ++++++++++++++++++++---------
>>>  1 file changed, 33 insertions(+), 15 deletions(-)
>>>  diff --git a/arch/mips/boot/dts/ingenic/ci20.dts=20
>>> b/arch/mips/boot/dts/ingenic/ci20.dts
>>>  index 59c104289ece..44741e927d2b 100644
>>>  --- a/arch/mips/boot/dts/ingenic/ci20.dts
>>>  +++ b/arch/mips/boot/dts/ingenic/ci20.dts
>>>  @@ -4,6 +4,8 @@
>>>  #include "jz4780.dtsi"
>>>  #include <dt-bindings/clock/ingenic,tcu.h>
>>>  #include <dt-bindings/gpio/gpio.h>
>>>  +#include <dt-bindings/interrupt-controller/irq.h>
>>=20
>>  This include should be in patch 3/5 where it's first used.
>=20
> Yes. That is much better.
>=20
>>=20
>>  With that fixed:
>>  Reviewed-by: Paul Cercueil <paul@crapouillou.net>
>>=20
>>  for the whole series.
>=20
> What is easier: that you fix it during applying somewhere
> or should I send a v5?

I guess send a V5.

- Paul

>=20
> BR,
> Nikolaus
>=20

=

