Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4937927D280
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 17:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbgI2PPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 11:15:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11600 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgI2PPi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 11:15:38 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f734f8e0001>; Tue, 29 Sep 2020 08:15:26 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 15:15:38 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 29 Sep 2020 15:15:38 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <pavel@denx.de>, <stable@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <284adc47a1ab424eb6b574322f89e768@HQMAIL111.nvidia.com>
Date:   Tue, 29 Sep 2020 15:15:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601392526; bh=uPyUO9kYwwUolBLsliQVrUYyIfuIK2+OII8ZiudcdQ0=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=hgnlsG2A/uELHIrPnrcBzioY9LdD8uzF2UmHP3rfBWzVutJJ6YqYc/6fuWnmk3fY9
         4N8gJxhIkg556uhQZfAuwl8dgqh0Ic8PUZRynjk0TA+O+Glxn9G0nY2hvE/0D1WcwJ
         Uk7lCfUYoTCfWSFz5dsHVVuGe0OqQzGSQzE3yybGTRfHieaLU/KxjaU/E3AKipKCjP
         akcAQ1A+Lm1gUL2tA0HfdGrp33wxQeLtOWKNZwyba9Bm5MSGGT7rgPlEHh1xkYtF5Q
         NFW11bDrXWVCj+VWFyFYnPJX/k7X9CZenW6gYB6oDLKnDH5Fu8zZoB9rRc6lsd4j+s
         fg8mk/Abjp3Vw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Sep 2020 13:00:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.13 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    14 builds:	14 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.13-rc1-g2bea8b771966
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
