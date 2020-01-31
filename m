Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E8014EB64
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 12:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgAaLEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 06:04:16 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10508 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgAaLEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 06:04:15 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e3409a00000>; Fri, 31 Jan 2020 03:04:00 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 31 Jan 2020 03:04:15 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 31 Jan 2020 03:04:15 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 31 Jan
 2020 11:04:13 +0000
Subject: Re: [PATCH 5.5 00/56] 5.5.1-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200130183608.849023566@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <69db1365-4b9a-0e58-4998-c9275bbc8f83@nvidia.com>
Date:   Fri, 31 Jan 2020 11:04:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580468640; bh=p9U6PkjfJyXhKNLIsIerhOfyVD0U0oJFaAXuZKp3KC4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Lhd9BWFyKyMwZFzRox6Hw2Qs8UV/fl84CHZYVW4Dk49/Jj9+Ka/WeiTGiBf3bvO6c
         rDI29MtszGvXO5MKLBrkga2yFGckImrWw1pYrgGNCz9lnkausid0pnmrz9CNMYU79i
         Noy4eNRljNwRNIh6I5plyWqnIbQDvOaGOruf7AslsxMfoBjfiRSobFmSIr9iU4Z2Or
         Wc+tDrk/Dcv7BduPAYQ+oGu6BVYfeuj78J2PHnpgaXsofbLW3YCAwAmOn9YkVd+oPa
         mIjU5N5O1/6q8RbPAjnIdo5VuPfZ09v239k2gDCEbnCgtG2rGlyCS/h/TliD+wLjli
         mzl0ZgfO7uoqQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/01/2020 18:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.1 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.5:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.5.1-rc1-gad64b54689dd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
