Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE5C6542C1
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 15:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiLVOUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 09:20:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVOUr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 09:20:47 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE3A1001
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 06:20:45 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id tz12so5208903ejc.9
        for <stable@vger.kernel.org>; Thu, 22 Dec 2022 06:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w0VrLN7ReTiwyFyH6raxJVPW+7ZqprbBaTbgFuBLlhM=;
        b=FNQNThLxl6dYeyRcypE1Wb/0gAAdVIup4nGRAQFlKXw8GsLHJxFTiv3rZh/dSGtNpj
         UoSBUSvs01CFyVaRG5I3hnbEGjtL5C1MaL9pVYSj6N0TZ2RQTM3X3c4uxyJTYpBM31sW
         /v1DktRiKjecXCs9U7gbxS6RxnAlabfTbJ7GNkzgSoYlqAtus3pr+ZXj+VwkJmmfYCFJ
         uXcfdYcLvmRHvTkiz4tyAc9cP4OjsHG8mVAiO3OO7v27YN0p7+mt9WMlPI0kcA7TywCN
         Ndjg6WaPX8hoSexAXMQUFiWHBjaNSVbRm38REOjDzbfXoXFPSGv5XNuDU8ZVPzVkagkw
         f4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0VrLN7ReTiwyFyH6raxJVPW+7ZqprbBaTbgFuBLlhM=;
        b=R7A5NU5WbKyrdcYs05vfpHqIHoZBN6x5qpNQwN5xv0Bs2cz3dbZrIgAO48QhL4Awhi
         n8W6NSE647MbpQyLqP4sWwCm5Tw/sVBOeWYNpTLaBgatswUbAUN4mU3KBEVeICAVnTrr
         2x/eXXKWI81erXWVI9QYbImWqsdMr15l8+c2cqKEX7k31T0mex575fEIPq/XWC5Z70/9
         i0CDvTm9pfzwUcd5q3pWc1kAcHKHGt3bIlZoXA4mLtHBV0pLkZW8KQXxF7nI8NrgyGpR
         uiQ75RaCmtXnbGK/x+LBNho2+Sg/j8FR05+JB5SYh7ZgPRuvUHiMTBf5caKSrN2T4cVj
         OaAg==
X-Gm-Message-State: AFqh2ko8+0gU/X8imp6gIjYFCBRiRkOUdzoN/vVkA5Kw4nNOgNLn6csd
        IWdeuMfWh6saPX8F1WL6SK0TUA==
X-Google-Smtp-Source: AMrXdXuCxILt4Fs1n68sHksTQWcVTaD7koX4UFAdmbC4PzMLB6vMG1r8Uldc8TuybgNHW7U4PRDX6Q==
X-Received: by 2002:a17:907:d681:b0:7c0:eb38:f8af with SMTP id wf1-20020a170907d68100b007c0eb38f8afmr4881131ejc.2.1671718843921;
        Thu, 22 Dec 2022 06:20:43 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.131])
        by smtp.gmail.com with ESMTPSA id x20-20020aa7d6d4000000b0047b252468a4sm415718edr.78.2022.12.22.06.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 06:20:43 -0800 (PST)
Message-ID: <86b513b7-b65f-4948-7c09-789844f0d90d@linaro.org>
Date:   Thu, 22 Dec 2022 16:20:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] Documentation: stable: Add rule on what kind of patches
 are accepted
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, corbet@lwn.net, stable@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        joneslee@google.com
References: <20221222091658.1975240-1-tudor.ambarus@linaro.org>
 <Y6RchEaXUvg+9nKv@kroah.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <Y6RchEaXUvg+9nKv@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 22.12.2022 15:32, Greg KH wrote:
> On Thu, Dec 22, 2022 at 11:16:58AM +0200, Tudor Ambarus wrote:
>> The list of rules on what kind of patches are accepted, and which ones
>> are not into the “-stable” tree, did not mention anything about new
>> features and let the reader use its own judgement. One may be under the
>> impression that new features are not accepted at all, but that's not true:
>> new features are not accepted unless they fix a reported problem.
>> Update documentation with missing rule.
>>
>> Link: https://lore.kernel.org/lkml/fc60e8da-1187-ca2b-1aa8-28e01ea2769a@linaro.org/T/#mff820d23793baf637a1b39f5dfbcd9d4d0f0c3a6
>> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
>> ---
>>   Documentation/process/stable-kernel-rules.rst | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
>> index 2fd8aa593a28..266290fab1d9 100644
>> --- a/Documentation/process/stable-kernel-rules.rst
>> +++ b/Documentation/process/stable-kernel-rules.rst
>> @@ -22,6 +22,7 @@ Rules on what kind of patches are accepted, and which ones are not, into the
>>      maintainer and include an addendum linking to a bugzilla entry if it
>>      exists and additional information on the user-visible impact.
>>    - New device IDs and quirks are also accepted.
>> + - New features are not accepted unless they fix a reported problem.
> 
> No need to call this out, it falls under the "fixes a problem" option,
> right?
> 
> The goal is not to iterate every single option here, that would be
> crazy.  Let's keep it short and simple, our biggest problem is that
> people do NOT read this document, not that it does not list these types
> of corner cases.
> 

When I read the document I thought that new features are not accepted
at all, so I took into consideration making a custom fix for stable.
But that would have been worse, as it implied forking the stable and
would have made backporting additional fixes harder. An explicit rule
like this would have saved me few emails changed and few hours spent on
looking for an alternative fix. But maybe others find this a
common sense implied rule and you won't have to be summoned for it
anymore.

> So thanks for the patch, but I will not accept it.
> 

Okay, as you prefer.

Cheers,
ta
