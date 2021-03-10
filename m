Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C17C333BB8
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 12:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCJLpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 06:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhCJLpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 06:45:07 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D70C06174A
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:45:06 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id w11so22967621wrr.10
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 03:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cz0fXzwF58CaOrKZvbHUO6/X5/2Fu4uV61B8MXvz4ls=;
        b=oZrRxwpXnGDG+9kxxe2vfRBVwklj73g0nypLMuVlQIkPnHi2QdAfnmbxKoPy241JE2
         DNb+6SY1v32gA83eFfUz2BKs4ShFGV+E2ya4dYBpzUj7MXN66+Q3PYBpqLhzaK5IYttX
         BoGHnZTU5ssxdjtY5OmGVnSIL+p2FSYcsWmukQP7I/fk4j8O7ESiL3AQLmTyqFKn1HDb
         bSEMq0n8iq6m50PVH+2dLpV24BzeTgkV0Zu+Okpd5iaR+6SHBNPYfzP6hqle6IOd3Iur
         /RQ+dZaa1vGla6gYOkKfUPSmVAyNyUkFUCkkmhZCWl/Q52hjKEWGVZ1NpwROmcDQ5bfc
         hCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Cz0fXzwF58CaOrKZvbHUO6/X5/2Fu4uV61B8MXvz4ls=;
        b=SeY4FHdDw2PvX4EUXFZFisCL9m/CXom+7KbwnxgTUxgglVggUeLsYsCLm/4k5ACXlB
         T+mqICPl7pX7osth8uJ+MrlvfAZCHhIhSFFNxiLR4P3gRIFwWxdwTmWyOon3sCrtpZk0
         m45t1VshIDdcCOy1RsXF8ZfhFCLGFYLEXfLQ33kuRHb2TScICv3AI4ULllg7obg4BFpU
         JMbmyq52nFzI+o0nl3eh82G+5sae517kb+OYqiUngc8li/hCKPQBdD9UWUdrtRIAIpYI
         NNAH6qDnXRxQGZlqGk45gTDmEr/pCbaFFep+sxnAnQoIlj4uugyEAzpIDldQS7M3LY+I
         9O1g==
X-Gm-Message-State: AOAM5325zHAWi3tUvb08KEhtTIBeALMG1wFuEagXuYMz0rqsC7Q3YQ41
        XgXVEStz0GF6SVyFKAo8dWg=
X-Google-Smtp-Source: ABdhPJz9djmrbz3UTjZ8ZhctfR2wyCNrFe2aViNRa4NmrpTVa5/F9G7T0s0uMw5J8g3sIXSmbiC8Wg==
X-Received: by 2002:adf:a18a:: with SMTP id u10mr3106560wru.197.1615376704838;
        Wed, 10 Mar 2021 03:45:04 -0800 (PST)
Received: from [192.168.8.123] ([85.255.232.55])
        by smtp.gmail.com with ESMTPSA id l15sm8716494wme.43.2021.03.10.03.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 03:45:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1615375332.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH stable-5.11 0/9] stable-5.11 backports
Message-ID: <984359b4-051f-9724-d099-48fbc6c863bf@gmail.com>
Date:   Wed, 10 Mar 2021 11:41:09 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/03/2021 11:30, Pavel Begunkov wrote:
> 5-6/9 were forgotten to be marked for-stable. Others are

> 5 out of 6 failed to apply + dependencies.

edit: 3 out of 4 that came on March 1st, and the 4th was reverted
upstream so isn't needed. Doesn't matter though

> 
> Jens Axboe (3):
>   fs: provide locked helper variant of close_fd_get_file()
>   io_uring: get rid of intermediate IORING_OP_CLOSE stage
>   io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL
> 
> Pavel Begunkov (6):
>   io_uring: fix inconsistent lock state
>   io_uring: deduplicate core cancellations sequence
>   io_uring: unpark SQPOLL thread for cancelation
>   io_uring: deduplicate failing task_work_add
>   io_uring/io-wq: return 2-step work swap scheme
>   io_uring: don't take uring_lock during iowq cancel
> 
>  fs/file.c     |  36 +++++---
>  fs/internal.h |   1 +
>  fs/io-wq.c    |  17 ++--
>  fs/io-wq.h    |   5 +-
>  fs/io_uring.c | 241 +++++++++++++++++++++++---------------------------
>  5 files changed, 145 insertions(+), 155 deletions(-)
> 

-- 
Pavel Begunkov
