Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99E0919BC45
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 09:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgDBHK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 03:10:59 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8350 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbgDBHK7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 03:10:59 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e858fd10000>; Thu, 02 Apr 2020 00:10:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 02 Apr 2020 00:10:58 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 02 Apr 2020 00:10:58 -0700
Received: from [10.26.72.253] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 2 Apr
 2020 07:10:56 +0000
Subject: Re: [PATCH 5.5 00/30] 5.5.15-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200401161414.345528747@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8f6aa8e7-a388-a778-3f35-94735d14bb56@nvidia.com>
Date:   Thu, 2 Apr 2020 08:10:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585811409; bh=m2a4XvGtfUmRyvWxcZDz1SYBZP1Yh3EqWCNnor68rCw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YLvB+LEaT3xYpdbz9wnyNdIji2+3E9yunBb+ssW+iIb9MsDfyeLvvtZdOvAzIoOM2
         uXImZsYNGMQ3TRJZ+p66V1QCDWd+3VvHhlBwHYzR5f72FyByeqLVcliNmcH56GzATQ
         7plT8xX4ZyNlxoHPUzA8J+6aA6qx+0SEQxxndJMP7+/fkQwbvO5D3mR+FMQNr8meNa
         xubj/ABTg9hpPSpDvEoCfLdMfp0G/tfXv+SIKiXUQHW6Yg4k6/gNCJNO0REFTqimtY
         /06MAptn9wsaPtAVwvAAc2AUBujLaksJGdKadJOSRqE5G5TkhdpXzf7BlQBJJBpOnC
         HU6jDr9GAKDnw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 01/04/2020 17:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.15 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Apr 2020 16:09:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.5:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.5.15-rc1-gcd17199418ca
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
