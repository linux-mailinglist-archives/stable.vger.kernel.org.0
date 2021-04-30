Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1269336F332
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 02:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3Aia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 20:38:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17409 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhD3Ai3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 20:38:29 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FWYLd6t7FzlbhF;
        Fri, 30 Apr 2021 08:35:37 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Fri, 30 Apr 2021 08:37:35 +0800
Subject: Re: Linux 4.19.189
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <161961057518956@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <e6e53748-a57e-ab17-e2fb-0ff3313fb907@huawei.com>
Date:   Fri, 30 Apr 2021 08:37:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <161961057518956@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/4/28 19:49, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.19.189 kernel.
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

Tested on arm64 and x86 for 4.19.189,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.189
Commit: 97a8651cadce7c2b7c4d8f108b392eff31fe2c08
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 6263
passed: 6263
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 6263
passed: 6263
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
