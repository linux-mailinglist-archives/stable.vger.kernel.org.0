Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4C936193B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 07:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhDPFZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 01:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhDPFZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 01:25:42 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13525C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 22:25:18 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id k18so21795646oik.1
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 22:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VuyXZGHUzyN4lwfmyii/Px2wkiAy/xsRWikujUkN/HI=;
        b=d4xAlFeOkJSgVNiLoL0p9j+Hp+OoKhi//AM8sTW4OqPkaEFjv5E30hOY3VrbRQMECl
         9x37ibWMhFoX7IVfPpJOYUwuPgbvZsxsehQ1e83gsKRlLraVDVbnSEBJY/VUCw+Vq8EK
         gvw09l6oDJ45g65Mk2Nr2DPtt49rH74oRoc7LaB3dysP1IiJErlBcRZVpmHysnRSnStm
         58Hy9akHLvba2MBrcWKK1J5phhB0+3i9knm+IGtDi3d8gI6Sxmer+8vjFf6l67VbgTs3
         Zbk1I7KF96qebuafRWvOsXw+zoKsN0qPFavYtDTdrWOP5GHDujRVbLXwRwwminNFj+OE
         iNcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VuyXZGHUzyN4lwfmyii/Px2wkiAy/xsRWikujUkN/HI=;
        b=K9my+Eas2pEGLHsnwztuj1L2SmjKjeK7YjFG5w52eZKZQ5RPsuc5oIrxjbiU5Lk9hH
         +MtWOw1w2x3iYmDaqZeFwq4KRrb/O/AY/rHeyY5S+/vMb87zAuSFf+zpuLMJFAzt0eCp
         gCZCb6NCPRpCzh5WL7CBRy5guRbt2Kay2XRt0zFOkTx1RRmMusQCOICgQJy5zxB/jbIp
         otSCowkuiEnSx/rSZ5nwyYcQmHlzDMNeVyRsQTkgI1B1/mPmKN+I/ZVtWsnakxBmgRU6
         NG5urM3Jw4+70hqXMnqr1utf0UrjONC0wqUCg121GYuj0D+fMXZaNijEqY3jFMxyxD1q
         CGAw==
X-Gm-Message-State: AOAM530E5YpDBthZCQVKFp6dVbNCYLbuNLTR7k7Q3MHiEw5Zhl8h71FJ
        w3k0Xqjoypyzyhoi24Vn2i2SpOCqU/I=
X-Google-Smtp-Source: ABdhPJyzmtVBh/sIiwY2ECQ2bDsgjPkOfEcA7BgJ/pDa47GWfy9Rqy9QTBjXAq1H9x4+h8s37QPKOg==
X-Received: by 2002:aca:d553:: with SMTP id m80mr5332288oig.38.1618550716728;
        Thu, 15 Apr 2021 22:25:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p64sm1164100oib.57.2021.04.15.22.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 22:25:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: netfilter/x_tables patches for v4.4.y..v4.14.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
 <YHhr1WuX4/0l+9lP@kroah.com> <20210415174146.GA30478@roeck-us.net>
 <YHkex2OYIOQa8G+g@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <8689e6b0-215a-bd62-e105-dae58d9b824a@roeck-us.net>
Date:   Thu, 15 Apr 2021 22:25:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YHkex2OYIOQa8G+g@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/15/21 10:21 PM, Greg Kroah-Hartman wrote:
> On Thu, Apr 15, 2021 at 10:41:46AM -0700, Guenter Roeck wrote:
>> On Thu, Apr 15, 2021 at 06:37:41PM +0200, Greg Kroah-Hartman wrote:
>>> On Thu, Apr 15, 2021 at 09:28:15AM -0700, Guenter Roeck wrote:
>>>> Hi Greg,
>>>>
>>>> please consider applying the following two patches to v4.4.y, v4.9.y, and v4.14.y
>>>>
>>>> 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
>>>> 175e476b8cdf ("netfilter: x_tables: Use correct memory barriers.")
>>>
>>> The second patch here says that it's only needed to go back until:
>>> 	    Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
>>>
>>> Which is only backported to 4.19.  So why do older kernels need that, is
>>> the fixes tag wrong?
>>>
>> Where do you get that from ? 7f5c6d4f665b is, from what I can see, in v3.0.
>>
>> $ git describe 7f5c6d4f665b
>> v2.6.39-rc1-159-g7f5c6d4f665b
>> $ git log --oneline v2.6.39..v3.0 | grep "netfilter: get rid of atomic ops in fast path"
>> 7f5c6d4f665b netfilter: get rid of atomic ops in fast path
> 
> Ah, my tool that checks where a patch comes from doesn't look past 3.1
> if it finds that it was mentioned in a released tree for various
> reasons, but when I look at the full sha1, it finds it properly, my
> fault...
> 

Yes, but still please don't apply anything. As mentioned in the other patch,
80055dab5de0 was fixed twice subsequently, and those fixes don't apply cleanly.
Better leave this alone.

Thanks,
Guenter

