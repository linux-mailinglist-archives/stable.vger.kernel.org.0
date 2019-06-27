Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2022357E52
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 10:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfF0IhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 04:37:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19530 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0IhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 04:37:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d14802b0000>; Thu, 27 Jun 2019 01:36:59 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Jun 2019 01:37:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Jun 2019 01:37:00 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Jun
 2019 08:36:57 +0000
Subject: Re: [PATCH 4.4 0/1] 4.4.184-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190626083604.894288021@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <217e73e4-7777-558c-186f-c94658447ae0@nvidia.com>
Date:   Thu, 27 Jun 2019 09:36:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190626083604.894288021@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561624619; bh=SbCX0SL6eqFrPHJ08VgcjdHO9dt/tQEV1PoVfugs1V0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ahjkHtizw91I334aow3iq0t4gpcZKBHQoNoV+qAfrmqMbkdf+S5AQb/mSaKymdySK
         jVotCBgx8Bb5GBoRgUC4NFknOswkrSnZ+/2QDv/gBakLoUu3f4g9pR9+nofnkhNpqu
         RYy6NdkxSw8it14V0QM1MvmjU9stEdXnzdUaEOaF7CbTkeI4LffSAmLu6M21FkwUgw
         uLZLIFoW73614d2jSBs+UYyHt8+mLXzInsf7cISLOOMUTrInzWgUr7ko/e3q4S+rp3
         tJvzM5azHJR8NdVC1onsYrZBQ+zK+qDU0zz/Lh0rxWBimHRq9WhrAa3qsXSB9R1LTC
         BoibfjP5azKfw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/06/2019 09:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.184 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.184-rc1-g5f1824292521
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
