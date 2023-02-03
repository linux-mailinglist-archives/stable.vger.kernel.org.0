Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00CD689F88
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 17:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjBCQqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 11:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbjBCQqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 11:46:44 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E721468AFF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 08:46:43 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id z2so2300773ilq.2
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 08:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fpdkLgPklBFJN/zZhaetYuhJzTuu3xpdAsK6groGA1Y=;
        b=JQ7X8f5pg2YJwEN+s3K6LyyxAgyzVLO8Xf+SXbt6ii1BKjClLzlFB6TqEkoiYAWNe7
         PFgPO+Dw6wpA+k7TdoSM4MFDwtk91tamXdkV4GPOJPK4pQLTLtjGHhVP+WspCS0j8NK7
         SkEHI2VWwYVpWX1zfgVe9UM2zAOylbTDpPwFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fpdkLgPklBFJN/zZhaetYuhJzTuu3xpdAsK6groGA1Y=;
        b=NunB3m0aOoE0mQhKFwdG+r8LPpMo+FbMIQ78q1wBFwF+CUkZhFiA/vnA5NVecpg77d
         +s21Y7A3WZUDCvtUAP9k6D4wbek0wTlXHiJbaieJjH9554OcwEgyqlWRkGeBIeJsFweG
         W69Zusj1S6CtsGPxfeU3nJceesGcUhTAFgE9AdHUG2+RdXQluF0kgv/mbjXfJt/X0GFg
         1rVnfzYKbzgxfXc4Hd6euzerAwQozOa0yotGkKobDq7djZ5ET2TC0ZZCX0IvLDLAHG1x
         redJnJiiC/fZFIOi8CXg29KO6zXUJX6NJ9QsgltkHESfTgU/LORnP3HO3JK4eo8rIOVt
         8dDQ==
X-Gm-Message-State: AO0yUKVKK7E/AIK0H1R+F5fegJ6Hj5yoDOf+1A2tuu/uPIdcV/KfJOYm
        gyvwC1sTcE+DHPfCeLlOWTDKyg==
X-Google-Smtp-Source: AK7set/2VlpenuhWmd7WjxknhQtKu7ZjvIBUmJUYZIUNG64PBzvUgAxN6/wOZMlxUXaHomgNPzNNOQ==
X-Received: by 2002:a05:6e02:110f:b0:30e:f89b:6652 with SMTP id u15-20020a056e02110f00b0030ef89b6652mr5194229ilk.0.1675442803197;
        Fri, 03 Feb 2023 08:46:43 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g26-20020a02b71a000000b003affa7891ccsm984291jam.105.2023.02.03.08.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 08:46:42 -0800 (PST)
Message-ID: <df93cbb8-0097-db63-5e0d-b7dd2ec1ea55@linuxfoundation.org>
Date:   Fri, 3 Feb 2023 09:46:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] Linux 6.1.9
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Vinayak Hegde <vinayakph123@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@vger.kernel.org>
References: <20230203093811.2678-1-vinayakph123@gmail.com>
 <CAJesESYM1URn3_hMjPoMkfFo=5k-Yb9HZuyy9__kyKoZPoAsRA@mail.gmail.com>
 <48e1ae98-8f29-96d2-61af-d79ce22dcc62@gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <48e1ae98-8f29-96d2-61af-d79ce22dcc62@gmail.com>
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

On 2/3/23 03:12, Bagas Sanjaya wrote:
> On 2/3/23 16:42, Vinayak Hegde wrote:
>> Hi Everyone,
>> I was going through A Beginner's Guide to Linux Kernel Development (LFD103) course and was trying out a few things
>> mistakenly sending this mail.
>>
> 
> Hi and welcome to LKML!
> 
> Some netiquette tips:
> 
> * Don't top-post when replying; reply inline with appropriate context
>    instead. Some people (like me) tends to cut quoted reply below
>    if you top-post.
> * Don't send HTML emails - many kernel development lists (including
>    LKML) don't like them for being common spam method.
> * Wait for at least a day before replying - people may respond to
>    your message at different pace.
> * Use git-send-email(1) to submit patches (see
>    Documentation/process/submitting-patches.rst for how to do that).
>> Regarding your patch, I think Greg has already bumped SUBLEVEL
> whenever new stable release is made, so no need to send separate
> patch just for that.
> 

[Trimmed the email list to reduce noise.]

If you read this email more carefully, you would have noticed that this
email was sent by mistake while taking LFD103 class. The sender said this
isn't a patch.

thanks,
-- Shuah

