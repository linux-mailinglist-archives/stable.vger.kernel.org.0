Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB501642F4
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 12:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBSLGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 06:06:31 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19261 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgBSLGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 06:06:31 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4d16960000>; Wed, 19 Feb 2020 03:05:58 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 19 Feb 2020 03:06:30 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 19 Feb 2020 03:06:30 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 11:06:28 +0000
Subject: Re: [PATCH 5.5 00/80] 5.5.5-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200218190432.043414522@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <67cf2b44-666d-c573-0e99-8f433444f84f@nvidia.com>
Date:   Wed, 19 Feb 2020 11:06:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582110358; bh=xfC3i+m8dfK/zLtPwLz+39tlDVROf4cN95K9PQ4QhCg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=a6hwOTAiiM66jQWkeFyJ1mRV+G4HKlaJOR5cr5g5haRkh6VCbEwkPc5nXtqhb1Fwn
         zuCX4fn95ZIkO100NzMd2uICXuqNt7j5BFxf0Atj4fZz3cPfyxIEeHqa2edJ5SMwmx
         p28N4h4agdg7L6RITnVZ5FihMxplEEoWvQ/itphajRvkc2PnUdQcMbyD9Qh0LNZga2
         dkBtVHTZR8cmRZzDBjjbAAw/VcEeqaYOhe1SCTKz9YN9wP+82wgul+4iIXaQpP9d/n
         R/3sRnmZmj7fMTQZvh+S3GotvEOekyiS5FGFEz8eb56SwcGqvzoCmD7Dzl0ibfdo3s
         ujz3LCygYOSBg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/02/2020 19:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.5 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.5-rc1.gz
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

Linux version:	5.5.5-rc1-g8aa3a43b129c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
