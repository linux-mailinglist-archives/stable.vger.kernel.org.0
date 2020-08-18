Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509AB2480D3
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 10:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHRIjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 04:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgHRIjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 04:39:42 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E77EC061342
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 01:39:41 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id v22so14607486edy.0
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 01:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=krt9y06sw5wM2zdZFK7qEmdsIbp+8Mc5QP6cjH66RXM=;
        b=aH58BYaZShWH3cj1RrQx0g8nyuALUOKEKJNmmJ0ZcgEs7hH/S+7VcyXHBahIg8vEt8
         giAkc5JtdgzqbGdSx3ut4A7jSccgRD8MqZF7bl38pTeU96DfqrC3CIDVxzX/MXxSguqW
         KX9yggIVA5cmAibivEjF0Rcck4aHpgyccqutF6jJwjtRbvMvlyJBlyyYjg+iSO9mLasc
         n2aNvT98w9OniATPNU4TQbbh22NJGKv+eI7RZgZ3zrKOgnL7yeAr9mPOtf/tB+1/fYkc
         yIFt+5LN18clc7l1wP+vuaBXth9lYBjcy9hsimYznFssno0B702IPSSm8+JDqajK2uZc
         ppMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=krt9y06sw5wM2zdZFK7qEmdsIbp+8Mc5QP6cjH66RXM=;
        b=VDvc3pKfwOsO95HINb75ba6Z9gEmDi0LLn1hUuuHn9uIpzbelL8vciZ+7gri8ORtEf
         jaPisDH+pFxD8N1XksFdGHnKTcKV+dz8Qs2StxQibvO3VIpIrhR2WEt9kKxjtmhexhWR
         OytpBq8S6G9m1DvIUvmoCU+aAZhcisqNeXe+zVo8Y0Mtm4iC3Y4l0kyitnOflolw3SAo
         YXhdB2rNN4wPXAcChlXsfHaA52lp+mL7LUlQh6iFWDzm/Q6dunCToVCZCto8Ruo5RziN
         KT2D9KWBlo5nmYTArSbr/zmWVuGgHvcDGPHaYsxGrCOi0+CQi/V4L9WnLzZQvpODuBAV
         KF/w==
X-Gm-Message-State: AOAM530WJrH5RGiNfBh+SjclVVZ+7bmNToyCGxbKo8yhwLEC6HzBAIgR
        Fb0JxtoSLE/0H2XNKVEIYKKTTQWRjKb9PePp
X-Google-Smtp-Source: ABdhPJxN/TH+0WNfCS1NTLaJN2eVMsP73HpIhJZbmoUAK8L248zBAVsNcbUhObEWWURbLfBmDvhJoA==
X-Received: by 2002:aa7:dc44:: with SMTP id g4mr19052600edu.273.1597739979894;
        Tue, 18 Aug 2020 01:39:39 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:a03f:5a32:bd00:41f1:972d:5bac:bf85])
        by smtp.gmail.com with ESMTPSA id rv14sm15928157ejb.33.2020.08.18.01.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2020 01:39:39 -0700 (PDT)
Subject: Re: Patch "net: refactor bind_bucket fastreuse into helper" has been
 added to the 4.14-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, tim.froidcoeur@tessares.net,
        stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
References: <159765838685222@kroah.com>
 <9f27fa03-b205-9195-758c-c9c67b384a21@tessares.net>
 <20200818070831.GB3333@kroah.com>
 <bf040796-d96b-d9a3-589f-317eed1e299b@tessares.net>
 <20200818072007.GA9254@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <00e0aca1-4516-0a8f-f09d-8d3b69db96f7@tessares.net>
Date:   Tue, 18 Aug 2020 10:39:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818072007.GA9254@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/08/2020 09:20, Greg KH wrote:
> On Tue, Aug 18, 2020 at 09:11:36AM +0200, Matthieu Baerts wrote:
>> On 18/08/2020 09:08, Greg KH wrote:
>>> On Mon, Aug 17, 2020 at 09:28:48PM +0200, Matthieu Baerts wrote:
>>>> Hi Greg,
>>>>
>>>> On 17/08/2020 11:59, gregkh@linuxfoundation.org wrote:
>>>>>
>>>>> This is a note to let you know that I've just added the patch titled
>>>>>
>>>>>        net: refactor bind_bucket fastreuse into helper
>>>>>
>>>>> to the 4.14-stable tree which can be found at:
>>>>>        http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>>>
>>>>> The filename of the patch is:
>>>>>         net-refactor-bind_bucket-fastreuse-into-helper.patch
>>>>> and it can be found in the queue-4.14 subdirectory.
>>>>>
>>>>> If you, or anyone else, feels it should not be added to the stable tree,
>>>>> please let <stable@vger.kernel.org> know about it.
>>>>
>>>> (...)
>>>>
>>>>> Patches currently in stable-queue which might be from tim.froidcoeur@tessares.net are
>>>>>
>>>>> queue-4.14/net-refactor-bind_bucket-fastreuse-into-helper.patch
>>>>
>>>> Thank you for backporting this patch!
>>>>
>>>> It seems the backport of the companion patch -- d76f3351cea2 ("net:
>>>> initialize fastreuse on inet_inherit_port") -- was lost somewhere for 4.14
>>>> version. It was backported in all other newer stable versions: 5.8, 5.7,
>>>> 5.4, 4.19 but not in 4.14.
>>>> The patch backported here is a preparation for the real fix which is the
>>>> missing patch.
>>>>
>>>> I guess the intention is to backport d76f3351cea2 to v4.14 as well. If not,
>>>> this refactoring is maybe not needed :)
>>>
>>> Ugh, that was my fault, thanks for catching this.  I've now queued this
>>> up to 4.14.y.
>>
>> Thank you for having added it!
>>
>> All these backported patches look good to me!
> 
> Thanks for checking.
> 
> I stopped at 4.14.y as the code for 4.9.y and 4.4.y changed a bunch in
> this area, do you think it's worth doing the backport to those really
> old kernels?  If not, no big deal, I figured I would ask, as I couldn't
> tell how realistic devices running them would hit this issue.

To be honest, my colleague Tim found the issue when looking at something 
else on a RHEL 7 (based on a v3.10) kernel :)
We noticed the behaviour with TPROXY was the same on the latest kernel.

The fix for the RHEL 7 kernel was even simpler with the code looking 
more like what we have in 4.4.y where we have to move only the if/else 
block:

https://elixir.bootlin.com/linux/v4.4.232/source/net/ipv4/inet_connection_sock.c#L219

In 4.9.y, tb->fast* variables are set with other code. It is indeed not 
as simple to backport:

https://elixir.bootlin.com/linux/v4.9.232/source/net/ipv4/inet_connection_sock.c#L221

I don't know if there are many devices doing a transparent proxy and 
using a kernel 4.4.y or 4.9.y. If you think it is needed to backport 
this fix and if you need help, we can look at sending patches when we 
are back from holidays.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
