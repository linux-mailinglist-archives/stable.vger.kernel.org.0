Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3A1511F1
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 22:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgBCVjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 16:39:52 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13988 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgBCVjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 16:39:52 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e3893100000>; Mon, 03 Feb 2020 13:39:28 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 03 Feb 2020 13:39:51 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 03 Feb 2020 13:39:51 -0800
Received: from [10.26.11.224] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Feb
 2020 21:39:48 +0000
Subject: Re: [PATCH 4.19 00/70] 4.19.102-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200203161912.158976871@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <022a1e41-2221-3124-a7f3-909cf08edd1f@nvidia.com>
Date:   Mon, 3 Feb 2020 21:39:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1580765968; bh=kjhA0tZxxu3S4eN8L9BfeZeqw5izXFeYwyWs7wZIxmw=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=enAfhxufox1KLT1keTEpxS5WRS2iPbR19jE1cryH3m6O3IBp6lJoXqkkVcMKPU390
         nPFPmZmT5ZrpPjRLVxDpqGrIFVcZoXOqQq/rB74QSPdW6VYc4u+NLpD7c49LGGItap
         c+6/kZiHRivyCORrLgBGw998n5zOFniZFbByJyeSzMBIQfVNIB1hhbafbSv/qwcqzh
         w+gC+H+RDqjmIZ5AXTX3hiEShxEmLq6V+nAmeLHGSkBfhNPFxwUgKdHCtvtCBCxMuB
         KgGwjsu6Cx1c7QX0ymzt5rR+5EtI+7JWXrHdrmK2hMODaSsDxWkkJM6nbsETeOFBW8
         bZF1rX2Pp7BAw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/02/2020 16:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.102 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.102-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.19:
    11 builds:	11 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.102-rc1-g15412149f234
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
