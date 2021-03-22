Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD96343658
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 02:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhCVBiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Mar 2021 21:38:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14115 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVBhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Mar 2021 21:37:54 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F3cX93krMz19GB8;
        Mon, 22 Mar 2021 09:35:53 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 09:37:43 +0800
Subject: [linux-stable-rc CI] Test report for 4.14.226/x86
References: <87407c63-cff0-433c-99ad-12d894b0cb84@DGGEMS410-HUB.china.huawei.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
X-Forwarded-Message-Id: <87407c63-cff0-433c-99ad-12d894b0cb84@DGGEMS410-HUB.china.huawei.com>
Message-ID: <92a1a310-362f-512c-c82e-30b587e14b57@huawei.com>
Date:   Mon, 22 Mar 2021 09:37:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87407c63-cff0-433c-99ad-12d894b0cb84@DGGEMS410-HUB.china.huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.100]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Kernel repo: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Arch: x86
Version: 4.14.226
Commit: cb83ddcd5332fcc3efd52ba994976efc4dd6061e
Compiler: gcc version 7.3.0 (GCC)
--------------------------------------------------------------------
All testcases PASSED.
--------------------------------------------------------------------
Testcase Result Summary:
total: 4676
passed: 4676
failed: 0
timeout: 0
--------------------------------------------------------------------
Tested-by: Hulk Robot <hulkrobot@huawei.com>
