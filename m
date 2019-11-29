Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B4810DAA2
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfK2Upz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:45:55 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:44001 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfK2Upz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:45:55 -0500
Received: by mail-pj1-f47.google.com with SMTP id g4so993181pjs.10
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gg5me5dViZKmX3j5Wl5G7oXUhPYuxdRzN5a2QntEtdY=;
        b=RPpCWkXjASFdGL8lUGiEm00+1Jw8VqN+E8nmsVIH7HQy+NfX4KSWliROvaWA8TKdv1
         oPhngwKUltxp7bdjirNdovk/8XIG80Bp26AlNZ7+K30F6VnNMr2YZHFraQMUbw9wJ+9d
         tW89K16h3pSqiLh3pgZch2pNdOcfEreEC+phSXg73Vvg34YauGy+9yWX1R3KH4wk5Ge3
         3kg00y+HEjWacssIgkU68/iBqtvMnTcw2fd34yZOxDJnc3Mzn6dDIRucrjxj6oC4NkE3
         9isiG8wSOIkvFSADyqkBDOVKs8TWlOOyEfHfvQQsALy1Q58Y0BNR/BktgDZKAmJTGAYu
         2ooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gg5me5dViZKmX3j5Wl5G7oXUhPYuxdRzN5a2QntEtdY=;
        b=reILgajsjhBNk9bjYDBNqfvUye1OnZ/zsLVsApB1ZJ/VVv+XZlp06XKVqx933fCOH6
         BleoAoBrka9Joa13PcWrp7urbFyBQZp6ydiVpNne/drMY4VLrYVYSmTIhIW5ROMypnKi
         xMOq2iw8mUTiEVvbAlLv8TxAn5HbO8SwdOSK7uKB3SBJsF1noBrU5xmt9ieiEkXCmZRV
         lhiQESmpQ6dFo6Ux6hufMBu1LMkZiOnBTLaiQeY5nCYt2UyAf3Jr9HzQhLpp2TUiPv03
         VL6ZzlPjq+Z/U9WYoCcGUTIE1cSJm3BeBbi5WLeW07AaYf4novI4Kfp0TRXv5XY68vQL
         WLLA==
X-Gm-Message-State: APjAAAWHKpSlPbZYWVvAzEwvaur9630IpDwYvcixcbllKcGB0vKueqnG
        HJGl7STmCrx4FXshJoLzVFc+eA==
X-Google-Smtp-Source: APXvYqzrgh9Qm7BMjFQKa7oMdl/3zmuWcPPllwiqcAAG1hrsImgTL4prpQ+lZjxxJFbWepsZltn+4w==
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr19937314pjb.99.1575060353342;
        Fri, 29 Nov 2019 12:45:53 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:6938:40fc:d284:b43? ([2605:e000:100e:8c61:6938:40fc:d284:b43])
        by smtp.gmail.com with ESMTPSA id b1sm15584966pjw.19.2019.11.29.12.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Nov 2019 12:45:52 -0800 (PST)
Subject: Re: Build failure on latest powerpc/merge (311ae9e159d8 io_uring: fix
 dead-hung for non-iter fixed rw)
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc:     stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <71cf82d5-5986-43b7-cf1c-acba429a89d6@c-s.fr>
 <3a95d445-1f5c-7750-f0de-ddc427800b3b@kernel.dk>
 <4ef71e74-848f-59d4-6b0b-d3a3c52095a0@c-s.fr>
 <5389b43a-259d-997c-41e6-5e84a91b012a@kernel.dk>
 <38cb2865-d887-d46d-94ef-4ebccff4dc60@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <884742fe-2eff-48ba-1382-83aab9a37a84@kernel.dk>
Date:   Fri, 29 Nov 2019 12:45:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <38cb2865-d887-d46d-94ef-4ebccff4dc60@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/29/19 10:07 AM, Pavel Begunkov wrote:
> On 29/11/2019 20:16, Jens Axboe wrote:
>> On 11/29/19 8:14 AM, Christophe Leroy wrote:
>>>>>
>>>>> Reverting commit 311ae9e159d8 ("io_uring: fix dead-hung for non-iter
>>>>> fixed rw") clears the failure.
>>>>>
>>>>> Most likely an #include is missing.
>>>>
>>>> Huh weird how the build bots didn't catch that. Does the below work?
>>>
>>> Yes it works, thanks.
>>
>> Thanks for reporting and testing, I've queued it up with your reported
>> and tested-by.
>>
> My bad, thanks for the report and fixing.

No worries, usually the build bots are great at finding these before
patches go upstream. They have been unreliable lately, unfortunately.

-- 
Jens Axboe

