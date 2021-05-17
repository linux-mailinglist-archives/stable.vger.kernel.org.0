Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5D3822F8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 05:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhEQDCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 23:02:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3559 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbhEQDCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 23:02:35 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fk3jk0HP8zmVvy;
        Mon, 17 May 2021 10:58:34 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 11:01:17 +0800
Received: from [10.174.178.208] (10.174.178.208) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 11:01:17 +0800
Subject: [linux-stable-rc CI] Test report for 5.4.120-rc1/arm64 and x86
From:   Samuel Zou <zou_wei@huawei.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <8271104d-0569-014a-63fe-02881cd45ca2@huawei.com>
 <8fea2e56-517c-dad4-62cc-b3521c67f562@huawei.com>
 <a2421ee5-4454-61a2-b56f-38d1650b74f2@huawei.com>
Message-ID: <01eeb70f-83a2-26ab-2355-7badd7743086@huawei.com>
Date:   Mon, 17 May 2021 11:01:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a2421ee5-4454-61a2-b56f-38d1650b74f2@huawei.com>
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

8476Tested on arm64 and x86 for 5.4.120-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.120-rc1
Commit: 597e9eb189ad42b0e2d9125d720f45f51adeab09
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8476
passed: 8476
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8476
passed: 8476
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
