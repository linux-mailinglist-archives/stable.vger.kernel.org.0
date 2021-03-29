Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B6134C130
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 03:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhC2Bgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 21:36:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15364 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhC2BgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 21:36:21 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F7w940kvXz93SR;
        Mon, 29 Mar 2021 09:34:16 +0800 (CST)
Received: from [10.174.178.100] (10.174.178.100) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:36:14 +0800
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Samuel Zou <zou_wei@huawei.com>
Subject: [linux-stable-rc CI] Test report for 5.4.109-rc1
Message-ID: <ae68b5d5-3c10-1fa3-400c-e2fb020085ae@huawei.com>
Date:   Mon, 29 Mar 2021 09:36:14 +0800
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

Tested on arm64 and x86 for 5.4.109-rc1,

Kernel repo:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-5.4.y
Version: 5.4.109-rc1
Commit: f6e98ecf34303bfe946414761781ffcaf5b0f630
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
