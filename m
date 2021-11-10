Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AE344C606
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 18:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhKJRj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 12:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbhKJRj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 12:39:58 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE38C061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 09:37:10 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id q33-20020a056830442100b0055abeab1e9aso4988190otv.7
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 09:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ygf61tOMOApYRdSrFHsXxkhniN8psSHTULNc2t77/C8=;
        b=E+QOUSUWKhu0wAZkKczM54MTVdVHsxdCfwVfBsGYvo3i7ksGB5XCEkHfWSm2Ajo0S2
         JnjFXsdp6geG2wCRaCTgFYBOVNOyB+zFd6g79gwVm+1BfRhSTz5JsdwCSG5GrFd+LTR1
         Cg1gckkLiaShchfnRcyxuzOx3nI9DLZAVjCvd1WfawjbaTyiltYKjTMpdnmyMWZmg1YZ
         yLGE2DDYj4YvKHjyriZ0oAllvGjjKKLUs8q0VsjArU7xizTNWmIBmLcFF+LWA7sfaVGA
         1Is98Np3zZARQSNmjAyAjoG6ixLq9J6eef03Pun2FwV+d5dCk0pJZI7xvIwDWC692AFF
         5IAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ygf61tOMOApYRdSrFHsXxkhniN8psSHTULNc2t77/C8=;
        b=IB2120XvzsyGO7ID31ZAKqUzY7MMr9v1QLjK1MQ6UsZ4/YBWXsHOvadSI6TRX+gPiD
         zkXAG3HDq9wQ5zj8i9AI0FOnz0ML/NdRyZZyhQkHDF5Shd0q/+wByY8VeQw4gK40+CcU
         CR1MEqkbQmXVSJ8LNy3a6jaQKG6WecYNzlqMtC4STUtYT+yqVylzCealFm+neAyyaTQo
         yb5MDzxTjUIPYl68oSBwoHeufHB6G7GHQ+RThgbk4FYAo31dBEN9Tg3Xx1Qpy3BnG3Su
         FrbT7NqUhpU0XgDnKGB9vqzQvU5CHIrif4W00/Z+RuYcX7YqTIcUMWMXJhdHYHaVqfFQ
         gdWg==
X-Gm-Message-State: AOAM531nZ6ayp/qPTUxNKbxQ43H/ecEtiFv2ndfzCqrfQe8cyWg5ZjQ6
        5w2kzyPuz1JCs5yv26WfZSM=
X-Google-Smtp-Source: ABdhPJwWNvigqVW1eEE/COeqXilw2tahrDW8B+zxob3EvX4D8ScPK0I8ugen33vScjPRrv2LYybq7w==
X-Received: by 2002:a05:6830:348f:: with SMTP id c15mr801649otu.254.1636565829860;
        Wed, 10 Nov 2021 09:37:09 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y4sm96947ots.73.2021.11.10.09.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 09:37:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@google.com>,
        Yi Fan <yfa@google.com>, shreyas.joshi@biamp.com,
        Joshua Levasseur <jlevasseur@google.com>, sashal@kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        wklin@google.com, mfaltesek@google.com
References: <YYqZdkLBAC8mtRSC@alley>
 <a46e9a26-5b9f-f14c-26be-0b4d41fa7429@roeck-us.net> <YYu1B40MQx2+WkZ6@alley>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] printk/console: Allow to disable console output by using
 console="" or console=null
Message-ID: <88adef2b-0fc8-e22e-8cce-ee7b7e93e6ba@roeck-us.net>
Date:   Wed, 10 Nov 2021 09:37:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YYu1B40MQx2+WkZ6@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 4:03 AM, Petr Mladek wrote:
> On Tue 2021-11-09 10:15:12, Guenter Roeck wrote:
>> On 11/9/21 7:53 AM, Petr Mladek wrote:
>>> The commit 48021f98130880dd74 ("printk: handle blank console arguments
>>> passed in.") prevented crash caused by empty console= parameter value.
>>>
>>> Unfortunately, this value is widely used on Chromebooks to disable
>>> the console output. The above commit caused performance regression
>>> because the messages were pushed on slow console even though nobody
>>> was watching it.
>>>
>>
>> We actually had to revert this patch on Chromebooks, so we'll have to revert
>> it again from stable releases after it gets there.
> 
> What patch was or need to get reverted on Chromebooks, please?
> 
>    1. commit 48021f98130880dd74 ("printk: handle blank console
>       arguments passed in.")
> 
> or
> 
>    2. commit commit 3cffa06aeef7ece30f6b5ac0e ("printk/console: Allow
>       to disable console output by using console="" or console=null")
> 
Both.

> 
> I know that the 1st patch caused problems on Chromebook. The 2nd one
> was supposed to fix the problem.
> 
> The 2nd patch is being backported here? Do you still see the problems
> with it, please?
> 
Yes.

> 
>> The problem is two-fold:
>>
>> First, it is used in Chromebooks to disable the default console in production
>> images; that default console may be set in a devicetree file, and this patch
>> doesn't really disable it. In other words, Chromebooks use "console=" to
>> implement "mute_console" as suggested below, and this patch does not address
>> that use case.
> 
> I guess that you are talking about the 1st patch.
> 
> The 2nd patch should make it working basically the same way as when reverting
> the 1st patch. The difference is that it prefers the fake ttynull
> console driver instead of none. It should be better because it will
> provide a kind of null console for stdin/stdou/stderr of the init
> process. But it still should result into a none-driver when ttynull
> driver is not available.
> 

Yes, that was what we initially assumed as well - only, as the patch
states, it doesn't work as needed for Chromebooks if another console
is registered by other means.

> Or do you use another extra patch for Chromebooks, please?
> 

Not that I know of. We just rely on the old behavior.

>> Second, the patch causes some unexplained problems with dm-verity, which
>> inexplicably fails on some Chromebooks when the patch is in place.
>> We never tracked down the root cause because the patch doesn't work
>> for us anyway.
> 
> Interesting. I wonder what console was really registered when it complained.
> 

It was with a Chromebook using devicetree, where the console is primarily
passed via devicetree and not as boot parameter. I don't recall the exact
model(s).

Guenter
