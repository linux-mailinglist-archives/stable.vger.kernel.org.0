Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341E41588DF
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 04:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBKDhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 22:37:15 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38710 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbgBKDhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 22:37:15 -0500
Received: by mail-pl1-f193.google.com with SMTP id t6so3668610plj.5
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 19:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5U8eonzHnPyuSZmb4Nh8pGNJikDrslUEBB9el0Q2uPI=;
        b=XMyHcyr/+66QBrfROAwjk7bKo+9XytwKT1MJD9FTGxzBnL7eWxaNfljBAdaD7tr/Kt
         lh5BPJBMMxCD5RiOeoMiZ7f/8xuji1zNIsrjG2SUD4lDBEvIvO5rdRp2i4gjVMUatMLD
         vChaJogZwzziGgzE9KlfFCzl4vRkBiSXZqygIEarzFfzdtMUZ84OEW6JKWMcv86EKmAB
         wbl/quW21dHP95ktuFYjcB9BeP4vYhFxfK93ykxKDCFbwCegs5mSRqh/IYEfyBCRhIF3
         rMqTIlM3ILv9a9KCx522fKE5evjekVrPmqwC4CNQSRWK870vXNuEh9BoMF/6pyEIU73Y
         xmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5U8eonzHnPyuSZmb4Nh8pGNJikDrslUEBB9el0Q2uPI=;
        b=kfukPuWRB/wAps5OmpKyTnS5tGi62fiX54J3JaT76FSYbYg2ReYsaXwJSZ56gdJEph
         pvbyZAqtCpnUUZkyT1h2h5UUx+jBwoGoFHFgoTV7lAEHjZhVJGOjucIxb0+s+RoyzIGQ
         IfhH4uMmcvQldefK9Ny04loSlfdTCEkFeObtJm878/jaduRFCSxTfk0mq6TlCITcU0Ul
         VP3nauv66DpvJ+WMCDtVw9s5fzV9aPGbF7FEXk4FfLpe+TOVpzPQLhXxbsBhRQZalRCZ
         wadgMdj/sc4gksSlevhdXKydHOt0MDTUrlyvlxVAYl5xCnEkzmqB19jVnHkfiduoBlcc
         AF0g==
X-Gm-Message-State: APjAAAU6VdulLGi7VgAna5pH4hWxiBa6r26d6ABAUjmFmNosLSBBsVtB
        W9U6yZYH5ZKP3/p+093L48oMOvkscO4=
X-Google-Smtp-Source: APXvYqws6SlCTI0DAXP+vk6uoWxC4fodrQ8SHhJVR22lENfeTJAD0VSOE6kxQQ/w8VhqHo9UQDMuaw==
X-Received: by 2002:a17:90a:23e5:: with SMTP id g92mr2881592pje.14.1581392232852;
        Mon, 10 Feb 2020 19:37:12 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b1sm1912562pfp.44.2020.02.10.19.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 19:37:12 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io_uring: prevent potential eventfd
 recursion on poll" failed to apply to 5.5-stable tree
To:     Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <158124917113830@kroah.com> <20200209183345.GP3584@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0de57b7-036e-bb24-f01f-4e9ff1284800@kernel.dk>
Date:   Mon, 10 Feb 2020 20:37:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200209183345.GP3584@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/20 11:33 AM, Sasha Levin wrote:
> On Sun, Feb 09, 2020 at 12:52:51PM +0100, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.5-stable tree.
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
>>From f0b493e6b9a8959356983f57112229e69c2f7b8c Mon Sep 17 00:00:00 2001
>> From: Jens Axboe <axboe@kernel.dk>
>> Date: Sat, 1 Feb 2020 21:30:11 -0700
>> Subject: [PATCH] io_uring: prevent potential eventfd recursion on poll
>>
>> If we have nested or circular eventfd wakeups, then we can deadlock if
>> we run them inline from our poll waitqueue wakeup handler. It's also
>> possible to have very long chains of notifications, to the extent where
>> we could risk blowing the stack.
>>
>> Check the eventfd recursion count before calling eventfd_signal(). If
>> it's non-zero, then punt the signaling to async context. This is always
>> safe, as it takes us out-of-line in terms of stack and locking context.
>>
>> Cc: stable@vger.kernel.org # 5.1+
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> I queued it back to 5.5 by taking f2842ab5b72d ("io_uring: enable option
> to only trigger eventfd for async completions") and working around
> missing commit 69b3e546139a ("io_uring: change io_ring_ctx bool fields
> into bit fields"). However, 5.4 is a bit more complex than what I can
> tackle without a test suite.
> 
> Jens, is there something I can run to validate io_uring on older
> kernels?

liburing has a set of regression tests, but unfortunately mostly tailored
to the current kernel, though stable should hopefully pass if we have
everything we need backported! I can try and stake a stab at the backport
too, I'll have more later in this round anyway...

-- 
Jens Axboe

