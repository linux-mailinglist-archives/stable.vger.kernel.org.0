Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B07DBF0A
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 09:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbfJRHzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 03:55:07 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11062 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfJRHzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 03:55:06 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5da96fde0000>; Fri, 18 Oct 2019 00:55:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 18 Oct 2019 00:55:06 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 18 Oct 2019 00:55:06 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Oct
 2019 07:55:06 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Oct
 2019 07:55:03 +0000
Subject: Re: [PATCH 4.4 00/79] 4.4.197-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191016214729.758892904@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <11fd4e3d-7487-b7a2-9f23-2f536f1459f7@nvidia.com>
Date:   Fri, 18 Oct 2019 08:55:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1571385311; bh=XBd7l6J4ICA6DeU5pmurU+x1NeQvbgPFG6ah7rWtzQc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=M++K6rEj0tWrnrHkcP0GtXNEgAfWfcPu7WEg0FvsPq16D0fRtfpnY2L1w/UMRYXsR
         lP4ztKnMuLfCE+Lq47cnNneu+vgKwhp7/aQxtJsSoiCNVe4jzErfWNXFivwVveQ1xj
         uETqkPRTcFkBNY04ZwCfiDdUhTAIqMYXuuuu9DEAkRpLunH2NUVDwXeUDreL2TVlio
         XjCYv7efXW0424JBeMBjyz5BW7yVm8bFmdhfMhyMDb2p8JQzi5MK6sciJAElcIkfL9
         n1mmx0kH7sjuX2vVlRcm7mRLNPtxRAMx+7Q1Zyt/9nhO8Nc1S/ESkTockDpxTNngjD
         aAJ9k3whUkzQA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/10/2019 22:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.197 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.197-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.197-rc1-gcb63cd392f38
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
