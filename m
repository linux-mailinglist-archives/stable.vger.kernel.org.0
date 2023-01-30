Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1C36816E7
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237777AbjA3QvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbjA3QvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:51:22 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2877B3D93C
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:51:14 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id i17so5200374ils.11
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:51:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L4+NGVtQcxQHnP5AnyWUVuA7rVFG+isSqEi52ETwsuU=;
        b=B5T2nwTCHfcs88l2bKIgSjjRUGjb/i+ybCHRbsjSPwdB8KvsLaz3O0Lijw+hVQuA6o
         AAwidKzyQBCoNKDPjw7zhgmYCsnvZsh0BBOS426a9b/eL4lENjVccPEiHB5eM1+nvdBe
         kSxVb5aBvv+pnRxK0R2OXPjhV299l2x1zXVQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L4+NGVtQcxQHnP5AnyWUVuA7rVFG+isSqEi52ETwsuU=;
        b=G3PaqnztxUMdE4n+KQxt+slleCbzkO6DrUlVyQHjDwsP/yABow9vNWOpo7bf3KAjOT
         olOMuat9sICJDKWjnPa5QCTZFd0QJueSB4461038C64L8CP1grefEHa/G/pK4ahx0C42
         QBGSpUohDIYfApJPR+u/49nYnX2S0nSZJ3bKX2eo2rTMbIgXf3MVtsFzwY9Z+i5poqf6
         d+c4VYjUTwJEN1hXfF1Nxz5+uXHae5Bfneit6Vg7j1bb+W1sW3lniP4WIPgAerhBXR5w
         MfAK7EkTl42jcDClacK9KE3Hs3aoah5hDSI+GMh2RnPzL1gqvNLtEMRxyxuszoxaVytS
         lC0A==
X-Gm-Message-State: AO0yUKXSSKFuCoWhHDu7ieLajo7ZZ5+/pilpIBjWGPkbzSsfvs26HmHs
        Ws7qzg7ml2HsB0WnhiHNTp/RKQ==
X-Google-Smtp-Source: AK7set8KQL/sK8y39rETcNiJ+KPIoI2Qi/10KmCTmE2Vx17U8Sdq0cTtfHgBqRQpobshNQ95ti9gwA==
X-Received: by 2002:a05:6e02:12e1:b0:310:ff8c:6844 with SMTP id l1-20020a056e0212e100b00310ff8c6844mr312128iln.2.1675097473487;
        Mon, 30 Jan 2023 08:51:13 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c1-20020a92bd01000000b0030f5796e89fsm4076969ile.48.2023.01.30.08.51.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:51:12 -0800 (PST)
Message-ID: <5283d88f-624a-b6a0-d89b-64eda6f33770@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 09:51:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 26/34] selftests: sync: Fix incorrect kernel headers
 search path
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-27-mathieu.desnoyers@efficios.com>
 <1a1b86bc-10e4-bcb9-66dd-3aa599ecadc3@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <1a1b86bc-10e4-bcb9-66dd-3aa599ecadc3@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 09:44, Shuah Khan wrote:
> On 1/27/23 06:57, Mathieu Desnoyers wrote:
>> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
>> building against kernel headers from the build environment in scenarios
>> where kernel headers are installed into a specific output directory
>> (O=...).
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: linux-kselftest@vger.kernel.org
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: <stable@vger.kernel.org>    [5.18+]
>> ---
>>   tools/testing/selftests/sync/Makefile | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/sync/Makefile b/tools/testing/selftests/sync/Makefile
>> index d0121a8a3523..df0f91bf6890 100644
>> --- a/tools/testing/selftests/sync/Makefile
>> +++ b/tools/testing/selftests/sync/Makefile
>> @@ -1,6 +1,6 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>   CFLAGS += -O2 -g -std=gnu89 -pthread -Wall -Wextra
>> -CFLAGS += -I../../../../usr/include/
>> +CFLAGS += $(KHDR_INCLUDES)
>>   LDFLAGS += -pthread
>>   .PHONY: all clean
> 
> Adding seccomp maintainers:
> 
> kees,
> 
> I plan to take this through kselftest unless there are conflicts.
> In case there are conflicts and you want to take this through yours
> 
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> 
Sorry wrong message. I am taking this one through mine.

-- Shuah

