Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9B2B03F8
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 12:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgKLLep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 06:34:45 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18871 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgKLLeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 06:34:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fad1ddb0001>; Thu, 12 Nov 2020 03:34:51 -0800
Received: from [10.26.72.124] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Nov
 2020 11:34:40 +0000
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Dmitry Osipenko <digetx@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20201111103847.152721-1-jonathanh@nvidia.com>
 <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
 <5409bbb4-d3f9-ccc9-ac3e-6344975bd58e@nvidia.com>
 <acadbf40-5dea-eee1-b05e-ad788df56bf7@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <21158311-2843-0c83-2fd5-19dacdd9c21a@nvidia.com>
Date:   Thu, 12 Nov 2020 11:34:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <acadbf40-5dea-eee1-b05e-ad788df56bf7@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605180891; bh=IHvwAMbKqrHNR5N1GZkSBeag2qQBKHNZAPTqztYrHTU=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=JejLUMD3iIlG0EXmEkmkcOEyW9xqomHi32i6ZOZooYeCh5yNBkqofLz3lghjx2vey
         ghDkxXewIjzZpzFHvLonRj9dKvuT1o4m6XGaFxiBWGdfQBG7HCH3ZIrXVFyIvgbQQP
         6ZYJK6c45fqo7eO9f2AKl+ieZf8bPeFhHafymoOzGIwMrDPanL4MwET1z0W0WuWYES
         N56FXGBD9oYGv5m7+8c/P/ZLnqw6NnWoBY59+GdzhF/sE6fwzW74dmBER1wrl9Vbdy
         gb8gZDuRt5Y8hPNi0Ls0p7qAuRTNUrIJfNgg9x0WdkxjtcRvfXkzogq/7ZLYvUjn5W
         ef2Y+P0RqENog==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 12/11/2020 10:51, Dmitry Osipenko wrote:

...

> If you don't see a message in KMSG saying "bringing vdd_cpu to
> 1000000uV", then should be good.

The bootlog shows ...

[    2.271768] tps6586x 3-0034: Found TPS658621C/D, VERSIONCRC is 2c

[    2.280320] vdd_sys: supplied by vdd_5v0

[    2.285153] vdd_sm0,vdd_core: supplied by vdd_sys

[    2.294231] vdd_sm1,vdd_cpu: supplied by vdd_sys

[    2.299984] vdd_sm2,vin_ldo*: supplied by vdd_sys

[    2.305285] REG-LDO_0: supplied by vdd_sm2,vin_ldo*

[    2.311492] vdd_ldo1,avdd_pll*: supplied by vdd_sm2,vin_ldo*

[    2.318053] vdd_ldo2,vdd_rtc: supplied by vdd_sm2,vin_ldo*

[    2.324786] vdd_ldo3,avdd_usb*: supplied by vdd_sm2,vin_ldo*

[    2.331848] vdd_ldo4,avdd_osc,vddio_sys: supplied by vdd_sm2,vin_ldo*

[    2.339104] vdd_ldo5,vcore_mmc: supplied by vdd_sys

[    2.344447] vdd_ldo6,avdd_vdac: Bringing 2850000uV into 1800000-1800000uV

[    2.352226] vdd_ldo6,avdd_vdac: supplied by vdd_sm2,vin_ldo*

[    2.358814] vdd_ldo7,avdd_hdmi,vdd_fuse: supplied by vdd_sm2,vin_ldo*

[    2.366176] vdd_ldo8,avdd_hdmi_pll: supplied by vdd_sm2,vin_ldo*

[    2.372959] vdd_ldo9,avdd_2v85,vdd_ddr_rx: supplied by vdd_sm2,vin_ldo*

[    2.380373] vdd_rtc_out,vdd_cell: supplied by vdd_sys


Jon
