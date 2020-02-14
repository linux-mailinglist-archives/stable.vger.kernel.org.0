Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A1615D585
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgBNK0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 05:26:21 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14244 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgBNK0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 05:26:21 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4675890000>; Fri, 14 Feb 2020 02:25:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 14 Feb 2020 02:26:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 14 Feb 2020 02:26:20 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 14 Feb
 2020 10:26:17 +0000
Subject: Re: [PATCH 4.9 000/116] 4.9.214-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200213151842.259660170@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7a618b52-a10e-573e-167a-e22d3d628598@nvidia.com>
Date:   Fri, 14 Feb 2020 10:26:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581675914; bh=+YusFuZDYD7xM/mSJKyzf2h9O9FnI3FZ6Pbr/4l4uuc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=LLqgUeYi/XlzLmCEyDMs9cUssrvWsZGHtTatNXAoWQJnRC3NwKsHAt6lWrCN6hL1n
         p++HsZywEdH3zTyU4oqyK5UjP00eXGLgJmn+lRSM1pk7K1puDv8siLDcpN3I6VsRoZ
         hnNmFMVCc2yg+FficJER47NOT5TWfWzYiIZgKoxW/AkxFY7hftgR6eL3vOdss1cJjL
         4tVdqmisn/FZm80mEDU5z7nnZ1IVoyHoxFItSRcHnFKQQGQNfCM0vr7VdZHei32B91
         y2HLMO+RdKWXCoW5btz18J6jx0t+T4AXUmMPFhvlBvnSs1CarhaW6FP60Y7EOZLjpn
         fKXELVVYpzzsA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/02/2020 15:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.214 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.214-rc1.gz
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

Linux version:	4.9.214-rc1-g41f2460abb3e
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
