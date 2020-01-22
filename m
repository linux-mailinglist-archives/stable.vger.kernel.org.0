Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586A614584D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgAVO6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:58:13 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10921 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgAVO6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:58:13 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2862f60000>; Wed, 22 Jan 2020 06:57:58 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 22 Jan 2020 06:58:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 22 Jan 2020 06:58:12 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 22 Jan
 2020 14:58:10 +0000
Subject: Re: [PATCH 4.14 00/65] 4.14.167-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200122092750.976732974@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9e9e9c4c-8d2f-18de-cb8a-7e950a10e2b7@nvidia.com>
Date:   Wed, 22 Jan 2020 14:58:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579705078; bh=1qAFsOzIltHf1rnbVQ7skx+2MsN4rBHABlSu8W4Q8qk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lYIw1bBxc40nUKAe1sTmozHueoXnb1hVqsHs4KboEGWtJgJYmE9+F/qO8HxroeScS
         I8YP2vNIdIdS0MiCiYzQmdIGNAY2rx/Z9+/RwFYjzs78ImMY0R38sJ121nj/6XubEw
         wxjMqpsyEiS6KmWU9OrK7EC4gKmZBnz0vnVB7tjYX24752Q44A1RPWtJ9FqRDU1953
         84y4GZ136T1SNby8PUpwEg5Yuolcus8qfxZeVAj6QX8kSbvR6wCtidcUf2qLCsZvA5
         v5MnqPjbJsB6rHJ9ZTmW+zv0NvzDBJ4q95Fk1V1zQ4g9uPhl+1vHTTB+bWtfnsO3yw
         EzFk0/ptdpJCA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/01/2020 09:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.167 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.167-rc1.gz
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

Linux version:	4.14.167-rc1-gbb5af942ee10
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
