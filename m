Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8926CD978C
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405818AbfJPQhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 12:37:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40407 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405761AbfJPQhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 12:37:40 -0400
Received: by mail-io1-f66.google.com with SMTP id h144so54577370iof.7
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 09:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tl84kbahIecZLsyXD6tiRxeMB+dpQzETQPNOO4al72o=;
        b=cAY8V42iHjmJNCQKoTsqLEi1OIhmyasfLWN4sje6hD/eKPFTRjOrThirM3ZJQlQ5p9
         PHWmNV2LaVf3Mw8PSP0+iIvTOlqYNa4Mw/EysAkwTmD5NMmyF0GR89HwJ/7zEod/ltjy
         FQ832Hf+2pVw0fqnGajW+PE/xR9ZkWwv5eYD9pE+0bUteDSWo8AXMrjUEoqFeB+XE85k
         VRybSDDTM3goOxpOJflDmmjzhelgeGCLFBf61Tx1AzKYebm0C0VtiykkyunPaVDu9jSJ
         pCFyUyNd/V3dEVZTPKP5mem5xzYVUrsQZBaNU/+4wQs+80k7CAJLOsKDVybJIaRqBUs/
         gN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tl84kbahIecZLsyXD6tiRxeMB+dpQzETQPNOO4al72o=;
        b=ZwrnVnz7aadvnP58gnZwZzjqxubYRiL9WeJ5PTIoRnw/1khQDQDL5eklVQ+q5Y4MZA
         Wcwi7EgI1B/3yXSfe0JipYQy87RuSnVq3JrwHIkaUoNzEtcWx0msPNfKPHpznas2OYiv
         IOjd7hYtwlWkziXFubWxtd5FB4LxJ4xzAI1PiO6nk8FXZ2bdYqfCcg28eQ1c8oFdVEW8
         59VHKSHyQQ3UJr07idKsIfnGuE1+t4sgs+6eAqquYAENpYsIxBUmRHmqmvP4u7tEL4Ax
         B4poameN6setgrRSgoBs3VQVWqXKXIemCi1OlyF2aPojHQX9TTVAnCGTCKKBD1HEpDIt
         JoKA==
X-Gm-Message-State: APjAAAW82PCVv6MEz1O/X24qh7jLH+pJa0jaQLLKREZeikWasV8dvqrA
        iK5vrnQPw/T9zhK2ZJy73u5wncFDyqI6Aw==
X-Google-Smtp-Source: APXvYqxavOKZJB/om0qUk4Ri/9gAcQhpI+eqIh/S8f22aKYXZVg/8SV6WqMTVViv0lirn9Ilkxrplw==
X-Received: by 2002:a5d:8f8e:: with SMTP id l14mr27863872iol.107.1571243858805;
        Wed, 16 Oct 2019 09:37:38 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n10sm5403146ilh.53.2019.10.16.09.37.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 09:37:37 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: only flush workqueues on fileset
 removal" failed to apply to 5.3-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stefanha@redhat.com, stable@vger.kernel.org
References: <1571241883130167@kroah.com> <20191016161320.GC441788@kroah.com>
 <3a044404-f84e-992a-ff2d-6d35aa4bddf2@kernel.dk>
 <20191016163319.GA506416@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ad17c4ef-1786-0b3b-66a4-14c7ce9445c3@kernel.dk>
Date:   Wed, 16 Oct 2019 10:37:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016163319.GA506416@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/19 10:33 AM, Greg KH wrote:
> On Wed, Oct 16, 2019 at 10:20:16AM -0600, Jens Axboe wrote:
>> On 10/16/19 10:13 AM, Greg KH wrote:
>>> On Wed, Oct 16, 2019 at 09:04:43AM -0700, gregkh@linuxfoundation.org wrote:
>>>>
>>>> The patch below does not apply to the 5.3-stable tree.
>>>> If someone wants it applied there, or to any other stable or longterm
>>>> tree, then please email the backport, including the original git commit
>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> ------------------ original commit in Linus's tree ------------------
>>>>
>>>> >From 8a99734081775c012a4a6c442fdef0379fe52bdf Mon Sep 17 00:00:00 2001
>>>> From: Jens Axboe <axboe@kernel.dk>
>>>> Date: Wed, 9 Oct 2019 14:40:13 -0600
>>>> Subject: [PATCH] io_uring: only flush workqueues on fileset removal
>>>>
>>>> We should not remove the workqueue, we just need to ensure that the
>>>> workqueues are synced. The workqueues are torn down on ctx removal.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 6b06314c47e1 ("io_uring: add file set registration")
>>>> Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index ceb3497bdd2a..2c44648217bd 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -2866,8 +2866,12 @@ static void io_finish_async(struct io_ring_ctx *ctx)
>>>>    static void io_destruct_skb(struct sk_buff *skb)
>>>>    {
>>>>    	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
>>>> +	int i;
>>>> +
>>>> +	for (i = 0; i < ARRAY_SIZE(ctx->sqo_wq); i++)
>>>> +		if (ctx->sqo_wq[i])
>>>> +			flush_workqueue(ctx->sqo_wq[i]);
>>>>    
>>>> -	io_finish_async(ctx);
>>>>    	unix_destruct_scm(skb);
>>>>    }
>>>>    
>>>>
>>>
>>> This fails to build as sqo_wq is a pointer in 5.3, not an arrary.
>>> Backporting that array change feels "big" for 5.3, is that needed here,
>>> or can this be fixed differently?
>>
>> Yeah, we don't need to do that. It's just a pointer in 5.3, not an
>> array of pointers, so the below should be all we need for 5.3 (and
>> 5.2/5.1).
> 
> 5.2/5.1 are long end-of-life, but this change looks sane.  I'll go queue
> it up for 5.3.y, thanks for the patch!

Thanks Greg!

-- 
Jens Axboe

