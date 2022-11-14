Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E156627518
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 04:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiKND76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Nov 2022 22:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbiKND75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Nov 2022 22:59:57 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434F811C16
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 19:59:56 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f3so2822605pgc.2
        for <stable@vger.kernel.org>; Sun, 13 Nov 2022 19:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQZZjpNqvZsbs1aZ+f9L6Zj8PA0ItCU0rBc0b1FARyw=;
        b=vdB5fAHXaRnl7hEGIoiRCjv4822lI+8QizRapf66BmUN2RvoLmk1izUL25FAw8x4c0
         Fg1r5WnIaf5BUQwu7KlU9RU+15lhg9x+V0K9tRRu6XunTvyOe2M+d9p0Z8UCfB+IjmFo
         6HgrdONadSO1rj4QGrvMn46maeMM1yZeED2aU8PhbJvHIo1pyk7Ggu4QDktXJlqbQ3zH
         GR3dlDfqu/90Dwu8sr159TzENYpVbOaHtEYQmJ7PVkmtlxE2QQbo6Mq1E2yM+i4kxQ4p
         2HyTY4R02QmKE+UbuWvcM2grft8OfjzohGFcD0oJs2HAifkoivRgDqMQbopDaKIVW7kS
         kYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQZZjpNqvZsbs1aZ+f9L6Zj8PA0ItCU0rBc0b1FARyw=;
        b=y1CA3Iimlrm8C2b8ijFMChEJtqTW2LtsKqCRFoxSBO3gFeMDTtWtA9EzAFDbgRDjP2
         pqTnqiOKQ4cQvqXrU5ZB5VTt0qO19AfVeFfQdioAJgV4+zbx/6ZCMdA6APonBCi/2R6d
         PNJ463U25CWBU5qvqDPsMoAz9WkwgspG5JAjsuCgehOjgfggZBuIHvhVLo/ViDsCk3fJ
         BlJcXyecLnYTw1YnBRpSk/w/7svAPNY87FpYK4rlwlsV/530K+Qjrt+4+INFL8TiQb9t
         RHCycvsNpvIhar8avbRLVMSrzn4xyugtWI8MJpiCsUseqB5fRMIEQDOmF/bjRc3tiLYo
         wQEg==
X-Gm-Message-State: ANoB5pnzk1QI1Omcgr9B2iUvAk1GUh+a/IjuT1u645AMGwX9b73/oYjZ
        ClQzsfDbyQPgD25+M6gf/AfcsQ==
X-Google-Smtp-Source: AA0mqf72JWncrSTFwDOEPs30Ny/aQyU6SBZ2m0gCMhNu13fXnwcY9AQ7OCeL8R/ZUFswDSD0+buZ2w==
X-Received: by 2002:a63:1d49:0:b0:476:898c:ded5 with SMTP id d9-20020a631d49000000b00476898cded5mr2276339pgm.299.1668398395776;
        Sun, 13 Nov 2022 19:59:55 -0800 (PST)
Received: from [10.254.69.19] ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id g3-20020a170902868300b00168dadc7354sm6061996plo.78.2022.11.13.19.59.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Nov 2022 19:59:55 -0800 (PST)
Message-ID: <039ce475-f935-e0c2-4734-1dd57519d961@bytedance.com>
Date:   Mon, 14 Nov 2022 11:59:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v2] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
To:     Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     dvyukov@google.com, jgg@nvidia.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <Y2kxrerISWIxQsFO@nvidia.com>
 <20221108035232.87180-1-zhengqi.arch@bytedance.com>
 <CAC5umygzc=H-9dCa_pLoqodS4Qz90OVmQkrvFOCPv27514tP3A@mail.gmail.com>
Content-Language: en-US
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <CAC5umygzc=H-9dCa_pLoqodS4Qz90OVmQkrvFOCPv27514tP3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/11/9 01:36, Akinobu Mita wrote:
> 2022年11月8日(火) 12:52 Qi Zheng <zhengqi.arch@bytedance.com>:
>>
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
> 
> Looks good.
> 
> Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>

Thanks. And hi Andrew, seems no action left for me, can this patch
be applied to mm-unstable tree for testing? :)

-- 
Thanks,
Qi
