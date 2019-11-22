Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8E4107360
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 14:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfKVNiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 08:38:10 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7220 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfKVNiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 08:38:10 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd7e4c50000>; Fri, 22 Nov 2019 05:38:13 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 22 Nov 2019 05:38:10 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 22 Nov 2019 05:38:10 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 22 Nov
 2019 13:38:07 +0000
Subject: Re: [PATCH 4.9 000/222] 4.9.203-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100830.874290814@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4e76f771-28b5-ebde-d86d-d2735eccf2a0@nvidia.com>
Date:   Fri, 22 Nov 2019 13:38:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574429893; bh=UgwXCDkc6O3lLvRRqn4YZuVFeFbLEIrDBst2z1R5QN8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YtKUtGok/KQTkkrjE97/n1kB1EAlgK0v5UigS2Ab547P3R33WTEzG+RMJlZ321EQc
         6wMGQXSKF6HGpZM2V3KiGHmfqwHwPQGy9kL8nN/jlUWLA5cVREymgfCclbQZjiWL84
         TizwMUejOqdMa/26k7pR/1FWqidi1U/1RzMnHsvDGJTIm7pvJZ06dXGkDmlPtOr/6J
         QaWuOoV0bYU4qjbkaXyIKiRfaATZtkE40WrmzNPQbRiEa0sFiBdlF6/uMCIKYokAwg
         RuCNP5Ilcixl29uCl4eLmKT15CEs9LN8l3Gjv15GJTRLBI2Egtj7HExISgyg5/DP7d
         m2Fv3XCKA/LIA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/11/2019 10:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.203 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.203-rc1.gz
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

Linux version:	4.9.203-rc1-gc2ff777d9ae8
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
