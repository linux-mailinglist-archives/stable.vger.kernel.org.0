Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E5B417838
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 18:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347300AbhIXQNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 12:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347289AbhIXQNA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 12:13:00 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB7AC061571;
        Fri, 24 Sep 2021 09:11:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so7874547pjb.5;
        Fri, 24 Sep 2021 09:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0YfQ2zBxgksg+2Nskeom4iZ9y4gZMYBwdBh+RnSeLrE=;
        b=D/UN2KRJLanA8Tv5NPi/h+nQS4a/S4wPewaIv94UADb1wZji1oiq48A4Y4Q93SxnLU
         AGBg8vBAhynuNwBXA5ttZW0qUBny5KFN8sNbQk9/omWPoO2RQRs+YcXxiWhn8XEr6293
         CI7vI+FYxUG/GJhRzfvgH1oZDBUTwmuxEwNEv/qdCxmy8oHxs2P19xwVJyyCcXzNDTGe
         lv4FzzLhiyrlEJ6TFavpBM7p06SPqgUXUlYTJMDvIj7iZwBo2olc5C2uB5hys4bqGBoE
         44WeDM+O8uv9N5p06sAS9Bh/u8wEWJ8pnJnLWXj8UimuzkP0m1i0+I7LnIcKYHjtFLSO
         DhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0YfQ2zBxgksg+2Nskeom4iZ9y4gZMYBwdBh+RnSeLrE=;
        b=Qk/uKjAp/M2OXFgLVl0lDL/R3rdEo/S0+56mk7LrdwO+9ZgmPkKcN0MeSMPV0ix4yn
         OYJJn8JeiTK1yDui1R3xkNBqgOldXTqG/7j+FhHRQfWe473MdKsGVPNawW1BiPrz2dgL
         sz/DfvJqsa/2qi0UeFu8aLB87ozqAPcbdsQrdmBBga/HxFPkXVihCgx4clb0eX/lBwB+
         Jpd9xPd79LtlkptCRFZdFyVAD5govP7P4rAlEWzWuOeqLaMfrUTm3pzpIQCTlqWPqKf0
         615iLETLGvQQANSQOyVD0FAs/lzhhq09MY8xTdYqwy/Ugapf3/1IyctM5bVUn/fF17wh
         9Ahg==
X-Gm-Message-State: AOAM533R9ubi14nS4KNMl/ADdiDsQSFRNN5gb2udi+S2v7QN1/QrG3Mr
        eJdVaNpFP1WMBW+tcOIJjOY=
X-Google-Smtp-Source: ABdhPJzrM/8wvP4Z2JYad3PsfXWq5EEyrAQmrfchjQltvkGtLcQZB3kT43/43GIE3okA9/+ng3XSUw==
X-Received: by 2002:a17:90a:300c:: with SMTP id g12mr3149919pjb.37.1632499886793;
        Fri, 24 Sep 2021 09:11:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 126sm11697724pgi.86.2021.09.24.09.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:11:26 -0700 (PDT)
Subject: Re: [PATCH stable 4.9 v2 0/4] ARM: ftrace MODULE_PLTS warning
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
References: <20210922170246.190499-1-f.fainelli@gmail.com>
 <YUxYV/m36iPuxdoe@kroah.com> <YU2769mOr3lb8jFi@sashalap>
 <bb9fde7d-3644-6d30-c238-73427ab200e6@nokia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <34ae79e3-f109-bc4b-341a-f05d95cf15e3@gmail.com>
Date:   Fri, 24 Sep 2021 09:11:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bb9fde7d-3644-6d30-c238-73427ab200e6@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/24/21 8:27 AM, Alexander Sverdlin wrote:
> Hi Sasha,
> 
> On 24/09/2021 13:52, Sasha Levin wrote:
>>>> This patch series is present in v5.14 and fixes warnings seen at insmod
>>>> with FTRACE and MODULE_PLTS enabled on ARM/Linux.
>>>
>>> All now queued up, thanks.
>>
>> Looks like 4.19 and older break the build:
>>
>> arch/arm/kernel/ftrace.c: In function 'ftrace_update_ftrace_func':
>> arch/arm/kernel/ftrace.c:157:9: error: too few arguments to function 'ftrace_call_replace'
>>   157 |   new = ftrace_call_replace(pc, (unsigned long)func);
>>       |         ^~~~~~~~~~~~~~~~~~~
> 
> in principle you can add ", true" as a third argument in all these ftrace_call_replace()
> call-sites which still have two args.

Sasha, what configuration failed to build? I build tested with
mutli_v7_defconfig which does enable FTRACE by default and then ensured
that CONFIG_ARM_MODULE_PLTS was enabled. From there I will re-submit,
sorry about that.

> 
>> arch/arm/kernel/ftrace.c:99:22: note: declared here
>>    99 | static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
>>       |                      ^~~~~~~~~~~~~~~~~~~
>> arch/arm/kernel/ftrace.c: In function 'ftrace_make_nop':
>> arch/arm/kernel/ftrace.c:240:9: error: too few arguments to function 'ftrace_call_replace'
>>   240 |   old = ftrace_call_replace(ip, adjust_address(rec, addr));
>>       |         ^~~~~~~~~~~~~~~~~~~
>> arch/arm/kernel/ftrace.c:99:22: note: declared here
>>    99 | static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
>>       |                      ^~~~~~~~~~~~~~~~~~~
>> make[2]: *** [scripts/Makefile.build:303: arch/arm/kernel/ftrace.o] Error 1
>>
>> I've dropped them.
> 


-- 
Florian
