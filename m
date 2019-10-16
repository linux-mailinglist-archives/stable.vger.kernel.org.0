Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597B0D96F9
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 18:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388413AbfJPQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 12:20:20 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:38104 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733190AbfJPQUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Oct 2019 12:20:20 -0400
Received: by mail-il1-f196.google.com with SMTP id y5so3220515ilb.5
        for <stable@vger.kernel.org>; Wed, 16 Oct 2019 09:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YFLh1d9BlryR2ckUlkJhg9OaG9WasE5z+qyn+rTi6rM=;
        b=CK89vMyz09mnBbNl4KKK0xEGvWj9p31Rahb44OiTa6nxCQunu965eA57OHRC8UXJYa
         0ORp+Oc/ibgZQYdu9NqMKEeejIt+3bvT+yF11N3g/OtDrLdUHycMG6I4+lYMkoThFPxW
         wSHghytNIso2cs3SkYzlY710ngSouyyOlIH2s/CouQ7TJQthrgDViGUT09NEG2LI8ZEk
         PzM9UnF3lESWYXhPufcnFhmKSlMi/Z0qNuSySFJ1XQ7jCjKc7v3XEovLX8Fs0WKAQD56
         pM2qvHclMpbgR9RknHobj5kqA/yF++Y5jdcVhXAf/vbPCftZ4+EaNXFtg4gU5CdxJp/B
         RGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YFLh1d9BlryR2ckUlkJhg9OaG9WasE5z+qyn+rTi6rM=;
        b=UPUMW4EJo/Xj3IY4ExV84MgiQ2rwdlgNqd5X40r9Krl2AoBGgrb/7nySMOMxZB663m
         mQpqQWi/QLt9mgAmwwVbNWg44ZEnOZmXvbwXrpXnxsOhXXYpp6PnIpLuk66MPNkSnZUC
         KnhKeWXyDL79oMnNeB9wHldUjQxinSfrEf5WXNPEhPRypF4pxB3Pwm4/jBf+PeKMONfc
         DHFxWU2mA5e6FWq75SF01LlU1NNpGijen5Q8ACeIMGNAjpTOKRZhnBqCvtAnkaAXw9F+
         UwrO4n1fDWwXT3SjmbpC66YFrheBuRcWwP/stnbdWdE108NgR8wWOEoVnuWBXtjmnGNH
         KStg==
X-Gm-Message-State: APjAAAUxxcCQU23LASbIPOklG23jFA5PJ8g/PdC46E5e+ZgSnWyM8jY/
        sFcfdZciJc+tFAk+SJYh+J1zhVqrHH1lxw==
X-Google-Smtp-Source: APXvYqymShPLaD6M8YuxePuTFKYLcrj7YYSh03bpM52AoJKD7HGTwYC/iukxcEpid+IqE5KIxMFxpg==
X-Received: by 2002:a92:ce41:: with SMTP id a1mr13523502ilr.107.1571242818383;
        Wed, 16 Oct 2019 09:20:18 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n78sm5197441ila.81.2019.10.16.09.20.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 09:20:17 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: only flush workqueues on fileset
 removal" failed to apply to 5.3-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>, stefanha@redhat.com
Cc:     stable@vger.kernel.org
References: <1571241883130167@kroah.com> <20191016161320.GC441788@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a044404-f84e-992a-ff2d-6d35aa4bddf2@kernel.dk>
Date:   Wed, 16 Oct 2019 10:20:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016161320.GC441788@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/19 10:13 AM, Greg KH wrote:
> On Wed, Oct 16, 2019 at 09:04:43AM -0700, gregkh@linuxfoundation.org wrote:
>>
>> The patch below does not apply to the 5.3-stable tree.
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
>> >From 8a99734081775c012a4a6c442fdef0379fe52bdf Mon Sep 17 00:00:00 2001
>> From: Jens Axboe <axboe@kernel.dk>
>> Date: Wed, 9 Oct 2019 14:40:13 -0600
>> Subject: [PATCH] io_uring: only flush workqueues on fileset removal
>>
>> We should not remove the workqueue, we just need to ensure that the
>> workqueues are synced. The workqueues are torn down on ctx removal.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 6b06314c47e1 ("io_uring: add file set registration")
>> Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ceb3497bdd2a..2c44648217bd 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2866,8 +2866,12 @@ static void io_finish_async(struct io_ring_ctx *ctx)
>>   static void io_destruct_skb(struct sk_buff *skb)
>>   {
>>   	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ctx->sqo_wq); i++)
>> +		if (ctx->sqo_wq[i])
>> +			flush_workqueue(ctx->sqo_wq[i]);
>>   
>> -	io_finish_async(ctx);
>>   	unix_destruct_scm(skb);
>>   }
>>   
>>
> 
> This fails to build as sqo_wq is a pointer in 5.3, not an arrary.
> Backporting that array change feels "big" for 5.3, is that needed here,
> or can this be fixed differently?

Yeah, we don't need to do that. It's just a pointer in 5.3, not an
array of pointers, so the below should be all we need for 5.3 (and
5.2/5.1).


diff --git a/fs/io_uring.c b/fs/io_uring.c
index cfb48bd088e1..e05f302cfb41 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2564,7 +2564,8 @@ static void io_destruct_skb(struct sk_buff *skb)
 {
 	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
 
-	io_finish_async(ctx);
+	if (ctx->sqo_wq)
+		flush_workqueue(ctx->sqo_wq);
 	unix_destruct_scm(skb);
 }
 

-- 
Jens Axboe

