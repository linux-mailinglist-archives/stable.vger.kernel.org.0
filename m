Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2194ECA4F
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 19:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244956AbiC3RMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 13:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236395AbiC3RMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 13:12:05 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F5247040
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:10:17 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id o8so18057059pgf.9
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 10:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=9uW/AXyG1i0n/wsVGv38ziS/6sV7ZT3qnWNnHTRRI4I=;
        b=m1OY/I6gCVzEzhBYDnUvMMp8AlINaImgjc4Nnbx6CY/iFcxVOVDeN3hGMe3FKsaZw7
         6qxm03vqxmxcHWujSnpp+JEBCTTI8/OmZkPiY0i9Y7NzHm8ojPqjojSHm9K6QhwsGgt/
         vzhovcZ9Zxo1mIoJHAFZ0qyr0lJ4Ct+ux3+rrg7R7dqGsB/HSNe8+2PI/yV/3funqh/f
         UG0IQTe0jbS/T9xsnIZylqD+ng2seLVqKTQ3upMrF4mZcGcFptb31aSGprGXkaftCdz9
         k+5Upfk4aOWNL3flLq7HT9Et04TqsScU7j8GvRzIBlI5VbHeYyQ5HGfxoHUVRYlpYZcS
         9KHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=9uW/AXyG1i0n/wsVGv38ziS/6sV7ZT3qnWNnHTRRI4I=;
        b=TF/cb9kIx51jVYT6gAvtmIspndCBEdZZpu9902IDzGyl3ARz76edg1xj8wcBihUHxp
         +2B/ur2QbZs9adOXUTXtuL/1hQR7T9nqDh1tuKXsKHxUxj9lyzU2MfTVBIWbfreCZHsF
         U+9cSo3NjQ2LRLi6AGwYDbpbhxPxDwzqeqjGH5rfKs2tT6BxkVAQLnx0ZytKaIf4pOjm
         PmWi/gl+y/hPZi18zhk3tRicSDf7fTQmxGhO8K+2yIRfQg6yC4u4EU1dHKbqTZHHgs4M
         kjU/MzAWtZHcIer+L6AiLUZt95HEuQQOJSj3jhZu0uoVw3Vp8V5m+kw1s5RBqBUllSXT
         nfFg==
X-Gm-Message-State: AOAM530qWRQ4TQrTXOqiqi2SWA9pMu0oDjZgsjzIjxMocFU9dfKypHdx
        6QtW1+dCtywlq7sQR+kzE3r6DQ==
X-Google-Smtp-Source: ABdhPJwjIc7PEj0nyvJmHO4d4HtAm+wSAJaGDeRywChSsOf0mujORlRbMEM+cMxO4dUJ8cY4PFsx7A==
X-Received: by 2002:a63:310f:0:b0:385:fcbf:c225 with SMTP id x15-20020a63310f000000b00385fcbfc225mr7099415pgx.31.1648660217230;
        Wed, 30 Mar 2022 10:10:17 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id y12-20020a17090a784c00b001c6bdafc995sm8260414pjl.3.2022.03.30.10.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 10:10:16 -0700 (PDT)
Message-ID: <6bb0f4a1-f32a-c160-4100-2d555147fa2d@linaro.org>
Date:   Wed, 30 Mar 2022 10:10:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220329220256.72283-1-tadeusz.struk@linaro.org>
 <20220329220256.72283-2-tadeusz.struk@linaro.org>
 <YkSHViipbwCb6sZQ@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH 2/2] skbuff: Extract list pointers to silence compiler
 warnings
In-Reply-To: <YkSHViipbwCb6sZQ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/22 09:37, Greg KH wrote:
> On Tue, Mar 29, 2022 at 03:02:56PM -0700, Tadeusz Struk wrote:
>> Please apply this to stable 5.10.y, and 5.15.y
>> ---8<---
>>
>> From: Kees Cook <keescook@chromium.org>
>>
>> Upstream commit: 1a2fb220edca ("skbuff: Extract list pointers to silence compiler warnings")
> 
> What about 5.16?
> 
The first one is already in 5.16. The second one applies cleanly, and the build
looks ok.

-- 
Thanks,
Tadeusz
