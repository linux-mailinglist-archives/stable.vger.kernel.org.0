Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3852F1808C6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgCJUIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:08:45 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4978 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgCJUIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:08:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e67f3710001>; Tue, 10 Mar 2020 13:07:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Mar 2020 13:08:44 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Mar 2020 13:08:44 -0700
Received: from [10.26.11.187] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Mar
 2020 20:08:41 +0000
Subject: Re: [PATCH 5.4 000/167] 5.4.25-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200310144113.973994620@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9707ee43-0cd0-b364-f31a-12f77948535b@nvidia.com>
Date:   Tue, 10 Mar 2020 20:08:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310144113.973994620@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583870833; bh=fi6ATaIrWzMstx2EfF8vhZL8Jn+mL8DiXLLtWO/MuS0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=iuceP3FXiHLzaRXGCT/QD0yDWT1dLej9HgWXO8aI3J1Ike6QZk1lp5XR7B8tGBSwO
         TtR4q/mG/hlVMDmp975sgqZlKwoj8+t3LJUuDa+kNMuxK/KcxKLsEmw2yfTMmzz0Pz
         Ri85D4JzNUh78GpDT7TZo0iMTxMVAZEMHHUprpCMBcCKMQseAB1MypZpiNbrVod6gA
         rMKAs+p5eYFAPRoBqNHIT6c5HVm3bYPZEiX+84NYLz9t9/ONHzRRsOPSKM4NAMI3xB
         3Wje1tPYYSZj5B3ERrYO6YCDPS7uE0vPKs/jG2EeAPCg9AU13xyv185NFlhaDzSWVQ
         CtJ2pqTxyu9eA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/03/2020 14:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.25 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 14:40:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.25-rc2.gz
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

Linux version:	5.4.25-rc1-g01c3b21f542b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
