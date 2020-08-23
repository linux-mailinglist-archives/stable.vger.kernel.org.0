Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D33C24EFC0
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 22:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgHWU5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 16:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgHWU5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 16:57:17 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219B0C061573
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 13:57:17 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so3244487plt.3
        for <stable@vger.kernel.org>; Sun, 23 Aug 2020 13:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o7jk5hj99z/ZW8lA4yke5NQO1f1PEATc2IjL4V7LiEQ=;
        b=nrQ/dxb2PcPzvZXPeu60H6f3nfjJLIngalECmEc54pOfRTpqqDddqzHmWK50H5iJXa
         gfmdiAyDQ/p/Yi9N7/4vWxqYKSOs3LOrPX2rkpXZoOrE/V2ul4n86t9P3lFmcA3AF3fY
         wYbopLRboSTIfHPV9h/MsTK90wx8U5gvCXiwyJGBP+pq+aZxHK3F0GzN8L7eulskJfwh
         BIVYmFLN3Rj69GVYnELJ57NiRStzEQjCCTUzjSueu0hokcWTi570mLnZT8TVI3l5BVhD
         7w7hB3Sf3Qu/GzMKLRiIOL/G7rZGwoOLEJeFLCaD2zPwXS42pCL+92XAGTk/AMPPXL56
         PVQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o7jk5hj99z/ZW8lA4yke5NQO1f1PEATc2IjL4V7LiEQ=;
        b=fJta1gJQJp+6Ir+vHytFV94i+ELtKs3MrOzfZQpLRtu8mQamplwAVP8KSwFBBQYmPX
         OuS8pOUgFztlRZmPYI+GBL8gjkdFhN8SIJUSHiP0+o5LcGwzbvVU9MhH3VMtdxFPtWyn
         R7M/lqul2Ex96o6ETC2Q4Fhw5AwRx8wM6sDk895xnOjSxEM3MV5VjnAxVOAaALltRtoX
         qr08VWURoJcnrz0WXI7F1xnxTsRP1jF3gwjb6ujMJ3nvTSINyUWa/DIJ/uqkkKfnQGcK
         6kzjMGexp6quReFDSNVZABMub7N/2CdeYssNMysZjqYESmu/8s6WiGggW7fyCdQq96az
         pU+Q==
X-Gm-Message-State: AOAM532l1APeRLavOj6wKQ8XSjTqggt2p+xuE+VoDSotlyzhRMzzHjMk
        sElM19HsKGGNQkyrI62LHvv1xWMwiT5cHvmF
X-Google-Smtp-Source: ABdhPJzRlpxxtmQRgtTroQi6C07ddl2PPE72sx8XNq1LEYSk2VGlMFs6IvaDDawc7OXbBbeamqcgoQ==
X-Received: by 2002:a17:90a:de89:: with SMTP id n9mr2055028pjv.50.1598216236219;
        Sun, 23 Aug 2020 13:57:16 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x23sm8861711pfi.60.2020.08.23.13.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Aug 2020 13:57:15 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: find and cancel head link async
 work on files exit" failed to apply to 5.7-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, asml.silence@gmail.com,
        stable@vger.kernel.org
References: <159818496684216@kroah.com>
 <5e0d43b1-f2ed-3faa-cb30-8cacd5f16faa@kernel.dk>
 <fcf3384c-956e-8310-d0d6-1ac8e1f66ebe@kernel.dk>
 <20200823204309.GF8670@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <16861aa9-463f-b7c2-0de5-2f9bf3b32fa1@kernel.dk>
Date:   Sun, 23 Aug 2020 14:57:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200823204309.GF8670@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/23/20 2:43 PM, Sasha Levin wrote:
> On Sun, Aug 23, 2020 at 02:04:25PM -0600, Jens Axboe wrote:
>> On 8/23/20 7:48 AM, Jens Axboe wrote:
>>> On 8/23/20 6:16 AM, gregkh@linuxfoundation.org wrote:
>>>>
>>>> The patch below does not apply to the 5.7-stable tree.
>>>> If someone wants it applied there, or to any other stable or longterm
>>>> tree, then please email the backport, including the original git commit
>>>> id to <stable@vger.kernel.org>.
>>>
>>> This needs this one backported:
>>>
>>> commit 4f26bda1522c35d2701fc219368c7101c17005c1
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Mon Jun 15 10:24:03 2020 +0300
>>>
>>>     io-wq: add an option to cancel all matched reqs
>>>
>>> I'll take a look later today, unless Pavel beats me to it.
>>
>> OK, you just need to cherry pick this one:
>>
>> commit f4c2665e33f48904f2766d644df33fb3fd54b5ec
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Mon Jun 15 10:24:02 2020 +0300
>>
>>    io-wq: reorder cancellation pending -> running
>>
>> and then cherry pick this one:
>>
>> commit 4f26bda1522c35d2701fc219368c7101c17005c1
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Mon Jun 15 10:24:03 2020 +0300
>>
>>    io-wq: add an option to cancel all matched reqs
>>
>> and then the patch will apply directly without needing any sort of
>> massaging. Looking at that series, please pick this one as well (either
>> at the end, or after the first two):
>>
>> commit 44e728b8aae0bb6d4229129083974f9dea43f50b
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Mon Jun 15 10:24:04 2020 +0300
>>
>>    io_uring: cancel all task's requests on exit
> 
> Done, thanks!

Thanks Sasha!

-- 
Jens Axboe

