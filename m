Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAA21B78F0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgDXPJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgDXPJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:09:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A13C09B045
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 08:09:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n16so4747320pgb.7
        for <stable@vger.kernel.org>; Fri, 24 Apr 2020 08:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pBP/Zs60D+w1BXGvu6+cZEga3bfTSRUGw8RK1l65QZs=;
        b=AU/hKAk/aKWP81xUrS7pGqoGOy0YPrWpp6b0ECOOfGXZOwneJAfhmyuFl7g5xuxjZm
         v3EQvKZz1jcjzVSAAE6aDOOLSZhtKDiQ19BZXSIxca5epOiOUloOHlTNsADZoEgqKMi2
         GCmQHntkBzFjA0DXEUlCgZ2o6uGlqyOW2FirDtS1D01m+s+T9RZ5buEEJaxqJ6VBT4Ra
         /M4F3z4WvFDDrmBqJXAkHdHkNGJXlMbTF3YM8W6sosejwvS5jbhZgFbRoSeei6ck+mbn
         siFCDa1RPGn4gsRjpMJKFYjyEz+WrrhMMocIx/qN8uZsrmthEZWTRO9wOIEODP3GTWDS
         2Pfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pBP/Zs60D+w1BXGvu6+cZEga3bfTSRUGw8RK1l65QZs=;
        b=oveqEfWmFGkBIrQM7tyhSJSmOyYDAuj4ae3HA5eQBxmV2v4hrJDzohQa4fjNpSr9UB
         q91G7CMM8kx6N3WO8ehVVtyaMmxKIEomQwW1fX9w204EL5kU7jbNzMhZqbcKzLCEkMkG
         LiSkZhqUPXaf8YDpmw5oA+dkazH1eZSdx3YAEn/LGQW8beqGx3Ko3WFkMmnooLntdw8z
         p+axIbpm9N9IQUWfQkEuju6mZCbih1GaJjQKybHY3xUhKKvQckiMDCBdw//qUjdZQbdG
         6adl7Ma3tgl/erBwFr31RTFyRLi3rwkigPT0Ei2BJY03XMcnqUpIxIDSSfZKRtTR/Jjm
         5NFg==
X-Gm-Message-State: AGi0PubVMiY2qvBrnNpHlHuaEVTEcCfCdHfy6fpaVTANoUsq7vXRttER
        qJUudujL6x/nClnesKJLHv8=
X-Google-Smtp-Source: APiQypJm/s6oW9e7Q/MQnxu8TRhQulj1YC7YL/X6ORGa+sUzk5LYXf4cRKI5Q3bdLpPz6wHVSQaynQ==
X-Received: by 2002:a63:f70e:: with SMTP id x14mr9104605pgh.394.1587740997665;
        Fri, 24 Apr 2020 08:09:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j14sm5139738pjm.27.2020.04.24.08.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 08:09:56 -0700 (PDT)
Subject: Re: List of patches to apply to stable releases
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
References: <20200422194306.GA103402@roeck-us.net>
 <20200424101118.GC381429@kroah.com> <20200424140218.GA136135@roeck-us.net>
 <20200424150232.GC607082@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <56951059-beec-be4c-86e0-3a221d9b386a@roeck-us.net>
Date:   Fri, 24 Apr 2020 08:09:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424150232.GC607082@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/20 8:02 AM, Greg Kroah-Hartman wrote:
> On Fri, Apr 24, 2020 at 07:02:18AM -0700, Guenter Roeck wrote:
>> On Fri, Apr 24, 2020 at 12:11:18PM +0200, Greg Kroah-Hartman wrote:
>>> On Wed, Apr 22, 2020 at 12:43:06PM -0700, Guenter Roeck wrote:
>>>
>> [ ... ]
>>>>
>>>> Upstream commit ce4e45842de3 ("crypto: mxs-dcp - make symbols 'sha1_null_hash' and 'sha256_null_hash' static")
>>>>   upstream: v4.20-rc1
>>>>     Fixes: c709eebaf5c5 ("crypto: mxs-dcp - Fix SHA null hashes and output length")
>>>>       in linux-4.4.y: 33378afbd12b
>>>>       in linux-4.9.y: df1ef6f3c9ad
>>>>       in linux-4.14.y: c0933fa586b4
>>>>       in linux-4.19.y: 70ecd0459d03
>>>>       upstream: v4.20-rc1
>>>>     Affected branches:
>>>>       linux-4.4.y
>>>>       linux-4.9.y
>>>>       linux-4.14.y
>>>>       linux-4.19.y
>>>
>>> That's really not a "bug", but I'll take it to keep your scripts happy.
>>>
>> No need to do that - if it happens please let me know and feel free to
>> drop. The script finds lots of irrelevant patches which are (often
>> unnecessarily) marked as Fixes: (maybe we should have a rule stating that
>> comment changes or documentation changes don't count as "fix"). I already
>> drop a lot of them, and feedback like this helps me decide what to drop
>> in the future.
>>
>> In this case I kept the patch in the list not for the happiness of the
>> script but for the happiness of static analyzers. While it doesn't fix
>> a bug per se, it reduces the noise produced by those, which I think does
>> help because less noise improves focus on real bugs.
> 
> Yes it does, good point, but I don't want to start backporting all
> sparse warning fixes to stable kernels just yet :)
> 

NP, I'll drop those in the future.

Thanks,
Guenter
