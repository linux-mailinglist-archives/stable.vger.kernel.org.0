Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CC120F15A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 11:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgF3JPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 05:15:36 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10224 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729866AbgF3JPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 05:15:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efb02550000>; Tue, 30 Jun 2020 02:13:57 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 30 Jun 2020 02:15:35 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 30 Jun 2020 02:15:35 -0700
Received: from [10.26.75.203] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 30 Jun
 2020 09:15:33 +0000
Subject: Re: [PATCH 5.7 000/265] 5.7.7-rc1 review
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <58ac88f8-bb04-2aa0-58da-5eb43c8fc175@nvidia.com>
Date:   Tue, 30 Jun 2020 10:15:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593508437; bh=BWUcapYK1XTuRW5qNBQEtL950SgyZLIB9Td6l1KiEng=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=a3EerosasH6oYdnSbDpm38BBjelCPxUDPXf8pbFdRGSx/TEocAGr2JKrASdLLVnhk
         nPc1rYZDtsr9/YRIDiW2gXByRn12zjsc0dwEr3NfFPxS6yZcj6fkm0Q2iZVFGI6Gz1
         w3PCTGdeU4preae7Xtm2ZsW3xpaf3RYe2jL/5RIwQkYcOE5ZrNYnnmhTcNKGZS7I0C
         ylL8nrEep1pbub6Ch4+rvxmZtylUXotWMU/idRHHHhCuAsGkFB0LFcahOQ7gdGeAj5
         5dD44Hu7EgD6CGdY4yhB77XKJE4nlOtF2rz+qXR8z9gbWEkT01xYdxzUQ3CQCO0Nm3
         XWej+8ELdj9DQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29/06/2020 16:13, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.7.7 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 01 Jul 2020 03:14:48 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.7.y&id2=v5.7.6
> 
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> and the diffstat can be found below.
> 
> --
> Thanks,
> Sasha

All tests are passing for Tegra ...

Test results for stable-v5.7:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    56 tests:	56 pass, 0 fail

Linux version:	5.7.7-rc1-g97943c6d41ef
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
