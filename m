Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398D412FBCB
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 18:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgACRu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 12:50:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9059 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728141AbgACRu5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 12:50:57 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e0f7ef10000>; Fri, 03 Jan 2020 09:50:41 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 03 Jan 2020 09:50:56 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 03 Jan 2020 09:50:56 -0800
Received: from [10.26.11.112] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 Jan
 2020 17:50:54 +0000
Subject: Re: [PATCH 4.14 00/91] 4.14.162-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200102220356.856162165@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3e220aad-d368-dd2e-c950-209448d907a3@nvidia.com>
Date:   Fri, 3 Jan 2020 17:50:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578073841; bh=FBtkNaXNy6/kLaLDkQf+BoDjSe34zO5NEbSK/DDnkXY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YwqX5EyBxY7aAbB8afSfJF2RNuwq/iNcmiBll0qZE94AfVOqsIll3iNWvlbCEcX14
         xdMlCxzvUGKnTzEz9KoOVpAX+WEbLZ7nXu7etVGjt3UEbpGe6wD0Hmex5wb3tvR5Fd
         uIX3+a2BamvZYlyEhY48726YVOUsJyJf1yzTBTespH9Ut8t4mkG0LQOUUbo8kyldDT
         zbzbtk4lDiZC4ABzFHpFjFg7zh2zcWGR4b+Anb/4UNxAwmwT1GElepJBWkGVriwTph
         AHdLvzYQSGBoW8Qt+KUeVbue+9A8rXfiqJ6cCcEWc3FWv86+dZGLZSKMpBOQLHqKDu
         x9wb2ryX9VhnQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/01/2020 22:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.162 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 22:01:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.162-rc2-g0e6f77cf689c
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
