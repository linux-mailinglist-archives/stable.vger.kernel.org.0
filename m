Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD111C5072
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 10:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgEEIgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 04:36:39 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12333 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgEEIgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 04:36:38 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb125150000>; Tue, 05 May 2020 01:34:29 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 05 May 2020 01:36:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 05 May 2020 01:36:38 -0700
Received: from [10.26.73.45] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 May
 2020 08:36:35 +0000
Subject: Re: [PATCH 4.4 00/18] 4.4.222-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200504165441.533160703@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <779ededd-d368-95fd-bd26-70447775df77@nvidia.com>
Date:   Tue, 5 May 2020 09:36:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588667669; bh=EZjaSzY5oCOxjQFkKHW2nMdSLp44HFcax5hGCGwiKiQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=IrZIvOWkumZtcB6RDV9fvr2WMh600QCiRfiiQ02UB6F3T7/qPKSNP8ocMRiL+WXkI
         OuBlJWN9Z1AMMBhkReMDk9ITxaMb6pqSRcOdX5CO6IHWDcafCAcgZR7y6/doaZhxsQ
         su1S8NtMoI242kMvBV8SLo0vxcJIoDuofMmOekPKOZb1m/6i8At9s0Kr0EvZ4Vqcrv
         e7TerXCh+y2iuvGv6LdH8VBO1gYhnobgPWIP+qL/jTMHxZqQkUPGP154bdcwpKgL9t
         rFKlWor9k0TWZhl44t03mBdmHlhoORvp44YOwJ1ANxu1po3HdDZ1izQxt0F2WZX0+R
         BxdLEPhdu67fw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04/05/2020 18:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.222 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.222-rc1.gz
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

Linux version:	4.4.222-rc1-g2f5149253281
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
