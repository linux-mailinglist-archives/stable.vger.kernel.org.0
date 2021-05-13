Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A123B37F4CF
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 11:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhEMJ2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 05:28:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2585 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhEMJ2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 05:28:44 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FgmTD09DvzsRFd;
        Thu, 13 May 2021 17:24:48 +0800 (CST)
Received: from [10.174.178.208] (10.174.178.208) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 17:27:27 +0800
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Subject: [linux-stable-rc CI] Test report for 4.14.233-rc1/x86
Message-ID: <8271104d-0569-014a-63fe-02881cd45ca2@huawei.com>
Date:   Thu, 13 May 2021 17:27:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested on x86 for 4.14.232-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.14.y
Version: 4.14.233-rc1
Commit: db409d166f5c0d520b50b72ad028624690915768
Compiler: gcc version 7.3.0 (GCC)

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8423
passed: 8423
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
