Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1A92D696F
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393979AbgLJVHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:07:41 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16935 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393912AbgLJVFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:05:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd28d730000>; Thu, 10 Dec 2020 13:04:51 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 10 Dec
 2020 21:04:51 +0000
Received: from jonathanh-vm-01.nvidia.com (172.20.13.39) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 10 Dec 2020 21:04:51 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <stable@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/54] 5.4.83-rc1 review
In-Reply-To: <20201210142602.037095225@linuxfoundation.org>
References: <20201210142602.037095225@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <a6ccffb1a9d2480d96e373a2f9113ef8@HQMAIL109.nvidia.com>
Date:   Thu, 10 Dec 2020 21:04:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607634291; bh=+VmEiO8YNUqN45s6zj3a6WfAhU6C6SMOljUjb9c8KOc=;
        h=From:To:CC:Subject:In-Reply-To:References:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:
         Date;
        b=jNakXxD8TVCYTxLp+HeCQpABmOeNxBsHYvZ8wjQxvdFZ2bxXHIXMnuK9q2IOq8Olg
         I5blm6AeH3eotoT6pIGVHWAtv8LAOMZ1e6xRsi6XYvlBbBcQ0RyBKVzEUoDcIAM82F
         j+oCro9ysc08okjm4XDxFVt9ZHeSb8+1AY/CpexwLHwk6T0EvLMZ7Avzw4UB5zTCNK
         h/H0VUucGuMkh6KZ+5ResjZrfNB3Men4JODZVME/3hHqc6982IYVVAGZHmHzviaFbS
         Zxrwre/k5F3m5zuj8dfvE693mqE9+7baToimi5sOjNn1wa5NXuskt03cmZzL+RFHU8
         VlgUsLLBk94rQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Dec 2020 15:26:37 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.83 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    15 builds:	15 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.4.83-rc1-gf71b3a7c3765
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
