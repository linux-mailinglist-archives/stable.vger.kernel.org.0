Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EFC34C12F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 03:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC2Bgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 21:36:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14939 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhC2Bgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 21:36:41 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F7w9v21MtzkgGr;
        Mon, 29 Mar 2021 09:34:59 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:36:36 +0800
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Subject: [linux-stable-rc CI] Test report for 5.10.27-rc1
Message-ID: <fb27410d-39e1-6bc1-d93e-0737d288318e@huawei.com>
Date:   Mon, 29 Mar 2021 09:36:36 +0800
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

Tested on arm64 and x86 for 5.10.27-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.10.y
Version: 5.10.27-rc1
Commit: fa9a491e09c628b42367904679b934b54a3809b8
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4720
passed: 4720
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 4720
passed: 4720
failed: 0
timeout: 0
--------------------------------------------------------------------

Tested-by: Hulk Robot <hulkrobot@huawei.com>
