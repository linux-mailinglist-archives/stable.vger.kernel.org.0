Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27CC43EDC
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbfFMPx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:53:28 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9822 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbfFMPx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 11:53:28 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d0271760001>; Thu, 13 Jun 2019 08:53:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 13 Jun 2019 08:53:26 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 13 Jun 2019 08:53:26 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 13 Jun
 2019 15:53:24 +0000
Subject: Re: [PATCH V2] clk: tegra210: Fix default rates for HDA clocks
To:     Sasha Levin <sashal@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC:     <linux-clk@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <1559743299-11576-1-git-send-email-jonathanh@nvidia.com>
 <20190607002314.4AEF321019@mail.kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d69e549b-1509-b249-0a4e-16417b2ce3e8@nvidia.com>
Date:   Thu, 13 Jun 2019 16:53:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190607002314.4AEF321019@mail.kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560441206; bh=7kUpFFpRMuOMI9kyrgi28sxzCDqI4E0BfWOUhr+G4+s=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=TecXneTy+K46gqE29Dgo0E0GKMaJ8/SpshUuqqkUGKwcN3k9hqz0IXjbNhAs/Uwzd
         lRIAIQ8FRuiRw2iph+6kVxK9I30rMCshr3HPGBrlATXBAzfNdCUDQO9VTpkJRSl6tR
         jv8ZvBmgXBVlgBtOhxVa1nPp+E0xSBNRr331fdNiftCeI7eiUz3yre07RrLTsL1CKx
         xP9mpf8ijZ6c5fP3prwCBs0EhzAEtPEQ4vlFSp1jTcc1gX8+wen+NDcSYPhRV/YLnH
         yeYp9asmz5K160Vtzi36kNqqUiH+tFcfy3f59IWCRueKyW5I88mgcewUtHnM3S1ZZa
         DsnIWsmC5oJ3w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 07/06/2019 01:23, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.7, v5.0.21, v4.19.48, v4.14.123, v4.9.180, v4.4.180.
> 
> v5.1.7: Build OK!
> v5.0.21: Build OK!
> v4.19.48: Failed to apply! Possible dependencies:
>     845d782d9144 ("clk: tegra: Fix maximum audio sync clock for Tegra124/210")
> 
> v4.14.123: Failed to apply! Possible dependencies:
>     26f8590c4a1f ("clk: tegra: Make vic03 a child of pll_c3")
>     845d782d9144 ("clk: tegra: Fix maximum audio sync clock for Tegra124/210")
>     c485ad63abb4 ("clk: tegra: Specify VDE clock rate")
> 
> v4.9.180: Failed to apply! Possible dependencies:
>     24c3ebef1ab6 ("clk: tegra: Add aclk")
>     26f8590c4a1f ("clk: tegra: Make vic03 a child of pll_c3")
>     319af7975c9f ("clk: tegra: Define Tegra210 DMIC sync clocks")
>     34ac2c278b30 ("clk: tegra: Fix ISP clock modelling")
>     3843832fc8ca ("clk: tegra: Handle UTMIPLL IDDQ")
>     845d782d9144 ("clk: tegra: Fix maximum audio sync clock for Tegra124/210")
>     8dce89a1c2cf ("clk: tegra: Don't warn for PLL defaults unnecessarily")
>     9326947f2215 ("clk: tegra: Fix pll_a1 iddq register, add pll_a1")
>     bfa34832df1f ("clk: tegra: Add CEC clock")
>     c485ad63abb4 ("clk: tegra: Specify VDE clock rate")
>     e745f992cf4b ("clk: tegra: Rework pll_u")
> 
> v4.4.180: Failed to apply! Possible dependencies:
>     26f8590c4a1f ("clk: tegra: Make vic03 a child of pll_c3")
>     385f9adf625f ("clk: tegra: Constify pdiv-to-hw mappings")
>     407254da291c ("clk: tegra: pll: Add logic for out-of-table rates for T210")
>     6583a6309e83 ("clk: tegra: pll: Add tegra_pll_wait_for_lock to clk header")
>     845d782d9144 ("clk: tegra: Fix maximum audio sync clock for Tegra124/210")
>     86c679a52294 ("clk: tegra: pll: Fix _pll_ramp_calc_pll logic and _calc_dynamic_ramp_rate")
>     8d99704fde54 ("clk: tegra: Format tables consistently")
>     c485ad63abb4 ("clk: tegra: Specify VDE clock rate")
>     c4947e364b50 ("clk: tegra: Fix 26 MHz oscillator frequency")
>     d907f4b4a178 ("clk: tegra: pll: Add logic for handling SDM data")
>     dd322f047d22 ("clk: tegra: pll: Add specialized logic for Tegra210")
>     e52d7c04bb39 ("clk: tegra: Miscellaneous coding style cleanups")
>     e745f992cf4b ("clk: tegra: Rework pll_u")
> 
> 
> How should we proceed with this patch?

I think that applying to 5.0 and 5.1 is fine for now.

Thanks
Jon

-- 
nvpublic
