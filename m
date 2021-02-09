Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95493314AEB
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhBIIz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhBIIyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 03:54:00 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039DBC061788
        for <stable@vger.kernel.org>; Tue,  9 Feb 2021 00:53:19 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v14so5050587wro.7
        for <stable@vger.kernel.org>; Tue, 09 Feb 2021 00:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=H208pVEPEbQ1MKSr4OW/7+4dNKsHEjdg7nesnQMvyp8=;
        b=nEOooPDEVr2l45WeE7wb95Sm/9VCZYRDo2IDYlfp7OyUip+YG8taZwJNy6NutaQbTS
         uNEDbwAeJj/AJlyEOBYwxQHrNzv8uSi60zxOBa+Dm+iEDq9VfFAy74NJX72E8Ugk81n9
         9GVv/2zSK1G2H6rFXL7iSkSi9BuegWhZW6BwFbi2wXzNmBZcQ3nc0MEObEqgSKltJJGJ
         f1TBzMEIBHk61cssdfbyGaL12eLdhXEVUM8RI05F0CnZLoW3EFKiW0GZtrgyOTkzKIwW
         YgryQpDvKCmW0I/fwsvm4zcXW1w0RSQbtpVQH9rI8wVag5Q0xmZcWxk3QGCePVUpi/nm
         HbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=H208pVEPEbQ1MKSr4OW/7+4dNKsHEjdg7nesnQMvyp8=;
        b=T3Mej+p3mpuSs4FHEq4AFo2/tCrtMWLndLC+X8Frn8g8mZDH7Fz0H0a8dtAAOG3dbf
         DYFGmOI8W6fmVdKrnKE+rWYWjg7vHxpxR1W+CTQBOY3aAASqPsRP1jAU0Yw4e/bacFhU
         EuBWgqzNLPytjg/j7Nej+uDAGiT3Ru4Y93d/qpMO6ccaXIwj6FcOnFQ2Deamh+XGB4bT
         PD5PVx5EN21cs6knbvBzBRalfTLU1oFQArB7SsdrriGByK18VgNXn2dY08QLlH5s81bN
         yRyAY1pwGVt9oxZsU73lNfKHBeeUXZ+dyR2VCqjdD9Cla61pFUz9/trgYeRsBeBKvRZM
         FP5w==
X-Gm-Message-State: AOAM5323QFydP/tp4PoJUdwPjrpJ0EJT7P9JCdoXP373Lh57aNdk4dDV
        Z17UcrJNP2VT3w7O2bvPFKyyqagsGL0NxA==
X-Google-Smtp-Source: ABdhPJzN9QLvfxnc87FTfAej1i1vfCta3vnRz10Qfk8dnuz0GigPQqeqioTRm2sIPYW4akt9sBr4hg==
X-Received: by 2002:adf:fe82:: with SMTP id l2mr5098493wrr.341.1612860798577;
        Tue, 09 Feb 2021 00:53:18 -0800 (PST)
Received: from tmp.scylladb.com (bzq-109-67-58-110.red.bezeqint.net. [109.67.58.110])
        by smtp.googlemail.com with ESMTPSA id q15sm7180104wrr.58.2021.02.09.00.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 00:53:17 -0800 (PST)
Subject: Re: Linux 4.9.256
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
References: <1612535085125226@kroah.com>
 <23a28990-c465-f813-52a4-f7f3db007f9d@scylladb.com>
 <20210208185707.GC4035784@sasha-vm>
From:   Avi Kivity <avi@scylladb.com>
Message-ID: <219a26ec-fd6b-b841-43ef-57e04b417c4e@scylladb.com>
Date:   Tue, 9 Feb 2021 10:53:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210208185707.GC4035784@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/8/21 8:57 PM, Sasha Levin wrote:
> On Mon, Feb 08, 2021 at 05:50:21PM +0200, Avi Kivity wrote:
>> On 05/02/2021 16.26, Greg Kroah-Hartman wrote:
>>> I'm announcing the release of the 4.9.256 kernel.
>>>
>>> This, and the 4.4.256 release are a little bit "different" than normal.
>>>
>>> This contains only 1 patch, just the version bump from .255 to .256 
>>> which ends
>>> up causing the userspace-visable LINUX_VERSION_CODE to behave a bit 
>>> differently
>>> than normal due to the "overflow".
>>>
>>> With this release, KERNEL_VERSION(4, 9, 256) is the same as 
>>> KERNEL_VERSION(4, 10, 0).
>>
>>
>> I think this is a bad idea. Many kernel features can only be 
>> discovered by checking the kernel version. If a feature was 
>> introduced in 4.10, then an application can be tricked into thinking 
>> a 4.9 kernel has it.
>>
>>
>> IMO, better to stop LINUX_VERSION_CODE at 255 and introduce a 
>
> In the upstream (and new -stable fix) we did this part.
>
>> LINUX_VERSION_CODE_IMPROVED that has more bits for patchlevel.
>
> Do you have a usecase where it's actually needed? i.e. userspace that
> checks for -stable patchlevels?
>

Not stable patchlevels, but minors. So a change from 4.9 to 4.10 could 
be harmful.


I have two such examples (not on the 4.9->4.10 boundary), but they test 
the runtime version from uname(), not LINUX_VERSION_CODE, so they would 
be vulnerable to such a change.


