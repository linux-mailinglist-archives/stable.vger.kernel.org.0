Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E27223E2C5
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 22:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgHFUCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 16:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgHFUCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 16:02:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC13C061575
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 13:02:50 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j9so38101366ilc.11
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 13:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GcmxaFAbN9FMOZvy1ws6uE/hP82637tGxfEk48uh7HY=;
        b=AzQNBu5LtmU+t3c6vUOJRUCvqiRtHE7oZ2mjfQNHOTkSRfBPMdGUrkKbxZBQI1jIU5
         LKinN/3WztDZsYn5pMZ1v3MxwbqbolF0H+dYM5UpKIhdOHXv1r41z2XVOl7VY3QHH1tL
         7bb+Ssl+fBKgZxUvcWKBbr/I4BFlGWg/jvilI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GcmxaFAbN9FMOZvy1ws6uE/hP82637tGxfEk48uh7HY=;
        b=K+BWYrUAw88oxuOjJMqq9ixJXKSsxQur28wlYwpN3wjN1/FVkKIQi/59nhcuWSv0bn
         hm2Xd4HUOMAf9txLEu/94hWS30f6Mf7O6lZUQ3Vtkr/51UUoKpGJJRjoBmjpY8SWR4HU
         coXWHNvEhtB6AIkMqcMRhuSRKoMlujHomi3llcLAz1X93SVWRkpczeN5tyWrtTRewot2
         QuF5JKBcW2ZwmB9GfdOdT5mtJ0I3VL3YAyLZjAQcu3EmeDMyUHwR5Kv5hSMe0FgDjiXI
         rndgFPFPNVd27EJJc1lpNzeoRqZEMx1zyAOXbesrL0pnbJ7YATJJRvI+e0xPhI0cZAOH
         Ln3g==
X-Gm-Message-State: AOAM531bxJLFXY6wO2+mV77NKgItLH52w/j+3BVi4mP5+tX7xHOdh02P
        VKcDXKzG8z+Lvq4HVyE3PnQlhg==
X-Google-Smtp-Source: ABdhPJyVWpq4Hy6ek99rwtJSeq/2b1JB3+ZMX421UkOI3KmSXS+Rx1lmNwqnEWR8vOC170Yh+F6Wkw==
X-Received: by 2002:a05:6e02:1213:: with SMTP id a19mr658521ilq.129.1596744169530;
        Thu, 06 Aug 2020 13:02:49 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l5sm5241282ios.3.2020.08.06.13.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 13:02:49 -0700 (PDT)
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthias Maennich <maennich@google.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200604164145.173925-1-maennich@google.com>
 <alpine.DEB.2.21.2006042130080.2577@hadrien>
 <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
 <20200622080345.GD260206@google.com>
 <0eda607e-4083-46d2-acb8-63cfa2697a71@linuxfoundation.org>
 <20200622150605.GA3828014@kroah.com>
 <f09e32dc-8f17-d09a-b2e4-fb4c0699838e@linuxfoundation.org>
 <baf80622-0860-e640-eb14-dffc02597ed3@linuxfoundation.org>
 <20200806195704.GA2950037@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8417ccd3-9964-3b8e-65e5-6140be0b28fd@linuxfoundation.org>
Date:   Thu, 6 Aug 2020 14:02:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806195704.GA2950037@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/6/20 1:57 PM, Greg Kroah-Hartman wrote:
> On Thu, Aug 06, 2020 at 01:48:26PM -0600, Shuah Khan wrote:
>> On 6/22/20 10:14 AM, Shuah Khan wrote:
>>> On 6/22/20 9:06 AM, Greg Kroah-Hartman wrote:
>>>> On Mon, Jun 22, 2020 at 08:46:18AM -0600, Shuah Khan wrote:
>>>>> On 6/22/20 2:03 AM, Matthias Maennich wrote:
>>>>>> On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
>>>>>>> On 6/4/20 1:31 PM, Julia Lawall wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On Thu, 4 Jun 2020, Matthias Maennich wrote:
>>>>>>>>
>>>>>>>>> When running `make coccicheck` in report mode using the
>>>>>>>>> add_namespace.cocci file, it will fail for files that contain
>>>>>>>>> MODULE_LICENSE. Those match the replacement precondition, but spatch
>>>>>>>>> errors out as virtual.ns is not set.
>>>>>>>>>
>>>>>>>>> In order to fix that, add the virtual rule nsdeps and only
>>>>>>>>> do search and
>>>>>>>>> replace if that rule has been explicitly requested.
>>>>>>>>>
>>>>>>>>> In order to make spatch happy in report mode, we also need a
>>>>>>>>> dummy rule,
>>>>>>>>> as otherwise it errors out with "No rules
>>>>>>>>> apply". Using a script:python
>>>>>>>>> rule appears unrelated and odd, but this is the shortest I
>>>>>>>>> could come up
>>>>>>>>> with.
>>>>>>>>>
>>>>>>>>> Adjust scripts/nsdeps accordingly to set the nsdeps rule
>>>>>>>>> when run trough
>>>>>>>>> `make nsdeps`.
>>>>>>>>>
>>>>>>>>> Suggested-by: Julia Lawall <julia.lawall@inria.fr>
>>>>>>>>> Fixes: c7c4e29fb5a4 ("scripts: add_namespace:
>>>>>>>>> Fix coccicheck failed")
>>>>>>>>> Cc: YueHaibing <yuehaibing@huawei.com>
>>>>>>>>> Cc: jeyu@kernel.org
>>>>>>>>> Cc: cocci@systeme.lip6.fr
>>>>>>>>> Cc: stable@vger.kernel.org
>>>>>>>>> Signed-off-by: Matthias Maennich <maennich@google.com>
>>>>>>>>
>>>>>>>> Acked-by: Julia Lawall <julia.lawall@inria.fr>
>>>>>>>>
>>>>>>>> Shuah reported the problem to me, so you could add
>>>>>>>>
>>>>>>>> Reported-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>>>>
>>>>>>>
>>>>>>> Very cool. No errors with this patch. Thanks for fixing it
>>>>>>> quickly.
>>>>>>
>>>>>> I am happy I could fix that and thanks for confirming. I assume your
>>>>>> Tested-by could be added?
>>>>>
>>>>> Yes
>>>>>
>>>>> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>>
>>>>>> Is somebody willing to take this patch through their tree?
>>>>>>
>>>>>
>>>>> My guess is that these go through kbuild git??
>>>>
>>>> If you want to take this, that's fine with me.  But as I had the
>>>> original file come through my tree, I can take it too.  It's up to you,
>>>> either is ok with me.
>>>>
>>>
>>> Great. Please take this through your tree.
>>>
>>
>> Greg! Looks like this one didn't make it in. Can you pick this up?
> 
> I think this is 55c7549819e4 ("scripts: add dummy report mode to
> add_namespace.cocci") in Linus's tree right now, right?
> 

Yes. It is in Linux 5.9. I was looking in the wrong place on
Linux 5.8. :(


thanks,
-- Shuah

