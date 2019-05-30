Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98FB2FC33
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE3NXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 09:23:16 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1517 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfE3NXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 09:23:16 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cefd9430001>; Thu, 30 May 2019 06:23:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 30 May 2019 06:23:15 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 30 May 2019 06:23:15 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 30 May
 2019 13:23:13 +0000
Subject: Re: [PATCH 5.1 000/405] 5.1.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190530030540.291644921@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0f0f1d03-64c9-7197-c82d-1ca27142be00@nvidia.com>
Date:   Thu, 30 May 2019 14:23:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559222595; bh=/Da/X44gnw0lY7xc5tOfi3i+ExmIyaDVrEeh59+11GY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=TBBeGSjVIwzUAv4D8lvaWoBXAkDHYgAOhOCKWsJrCZCzfatTIL6+0EpzEfAcgckZ2
         XQpbXHWgcIaOXynGwaGwNFJaSqrjNGWTGWuD7SuROgAwoiTVEGEwfdDnKiXcEcBSeT
         4FnxzfMNVEzxJl8EkJ2uxdKuhsJyxLN1CiYthPEiBlTmVLfP6CARQnSh7xp/MhpA+U
         n6QGsTGFmtiklkXmQeV/LaQXL3zW8V6qtbFLqsOiUoBgl0S7Qr030JO3wGDhBK0uvC
         ipGoGcK/l/vPG2P4vk+xk0n4YDvuFq9eqPo+yf2aS0P75bgIf6ysJqD9eD14Zrqj9M
         bEnfHFP8QelOw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/05/2019 03:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.6 release.
> There are 405 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:01:59 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.1:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.1.6-rc1-g6df8e06
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
