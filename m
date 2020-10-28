Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5B29D477
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgJ1VwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:52:18 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12040 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbgJ1VwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:52:17 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f99c68c0000>; Wed, 28 Oct 2020 12:29:16 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 28 Oct
 2020 19:29:36 +0000
Received: from jonathanh-vm-01.nvidia.com (10.124.1.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 28 Oct 2020 19:29:36 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.8 000/633] 5.8.17-rc1 review
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <e00b28b9c8234a59ba2438623bf584a1@HQMAIL101.nvidia.com>
Date:   Wed, 28 Oct 2020 19:29:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603913356; bh=YXnYEjqBzF30DO2cPMy0AWHbfyWZVC9hSB8+othk84Q=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=UcI/PfTEythu2/quJ6kvh6I06xqj8MEq//s6fy1HqImM3Dqt+AFsuLYNJE2kKmYtA
         jlGxDLUhe62JykQF7jzaYE6Z8plMzlLGjk5g8AgKVp6rs3EhCZvmbnniCdrhdnfg7n
         XhpH5mjirDMvtPgC1ve5HyETulRKZLBj1JBVA5EvKjXJd/MCMWSCLgItaER7Uu+lZe
         4iNSHX1hf/nUNK08BccMKjZEltUw1ugjo4KQJq3wFAQ9VyJj1G5yksLMlSs1YDBpE1
         Z7gJBkBknROWG+RkTEQSk6JFn+C6boV6FgNqh8inyFvZHNyQXPC/EL82AMWy8e4L5g
         Y/yBBR75VmlLQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Oct 2020 14:45:43 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.8.17 release.
> There are 633 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Oct 2020 13:53:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.8:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    60 tests:	60 pass, 0 fail

Linux version:	5.8.17-rc1-g5be39e9f29ce
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
