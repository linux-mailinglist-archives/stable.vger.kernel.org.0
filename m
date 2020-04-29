Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877FF1BD951
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 12:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgD2KRI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 06:17:08 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15621 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbgD2KRI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 06:17:08 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea953e10000>; Wed, 29 Apr 2020 03:16:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 29 Apr 2020 03:17:08 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 29 Apr 2020 03:17:08 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 29 Apr
 2020 10:17:07 +0000
Received: from [10.26.73.139] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 29 Apr
 2020 10:17:04 +0000
Subject: Re: [PATCH 5.4 000/168] 5.4.36-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200428182231.704304409@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <186b8264-4eea-6fa3-0a85-cd508f39282b@nvidia.com>
Date:   Wed, 29 Apr 2020 11:17:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588155362; bh=xzQonT7HWILtwX+AI6rYMv8shoHIAwajJaeNXZiPJsM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=j4FAFsar5kkZJPtorjlaA459FKr34fSeoKDun1uGulgNJ0yshIslgGgxh4SUFxwQK
         cZR3iZT/E4w1SFTRa1IIDeGYfzRVyTt6TcCsW9mQ/9k90+DoKCDmt3yEVx27LKDAWT
         a7EyvxnaakwIk3fzEYwwj/UAUSjTEDh7WKPctpuFqgxXqND/ftd6l9GwoGDXgcD6qz
         j7qqZPxLD/qXNu7gE4esPZieezaAsJFEzw9mHBpFRtncRANMk/Xd86A9UMMQZbTPBa
         8wQFAuTly0Vr+XYs+iuOkFL3WQXaFPSmcmU1jg0oKnTkFIWeiVDEOJIZgOun+Fqwse
         BreHsHXGjFsig==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 28/04/2020 19:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.36 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Apr 2020 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    24 boots:	24 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.36-rc1-g388ff47a1fba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
