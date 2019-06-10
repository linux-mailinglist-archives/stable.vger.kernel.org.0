Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97833B13C
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 10:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbfFJIud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 04:50:33 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7322 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387890AbfFJIuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 04:50:32 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5cfe19d80000>; Mon, 10 Jun 2019 01:50:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 10 Jun 2019 01:50:31 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 10 Jun 2019 01:50:31 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 08:50:29 +0000
Subject: Re: [PATCH 4.9 00/83] 4.9.181-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20190609164127.843327870@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <585769c0-2c9d-20d1-de18-cba5e37b03e5@nvidia.com>
Date:   Mon, 10 Jun 2019 09:50:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL106.nvidia.com (172.18.146.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560156632; bh=ZokrrMNJ71l+YyeOrMWNSzwuEnrKyxByseIVWXhZtbA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=V2bz8hnCZb/AlfNuJSHZWWA6jVduoy2okj1YQoPoHEGnjzTuulIWCydm5tOT5tU+F
         IVu7lABge8uoZPHiw5dePrhmHiqaku2THt3fd8QCQIKQOEyedRgx5ZkH1AYpufuth1
         Sv/WY0ZDIYX8vSm2CPDK3nO5RD2zB9FcF2hThZ0wM/b7ikfmZu+cKTm9C1/xrXbfWa
         rIcNSkzFhAbC1VlqF/gbi1Oo6XbasRH8EjYJiaRHhR+vIkhnbdhDGjSVaCu6XmXrOk
         IrxMFQmdbwvvWbrsxXhKOpJxIrVlCFhmdHs/XAbUaH79BW8WelgfvQn6rTu19CddiK
         SYX5bVxueQUlg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 09/06/2019 17:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.181 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:39:58 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.181-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests are passing for Tegra ...

Test results for stable-v4.9:
    8 builds:	8 pass, 0 fail
    16 boots:	16 pass, 0 fail
    24 tests:	24 pass, 0 fail

Linux version:	4.9.181-rc1-g4fcf72d
Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
