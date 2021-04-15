Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F4A360241
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhDOGSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:18:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15682 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhDOGSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 02:18:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FLTZr5Q4zzpYNH;
        Thu, 15 Apr 2021 14:14:44 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 14:17:35 +0800
Subject: Re: Linux 4.19.187
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <161838241321927@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <17fc4daa-e6c9-21b3-4406-d946406594fd@huawei.com>
Date:   Thu, 15 Apr 2021 14:17:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <161838241321927@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/4/14 14:40, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.19.187 kernel.
> 
> All users of the 4.19 kernel series must upgrade.
> 
> The updated 4.19.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 4.19.187,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.187
Commit: 0f1b4cb77d7f5a442b03f8ad597768b422e8ec58
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 5723
passed: 5723
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 5723
passed: 5723
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>

