Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B3520F142
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 11:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgF3JN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 05:13:29 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2725 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgF3JN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 05:13:28 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efb022b0001>; Tue, 30 Jun 2020 02:13:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 30 Jun 2020 02:13:28 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 30 Jun 2020 02:13:28 -0700
Received: from [10.26.75.203] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jun
 2020 09:13:26 +0000
Subject: Re: [PATCH 4.4 000/135] 4.4.229-rc1 review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <3b34e3f2-6d78-d42f-7358-86fe430db1eb@nvidia.com>
Date:   Tue, 30 Jun 2020 10:13:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593508395; bh=RLxH6xnLK8ZOVtLH6xC/l0Kl5rUluekML1u1TVcJxMo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=LH3BBRfLXZ+4a+jHU9VrZykPGlA9l/TX+75XMTCqM/jLNzqZ0iZLD7XdNfELFAuEO
         ZNPy/5pWmiP5ZbU6O4IxgurqHO+rfgA0+GrykZ1NjXJfs0Yy48iSgfq65t40BfbDLr
         7xR/9S7ZzBDYIldoN4gmRXZoi95I6If4DqCkS3WYPs/3y5t/s1D6sIqVUKbOYIpkrH
         It6zt4zyze6Ipsnjc5FJXWec/D87bjP3veLlMzxW4J8WrylXkFEF6ZVnDZYQ/RQjMB
         Tk/eBiV2xITWb4mhUsH40lVG918wYX7LmAcxvuIJY0miw5r/71F9Yni63NN8AoiyOT
         OuT95KTSVwhfg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/06/2020 16:50, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 4.4.229 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:53:07 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-4.4.y&id2=v4.4.228
> 
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> --
> Thanks,
> Sasha


All tests are passing for Tegra ...

Test results for stable-v4.4:
    6 builds:	6 pass, 0 fail
    12 boots:	12 pass, 0 fail
    25 tests:	25 pass, 0 fail

Linux version:	4.4.229-rc1-g136455f30e39
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
