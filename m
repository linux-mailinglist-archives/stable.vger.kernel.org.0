Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E472619B69
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 12:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfEJKRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 06:17:05 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4192 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbfEJKRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 06:17:05 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cd54f9c0001>; Fri, 10 May 2019 03:17:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 10 May 2019 03:17:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 10 May 2019 03:17:04 -0700
Received: from [10.26.11.182] (172.20.13.39) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 10 May
 2019 10:17:01 +0000
Subject: Re: [PATCH 4.19 00/66] 4.19.42-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190509181301.719249738@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5ef39e05-847c-59d4-c4d9-091623701733@nvidia.com>
Date:   Fri, 10 May 2019 11:16:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1557483420; bh=9KkD+pexN7v0m4NeK+RApLfh77PARewgPeFEj5YRQQA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qJgzEmtYpn8Zc115JOMCxsfqaD+typokIHTZIxWqwpQC/zM7g5NWWuXofo5NX0FUu
         C4zVAnHqFvODEySgeymV8I8iTaAw4Br/VMX05+km/PdB6mLzQf4nNMQunfHzIktybW
         fJyXdnJo//kVQJRHcX/UnXTHrW6Pm0nvg0E/xpz+i+ILVoLDgWRcoEvX5c61qjFgro
         9dqrOc1roVtrfcSYOF7YVq+L01pJpRBPWg2+aiKKf0mOvSBPexMirYsrL9qDHrfxwm
         lrYFyp8KrZGl1A4/2SPd0FZLc9l0V1Q63YlQWStwqI2bX8J5aOkNM79/DBm+gs/9qC
         xM8WzQWxF0nZg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/05/2019 19:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.42 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:18 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.42-rc1-g82fd2fd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana, tegra210,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
