Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15B71EEC28
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 22:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgFDUjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 16:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbgFDUjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 16:39:21 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D4C08C5C1
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 13:39:20 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m2so5837603otr.12
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 13:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n4qcFbrYrQboDsoGvWR4IKKjkBw2HOoEx50CuF4/sRg=;
        b=X+1urrchhlAJ6Ly5eKLEwlLZBlos/tPMbW2qcDX2ccbNN0J0XQByplLqMfeDaRcNHQ
         EvnZLIGtALIexNJWE7WZhaFK5yQsyRt8/i1DxNLSpK+1LzHPWpUKOETN1BYjFdCjB+Vl
         /AP5kdUUtAL9HKi1PmPBX5OXwcuOL94Gi6dhk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n4qcFbrYrQboDsoGvWR4IKKjkBw2HOoEx50CuF4/sRg=;
        b=IxgNqkpINIBQiyA/X/NND4bkShTjaaaN0iTlKZuH0ky2IOkY6zHylUszOO7dRLEHVE
         qIpFwU3GRA8hQYnuHtYMUNiaUOg3x1+ICLV7NKuA1ahGesIrw0xhRTw4iYTpUZG1vBiF
         ka8IBa5agPnikjd9ygviQi8Z0PuCIKiz6MdLYIS69fHwMw9YKCMIzgBcQZd0lNHclqer
         2HoTuHmuu3hV/jOtN+Sl34/uCx1WOwxUR98gMUVFfO3DZ30KfK+tnyGHbL5izKVROE7W
         UdHvuQr/FQYZGQEaxKSnqt+i75kVOWqEQPgnsns7amOmPyhBwrrY/Q9eVpnggcRKIWOt
         xDpg==
X-Gm-Message-State: AOAM531fGw6mVIpPXirxMBIOvWpQJ3l8T1eL3bSbRwGbLfD2n8Eh8bgy
        P41Cod8ParFf/GMk9RqAws4vuw==
X-Google-Smtp-Source: ABdhPJy7AdFjBepNhW8xq/grKYoy25Pw+/agwirtqSpnQR9W3AmaDRAKSPoazBhBoL3dX678SmP4sw==
X-Received: by 2002:a9d:7f8c:: with SMTP id t12mr2603935otp.66.1591303160057;
        Thu, 04 Jun 2020 13:39:20 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id f2sm1527259otc.45.2020.06.04.13.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 13:39:19 -0700 (PDT)
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
To:     Julia Lawall <julia.lawall@inria.fr>,
        Matthias Maennich <maennich@google.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20200604164145.173925-1-maennich@google.com>
 <alpine.DEB.2.21.2006042130080.2577@hadrien>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
Date:   Thu, 4 Jun 2020 14:39:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.2006042130080.2577@hadrien>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/4/20 1:31 PM, Julia Lawall wrote:
> 
> 
> On Thu, 4 Jun 2020, Matthias Maennich wrote:
> 
>> When running `make coccicheck` in report mode using the
>> add_namespace.cocci file, it will fail for files that contain
>> MODULE_LICENSE. Those match the replacement precondition, but spatch
>> errors out as virtual.ns is not set.
>>
>> In order to fix that, add the virtual rule nsdeps and only do search and
>> replace if that rule has been explicitly requested.
>>
>> In order to make spatch happy in report mode, we also need a dummy rule,
>> as otherwise it errors out with "No rules apply". Using a script:python
>> rule appears unrelated and odd, but this is the shortest I could come up
>> with.
>>
>> Adjust scripts/nsdeps accordingly to set the nsdeps rule when run trough
>> `make nsdeps`.
>>
>> Suggested-by: Julia Lawall <julia.lawall@inria.fr>
>> Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck failed")
>> Cc: YueHaibing <yuehaibing@huawei.com>
>> Cc: jeyu@kernel.org
>> Cc: cocci@systeme.lip6.fr
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Matthias Maennich <maennich@google.com>
> 
> Acked-by: Julia Lawall <julia.lawall@inria.fr>
> 
> Shuah reported the problem to me, so you could add
> 
> Reported-by: Shuah Khan <skhan@linuxfoundation.org>
> 

Very cool. No errors with this patch. Thanks for fixing it
quickly.

thanks,
-- Shuah



