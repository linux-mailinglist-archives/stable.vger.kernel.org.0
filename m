Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1223D34A11D
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 06:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhCZFph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 01:45:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14480 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhCZFpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 01:45:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F69qn4MHCzyNFS;
        Fri, 26 Mar 2021 13:43:17 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 13:45:16 +0800
Subject: Re: Linux 4.14.227
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <16165813912347@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <515d1bf1-d784-9da4-866d-b4b29126a12e@huawei.com>
Date:   Fri, 26 Mar 2021 13:45:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <16165813912347@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/24 18:23, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.14.227 kernel.
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

Tested on x86 for 4.14.227,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.227
Commit: 670d6552eda8ff0c5f396d3d6f0174237917c66c
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

