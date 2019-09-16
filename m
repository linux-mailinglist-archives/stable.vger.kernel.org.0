Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C56B38C4
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732261AbfIPKzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:55:10 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19358 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729112AbfIPKzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 06:55:10 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d7f6a130000>; Mon, 16 Sep 2019 03:55:15 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Sep 2019 03:55:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Sep 2019 03:55:09 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 10:55:09 +0000
Received: from [10.21.132.148] (10.124.1.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Sep
 2019 10:55:06 +0000
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH 4.14 00/21] 4.14.144-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190913130501.285837292@linuxfoundation.org>
Message-ID: <c7186e08-3faa-5a4a-8c96-957592667199@nvidia.com>
Date:   Mon, 16 Sep 2019 11:55:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130501.285837292@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1568631315; bh=XtBvUo7ErPWpwywlPIBPO8hsGed2vWoZb2aISH+/vxk=;
        h=X-PGP-Universal:From:Subject:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Kyfsw2UiYrJb3rNsHHBCZuRrbvb7YyV/8tSyxi1IREXX8H0UD3OkMOJfkll8lWE8p
         x1RtdoMdmTuk5JbVCexvX+8yoMQYt5dwaO/OtQpaOZi5nTgE94n4sl2dM//d8Qmyay
         P2gToeK+q8s7+UiEY3MAzK6TvoYjoEHWUPrzJDzMLf7JAyW4lot7SMPitqOJ6QMmfm
         KOSXlwMnCo4Z0pR54pRA0jMPBZDYfmeih8sYmYGN3dQssfYq10OookQ5gvd+2Ape1Y
         P/eNwSND87q5DTzR52xod2/s8HKVdg1m2nofuzpvDju22Ja1oUHPCMTdnzojA+pUUy
         GsOf7p3N/a4Ww==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/09/2019 14:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.144 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests passing for Tegra ...

Test results for stable-v4.14:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.14.144-rc2-ga0bf0c3c56ab
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
