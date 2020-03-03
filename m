Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 243D1178544
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 23:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgCCWLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 17:11:25 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2008 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCCWLZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 17:11:25 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e5ed5b80000>; Tue, 03 Mar 2020 14:10:01 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 03 Mar 2020 14:11:24 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 03 Mar 2020 14:11:24 -0800
Received: from [10.26.11.142] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Mar
 2020 22:11:21 +0000
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200303174304.593872177@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f109bb1e-1520-893b-ae48-70a80fc3f29b@nvidia.com>
Date:   Tue, 3 Mar 2020 22:11:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1583273401; bh=urPkfjnlN9JykNtKvapn5x7KVuAEh5vM83mwv5Guhl8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=MpQ5o3KcAMESBSBMdxRENifD39PsIhGCYZo+rNBI5uHyozFqdOTn5JwOVdIexZrTg
         VcN0NEhkAbFhgUYn23sRg8wTdL4xM/4hC+qFsQ768oaLCBWz7NAINXMGiRasCyNWRZ
         wRQwv73sAwnMkxZYQ+rIi+/w+QopBb9EMdiDjmfWxiuAsy1m9gRUToVgUlYrtPpPD5
         5ouN2p7y3J1B3RreMBCkLUD3Sb+IUjwLRLUbt9qDuBUGzeFxvKUQfYcG4cENVEW6YT
         hDED0FiNeGbMz5RRE0IMvoxcMTwLU7w1/NKUsjEKyxcYg6FmbTDN8wlyOzeXSaszeJ
         48sEq3D9hsVPA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/03/2020 17:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.8 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.5:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.5.8-rc1-g3517b32c0774
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
