Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9A53949A8
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 02:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhE2Apd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 20:45:33 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2454 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhE2Apc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 20:45:32 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FsN5T4CXgz67JG;
        Sat, 29 May 2021 08:41:01 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 08:43:55 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 08:43:55 +0800
Subject: [linux-stable-rc CI] Test report for 4.14.235-rc1 on x86
From:   Samuel Zou <zou_wei@huawei.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <8271104d-0569-014a-63fe-02881cd45ca2@huawei.com>
 <8fea2e56-517c-dad4-62cc-b3521c67f562@huawei.com>
 <a2421ee5-4454-61a2-b56f-38d1650b74f2@huawei.com>
 <ea917176-a1c9-5845-26b7-928354388194@huawei.com>
 <fd057e1a-bca7-fe7d-e3f0-fed84e8f5abb@huawei.com>
Message-ID: <fec5214d-3a8c-1390-f12f-c903be446532@huawei.com>
Date:   Sat, 29 May 2021 08:43:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fd057e1a-bca7-fe7d-e3f0-fed84e8f5abb@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested on x86 for 4.14.235-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.235-rc1
Commit: 599af343b6b74265e0054582d301c7cd32cfc686
Compiler: gcc version 7.3.0 (GCC)

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8833
passed: 8833
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
