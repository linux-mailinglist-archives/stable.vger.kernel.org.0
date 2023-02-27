Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1BC6A458D
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 16:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjB0PGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 10:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjB0PGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 10:06:31 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70FCD22023;
        Mon, 27 Feb 2023 07:06:24 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id z5so4122525ilq.0;
        Mon, 27 Feb 2023 07:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=7LYsXh7yFjvc6hXHyqIsE8hhFTTffTHd8InHSgGAxhw=;
        b=G3r076THYu1XxK5yt2OEuJazbW1iXDsihzJa9XbBcdRhA0QfFMiDLteUmypKGGBD+H
         8O3JOtdpzO91UOpfLULgQw/BvUcNB65BkxFl98zHOEV6KuaovsfAKJ7OXwI7RW4WoV+X
         AVW6dEMGBqP8ZC3sEwOhsQQzrrJnxvF8eEsnudWS4cA/mAZw2fQwDhoRbKWojTP8n8lU
         FH4p4LCVnII+kcN284UzZSEnG261vJ3XSFPUoqjwz4acG5N34tByG5Vous3VdOXR8RIN
         UwewuIqYWSaOo01f8TBwNIYeXyM2lAqPrCKWLqnpzMSr27qKGsNi9lLA6dBPJyutb7BW
         yJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7LYsXh7yFjvc6hXHyqIsE8hhFTTffTHd8InHSgGAxhw=;
        b=Cn5bk1vPPqC6k+9qOa9q2mlZxyDOE8TcYBLGt+OPVDbF9EVil7RYTGMUWkJqLJyvcT
         EDU0PJbb/cYtA73r7+B6upCr5vmzhMk+jD7SuAbSyu20U8yeLps1ra04a8xg5y1D8/97
         fVKj8uUvA2ZSP/FoK4wVoxTx8Iqd1xZ3p+Nd62lz5QzHeAXcH/j4NPrx2oXf9SLVYm/Y
         unuWlS41ebasg17yMQenhtklocQBT+XTSTFMmayX9JJOCCUfJEICmL15tuoulDqiij2D
         xt49Y8jFIyGVZqxNJYx0Ri0HoN4Gy8zmbUHQMUtfUErGoXWnNHUDP/EuOuKLnJiFr31S
         HrsA==
X-Gm-Message-State: AO0yUKViI8KZeUG5yIZJ0P04zxvK5AEVpoxvxyZDsSl34XcgNdkrkUiR
        vsbNI2eDR3I9qzsYcW9R4+s=
X-Google-Smtp-Source: AK7set/5kSpmSZ8xsksz1cCxD2giHtys6ziE4PL/RiA0pYR+mOLxUY4e7ksmBC0+cQ+pC4kFd0+YsQ==
X-Received: by 2002:a05:6e02:2197:b0:315:4169:c5ac with SMTP id j23-20020a056e02219700b003154169c5acmr23554700ila.30.1677510383862;
        Mon, 27 Feb 2023 07:06:23 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p3-20020a056e02104300b003157696c04esm2058369ilj.46.2023.02.27.07.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 07:06:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3ed3054d-0ede-4557-4590-a01861c338e3@roeck-us.net>
Date:   Mon, 27 Feb 2023 07:06:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230220180729.23862-1-mario.limonciello@amd.com>
 <20230227145554.GA3714281@roeck-us.net>
 <7f5bd6a2-2eed-a27e-8655-181bb37a7c1c@amd.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <7f5bd6a2-2eed-a27e-8655-181bb37a7c1c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/23 06:58, Mario Limonciello wrote:
[ ... ]
>>> +    version = ((u64)val1 << 32) | val2;
>>> +    if ((version >> 48) == 6) {
>>> +        if (version >= 0x0006000000180006ULL)
>>> +            return false;
>>> +    } else if ((version >> 48) == 3) {
>>> +        if (version >= 0x0003005700000005ULL)
>>> +            return false;
>>> +    } else
>>> +        return false;
>>
>> checkpatch:
>>
>> CHECK: braces {} should be used on all arms of this statement
>> #200: FILE: drivers/char/tpm/tpm-chip.c:557:
>> +    if ((version >> 48) == 6) {
>> [...]
>> +    } else if ((version >> 48) == 3) {
>> [...]
>> +    } else
>> [...]
> 
> It was requested by Jarko explicitly in v1 to do it this way.
> 
> https://lore.kernel.org/lkml/Y+%2F6G+UlTI7GpW6o@kernel.org/
> 

Interesting. We live and learn.

Guenter

