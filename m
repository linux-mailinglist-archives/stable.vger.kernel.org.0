Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBD96CBC0
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 11:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfGRJVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 05:21:02 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14459 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfGRJVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 05:21:02 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d303a030002>; Thu, 18 Jul 2019 02:21:07 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 18 Jul 2019 02:21:01 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 18 Jul 2019 02:21:01 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 18 Jul
 2019 09:20:58 +0000
Subject: Re: [PATCH 4.19 00/47] 4.19.60-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190718030045.780672747@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ef3cc43e-8f60-99c6-fa82-66eebc08ab9b@nvidia.com>
Date:   Thu, 18 Jul 2019 10:20:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718030045.780672747@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563441668; bh=MlqoQ+5CQwJhrOUHE0VoyMxCPlZT6qKbBFNMJdepZNU=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FoqTosoUqNF0MMTQWjVDGbXFhAAbzosRxfq+Cwi2dGZrgEi4sMa8yt+98X53oP5K3
         TizhFsI6Mlt/+uLBWVKRj6Tlo7sv23xF56r5G0Kb0cBnVoRk4m8QvwjpZI+Gzyi78O
         Zjc8MRCxFzjrN/Nk27HAUZ44i8OtgCtJqMZxukVmwSfmhVzkqgrTyirbbi5tAVNlxg
         Qwok9yVbNphUOI7IsskYSz4ocODz5iuLbCvqHy0cSTnYxSO3Ei4QZG41Zi4OyWacf6
         RCZJrFYjBo2qaNcMzfoMxqZCSK65Jd2SxA09o64vHFUW8fo+8l1BB9Y0/y4KZgGui5
         qiK7Z+m940Peg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/07/2019 04:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.60 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.60-rc1.gz
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

Linux version:	4.19.60-rc1-gaa9b0c7579ba
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
