Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D852F79784
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390897AbfG2UAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:00:31 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43413 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390628AbfG2Twk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 15:52:40 -0400
Received: by mail-pg1-f173.google.com with SMTP id r22so1172199pgk.10
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 12:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5y1RR/5zVFkKh6d2Sxhk6oeZ+5czoNd5UTuSdAZxZjc=;
        b=WcDSArfVRa9rl77duBrhZs9kjHpUXwE9kaU9GJLVApvOB9Vb2XFVLYhf7SO4ICIuIn
         WrVGHAqJUBG/4S44Y9EaS8OYXnXJQAQNV5UhY99V01mJXU/4M048ZrSKrcR4SIf8AM9Q
         iDBsvlivXl73a/gvLYpOkdZuVUHlOM+edN9U86wzZkbFGvJLp/i8Vxwq53alNqT6qRss
         wABudQFYItFXgtfoxGjUj70VZnffsibiDH4bwGTgXkr+QhsrLnIu4iLuEZzSOn40SybZ
         q2+wUOEeOhLGwLmO5LQ0F36btlbnJmpk6t8ddy70zqE+sA0QArWoKeDPPBkIJUx0Bq0l
         axHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5y1RR/5zVFkKh6d2Sxhk6oeZ+5czoNd5UTuSdAZxZjc=;
        b=e74IRHw1nsmGu/nbDPz2XZ5e7JxsHAVVu7t1cPVWiz4ypvvgyFWg3NYMcQoDHzwSkm
         DZkDikVXPYI6NJnjBnhqnVxZmnS3ZYJyWPPWIj7VnDx2f2izz13qGqBK8yvSe/ma0SxG
         JT4iohlr7UU4Qekc/KNodVTdgpu8fzmsTKnChZUylKXyxS/cKPW6wdcRlsRv3lM/8zjg
         AYm39LoHjk+mn9NoeivD2XfP9zv1kNt0V/Wrk0gF3m+zs34WJpBzJO1m6J/yMFaB9CHt
         qC+KtmalzDdTlj55eAxfh/yrN/IOyQBGbIvV4x7bCVZqTI0GlBAs2XQr8QLbHziOdlS/
         3g+g==
X-Gm-Message-State: APjAAAXYeIi+i2aUvJPdl0SBa4OnrKP0IwD4h90/ktDpR5OjyPywyTAY
        F9ZI3pxPbHgsCpkCxAzsYDU3XE37FGA=
X-Google-Smtp-Source: APXvYqwgiSH4AZKyWp5h2Hs1pDQrT1rz2RoZp5wEx7xD1tB0EMbDvp/KYskrjs9MeFN4S83Uo/+xQg==
X-Received: by 2002:a63:fe52:: with SMTP id x18mr105136200pgj.344.1564429959426;
        Mon, 29 Jul 2019 12:52:39 -0700 (PDT)
Received: from [192.168.1.188] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id f12sm52309956pgq.52.2019.07.29.12.52.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 12:52:38 -0700 (PDT)
Subject: Re: fs/io_uring.c stable additions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <59d14d1f-441a-568c-246e-4ee1ea443278@kernel.dk>
 <20190729181528.GA25613@kroah.com>
 <abd31004-9c2f-ffa9-10b3-77ed4427d411@kernel.dk>
 <93699ab7-35b2-338a-967d-bf0b432e8abf@kernel.dk>
 <20190729185808.GA25051@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4b0b9bd0-c8cf-63ca-0b45-fa5f32a03c37@kernel.dk>
Date:   Mon, 29 Jul 2019 13:52:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729185808.GA25051@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/29/19 12:58 PM, Greg Kroah-Hartman wrote:
> On Mon, Jul 29, 2019 at 12:35:14PM -0600, Jens Axboe wrote:
>> On 7/29/19 12:17 PM, Jens Axboe wrote:
>>> On 7/29/19 12:15 PM, Greg Kroah-Hartman wrote:
>>>> On Mon, Jul 29, 2019 at 12:08:28PM -0600, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> I forgot to mark a few patches for io_uring as stable. In order
>>>>> of how to apply, can you add the following commits for 5.2?
>>>>>
>>>>> f7b76ac9d17e16e44feebb6d2749fec92bfd6dd4
>>>> 0ef67e605d2b1e8300d04fd9134d283bbbf441b9
>>>> Does not apply :(
>>>>
>>>>> c0e48f9dea9129aa11bec3ed13803bcc26e96e49
>>>>
>>>> Now queued up.
>>>>
>>>>> bd11b3a391e3df6fa958facbe4b3f9f4cca9bd49
>>>>
>>>> Does not apply :(
>>>>
>>>>> 36703247d5f52a679df9da51192b6950fe81689f
>>>>
>>>> Now queued up.
>>>>
>>>> You are 2 out of 4 :)
>>>>
>>>> Care to send backported versions of the 2 that did not apply?  I'll be
>>>> glad to queue them up then.
>>>
>>> Huh strange, I applied them to our internal 5.2 tree without conflict.
>>> Maybe I had backported more...
>>>
>>> I'll send versions for 5.2 in a bit for you.
>>
>> Here you go, those two on top of the others. Ran it through the
>> regressions tests here, works for me.
> 
> That worked, all now queued up, thanks!

Great, thanks Greg!

-- 
Jens Axboe

