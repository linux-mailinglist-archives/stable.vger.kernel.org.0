Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65053ADC49
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 03:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFTBsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Jun 2021 21:48:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5406 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFTBso (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Jun 2021 21:48:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G6wRB6wrVz71Wp;
        Sun, 20 Jun 2021 09:43:18 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 20 Jun 2021 09:46:31 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sun, 20 Jun 2021 09:46:30 +0800
Subject: Re: Linux 4.14.237
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <1623839514115200@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <985aef25-e570-68a8-fb1f-16ffd320a66e@huawei.com>
Date:   Sun, 20 Jun 2021 09:46:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1623839514115200@kroah.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/6/16 18:31, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.14.237 kernel.
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

Tested on x86 for 4.14.237,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.237
Commit: cfb41ef9deb1e6572ac218ddfcec9567e5d1c101
Compiler: gcc version 7.3.0 (GCC)

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8835
passed: 8835
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
