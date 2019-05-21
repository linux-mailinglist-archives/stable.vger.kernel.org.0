Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF80624AD5
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfEUIw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:52:26 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5155 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfEUIw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 04:52:26 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ce3bc460001>; Tue, 21 May 2019 01:52:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 21 May 2019 01:52:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 21 May 2019 01:52:25 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 21 May
 2019 08:52:22 +0000
Subject: Re: [PATCH 5.0 000/123] 5.0.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190520115245.439864225@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <38bbf46f-484c-3777-cb89-3e946fe49be4@nvidia.com>
Date:   Tue, 21 May 2019 09:52:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1558428742; bh=m3Xqf0zjUtyVG46uo8sJWsyXf+Gj94yu/RwzmPq9bEk=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=mJ5KySveNt7xy4hya03j4ZqZugyzmhSkXwF6OR7UHGHyjiaUKm+xXyJ4f0iULgvwG
         4RlDzfmJJCaGYc0T6lXPSW/6mBRoz0usk4FJxFQBwK89enaidri2lvCglZa/nTZtrg
         M8QiLMdaBlThvct32wWGET484hQsGJwb6A94ebGZXrTdNRZAlBNejN1pSmzJIDnR9Z
         rGPNndbpolSbnOMwhOja4jk8tembxUKpXjdZMckt4fTdpWGtXQYMkuul5zuTmP1EIK
         M61sz14Q7oFfiejkJk/JV5Q29LQAj6of9nhi1Q49FSke62hiF1rqrCyoals2QgsoS8
         mN+PIyonYUjzw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/05/2019 13:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.18 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 22 May 2019 11:50:46 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.0.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.0:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	5.0.18-rc1-gbb27727
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
