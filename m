Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340D9D3B38
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 10:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfJKIdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 04:33:37 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4259 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfJKIdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 04:33:35 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5da03e620000>; Fri, 11 Oct 2019 01:33:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 11 Oct 2019 01:33:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 11 Oct 2019 01:33:34 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Oct
 2019 08:33:34 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Oct
 2019 08:33:32 +0000
Subject: Re: [PATCH 4.19 000/114] 4.19.79-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191010083544.711104709@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <126aef3d-e4a7-cd4f-b4fe-f124f38e1be6@nvidia.com>
Date:   Fri, 11 Oct 2019 09:33:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570782818; bh=ajytr2BTyG6jUUktSEMKTxC3em83iWXhj8qC0o703Ho=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aHVXQaRNoDYMfKwIbr5LxmXyblSehjzzXCzHjb6OsFwb0UwAcqfpwnyNwE0u56w+l
         uPooIcTmZuaTizzzkNCx/izwcZFwTqCKWVdxbj7/xOhFtZjbLd/L2fbTe4ymuufCmf
         hbgOPl9iqyf2CQFA3dBjDyyIfJXdf85TmtwNnIkZm2NPM8KgddW3LwKZHsiCYvhwbM
         gG9HwQ3FrjzeZO1KwLA+TX3x6lyG2H+8VfV23za+H3GY4kxPyi0EFqSkVKDTt9RDgh
         rXddPrf9JGmxoCjp6plhL81CnwLPWDBF3iUX/qbAGG+9Z67Mxq6CDdhiPcvsz/aYpu
         u1A+vjgnMVNhA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10/10/2019 09:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.79 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.79-rc1-g4d84b0bb68d4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
