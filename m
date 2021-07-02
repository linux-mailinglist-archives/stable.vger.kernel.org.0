Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD943B9A4E
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 02:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhGBBC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 21:02:29 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10235 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhGBBC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 21:02:29 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GGGnQ3KFhz1BTcT;
        Fri,  2 Jul 2021 08:54:34 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 08:59:56 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 2 Jul 2021 08:59:55 +0800
Subject: Re: Linux 5.10.47
To:     Sasha Levin <sashal@kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>
CC:     <lwn@lwn.net>, <jslaby@suse.cz>, <gregkh@linuxfoundation.org>
References: <20210630134020.478257-1-sashal@kernel.org>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <b16455d7-4272-aae5-3df1-5d6a2d4fe09b@huawei.com>
Date:   Fri, 2 Jul 2021 08:59:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210630134020.478257-1-sashal@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/6/30 21:40, Sasha Levin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> I'm announcing the release of the 5.10.47 kernel.
> 
> All users of the 5.10 kernel series must upgrade.
> 
> The updated 5.10.y git tree can be found at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
> and can be browsed at the normal kernel.org git web browser:
>          https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> 
> 
> Thanks,
> Sasha
> 

Tested on arm64 and x86 for 5.10.47,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.47
Commit: 4357ae26d4cd133a86982f23cb6b321304faac50
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8906
passed: 8906
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8906
passed: 8906
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
