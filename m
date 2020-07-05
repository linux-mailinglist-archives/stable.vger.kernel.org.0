Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735D0214FAC
	for <lists+stable@lfdr.de>; Sun,  5 Jul 2020 22:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGEU5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jul 2020 16:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728038AbgGEU5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jul 2020 16:57:13 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9268FC061794
        for <stable@vger.kernel.org>; Sun,  5 Jul 2020 13:57:13 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k71so12411260pje.0
        for <stable@vger.kernel.org>; Sun, 05 Jul 2020 13:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LQra+OzF4k64KbPTjvj5MK+1o4iBbOUYG7MJ3KGBIng=;
        b=P3JgcdHAYTyabBbu2O0GH6+2VBPpaYSGY+a9DX6fsejEXaIqUwxU9gpB1P8vMNQBjp
         F2JrPbMf2YfJAvc+F5GuG/X88dQM8xx8oCoFyy29Fc3FaT2TKVKBq0ySxPP/B6qlqEK6
         NReQMNsvCnGeAw7FJsLzYA12NUtrazbtLl1k4iHvUvly2HGMsCiBvEv8FYmQb3PX0dm/
         P8VUabgnz7daqtMG+DhEFrwHhjVw1rDHnvit92LA8d+75FCGa5Hyiq+qs0Ncq3S6SQlv
         gC3DTeVmvbtwT5Sgmr451gw3TszW66Wd7+NeqIpufm6kieKqCeEuyI6qQCNaythcpjUm
         kPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LQra+OzF4k64KbPTjvj5MK+1o4iBbOUYG7MJ3KGBIng=;
        b=XRD7JoJksQwSmTq1FMctWcWypORsgtyLEixa6Pf5zMtPyEwbQXDqD+7UlcWxg55BBE
         aeyKuSA+dcWlpoyyzKZl9RnvCJIJKaOd3kz3qrhWAA1L1e2VtTmI5c7ISvdd7BmvZ4ly
         7psyHKi3V2zs3wQFcU7Gt2hq5HwmPXyO182Ku7Bljv0mjaf4EOEtJd8CZdesFcvLBgX3
         00+yPWF+CaoqwT1Y9o4DdYo2NyPuOU/ozwFVXpn+mzRQIpeGygZrWEDFaIncBLJHwG4t
         5E+t9620ZvWAK9yCcITTPbf1NNVfmzBhDUvMNvdBCP4m6cHTqLQ0Dor02aDo7f/t8RL8
         eJEw==
X-Gm-Message-State: AOAM5300magc81+Tg7TaBng/ZleObPrxqSv7SQ6V66wJnMaZpWfh4zOM
        ur1QX9Zof3mGH4H7kDyS5oPXoqMFA7Smlw==
X-Google-Smtp-Source: ABdhPJyx9wsqKh6O9dhjCdxNPx9KSxzLVEs3plgQJNQuoeCbTZKjMBzMKcg+htI4hlPgIZ6zTdUF4w==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr3427483pjq.47.1593982632802;
        Sun, 05 Jul 2020 13:57:12 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k7sm17512907pgh.46.2020.07.05.13.57.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:57:12 -0700 (PDT)
Subject: Re: Patch "io_uring: use signal based task_work running" has been
 added to the 5.7-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <20200705134847.6A6AF20747@mail.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3aa74884-9e39-b018-05b0-ab2575c0681a@kernel.dk>
Date:   Sun, 5 Jul 2020 14:57:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200705134847.6A6AF20747@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/20 7:48 AM, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     io_uring: use signal based task_work running
> 
> to the 5.7-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      io_uring-use-signal-based-task_work-running.patch
> and it can be found in the queue-5.7 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Thanks for queueing this up, can you also add the fix for it? It's in
Linus's tree:

commit b7db41c9e03b5189bc94993bd50e4506ac9e34c1 (tag: io_uring-5.8-2020-07-05, origin/io_uring-5.8, io_uring-5.8)
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Jul 4 08:55:50 2020 -0600

    io_uring: fix regression with always ignoring signals in io_cqring_wait()

Thanks!

-- 
Jens Axboe

