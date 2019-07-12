Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6080267008
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 15:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGLN1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 09:27:06 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9719 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfGLN1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 09:27:06 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d288aac0002>; Fri, 12 Jul 2019 06:27:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 12 Jul 2019 06:27:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 12 Jul 2019 06:27:05 -0700
Received: from [10.26.11.231] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 12 Jul
 2019 13:27:00 +0000
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>, <j-keerthy@ti.com>
References: <20190712121628.731888964@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <4dae64c8-046e-3647-52d6-43362e986d21@nvidia.com>
Date:   Fri, 12 Jul 2019 14:26:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1562938030; bh=Q2Y5HNhu6cRQzurLvAkU7Yps/temzPw4REY6pADXcGM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=WD1DO2vCZ3Ma+umQF1ECtY45Q6y+3121pMBxGSss+VdPeC+W1MTaGwckblX3CG35G
         soEs6MgHX2CjBO2wONAekRsXo/Ue0MDpk+BDQm+2HgvnbGuB0HUgy34M3+2pE+TrB+
         K1HpAXeQItji+so6783+saemJcF7ZBmhV+scRb8iDwp9eYlxUJ1jRuZJc3zLUiEmN5
         xXR2VvqKXNo03NQyNnu36Rx+R/uYbgeQe1MlkhzCidRlH0N5udEMQKnf94FaipY8Ye
         b9ow2uwjGRAnikK3m8A9HOhs2mwM50NQ/S/lJB5EEu+WkGm2HxDN7SEvDi8TVbWFas
         b1Zzs/Vx6PFGA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 12/07/2019 13:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.18 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...

> Keerthy <j-keerthy@ti.com>
>     ARM: dts: dra71x: Disable usb4_tm target module

...

> Keerthy <j-keerthy@ti.com>
>     ARM: dts: dra76x: Disable usb4_tm target module

The above commits are generating the following compilation errors for
ARM ...

Error:
/dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:15.1-9
Label or path usb4_tm not found

Error:
/dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra76x.dtsi:89.1-9
Label or path usb4_tm not found

After reverting these two, I no longer see these errors.

Cheers,
Jon

-- 
nvpublic
