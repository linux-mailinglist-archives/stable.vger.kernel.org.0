Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D8010C746
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 11:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfK1Kzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 05:55:40 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11069 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfK1Kzk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 05:55:40 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddfa7ae0000>; Thu, 28 Nov 2019 02:55:42 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 28 Nov 2019 02:55:39 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 28 Nov 2019 02:55:39 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 10:55:37 +0000
Subject: Re: [PATCH 4.4 000/132] 4.4.204-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191127202857.270233486@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <1fb60552-bb43-ef89-f361-fb7333aebb1b@nvidia.com>
Date:   Thu, 28 Nov 2019 10:55:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574938542; bh=aGbcbOvqfsAr7MsM1e1a7mUp7YLaSjfoM0MB+4WIRGU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=hZU/fm4RhDPhQdgMa4rE92jOEwu/yCAb0qazKh8xHUA2VeCYidEOcNB1/2P48hIg7
         z0sr5XhRO6yxpDEnArgw6KhRhHTARJ+1KYXqjrD3bSsb17wum0XnVy+XoHu4jLbGZD
         YOIxKSo9HeAkpfbpPeh4R9BLyh2yZGO1dosGJT48sYBuhrqnMH2t2p6IAmRjOZckDl
         6zjP6qobk89veCpkOCteCIZKK9csY3tHn9oqDv31714jkg8zmHJz2S9N0dZhstoOZy
         XjWTz1bTssnGrkMZpSnXjun/jJ5Gb8qSd5zkK5nRu1ycbO0Xql5XG8B2RJfrw0Eamf
         4aCq5a2uLN5Nw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/11/2019 20:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.204 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------

All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    19 tests:	19 pass, 0 fail

Linux version:	4.4.204-rc1-gd7e1aa334904
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
