Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C2C12A78
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 11:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfECJ2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 05:28:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3405 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfECJ2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 05:28:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ccc099c0001>; Fri, 03 May 2019 02:27:56 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 03 May 2019 02:28:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 03 May 2019 02:28:00 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 May
 2019 09:27:57 +0000
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190502143339.434882399@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7a4ddaf6-819f-b8f3-4104-f979b2c08655@nvidia.com>
Date:   Fri, 3 May 2019 10:27:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1556875676; bh=ZakalKCGUqgTa7eOrd6KjldSfkB7Pz1YEJDda4CByqo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=DDe9Vc72ckBstqd6sMV5GG9mahoeaKP2NLvsbAsgkwqxXoBhj8bzDXHrptyXqLcuZ
         IaRYlDT+nmtkCWGZgnoiD5fk8z+f+VWANFrfHRP+kkYOYwWXYHEoaugb7oUcpuXgw/
         utvHPJGPdVCLe7dxPpRTKKadplJZ8fncc1F1cl7ZYKT6cl34zNHuCBuoEUMNBGjdeI
         Y+5jXLBd42AIfoEr7TgqclffbqlZe2JGVKasVvkvNxRmqM7o6xXxMMxbqix6Wt4/Ta
         x87KTmYzDE9vNNNp2SIrsMHGrF/SZL4opuImLKr8bjX6NPwz5XMoHpRVmlM7BrQnZN
         0Nn9WPIQxXlSg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/05/2019 16:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.12 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.0:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.0.12-rc1-g17f9302
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana, tegra210,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
