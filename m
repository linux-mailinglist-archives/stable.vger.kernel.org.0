Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E79145848
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 15:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAVO6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 09:58:02 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17843 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVO6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 09:58:02 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e2862ea0000>; Wed, 22 Jan 2020 06:57:46 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 22 Jan 2020 06:58:01 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 22 Jan 2020 06:58:01 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 22 Jan
 2020 14:57:59 +0000
Subject: Re: [PATCH 4.9 00/97] 4.9.211-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200122092755.678349497@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <35050bf6-7604-2b92-b240-bf0310010825@nvidia.com>
Date:   Wed, 22 Jan 2020 14:57:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579705066; bh=ORJfFIAyrWS7+mpIzNpzgkHi42kx949/6h4fATd0xLg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=eE8io82PKvZWU5Vms6WWdqQKvCE2dw7+K+xXRNjun9A+e80bJSlRq9k6zTCx+ZyHM
         0Ni6Qi4/3PTUBN+CFhsTYJqqP6AaG+wk6atfI1oPxMPsncu+ROYQsAIUbhRl5u+D7b
         PeTb6yfu5fnM4cL6sfjF8yMZJdUGC/rfmirqG9VOyMs0C3Mn8MGBNE0RsRWgGauDTe
         lVNZ/4LH7bguOIzHaVVhlMbCkshDUrajqlBJl/triLAfVAMKX/kj8RJyZwcYo2qaHN
         SJ1dqcRHcODtEUjTY3aNYTqf5xxCNCOP8Mjy3Pww6+sXS7VHaOXjYxTQwmuwsWp9XQ
         7riHzmbAU6DIw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/01/2020 09:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.211 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.211-rc1.gz
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

Linux version:	4.9.211-rc1-gc10529b210d1
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
