Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA831E640C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 17:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfJ0QSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 12:18:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39882 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfJ0QSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 12:18:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so4094044plp.6
        for <stable@vger.kernel.org>; Sun, 27 Oct 2019 09:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nbh4iz1eFwR5PpwtFBpknyqn4rUMw0eiD33U7RhvHyM=;
        b=HAu2K8bpOrx6M7+H9zjUycuix6PNsDf38LzA1OFE4EGRoFf1q4CdEMCm0m/ktcVuMq
         r3OPmpAKZVeubdlQnWr6YXZRuA0moC77yDEdnIrxBqRLQjUuxw6D0jwHheNWr9r88bJG
         PsRHpc+g+7lWbadl/H1s52CcRN0PbHSGK6/8CvEdCs2bLYzRXShvEgVZwbk/wgrWfldT
         5dFI7PvUGrq08IWyspnwOmm/3sCIDOpKc+BJyy3OrMKvtz9ctIbsWWHEGkZF4/UPiPqC
         fs0+m2OF6mzDBoLwnxDCE68bZnQ1GKUBn2h+SsApTzPc2iZWp9yOP8GoZ+dr0CHmGvdX
         89mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nbh4iz1eFwR5PpwtFBpknyqn4rUMw0eiD33U7RhvHyM=;
        b=ISYEl6ABPRMNunf7mmgRau52Y4L4SeMYCPF0WPrSSG2FLCzCDzHQhzoVWwelejpSSY
         QI/kE9PEGJrAAcolsPpCcAVyPYeHCpzP8tcfwsTc1qDBpLfqWUIZw5dA+dVVvdvxAecQ
         /ymyyPE7Hdbc7NHH8GAekK5Wu+f3hidpUCHvCjKEabc6NSpIxGK1ibpQnS+DB14pxuNp
         9P64J6eXbh2SXj8I5JBmESMESV4Wik0MHGO9S+oSCw+owGPtyihaLEIS/45gre15aHv4
         AcdqjitZPpQGOxmZRwvicP5vr1xIQhQg7em3IoXgVsKWGJjVJcAlSl1z198eXqOMeGmO
         80GQ==
X-Gm-Message-State: APjAAAXSmGAYU9XPRg3JD4kOyA95MBD96/pGh1o8KnFAXeT4jjzX6Y5N
        7WnvxbzG2sVk/gaq89MTz1lZuVuL4p5wtg==
X-Google-Smtp-Source: APXvYqy44iY+777MXLUlaXmJXSoaDwM7r5V0biE27az+gYZvnmBd7jc3crFJE6C7EmRC6xOBhZVjcg==
X-Received: by 2002:a17:902:244:: with SMTP id 62mr15193515plc.14.1572193097921;
        Sun, 27 Oct 2019 09:18:17 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id q33sm8370208pgm.50.2019.10.27.09.18.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 09:18:17 -0700 (PDT)
Subject: Re: io_uring stable 5.3 backports
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
 <20191027085204.GA1560@sasha-vm>
 <f90a0bd3-3074-ee14-dea9-63d520bd72a2@kernel.dk>
 <20191027134832.GD1560@sasha-vm>
 <4dab77cb-0e29-15af-bb32-26ee23de3f69@kernel.dk>
 <20191027142415.GE1560@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <981a3436-e8a0-f13d-d33c-1aa53114fc64@kernel.dk>
Date:   Sun, 27 Oct 2019 10:18:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027142415.GE1560@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/27/19 8:24 AM, Sasha Levin wrote:
> On Sun, Oct 27, 2019 at 08:03:09AM -0600, Jens Axboe wrote:
>> On 10/27/19 7:48 AM, Sasha Levin wrote:
>>> On Sun, Oct 27, 2019 at 06:01:03AM -0600, Jens Axboe wrote:
>>>> On 10/27/19 2:52 AM, Sasha Levin wrote:
>>>>> On Sat, Oct 26, 2019 at 05:33:41PM -0600, Jens Axboe wrote:
>>>>>> Hi,
>>>>>>
>>>>>> For some reason I forgot to mark these stable, but they should go
>>>>>> into stable. In order of applying them, they are:
>>>>>>
>>>>>> bc808bced39f4e4b626c5ea8c63d5e41fce7205a
>>>>>
>>>>> This commit says it fixes c576666863b78 ("io_uring: optimize
>>>>> submit_and_wait API") which is not in the stable tree.
>>>>>
>>>>>> ef03681ae8df770745978148a7fb84796ae99cba
>>>>>
>>>>> This commit doesn't say so, but really it fixes 5262f567987d3
>>>>> ("io_uring: IORING_OP_TIMEOUT support") which is not in the stable tree.
>>>>>
>>>>>> a1f58ba46f794b1168d1107befcf3d4b9f9fd453
>>>>>
>>>>> Same as the commit above.
>>>>
>>>> Oh man, sorry about that, I always forget to check if all of them are in
>>>> 5.3. I blame the fact that I backport everything to our internal tree,
>>>> which is 5.2 based. But yes, you are of course right, those three can be
>>>> dropped.
>>>
>>> How much "secret sauce" does your internal tree have? Is it something
>>> we can peek into to make sure we don't miss fixes?
>>
>> There's no secret sauce in the internal tree, it's just that I backport
>> everything into the 5.2 version that is our newest. It's fully uptodate
>> with 5.4-rc and in some cases what's queued up for 5.5 as well. Hence I
>> sometimes forget to check what is applicable to 5.3-stable, since I have
>> it in our 5.2 tree...
>>
>> The internal tree is just backports. That's how we do things.
> 
> Could you push it somewhere public? I could automate grabbing fixes off
> of it.

There a few reasons why that hasn't been done, and none of them are
related to the actual code/patches in there..

But I don't think it would help you. The io_uring branch is a mix of
things that have gone into the current window (and may or may not need
to go to stable), and things that are queued up for the next kernel
versions (and aren't going to stable). This will just continue to drift
from stable, until we respin a new kernel version internally.

-- 
Jens Axboe

