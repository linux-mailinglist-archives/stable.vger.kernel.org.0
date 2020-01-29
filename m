Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCF114CB4E
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgA2NQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 08:16:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14884 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgA2NQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 08:16:49 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e31858d0000>; Wed, 29 Jan 2020 05:15:57 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 29 Jan 2020 05:16:48 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 29 Jan 2020 05:16:48 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 29 Jan
 2020 13:16:46 +0000
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200128135817.238524998@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6e27f82c-1804-8041-dd93-7c9e7b5b6c0b@nvidia.com>
Date:   Wed, 29 Jan 2020 13:16:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580303757; bh=Wc0j0t9khzWGY+/QTlfYlP5ZdADkoPl9unOCMJW5iro=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=M8Gc3CzDbK3AkVrZ22z0r1hmHwLgRtqYaSdXbbL0D/z+TS7lPRirRPm02GUqmrij6
         DyjGdxgZXbSZfyw1zHazfeYtcmTyu31+7PRQeyCEYTEF2ek06b7k4pQ8z7mwLjVLHf
         2QudDRgm2JMMPcO2B1LwAAdvLpvC/+hVyBubxFsefAXwITVi8NzgV3ezB+qLOyDC3h
         xIwTaDJzVXzugwLOX92PAu+kNR8bo/2btfpAwF3OVuKeXaFJF5YjGhVA+jeE1ZDVKu
         xPBjaCC9l0a7rFNjWXSFQJ5274eLfBNcrSjOu7mhCgVh00ktOTpZUh4MHLfV+gAI0e
         wVMSpxTxOungA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/01/2020 13:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.16 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.16-rc1-g4acf9f18a8fe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
