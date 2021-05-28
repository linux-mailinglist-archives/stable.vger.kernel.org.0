Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E212393D0D
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 08:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhE1GYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 02:24:47 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2331 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhE1GYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 02:24:45 -0400
Received: from dggeml752-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FrvDS09HMz1BFtW;
        Fri, 28 May 2021 14:00:24 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggeml752-chm.china.huawei.com (10.1.199.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 14:04:59 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 14:04:59 +0800
Subject: [linux-stable-rc CI] Test report for 4.19.193-rc1 on arm64 and x86
From:   Samuel Zou <zou_wei@huawei.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <8271104d-0569-014a-63fe-02881cd45ca2@huawei.com>
 <8fea2e56-517c-dad4-62cc-b3521c67f562@huawei.com>
 <a2421ee5-4454-61a2-b56f-38d1650b74f2@huawei.com>
 <ea917176-a1c9-5845-26b7-928354388194@huawei.com>
Message-ID: <fd057e1a-bca7-fe7d-e3f0-fed84e8f5abb@huawei.com>
Date:   Fri, 28 May 2021 14:04:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ea917176-a1c9-5845-26b7-928354388194@huawei.com>
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

Tested on arm64 and x86 for 4.19.193-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.193-rc1
Commit: f96d7c02c0d0a6180888c0241399373121777708
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8855
passed: 8855
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8855
passed: 8855
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
