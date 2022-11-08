Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E32620BA1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 09:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiKHI6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 03:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiKHI6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 03:58:18 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803492F646
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 00:58:17 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so17288102pjc.3
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 00:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R6zHKniDXHG6psc3MbF8qS0f79e5oPRG+XQe4V39iSs=;
        b=jS3wKBZTZZjWrd+5/yh1fiJS8luDkuQZXwWeJsuFlhHPl01Cvyz5APoOukAAgI5lxs
         DkuHUcU++n7RPoCR5ixF17Im6S/TU67bUB+ba16tg6x/NoNaOTJ1SB31OKfd2PYfxJxX
         StTJ82K9eSLLCd3Zi4k04h9KiqqqZP4IfuOuiyGsu+MUaid2q6g0+c4mp+GJ44jcPi6d
         TraPOjlIKGIttFjOk5l+4uO3IyflnI/bZZRxUAplwf5M3iRBdYyIzZXOmrKXxS5kByne
         2icF1Hr+B+aXrBoF3AuPwMePm8XLFYRovOQACqLd1rDjzjyirYzLyhXhWl73y0fX72nu
         qAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6zHKniDXHG6psc3MbF8qS0f79e5oPRG+XQe4V39iSs=;
        b=3HvfFsbVwlYvhQbFzOYH8GmsY/065Bw0xRxuABL7v8X8v30iONFL0oBUyMpiDlkY9f
         D2D80OVZqt0J9I2CaCTt84hrSfdxlhiOvtOXa8qeL/EDgV7GPeg2DetVsQsG3noC6AAD
         M7fgVYqNVhfevukVFwyRSI/iLp/Op1aGqOhJsW+8NnEn7f/MTZ6nljT0SQKx4ikdgx3v
         J4rbortSq0F4ppxrEJXJdO3PnJAOukdqm0oBN7OFe8piBUfTgxmaDE6lOJbX443miwDc
         uIbn7tTRPgHY7c4qDj+8oovJMXTUvKsq5KMDraNv7bbQpHzUDUvaST1TbNi/OoFYUysp
         2nRw==
X-Gm-Message-State: ACrzQf0ss+9xrIBO9EX4066i9cSW8lTt6yP023ZY1QBFLxN31id9Uufv
        k3n6bVUHpyPq74KqWefC65vvJw==
X-Google-Smtp-Source: AMsMyM6r+usVnhZ3DbQ0cit9SiOGzAR3uWWMZHRWXcqL1ZL/jpn3eb4zm7GKPG327wPwDjQuXvKb6g==
X-Received: by 2002:a17:90b:3504:b0:214:199e:7e6d with SMTP id ls4-20020a17090b350400b00214199e7e6dmr38032578pjb.192.1667897896983;
        Tue, 08 Nov 2022 00:58:16 -0800 (PST)
Received: from [10.255.93.192] ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id k21-20020a628415000000b0056bb06ce1cfsm6044022pfd.97.2022.11.08.00.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 00:58:16 -0800 (PST)
Message-ID: <70dfbac1-4c84-9567-30be-1e2594157e62@bytedance.com>
Date:   Tue, 8 Nov 2022 16:58:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.3
Subject: Re: [PATCH v2] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Content-Language: en-US
To:     Wei Yongjun <weiyongjun1@huawei.com>, dvyukov@google.com,
        jgg@nvidia.com, willy@infradead.org, akinobu.mita@gmail.com
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
References: <Y2kxrerISWIxQsFO@nvidia.com>
 <20221108035232.87180-1-zhengqi.arch@bytedance.com>
 <65863340-b32f-a2fe-67ae-f1079b19eee4@huawei.com>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <65863340-b32f-a2fe-67ae-f1079b19eee4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/11/8 16:44, Wei Yongjun wrote:
> Hi Zheng Qi,
> 
> On 2022/11/8 11:52, Qi Zheng wrote:
>> When we specify __GFP_NOWARN, we only expect that no warnings
>> will be issued for current caller. But in the __should_failslab()
>> and __should_fail_alloc_page(), the local GFP flags alter the
>> global {failslab|fail_page_alloc}.attr, which is persistent and
>> shared by all tasks. This is not what we expected, let's fix it.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   v1: https://lore.kernel.org/lkml/20221107033109.59709-1-zhengqi.arch@bytedance.com/
>>
>>   Changelog in v1 -> v2:
>>    - add comment for __should_failslab() and __should_fail_alloc_page()
>>      (suggested by Jason)
>>
>>   include/linux/fault-inject.h |  7 +++++--
>>   lib/fault-inject.c           | 14 +++++++++-----
>>   mm/failslab.c                | 12 ++++++++++--
>>   mm/page_alloc.c              |  7 +++++--
>>   4 files changed, 29 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
>> index 9f6e25467844..444236dadcf0 100644
>> --- a/include/linux/fault-inject.h
>> +++ b/include/linux/fault-inject.h
>> @@ -20,7 +20,6 @@ struct fault_attr {
>>   	atomic_t space;
>>   	unsigned long verbose;
>>   	bool task_filter;
>> -	bool no_warn;
>>   	unsigned long stacktrace_depth;
>>   	unsigned long require_start;
>>   	unsigned long require_end;
>> @@ -32,6 +31,10 @@ struct fault_attr {
>>   	struct dentry *dname;
>>   };
>>   
>> +enum fault_flags {
>> +	FAULT_NOWARN =	1 << 0,
>> +};
>> +
>>   #define FAULT_ATTR_INITIALIZER {					\
>>   		.interval = 1,						\
>>   		.times = ATOMIC_INIT(1),				\
>> @@ -40,11 +43,11 @@ struct fault_attr {
>>   		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
>>   		.verbose = 2,						\
>>   		.dname = NULL,						\
>> -		.no_warn = false,					\
> 
> How about keep no_warn attr as it be, and export it to user?
> 
> When testing with fault injection, and each fault will print an backtrace.
> but not all of the testsuit can tell us which one is fault injection
> message or other is a real warning/crash like syzkaller do.
> 
> In my case, to make things simple, we usually used a regex to detect whether
> wanring/error happend. So we disabled the slab/page fault warning message by
> default, and only enable it when debug real issue.

So you want to set/clear this no_warn attr through the procfs or sysfs
interface, so that you can easily disable/enable the slab/page fault
warning message from the user mode. Right?

Seems reasonable to me. Anyone else has an opinion on this? If it is
really needed, I can do it later.

Thanks,
Qi

> 
> Regards,
> 
> 
>>   	}
>>   
>>   #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
>>   int setup_fault_attr(struct fault_attr *attr, char *str);
>> +bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags);
>>   bool should_fail(struct fault_attr *attr, ssize_t size);
>>   
>>   #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
>> diff --git a/lib/fault-inject.c b/lib/fault-inject.c
>> index 4b8fafce415c..5971f7c3e49e 100644
>> --- a/lib/fault-inject.c
>> +++ b/lib/fault-inject.c
>> @@ -41,9 +41,6 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
>>   
>>   static void fail_dump(struct fault_attr *attr)
>>   {
>> -	if (attr->no_warn)
>> -		return;
>> -
>>   	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
>>   		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
>>   		       "name %pd, interval %lu, probability %lu, "
>> @@ -103,7 +100,7 @@ static inline bool fail_stacktrace(struct fault_attr *attr)
>>    * http://www.nongnu.org/failmalloc/
>>    */
>>   
>> -bool should_fail(struct fault_attr *attr, ssize_t size)
>> +bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
>>   {
>>   	bool stack_checked = false;
>>   
>> @@ -152,13 +149,20 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
>>   		return false;
>>   
>>   fail:
>> -	fail_dump(attr);
>> +	if (!(flags & FAULT_NOWARN))
>> +		fail_dump(attr);
>>   
>>   	if (atomic_read(&attr->times) != -1)
>>   		atomic_dec_not_zero(&attr->times);
>>   
>>   	return true;
>>   }
>> +EXPORT_SYMBOL_GPL(should_fail_ex);
>> +
>> +bool should_fail(struct fault_attr *attr, ssize_t size)
>> +{
>> +	return should_fail_ex(attr, size, 0);
>> +}
>>   EXPORT_SYMBOL_GPL(should_fail);
>>   
>>   #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
>> diff --git a/mm/failslab.c b/mm/failslab.c
>> index 58df9789f1d2..ffc420c0e767 100644
>> --- a/mm/failslab.c
>> +++ b/mm/failslab.c
>> @@ -16,6 +16,8 @@ static struct {
>>   
>>   bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
>>   {
>> +	int flags = 0;
>> +
>>   	/* No fault-injection for bootstrap cache */
>>   	if (unlikely(s == kmem_cache))
>>   		return false;
>> @@ -30,10 +32,16 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
>>   	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
>>   		return false;
>>   
>> +	/*
>> +	 * In some cases, it expects to specify __GFP_NOWARN
>> +	 * to avoid printing any information(not just a warning),
>> +	 * thus avoiding deadlocks. See commit 6b9dbedbe349 for
>> +	 * details.
>> +	 */
>>   	if (gfpflags & __GFP_NOWARN)
>> -		failslab.attr.no_warn = true;
>> +		flags |= FAULT_NOWARN;
>>   
>> -	return should_fail(&failslab.attr, s->object_size);
>> +	return should_fail_ex(&failslab.attr, s->object_size, flags);
>>   }
>>   
>>   static int __init setup_failslab(char *str)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 7192ded44ad0..cb6fe715d983 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -3902,6 +3902,8 @@ __setup("fail_page_alloc=", setup_fail_page_alloc);
>>   
>>   static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
>>   {
>> +	int flags = 0;
>> +
>>   	if (order < fail_page_alloc.min_order)
>>   		return false;
>>   	if (gfp_mask & __GFP_NOFAIL)
>> @@ -3912,10 +3914,11 @@ static bool __should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
>>   			(gfp_mask & __GFP_DIRECT_RECLAIM))
>>   		return false;
>>   
>> +	/* See comment in __should_failslab() */
>>   	if (gfp_mask & __GFP_NOWARN)
>> -		fail_page_alloc.attr.no_warn = true;
>> +		flags |= FAULT_NOWARN;
>>   
>> -	return should_fail(&fail_page_alloc.attr, 1 << order);
>> +	return should_fail_ex(&fail_page_alloc.attr, 1 << order, flags);
>>   }
>>   
>>   #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS

-- 
Thanks,
Qi
