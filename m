Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433AF380169
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 03:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhENBE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 21:04:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2308 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbhENBE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 21:04:56 -0400
Received: from dggeml717-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fh9Cd5rq0z19JTq;
        Fri, 14 May 2021 08:59:25 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggeml717-chm.china.huawei.com (10.3.17.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 09:03:43 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 14 May 2021 09:03:42 +0800
Subject: [linux-stable-rc CI] Test report for 4.19.191-rc1/arm64 and x86
From:   Samuel Zou <zou_wei@huawei.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <8271104d-0569-014a-63fe-02881cd45ca2@huawei.com>
Message-ID: <8fea2e56-517c-dad4-62cc-b3521c67f562@huawei.com>
Date:   Fri, 14 May 2021 09:03:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8271104d-0569-014a-63fe-02881cd45ca2@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested on arm64 and x86 for 4.19.191-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.191-rc1
Commit: 69ba3015e443c6bdf3a588d7ead0592d2920f6cb
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8435
passed: 8435
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8435
passed: 8435
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
