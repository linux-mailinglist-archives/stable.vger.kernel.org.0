Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EFB69DB10
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 08:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjBUHTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 02:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbjBUHTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 02:19:12 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3856180
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 23:19:10 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PLVvp1cQmz16NlY;
        Tue, 21 Feb 2023 15:16:38 +0800 (CST)
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 21 Feb 2023 15:19:05 +0800
Message-ID: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
Date:   Tue, 21 Feb 2023 15:19:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To:     <peterz@infradead.org>
From:   Tong Tiangen <tongtiangen@huawei.com>
Subject: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
CC:     <keescook@chromium.org>, <sethjenkins@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, <bp@suse.de>,
        <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi peter:

Do you have any plans to backport this patch[1] to the stable branch of 
the lower version, such as 4.19.y ?
When I try to backport this patch to 5.10.y, I met some KASAN[2] and 
KASLR[3] related issues. Although they were finally solved, there were 
still some detours in the process.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=97e3d26b5e5f371b3ee223d94dd123e6c442ba80
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3f148f3318140035e87decc1214795ff0755757b
[3]

Best Regards,
Tong

.
