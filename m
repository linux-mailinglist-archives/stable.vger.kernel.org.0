Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEAD211F762
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfLOLMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:12:16 -0500
Received: from 50-87-157-213.static.tentacle.fi ([213.157.87.50]:46010 "EHLO
        bitmer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfLOLMQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 06:12:16 -0500
Received: from dsl-hkibng31-54fab8-157.dhcp.inet.fi ([84.250.184.157] helo=[192.168.1.42])
        by bitmer.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <jarkko.nikula@bitmer.com>)
        id 1igRoq-0002q7-1j; Sun, 15 Dec 2019 13:12:12 +0200
Subject: Re: [PATCH] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection
 GPIO polarity
From:   Jarkko Nikula <jarkko.nikula@bitmer.com>
To:     Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-omap@vger.kernel.org, stable@vger.kernel.org
References: <20191116151651.7042-1-jarkko.nikula@bitmer.com>
 <20191125111125.AF5D720836@mail.kernel.org>
 <27e677de-4e45-7eef-45b5-796e29fd39c0@bitmer.com>
Message-ID: <fa4993eb-9cfb-5976-ae3b-3e22a1ddcd69@bitmer.com>
Date:   Sun, 15 Dec 2019 13:12:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <27e677de-4e45-7eef-45b5-796e29fd39c0@bitmer.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/19 8:27 PM, Jarkko Nikula wrote:
> On 11/25/19 1:11 PM, Sasha Levin wrote:
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags cell for OMAP2+ boards").
>>
>> The bot has tested the following trees: v5.3.12, v4.19.85, v4.14.155, v4.9.202, v4.4.202.
>>
>> v5.3.12: Build OK!
>> v4.19.85: Build OK!
>> v4.14.155: Build OK!
>> v4.9.202: Failed to apply! Possible dependencies:
>>     1a177cf72b3a ("ARM: dts: dra72-evm-tps65917: Add voltage supplies to usb_phy, mmc, dss")
>>     45ea75eb92a4 ("ARM: dts: omap*: Replace deprecated "vmmc_aux" with "vqmmc"")
>>     5d080aa30681 ("ARM: dts: dra72: Add separate dtsi for tps65917")
>>     6eebfeb9cf0d ("ARM: dts: Add support for dra718-evm")
>>     e9a05fbd21de ("ARM: dts: dra72-evm: Fix modelling of regulators")
>>
>> v4.4.202: Failed to apply! Possible dependencies:
>>     12ca468306a2 ("ARM: dts: am57xx: cl-som-am57x: add dual EMAC support")
>>     1a472e14ba08 ("ARM: dts: am57xx: cl-som-am57x: dts: add RTC support")
>>     27ddd846cb25 ("ARM: dts: am57xx: cl-som-am57x: add USB support")
>>     2c7cf1f48f36 ("ARM: dts: am57xx: cl-som-am57x: add EEPROM support")
>>     2d47fc3b9801 ("ARM: dts: am57xx: cl-som-am57x: add touchscreen support")
>>     317d15679a5e ("ARM: dts: dra72-evm: Mark uart1 rxd as wakeup capable")
>>     387450fc882e ("ARM: dts: am57xx: cl-som-am57x: add basic module support")
>>     3a1de8082405 ("ARM: dts: dra7xx: Fix compatible string for PCF8575 chip")
>>     4424cd009648 ("ARM: dts: am57xx: cl-som-am57x: add analog audio support")
>>     45ea75eb92a4 ("ARM: dts: omap*: Replace deprecated "vmmc_aux" with "vqmmc"")
>>     488f270d90e1 ("ARM: dts: dra7: Fix NAND device nodes")
>>     4e8603eff519 ("ARM: dts: omap: remove unneeded unit name for sound nodes")
>>     6686f744df70 ("ARM: dts: DRA72-EVM: Add regulator-allow-bypass property for ldo1 and ldo2")
>>     6cfec12f2545 ("ARM: dts: dra72-evm: Enable AFIFO use for McASP3")
>>     6eebfeb9cf0d ("ARM: dts: Add support for dra718-evm")
>>     8deb60f535fa ("ARM: dts: am57xx: cl-som-am57x: add eMMC support")
>>     9255ea8472d2 ("ARM: dts: dra72-evm: Use DRA7XX_CORE_IOPAD pinmux macro")
>>     a23fc1558487 ("ARM: dts: dra7x-evm: Provide NAND ready pin")
>>     a4240d3af677 ("ARM: dts: Add support for dra72-evm rev C (SR2.0)")
>>     a7cac713f90a ("ARM: dts: AM572x-IDK Initial Support")
>>     cc2d681420d0 ("ARM: dts: am57xx: cl-som-am57x: add spi-flash support")
>>     e1fdd060f08d ("ARM: dts: am57xx: sbc-am57x: add basic board support")
>>     e9a05fbd21de ("ARM: dts: dra72-evm: Fix modelling of regulators")
>>
>>
>> NOTE: The patch will not be queued to stable trees until it is upstream.
>>
>> How should we proceed with this patch?
>>
> Ah, it doesn't apply to v4.4 and v4.9 due the commit 45ea75eb92a4 ("ARM:
> dts: omap*: Replace deprecated "vmmc_aux" with "vqmmc"") but that commit
> doesn't apply either stable and probably even should not even if it would.
> 
> I believe best is me to submit a separate version for v4.4/v4.9.
> 
Interesting, went checking this again today. Actually both v4.4.202 and
v4.9.206 work ok and independently of card detect polarity. So both -
and + lines below work:

diff --git a/arch/arm/boot/dts/omap3-tao3530.dtsi
b/arch/arm/boot/dts/omap3-tao3530.dtsi
index dc80886b5329..e3dfba8b3efe 100644
--- a/arch/arm/boot/dts/omap3-tao3530.dtsi
+++ b/arch/arm/boot/dts/omap3-tao3530.dtsi
@@ -225,7 +225,7 @@
        pinctrl-0 = <&mmc1_pins>;
        vmmc-supply = <&vmmc1>;
        vmmc_aux-supply = <&vsim>;
-       cd-gpios = <&twl_gpio 0 GPIO_ACTIVE_HIGH>;
+       cd-gpios = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
        bus-width = <8>;
 };

Unfortunately I don't have time to dig deeper at the moment was there
regression somewhere else like in TWL GPIO or MMC why card detection is
always active in MMC point of view.

So it looks for now on there is no need to have separate version for
v4.4/v4.9 from my patch.

-- 
Jarkko
