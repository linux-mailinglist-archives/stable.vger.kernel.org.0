Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F74681778
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 18:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbjA3RU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 12:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbjA3RUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 12:20:54 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87C40BDD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:20:51 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id w13so1318678ilv.3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 09:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nYvSu7sGuVp3fcdCEzQKaHTtWhvrpcM/e6lnGhHfApc=;
        b=MDVN9oP8sf9ZdDdDxbmGir/VnoyUkLtqHvPfe/G9K0P1gzsh0nGJVbEuasy3HpfFIl
         G8M5/D/uV4aDj4Dbuc1D3WGTW29WO2bjLq3sP2mqZ6muyAMe0OvPIAWysFHoULw+8rmW
         Mk0sc/HuDPV6u4Kg+1Qnt2Z91OAElxNUzvW9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYvSu7sGuVp3fcdCEzQKaHTtWhvrpcM/e6lnGhHfApc=;
        b=0u5GigIeJEb0tIw4Ap/mAKU0q8LelO5nlrS4vrcZeIaiqoYgpL7sFMRKFdaW6xFxv7
         ztBJkEvXSY5yZbgH+JOsDiv6T8RzQsXKH9SZqjOL4+BLy0bft3ZSDVYLHzlAhg5kEQOD
         hC7KQn68exHI/ZQcy0ZC/TJFGBVtbfUCiw0jGWR+Sphnzepo84qEPlDggqIN4Cg9aLaM
         pPCiypJJsXkBHL8brWtIbQrAYKik6RffLBMw7lHWvHI7FNpoLj6BMd4vQglQ85nVyC3o
         PBjRNW97tG3BFLUb+j5ROwihNPLiOC26zP+UfhSt8/++9fIvXhR3TOXABnRIL6GkforQ
         q+/g==
X-Gm-Message-State: AO0yUKX6XcAJtNlA5hTRtfMBjk+EyX7hhRDV57fV7i0UVJvLKa2s3pHQ
        x1xWOl+hTDwxdZ7JBIxkDV57vA==
X-Google-Smtp-Source: AK7set/cmm0UJmfb8skPehugWvQCe1zkBRJzPEXUguu8cgjJZ0vsH8TB3fLulqfgPzS3PF4wocMzmw==
X-Received: by 2002:a92:6810:0:b0:310:9adc:e1bb with SMTP id d16-20020a926810000000b003109adce1bbmr3088730ilc.0.1675099250431;
        Mon, 30 Jan 2023 09:20:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t5-20020a028785000000b003a7cd65b280sm4851453jai.92.2023.01.30.09.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 09:20:49 -0800 (PST)
Message-ID: <25c240be-2291-9e4a-a32e-a16a8e2d9c6f@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 10:20:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 01/34] selftests: arm64: Fix incorrect kernel headers
 search path
Content-Language: en-US
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-2-mathieu.desnoyers@efficios.com>
 <d44aa330-5767-58e0-77af-c6541252040b@linuxfoundation.org>
 <Y9f6+jkfE+zRWR+Z@arm.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <Y9f6+jkfE+zRWR+Z@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 10:14, Catalin Marinas wrote:
> Hi Shuah,
> 
> On Mon, Jan 30, 2023 at 09:09:42AM -0700, Shuah Khan wrote:
>> On 1/27/23 06:57, Mathieu Desnoyers wrote:
>>> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
>>> building against kernel headers from the build environment in scenarios
>>> where kernel headers are installed into a specific output directory
>>> (O=...).
>>>
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>> Cc: Shuah Khan <shuah@kernel.org>
>>> Cc: linux-kselftest@vger.kernel.org
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: <stable@vger.kernel.org>    [5.18+]
>>> ---
>>>    tools/testing/selftests/arm64/fp/Makefile   | 2 +-
>>>    tools/testing/selftests/arm64/tags/Makefile | 2 +-
>>>    2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>
>> Adding arm maintainers.
>>
>> Would you me to take this patch through kselftest tree? If you
>> decide to take this through yours:
> 
> Are you taking the whole series? If yes:
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> (otherwise I can pick this up)
> 

I am taking several patches in the series with an exception
when maintainers want to take them through theirs.

I will apply to mine and take this through.

thanks,
-- Shuah
