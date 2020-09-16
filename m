Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1844726C8CD
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 20:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgIPS5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 14:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727527AbgIPRxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:53:11 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07849C002173
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 07:26:51 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o8so6887832otl.4
        for <stable@vger.kernel.org>; Wed, 16 Sep 2020 07:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2D1OU8amju4lA0O/9NcGkhPyv8OEovj+wikjkwIUt7Q=;
        b=NGIGTUJ+Wm5tSYmyZhgb9P/mhMA1R8QbZFRuug43BZhiSWrANJuChB9zWZgolQqvWU
         hT66ohFQqpnV3xk3AsC7wdbXmRJ7ZWkbZ1+lqkpD15+sAW7XR/cojjrNRzzh7n2vI3uo
         7WeHkQQ1kMRJzu+ksCwVk/iFtucpSsLIFIYks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2D1OU8amju4lA0O/9NcGkhPyv8OEovj+wikjkwIUt7Q=;
        b=Gw5j+0Iag4dmN6cB86Ql3Ciq7w3tuelGIBWkcFwk3D6wMBV+pAfWEU+Z0YOVNcQ/YX
         uQ+2XgK64pfDi+yJ1fj4LPIjNKdWKNiJY9niKVb6QRDyRnS2lsPlo0+X2NwtshFUJuWp
         IUuXppeC90Sub6zgIdd9yPwxNNvaW+Dh/Sy8tveG5jJ8FhH9D2Xy4KC0BVOvZ6rpd5vQ
         q+Q6+CNj1IU9/9Mv7LlIBankEbupE3SpRf1o7MPVSPM2wyrdU4vrDGBy/BKtrxpDp4kl
         6y0AusftJ2gCubos9GMYDTZc4WNUN1R8QAXzZ0R/JOHTbjRLCNPxsq9k14p9dYVbHFJI
         jTnA==
X-Gm-Message-State: AOAM531uNtupoJOup5dVY0/K8R26IQjsUHjztpCSOQiM12mRHyjG2FTp
        n+RoPFOfKSONN8bsGutE2oaIUTj+URdv+g==
X-Google-Smtp-Source: ABdhPJwMz+cTRB/ole33O3az2A9OpsPjAFMkCBENa1ojUIpGBpjTHA4NjGEW2ki+PP7UlxYbEvF/8Q==
X-Received: by 2002:a9d:7c7:: with SMTP id 65mr17220499oto.268.1600266411163;
        Wed, 16 Sep 2020 07:26:51 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l3sm8293920oth.36.2020.09.16.07.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 07:26:50 -0700 (PDT)
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Prateek Sood <prsood@codeaurora.org>,
        Takashi Iwai <tiwai@suse.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
 <b94c29b3-ef68-897b-25a8-e6fcc181a22a@linuxfoundation.org>
 <8277900f-d300-79fa-eac7-096686a6fbc3@linuxfoundation.org>
 <20200916062958.GH142621@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <69e7c908-4332-91fd-bdb2-6be19fcbf126@linuxfoundation.org>
Date:   Wed, 16 Sep 2020 08:26:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916062958.GH142621@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/16/20 12:29 AM, Greg Kroah-Hartman wrote:
> On Tue, Sep 15, 2020 at 08:54:24PM -0600, Shuah Khan wrote:
>> On 9/15/20 3:06 PM, Shuah Khan wrote:
>>> On 9/15/20 8:11 AM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.8.10 release.
>>>> There are 177 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
>>>>
>>>> or in the git tree and branch at:
>>>>      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>>>> linux-5.8.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> Compiled and booted fine. wifi died:
>>>
>>> ath10k_pci 0000:02:00.0: could not init core (-110)
>>> ath10k_pci 0000:02:00.0: could not probe fw (-110)
>>>
>>> This is regression from 5.8.9 and 5.9-rc5 works just fine.
>>>
>>> I will try to bisect later this evening to see if I can isolate the
>>> commit.
>>>
>>
>> The following commit is what caused ath10k_pci driver problem
>> that killed wifi.
>>
>> Prateek Sood <prsood@codeaurora.org>
>>      firmware_loader: fix memory leak for paged buffer
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.8.y&id=ec0a59266c9c9f46037efd3dcc0323973e102271
> 
> Ugh, that's not good, is this also a problem in 5.9-rc5 as well?  For
> reference, this is commit 4965b8cd1bc1 ("firmware_loader: fix memory
> leak for paged buffer") in Linus's tree.
> 

I am not seeing this on Linux 5.9-rc5 for sure.

> And it should be showing up in 5.4.y at the moment too, as this patch is
> in that tree right now...
> 

I don't see this patch in  4.19.146-rc1

Linus's tree works for with this patch in. I compared the two files
for differences in commit between Linus's tree and 5.8.10-rc1

Couldn't find anything obvious.

thanks,
-- Shuah



