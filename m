Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE9A11F055E
	for <lists+stable@lfdr.de>; Sat,  6 Jun 2020 08:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgFFG1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Jun 2020 02:27:46 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1367 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgFFG1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Jun 2020 02:27:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5edb37080000>; Fri, 05 Jun 2020 23:26:16 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 05 Jun 2020 23:27:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 05 Jun 2020 23:27:45 -0700
Received: from [10.26.72.65] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Jun
 2020 06:27:43 +0000
Subject: Re: [PATCH 5.6 00/43] 5.6.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200605140152.493743366@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <f79dcb37-ce79-5029-be0a-afd1241eb5be@nvidia.com>
Date:   Sat, 6 Jun 2020 07:27:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1591424776; bh=yHgtJ/HkobIUCtbL8CcJlh0rMdFxHadzCIZF44EDi94=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ow3MlWAP+PVj+IUnfImuTohoa4A5539O3DmssLdksdVKQxBnIP+D93L1nTtYMlFoz
         gpvnX1ElP71c+DAPdcdkhHidWFaUprpg/1oMO7HkBMu+QVC+EYmurzpf4zZF8bl6ma
         1+D8yyE3AVMuTr23Ax1Ft0JSINn5MDI24c6OV/fxO6L7X4TsmOGpvrqk9NHP9t2bF9
         OUhFzTNhzD1HdHZkUP1neJqwM9msZqtv/mvhVQM0qoEO2SAY5JOvN76E5xhCLCuxtm
         qhw7KlqI642dZ8Pu3Fb8LbhUYI9A1sSNFfKIZ7bL2Hgj+k9PFAk1GRzJ1e0tR7CDua
         T/dnJoe/J39lQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/06/2020 15:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.17 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Jun 2020 13:54:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests are passing for Tegra ...

Test results for stable-5.6:
    11 builds:	11 pass, 0 fail
    26 boots:	26 pass, 0 fail
    50 tests:	50 pass, 0 fail

Linux version:	5.6.17-rc1-gcb5634cad7d5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
