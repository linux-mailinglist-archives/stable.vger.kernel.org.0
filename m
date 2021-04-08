Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE6357CC2
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 08:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhDHGr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 02:47:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15963 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhDHGr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 02:47:56 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FGBbc4DF1zyNjd;
        Thu,  8 Apr 2021 14:45:32 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Thu, 8 Apr 2021 14:47:40 +0800
Subject: Re: Linux 4.14.229
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <1617794196159229@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <072bb282-0290-2bd8-e4db-884b233fea10@huawei.com>
Date:   Thu, 8 Apr 2021 14:47:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1617794196159229@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/4/7 19:16, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.14.229 kernel.
> 
> All users of the 4.14 kernel series must upgrade.
> 
> The updated 4.14.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 

Tested on x86 for 4.14.229,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.229
Commit: 0cc244011f40280b78fc344d5c2aac5a0c659f77
Compiler: gcc version 7.3.0 (GCC)

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4667
passed: 4667
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>

