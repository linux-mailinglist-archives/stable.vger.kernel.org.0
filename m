Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE5C1B6F31
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 09:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDXHmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 03:42:33 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11421 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgDXHmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 03:42:33 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea2985c0000>; Fri, 24 Apr 2020 00:42:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 00:42:33 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 24 Apr 2020 00:42:33 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 07:42:32 +0000
Received: from [10.26.73.231] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 07:42:30 +0000
Subject: Re: [PATCH 4.14 000/198] 4.14.177-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200423103335.768056640@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b3abc546-98a3-ef8d-57b5-d75491ca5a82@nvidia.com>
Date:   Fri, 24 Apr 2020 08:42:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423103335.768056640@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587714140; bh=3VcYSyENb3v5WQnqbdYshpays7hrJtoEp41UYWAGWU4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FnoLjfZMftne8+3WouqfTOcjG1j16x8r/naQjC+Aku28O+Wyyez0z2eT7drrezi29
         +BQQMUJveELIFWlIHK9jDNpU0O4PijqY/CayvknEPnKFA0Xh/5ax1PioFMkSPCuBVD
         zt0aFoUhD9rX+XV3KnQV0yryX++2D6oBP3SAgb0FQZb5TF6DWNh1eCVQZ0C/Ppc4xI
         LlvAc/GYvjL7f9QTwmICNj6R3tg3ZIaK0NUxcyhnc6zkoWqRBP0Vu46Yvt64VI/ioT
         ncnoPcqGkhf5MNu1nTfCJp8Fz7MtqcCNQds6+Myx1vJl66em/7tTXsAbfVTSIBn8Fe
         PnM1QnKWHHy6w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/04/2020 11:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.177 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.177-rc2.gz
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

Linux version:	4.14.177-rc2-ga7097ef0ff82
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
