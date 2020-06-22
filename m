Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FF7203C50
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 18:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbgFVQOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 12:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbgFVQOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 12:14:36 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C66BC061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 09:14:36 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id d67so16088629oig.6
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 09:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VVaCcZG58WyWvPJ2lYOGRecBDq8B1jl/4gBvyhUrQn8=;
        b=hjOqsA1J9Nge6aShoubXb7xlmkqcvD0u8sQ/uIBCrC8e0bV/fPKVmzQKXoxiz+uH8G
         7zaQSSlnpNs4/FKAMUbEFx657gJcZzY8dAVSe7rNcGm1tEoKepIA1gNYRSHak7eU5pAR
         4AR1Bq0GeXrG+kCCO+BaDcpqAhMClQ+vJiEU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VVaCcZG58WyWvPJ2lYOGRecBDq8B1jl/4gBvyhUrQn8=;
        b=M9SEb9O9n5QHsS7GA+jiCsDKqTvCXK39d6rH6JM7XQfUakEABycr/KsQET9lLFPxqD
         LXuH77JJ1tHw+L1TpLD0jOYGZm4Gyw9mU5mhp+CAcaWX4cfowgdV3WAyzww0rMm7h4Ky
         +NBBrjZwkVoJIGAAU0nVp76Gpz66cetyADlGKiqE/znqYNA7qdAF/WzVxM6GIdIk9dCd
         Bku8aommFqHXV/MHnAn6g/wbryqa9hcnivXYtEjO/3nLrlHTTeuALYI1bZxmAw+/kq9A
         GMlG/dViT5hIpNTQZZ/1AvpXVR4mPEXi83zeRRNbvxuJLtIKwM4iGT/k+3aNg17snoU0
         aSnw==
X-Gm-Message-State: AOAM5312gUETses6ECX5KvH28QRwuVKNIGKRSJ8P2kef8URfoWqBTWx5
        ybFuTn3SuE7K7WHp1BfOJmRnEQ==
X-Google-Smtp-Source: ABdhPJzm8MU3zV30ZHzDJEy4NbsU5cQabBWx/boBq5HyQvshlDpCIao3+byLMx0/z0YzJ18pFAP0XA==
X-Received: by 2002:aca:6008:: with SMTP id u8mr13575129oib.58.1592842475938;
        Mon, 22 Jun 2020 09:14:35 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 35sm3365700otd.68.2020.06.22.09.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 09:14:35 -0700 (PDT)
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
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f09e32dc-8f17-d09a-b2e4-fb4c0699838e@linuxfoundation.org>
Date:   Mon, 22 Jun 2020 10:14:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622150605.GA3828014@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/22/20 9:06 AM, Greg Kroah-Hartman wrote:
> On Mon, Jun 22, 2020 at 08:46:18AM -0600, Shuah Khan wrote:
>> On 6/22/20 2:03 AM, Matthias Maennich wrote:
>>> On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
>>>> On 6/4/20 1:31 PM, Julia Lawall wrote:
>>>>>
>>>>>
>>>>> On Thu, 4 Jun 2020, Matthias Maennich wrote:
>>>>>
>>>>>> When running `make coccicheck` in report mode using the
>>>>>> add_namespace.cocci file, it will fail for files that contain
>>>>>> MODULE_LICENSE. Those match the replacement precondition, but spatch
>>>>>> errors out as virtual.ns is not set.
>>>>>>
>>>>>> In order to fix that, add the virtual rule nsdeps and only
>>>>>> do search and
>>>>>> replace if that rule has been explicitly requested.
>>>>>>
>>>>>> In order to make spatch happy in report mode, we also need a
>>>>>> dummy rule,
>>>>>> as otherwise it errors out with "No rules apply". Using a script:python
>>>>>> rule appears unrelated and odd, but this is the shortest I
>>>>>> could come up
>>>>>> with.
>>>>>>
>>>>>> Adjust scripts/nsdeps accordingly to set the nsdeps rule
>>>>>> when run trough
>>>>>> `make nsdeps`.
>>>>>>
>>>>>> Suggested-by: Julia Lawall <julia.lawall@inria.fr>
>>>>>> Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck failed")
>>>>>> Cc: YueHaibing <yuehaibing@huawei.com>
>>>>>> Cc: jeyu@kernel.org
>>>>>> Cc: cocci@systeme.lip6.fr
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Matthias Maennich <maennich@google.com>
>>>>>
>>>>> Acked-by: Julia Lawall <julia.lawall@inria.fr>
>>>>>
>>>>> Shuah reported the problem to me, so you could add
>>>>>
>>>>> Reported-by: Shuah Khan <skhan@linuxfoundation.org>
>>>>>
>>>>
>>>> Very cool. No errors with this patch. Thanks for fixing it
>>>> quickly.
>>>
>>> I am happy I could fix that and thanks for confirming. I assume your
>>> Tested-by could be added?
>>
>> Yes
>>
>> Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>>>
>>> Is somebody willing to take this patch through their tree?
>>>
>>
>> My guess is that these go through kbuild git??
> 
> If you want to take this, that's fine with me.  But as I had the
> original file come through my tree, I can take it too.  It's up to you,
> either is ok with me.
> 

Great. Please take this through your tree.

thanks,
-- Shuah
