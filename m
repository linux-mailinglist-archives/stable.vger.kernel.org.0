Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A69817853E
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 23:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgCCWKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 17:10:31 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:1946 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCCWKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 17:10:31 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e5ed5820002>; Tue, 03 Mar 2020 14:09:06 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 03 Mar 2020 14:10:30 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 03 Mar 2020 14:10:30 -0800
Received: from [10.26.11.142] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Mar
 2020 22:10:27 +0000
Subject: Re: [PATCH 4.19 00/87] 4.19.108-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200303174349.075101355@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <89b83a6d-83e1-f022-7e3a-899cc3eb44b8@nvidia.com>
Date:   Tue, 3 Mar 2020 22:10:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583273346; bh=k8kfYBKjflXak5hVHGLW4Lo/HMol0YZZLdnsQW/LMmw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ePznjHviJOrM7whqTeUber7Rqa5FFcfzWX58zPzezcx7SsK4QeAwFklSqvXMkbD8b
         ESK6DZrq1jMwX1U6GwVNV7X8UZZaBsRvjR2ppIpgiEWBYPsidQhGjAAe9jVEGzWQWQ
         QJO3tgTlaNPRZPNxen+S9RBhrYIS3KUTTTyyYy4+tf2iJRgZy1wf2i8XBgBSLkALCv
         PvnEggF5/o85rCtOwz81Xza9nr1ECzI/uDR5TWE3HL9JBj+YzbYEpJ8J6Z5a48ltJR
         AmPhgtTwvcRwPmMCICxaOeqlpNvuO5ifASU7B66Pl0cdfmNmr+3zDCuklg8t+8GGMd
         ya84zZIlkmO8g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/03/2020 17:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.108 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Mar 2020 17:43:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.108-rc1-g619f84afab6a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
