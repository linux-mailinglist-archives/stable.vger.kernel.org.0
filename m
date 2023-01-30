Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB466816BC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbjA3Qod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbjA3Qoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:44:32 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946CEEC59
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:44:31 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id d10so5331736ilc.12
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TP2FA9iVMVG7/uMbkVvWEbyziyRGtaH4gEIa9aqoO6M=;
        b=WmxTjqEvz6RHfM+FNxsU5RBZ+krkXdzQanA37TRAQ61CoeYNZGN1TLNGZzFkjzjijt
         wfNGM1gdkkQjpyBrjRwpFPjY63qP/EFazAb3LtRBupwzSRb7o5+Gu2isjlAvyPq5px1h
         ysPRnt/IRowx6BGAwfr9PTKVfffkpkwHX1ZXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TP2FA9iVMVG7/uMbkVvWEbyziyRGtaH4gEIa9aqoO6M=;
        b=0ymBHROivJ5rD83qvHvAIZ454KrzZAnEP85WsS7J2ufdjppD9ZSc1ZAB7KMlajBFY8
         U8fackZyMOs2Pu99uMGkUqtILDR1xLixGGhC0ODnqwhSPcHbBb7bJTwTEdXYt2pxZ7xu
         /EYY9JBnvdDAMlojay7spMO+2GKdpfDShYqW/xR2hKVAHFW5l7xAvQAdCP99HsQs+1Ig
         YmJ4Dd7m3SvgS4emkpUQHkRFkhJYjj/71sKgBYTJgchAh77//xrvbPz3Aaqb4cUCnYhj
         X/DdjXt2vDFn4T0rKjwrORqr/uXR23DHMX+TNsAlluV0ExsaCRIQrHHavUDi8TSSssRv
         KIbA==
X-Gm-Message-State: AO0yUKXudJW2nlgnTg5QITNSEcO18zBikv2cfn+YHgx2nUI6lNvxgM68
        cuXCk4ykR0yB/dtrWwJjboukyw==
X-Google-Smtp-Source: AK7set+K/RkA4gMwXUEvq3WwX+LvCyjoutxOC3teKcL+JdCGNVlAzyhiJyJbhalYWU3RJeG23o8Gpg==
X-Received: by 2002:a05:6e02:1a46:b0:310:ecea:b488 with SMTP id u6-20020a056e021a4600b00310eceab488mr1007591ilv.3.1675097070968;
        Mon, 30 Jan 2023 08:44:30 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x7-20020a923007000000b003109eed8dfdsm4088277ile.17.2023.01.30.08.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:44:30 -0800 (PST)
Message-ID: <1a1b86bc-10e4-bcb9-66dd-3aa599ecadc3@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 09:44:29 -0700
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
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230127135755.79929-27-mathieu.desnoyers@efficios.com>
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
>   tools/testing/selftests/sync/Makefile | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/sync/Makefile b/tools/testing/selftests/sync/Makefile
> index d0121a8a3523..df0f91bf6890 100644
> --- a/tools/testing/selftests/sync/Makefile
> +++ b/tools/testing/selftests/sync/Makefile
> @@ -1,6 +1,6 @@
>   # SPDX-License-Identifier: GPL-2.0
>   CFLAGS += -O2 -g -std=gnu89 -pthread -Wall -Wextra
> -CFLAGS += -I../../../../usr/include/
> +CFLAGS += $(KHDR_INCLUDES)
>   LDFLAGS += -pthread
>   
>   .PHONY: all clean

Adding seccomp maintainers:

kees,

I plan to take this through kselftest unless there are conflicts.
In case there are conflicts and you want to take this through yours

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
