Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E622E8801
	for <lists+stable@lfdr.de>; Sat,  2 Jan 2021 17:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbhABQGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Jan 2021 11:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbhABQGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Jan 2021 11:06:05 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD5FC061573;
        Sat,  2 Jan 2021 08:05:25 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 190so13243593wmz.0;
        Sat, 02 Jan 2021 08:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L2xy3XQXTVwEIX4kqwVgfni5lSuvG30L9E1jrQeAcDE=;
        b=YjoDHg1DygmSPpoABoMHeV2OJ1Q7ltY9JgcIMywm4ioCppZzI4ZDfipzMlmM0aacFB
         9oiJuf2eJHZt0mKjRivkvR+HB5KJTaQMPeNdEvyitqDmb3jHtE3kuZA7LDSbaj9NgjFK
         igTt3QU12Bg4Ek5ibaQQx9nmJAp83I4HrUdBTAUiMAgP0GhoWin2Kib0m3oF7mI4sjz4
         XwnB3IzSLISsCYgZU8Ue1l4nK76CPb8mFBlCVFySGCTw8uNQyCVWqRc5GrBQaVGhSYFp
         1r12A0okCgd1gykG8Inu1Fh3iTmO4xhI3PaHp/hARyhYepKa/qWNo8abU2lbYk9kJ0zv
         Ws+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=L2xy3XQXTVwEIX4kqwVgfni5lSuvG30L9E1jrQeAcDE=;
        b=DudCskQQ9FOz2rNk1Wr5j7CO0IEVlyh7KE4ezjcUYtjiryv+G0bOcTAuhdNCwNriwU
         s0jmFsqtD+Agg2ey2bIFaJOQicErDACf6zeh7ZJ35MgDT4nktnpB6JZloWRjNMGSftSA
         KdfbtaSDjz8AHqRAgDFMxD11KhgqPJc/3TZ6nflovIO2rhgrFBbLzTparmL3Gy9Fi0A+
         hZhXg9InCw8zG6ydpdTouY7xvcoDLOSRtAbVmW32aSkzsS/HWcwVDORxXHdbtrfxtQpm
         2EzWmlQMWu8TQyNaHpclWBY2lGZKYGpbMOcaiItvohTCRBN6OOUHsV3RhgcW551yrvUC
         FK2A==
X-Gm-Message-State: AOAM533lt92r9YVqSbC3E5zMifohe0JH2AErl1pTHe0jc8H9FD5JsuuO
        H9unHVC9fHHQQBxIWoZ0peaQgbR+B2o=
X-Google-Smtp-Source: ABdhPJzkfsSqPA7hUUhQdB9FqGrGXxqDkFiJDMdLlmPAHwYPWybOE20Yc5vtFjZmpDi3WHcspgmFyw==
X-Received: by 2002:a1c:b407:: with SMTP id d7mr20001170wmf.34.1609603523561;
        Sat, 02 Jan 2021 08:05:23 -0800 (PST)
Received: from [192.168.8.179] ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id 125sm23663034wmc.27.2021.01.02.08.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jan 2021 08:05:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1609361865.git.asml.silence@gmail.com>
 <12a143ea8f841801b36ccd1cca3558543eab7683.1609361865.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/4] kernel/io_uring: cancel io_uring before task works
Message-ID: <4f9fda9d-1e5c-2a10-2356-730026ae5d27@gmail.com>
Date:   Sat, 2 Jan 2021 16:01:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <12a143ea8f841801b36ccd1cca3558543eab7683.1609361865.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/12/2020 21:34, Pavel Begunkov wrote:
> For cancelling io_uring requests it needs either to be able to run
> currently enqueued task_wokrs or having it shut down by that moment.
> Otherwise io_uring_cancel_files() may be waiting for requests that won't
> ever complete.
> 
> Go with the first way and do cancellations before setting PF_EXITING and
> so before putting the task_work infrastructure into a transition state
> where task_work_run() would better not be called.

It won't do in the end, because after cancellation we don't have files
NULLed yet and SQPOLL task may use find and use them. I guess can't be
dropped because of rc, I'll think whether to revert or somehow shut
sqpoll.

> Cc: stable@vger.kernel.org # 5.5+
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/file.c     | 2 --
>  kernel/exit.c | 2 ++ 
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index c0b60961c672..dab120b71e44 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -21,7 +21,6 @@
>  #include <linux/rcupdate.h>
>  #include <linux/close_range.h>
>  #include <net/sock.h>
> -#include <linux/io_uring.h>
>  
>  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
>  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> @@ -428,7 +427,6 @@ void exit_files(struct task_struct *tsk)
>  	struct files_struct * files = tsk->files;
>  
>  	if (files) {
> -		io_uring_files_cancel(files);
>  		task_lock(tsk);
>  		tsk->files = NULL;
>  		task_unlock(tsk);
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 3594291a8542..04029e35e69a 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -63,6 +63,7 @@
>  #include <linux/random.h>
>  #include <linux/rcuwait.h>
>  #include <linux/compat.h>
> +#include <linux/io_uring.h>
>  
>  #include <linux/uaccess.h>
>  #include <asm/unistd.h>
> @@ -776,6 +777,7 @@ void __noreturn do_exit(long code)
>  		schedule();
>  	}
>  
> +	io_uring_files_cancel(tsk->files);
>  	exit_signals(tsk);  /* sets PF_EXITING */
>  
>  	/* sync mm's RSS info before statistics gathering */
> 

-- 
Pavel Begunkov
