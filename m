Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6168E34C12D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 03:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhC2BgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 21:36:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14503 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhC2BgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 21:36:00 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F7w8f5RYjzwPF0;
        Mon, 29 Mar 2021 09:33:54 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:35:53 +0800
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Subject: [linux-stable-rc CI] Test report for 4.19.184-rc1
Message-ID: <e5e3d2a9-b786-d173-8315-622c44f4bcc4@huawei.com>
Date:   Mon, 29 Mar 2021 09:35:53 +0800
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

Tested on arm64 and x86 for 4.19.184-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.184-rc1
Commit: a28c71697fc5a68a07fa87c1b5917bf04913a1ec
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4679
passed: 4679
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4679
passed: 4679
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
