Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656DC1808BE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgCJUIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:08:02 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4909 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgCJUIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 16:08:02 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e67f3470000>; Tue, 10 Mar 2020 13:06:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 10 Mar 2020 13:08:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 10 Mar 2020 13:08:01 -0700
Received: from [10.26.11.187] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Mar
 2020 20:07:58 +0000
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200310124203.704193207@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <042ae314-af0d-9da5-04a8-e1198fe36de1@nvidia.com>
Date:   Tue, 10 Mar 2020 20:07:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583870791; bh=PNmrbRKDA9kjnHKv42eOvKxcW/4DLS1M/Wye0qqKh2k=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=pwYFQjGCweFcUpaq+ZvSLo8qX8KjLcz+N0GSzZnqVEmlkJkSuvxrA+4wInjIR5COG
         TVLsFMXzAJZjKvAlq2XLUu7U5/pYD+rtCGyvlDKgpx9LITQvz3J+uGM1OeAcqpmEjC
         B9wJ0fjvS6n4/UpBYtIObnMrmN98CoKJU6fKgKw2izyC1rqPoQFHFxj8FU6Kw3VobU
         W52rRx8phsH548b8qpzj5i0KXgYrX/o9X5bzVMDVpy/Vyh6DSYqei3SzuJ/x5987PC
         40YL4sf8ejRB/5WCvJt7I2TxZNgXL212MfqN8l9YOQ3814ZPVRjOL9lxunXUhJmIIO
         yz/7PrQa6ObMg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/03/2020 12:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.173 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Mar 2020 12:41:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.173-rc1-gd5b7f770c4ed
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
