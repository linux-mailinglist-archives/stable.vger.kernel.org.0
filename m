Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7F8167A37
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgBUKKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 05:10:11 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14297 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbgBUKKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 05:10:11 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4fac610001>; Fri, 21 Feb 2020 02:09:37 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 21 Feb 2020 02:10:11 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 21 Feb 2020 02:10:11 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Feb
 2020 10:10:08 +0000
Subject: Re: [PATCH 5.5 000/399] 5.5.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200221072402.315346745@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <dea062e3-48c7-f878-c733-addf39a9c4f3@nvidia.com>
Date:   Fri, 21 Feb 2020 10:10:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582279777; bh=+W8p+ZYg9vxNr3QG7jfIrRIVlosHQFFO0vdkqfyoFfY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=OOSnv5KO70aHCA8exUuM5wn7fI3/Oa8WJDgvvR89qSNuihLt/aSrqiYznkYrZ0UDy
         x4GlBGwLlvulf54Tnx/nmXkA0Ljdr2YkR5JzOkqm0MxBrLg8xLSn1Cu3Akya6jL3d4
         F/58RUdzXq3WvfKR2Q8MeGEBgrZO8hQOftM3EAJWAzWsFLu72NmfPYdxCJX3C3zTtQ
         b8xQEkEL3F5cEhpF15mAtoviPGyYHPcJ/rHiAL8Ew8Aa0OExgMe/iZd3n7kTZBw3KV
         uF+G0UvbetuHIO3/pkIcGV20419rQLDnZ/qfX45xBP+7ctSJauLqTx4JoncSFwWeb3
         UfhktOv6IxEmg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 21/02/2020 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.6 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Feb 2020 07:19:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.6-rc1.gz
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

Linux version:	5.5.6-rc1-g84fa24740caa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
