Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30821642F1
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 12:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgBSLGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 06:06:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19249 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgBSLGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 06:06:18 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e4d16890000>; Wed, 19 Feb 2020 03:05:45 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 19 Feb 2020 03:06:17 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 19 Feb 2020 03:06:17 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 19 Feb
 2020 11:06:15 +0000
Subject: Re: [PATCH 5.4 00/66] 5.4.21-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20200218190428.035153861@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <07395747-8acf-2bc2-4d1a-a18d459ee051@nvidia.com>
Date:   Wed, 19 Feb 2020 11:06:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1582110345; bh=xVrCxP9TSGwFzPOF0o9gIz4WPfkM49CVhXedXvDe75w=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=O2Cewf7L3ug3Val/cCcXSS6kyU5HumIdTcqesq4ZhUk4+OQLy+KItowaXuIAHpXcQ
         onRLwxIl3xJtP3Rc01R2ShDX9RWaAGx5+5//69yaRH1p4r7q/Ag2wS2x7X9Ra9Qch4
         Eq4EpLeYD5JNrmHduJgh/J9l39vTD/4u0ifobQnkjItD27NWW/s7YxN8TaQZdW0RvI
         Uf1/QgKYDAT5unmNvz22GIPSkMyUM8pTSrSurtjPluOzsrHNSda4zMqR3j9OKDwuOJ
         jFab9gDpUxq4L8wVKvagheHB4Ou0EtC7s85dpMSRPoidowgcAhDFKj6aywpJRlVO+Q
         co2zZoRolYWqw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 18/02/2020 19:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.21 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Feb 2020 19:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v5.4:
    13 builds:	13 pass, 0 fail
    22 boots:	22 pass, 0 fail
    40 tests:	40 pass, 0 fail

Linux version:	5.4.21-rc1-g70464966e42b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
