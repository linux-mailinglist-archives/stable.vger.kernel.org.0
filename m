Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD96412A72
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 11:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfECJ1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 05:27:38 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1347 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfECJ1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 05:27:38 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ccc096a0000>; Fri, 03 May 2019 02:27:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 03 May 2019 02:27:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 03 May 2019 02:27:37 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 3 May
 2019 09:27:35 +0000
Subject: Re: [PATCH 4.14 00/49] 4.14.116-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190502143323.397051088@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ec1b3ef2-523a-61f4-32be-2ddcdeac27e7@nvidia.com>
Date:   Fri, 3 May 2019 10:27:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL101.nvidia.com (172.20.187.10)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1556875626; bh=uBAoCoztT7TRAGja6Wr7gfP41wtG+konRr+aOT9FelI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=g7+c+Ta1iPv9DGpExsaDum8Psq4R6nLp4urIg/QjrEOK6H80j2VuNUFPEwEewgXVd
         aY8jERiqAOpD4qT2j5Y66KYFBwgVj0FsBYhc/qSmYW4H+50XcTfng8kc0oqI8kC1xm
         hmXePJWtka6yJpDcjiEzuH9O2iV9v6kyDG4GN9ZzJBJVppD2EkiX1IjECoCFnvW0bp
         NRMsVYa5imLRSXeqS7Fp3Cbwzo99CCQ3V1+bpbKqmAUD85TyQaQNruWH8l6oZnLsbA
         eTkzltfwKATmisa1M2nv5E7DxHURKEtGxIPyPcn+XD2bzmss8WHstOm9p3ShJH7p38
         p/CpvcmZ+dm/Q==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 02/05/2019 16:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.116 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:06 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.116-rc1-ga4aa5bf
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
