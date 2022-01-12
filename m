Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410BB48BD72
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 03:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiALCyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 21:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348956AbiALCyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 21:54:20 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B80C06173F;
        Tue, 11 Jan 2022 18:54:19 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id o1so1019101ilo.6;
        Tue, 11 Jan 2022 18:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fgeNXgYsb4D9aJu5WojhZDNDfNDiciRoqWK6eNj8jxY=;
        b=R4+DJC81vvYpg1SvpPg/1yf09e1qZigjn48Bh7HRpsQAhliQ7qK2neIVY+k75coRtL
         /eM5IkW6tqaKswU+yAEF8hKo2iYV/9Rq/5i2s/FtGabv5ACocCcZsZLt81N5cA/tljJO
         5efS+oHiXYr9aOBDo0/gFJJ6R8KYjhh9VxuE8Uz2MmMg2VsTq7IeL+9KVBydHX6vFnK6
         xypd9Z6MNBv4fPMnykADGJcysp1A0dRiwPITnUAfhEC9w6uM8BxzJyezTROdE44nTkKG
         0rw2wyRj8OfdplDhDg4du1hm6CsO2QneOsFYkACFYJmx+QRKReY78Zy7zFzv/xQKIzFK
         0pxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fgeNXgYsb4D9aJu5WojhZDNDfNDiciRoqWK6eNj8jxY=;
        b=nNbrFII20sWjOYKtEzzJNXIYTdBzEqHC1OXlpV765WkxRJKB+ha0cPnL58mWQEK2wx
         4eAwO4T5R8bWTr7SGn7GmrETVV4HRB1VmauUeyKRB84a4skbxy8kFriSmYceihHLTnGV
         5oQGqmCWeD8fhNfnlHKd2BH4rivGEcAWPhvwv7TYWL9RNu89wURz+LA+yLVA/G1nuKKa
         m7C9ubZr5CUEhuOojbdlWNLDAoefeeS2m7ursKMCZY7BLLOZ6aaNME+DlnvcR28bJEM9
         xy+nWvwFrj6mKWedBI8IIlW+G/r7jkhWIUGtPVbl5cd0xGgDzyH2tjXacHcGz/HWmKR5
         3cCg==
X-Gm-Message-State: AOAM532Ors6qFVqmb2T6RKz3J1BaWsrHnhEifPjCJgDfI/AK6VRLxIQf
        R2rK/vgpTAszfDthisOdiOk=
X-Google-Smtp-Source: ABdhPJzJui0jZY6i8Cn4n9B4TEA10DVlpkaTHr8niM2ovhCyVvD8z/MDE5gyFidQM3eAgAMI1V6s2g==
X-Received: by 2002:a05:6e02:1ba8:: with SMTP id n8mr3796154ili.235.1641956058506;
        Tue, 11 Jan 2022 18:54:18 -0800 (PST)
Received: from ?IPV6:2601:282:8100:7:fcb0:7ceb:152:3c49? ([2601:282:8100:7:fcb0:7ceb:152:3c49])
        by smtp.gmail.com with ESMTPSA id q9sm6557588ils.79.2022.01.11.18.54.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 18:54:17 -0800 (PST)
Message-ID: <6735bf4f-b5e1-a982-6502-bd62c7715443@gmail.com>
Date:   Tue, 11 Jan 2022 19:54:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] HID: Ignore battery for Elan touchscreen on HP Envy X360
 15t-dr100
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        stable@vger.kernel.org
References: <20220110034935.15623-1-kkurbjun@gmail.com>
 <YdvYVQub0+pu5ahg@kroah.com>
From:   Karl Kurbjun <kkurbjun@gmail.com>
In-Reply-To: <YdvYVQub0+pu5ahg@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/9/22 23:55, Greg KH wrote:
> On Sun, Jan 09, 2022 at 08:49:35PM -0700, Karl Kurbjun wrote:
>> Battery status on Elan tablet driver is reported for the HP ENVY x360
>> 15t-dr100. There is no separate battery for the Elan controller resulting
>> in a battery level report of 0% or 1% depending on whether a stylus has
>> interacted with the screen. These low battery level reports causes a
>> variety of bad behavior in desktop environments. This patch adds the
>> appropriate quirk to indicate that the batery status is unused for this
>> target.
>>
>> Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
>> ---
>>   drivers/hid/hid-ids.h   | 1 +
>>   drivers/hid/hid-input.c | 2 ++
>>   2 files changed, 3 insertions(+)
> 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Thanks Greg,

Sorry for the mix-up on my side.  I read that page before I submitted 
the patch but I went back and reread it.  I was trying to follow "option 
1" but I am guessing what I messed up was the cc in the signed-off area 
rather than the cc through email?

I was looking for an example of that - I found these threads:
https://lore.kernel.org/lkml/20130618161238.626277186@linuxfoundation.org/
and this one was what I was originally modeling my submission off of:
https://lore.kernel.org/lkml/20210125183218.373193047@linuxfoundation.org/

Is there an example of how I should add the cc to the sign-off area.  As 
I read those threads the stable list was added to the email cc?  Should 
I resubmit it to the linux-input with the appropriate change or follow a 
different flow now that the first email went out?

If I were going to resubmit I think I would need to to like so:

...
 > target.
 >
Cc: stable@vger.kernel.org
 > Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
 > ---
 >  drivers/hid/hid-ids.h   | 1 +
 >  drivers/hid/hid-input.c | 2 ++
 >  2 files changed, 3 insertions(+)
 >
 > diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
 > index 19da07777d62..a5a5a64c7abc 100644
...

Is that correct?

Karl
