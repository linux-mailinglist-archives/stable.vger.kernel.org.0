Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E276213091F
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 17:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgAEQfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 11:35:02 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38330 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgAEQfC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 11:35:02 -0500
Received: by mail-pj1-f67.google.com with SMTP id l35so6750098pje.3
        for <stable@vger.kernel.org>; Sun, 05 Jan 2020 08:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ppSD70OcfsybNjtL8+O6CmpsRAFklJWZoYP8misyylM=;
        b=bLxCsToh+oY2gaOPQ5H/DKlU2Nf7qpf6WzJgVy7Go7j7ZHfOV7XV0Kvo8dG9mcoXsb
         c8k+GoNvi8CsAagjuKldgWGC67qMKxdGUrQnCT8p1TT5PwyafUIX6G9QzFzki9czjE+b
         mvNcLmWSnOmXxlI+Y7meB5QA8em7SQHKisRktqDNLFbXmRFWKwc5+WfiJOlKeHmGU+Na
         Xzb47Vo7yjsme1hBH+fZ+9ki8AJoUqlDHkgDO7k7GYmzDixpg4N+NrNXFFZN998RoREC
         mqMIqJkXV3R9Dnf/dDlzcwDbGs3qocB5g2ecf9EHWjU2CI8SN3FCBQkXSvdAFkQWCMok
         J3OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ppSD70OcfsybNjtL8+O6CmpsRAFklJWZoYP8misyylM=;
        b=rlirPGqc33nl75Qhx1bDu+mNCuEm5ztvhe7akdKquHomLiT3DW5bYHk/CG5cB0Mh6O
         GdanyTTtl7dKLDkpRazsVk/hfsnc3uGkf9wC8MVKtIHjCZuUsk0/hdX5TJxubRkk6lWI
         /U0w30Mi93BwHfTuVM5xqeh6sEYt2YQzz1mUCF7IyiRg1N7k8fsEnq7HL/hNXbeMMZQp
         OFM7qHu83W8plcZR9NIy2dL+CpTiPyu/xlTKMg7GmD3Nd2Ux45XLKIZnpyEqUtM/h6xY
         3EKW8B3bl7aD2WCipjkYM3jJoOFKXp+M5jGEJRW0/hURlQN8AlU7zNkWB+xOgS54/nNT
         E5Kw==
X-Gm-Message-State: APjAAAVSJ5v+6iyHhAsu44ozTW3ri6gX2lyZ9KWYTs96TyLC+lI95XQY
        iHaNFozpq8tUAFjEVpe/pm4=
X-Google-Smtp-Source: APXvYqwGUazu1DPGetPWL9K/gxs79b+kQy1txRWaS9G7pP5ipGNeWyHbARs/k3JApZ7H6GlznDolag==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr101188369plt.110.1578242101242;
        Sun, 05 Jan 2020 08:35:01 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5sm21987652pjt.28.2020.01.05.08.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jan 2020 08:35:00 -0800 (PST)
Subject: Re: Clock related crashes in v5.4.y-queue
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com> <20200102212837.GA9400@roeck-us.net>
 <20200103004024.GM16372@sasha-vm>
 <83b51540-f635-19c7-1621-3241315cc62c@roeck-us.net>
 <20200105160204.GR16372@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <9c295487-5e28-0fa7-7892-59e61cd7d07e@roeck-us.net>
Date:   Sun, 5 Jan 2020 08:34:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200105160204.GR16372@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/5/20 8:02 AM, Sasha Levin wrote:
> On Fri, Jan 03, 2020 at 06:50:45AM -0800, Guenter Roeck wrote:
>> On 1/2/20 4:40 PM, Sasha Levin wrote:
>>> On Thu, Jan 02, 2020 at 01:28:37PM -0800, Guenter Roeck wrote:
>>>> On Thu, Jan 02, 2020 at 10:01:19PM +0100, Greg Kroah-Hartman wrote:
>>>>> On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I see a number of crashes in the latest v5.4.y-queue; please see below
>>>>>> for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>>>>>> leak in clk_unregister()").
>>>>>>
>>>>>> The context suggests recovery from a failed driver probe, and it appears
>>>>>> that the memory is released twice. Interestingly, I don't see the problem
>>>>>> in mainline.
>>>>>>
>>>>>> I would suggest to drop that patch from the stable queue.
>>>>>
>>>>> That does not look right, as you point out, so I will go drop it now.
>>>>>
>>>>> The logic of the clk structure lifetimes seems crazy, messing with krefs
>>>>> and just "knowing" the lifecycle of the other structures seems like a
>>>>> problem just waiting to happen...
>>>>>
>>>>
>>>> I agree. While the patch itself seems to be ok per Stephen's feedback,
>>>> we have to assume that there will be more secondary failures in addition
>>>> to the one I have discovered. Given that clocks are not normally
>>>> unregistered, I don't think fixing the memory leak is important enough
>>>> to risk the stability of stable releases.
>>>>
>>>> With all that in mind, I'd rather have this in mainline for a prolonged
>>>> period of time before considering it for stable release (if at all).
>>>
>>> I would very much like to circle back and add both this patch and it's
>>> fix to the stable trees at some point in the future.
>>>
>>> If the code is good enough for mainline it should be good enough for
>>> stable as well. If it's broken - let's fix it now instead of deferring
>>> this to when people try to upgrade their major kernel versions.
>>>
>>
>> This is where we differ strongly, and where I think the Linux community will
>> have to make a decision sometime soon. If "good enough for mainline" is a
>> relevant criteria for inclusion of a patch into stable releases, we don't
>> need stable releases anymore (we are backporting all bugs into those anyway).
>> Just use mainline.
>>
>> Really, stable releases should be limited to fixing severe bugs. This is not
>> a fix for a severe bug, and on top of that it has side effects. True, those
>> side effects are that it uncovers other bugs, but that just makes it worse.
>> If we assume that my marginal testing covers, optimistically, 1% of the kernel,
>> and it discovers one bug, we have the potential of many more bugs littered
>> throughout the kernel which are now exposed. I really don't want to export
>> that risk into stable releases.
> 
> The assumption here is that fixes introduce less bugs than newly
> introduced features, so I'd like to think that we're not backporting
> *all* bugs :)
> 
> It's hard to define "severe" given how widely the kernel is used and all
> the weird usecases it has. Something that doesn't look severe might be
> very critical in a specific usecase. I fear that if we have a strict
> definition of "severe", our users will end up carrying more patches
> out-of-tree to fix their "less severe" issue, causing fragmantation
> which we really want to avoid.
> 
> I actually belive very much in the suggestion you've made in your first
> paragraph: I'd love to see LTS and later on -stable kernels go away and
> users just use mainline releases. Yes, it's unrealistic now, but I'd
> like to think that we're working towards it, thus I want to keep picking
> up more patches and develop our (as well as our user's) testing muscle
> to be able to catch regressions.
> 

The result will be that more users will abandon upstream stable releases.
I already have trouble explaining why that many patches are being backported;
there is quite some internal grumbling about it (along the line of "this
patch should not have been backported").

I think we are going into the absolutely wrong direction. Expecting that
everyone would use mainline is absolutely unrealistic, and backporting
more and more patches to stable branches can only result in destabilizing
stable branches, which in turn will drive people away from it (and _not_
to use mainline). The only reason it wasn't a disaster yet is that we have
better testing now. But we offset that better testing with backporting
more patches, which has the opposite effect. One stabilizes, the other
destabilizes. The end result is the same. Actually, it is worse - the
indiscriminate backporting not only causes unnecessary regressions,
it (again) gives people an argument against merging stable releases.
And, this time I have to admit they are right.

Guenter
