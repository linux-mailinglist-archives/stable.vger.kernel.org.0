Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BC3CDEB6
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 12:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfJGKHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 06:07:39 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18109 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfJGKHj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 06:07:39 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d9b0e730000>; Mon, 07 Oct 2019 03:07:47 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 07 Oct 2019 03:07:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 07 Oct 2019 03:07:38 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct
 2019 10:07:37 +0000
Received: from [10.21.133.51] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct 2019
 10:07:34 +0000
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191006171038.266461022@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <89329840-8544-1d75-eb4e-fa2d1099ce9b@nvidia.com>
Date:   Mon, 7 Oct 2019 11:07:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191006171038.266461022@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1570442867; bh=mjfY1cnI00RZpqM/gScLlfdGNqe//fkcYTRSNXlWNBA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=rS897L+S3LKMekfX8Ocns6ryyjODQovyphlz1RHG0EUzV/h2jc4XtWX6dFKPQCgaL
         7qo3/j68r5EKsmRBJt2vvCSZKMzgqQ5bc8BBa6mPz13PPJSUVnc1BuSt3eCq0p6WYs
         5ZbznTvholquOBij2Txecz+RElWa6Uu0OC8u+0w6ocnkbbmslMGIuV0c1hBa9U/52I
         3um55p1kI4kLtJmrfukxtsAMWguJuCpS18pystRT6whFjH5l/NvaahoO7WjWfSAimb
         j0FGfPFPa4wmaqeUKTe6mfuqWUFJT1qY3TGLRZ98vT3KtxlWCxl/xkbjPf/ZE2Lf2N
         E8Xk1eDZu4d5w==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/10/2019 18:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.196 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.196-rc1.gz
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

Linux version:	4.4.196-rc1-g2082eedffaaa
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
