Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDED337E6
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 20:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFCSdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 14:33:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15140 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfFCSdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 14:33:06 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cf567e00000>; Mon, 03 Jun 2019 11:33:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 03 Jun 2019 11:33:05 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 03 Jun 2019 11:33:05 -0700
Received: from [10.26.11.157] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Jun
 2019 18:33:02 +0000
Subject: Re: [PATCH 4.19 00/32] 4.19.48-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190603090308.472021390@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <87bedfca-5d88-a697-1f10-25fe964d69a3@nvidia.com>
Date:   Mon, 3 Jun 2019 19:33:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL108.nvidia.com (172.18.146.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1559586784; bh=u+wT24mGyHsbtfP2s/PCxFI9aBFkb1je47cecOWWjtg=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=A3TCvfX00eCyOkJR/lHdsD5rB1AG9tggA4TWpheR/52rBnWtQZnfw/hCuld3CFxt6
         9BCjrvH/h2aX534SvEAxecCWJGjvDQaWnjXzoQfc34/xwqUF7Or8x/zTdazg/WdgEt
         OZrtcGZp6a8aoZMIhqTqF1ef9ydwMSdLQCgW5oUjs17o836rRjI1JZO7YY2l13iu/F
         VqA21gwSbEFqxj+DJst7I1An3Jgoue3K03fAGRdJJPq/Xv2+b4HedDN+9dxDUOEfiv
         xsDfg6eIF7YRgEuS9cjnm6+GBwz1sND/dODpRASVUiWXJswHURy2GatG/Ho/r7vR/S
         Qc72yClYjV4xA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 03/06/2019 10:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.48 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:02:49 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.48-rc1.gz
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

Linux version:	4.19.48-rc1-g322f407
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
