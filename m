Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB8C1B5903
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 12:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDWKU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 06:20:58 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13741 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWKU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 06:20:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ea16bfb0000>; Thu, 23 Apr 2020 03:20:43 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 23 Apr 2020 03:20:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 23 Apr 2020 03:20:55 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Apr
 2020 10:20:55 +0000
Received: from [10.26.73.193] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 23 Apr
 2020 10:20:51 +0000
Subject: Re: [PATCH 4.14 000/199] 4.14.177-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200422095057.806111593@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b1ee9ab9-3076-72b7-7b4a-9a3350f3d4df@nvidia.com>
Date:   Thu, 23 Apr 2020 11:20:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1587637243; bh=5jtQRgHjW4ix3LA0PrET7Fc6VS2NrOvyeHoa+C5IipE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=QmHvBh+X/o7ABk1sSzk3oaZJuGQOTZZxYaZObe5/6ByL4dKj6IN1JYpSSsuuyBWQj
         5sMV30ZrYQBXct9qFJMupD8AJZ2uosWqQJVgbuU835o+9ndo6sUBMQjlDNQZVbnFeF
         2OkmevY2xTEttb6BQVVS75opV4LXAjxxQJyEtZZBU9ibArT/skX9821ca4Ql8gftZE
         8uTCdqvsE2mxhTByY/C0RhBR95Qd0XP/7ndxToN4THvaDHmq1/a5gu963n3qgOWdGT
         VmUAcPPSr0ZXsQeBU1a+gXMReztpXMY0iEu0twAoUSkvr26suHZOf2sOs2F4U3uA3+
         gmIrTX+uGlc+g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 22/04/2020 10:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.177 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Apr 2020 09:48:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.177-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.177-rc1-gcebd79de8787
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
