Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98AF42C6E5
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 18:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhJMQ5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 12:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbhJMQ5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 12:57:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508AAC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 09:55:28 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t16so12940690eds.9
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 09:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WZlwrMo3M+8vQXR6cl79ydfCu49Alm9meH+iVztLnUc=;
        b=oClBcVnq7kUyqu1Vpty8V9xLQeEZurdtKoZZSLjuIbB8+m+Pk3sGXF3/Wvzo70a8Ds
         zshDiH8Lgpzypf+7lTn6flC0jhzWyflKk0InC3vzOE4ThVF6H9DB4zGdFihjB+m8u+il
         WBLE6usqfwSR11AQQB3ngEq/C5YB8kZXDaHsrDjoLM0ZX6fkgeu1nvlnZRwYtZrY4c++
         vbdFLLA6VKwrLj0bwathcKSYJJZpfmRkAJePvqQ7rA2WWNQ/pVBowounl1rpiyA1CpkU
         /wpyxQ2n8xVMGB5JOnrRXX53dk8QnXsi93GoVJSrlYSzZaTB42QJHAe7SqrCrt6ACwV4
         5MqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WZlwrMo3M+8vQXR6cl79ydfCu49Alm9meH+iVztLnUc=;
        b=nrkVMmUarcK7K0gqIU/V76BsNy9X53nV8OR2pmU2l39vZuEisWdhj0sFaEnMK373T7
         9kPwu+bNd4L7/Gdge6UC2e6zMvqe2NNnOgzHobzT3u1FJIkDnbtMlEL3zQTcOCFtQtT9
         ZC9C172vlI5SWS4TNtLxzSnvV4DHosWzY3C8Q/caaZ4SxrtJ/bHmNJqdhdgFdhDj7BiK
         2o2TfPZ+DYjFlFf05AMq+pZZXDYWO3lKBjtATARbAp+KRgORWsMB2Ggydavs3tTAex3x
         BXFLyTmR5PCloKCr31sp4VbPp2K3BeeUqxzC2I5ZgDzVMWIc8WP5d4V+S24Psn+HIpxR
         /AmQ==
X-Gm-Message-State: AOAM531JWvbFckEdXFj04h8vEwbvPDlxOcDeHQ1yZDzxTRJxgcXlAyzI
        KoAW09yy1mO7n7uW2PzZw4WuqNw75pkgEA==
X-Google-Smtp-Source: ABdhPJweqEImDoaHSOQSAXZTVQOSr+ofvYpStkgVt5ATp5zDlJH8UgXNb5BWu+thpQXdiTKIcl+FIA==
X-Received: by 2002:a17:906:2310:: with SMTP id l16mr455366eja.118.1634144126294;
        Wed, 13 Oct 2021 09:55:26 -0700 (PDT)
Received: from [192.168.178.46] ([213.211.156.121])
        by smtp.gmail.com with ESMTPSA id z1sm123257edc.68.2021.10.13.09.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 09:55:25 -0700 (PDT)
Message-ID: <7759a933-83b9-9e9f-df3b-6fb5888cfaa7@tessares.net>
Date:   Wed, 13 Oct 2021 18:55:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: Use of "Fixes" tag for trivial fixes
Content-Language: en-GB
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <19ffe0d6-f957-135c-cbae-14a0a46f3183@tessares.net>
 <YWcN2+XZ8+h4Jrwr@kroah.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <YWcN2+XZ8+h4Jrwr@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 13/10/2021 18:48, Greg Kroah-Hartman wrote:
> On Wed, Oct 13, 2021 at 04:47:55PM +0200, Matthieu Baerts wrote:
>> Hi Greg, Sasha,
>>
>> First, thank you for your great job maintaining the stable versions!
>>
>> In our work related to MPTCP, we were wondering if we should/can add the
>> "Fixes" tag for trivial/stable fixes.
>>
>> It is certainly easier to explain that with an example: we have a small
>> patch [1] to stop exposing a function that is only used from one .c file
>> and declared there too. So the signature is removed from the .h file and
>> the 'static' keyword is added in the .c file. It should have been like
>> that since the introduction of this function.
>>
>> We don't know if we can/should add the "Fixes" tag for such cases: the
>> "mistake" has been introduced by one specific commit so we could add the
>> "Fixes" tag but we also know patches with such tags are certainly going
>> to be automatically backported. The patch is not really fixing a bug,
>> more a "cleaning". Does it make sense to backport these patches then?
>>
>> On one hand, we might think it would be interesting to backport it to
>> reduce the differences with the last version: if the idea is to backport
>> simple fixes to ease future and maybe more complex backports later. But
>> on the other hand, it is more work for you to backport it: if the idea
>> is to backport only actual bug-fix patches. So what is the preferred policy?
>>
>> We didn't find anything in the doc on "when not to add the 'Fixes' tag"
>> but we know the Stable Kernel Rules doc mentions to avoid trivial fixes.
>> Maybe this patch is not "trivial", it is not really a bug-fix either but
>> that's not the real question here, more: does this rule -- and other
>> ones from Stable Kernel doc -- apply to the "Fixes" tag as well?
> 
> Please use the Fixes: tag whenever you want to.  Having it there does
> NOT mean the patch is automatically backported to stable releases, we
> look at them all and choose if they are valid or not.

Wow, that's a lot of patches to read! :)

> There are lots of tiny "Fixes:" commits that we do not backport for
> obvious reasons that they do not fit the stable kernel requirements.
> 
> If you know a patch should be backported to a stable tree, then put the
>  cc: stable on it, as documented.  Again, "Fixes:" is no guarantee that
> a commit will be backported at all.

Thank you for your reply, that's very clear!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
