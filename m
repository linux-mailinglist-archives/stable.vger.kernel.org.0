Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9F13B2794
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 08:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhFXGsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 02:48:40 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:8318 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFXGsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 02:48:39 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G9VtB2YRXz71Xq;
        Thu, 24 Jun 2021 14:42:10 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 14:46:17 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 24 Jun 2021 14:46:17 +0800
Subject: Re: Linux 5.4.128
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable@vger.kernel.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>
References: <162445495872219@kroah.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <adb2a03d-8f1a-5cce-1dbf-3e1418c063df@huawei.com>
Date:   Thu, 24 Jun 2021 14:46:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <162445495872219@kroah.com>
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



On 2021/6/23 21:29, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 5.4.128 kernel.
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

Tested on arm64 and x86 for 5.4.128,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.128
Commit: 4037804c55745738e0950658a5132790e6ac52e4
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8905
passed: 8905
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8905
passed: 8905
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
