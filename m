Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4BBCDEC4
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 12:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfJGKId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 06:08:33 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18148 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJGKId (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 06:08:33 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d9b0ea90000>; Mon, 07 Oct 2019 03:08:41 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 07 Oct 2019 03:08:32 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 07 Oct 2019 03:08:32 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct
 2019 10:08:31 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct 2019
 10:08:28 +0000
Subject: Re: [PATCH 4.19 000/106] 4.19.78-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191006171124.641144086@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <dce71cbd-3e2d-8684-3724-c79ff5815dae@nvidia.com>
Date:   Mon, 7 Oct 2019 11:08:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570442921; bh=CtuK/0X1ruOnhnMgftxCe+omXz82+fCSIDeXrVZEiog=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=HXsMsAXYn4EE8tD+QUETA81DN0Y6q+uQ4S/bhAZMt8pLa0kaUaJh+R4BUDD9mJ/eR
         /3RKbtEWjD3TJjODLUIEu+vHI8uf8abLBjspTi3qwDK9897Xay+P0ExTvKvGPnpgbv
         J9GTdceTv17IJ+3+COeGW4C2P7Oxy75HkTQ2zNLLgdYd/rMg2HGptMgIjhts+0xD3Z
         tWnUwJR4d83iB5q5LgaxpYE0Eb1qwPQGFpsLoX0tgiYeBAGuN8QkJ9geW/dkuUi6JA
         Huy/LLIkH6x+6rssVJLK4W88UAp9SE8yLIO5K/F1gXrkbd1JzvjYqQEc/a+WE7vZPS
         bgF+74zhA3KcQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/10/2019 18:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.78 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.78-rc1-g61e72e79b84d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
