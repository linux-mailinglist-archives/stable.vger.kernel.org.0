Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984851D9270
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 10:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgESItf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 04:49:35 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18177 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgESIte (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 04:49:34 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec39d100000>; Tue, 19 May 2020 01:47:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 May 2020 01:49:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 May 2020 01:49:34 -0700
Received: from [10.26.74.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 May
 2020 08:49:31 +0000
Subject: Re: [PATCH 4.9 00/90] 4.9.224-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200518173450.930655662@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <16708a3e-fde0-a8f9-1efb-6f4ffc15770f@nvidia.com>
Date:   Tue, 19 May 2020 09:49:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589878032; bh=dH1j9EdPGoLoZbDGarvi8zRljCGtenjBFY9ILkxx6ZE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=PV4ENN/7Mn8dbG+W+qMQB4y4O1/37gDRSN2pL1xUZQCDm2mXWKcJ/4z6N7sdi/0ls
         Pzp7PdtdANTfdZ4HrZxmV26wKpOFnm8uGI0CDPhyKq6dfe6dC1zbanom+we1NI38R3
         1XebgNi1TjaJkd6gQHigUUpZNG/Q/455LS0lBFMyy80WU9ocVcTQM188lK4n3tf+qL
         dXLxGA1+sAhHa1jDzY4StkqbrHMNgT1XU5tL40lKbKfdgPsNvjmUlaui4jlLFgGl7h
         cX84+W14OyjOBSVZUk07rBFyOKLcoZ0hfAD9kLVmHzfZceUaGlAanTj9U5hEYyYBGo
         6wqtw0Mk9GoWA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/05/2020 18:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.224 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.224-rc1.gz
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

Linux version:	4.9.224-rc1-g6b0209f7a185
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
