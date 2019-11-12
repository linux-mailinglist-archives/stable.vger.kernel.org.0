Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E64F8F22
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 13:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfKLMB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 07:01:29 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:1172 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfKLMB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 07:01:28 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dca9ee00000>; Tue, 12 Nov 2019 04:00:32 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 04:01:28 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 04:01:28 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 12:01:25 +0000
Subject: Re: [PATCH 4.19 000/125] 4.19.84-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191111181438.945353076@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <115fb81e-6eef-59d1-9c48-85c58fd5d4d7@nvidia.com>
Date:   Tue, 12 Nov 2019 12:01:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573560032; bh=kYzJvlrjL/t3vZg0TUH9xRibvGN3/HntHNrZXbRNiqE=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=L50ygDTq9ZQVocZp2zNyT0/1YhQ8jps1YFztLvv9PzY7jmYNeAW46YRlqxeOiyEzd
         D1Hj/7twzMOBRU+oKTAuwNW32zx4seOD/IylS71EnVkEIIEOHGbXsRpE0E3BC5Y+cO
         om6I8jsKvhp4VvVoQWUOsBSHanKUisP3gpW8wABkV1Xqnoi9K0Lq7wGDR21ygsE7Vq
         DmFr41zanZjyoV8KNo5zJS1HOvgz7q8scGu48nxFuKnm5FxBM7vkn1TgKe8uH6odEH
         oT3PRuThKnwa/2CKxsnholNW9v05fprfMt9bwHGY92dFiDLD6BkDCVMbEZ8C98ZYcP
         R4SoMtYDfM2Vg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/11/2019 18:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.84 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests for Tegra are passing ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.84-rc1-g0f8b6b0b5b94
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
