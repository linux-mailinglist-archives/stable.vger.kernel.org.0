Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7462140A97
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 14:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAQNU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 08:20:58 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9197 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgAQNU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 08:20:58 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e21b4a40000>; Fri, 17 Jan 2020 05:20:36 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 17 Jan 2020 05:20:57 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 17 Jan 2020 05:20:57 -0800
Received: from [10.21.133.51] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 17 Jan
 2020 13:20:54 +0000
Subject: Re: [PATCH 4.19 00/84] 4.19.97-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200116231713.087649517@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f9b46181-9869-ee55-2542-467a5e1a5114@nvidia.com>
Date:   Fri, 17 Jan 2020 13:20:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579267236; bh=O0qsWukNRUtvrpUm6vx+wVXHV+t3STeCom3pNisn5y0=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=W9qIMR8nKc+154oLcwSN0GBq5KQL+ai1l+gRJWlz1fAvjPsla7C0ZxdwFqdBpSr2Z
         xgilfQz1Dqo9fFr/F0fzlepW3V0Tu6aMv7C+oYgAMKkdXalkf8Cxj2iBAbfCDh8GHz
         EeVv5Jy4yLWzfUNEDfSgtuGS6XMknuNSZ4xO2o75p89IBHR6aVe8dX/fM7qmFoU3gW
         2okldVUBQMMvZDxOUxKc+UGWRgMJ3PqyIHfuoARy0EDdIfYraetIgihqKfj9AqRfyM
         r9jme0RbJHWToCWUgXtegji/SxgWE8h4vcXCmnA+1Whq+rCd/tNkBSDgnXbCxmD2JK
         8+fl788CmgvQA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/01/2020 23:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.97 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jan 2020 23:16:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.97-rc1-ge301315724e2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
