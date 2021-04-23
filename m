Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F15369B0F
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhDWUAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 16:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhDWUAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 16:00:01 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B80C06174A
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 12:59:20 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so41203329otf.12
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 12:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6iSj1GEtiQZ9M3J3gU3b18A/HnutzEB33d+sPDU4Lh8=;
        b=SJ8vF1y2bTXYd0n1OQqCrR7Ho4O0E73Bs06P2PO565GjWwKCv0WY4tFVg+wJD7TFl+
         HWhODvTnqJuTk6raOtlb3z5elNi4p5gFd3kk8P18d3G7o9b0TuTcN8q6dW2rvp4+a6V/
         VoyMaSy+OqXELodgymwdwEAqt8UL8y03/sUMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6iSj1GEtiQZ9M3J3gU3b18A/HnutzEB33d+sPDU4Lh8=;
        b=AjEOVn0smslgRVtsCCFUy26Eqquqm7wr7/eNOrD5cznWT7SM9i47HLO4U10ehxQ8tK
         k9IrR9i3HLbx20DrGO44WTg+6HllZVgnNUkQwgOevrtj8Sl04IKDhAhTK7ou2sibbP9R
         ZfbKBBrl/+oo+nEOshU1gGkETCx4vV+jQdfDdYgLsoUJX4lIenP3Xu3DRR56NhV6S0ME
         XXoyzJD9LkjmaYa3rHNKtWu8OKi0YsQNIbCAqhsrpDhivct4XifKw3yicwRJZeYl2zDU
         uTinlnzYJEJLaq775xtGwjMYV0RAfZms9LLUqRZSBqK+rcq0VeZbu+w4Hyz6QE1Xj6AE
         5I8A==
X-Gm-Message-State: AOAM532WldZr7HfV7mAbXbX+UMig0e5NKzRV9o+pGzlqDB+5IvSh4zrF
        55PKMYRv+TOxvobU2BiulCoAyw==
X-Google-Smtp-Source: ABdhPJwX8YGq8nYTFV90MV99op+N+/Biz8iVr0qFLYrq2bD1vaPBV3E8YodsM1UucQom0nGyS/4OnQ==
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr4742403ota.27.1619207960033;
        Fri, 23 Apr 2021 12:59:20 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s19sm1574723otq.6.2021.04.23.12.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 12:59:19 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] usbip: vudc synchronize sysfs code paths"
 failed to apply to 4.14-stable tree
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, Tom Seewald <tseewald@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <161812561233164@kroah.com> <YIMjud72SYv5t5tt@debian>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5a668128-93ff-8e77-f595-dea0c8233d58@linuxfoundation.org>
Date:   Fri, 23 Apr 2021 13:59:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YIMjud72SYv5t5tt@debian>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/23/21 1:44 PM, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Apr 11, 2021 at 09:20:12AM +0200, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 4.14-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>>  From bd8b82042269a95db48074b8bb400678dbac1815 Mon Sep 17 00:00:00 2001
> 
> Just wondering if you have missed this one as I am not seeing it in your
> queue for 4.14-stable but can see in 4.9-stable queue. And this will apply
> directly on top of your 4.14-stable queue.
> 
> 
This patch needed some work. Tom sent in the patch.

https://lore.kernel.org/stable/d2cc4517-4790-b3a7-eec0-16fe06ea22eb@linuxfoundation.org/

thanks,
-- Shuah

