Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FBD2FC2A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfE3NWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:22:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2184 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfE3NWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 09:22:00 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cefd8ed0001>; Thu, 30 May 2019 06:21:49 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 30 May 2019 06:21:59 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 30 May 2019 06:21:59 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 30 May
 2019 13:21:56 +0000
Subject: Re: [PATCH 4.14 000/193] 4.14.123-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190530030446.953835040@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <194fe277-0f9b-4328-6026-0197f198c59e@nvidia.com>
Date:   Thu, 30 May 2019 14:21:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559222509; bh=xfZf1L1ltepseyUqSj7Ivsx87atITCRjMZUx6r7nALY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=VR/dy9NVZYrwlUuJr/HWzR1cR2KPLzELs1OWXMDPJvd9uoY0s84kfUv6J7T/B59nd
         JUBm/ly6JoQn+LpT5+Qn443XgAY1c5/amx0YstoZbHH1hk4aQ6CB3RQnwRqs8m9rWz
         ywvQmQL8TzU6VtW8ihdGCkTz+20uKZcHPEMoHWaZTnCBs+T+sF+Hj7QxS9BPqBCsi3
         1LgZQST56bs+76PY6SMcACcBWCcaoUf7eQPiftfDIT2nAPjTjYy4OeZ1pcTfghUbVQ
         uzqQPfMW5u/095ieCvAVQwq+ef3+NQ9SG2JZoSJ/r/j1dWl/q2pU5B2vFD3Ofkwiha
         87NWaLp/URufw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/05/2019 04:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.123 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:04 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.123-rc1.gz
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

Linux version:	4.14.123-rc1-g0352fa2
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
