Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260694697A3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 15:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244722AbhLFOD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 09:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbhLFOD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 09:03:29 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E2BC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 06:00:00 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id b40so25478064lfv.10
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 06:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QBylkiaxKcNZK673+ObQDiEOaHM4rEf/KTzn1jf8WUI=;
        b=oLI5KVrQX1zW6RamUv55yMr8OD+rL4YBX/e+MK3JEbGfGu3BO54B9RsGwBIKDSZrdI
         usNMTGnukFB6MOssA42lE8dJG0oMfT7BHq001/lFQ2VA4vLb6WMGepqH6+VzwXryKw+q
         rYwTSRXKxsCLKBbblX6+/+kqE218DrP/B7dkV362fsH7QghMrTe894+nShE9gbHltgdG
         XlD3VuNo0H6z0ABqA0E01RBe0o3NbdNJaaOR1cSkicXKUINV1oXg/ImLSVKu8XpEt8P4
         u2a2G627czxIjB4vMnkdf0GXP+zVqQChVn2053GYTWlDzirhdEMYjTNB8hlIZc77EvRV
         DNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QBylkiaxKcNZK673+ObQDiEOaHM4rEf/KTzn1jf8WUI=;
        b=jnjDz01KFWKn3AJYNm65QUSmAsrwP0thSekt/2puWT6rD346Kcz92oNyjXRjE91v4Y
         hMeUEagjPmsiqq5m+47cxJRAyuifK+IEBfM0mLrK0jsnJnhUPW20XZMeLUbKwQxh7we9
         Ufboh3i24YbhgTVf0jm/t/1uYMSxYwtZwPUPOH8WRB2GrasAduX+82wtzC1qaokmVm07
         mfeC/CXqRvVr6mcgwGCuoSTgiP3PqC84vfc19AyDcgUgRI1ZtJqCkaiispk0NUYoX879
         uimYADgOpkuBjbC4njZ5w6KXr5tTLsrY2Ps3kkXd+jdf5ekfLXFrjYXl9ovJZ0jsGyKd
         f8KQ==
X-Gm-Message-State: AOAM53027XoekJiZnTk9BxJc7qjB4fMnhSOMok1uBRaumQgIw/Lsz4qX
        AaSgmibyvMvJ5FjWKnZwNFkI7/hfDyY1QA==
X-Google-Smtp-Source: ABdhPJxhTdxzdx7uuR52FcaNhev/13jsnFJ6z9Sc160elLK3Qqn3EyDObUXDcz95M0xF/AxEn0+e4A==
X-Received: by 2002:ac2:4c4d:: with SMTP id o13mr34510886lfk.196.1638799198577;
        Mon, 06 Dec 2021 05:59:58 -0800 (PST)
Received: from [213.112.1.193] (c-51aad954.51034-0-757473696b74.bbcust.telenor.se. [213.112.1.193])
        by smtp.gmail.com with ESMTPSA id y11sm1430763ljh.54.2021.12.06.05.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 05:59:58 -0800 (PST)
Message-ID: <ba94ea3b-c2df-9ddb-1074-d6b58389a686@gmail.com>
Date:   Mon, 6 Dec 2021 14:59:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Could the fix for broken gcc-plugins with gcc-11 be backported to
 5.10?
Content-Language: en-GB
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, keescook@chromium.org
References: <a11f5d22-658c-44e9-51ab-d39c5e8776da@gmail.com>
 <Ya4KYD9lpKaQI9G7@kroah.com> <dbf6b329-03ae-fc92-80a6-8f80d88e28cf@gmail.com>
 <Ya4PqyRnxqB+5VaV@kroah.com>
From:   Thomas Lindroth <thomas.lindroth@gmail.com>
In-Reply-To: <Ya4PqyRnxqB+5VaV@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/6/21 14:27, Greg KH wrote:
> On Mon, Dec 06, 2021 at 02:24:29PM +0100, Thomas Lindroth wrote:
>> On 12/6/21 14:04, Greg KH wrote:
>>> On Mon, Dec 06, 2021 at 01:59:31PM +0100, Thomas Lindroth wrote:
>>>> Build support for gcc-plugins are not detected with gcc-11 in lts kernels.
>>>> Gentoo and Arch apply their own patch to fix the problem in their distribution
>>>> kernels but I would prefer if a proper fix was applied upstream.
>>>>
>>>> https://bugs.gentoo.org/814200 a gentoo report with the relevant info.
>>>>
>>>> I've searched for any upstream discussions about the problem but I've only found
>>>> one message saying the backport needs an additional fix. That was almost a year
>>>> ago. https://www.spinics.net/lists/stable/msg438000.html
>>>
>>> We can not take a patch in a stable kernel release unless it is already
>>> in Linus's tree.  Please work to get a patch accepted there first,
>>> before worrying about older kernel versions.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> The problem was fixed in Linus tree in commit 67a5a68013056cbcf0a647e36cb6f4622fb6a470
>> "gcc-plugins: fix gcc 11 indigestion with plugins..." added in v5.11
>>
>> That's the patch that needed some kind of additional fix before it could be backported
>> but that fix never materialized.
> 
> If you have a working version, based on a distro's use, please provide
> it and I will be glad to pick it up.
> 
> thanks,
> 
> greg k-h
> 

https://dev.gentoo.org/~mpagano/genpatches/trunk/5.10/2910_fix-gcc-detection-method.patch

Here is the patch gentoo applies to 5.10. It seems to be a combination of two upstream
commits:
67a5a68013056cbcf0a647e36cb6f4622fb6a470 "gcc-plugins: fix gcc 11 indigestion with plugins..."
1e860048c53ee77ee9870dcce94847a28544b753 "gcc-plugins: simplify GCC plugin-dev capability test"

I can't vouch for the correctness of that fix. I'm just a regular user who stumbled upon this
problem and found that gentoo bug report. Check with Kees Cook for that "additional fix". I
don't know what fix that is.

/Thomas Lindroth
