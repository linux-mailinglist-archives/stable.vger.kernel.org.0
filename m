Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCA10D82F
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 17:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfK2QEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 11:04:11 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:32971 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbfK2QEL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 11:04:11 -0500
Received: by mail-pl1-f176.google.com with SMTP id ay6so13064269plb.0
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 08:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=55yYEkm6RHJrPbGEbz5YaTrG6Snd2G6eoPVI+U2I9sw=;
        b=ixA6CFkEosFzfEFCuAMfiMcqA4yRfzWdPkgAQy+nlXnxzy72RoRXy12bxu7vVQRGW4
         q2Urr/WgXBsoiltbaiFdJaW+2Ic6va6kdHryTK502qDrAKETHoB0ztHiluS9AhqYclxX
         ftLioSXEjsN+i39I0lBJtS40Xs7f7kdq2eGx4xJL4uq3bMnocnEaf0kNUylJUjVZ68wo
         2gt9Bp68qEiH2AuFun6lNbK3qj9MugJ+4QALqXdBC9vvd9wljCgh85MKJK0cGK+PmaKZ
         4+wUSu9VMHM2G8xjmQL/g6EqfZX3IavR0EP16J317lBJzIRC88cftXSovW1ooylDjU1+
         DPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55yYEkm6RHJrPbGEbz5YaTrG6Snd2G6eoPVI+U2I9sw=;
        b=rWeKPuRKm85G1Tl1Dv+0WqM4Pk5hQNHbL/pUYgCXgz99XuOcRfXea2rCjPus74SBNu
         kywrEzKo7eRl0uRs3rXEXalqlckL5iljw0Zy6RC8WfhirBkYSfO7aECzlocspEKnnIOS
         DSP3JUe9+5CIgAt89dz5Rj+IPxVC+kJWSggfw2DlZwV2Gdw2u/i3Xa4+7jmZ61sa4l2a
         ChSWiCTI23SK6bvHnIKvQDTv8AMPrDL/6yxXbP5UJE9VETd7ykwVXyhI02wXnkJW2/4I
         tZkae9uGX4XzJl9yQraFMbXK+cWlFADWHSoCvlbtH1yfmZ9ZpwMZNxSXoL8O0GAp8lPp
         19TQ==
X-Gm-Message-State: APjAAAVoqo/24lIzpY4WMi9f4nu2NBPzEqKdQJdSe8Hxoaaz1GQdswPc
        5AFnZtSYIVTL1+T/xdJh5Vm3hw==
X-Google-Smtp-Source: APXvYqzLZT3KWZYjNqWSQy2mj7zlWghNfW8U+ubCCK8iIBbW4a8KCTN325YznK1PmfsXvxdONXDJng==
X-Received: by 2002:a17:902:b90a:: with SMTP id bf10mr15393104plb.45.1575043450234;
        Fri, 29 Nov 2019 08:04:10 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:99f0:a6fb:215a:45a7? ([2605:e000:100e:8c61:99f0:a6fb:215a:45a7])
        by smtp.gmail.com with ESMTPSA id ay16sm13351352pjb.2.2019.11.29.08.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 08:04:08 -0800 (PST)
Subject: Re: Build failure on latest powerpc/merge (311ae9e159d8 io_uring: fix
 dead-hung for non-iter fixed rw)
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <71cf82d5-5986-43b7-cf1c-acba429a89d6@c-s.fr>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a95d445-1f5c-7750-f0de-ddc427800b3b@kernel.dk>
Date:   Fri, 29 Nov 2019 08:04:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <71cf82d5-5986-43b7-cf1c-acba429a89d6@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/19 6:53 AM, Christophe Leroy wrote:
>     CC      fs/io_uring.o
> fs/io_uring.c: In function ‘loop_rw_iter’:
> fs/io_uring.c:1628:21: error: implicit declaration of function ‘kmap’
> [-Werror=implicit-function-declaration]
>       iovec.iov_base = kmap(iter->bvec->bv_page)
>                        ^
> fs/io_uring.c:1628:19: warning: assignment makes pointer from integer
> without a cast [-Wint-conversion]
>       iovec.iov_base = kmap(iter->bvec->bv_page)
>                      ^
> fs/io_uring.c:1643:4: error: implicit declaration of function ‘kunmap’
> [-Werror=implicit-function-declaration]
>       kunmap(iter->bvec->bv_page);
>       ^
> 
> 
> Reverting commit 311ae9e159d8 ("io_uring: fix dead-hung for non-iter
> fixed rw") clears the failure.
> 
> Most likely an #include is missing.

Huh weird how the build bots didn't catch that. Does the below work?


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c2e8c25da01..745eb005fefe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -69,6 +69,7 @@
  #include <linux/nospec.h>
  #include <linux/sizes.h>
  #include <linux/hugetlb.h>
+#include <linux/highmem.h>
  
  #define CREATE_TRACE_POINTS
  #include <trace/events/io_uring.h>

-- 
Jens Axboe

