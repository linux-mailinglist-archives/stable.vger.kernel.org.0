Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD0934770
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 15:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfFDNBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 09:01:02 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:36708 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfFDNBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 09:01:01 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x54D0vxP115420;
        Tue, 4 Jun 2019 08:00:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559653257;
        bh=8aM95DBivlDTvSjYE3/afKa3UFfgzZRoy3lHgX+J4cc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QzUBJ8YUrDxwnv0k10gakfDGBJVzGKeh635RlLd85nbcKSCdADMI/r5VUBS3aETuv
         szPYkN5bQZyM+JUSDLSasG8TfAM7qWpbgHroVblgzPR0VnEoDbexlO5FR8HOsdZzBX
         yN2f4w6wC6KjP8X+z7qZ8iekRP5iMrZeel5V9IdE=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x54D0vsa117977
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 4 Jun 2019 08:00:57 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 4 Jun
 2019 08:00:56 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 4 Jun 2019 08:00:56 -0500
Received: from [172.24.190.215] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x54D0rL1090333;
        Tue, 4 Jun 2019 08:00:54 -0500
Subject: Re: [PATCH v3 1/3] mmc: sdhci_am654: Fix SLOTTYPE write
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>
CC:     <ulf.hansson@linaro.org>, <adrian.hunter@intel.com>,
        stable <stable@vger.kernel.org>
References: <20190528095928.26452-2-faiz_abbas@ti.com>
 <20190604125043.C8D40249A2@mail.kernel.org>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <00366591-23db-34a3-2299-90ae97c72a9c@ti.com>
Date:   Tue, 4 Jun 2019 18:31:15 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190604125043.C8D40249A2@mail.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On 04/06/19 6:20 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.1.6, v5.0.20, v4.19.47, v4.14.123, v4.9.180, v4.4.180.
> 
> v5.1.6: Build OK!
> v5.0.20: Build OK!

Please apply it only to the above two releases. I guess this script
could detect that the file was not even present before this and not try
to apply to those.

> v4.19.47: Failed to apply! Possible dependencies:
>     06b23ca021c4 ("mmc: sdhci-of-arasan: Add a single data structure to incorporate pdata and soc_ctl_map")
>     41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
>     f0061fed1f8a ("mmc: sdhci-of-arasan: Add Support for AM654 MMC and PHY")
> 
> v4.14.123: Failed to apply! Possible dependencies:
>     06b23ca021c4 ("mmc: sdhci-of-arasan: Add a single data structure to incorporate pdata and soc_ctl_map")
>     41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
>     7d326930d352 ("mmc: sdhci-omap: Add OMAP SDHCI driver")
>     84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
>     f0061fed1f8a ("mmc: sdhci-of-arasan: Add Support for AM654 MMC and PHY")
> 
> v4.9.180: Failed to apply! Possible dependencies:
>     06b23ca021c4 ("mmc: sdhci-of-arasan: Add a single data structure to incorporate pdata and soc_ctl_map")
>     3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
>     41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
>     7d326930d352 ("mmc: sdhci-omap: Add OMAP SDHCI driver")
>     84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
>     d38dcad4e7b4 ("mmc: sdhci: Let drivers decide whether to use mmc_retune_needed() with pm")
>     f0061fed1f8a ("mmc: sdhci-of-arasan: Add Support for AM654 MMC and PHY")
> 
> v4.4.180: Failed to apply! Possible dependencies:
>     06b23ca021c4 ("mmc: sdhci-of-arasan: Add a single data structure to incorporate pdata and soc_ctl_map")
>     0c7fe32e847f ("mmc: sdhci-of-arasan: fix clk issue in sdhci_arasan_remove()")
>     278d09624eda ("mmc: sdhci-of-arasan: fix missing sdhci_pltfm_free for err handling")
>     3a3748dba881 ("mmc: sdhci-xenon: Add Marvell Xenon SDHC core functionality")
>     3ea4666e8d42 ("mmc: sdhci-of-arasan: Properly set corecfg_baseclkfreq on rk3399")
>     41fd4caeb00b ("mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver")
>     476bf3d62d5c ("mmc: sdhci-brcmstb: Add driver for Broadcom BRCMSTB SoCs")
>     5d9460d74ce5 ("mmc: sdhci-pic32: Add PIC32 SDHCI host controller driver")
>     7d326930d352 ("mmc: sdhci-omap: Add OMAP SDHCI driver")
>     802ac39a5566 ("mmc: sdhci-of-arasan: fix set_clock when a phy is supported")
>     84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
>     89211418cb71 ("mmc: sdhci-of-arasan: use sdhci_pltfm_init for private allocation")
>     91aa366109e8 ("mmc: sdhci-of-arasan: add phy support for sdhci-of-arasan")
>     a05c84651145 ("mmc: sdhci-of-arasan: implement enhanced strobe callback")
>     c390f2110adf ("mmc: sdhci-of-arasan: Add ability to export card clock")
>     ca572f4636aa ("mmc: sdhci-of-arasan: Always power the PHY off/on when clock changes")
>     f0061fed1f8a ("mmc: sdhci-of-arasan: Add Support for AM654 MMC and PHY")
> 
> 
> How should we proceed with this patch?
> 

Thanks,
Faiz
