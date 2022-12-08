Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71841647107
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLHNuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHNuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:50:05 -0500
Received: from smtp-out-08.comm2000.it (smtp-out-08.comm2000.it [212.97.32.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6D5E3FA;
        Thu,  8 Dec 2022 05:50:03 -0800 (PST)
Received: from [127.0.0.1] (unknown [158.148.10.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-08.comm2000.it (Postfix) with ESMTPSA id 77488426880;
        Thu,  8 Dec 2022 14:49:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670507400;
        bh=yrY8+zB2euV2PqldD+sp9PnBqV0DhXW1r1yjIerNFjs=;
        h=Date:From:To:CC:Subject:In-Reply-To:References;
        b=s+jRvvfe5Jkbrebh5saE+jW8Mm2qGM5ECakblNalqFZ8GTIVCztjIIzGSf271VdxG
         QHLT7cIwWz2Y4iUicPEt8THQBlSFjWw+IloVVFl68S56JNIndVLaVdWdjbh+mVqKOU
         DNNfMVaAGtgMhEeRUJd6/wsQmvyPNEeWgT/k45hxHT1pvyqLiTyRcR1Gn5Pm7ivkCl
         eg79TsGiCCJknYSfGJU8lZpxIygkhND6XbSldKlj3csFy5RZgb3lZbQhNxwZQbG12g
         hlIw7IqNJRlYX7oUhys2qQQXaUbuuETTZ+c0fRNDoGOwWVH3dvc6aN1L8GQ/luV5DE
         pqEQOMY1Cxevw==
Date:   Thu, 08 Dec 2022 14:49:57 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
CC:     Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v1=5D_Revert_=22ARM=3A_dts=3A_im?= =?US-ASCII?Q?x7=3A_Fix_NAND_controller_size-cells=22?=
User-Agent: K-9 Mail for Android
In-Reply-To: <2a6c5a08-1649-3f80-cc37-a425f09f3a67@denx.de>
References: <20221205152327.26881-1-francesco@dolcini.it> <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de> <20221208115124.6cc7a8bf@xps-13> <2a6c5a08-1649-3f80-cc37-a425f09f3a67@denx.de>
Message-ID: <544539BE-F7C2-4484-9588-6428EFA8A537@dolcini.it>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 8 dicembre 2022 14:21:31 CET, Marek Vasut <marex@denx=2Ede> ha scritto:
>On 12/8/22 11:51, Miquel Raynal wrote:
>> Hi Shawn,
>
>Hi,
>
>> + Thorsten
>>=20
>> marex@denx=2Ede wrote on Mon, 5 Dec 2022 17:26:53 +0100:
>>=20
>>> On 12/5/22 16:23, Francesco Dolcini wrote:
>>>> From: Francesco Dolcini <francesco=2Edolcini@toradex=2Ecom>
>>>>=20
>>>> This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb=2E
>>>>=20
>>>> It introduced a boot regression on colibri-imx7, and potentially any
>>>> other i=2EMX7 boards with MTD partition list generated into the fdt b=
y
>>>> U-Boot=2E
>>>>=20
>>>> While the commit we are reverting here is not obviously wrong, it fix=
es
>>>> only a dt binding checker warning that is non-functional, while it
>>>> introduces a boot regression and there is no obvious fix ready=2E
>>>>=20
>>>> Cc: stable@vger=2Ekernel=2Eorg
>>>> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells"=
)
>>>> Link: https://lore=2Ekernel=2Eorg/all/Y4dgBTGNWpM6SQXI@francesco-nb=
=2Eint=2Etoradex=2Ecom/
>>>> Link: https://lore=2Ekernel=2Eorg/all/20221205144917=2E6514168a@xps-1=
3/
>>>> Signed-off-by: Francesco Dolcini <francesco=2Edolcini@toradex=2Ecom>
>> [=2E=2E=2E]
>>> Reviewed-by: Miquel Raynal <miquel=2Eraynal@bootlin=2Ecom>
>> [=2E=2E=2E]
>>> Acked-by: Marek Vasut <marex@denx=2Ede>
>> [=2E=2E=2E]
>>=20
>> As discussed in the above links, boot is broken on imx7 Colibri boards,
>> this revert was the most quick and straightforward fix we agreed upon
>> with the hope (~ duty?) it would make it in v6=2E1=2E Any chance you co=
uld
>> pick this up rapidly and forward it to Linus? Or should we involve
>> him directly (Thorsten?)=2E
>
>It seems neither Francesco nor me agree that this is the right approach a=
nd rather the fix should be the two-liner change to the OF partition parser=
, so maybe this should not be picked ?

I think that the 2 lines change might not be good enough to properly handl=
e the U-Boot generated OF partitions in the general case, even if it fixes =
my specific issue=2E

Given that I would do the revert as an immediate first step=2E

Francesco=20

