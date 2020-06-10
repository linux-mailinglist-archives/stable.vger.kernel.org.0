Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F19A1F5327
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 13:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgFJL2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 07:28:35 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13959 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgFJL2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 07:28:35 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ee0c3d50000>; Wed, 10 Jun 2020 04:28:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 10 Jun 2020 04:28:34 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 10 Jun 2020 04:28:34 -0700
Received: from [10.26.72.59] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Jun
 2020 11:28:31 +0000
Subject: Re: [PATCH 4.9 00/42] 4.9.227-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200609190124.109610974@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <8e0c8045-0d8f-80b9-ec6f-1e210f33991e@nvidia.com>
Date:   Wed, 10 Jun 2020 12:28:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609190124.109610974@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591788501; bh=4JMHrH1gtebT0j3xqiNwLMkhzFYNYaZU6Z3Ewvu1WUQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OOoMoCI0XY7hZANFPH1Qe0oZq3h/ZrobxW1PpFg0TugmWD3dbqkgry4i+jpbCTNnR
         72g5t3DPCKgvyuY/NHvkR8tnwPg/cp3fd66RUy73FyPuzl7geRkevF/Cd90mJYKgqd
         QbV0folefzFMKAEsGKraAtIlVN8C5WzWG1UCg0u5DknXgHyZOPNuTYMlZ3uC9VRWr9
         SqzmpHMQP8RuCQwWez++/v6oEeCAA94HTXPMRAV91wpJzssulLBdb/igefbM/BN77L
         v+ZZWnXhNWLj1Qv4VTJk/7Nsvav860GbE3kQ4KUJPugL/FrK1qDuEobjz2lX54v25k
         17IBeJvzqDgJg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2020 20:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.227 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:01:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.227-rc2.gz
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
    28 tests:	28 pass, 0 fail

Linux version:	4.9.227-rc2-g2d9a8182e06a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
