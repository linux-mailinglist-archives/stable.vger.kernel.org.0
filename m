Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF6369DB1C
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 08:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjBUHYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 02:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbjBUHYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 02:24:00 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0807EFC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 23:23:58 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PLW23460bzKpw9;
        Tue, 21 Feb 2023 15:22:03 +0800 (CST)
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 21 Feb 2023 15:23:55 +0800
Message-ID: <5dab5032-3dec-19a6-b03f-0e5139d8ba98@huawei.com>
Date:   Tue, 21 Feb 2023 15:23:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
From:   Tong Tiangen <tongtiangen@huawei.com>
To:     <peterz@infradead.org>
CC:     <keescook@chromium.org>, <sethjenkins@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, <bp@suse.de>,
        <stable@vger.kernel.org>, <tongtiangen@huawei.com>
References: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
In-Reply-To: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My fault, the third patch link is missing:)

[3] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d4150779e60fb6c49be25572596b2cdfc5d46a09

Best Regards,
Tong

.

在 2023/2/21 15:19, Tong Tiangen 写道:
> Hi peter:
> 
> Do you have any plans to backport this patch[1] to the stable branch of 
> the lower version, such as 4.19.y ?
> When I try to backport this patch to 5.10.y, I met some KASAN[2] and 
> KASLR[3] related issues. Although they were finally solved, there were 
> still some detours in the process.
> 
> [1] 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=97e3d26b5e5f371b3ee223d94dd123e6c442ba80 
> 
> [2] 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3f148f3318140035e87decc1214795ff0755757b 
> 
> [3]
> 
> Best Regards,
> Tong
> 
> .
