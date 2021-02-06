Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF675311EF9
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 18:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhBFRA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 12:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFRAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 12:00:25 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51C3C06174A;
        Sat,  6 Feb 2021 08:59:45 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id m7so11028655oiw.12;
        Sat, 06 Feb 2021 08:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0/UAdvhavUTbyxsEFBpVC/GjkxhAL2BGJY1lnKrcCkk=;
        b=GxyvINd2neluxgNxNGqofRw09+yh3vow3B2ok/57/hpFsHY6Uw6mERpMr6WvXzddn+
         Dh6OZBz9K2TB/UjKKqwzSSmgwbpbSfFQgr2wFCycCc/wEoIDit/1b1U86w6+sPt/tomx
         +0WaLzePt+RHqXFN2KBsgeZUbxgGSLLavhG5itIoYYHKcaLZRg2iFJg2jNrbTFC2RSl8
         VpYWk0874cn6zPHWPqmUyB4cU/f1yEg1MaN0pyQnSeF0/sfWkz4cW1cZjIbYZ5MhAup6
         ZKdsvJFnEgWQIw69qjcq7Rwd/aulzD01srsgQCoPUXr4CZDfVqagTNfepRxFAXZNVH1l
         +BUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0/UAdvhavUTbyxsEFBpVC/GjkxhAL2BGJY1lnKrcCkk=;
        b=mCZck28nFg7eDXUWXzmpP1Hy+5rH4bC802wpoiaZnsEv3KFumk6uQN974agYuUkaaO
         cbHIDTkCibv/r0+9wiTZswNJBflLQsHJVTmvyphVEL6vltOVFd7JLxcMXfG9JkCZC2V0
         Se1cMzBpzuDnY3E+c20XHE5P5VG7CIITleD88cfBz3+j2o1x4I9nzV8/UVnwQ28UDuL9
         tF7H75M5pwRqn3M5cAHGyqKLwDa5CTA2A4fW7i7C5WoGu0StuiroJPo/1gfrBYqUjBT1
         5Aa41JDl4QKkRvZX6qMyMcgtv0iHzGvUEAn/lMgt4YBky7dVurQAcDQ4cdCEGzj7T62C
         0xVA==
X-Gm-Message-State: AOAM530no3J8ReocrBgdi6gBAJ3iA5oW8qDE2oMcFPvbpnPmsHvk8B1U
        1gCIUqjB1MsZd0yle8hQfG4=
X-Google-Smtp-Source: ABdhPJz2FItpEibzfZP5FoftlZ34ne6yQBkCcm1oL1JelIcgrnGJMKlaSdJzIa1+wC1mX73t3kYU6w==
X-Received: by 2002:aca:90e:: with SMTP id 14mr6061879oij.65.1612630785182;
        Sat, 06 Feb 2021 08:59:45 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g36sm607141otb.67.2021.02.06.08.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Feb 2021 08:59:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: Linux 4.4.256
To:     Willy Tarreau <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net> <YB6S612pwLbQJf4u@kroah.com>
 <20210206131113.GB7312@1wt.eu> <20210206132239.GC7312@1wt.eu>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <e173809f-505d-64a8-1547-37e0f6243f4c@roeck-us.net>
Date:   Sat, 6 Feb 2021 08:59:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210206132239.GC7312@1wt.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/6/21 5:22 AM, Willy Tarreau wrote:
> On Sat, Feb 06, 2021 at 02:11:13PM +0100, Willy Tarreau wrote:
>> Something like this looks more robust to me, it will use SUBLEVEL for
>> values 0 to 255 and 255 for any larger value:
>>
>> -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
>> +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* (0$(SUBLEVEL) > 255) + 0$(SUBLEVEL) * (0$(SUBLEVEL \<= 255)); \
> 
> Bah, I obviously missed a backslash above and forgot spaces around parens.
> Here's a tested version:
> 
> diff --git a/Makefile b/Makefile
> index 7d86ad6ad36c..9b91b8815b40 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1252,7 +1252,7 @@ endef
>  
>  define filechk_version.h
>  	echo \#define LINUX_VERSION_CODE $(shell                         \
> -	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
> +	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* \( 0$(SUBLEVEL) \> 255 \) + 0$(SUBLEVEL) \* \( 0$(SUBLEVEL) \<= 255 \) ); \
>  	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))'
>  endef
>  

I like that version.

Two questions: Are there any concerns that KERNEL_VERSION(4, 4, 256)
matches KERNEL_VERSION(4, 5. 0), and do you plan to send this patch
upstream ?

Thanks,
Guenter
