Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED54C385B
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 16:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfJAO7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 10:59:11 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14278 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfJAO7L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 10:59:11 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d9369c70000>; Tue, 01 Oct 2019 07:59:19 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 01 Oct 2019 07:59:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 01 Oct 2019 07:59:11 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Oct
 2019 14:59:10 +0000
Received: from [10.21.133.51] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Oct 2019
 14:59:08 +0000
Subject: Re: [PATCH 5.3 00/25] 5.3.2-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>
References: <20190929135006.127269625@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <97a5107b-9b90-53be-47d3-dc5167013fd6@nvidia.com>
Date:   Tue, 1 Oct 2019 15:59:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190929135006.127269625@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1569941959; bh=vlBuovp/QWAOJq7PbYB4M4/L1Yv+5OKRVTSIGFN3PHU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=R5aYN2V8nvnZs8TTgigVCbycAu+uM48zVsYR71hzgSU3ph8JThUi5DXNpn4iWtmY6
         fcTsuOkkG4qmoGvjqQEkBXayovK8MtF0VgFjNvcSbe0s6In1hC4n+mjxT+aSnsFmn7
         nyQ7S5JiWb1CdFDIbBlDqMXYGbfCa3ZErl0lUiEDQDgu7YLnYT3lfvFad4R5nHjyO2
         q+zBiMXeNJH9fbtoQBRMiz6/1h0MLBjCfft2ZBd0kqZt3kCH27vv5NWRZTQG166tHJ
         DhV1JQ+aIxlbundnn7kWvv+3/GMwNzKS1I3lxsrgct67POTma92zK3uhtp5HF8gcPs
         eVMbhxBGfdSlw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/09/2019 14:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.3:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    38 tests:	38 pass, 0 fail

Linux version:	5.3.2-rc1-g5910f7ae1729
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
