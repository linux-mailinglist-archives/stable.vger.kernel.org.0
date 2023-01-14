Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0868C66AD66
	for <lists+stable@lfdr.de>; Sat, 14 Jan 2023 20:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjANTen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Jan 2023 14:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjANTem (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Jan 2023 14:34:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5270E93D6
        for <stable@vger.kernel.org>; Sat, 14 Jan 2023 11:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673724831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HA/97dyjvw31mI9hZ1vmlWUVLwk2nGxoZ9JgulwBbro=;
        b=TnpSaypPBh6yJo6KbhuhObJs6eIzAx550aVWHIYVMlaIH5iVM9HG6IC55Tn4gOIatLrctO
        pAaGECetW3LMflvrgT3f4njpIqhbSMWibMHGv6iT9ZZbQHKdEwCxQXWr36RcWUvKkLsvAQ
        8jtTGInuw2FG+6GI/7x9+chcaNMxRi4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-5e0boFmoM0uaDPXwAqfY1A-1; Sat, 14 Jan 2023 14:33:47 -0500
X-MC-Unique: 5e0boFmoM0uaDPXwAqfY1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB22C1C05B10;
        Sat, 14 Jan 2023 19:33:46 +0000 (UTC)
Received: from [10.22.32.40] (unknown [10.22.32.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4DB7C15BA0;
        Sat, 14 Jan 2023 19:33:46 +0000 (UTC)
Message-ID: <881dc653-a6b4-6fea-542d-e06d79d011e5@redhat.com>
Date:   Sat, 14 Jan 2023 14:33:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: FAILED: patch "[PATCH] sched/core: Fix use-after-free bug in
 dup_user_cpus_ptr()" failed to apply to 6.1-stable tree
Content-Language: en-US
From:   Waiman Long <longman@redhat.com>
To:     gregkh@linuxfoundation.org, mingo@kernel.org, peterz@infradead.org,
        wangbiao3@xiaomi.com
Cc:     stable@vger.kernel.org
References: <167368999799102@kroah.com>
 <fea9d850-4942-3457-0e14-573763e891a4@redhat.com>
In-Reply-To: <fea9d850-4942-3457-0e14-573763e891a4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/14/23 14:28, Waiman Long wrote:
> On 1/14/23 04:53, gregkh@linuxfoundation.org wrote:
>> The patch below does not apply to the 6.1-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> Possible dependencies:
>>
>> 87ca4f9efbd7 ("sched/core: Fix use-after-free bug in 
>> dup_user_cpus_ptr()")
>> 8f9ea86fdf99 ("sched: Always preserve the user requested cpumask")
>> 713a2e21a513 ("sched: Introduce affinity_context")
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>>  From 87ca4f9efbd7cc649ff43b87970888f2812945b8 Mon Sep 17 00:00:00 2001
>> From: Waiman Long <longman@redhat.com>
>> Date: Fri, 30 Dec 2022 23:11:19 -0500
>> Subject: [PATCH] sched/core: Fix use-after-free bug in 
>> dup_user_cpus_ptr()
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>>
>> Since commit 07ec77a1d4e8 ("sched: Allow task CPU affinity to be
>> restricted on asymmetric systems"), the setting and clearing of
>> user_cpus_ptr are done under pi_lock for arm64 architecture. However,
>> dup_user_cpus_ptr() accesses user_cpus_ptr without any lock
>> protection. Since sched_setaffinity() can be invoked from another
>> process, the process being modified may be undergoing fork() at
>> the same time.  When racing with the clearing of user_cpus_ptr in
>> __set_cpus_allowed_ptr_locked(), it can lead to user-after-free and
>> possibly double-free in arm64 kernel.
>>
>> Commit 8f9ea86fdf99 ("sched: Always preserve the user requested
>> cpumask") fixes this problem as user_cpus_ptr, once set, will never
>> be cleared in a task's lifetime. However, this bug was re-introduced
>> in commit 851a723e45d1 ("sched: Always clear user_cpus_ptr in
>> do_set_cpus_allowed()") which allows the clearing of user_cpus_ptr in
>> do_set_cpus_allowed(). This time, it will affect all arches.
>>
>> Fix this bug by always clearing the user_cpus_ptr of the newly
>> cloned/forked task before the copying process starts and check the
>> user_cpus_ptr state of the source task under pi_lock.
>>
>> Note to stable, this patch won't be applicable to stable releases.
>> Just copy the new dup_user_cpus_ptr() function over.
>
> I have a note here about what to do when backporting to stable. Just 
> copy the new function over will be fine.

That will be before the application of the subsequent patch which will 
modify it in a way for suitable for stable. I can send out a separate 
stable patch for that later today.

Cheers,
Longman

