Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1469DB6A
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 08:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjBUHqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 02:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjBUHqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 02:46:32 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE821A66E
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 23:46:30 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PLWWM34mCznWNm;
        Tue, 21 Feb 2023 15:43:59 +0800 (CST)
Received: from [10.174.179.234] (10.174.179.234) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 21 Feb 2023 15:46:27 +0800
Message-ID: <e2fea1a1-982d-20c8-d92c-bc4ed4d1d711@huawei.com>
Date:   Tue, 21 Feb 2023 15:46:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Consultation on backport 97e3d26b5e5f("x86/mm: Randomize per-cpu
 entry area") to stable
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <peterz@infradead.org>, <keescook@chromium.org>,
        <sethjenkins@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, <bp@suse.de>,
        <stable@vger.kernel.org>, <tongtiangen@huawei.com>
References: <2b814e48-d304-e48a-e4b4-c39a10d2dbf4@huawei.com>
 <Y/RzDvXr/iGpHl+f@kroah.com>
From:   Tong Tiangen <tongtiangen@huawei.com>
In-Reply-To: <Y/RzDvXr/iGpHl+f@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.234]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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



在 2023/2/21 15:30, Greg KH 写道:
> On Tue, Feb 21, 2023 at 03:19:05PM +0800, Tong Tiangen wrote:
>> Hi peter:
>>
>> Do you have any plans to backport this patch[1] to the stable branch of the
>> lower version, such as 4.19.y ?
> 
> Why?  That is a new feature for 6.2 why would it be needed to fix
> anything in really old kernels?

Hi Greg:

This patch fix CVE-2023-0597[1], this CVE report a flaw possibility of 
memory leak. And this is important for some products using this stable 
version.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=2165926

> 
>> When I try to backport this patch to 5.10.y, I met some KASAN[2] and
>> KASLR[3] related issues. Although they were finally solved, there were still
>> some detours in the process.
> 
> Send your series of backports to the list for review please if they
> match the stable kernel rules.

OK.

> 
> But why can't you just use the 6.2 kernel instead of something obsolete
> like 4.19?
> 
> thanks,
> 
> greg k-h
> .

Thanks.
Tong
.
