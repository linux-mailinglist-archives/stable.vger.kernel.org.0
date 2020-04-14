Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E301A78AD
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 12:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438566AbgDNKoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 06:44:17 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7478 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438551AbgDNKoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 06:44:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e9591a70000>; Tue, 14 Apr 2020 03:34:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 14 Apr 2020 03:36:04 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 14 Apr 2020 03:36:04 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:03 +0000
Received: from [10.26.73.15] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 14 Apr
 2020 10:36:00 +0000
Subject: Re: [PATCH 4.9 00/32] 4.9.219-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200411115418.455500023@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b82b85d6-a396-70be-55e1-3a55e847ff24@nvidia.com>
Date:   Tue, 14 Apr 2020 11:35:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200411115418.455500023@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1586860455; bh=yms/0YNK13lCL5HvO13G6Pk+4BzPYbWaAcuKYlJ/rZo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hCnhufRlu3rgWgS3+VX/8obXUeYUw380fGuzY0Lfgo0zJ0ajQnyQy9+fx2u59mnxa
         diSwCbI3uUNkUGZKUI7UfG6JgkVoA6O25aRoSyxCFiwmTL80xnpwf9xN2ewSm1sBi+
         LDbol9bsRJsH255uMb2seN8I/inSsPnHLyE0rTFPh2hsAmFFbA7dgt0VFbsU4XMoo2
         rp03+S4Ew06YO4UKHwWXG74MKEcHhK5kj3RyOG1BaUgIzle18nvbCrstoaAWcG3SyB
         kbglsbGnt74/vjzMtxS02oDD5A0iN9gH+EaFdlfO3H89EUtumDWxBGSytIjdKGHpbB
         LTFZYbXz1ozTQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/04/2020 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.219 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 13 Apr 2020 11:51:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.219-rc1.gz
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

Linux version:	4.9.219-rc1-ged218652c6a6
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
