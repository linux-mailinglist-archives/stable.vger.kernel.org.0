Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094E157E5E
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfF0Iik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 04:38:40 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:19650 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfF0Iik (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 04:38:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d14808e0000>; Thu, 27 Jun 2019 01:38:38 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 27 Jun 2019 01:38:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 27 Jun 2019 01:38:39 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 27 Jun
 2019 08:38:37 +0000
Subject: Re: [PATCH 4.14 0/1] 4.14.131-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190626083606.248422423@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7db66cbf-f67f-d790-3381-778768b3b8a3@nvidia.com>
Date:   Thu, 27 Jun 2019 09:38:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190626083606.248422423@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL103.nvidia.com (172.20.187.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561624718; bh=ZXJzc0xKjJrQxmlrwgA1gtKcOHIPzOcEpQG0laJPoWQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=TsmC9MnGr1ELkGtHay56ccwk28L6Y0BOB+zXKZSmXj06cPyY4aVCY3+yugC3B43vJ
         LJt3DsMYNWITbdzDSuu060amTOZd+8vU/duW8ySF46T+VeukC5xFkWHdjpGZt2SweM
         O5oqbBTwG4PHolO8ziEMoT3sA5j61gjtacAauVOUAiCOE8gdJ74cQdtxeUAHISVwsv
         6c322pAo/DKfkwQfZvVd3QtI7eyaWvOTNviGTh2o0RLupU8I1fgA8faCfMvCnqVtOv
         jK4CKkMsAwIfdcOX+E8ItImn5fP6i7KmIjG4gM/Q8CcRM3ReyRPxI+Q/z+xBVdFuCF
         OIfMQwZAUrUkg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/06/2019 09:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.131 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 28 Jun 2019 08:35:42 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.131-rc1-g2f84eb215456
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
