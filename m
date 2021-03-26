Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F879349E38
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 01:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCZAsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 20:48:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14877 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCZAr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 20:47:57 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F63Df51vGz9t4h;
        Fri, 26 Mar 2021 08:45:54 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Fri, 26 Mar 2021 08:47:51 +0800
Subject: Re: Linux 5.10.26
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <161666093914799@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <8b5af1e7-57f7-1610-a8fc-6b9a433ce617@huawei.com>
Date:   Fri, 26 Mar 2021 08:47:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <161666093914799@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/3/25 16:28, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 5.10.26 kernel.
> 
> All users of the 5.10 kernel series must upgrade.
> 
> The updated 5.10.y git tree can be found at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
> and can be browsed at the normal kernel.org git web browser:
> 	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> thanks,
> 
> greg k-h
> 

Tested on arm64 and x86 for 5.10.26,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.26
Commit: 856cd02bbdd412bf91ce327a3c97c52066f11c79
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4720
passed: 4720
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4720
passed: 4720
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>

