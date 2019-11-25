Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5FA10937B
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 19:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfKYS1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 13:27:20 -0500
Received: from 50-87-157-213.static.tentacle.fi ([213.157.87.50]:44858 "EHLO
        bitmer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbfKYS1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 13:27:20 -0500
Received: from dsl-hkibng31-54fae3-94.dhcp.inet.fi ([84.250.227.94] helo=[192.168.1.42])
        by bitmer.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <jarkko.nikula@bitmer.com>)
        id 1iZJ4u-0007De-2W; Mon, 25 Nov 2019 20:27:16 +0200
Subject: Re: [PATCH] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection
 GPIO polarity
To:     Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Cc:     linux-omap@vger.kernel.org, stable@vger.kernel.org
References: <20191116151651.7042-1-jarkko.nikula@bitmer.com>
 <20191125111125.AF5D720836@mail.kernel.org>
From:   Jarkko Nikula <jarkko.nikula@bitmer.com>
Message-ID: <27e677de-4e45-7eef-45b5-796e29fd39c0@bitmer.com>
Date:   Mon, 25 Nov 2019 20:27:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125111125.AF5D720836@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/25/19 1:11 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags cell for OMAP2+ boards").
> 
> The bot has tested the following trees: v5.3.12, v4.19.85, v4.14.155, v4.9.202, v4.4.202.
> 
> v5.3.12: Build OK!
> v4.19.85: Build OK!
> v4.14.155: Build OK!
> v4.9.202: Failed to apply! Possible dependencies:
>     1a177cf72b3a ("ARM: dts: dra72-evm-tps65917: Add voltage supplies to usb_phy, mmc, dss")
>     45ea75eb92a4 ("ARM: dts: omap*: Replace deprecated "vmmc_aux" with "vqmmc"")
>     5d080aa30681 ("ARM: dts: dra72: Add separate dtsi for tps65917")
>     6eebfeb9cf0d ("ARM: dts: Add support for dra718-evm")
>     e9a05fbd21de ("ARM: dts: dra72-evm: Fix modelling of regulators")
> 
> v4.4.202: Failed to apply! Possible dependencies:
>     12ca468306a2 ("ARM: dts: am57xx: cl-som-am57x: add dual EMAC support")
>     1a472e14ba08 ("ARM: dts: am57xx: cl-som-am57x: dts: add RTC support")
>     27ddd846cb25 ("ARM: dts: am57xx: cl-som-am57x: add USB support")
>     2c7cf1f48f36 ("ARM: dts: am57xx: cl-som-am57x: add EEPROM support")
>     2d47fc3b9801 ("ARM: dts: am57xx: cl-som-am57x: add touchscreen support")
>     317d15679a5e ("ARM: dts: dra72-evm: Mark uart1 rxd as wakeup capable")
>     387450fc882e ("ARM: dts: am57xx: cl-som-am57x: add basic module support")
>     3a1de8082405 ("ARM: dts: dra7xx: Fix compatible string for PCF8575 chip")
>     4424cd009648 ("ARM: dts: am57xx: cl-som-am57x: add analog audio support")
>     45ea75eb92a4 ("ARM: dts: omap*: Replace deprecated "vmmc_aux" with "vqmmc"")
>     488f270d90e1 ("ARM: dts: dra7: Fix NAND device nodes")
>     4e8603eff519 ("ARM: dts: omap: remove unneeded unit name for sound nodes")
>     6686f744df70 ("ARM: dts: DRA72-EVM: Add regulator-allow-bypass property for ldo1 and ldo2")
>     6cfec12f2545 ("ARM: dts: dra72-evm: Enable AFIFO use for McASP3")
>     6eebfeb9cf0d ("ARM: dts: Add support for dra718-evm")
>     8deb60f535fa ("ARM: dts: am57xx: cl-som-am57x: add eMMC support")
>     9255ea8472d2 ("ARM: dts: dra72-evm: Use DRA7XX_CORE_IOPAD pinmux macro")
>     a23fc1558487 ("ARM: dts: dra7x-evm: Provide NAND ready pin")
>     a4240d3af677 ("ARM: dts: Add support for dra72-evm rev C (SR2.0)")
>     a7cac713f90a ("ARM: dts: AM572x-IDK Initial Support")
>     cc2d681420d0 ("ARM: dts: am57xx: cl-som-am57x: add spi-flash support")
>     e1fdd060f08d ("ARM: dts: am57xx: sbc-am57x: add basic board support")
>     e9a05fbd21de ("ARM: dts: dra72-evm: Fix modelling of regulators")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
Ah, it doesn't apply to v4.4 and v4.9 due the commit 45ea75eb92a4 ("ARM:
dts: omap*: Replace deprecated "vmmc_aux" with "vqmmc"") but that commit
doesn't apply either stable and probably even should not even if it would.

I believe best is me to submit a separate version for v4.4/v4.9.

-- 
Jarkko
