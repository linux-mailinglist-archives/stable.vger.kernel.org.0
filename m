Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAE42FC30
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfE3NWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:22:42 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2226 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfE3NWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 09:22:41 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cefd9170000>; Thu, 30 May 2019 06:22:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 30 May 2019 06:22:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 30 May 2019 06:22:40 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 30 May
 2019 13:22:38 +0000
Subject: Re: [PATCH 5.0 000/346] 5.0.20-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190530030540.363386121@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <605acd4d-64d5-3f97-8f10-d8f1587e750f@nvidia.com>
Date:   Thu, 30 May 2019 14:22:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559222551; bh=7g4d8Qi0+mKUmgCD/znecETcrBjZfwjiCWTRlTd+bFM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=SwjGYG7ZYJfUTq5qEkADlkY4F1oPXZsPaHfHixsfd/EVs6VrzhytZ/p0Fxl+mKy67
         v4lLaoJQzhBMaupEtzBIP8VF6+8Df7pFspgI7h4EX2JdvT1RchjOEhbWuBjT+up7B2
         6w+DR5BXu8H+mvJnKtA1FdTBjw8eiZqjY5FQZSGkwsqvM1+u+wZSocNxOc+WdQVDD4
         2Kfu1kmSH6Y4wkO5wNzw1aZmYGbuM6ZixugLqRw0jrT5QLp2i5gy+NQ+D37Az/vq6U
         9cNjVbVqmr7xHJxxSQfOOIgqrg2kAkd5uLdab/xJI26c/YUed05j2bxETjV9eRJiBh
         C+UJpNzqQs0Vg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/05/2019 04:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.20 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:10 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.20-rc1.gz
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

Linux version:	5.0.20-rc1-g79c6130
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
