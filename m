Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC270681705
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjA3Qze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbjA3Qzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:55:33 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAED23E606
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:55:19 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id i6so1499313ilq.8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nC/IV5CSikVcFD92Ww8OR9pedo65XnElLOKkh2lDSp8=;
        b=EHkFqV3iePUrdFJk+fd5HxzSdFP+ViOLp9utC0CH9jBShd9a3QJsA+m3h/EMXlr6fI
         xB2YVghIBYvVi++IkF2FZbRWuqKKow+76V+AodNu0jJjWa4ptVcQvSuF+aOwYtTsuaXh
         D1eKiXxHoUA2eOWD+NGa0EnhhgnpfkjPZ4yPM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nC/IV5CSikVcFD92Ww8OR9pedo65XnElLOKkh2lDSp8=;
        b=bWpYFYYddaZ0mx1IY4mt9M6EqEb9Q5LAo3Po94EdEaF2GygCxqh+fm1tI7SFIBbyIx
         36PfV6qUMXX/rwy8WQ8DrqU8264/XYqR61kfbEBw0y7zn/CJA5oW4kj+bMB6MUM4Oug1
         tvhwC+9uwQjZ3EHUNWHHrLODu9Hf39DXWr9DFMvV0Ex1bzdy5QxslhhvyutzQeVfAUkz
         015gdpZjc7o8SekvH9UpQ2k6OHO968t0BXxlzD1Tjxvx4ovU4hfsEBE1r2zGdKiWV3ne
         c3L5aw9LMhBEZsf3EfuUlJul/NyqsnogvcHMjn6M6zuC6JDVOPNxhs2+VdvF/fcBaLaJ
         pQ/Q==
X-Gm-Message-State: AO0yUKVWmhEcywhjBbyNGzgCQ8FxURIN7/0KLI/xj48QP0HpoGClMbFH
        B7rZOJMYnmeL6oKdGQZnVMvSKA==
X-Google-Smtp-Source: AK7set8SdkBgwun/6MfApAU2iUlrWyH9MBGt2VrxM3BeLRuNtu0BLzGYDEJKLzgLW8tYvKoVz+v4VA==
X-Received: by 2002:a05:6e02:12e1:b0:310:ff8c:6844 with SMTP id l1-20020a056e0212e100b00310ff8c6844mr313978iln.2.1675097719102;
        Mon, 30 Jan 2023 08:55:19 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l17-20020a026a11000000b003a951542b10sm4909428jac.60.2023.01.30.08.55.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:55:18 -0800 (PST)
Message-ID: <63cf4999-5dbe-a191-8367-b2a359cfd024@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 09:55:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 28/34] selftests: vm: Fix incorrect kernel headers search
 path
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-29-mathieu.desnoyers@efficios.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230127135755.79929-29-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/23 06:57, Mathieu Desnoyers wrote:
> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> building against kernel headers from the build environment in scenarios
> where kernel headers are installed into a specific output directory
> (O=...).
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: <stable@vger.kernel.org>    [5.18+]
> ---
>   tools/testing/selftests/vm/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 89c14e41bd43..ac9366065fd2 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -25,7 +25,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/p
>   # LDLIBS.
>   MAKEFLAGS += --no-builtin-rules
>   
> -CFLAGS = -Wall -I $(top_srcdir) -I $(top_srcdir)/usr/include $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
> +CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
>   LDLIBS = -lrt -lpthread
>   TEST_GEN_FILES = cow
>   TEST_GEN_FILES += compaction_test

Adding mm maintainers.

Andrew,

Would you me to take this patch through kselftest tree? If you
decide to take this through yours:

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
