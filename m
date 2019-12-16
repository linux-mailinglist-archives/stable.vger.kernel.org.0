Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32435121C76
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 23:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLPWLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 17:11:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37105 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfLPWLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 17:11:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id p14so4614803pfn.4
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 14:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eN51P0fkFlAd1nYOszNxaBvw5nOhFDOIMZHQS6gpj2Q=;
        b=uTekF2BQjwdqxD+VqcRGSpDzTQon8lFafoR4zbgTLSUbWerMrumtsy0AJF7FDb9i5R
         GSaY2w0Sv+aL9ksTFjy+KJCE767OECSqjVXEJoyJINWuFB3B+vl3BVesIdbE1DpS1cBd
         QW0olbIfun4BoBGyE/tgODyEA16zym1+IKxshrGjSR9sVZQlLPIFa5aZMs2gLKVk2S3M
         jI/d/CMN2yJVSiLIAxInL2oyS0U/Zjbn7Ci0djEiG8meJWU5QbG03VQCkmMP0SA5/F2T
         fV51qoWeejjhgeC2PJEGmOcAgVScZisugj7Ig8SVqBkE9AyTC1UGtCmljSaAw/xoddFF
         YzdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eN51P0fkFlAd1nYOszNxaBvw5nOhFDOIMZHQS6gpj2Q=;
        b=PNdKjq/AhKv1gnCkW4uOSnjYbcrBLhWSR2DV7q1LrcQrrkuY4fVHd5MlO/WC40uBEb
         Ew0jNHJm3f0qufPSFFd61sYbGVU7SP4u+T2aEQuQII+aH8APfI8jq729hc+KBDsuqJ0p
         GCQuo+yA2lioBzfHJSMrY7hgJRCLFpvjAALHI5lb/GPQGxzCnJ5oKDOV6teLGf3JZyyr
         pFmwZP/6Q7nz1BBeJbf5iHVxUcf6K+RPuUDEDrPGvNmdHktapAkIb000sUSkBO1IUXZa
         qCdlCAVtquOr5kBbNduEc3spsAiox1WCp/QM9BHtjOps+wFaE1wiYIsilSkwqOVSDfIV
         ak5w==
X-Gm-Message-State: APjAAAXHZksDYb2OlG/OC6NW31hvSUJUnEjuxm2OhOeY+1vtKlEg5bgQ
        4lBX6NVWZWTtz5B19DeIaGQtduE6Buo=
X-Google-Smtp-Source: APXvYqxMh0ehfaV0Mt15/+xNpoxCT3yNPP7P282+opOm3TmevZm32O0YlrDv4f0nUNwGkRO/nv8XOg==
X-Received: by 2002:a63:597:: with SMTP id 145mr20394193pgf.384.1576534273867;
        Mon, 16 Dec 2019 14:11:13 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1017? ([2620:10d:c090:180::7616])
        by smtp.gmail.com with ESMTPSA id k12sm22978913pgm.65.2019.12.16.14.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 14:11:13 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] io_uring: allow unbreakable links" failed
 to apply to 5.4-stable tree
To:     Pavel Begunkov <asml.silence@gmail.com>,
        gregkh@linuxfoundation.org, carter.li@eoitek.com
Cc:     stable@vger.kernel.org
References: <15764077414946@kroah.com>
 <6f68d1db-127c-522e-dd83-8a0d6c2529fd@kernel.dk>
 <0f17474e-a0db-1d23-f0d0-38a199cc7e1f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <30a14598-5aa1-c250-4450-3bcd2dded933@kernel.dk>
Date:   Mon, 16 Dec 2019 15:11:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0f17474e-a0db-1d23-f0d0-38a199cc7e1f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/16/19 3:07 PM, Pavel Begunkov wrote:
> On 16/12/2019 01:13, Jens Axboe wrote:
>> On 12/15/19 4:02 AM, gregkh@linuxfoundation.org wrote:
>>>
>>> The patch below does not apply to the 5.4-stable tree.
>>> If someone wants it applied there, or to any other stable or longterm
>>> tree, then please email the backport, including the original git commit
>>> id to <stable@vger.kernel.org>.
>>
>> Might just be better to drop this from the 5.4 pile, unless Pavel
>> is motivated to backport it. Even if it throws a lot of rejects, most
>> of the hunks are trivial. Only one that requires a bit of thinking is
>> the one that deals with link issue.
>>
> I can, but do we want to backport new features? It may add new bugs, that
> completely betrays the idea. Anyway, let me know if it has to be done.

It's not about backporting a feature, it's about backporting the same
behavior to 5.4. We don't have links in 5.3 and earlier, and would be
nice to have the same in 5.4 and later. But it's not a huge deal for
this one...

-- 
Jens Axboe

