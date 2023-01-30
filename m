Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CC568140E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 16:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjA3PFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 10:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbjA3PFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 10:05:36 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F0B18152
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 07:05:33 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id m15so577715ilh.9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 07:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dnhZT335PeY3thfSyaxfEX7GHKCOcBFsdRRIOx085/E=;
        b=FLCrMtkGnVOQ0fxDgoT3+G+YMxirq8Mykav4eVg+QnhZqsElPM26hqFn1Q8txlfaf7
         99tlShJNGxohTa3Na+06Udh1dRj9Ej671ikyYnYWoJI0nMNE55ZXpNyiegeC9cZ9mgq7
         ZF3KoFZnzX8UerK3MF1guG4i7dEJA/WONeXUjQ0IVKgjkKJ51mo/ta9B+jSAdST+ewKP
         2Jn3IPbEU+hgeBECbmucpWoBmrCzFXnHhkE78Z6agCmr0EmFT9PRzDhmxh9SxdSSDfPw
         Xh2kSXsbQQsn33F11xvqcKo3Kuti4lzl8Ux0sF72lIyt8xNXSFrhOUR0MMQQafF83sUN
         rozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dnhZT335PeY3thfSyaxfEX7GHKCOcBFsdRRIOx085/E=;
        b=N69/GQXaR15WYPRdRidLH8i9+LKHW8m2Lf7sfvthnO9lfTqyYGFHJG6vYa0e55Tcp/
         wdtUpnA6Xs29y2WP83SjZxCcsMBzEX8JwEOZdgxIn1rAuOH+Rp4s3hNfRivS7uuxqze/
         4Oq3soTrhb5I5ZwqXjGOPRAY+y/OJlMXhc0Knn8bSNLnG8tT7zMJMrRq0TdzPUh5FZ0K
         +dlOk00fBOgKdaMWG/DoTp3OU3mkQ7cjVUSg1aMUeWrtsiWXMDkvi3nefESag85V3JGE
         BKIbuANso+ZAdgRCbbJgxDLxlmwotDbPj6jJK8WEWVZHn0D+vcPZDHywlUnMxfUSLisU
         wO2Q==
X-Gm-Message-State: AO0yUKUwIYoxuuZX0Vzqc8xJDWnl7R55X+QbFlRgGH1NGHGMwX2unWVk
        HRTuHZwLmyi6HERZsd/J1nT5rYD1ufRD4baz
X-Google-Smtp-Source: AK7set/gIW0cht8YeZGLwudxwv9h60s6oex0qWzH0A7RNtyLpHiwOFCxxAm/yYosUtAfIJVcsnZ3+Q==
X-Received: by 2002:a05:6e02:12e1:b0:310:ff8c:6844 with SMTP id l1-20020a056e0212e100b00310ff8c6844mr256615iln.2.1675091133066;
        Mon, 30 Jan 2023 07:05:33 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t5-20020a028785000000b003a7cd65b280sm4752646jai.92.2023.01.30.07.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 07:05:32 -0800 (PST)
Message-ID: <179c778a-fd24-96a9-1f9c-61b705d12c74@kernel.dk>
Date:   Mon, 30 Jan 2023 08:05:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: FAILED: patch "[PATCH] io_uring: always prep_async for drain
 requests" failed to apply to 6.1-stable tree
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     dylany@meta.com, stable@vger.kernel.org
References: <1674998787177121@kroah.com>
 <1aa4166f-c66b-5eea-e695-66f206482321@kernel.dk> <Y9eWMNS9jxBPPZ5v@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y9eWMNS9jxBPPZ5v@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/30/23 3:04 AM, Greg KH wrote:
> On Sun, Jan 29, 2023 at 12:40:11PM -0700, Jens Axboe wrote:
>> On 1/29/23 6:26 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 6.1-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> This should do it.
> 
> Looks like Sasha beat me to it :)
> 
> thanks for the backport!

Yep, looks like Sasha just pulled in the dependencies, which is
fine with me too.

-- 
Jens Axboe


