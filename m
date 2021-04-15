Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20434360244
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 08:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhDOGSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 02:18:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:16592 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhDOGSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 02:18:16 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FLTbp5S4Bz18J8t;
        Thu, 15 Apr 2021 14:15:34 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 14:17:48 +0800
Subject: Re: Linux 5.4.112
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <161838289817242@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <f877c184-0992-d4db-4321-f9f51b419c5a@huawei.com>
Date:   Thu, 15 Apr 2021 14:17:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <161838289817242@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/4/14 14:48, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 5.4.112 kernel.
> 
> All users of the 5.4 kernel series must upgrade.
> 
> The updated 5.4.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.4.112,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.112
Commit: 8f55ad4daf001b6ee8ddf672e14475a35403b258
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 5764
passed: 5764
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 5764
passed: 5764
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
