Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA41060C
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 10:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfEAIZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 04:25:12 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2187 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfEAIZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 04:25:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cc957e40000>; Wed, 01 May 2019 01:25:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 01 May 2019 01:25:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 01 May 2019 01:25:11 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 1 May
 2019 08:25:09 +0000
Subject: Re: [PATCH 4.14 00/53] 4.14.115-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190430113549.400132183@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fd6b7fd3-d758-cdbf-993d-d19c9cabb6a5@nvidia.com>
Date:   Wed, 1 May 2019 09:25:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1556699108; bh=XtsLxzbvhRWzpeV/8TI5/AYvol7Axbic7UMzxajHuBQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=nIn3Ar5jvJbd43aLB9FZDMRXGc3L49Yv4Qli6VZjGni3HfHmOrBtZyDHsBEzmLovL
         70+UURnYRsxfAqMQuAwiArxZyieDNIyEHn1kzax6EAuuo+y6oHzBmvkTK4cKR6t2ol
         w3c5xbMDS1SCZwkpFEKGQatLabZKzaqeHtQFLohAb1bmGuzhqKIP0nkVX2LPcHrQz1
         EqdnfRSEmmRNi92c3LKyxWaKJ3egX/tlfYzlDbOUO9r8aI/7vzq1oUWNVR7XG/Ws94
         MJFfzvTCMijJlEiX9ABOH/rum8yXI4PQxbUOxGCRIYKzQQuoD5OiJuYiDC/7Bsm2Ni
         yGWiWXviodKDQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/04/2019 12:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.115 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:34:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.115-rc1.gz
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

Linux version:	4.14.115-rc1-gdb44a15
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
