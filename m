Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A5E1EB3DF
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 05:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFBDpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 23:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBDpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 23:45:23 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE51C061A0E
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 20:45:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id d6so790253pjs.3
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 20:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zPngmtXiMgnCeGZF8JqJgdDKHatVoKPuWqPaLZTCre4=;
        b=oUbImO9WO1tYq7aYfU/Hxuidn6t7kt+u/5XKrU7KH0M84kFkRnrDE/BNPsMvXXl67M
         PmWvvJgh7oxzga2yrXi/xR2ZLE3KfQfm+1m315yLtVUiiFVrm0zyfPJssaxVtVeFj+vz
         Jdd0HxHYoI6TFsdeYsdOOqOvAkOM8lqKqQhSFEDfi8+Bm8L2+lI7MZeMDi4ar42sO+5A
         JVD+ELyLaLjBt5ZuHX2iGgaIVZ8FK31/aVqlQ0aMocupAwjT8qu84fJ1OFIHf/iEKYiz
         BlyC/pYS7wbdTrTCZzfEzTwrgeHhylVIVtQ1TWXm1+6QTyegGY7aq3nZAIuxTd7Or49y
         QXlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zPngmtXiMgnCeGZF8JqJgdDKHatVoKPuWqPaLZTCre4=;
        b=qOeIdUGdV2YuJlvicotLjgQCjVISqH+8rmreQETgTwSL9NzIuKLyFpAJ38U4uUFM2I
         LxU+rkziL+wj1LjFRjkSRIh3aDxFRq20cukLyzw4eUaJoqoxTgrJAENTuGWQ/4xsCAIQ
         UfzmTIw8Z1GiXmzWCRSSfbJ7D2rxulxVlXZMdB54HK2qfI+ekzWJBYSlAjKrLtNWEvXg
         KrIlN6TG8OEqx7OztTT3cJmcfQxmcaXar18Z/jUMOMIuBZcitpJHsCrEuALOeuU1Vywq
         gvBaB1LeYN5rh2cIWN/vAmaD67euTDs7+rrRUgPbaJKOd5dczA0QXbkmuE2xJESU7Iiv
         yFaw==
X-Gm-Message-State: AOAM532nnMIUwptvSXUWRC2lCojdaHuA2v4Lfu1lkcBo9UuJv1r1EonD
        7tNA+J/0LdGUh18whbH1ngOZ/MVQ
X-Google-Smtp-Source: ABdhPJxbnZ9RFR5qTRdyfLmLfdCNfEE3sh6qYiH3MAbtfYszK8CHLCclyWkPX0bWI6vtTy+eHOTcVw==
X-Received: by 2002:a17:90a:aa8d:: with SMTP id l13mr3162597pjq.92.1591069521668;
        Mon, 01 Jun 2020 20:45:21 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 4sm738670pfn.205.2020.06.01.20.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:45:20 -0700 (PDT)
Subject: Re: List of patches to apply to stable releases (5/26)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
References: <20200527045828.GA2874@roeck-us.net>
 <20200601165835.GC1037203@kroah.com> <20200601192254.GA31870@roeck-us.net>
 <20200602033032.GO1407771@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <2177ee1f-2603-d570-e80c-902fcab5e989@roeck-us.net>
Date:   Mon, 1 Jun 2020 20:45:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200602033032.GO1407771@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/1/20 8:30 PM, Sasha Levin wrote:
> On Mon, Jun 01, 2020 at 12:22:54PM -0700, Guenter Roeck wrote:
>> Hi Greg,
>>
>> On Mon, Jun 01, 2020 at 06:58:35PM +0200, Greg Kroah-Hartman wrote:
>>> On Tue, May 26, 2020 at 09:58:28PM -0700, Guenter Roeck wrote:
>>> > Upstream commit 106d45f350c7 ("scsi: zfcp: fix request object use-after-free in send path causing wrong traces")
>>> >   upstream: v5.3-rc1
>>> >     Fixes: d27a7cb91960 ("zfcp: trace on request for open and close of WKA port")
>>> >       in linux-4.4.y: b5752b0db014
>>> >       upstream: v4.9-rc1
>>> >     Affected branches:
>>> >       linux-4.4.y
>>> >       linux-4.9.y
>>> >       linux-4.14.y
>>> >       linux-4.19.y (already applied)
>>>
>>> This patch does not apply on those older branches, do you have a working
>>> backport?
>>
>> I am a bit at loss. Right now my script still tells me:
>>
>> Upstream commit 106d45f350c7 ("scsi: zfcp: fix request object use-after-free in send path causing wrong traces")
>>  upstream: v5.3-rc1
>>    Fixes: d27a7cb91960 ("zfcp: trace on request for open and close of WKA port")
>>      in linux-4.4.y: b5752b0db014
>>      upstream: v4.9-rc1
>>    Affected branches:
>>      linux-4.4.y
>>      linux-4.9.y
>>      linux-4.14.y
>>      linux-4.19.y (already applied)
>>
>> It only does that if the patch cherry-picks cleanly; otherwise it would
>> report conflicts. I checked and made sure that the patch was indeed applied
>> to my test branches for linux-{4.4,4.9,4.14}.y. I re-applied it, just to be
>> sure, with no problems. I also extracted it with git format-patch and
>> applied it with "git am", without issue.
> 
> Same here, so I've queued it up.
> 
>> What do you use to apply patches ?
> 
> *snicker*
> 
> https://i.pinimg.com/originals/ab/8f/f8/ab8ff8a51f1c2a9014cd9cc71c6def0a.png
> 
>> Anyway, my script also tells me:
>>
>> Upstream commit a33a5d2d16cb ("genirq/generic_pending: Do not lose pending affinity update")
>>  upstream: v4.18-rc1
>>    Fixes: 98229aa36caa ("x86/irq: Plug vector cleanup race")
>>      in linux-4.4.y: 996c591227d9
>>      upstream: v4.5-rc2
>>    Affected branches:
>>      linux-4.4.y (queued)
>>      linux-4.9.y (queued)
>>      linux-4.14.y
>>
>> and, indeed, it looks like a33a5d2d16cb is missing in v4.14.y-queue.
> 
> I think that Greg's script didn't like a33a5d2d16cb pointing to the
> wrong "fixes:" commit - 996c591227d9 rather than 98229aa36caa.
> 

Interesting. Makes me wonder how my script found the correct reference.
But then why did his script pick it up for 4.4.y and 4.9.y ?

Guenter
