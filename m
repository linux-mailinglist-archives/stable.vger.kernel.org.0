Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A611090E9
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 16:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfKYPSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 10:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbfKYPSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 10:18:10 -0500
Received: from [192.168.1.28] (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 588B120740;
        Mon, 25 Nov 2019 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574695089;
        bh=/EbFjbGqEPzBq5AKgrcTxQ8cMnOON5x15eANXr1joZQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=k6qKx75+drxs/Tujxrk4JTWWvM+Dbr0ygGqFkibnQgBgTkxIraZWemmhN4TNx+beX
         laV10q9Yo0gmyxWBFDAtzPHe1U4VmwSNdsoRD/1on18NiVOWk0OFl1xG67kIN+fjwo
         t4/C8Wmfdo/bfIMP+zdqTCAF6s8jiXDYC8yC4Ikk=
Subject: Re: [PATCH] arm64: dts: agilex/stratix10: fix pmu interrupt numbers
To:     Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        linux-stable <stable@vger.kernel.org>
References: <20191121213313.25783-1-dinguyen@kernel.org>
 <20191125111129.0E34A2075C@mail.kernel.org>
From:   Dinh Nguyen <dinguyen@kernel.org>
Openpgp: preference=signencrypt
Autocrypt: addr=dinguyen@kernel.org; prefer-encrypt=mutual; keydata=
 mQINBFEnvWwBEAC44OQqJjuetSRuOpBMIk3HojL8dY1krl8T8GJjfgc/Gh97CfVbrqhV5yQ3
 Sk/MW9mxO9KNvQCbZtthfn62YHmroNwipjZ6wKOMfKdtJR4+8JW/ShIJYnrMfwN8Wki6O+5a
 yPNNCeENHleV0FLVXw3aACxOcjEzGJHYmg4UC+56rfoxPEhKF6aGBTV5aGKMtQy77ywuqt12
 c+hlRXHODmXdIeT2V4/u/AsFNAq6UFUEvHrVj+dMIyv2VhjRvkcESIGnG12ifPdU7v/+wom/
 smtfOAGojgTCqpwd0Ay2xFzgGnSCIFRHp0I/OJqhUcwAYEAdgHSBVwiyTQx2jP+eDu3Q0jI3
 K/x5qrhZ7lj8MmJPJWQOSYC4fYSse2oVO+2msoMTvMi3+Jy8k+QNH8LhB6agq7wTgF2jodwO
 yij5BRRIKttp4U62yUgfwbQtEUvatkaBQlG3qSerOzcdjSb4nhRPxasRqNbgkBfs7kqH02qU
 LOAXJf+y9Y1o6Nk9YCqb5EprDcKCqg2c8hUya8BYqo7y+0NkBU30mpzhaJXncbCMz3CQZYgV
 1TR0qEzMv/QtoVuuPtWH9RCC83J5IYw1uFUG4RaoL7Z03fJhxGiXx3/r5Kr/hC9eMl2he6vH
 8rrEpGGDm/mwZOEoG5D758WQHLGH4dTAATg0+ZzFHWBbSnNaSQARAQABtCFEaW5oIE5ndXll
 biA8ZGluZ3V5ZW5Aa2VybmVsLm9yZz6JAjgEEwECACIFAlbG5oQCGwMGCwkIBwMCBhUIAgkK
 CwQWAgMBAh4BAheAAAoJEBmUBAuBoyj0fIgQAICrZ2ceRWpkZv1UPM/6hBkWwOo3YkzSQwL+
 AH15hf9xx0D5mvzEtZ97ZoD0sAuB+aVIFwolet+nw49Q8HA3E/3j0DT7sIAqJpcPx3za+kKT
 twuQ4NkQTTi4q5WCpA5b6e2qzIynB50b3FA6bCjJinN06PxhdOixJGv1qDDmJ01fq2lA7/PL
 cny/1PIo6PVMWo9nf77L6iXVy8sK/d30pa1pjhMivfenIleIPYhWN1ZdRAkH39ReDxdqjQXN
 NHanNtsnoCPFsqeCLmuUwcG+XSTo/gEM6l2sdoMF4qSkD4DdrVf5rsOyN4KJAY9Uqytn4781
 n6l1NAQSRr0LPT5r6xdQ3YXIbwUfrBWh2nDPm0tihuHoH0CfyJMrFupSmjrKXF84F3cq0DzC
 yasTWUKyW/YURbWeGMpQH3ioDLvBn0H3AlVoSloaRzPudQ6mP4O8mY0DZQASGf6leM82V3t0
 Gw8MxY9tIiowY7Yl2bHqXCorPlcEYXjzBP32UOxIK7y7AQ1JQkcv6pZ0/6lX6hMshzi9Ydw0
 m8USfFRZb48gsp039gODbSMCQ2NfxBEyUPw1O9nertCMbIO/0bHKkP9aiHwg3BPwm3YL1UvM
 ngbze/8cyjg9pW3Eu1QAzMQHYkT1iiEjJ8fTssqDLjgJyp/I3YHYUuAf3i8SlcZTusIwSqnD
 uQINBFEnvWwBEADZqma4LI+vMqJYe15fxnX8ANw+ZuDeYHy17VXqQ7dA7n8E827ndnoXoBKB
 0n7smz1C0I9StarHQPYTUciMLsaUpedEfpYgqLa7eRLFPvk/cVXxmY8Pk+aO8zHafr8yrFB1
 cYHO3Ld8d/DvF2DuC3iqzmgXzaRQhvQZvJ513nveCa2zTPPCj5w4f/Qkq8OgCz9fOrf/CseM
 xcP3Jssyf8qTZ4CTt1L6McRZPA/oFNTTgS/KA22PMMP9i8E6dF0Nsj0MN0R7261161PqfA9h
 5c+BBzKZ6IHvmfwY+Fb0AgbqegOV8H/wQYCltPJHeA5y1kc/rqplw5I5d8Q6B29p0xxXSfaP
 UQ/qmXUkNQPNhsMnlL3wRoCol60IADiEyDJHVZRIl6U2K54LyYE1vkf14JM670FsUH608Hmk
 30FG8bxax9i+8Muda9ok/KR4Z/QPQukmHIN9jVP1r1C/aAEvjQ2PK9aqrlXCKKenQzZ8qbeC
 rOTXSuJgWmWnPWzDrMxyEyy+e84bm+3/uPhZjjrNiaTzHHSRnF2ffJigu9fDKAwSof6SwbeH
 eZcIM4a9Dy+Ue0REaAqFacktlfELeu1LVzMRvpIfPua8izTUmACTgz2kltTaeSxAXZwIziwY
 prPU3cfnAjqxFHO2TwEpaQOMf8SH9BSAaCXArjfurOF+Pi3lKwARAQABiQIfBBgBAgAJBQJR
 J71sAhsMAAoJEBmUBAuBoyj0MnIQAI+bcNsfTNltf5AbMJptDgzISZJrYCXuzOgv4+d1CubD
 83s0k6VJgsiCIEpvELQJsr58xB6l+o3yTBZRo/LViNLk0jF4CmCdXWjTyaQAIceEdlaeeTGH
 d5GqAud9rv9q1ERHTcvmoEX6pwv3m66ANK/dHdBV97vXacl+BjQ71aRiAiAFySbJXnqj+hZQ
 K8TCI/6TOtWJ9aicgiKpmh/sGmdeJCwZ90nxISvkxDXLEmJ1prvbGc74FGNVNTW4mmuNqj/p
 oNr0iHan8hjPNXwoyLNCtj3I5tBmiHZcOiHDUufHDyKQcsKsKI8kqW3pJlDSACeNpKkrjrib
 3KLQHSEhTQCt3ZUDf5xNPnFHOnBjQuGkumlmhkgD5RVguki39AP2BQYp/mdk1NCRQxz5PR1B
 2w0QaTgPY24chY9PICcMw+VeEgHZJAhuARKglxiYj9szirPd2kv4CFu2w6a5HNMdVT+i5Hov
 cJEJNezizexE0dVclt9OS2U9Xwb3VOjs1ITMEYUf8T1j83iiCCFuXqH4U3Eji0nDEiEN5Ac0
 Jn/EGOBG2qGyKZ4uOec9j5ABF7J6hyO7H6LJaX5bLtp0Z7wUbyVaR4UIGdIOchNgNQk4stfm
 JiyuXyoFl/1ihREfvUG/e7+VAAoOBnMjitE5/qUERDoEkkuQkMcAHyEyd+XZMyXY
Message-ID: <311efb30-0027-44f7-1149-2fbf91f178e7@kernel.org>
Date:   Mon, 25 Nov 2019 09:18:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125111129.0E34A2075C@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply to v5.3.12

Thanks,
Dinh

On 11/25/19 5:11 AM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 78cd6a9d8e15 ("arm64: dts: Add base stratix 10 dtsi").
> 
> The bot has tested the following trees: v5.3.12, v4.19.85, v4.14.155, v4.9.202, v4.4.202.
> 
> v5.3.12: Build OK!
> v4.19.85: Failed to apply! Possible dependencies:
>     4b36daf9ada3 ("arm64: dts: agilex: Add initial support for Intel's Agilex SoCFPGA")
> 
> v4.14.155: Failed to apply! Possible dependencies:
>     4b36daf9ada3 ("arm64: dts: agilex: Add initial support for Intel's Agilex SoCFPGA")
>     7e7962dd1a53 ("kbuild: handle dtb-y and CONFIG_OF_ALL_DTBS natively in Makefile.lib")
>     cbbde59b29d7 ("arm64: dts: sort vendor subdirectories in Makefile alphabetically")
> 
> v4.9.202: Failed to apply! Possible dependencies:
>     06edb80f8c79 ("arm64: dts: Add Actions Semi S900 and Bubblegum-96")
>     0a07236269fa ("arm64: dts: meson-gxm: Add R-Box Pro")
>     15abee8ab055 ("ARM64: dts: amlogic: Add basic support for Amlogic S905X")
>     1d92bc896e2b ("ARM64: dts: meson-gxl-p23x: Add SD/SDIO/MMC and PWM nodes")
>     2ff2836152c4 ("arm64: allwinner: h5: add support for Orange Pi Prime board")
>     4b36daf9ada3 ("arm64: dts: agilex: Add initial support for Intel's Agilex SoCFPGA")
>     4e3886081848 ("arm64: dts: add Pine64 support")
>     4e6118974c7a ("ARM64: dts: meson-gxm: Rename q200 and q201 DT files for consistency")
>     72093fac811f ("ARM64: dts: meson-gxl-p23x: Enable IR receiver")
>     72a7786c0a0d ("ARM64: dts: Add Realtek RTD1295 and Zidoo X9S")
>     73a5d99febe6 ("ARM64: dts: meson-gxl-p23x: Enable ethernet")
>     7e7962dd1a53 ("kbuild: handle dtb-y and CONFIG_OF_ALL_DTBS natively in Makefile.lib")
>     8441add12b9e ("ARM64: dts: meson-gxl: Add support for Nexbox A95X")
>     9d41bbb6e13f ("arm64: allwinner: h5: add support for the Orange Pi PC 2 board")
>     bb51b5350d2f ("ARM64: dts: Add support for Meson GXM")
>     c67fe414059d ("ARM64: dts: meson-gxl-p23x: Add uart pinctrl")
>     c88cc3ee1b20 ("arm64: Prepare Actions Semi S900")
>     d6d1291d3b9d ("arm64: allwinner: h5: add support for NanoPi NEO2 board")
>     da47515ee63f ("ARM64: dts: amlogic: Add basic support for Amlogic S905D")
>     f51b454549b8 ("ARM64: dts: meson-gxm: Add support for the Nexbox A1")
> 
> v4.4.202: Failed to apply! Possible dependencies:
>     06edb80f8c79 ("arm64: dts: Add Actions Semi S900 and Bubblegum-96")
>     0a07236269fa ("arm64: dts: meson-gxm: Add R-Box Pro")
>     15abee8ab055 ("ARM64: dts: amlogic: Add basic support for Amlogic S905X")
>     1c3554fa94d3 ("arm64: dts: add the Alpine v2 EVP")
>     1d92bc896e2b ("ARM64: dts: meson-gxl-p23x: Add SD/SDIO/MMC and PWM nodes")
>     26a7e06dfee9 ("arm64: renesas: r8a7795: Add Renesas R8A7795 SoC support")
>     2e673c7dc37a ("arm64: dts: Add ZTE ZX296718 SoC dts and Makefile")
>     2ff2836152c4 ("arm64: allwinner: h5: add support for Orange Pi Prime board")
>     34b4f6d0599e ("arm64: tegra: Add Tegra132 support")
>     3c7bccccd3ed ("Documentation: devicetree: amlogic: Document Tronsmart Vega S95 boards")
>     49449828ba86 ("dtb: amd: Add support for new AMD Overdrive boards")
>     4a6e0a771eaa ("dtb: amd: Add support for AMD/Linaro 96Boards Enterprise Edition Server board")
>     4b36daf9ada3 ("arm64: dts: agilex: Add initial support for Intel's Agilex SoCFPGA")
>     4e3886081848 ("arm64: dts: add Pine64 support")
>     4e6118974c7a ("ARM64: dts: meson-gxm: Rename q200 and q201 DT files for consistency")
>     4f24eda8401f ("ARM64: dts: Prepare configs for Amlogic Meson GXBaby")
>     56a0eccdc0de ("arm64: dts: Add dts files for LG Electronics's lg1312 SoC")
>     72093fac811f ("ARM64: dts: meson-gxl-p23x: Enable IR receiver")
>     72a7786c0a0d ("ARM64: dts: Add Realtek RTD1295 and Zidoo X9S")
>     73a5d99febe6 ("ARM64: dts: meson-gxl-p23x: Enable ethernet")
>     7e7962dd1a53 ("kbuild: handle dtb-y and CONFIG_OF_ALL_DTBS natively in Makefile.lib")
>     8441add12b9e ("ARM64: dts: meson-gxl: Add support for Nexbox A95X")
>     985b81817ce1 ("Documentation: devicetree: amlogic: Document Meson GXBaby")
>     9d41bbb6e13f ("arm64: allwinner: h5: add support for the Orange Pi PC 2 board")
>     a426e1dee661 ("Documentation: devicetree: amlogic: Document P20x and ODROID-C2 boards")
>     bb51b5350d2f ("ARM64: dts: Add support for Meson GXM")
>     c67fe414059d ("ARM64: dts: meson-gxl-p23x: Add uart pinctrl")
>     c88cc3ee1b20 ("arm64: Prepare Actions Semi S900")
>     cc733bc90636 ("ARM64: dts: amlogic: Add Tronsmart Vega S95 configs")
>     ce3dd55b99b1 ("arm64: Introduce Allwinner SoC config option")
>     d6d1291d3b9d ("arm64: allwinner: h5: add support for NanoPi NEO2 board")
>     da47515ee63f ("ARM64: dts: amlogic: Add basic support for Amlogic S905D")
>     e1a0ebc8d82b ("arm64: dts: uniphier: add PH1-LD10 SoC/board support")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
