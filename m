Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CCE259FC
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 23:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfEUVcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 17:32:03 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:36244 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfEUVcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 17:32:03 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 73CAD886BF;
        Wed, 22 May 2019 09:32:00 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1558474320;
        bh=KN+7+Y6HuTQUXjJHPxv21KSUpl/58gx83ZuyPRW6tQc=;
        h=From:To:CC:Subject:Date:References;
        b=zSTgqhYY419fkqtmofKeCuVgVVHe+SE+eUbLILv5B/q+2lHVNnt2WlSnSGH6FRgW7
         DIMvZMtLiDJiH3OxjEBD26Xp2r+3k6XSa1Pg3kOMCMc4RZRh4OnNAgGXFKGK7gcwu9
         0Q+Za0H17501RrknBI9quHJXy6JrpT3HHgdDJQlZc90ePcTCbV0XPpdFHAHewjG87X
         Bz1vpKYAIqwLZ50bz6f8PIvP2DWG+Xu6lyhZ01zETNtl11GWWnwULz1xDLe2pMa9aJ
         a60UCLlegL4j3nj970sz7WSwbj0MQOGwpgwPAZkJjAJhivwZgxPS1VSvqE2REpXI5T
         L7LibLI8p2CqQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5ce46e4c0002>; Wed, 22 May 2019 09:31:56 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1156.6; Wed, 22 May 2019 09:32:00 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1156.000; Wed, 22 May 2019 09:32:00 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Philippe Mazenauer <philippe.mazenauer@outlook.de>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>
CC:     Yangtao Li <tiny.windzz@gmail.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: armada-xp: Remove unused variables
Thread-Topic: [PATCH] clk: armada-xp: Remove unused variables
Thread-Index: AQHVEByfB3zMNKUPxE+M+EKg8bXzJw==
Date:   Tue, 21 May 2019 21:31:59 +0000
Message-ID: <b60737773b9049bb80f6b325ac543e67@svr-chch-ex1.atlnz.lc>
References: <VI1PR07MB4432F4F275BC445289FF3D9CFD070@VI1PR07MB4432.eurprd07.prod.outlook.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:3a2c:4aff:fe70:2b02]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Philippe,=0A=
=0A=
On 21/05/19 8:58 PM, Philippe Mazenauer wrote:=0A=
> Variables 'mv98dx3236_gating_desc' and 'mv98dx3236_coreclks' are=0A=
> declared static and initialized, but are not used in the file.=0A=
> =0A=
> ../drivers/clk/mvebu/armada-xp.c:213:41: warning: =91mv98dx3236_gating_de=
sc=92 defined but not used [-Wunused-const-variable=3D]=0A=
>   static const struct clk_gating_soc_desc mv98dx3236_gating_desc[] __init=
const =3D {=0A=
>                                           ^~~~~~~~~~~~~~~~~~~~~~=0A=
> ../drivers/clk/mvebu/armada-xp.c:171:38: warning: =91mv98dx3236_coreclks=
=92 defined but not used [-Wunused-const-variable=3D]=0A=
>   static const struct coreclk_soc_desc mv98dx3236_coreclks =3D {=0A=
>                                        ^~~~~~~~~~~~~~~~~~~=0A=
> =0A=
> Signed-off-by: Philippe Mazenauer <philippe.mazenauer@outlook.de>=0A=
=0A=
The usage of these was moved to a separate file in a later commit and =0A=
the original code wasn't fully cleaned up.=0A=
=0A=
Fixes: 337072604224 ("clk: mvebu: Expand mv98dx3236-core-clock support")=0A=
Cc: stable@vger.kernel.org=0A=
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz>=0A=
=0A=
Thanks=0A=
=0A=
> ---=0A=
>   drivers/clk/mvebu/armada-xp.c | 14 --------------=0A=
>   1 file changed, 14 deletions(-)=0A=
> =0A=
> diff --git a/drivers/clk/mvebu/armada-xp.c b/drivers/clk/mvebu/armada-xp.=
c=0A=
> index fa1568279c23..2ae24a5debd0 100644=0A=
> --- a/drivers/clk/mvebu/armada-xp.c=0A=
> +++ b/drivers/clk/mvebu/armada-xp.c=0A=
> @@ -168,11 +168,6 @@ static const struct coreclk_soc_desc axp_coreclks =
=3D {=0A=
>   	.num_ratios =3D ARRAY_SIZE(axp_coreclk_ratios),=0A=
>   };=0A=
>   =0A=
> -static const struct coreclk_soc_desc mv98dx3236_coreclks =3D {=0A=
> -	.get_tclk_freq =3D mv98dx3236_get_tclk_freq,=0A=
> -	.get_cpu_freq =3D mv98dx3236_get_cpu_freq,=0A=
> -};=0A=
> -=0A=
>   /*=0A=
>    * Clock Gating Control=0A=
>    */=0A=
> @@ -210,15 +205,6 @@ static const struct clk_gating_soc_desc axp_gating_d=
esc[] __initconst =3D {=0A=
>   	{ }=0A=
>   };=0A=
>   =0A=
> -static const struct clk_gating_soc_desc mv98dx3236_gating_desc[] __initc=
onst =3D {=0A=
> -	{ "ge1", NULL, 3, 0 },=0A=
> -	{ "ge0", NULL, 4, 0 },=0A=
> -	{ "pex00", NULL, 5, 0 },=0A=
> -	{ "sdio", NULL, 17, 0 },=0A=
> -	{ "xor0", NULL, 22, 0 },=0A=
> -	{ }=0A=
> -};=0A=
> -=0A=
>   static void __init axp_clk_init(struct device_node *np)=0A=
>   {=0A=
>   	struct device_node *cgnp =3D=0A=
> =0A=
=0A=
