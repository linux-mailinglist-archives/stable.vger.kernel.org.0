Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D8736B5F5
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 17:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhDZPkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 11:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhDZPkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 11:40:40 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F5EC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 08:39:58 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id t21so5598470iob.2
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 08:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LjbqQG3DviMiP2av4HbpIQ8Mt5hX+sErU4mb+U5e2wo=;
        b=ROWNFVZj+ydjI+8OUR7AQCDZVI0u0nNXuZLrnqmVoskWyF6c5eh4A1gRQSSejkunuF
         n61ZAlRtvw24Lbd5d6R1UrkSm5x5wU6M4prBX4rxhQ/5EExaBltpuzIIC4qX4SkIs/9F
         vXP6KK6YmoKHeC2I0JleVy1laK/ddIyPbKgjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LjbqQG3DviMiP2av4HbpIQ8Mt5hX+sErU4mb+U5e2wo=;
        b=gJGX44U3z6wnNCACVTMgso6RMzQE/wFSYZ7/dlODxs/6ya4+R/oPjVxXwyQDwl7zmC
         R7BZXMBgErTTziw5czoO8croDQiX0FlMZTJSb3UbJSG2Z1nKXkM3mtaBDo3k0wItnb5w
         TuQq9I1nPc1eiQMgRfWv5kKMwv2bT5KlHGQ0e2jjeXbpLIYBmHm5uqTFkMr2sB68TXnM
         TlPJ05hWg1GJLy2JILofj8FZoO5WiWAN5J/Do99gjjEfPNyJIla86TLzu1HTmLaYcQiy
         M76/WUvec0VliqoN/KSSxilXRFsmx+l2dXNKehL7Cp40i1uHAVrdHtovNny7IIJgbIXJ
         c+ZA==
X-Gm-Message-State: AOAM531i3XVLWqMMUSB/IpjDR8JDbuSAQJLtL8ocqjxxdWPOsQqQ8Foz
        czHuMp+CoPfbi7d7WnNzDAES2w==
X-Google-Smtp-Source: ABdhPJw79Gv8VcbM6uywYG6xMKWaulHUBDD++XzmuHz6HADPt4rggji8gh6Ru/wTpmn8+GOk7t8O/A==
X-Received: by 2002:a5d:9ac7:: with SMTP id x7mr15070994ion.181.1619451597611;
        Mon, 26 Apr 2021 08:39:57 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c11sm7716381iom.25.2021.04.26.08.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 08:39:57 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] usbip: vudc synchronize sysfs code paths"
 failed to apply to 4.14-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        Tom Seewald <tseewald@gmail.com>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <161812561233164@kroah.com> <YIMjud72SYv5t5tt@debian>
 <5a668128-93ff-8e77-f595-dea0c8233d58@linuxfoundation.org>
 <YIQu/4tcAaUB6rDQ@kroah.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c4d16db8-99fd-2236-a8f6-6dfa26be1182@linuxfoundation.org>
Date:   Mon, 26 Apr 2021 09:39:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YIQu/4tcAaUB6rDQ@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/21 8:45 AM, Greg KH wrote:
> On Fri, Apr 23, 2021 at 01:59:18PM -0600, Shuah Khan wrote:
>> On 4/23/21 1:44 PM, Sudip Mukherjee wrote:
>>> Hi Greg,
>>>
>>> On Sun, Apr 11, 2021 at 09:20:12AM +0200, gregkh@linuxfoundation.org wrote:
>>>>
>>>> The patch below does not apply to the 4.14-stable tree.
>>>> If someone wants it applied there, or to any other stable or longterm
>>>> tree, then please email the backport, including the original git commit
>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>> ------------------ original commit in Linus's tree ------------------
>>>>
>>>>   From bd8b82042269a95db48074b8bb400678dbac1815 Mon Sep 17 00:00:00 2001
>>>
>>> Just wondering if you have missed this one as I am not seeing it in your
>>> queue for 4.14-stable but can see in 4.9-stable queue. And this will apply
>>> directly on top of your 4.14-stable queue.
>>>
>>>
>> This patch needed some work. Tom sent in the patch.
>>
>> https://lore.kernel.org/stable/d2cc4517-4790-b3a7-eec0-16fe06ea22eb@linuxfoundation.org/
> 
> Ok, I missed that.
> 
> Can I get a set of patches just for 4.14.y now?  Mixing them in the
> series like that is a guarantee that someone will mess up.  And I did.
> 

Yes. My bad asking Tom to send this as a series. :(

Thanks Sudip for catching this.

Tom, Please resend this patch tagging it for 4.14.y

https://lore.kernel.org/stable/d2cc4517-4790-b3a7-eec0-16fe06ea22eb@linuxfoundation.org/

This is the only patch that needed back-port for 4.14.x. Others are
already in 4.14.y.

thanks,
-- Shuah
