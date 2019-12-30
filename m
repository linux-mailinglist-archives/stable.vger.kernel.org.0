Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B462C12D465
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 21:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfL3UTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 15:19:08 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2823 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfL3UTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 15:19:07 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e0a5bac0000>; Mon, 30 Dec 2019 12:18:52 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 30 Dec 2019 12:19:06 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 30 Dec 2019 12:19:06 -0800
Received: from [10.26.11.89] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Dec
 2019 20:19:03 +0000
Subject: Re: [PATCH 4.14 000/161] 4.14.161-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191229162355.500086350@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <6f3d971c-ef8c-62e3-b0e1-e1ad1d135c73@nvidia.com>
Date:   Mon, 30 Dec 2019 20:19:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1577737132; bh=fGtAHt2b8Ds9k/oacM72vQ8sdTTLuiR4VkAdbqEmXio=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=cvdsd5E5t1BEz5I8KEVx9++RG16D1VpocUZ+zZB5VCNIw6rgWUK9UzKfNLv+8KvfQ
         zL/eFomtMhk72ZkaVttkepQatLeaadCyQAPTP7VlSy3nmO/euIacjIMDcxUe0cnuqU
         h7jMf5qI1SpPVsLWIW5eGHlaffuNkT2lsHq5urAzuDVuJNpnWm6qFgN+SJGU5vPU+C
         Fms/jUvm4mvUGa2aPFrKx8xc8BxD9rHtPNXfa4MkX2vksIr0r1FbXWdhUAs1t8zJ+a
         CxUkzI+KGF2px6J5gv5ZXqcfBnRDQCJxFM2iiKqE0M+uLjByF9W5oSWMN0ZlU4D7gh
         gdwOJOp5eeDTw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/12/2019 17:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.161 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------


All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.161-rc1-g9973cdd1885a
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
