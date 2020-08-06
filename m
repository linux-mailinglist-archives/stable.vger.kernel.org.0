Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F423E285
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 21:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgHFTsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 15:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgHFTsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 15:48:31 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160D4C061574
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 12:48:31 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id u63so32219911oie.5
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 12:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4gQ75ruoSOCI+/ZqdsWxnLpvjWBjTukbDtC3AHZ8rTg=;
        b=HL+bKaZ+qVQ7F1TeHaJfo1vBm5yKb7vlf1+/xmjhLCt38vp7sIy8YHm32APcZNMHRZ
         Pk8848zPgRvrItpKjsDLfhlQ1I97F12VaL4ybd3Bg/rAwX6FnS3hld18jW4QXK7VUVmH
         CrDQcIQQ0hIDhPm5bXwQw+0rHRPZ7idk5LuXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4gQ75ruoSOCI+/ZqdsWxnLpvjWBjTukbDtC3AHZ8rTg=;
        b=YiWcFKGmErOx4yMmdCi3nau9zOAVVtS9oBAJLT3PIPcFyZcdDOHJHDhhpu5dbuL9ih
         i3WiLgm2y3aXThg2kM4zjVuYIlNcPhoGVO1uwjXi1tPgLhI3GAnEHRI4OnUFdyxlHina
         q2yUMZW4OYOmlt/ZKXbiXtwk/7z7cbwNoLhJ9nvGdfjYmVQDHJmFHCmOMvEkbVqxHuTS
         WymcOBBnhnM0LmrUcfoort6fTq/HOFz8aghp65u6oWABfD0oNNCoaAQ3p8Cu37HvhT1f
         I1t/CIWmNlucb3FAyotOBkpaPkA7uw2u14AmfSWSY0jVciE/5w6iL61XGpbPov3l9c7W
         pBfw==
X-Gm-Message-State: AOAM531j+zOIgrK+qOtpU4Y77GdLeGmEAB//tk6ZH2aJfhGimt4GoYzG
        emw2aMD6U2b7bbPxJM+E/65hx/EZ9ZE=
X-Google-Smtp-Source: ABdhPJw21Tec6i06lnsFmCKGZ+xmQIMhPfqdJ0RZ3DidumVLHLn1K9s9oALDXkGudqsb5SkM+Xo+0g==
X-Received: by 2002:aca:b106:: with SMTP id a6mr8160402oif.46.1596743308916;
        Thu, 06 Aug 2020 12:48:28 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 63sm1190607otp.39.2020.08.06.12.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 12:48:27 -0700 (PDT)
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Matthias Maennich <maennich@google.com>,
        Julia Lawall <julia.lawall@inria.fr>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org,
        skhan@linuxfoundation.org
References: <20200604164145.173925-1-maennich@google.com>
 <alpine.DEB.2.21.2006042130080.2577@hadrien>
 <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
 <20200622080345.GD260206@google.com>
 <0eda607e-4083-46d2-acb8-63cfa2697a71@linuxfoundation.org>
 <20200622150605.GA3828014@kroah.com>
 <f09e32dc-8f17-d09a-b2e4-fb4c0699838e@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <baf80622-0860-e640-eb14-dffc02597ed3@linuxfoundation.org>
Date:   Thu, 6 Aug 2020 13:48:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f09e32dc-8f17-d09a-b2e4-fb4c0699838e@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/22/20 10:14 AM, Shuah Khan wrote:
> On 6/22/20 9:06 AM, Greg Kroah-Hartman wrote:
>> On Mon, Jun 22, 2020 at 08:46:18AM -0600, Shuah Khan wrote:
>>> On 6/22/20 2:03 AM, Matthias Maennich wrote:
>>>> On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
>>>>> On 6/4/20 1:31 PM, Julia Lawall wrote:
>>>>>>
>>>>>>
>>>>>> On Thu, 4 Jun 2020, Matthias Maennich wrote:
>>>>>>
>>>>>>> When running `make coccicheck` in report mode using the
>>>>>>> add_namespace.cocci file, it will fail for files that contain
>>>>>>> MODULE_LICENSE. Those match the replacement precondition, but spatch
>>>>>>> errors out as virtual.ns is not set.
>>>>>>>
>>>>>>> In order to fix that, add the virtual rule nsdeps and only
>>>>>>> do search and
>>>>>>> replace if that rule has been explicitly requested.
>>>>>>>
>>>>>>> In order to make spatch happy in report mode, we also need a
>>>>>>> dummy rule,
>>>>>>> as otherwise it errors out with "No rules apply". Using a 
>>>>>>> script:python
>>>>>>> rule appears unrelated and odd, but this is the shortest I
>>>>>>> could come up
>>>>>>> with.
>>>>>>>
>>>>>>> Adjust scripts/nsdeps accordingly to set the nsdeps rule
>>>>>>> when run trough
>>>>>>> `make nsdeps`.
>>>>>>>
>>>>>>> Suggested-by: Julia Lawall <julia.lawall@inria.fr>
>>>>>>> Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck 
>>>>>>> failed")
>>>>>>> Cc: YueHaibing <yuehaibing@huawei.com>
>>>>>>> Cc: jeyu@kernel.org
>>>>>>> Cc: cocci@systeme.lip6.fr
>>>>>>> Cc: stable@vger.kernel.org
>>>>>>> Signed-off-by: Matthias Maennich <maennich@google.com>
>>>>>>
>>>>>> Acked-by: Julia Lawall <julia.lawall@inria.fr>
>>>>>>
>>>>>> Shuah reported the problem to me, so you could add
>>>>>>
>>>>>> Reported-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>>
>>>>>
>>>>> Very cool. No errors with this patch. Thanks for fixing it
>>>>> quickly.
>>>>
>>>> I am happy I could fix that and thanks for confirming. I assume your
>>>> Tested-by could be added?
>>>
>>> Yes
>>>
>>> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>
>>>> Is somebody willing to take this patch through their tree?
>>>>
>>>
>>> My guess is that these go through kbuild git??
>>
>> If you want to take this, that's fine with me.  But as I had the
>> original file come through my tree, I can take it too.  It's up to you,
>> either is ok with me.
>>
> 
> Great. Please take this through your tree.
> 

Greg! Looks like this one didn't make it in. Can you pick this up?

thanks,
-- Shuah

