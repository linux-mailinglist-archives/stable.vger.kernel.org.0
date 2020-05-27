Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D981C1E3C0C
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 10:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387910AbgE0IeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 04:34:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18570 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387397AbgE0IeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 04:34:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ece25ac0000>; Wed, 27 May 2020 01:32:44 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 27 May 2020 01:34:13 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 27 May 2020 01:34:13 -0700
Received: from [10.26.74.131] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 May
 2020 08:34:10 +0000
Subject: Re: [PATCH 5.4 000/111] 5.4.43-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200526183932.245016380@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b321e1d7-6dc6-6579-f3c4-69309d403475@nvidia.com>
Date:   Wed, 27 May 2020 09:34:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590568364; bh=/mgSlauif2jGF353o8wocJhAod7fbRspdgHnUs7AfME=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ARvKtPm6Q7kOnfK+A6Xe8XPWx8qUfj6uxXFnIJZf/9nD944UUsLUsFUmlaUQmjfRR
         XDwfKDaaaZcxwVYVNbgZSX6qWbdSbaI++eg0P577kxv9yXgp7oxSqT4qNgeis1FAHj
         Fm1nNIS0pMzU3GiMeAFAiTE9bM5nrSJ9mXnc4qJb7nIvGmhqweRApiS0BwvITSVkNR
         zYcGZP08s2+cSmA2Kp9k/o/suYZl972pA3Up11AJrroU+twsplWUfuSyNwpJeVRqmL
         Kpl8UqQbjawsGCOtXc2Mbhq5U2REqLnvNS94lrHQPvwUeqph9J6yGS5DNAUB/bJ2R0
         QBHu6wg8cqyjQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/05/2020 19:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.43 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 May 2020 18:36:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    42 tests:	42 pass, 0 fail

Linux version:	5.4.43-rc1-g3cb79944b65a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
