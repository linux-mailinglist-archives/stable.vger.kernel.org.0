Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7F926DE86
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbgIQOh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgIQOfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 10:35:52 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C8CC06178B
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 07:35:01 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h17so2113236otr.1
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 07:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pxmiWVhEehzHd6ZFjD+jJGJKKJXwae5fQoIEeS/lt3A=;
        b=Ur3SSfoKIzOhlMrokNh3d0LSIycelY4+JWEQbg+FShKSXi1LpiZrIq8Jh4xbbyXgDd
         1riseZqUbte0g3wM1FjeXzCiKzQ+SF/TaO3xtljB1N1ABjea15AXAT/WowvxPADy8HkG
         vxAZFY3tX2HddxkEOtUhzsrulM617ykltWnik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pxmiWVhEehzHd6ZFjD+jJGJKKJXwae5fQoIEeS/lt3A=;
        b=Q5ve/p7Yx+NrNySdncGUy0FgMUKE/QTNBjcT9kpU5WalxmnX2VcYqgvmNznyB7WciD
         ftm1tJKzP8IC1xJBwEg+0ORaY70m8moijvq0bLDKZRAQougVoHGCUgk1HCTT24La7zO9
         4khEMR8C2wi0SaP+NnPB9ZASghGwdxeMNeL+rjBS+vq2vs0Xy2W+Z9zXyOwL9cfCYu01
         qCDxlJmWf5nGo5wqvZmASa8AXU7xAejefpImlfz1xRqztlKsOv1H+sve6W/sRVNnBSxW
         TouGPJOg9yCIpt7MwUn4MIZYBfvl1LDiPStQKTg+DzzGI1+fmrWT6BwHgrF02GIpGmyR
         +IQg==
X-Gm-Message-State: AOAM532eKBsRNlGQXAhTyJDBmOsrZS6+vwm2FO95YD+yHYTGehd86LvO
        qCcNB8gH+VUPTZphgp7js9iUKg==
X-Google-Smtp-Source: ABdhPJyEN1ccVTpTrxj/BTLOknlXwp71HLPU26SVjNkxO20a0OqX6zwVNBiACSaugK7UKkzxCQJEKQ==
X-Received: by 2002:a9d:4b99:: with SMTP id k25mr20946151otf.281.1600353300965;
        Thu, 17 Sep 2020 07:35:00 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g7sm4410436otl.59.2020.09.17.07.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 07:35:00 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Prateek Sood <prsood@codeaurora.org>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
 <b94c29b3-ef68-897b-25a8-e6fcc181a22a@linuxfoundation.org>
 <8277900f-d300-79fa-eac7-096686a6fbc3@linuxfoundation.org>
 <20200916062958.GH142621@kroah.com>
 <69e7c908-4332-91fd-bdb2-6be19fcbf126@linuxfoundation.org>
 <20200916152629.GD3018065@kroah.com>
 <09de87b0-8055-26ef-cc31-0c63e63e5d2a@linuxfoundation.org>
 <20200916172529.GA3056792@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9365ff94-2a28-cc5f-7487-a6d8d42de302@linuxfoundation.org>
Date:   Thu, 17 Sep 2020 08:34:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916172529.GA3056792@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/20 11:25 AM, Greg Kroah-Hartman wrote:
> On Wed, Sep 16, 2020 at 09:34:52AM -0600, Shuah Khan wrote:
>> On 9/16/20 9:26 AM, Greg Kroah-Hartman wrote:
>>> On Wed, Sep 16, 2020 at 08:26:48AM -0600, Shuah Khan wrote:
>>>> On 9/16/20 12:29 AM, Greg Kroah-Hartman wrote:
>>>>> On Tue, Sep 15, 2020 at 08:54:24PM -0600, Shuah Khan wrote:
>>>>>> On 9/15/20 3:06 PM, Shuah Khan wrote:
>>>>>>> On 9/15/20 8:11 AM, Greg Kroah-Hartman wrote:
>>>>>>>> This is the start of the stable review cycle for the 5.8.10 release.
>>>>>>>> There are 177 patches in this series, all will be posted as a response
>>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>>> let me know.
>>>>>>>>
>>>>>>>> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
>>>>>>>> Anything received after that time might be too late.
>>>>>>>>
>>>>>>>> The whole patch series can be found in one patch at:
>>>>>>>>        https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
>>>>>>>>
>>>>>>>> or in the git tree and branch at:
>>>>>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>>>>>>> linux-5.8.y
>>>>>>>> and the diffstat can be found below.
>>>>>>>>
>>>>>>>> thanks,
>>>>>>>>
>>>>>>>> greg k-h
>>>>>>>>
>>>>>>>
>>>>>>> Compiled and booted fine. wifi died:
>>>>>>>
>>>>>>> ath10k_pci 0000:02:00.0: could not init core (-110)
>>>>>>> ath10k_pci 0000:02:00.0: could not probe fw (-110)
>>>>>>>
>>>>>>> This is regression from 5.8.9 and 5.9-rc5 works just fine.
>>>>>>>
>>>>>>> I will try to bisect later this evening to see if I can isolate the
>>>>>>> commit.
>>>>>>>
>>>>>>
>>>>>> The following commit is what caused ath10k_pci driver problem
>>>>>> that killed wifi.
>>>>>>
>>>>>> Prateek Sood <prsood@codeaurora.org>
>>>>>>        firmware_loader: fix memory leak for paged buffer
>>>>>>
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.8.y&id=ec0a59266c9c9f46037efd3dcc0323973e102271
>>>>>
>>>>> Ugh, that's not good, is this also a problem in 5.9-rc5 as well?  For
>>>>> reference, this is commit 4965b8cd1bc1 ("firmware_loader: fix memory
>>>>> leak for paged buffer") in Linus's tree.
>>>>>
>>>>
>>>> I am not seeing this on Linux 5.9-rc5 for sure.
>>>>
>>>>> And it should be showing up in 5.4.y at the moment too, as this patch is
>>>>> in that tree right now...
>>>>>
>>>>
>>>> I don't see this patch in  4.19.146-rc1
>>>
>>> It's not there, it's in 5.4.66-rc1, which worked for you somehow, right?
>>>
>>>> Linus's tree works for with this patch in. I compared the two files
>>>> for differences in commit between Linus's tree and 5.8.10-rc1
>>>>
>>>> Couldn't find anything obvious.
>>>
>>> Again, really odd...
>>>
>>> I don't have a problem dropping it, but I should drop it from both 5.4.y
>>> and 5.8.y, right?
>>>
>>
>> Sorry. Yes. Dropping from 5.8 and 5.4 would be great until we figure out
>> why this patch causes problems.
>>
>> I will continue debugging and let you know what I find.
> 

With this it boots and wifi is good for me. I am very puzzled by why
this made a difference to make sure I am not narrowing in on the wrong
patch.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
