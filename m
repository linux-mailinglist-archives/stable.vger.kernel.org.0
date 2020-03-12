Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50506182C2D
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 10:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgCLJRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 05:17:08 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19183 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgCLJRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 05:17:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e69fdb70000>; Thu, 12 Mar 2020 02:15:35 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 12 Mar 2020 02:17:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 12 Mar 2020 02:17:07 -0700
Received: from [10.26.11.156] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Mar
 2020 09:17:05 +0000
Subject: Re: [PATCH 4.14 000/126] 4.14.173-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200311130904.819648693@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <bf159c38-fc24-39d7-00a4-e85aa4f3e040@nvidia.com>
Date:   Thu, 12 Mar 2020 09:17:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200311130904.819648693@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584004536; bh=zB1WxBYgCEvZgU4P+Qhh8M9dCmHsE0BOzp7hDM1iSXc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BYr1Bp9Ch7t938AkpmGlavrPF3DHB+MrNwxniFP3vWeF6BZJ1C+xc1hNl1U6icTM6
         7psPruaPWXQdQjduzH65YsKed/2XjTCZU6vBPRUVCK7g+sEqKtDaIVppqwlIpljet+
         pJ3OQj4vONAjEpaqrt4C7QoPcnt92NcAKlpeK5S/rCqgAdpYU7VMS5qKB0uIot9riX
         LEFeu/hlkMpNOlF7khdW9o9uV0UlvDq7DZo05Tf4GeGpyLcqnhEuZRQPPGwFYyXVaP
         GSR7Z9DCDSgq8eLFL2+A/iKUhXQEOerWXhOKMLhy1/B4SdB6JNBcxn917bd9awEwXf
         QzIPPKpf1KWIQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/03/2020 13:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.173 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2020 13:08:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.173-rc2.gz
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

Linux version:	4.14.173-rc2-gc23e0b0dc693
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
