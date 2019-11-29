Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3859510D8D1
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 18:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfK2RQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 12:16:30 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:34740 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfK2RQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 12:16:29 -0500
Received: by mail-pg1-f171.google.com with SMTP id z188so14630126pgb.1
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 09:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cJUqaft98JUbJoAJGvOcDoZ/xfTmcquNmc0PZ2Qp0uM=;
        b=ubBm2VrLVzUJImie+uq75o/+w+tTc6Z0mrIfJ5WIoRKYN4Pp8UgmXdvLJ0PB+K9IhA
         6HUT780D+oJvXsK4Es3SKuPMCTJ+bOPIxsCqanMKRKhEOgvyTWRTLsgZMTGntNWluwM/
         sQSlPJU7T/UAGC+4gs3t94QQhF6xK6ewMvgJnrFdie8m4ZnRAOC1hjxofhhLNmOj72zP
         ALJLfymTQTKWVuPeIwpJbgFpdCt4C/X+ouBZ2Rdk8NY0VGFuC1qCPqZxFYjFmkVOPkmY
         FhKWyM2KHapwRofvaaFr5pXTPrXWBqblmVbYiI+wa7LRqdAoktrqqnTdSiXEi5NtbYIW
         p77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJUqaft98JUbJoAJGvOcDoZ/xfTmcquNmc0PZ2Qp0uM=;
        b=c6cW0ZdcLRaJQn4JFrXERZDQXzCOeLgaxMTnZzDd0dfPr8twtGRiOyQg5iYKSQJzbN
         8xe90XqTCd5o/LtpuLPJufLKeODrhD8YwAFVXUfVIFgFmw4vWFj+OGdo+YUHRPDqy76o
         pO9HYPPR7VzJGdNA0f4H0+6XMZn/SiblqZ92vwO4c9fNdBT+jC12n0rtkIZnPJuY3fE8
         8UPrthf38ZytY2XzYu+Lci/DzaaqZ3A/rNy1HgDsshxszadv6JaD+zZdczD6KbG31sSb
         /4CxQs2YHu1+sCTRFd+QLZ6RByzYaTs1BMc1Cd04CXmRYvDglGq8Hy2OuixJQ7nxV/jx
         MfVA==
X-Gm-Message-State: APjAAAWtcIAGSgduBT/Wcx4I4iLFUgDFNvHs7nrk6r5EbGDbBjdUB++7
        9izVAFVHayAWqOj37iyEcT02iw==
X-Google-Smtp-Source: APXvYqyuqCP95Pu9EWWsAQwExBzqJ/fW152qbXSCL38YrvQ4EciwmTcFOdOzX21DBAqwizS113OH6Q==
X-Received: by 2002:a63:5104:: with SMTP id f4mr17722304pgb.192.1575047787014;
        Fri, 29 Nov 2019 09:16:27 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c457:26a3:bdc5:9aed? ([2605:e000:100e:8c61:c457:26a3:bdc5:9aed])
        by smtp.gmail.com with ESMTPSA id s2sm26042860pfb.109.2019.11.29.09.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 09:16:20 -0800 (PST)
Subject: Re: Build failure on latest powerpc/merge (311ae9e159d8 io_uring: fix
 dead-hung for non-iter fixed rw)
To:     Christophe Leroy <christophe.leroy@c-s.fr>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <71cf82d5-5986-43b7-cf1c-acba429a89d6@c-s.fr>
 <3a95d445-1f5c-7750-f0de-ddc427800b3b@kernel.dk>
 <4ef71e74-848f-59d4-6b0b-d3a3c52095a0@c-s.fr>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5389b43a-259d-997c-41e6-5e84a91b012a@kernel.dk>
Date:   Fri, 29 Nov 2019 09:16:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <4ef71e74-848f-59d4-6b0b-d3a3c52095a0@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/19 8:14 AM, Christophe Leroy wrote:
> 
> 
> Le 29/11/2019 à 17:04, Jens Axboe a écrit :
>> On 11/29/19 6:53 AM, Christophe Leroy wrote:
>>>      CC      fs/io_uring.o
>>> fs/io_uring.c: In function ‘loop_rw_iter’:
>>> fs/io_uring.c:1628:21: error: implicit declaration of function ‘kmap’
>>> [-Werror=implicit-function-declaration]
>>>        iovec.iov_base = kmap(iter->bvec->bv_page)
>>>                         ^
>>> fs/io_uring.c:1628:19: warning: assignment makes pointer from integer
>>> without a cast [-Wint-conversion]
>>>        iovec.iov_base = kmap(iter->bvec->bv_page)
>>>                       ^
>>> fs/io_uring.c:1643:4: error: implicit declaration of function ‘kunmap’
>>> [-Werror=implicit-function-declaration]
>>>        kunmap(iter->bvec->bv_page);
>>>        ^
>>>
>>>
>>> Reverting commit 311ae9e159d8 ("io_uring: fix dead-hung for non-iter
>>> fixed rw") clears the failure.
>>>
>>> Most likely an #include is missing.
>>
>> Huh weird how the build bots didn't catch that. Does the below work?
> 
> Yes it works, thanks.

Thanks for reporting and testing, I've queued it up with your reported
and tested-by.

-- 
Jens Axboe

