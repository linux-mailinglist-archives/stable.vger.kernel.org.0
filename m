Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22571203FB
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfEPLAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:00:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2713 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfEPLAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 07:00:12 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cdd42910001>; Thu, 16 May 2019 03:59:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 16 May 2019 04:00:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 16 May 2019 04:00:11 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 11:00:08 +0000
Subject: Re: [PATCH 4.9 00/51] 4.9.177-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190515090616.669619870@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <46643ed0-7870-bf1b-35b2-2cfbb40a4c76@nvidia.com>
Date:   Thu, 16 May 2019 12:00:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558004370; bh=kX9fmtEI0KdrFj4jwoxOkPZJbs762Bqxd2cP2gmbLhc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hqgtFsc7CExlwMTJPDriakUUaC/HDbH5GlFdzDMEvkgrlcMQrNdIhq75U1rS7Fui2
         OcwQRUNs5wHlBc8t5j4BrLmqpwhnVhcNMXmkbKwGMbVP1eKy+18IfTEfKyIcWXdjwG
         VGGR1US68bnniq+8R3KU4UyvghJBPKHJrXkfqYJ7bsVI+cVbELOKQ9bOqQ/9CVXZif
         k1cK2sH6Np6Oewd/TpCLIK5QEAttzpiEtMgf3JUIwIQDvMWvTM3ZSqMqtxzlIekZQv
         CtC/EWPvs5yYGzMF/Wygoa1VuTH3lsNoopJKT6ITal9f/7Jy4OGYJhtDIWsKAk8GvF
         kSkBHCNpWseIg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/05/2019 11:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.177 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:42 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.177-rc1.gz
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

Linux version:	4.9.177-rc1-g2647f24
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
