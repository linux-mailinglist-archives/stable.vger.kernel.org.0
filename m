Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACC0215D05
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 19:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgGFRZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 13:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729616AbgGFRZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 13:25:23 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBA4C061755
        for <stable@vger.kernel.org>; Mon,  6 Jul 2020 10:25:23 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k23so40134274iom.10
        for <stable@vger.kernel.org>; Mon, 06 Jul 2020 10:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PJWuqJTOzvgYdgPCS5R9mLCixgN9hXssjOTSILbJ7Ss=;
        b=X2ubbvEBtPcwFCE+efLHzF039TCCoWc18lGooMiuAb1v4pR4AGE178deTZJ7Jy5ylp
         SjWuxtDHSf4NWpwYols0kJjocgyKuH9gwg0s7MXNyJfPWI5YcUM/HvTjTRtaFQeM12NK
         Kmm5qcdwWtEtn4W04YWp06h2IZHrt3kkvxSxVH5ytMI6AemGqsbNzRgX+RWiB149XVsV
         jTbAFXRVh3tfxBxwMMSYOlwCrQgvIX6AGg3bBN7J2IV7KmLO/XEbIdJiXhxylIfGnO+g
         QsjE3sR/OBKVbmVHFoO7x1iiMA1z4lpugDNsS5bfTbCfM5CfZ7RdSJ/4TZ92VY0slpMs
         5HvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PJWuqJTOzvgYdgPCS5R9mLCixgN9hXssjOTSILbJ7Ss=;
        b=clBZ2obILakyCj3QAZ4r2sMWVrl8PDPhVU7+7/hlJ94dVtd4z3gVGrcgrXObhsgJgT
         /WplEYlRp8eUMrNoF6fLaKjNcvWyEqhZqy6K3q/UbK8g/5/nev3R5tNYZKVV1jKZ/qHR
         OfGB2Gld4xV2B1Yxt/KDuR5/DJBKnxgs9twuYtJRGYD8DHsFjky7VzZZiJ08tvdhKTr/
         +nP2BZuA9CGumDFY0PEExwi6LtkLRM+WrkqYbVIk3QiDtRT82IUKgwdJvUMgPDLEqImj
         B9nGa8Bz/6TIhq10jtpbYqWiATJQct4KpI1CZ2Rbw+xEAveXhjCMaFnDbSoGHxSxMwgD
         1cmQ==
X-Gm-Message-State: AOAM531G8yMUwJJGCxv8qxnTIBHugKDISHkYoJGU+NyT3ogeHvGBNmCX
        xO57nj6cnkdeDzt6JwuVr7kvqp/BBIsH0Q==
X-Google-Smtp-Source: ABdhPJx6VvlyWrLq9IqnthEG+OHkVnkSlcaZvcwYCvVO6kCuWjrhCw6c1pWbzOM8SrfO12Mcj3qahg==
X-Received: by 2002:a6b:ba8b:: with SMTP id k133mr26565570iof.204.1594056322049;
        Mon, 06 Jul 2020 10:25:22 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c25sm10546690ioi.13.2020.07.06.10.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 10:25:21 -0700 (PDT)
Subject: Re: Patch "io_uring: use signal based task_work running" has been
 added to the 5.7-stable tree
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <20200705134847.6A6AF20747@mail.kernel.org>
 <3aa74884-9e39-b018-05b0-ab2575c0681a@kernel.dk>
 <20200706172306.GL2722994@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <707ba6e4-970a-68c1-48e3-c2f20b77eb31@kernel.dk>
Date:   Mon, 6 Jul 2020 11:25:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200706172306.GL2722994@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/6/20 11:23 AM, Sasha Levin wrote:
> On Sun, Jul 05, 2020 at 02:57:11PM -0600, Jens Axboe wrote:
>> On 7/5/20 7:48 AM, Sasha Levin wrote:
>>> This is a note to let you know that I've just added the patch titled
>>>
>>>     io_uring: use signal based task_work running
>>>
>>> to the 5.7-stable tree which can be found at:
>>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>>
>>> The filename of the patch is:
>>>      io_uring-use-signal-based-task_work-running.patch
>>> and it can be found in the queue-5.7 subdirectory.
>>>
>>> If you, or anyone else, feels it should not be added to the stable tree,
>>> please let <stable@vger.kernel.org> know about it.
>>
>> Thanks for queueing this up, can you also add the fix for it? It's in
>> Linus's tree:
>>
>> commit b7db41c9e03b5189bc94993bd50e4506ac9e34c1 (tag: io_uring-5.8-2020-07-05, origin/io_uring-5.8, io_uring-5.8)
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Sat Jul 4 08:55:50 2020 -0600
>>
>>    io_uring: fix regression with always ignoring signals in io_cqring_wait()
>>
>> Thanks!
> 
> Its been queued up too, thank you.

Thanks Sasha!

-- 
Jens Axboe

