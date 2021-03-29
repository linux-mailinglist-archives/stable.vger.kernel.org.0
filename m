Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A18034C132
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 03:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhC2BhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 21:37:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15078 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhC2Bg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 21:36:57 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F7w9m5VM9z19GWf;
        Mon, 29 Mar 2021 09:34:52 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:36:51 +0800
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Subject: [linux-stable-rc CI] Test report for 4.14.228-rc1
Message-ID: <916f450c-9451-13e4-aa53-434d2d8ff8bf@huawei.com>
Date:   Mon, 29 Mar 2021 09:36:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested on x86 for 4.14.228-rc1,

Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.228-rc1
Commit: aaaf04029b8104334aff982c80c3b5659be1f192
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
