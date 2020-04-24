Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E2F1B6F25
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 09:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgDXHkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 03:40:31 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11324 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgDXHka (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 03:40:30 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea297e10001>; Fri, 24 Apr 2020 00:40:17 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 24 Apr 2020 00:40:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 24 Apr 2020 00:40:30 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 07:40:30 +0000
Received: from [10.26.73.231] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 24 Apr
 2020 07:40:27 +0000
Subject: Re: [PATCH 4.4 00/99] 4.4.220-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200423103313.886224224@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <225e448d-9f12-79a6-2ed2-a640b6d90b13@nvidia.com>
Date:   Fri, 24 Apr 2020 08:40:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200423103313.886224224@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587714017; bh=soYeYf1LknidSFFvoym3JGwbRK2lE8doSBhKvaadGII=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=K5Fbz4W1V/i9yee+PWWkDyEETHppiKbp5ixlESVuqAe0VYklzWOlhLbsRI2Hdz8cs
         jNW5f50Kqrbtf4GPNqFY5FWQOeETLF9RVlWy8l0Nz4ejVDKe2RBoQOk9B0+qoktxJ8
         dgkRFANqzgZPjQZKi6V4CHiEQbl+OmWTwNxam/+EitLH5v1dgBxhuNYf9sJ5DRXB8e
         G29XLZ5RuXbOc1wyGCZoRI9xvZPx5PVQ6R2aCaRtyrhZkjYGD1+IOVu+E/iJCXBqWN
         lFEv0GaXjWVUXq5JyqSymry5vnSR/pl+E6SUtcE2s5RtO2epM/p+QXPGWSM9XcLzQD
         Qu3yGLyOuhxHQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 23/04/2020 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.220 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Apr 2020 10:31:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.220-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.220-rc2-gb7353bd580c0
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
