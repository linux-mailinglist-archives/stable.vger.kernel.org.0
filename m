Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B792640F3
	for <lists+stable@lfdr.de>; Wed, 10 Jul 2019 08:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbfGJGMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 02:12:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9366 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfGJGMD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 02:12:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d2581ad0000>; Tue, 09 Jul 2019 23:11:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 09 Jul 2019 23:12:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 09 Jul 2019 23:12:02 -0700
Received: from [10.26.11.158] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jul
 2019 06:11:58 +0000
Subject: Re: [PATCH 4.9 000/102] 4.9.185-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190708150525.973820964@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <108d73e7-572c-be95-ac49-a22922472e6b@nvidia.com>
Date:   Wed, 10 Jul 2019 07:11:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562739117; bh=K5IZjVmSe5BkUEqvzpkgCD4KV6AyCgBqjGSQJC4lzl8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=adWsPk/+9nHzfA9oXiLbGkbq6DwLsABcz6MKtoXTgmunrhYBfHvK32VVavbt8YBrv
         YvdgpfUAXWxfuWkmjnbmUYzaEbOx1A3RYYbNaRyvXEWDy3CJOkAeCdpolStNZQzNVn
         ulurqLrglFtx8eLBEdDQEcki2gPf96Tvsh5FWxcXrGpRtK8NHVKBKzFVnyeExz3Iby
         MtMm5e90+7ZNglOUEPQmndZtnMqHo8Dej0yH2bN4az6eOQWJWl+7dpVFHEgKCUKGKR
         qQT5Bq7MK4LpTj3Z0SGu4V1C/KRgNkrisZ9YP1fbzCyEPyrDGmkLtvdI53gIenMggl
         RaVWy3KysJmwQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 08/07/2019 16:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.185 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.185-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.185-rc1-gbb7044a09b6b
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
