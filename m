Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382E710DAA4
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfK2UqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:46:13 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39024 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfK2UqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:46:13 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so12644613pga.6
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lcQEbDrOdeTGsdDriWIDWyDz/Ndj7C2XNFozJomrzCs=;
        b=eGt3BOZy2ywOlxup/+14ZX3SCtJ06ssyFLTdrGksd1rb6pYpCYH8VEzjeYFtqr481K
         NF3jItbqR8pKggcozrQWARd5BZdeUwbO5jTUU35JjjmaNnY8U5GK/+r2rxwkChAf1c7l
         GGT3nJ5pIQEBsbXPr3Ktu7EPvOhIORKF5fSWXv+S2vunur9s+5e+v4cQ2tHYd+Yj/LtH
         BwvHBVa3b77A2IdmP8XafedrjqYRuYqYq+ITWbMdidWkWCNfNBy397O2OBMqvrNiay6Y
         xnIcv6KjTtllXx+RgStTRQI4ESlUHjYoUiWwJjB8yqX/Q1iATjEc38ZPxByTvGwzh3ua
         hCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lcQEbDrOdeTGsdDriWIDWyDz/Ndj7C2XNFozJomrzCs=;
        b=OzmGz2TycFSS4ue7oW2Uwfb8HBonHs/ajrN8GFtHjPuHklkchLdTmeEJ5MO/sUjZRc
         j9uUUmXMrpol7cJAeikTTMMHwaHjXsGY6VL5LMVhpnYsVF5Z0i8Ol4z8Geg77PAivobo
         zmuuce6QJglb8Bxc/0t4lXLSPAJXEOY9c/FZxQBTj5CsQOlV8UTAgv/BT2HYdGd9HMXk
         R6kTBoo3jRozEnlifF8G8NQgkrMr9Eq3RBZ2JPmrP6YcsozSczdaB2etUJh1nRtFZLje
         zRKPUuqo7XncZYbcoQQAsKEGFvdWQp0GQdbJb9mgwIW4Qfd/x5ODns6S9GWRNJLvcpk6
         W7jA==
X-Gm-Message-State: APjAAAVM7Lq7cwwTK7BUFO8VPzAlVDql/j1YY1063FE5OaRLEVZI/xge
        Y/wcDPjZR6/8O7fT6CJacL75sGMEXR7nJA==
X-Google-Smtp-Source: APXvYqxvQJVQqpyLVsl+VNb2UuE3zcS3ZWnoWbDXs6k3fnHjPmknMhkDyy9MfVAdjEepES9UHmb0yg==
X-Received: by 2002:a62:7883:: with SMTP id t125mr6776217pfc.141.1575060372583;
        Fri, 29 Nov 2019 12:46:12 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6938:40fc:d284:b43? ([2605:e000:100e:8c61:6938:40fc:d284:b43])
        by smtp.gmail.com with ESMTPSA id p18sm25995758pff.9.2019.11.29.12.46.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 12:46:11 -0800 (PST)
Subject: Re: io_uring stable additions
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <a552f6b6-bdb8-afb8-b178-1d30d4d9ece6@kernel.dk>
 <20191129195245.GR5861@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5ec21b1e-4a0d-1cc4-cd7d-7602624fa3fd@kernel.dk>
Date:   Fri, 29 Nov 2019 12:46:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191129195245.GR5861@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/19 11:52 AM, Sasha Levin wrote:
> On Thu, Nov 28, 2019 at 04:40:38PM -0800, Jens Axboe wrote:
>> Hi,
>>
>> I have a few commits that went into 5.5-rc that should go into stable. The
>> first one is:
>>
>> commit 181e448d8709e517c9c7b523fcd209f24eb38ca7
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon Nov 25 08:52:30 2019 -0700
>>
>>     io_uring: async workers should inherit the user creds
>>
>> and I'm attaching a 5.4 port of this patch, since the one in 5.5 is built
>> on top of new code. The 5.4 port will apply all the way back to 5.1 when
>> io_uring was introduced.
>>
>> Secondly, these two (in order):
>>
>> commit 4257c8ca13b084550574b8c9a667d9c90ff746eb
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon Nov 25 14:27:34 2019 -0700
>>
>>     net: separate out the msghdr copy from ___sys_{send,recv}msg()
>>
>> and
>>
>> commit d69e07793f891524c6bbf1e75b9ae69db4450953
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Mon Nov 25 17:04:13 2019 -0700
>>
>>     net: disallow ancillary data for __sys_{send,recv}msg_file()
>>
>> should be applied to 5.3/5.4 stable as well. They might look like pure
>> networking commits, but only io_uring uses the interface.
>>
>> These three fix important issues, which is why we need them in stable.
> 
> I've queued these three fixes to 5.4 and 5.3, thanks!

Thanks Sasha!

-- 
Jens Axboe

