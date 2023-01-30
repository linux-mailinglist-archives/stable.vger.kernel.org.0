Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBC668174D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 18:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbjA3RKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 12:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbjA3RJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 12:09:59 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791C14109C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:09:58 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id k12so354277ilv.10
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D0NwTkchautTwr2b39Io8oodrygOmHFDn/d5ivG/ofE=;
        b=IbZSTyOzumgCwaGh9+gOtUafb9wtJruo+OSMMousEq/WYpP7T0K4AzaxxeDJNvPgEw
         fllUmTju0J0bFbRsQRFV2oTIlltQYtI/daPtMOVtq0SnyxWBT4A2LHrjDMVemIfOcZfw
         wWlNz5NCKoRqRyAx2OOnh2UEj4yvrRXKVKR+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0NwTkchautTwr2b39Io8oodrygOmHFDn/d5ivG/ofE=;
        b=cFcBeT8FPde7us/1zjdtIKmpm5Y/7pxfXoIeNYL5XyDyMzHkEvbpubFhb2gH1jNaRD
         mF910PMKs1XAmCQm10ZyWKw8fVo7NZM8NjHyAmY16bbZacYbDF4TMTEWIfja5R2WZCsX
         IONN0QbSUXPNxgBrzwq8v8mRbkWq0U5KBBpobz2gp001TeVG6VhyJKDESebLAtM9ngCs
         DH3Ad6qgIOZSNEKRblGmy65AAGWYDj1AxwaDDCxt/otiQH3fuiVvlz57FZpf8mpkkB82
         PFOTrwhQX5OtKjLbhbmVU6urIsuWmElBFHxAR0eWAT8qnk8z1O/k4kfMCnktb0lHI8Co
         CzHw==
X-Gm-Message-State: AO0yUKUtinqlD69HORGfhBizh4ThzWmq0akzQnRlcUs20TtWrabWX8aQ
        6geH92v2jsvP3AfwT5tnRoiDLRkx/Jkh+OZL
X-Google-Smtp-Source: AK7set+Ka13TT616pYhAC6agDWa038VNKK0nbrDwsXNkOBLBm9pJSvboUARiJD/s2Nd4khZm7Kg4fA==
X-Received: by 2002:a05:6e02:1a46:b0:310:ecea:b488 with SMTP id u6-20020a056e021a4600b00310eceab488mr1021838ilv.3.1675098597745;
        Mon, 30 Jan 2023 09:09:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h19-20020a056638339300b003a2a167e7d9sm4392002jav.96.2023.01.30.09.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 09:09:57 -0800 (PST)
Message-ID: <a56e460e-f8f5-97e6-f469-9ae44b0eedc2@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 10:09:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 02/34] selftests: bpf: Fix incorrect kernel headers search
 path
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-3-mathieu.desnoyers@efficios.com>
 <4defb04e-ddcb-b344-6e9f-35023dee0d2a@linuxfoundation.org>
 <CAADnVQ+1hB-1B_-2LrYC3XvMiEyA2yZv9fz51dDrMABG3dsQ_g@mail.gmail.com>
 <7023e3f3-bfd3-5842-5624-b1fd21576591@efficios.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <7023e3f3-bfd3-5842-5624-b1fd21576591@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 10:00, Mathieu Desnoyers wrote:
> On 2023-01-30 11:26, Alexei Starovoitov wrote:
>> On Mon, Jan 30, 2023 at 8:12 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>>
>>> On 1/27/23 06:57, Mathieu Desnoyers wrote:
>>>> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
>>>> building against kernel headers from the build environment in scenarios
>>>> where kernel headers are installed into a specific output directory
>>>> (O=...).
>>>>
>>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>> Cc: linux-kselftest@vger.kernel.org
>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>> Cc: <stable@vger.kernel.org>    [5.18+]
>>>> ---
>>>>    tools/testing/selftests/bpf/Makefile | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>>> index c22c43bbee19..6998c816afef 100644
>>>> --- a/tools/testing/selftests/bpf/Makefile
>>>> +++ b/tools/testing/selftests/bpf/Makefile
>>>> @@ -327,7 +327,7 @@ endif
>>>>    CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
>>>>    BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)               \
>>>>             -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)                   \
>>>> -          -I$(abspath $(OUTPUT)/../usr/include)
>>>> +          $(KHDR_INCLUDES)
>>>>
>>>>    CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
>>>>               -Wno-compare-distinct-pointer-types
>>>
>>>
>>>
>>> Adding bpf maintainers - bpf patches usually go through bpf tree.
>>>
>>> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>> Please resubmit as separate patch with [PATCH bpf-next] subj
>> and cc bpf@vger, so that BPF CI can test it on various architectures
>> and config combinations.
> 
> Hi Shuah,
> 
> Do you have means to resubmit it on your end, or should I do it ?
> 

Hi Mathieu,

Please go ahead and resubmit.

thanks,
-- Shuah

