Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704A6147A1E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgAXJLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:11:42 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25955 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgAXJLm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 04:11:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579857101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rW7myJJ2GuW+fTx8x7EBJbhNaqxnzwmpTqYDBQ5SZU=;
        b=EaAOe95p3edOD5PbIwBI2TS/KwR7AuUqH40ElfmkMq04vj+NcudIYWqeGRiwHYVS1SoEtN
        OtsOwceZ9vV7CacwExZ0hQcjqMoWnK0+IMRAvj4hnpOs4j0uwoGbt+e9kl4JEvfklWeIqx
        Lu/fKR78Q8C9CVJ9JlgAHPex9ohu7J0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-cLPm1fBNOQG2qYiwXxAl1w-1; Fri, 24 Jan 2020 04:11:39 -0500
X-MC-Unique: cLPm1fBNOQG2qYiwXxAl1w-1
Received: by mail-wm1-f69.google.com with SMTP id u203so218985wme.9
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 01:11:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4rW7myJJ2GuW+fTx8x7EBJbhNaqxnzwmpTqYDBQ5SZU=;
        b=KMSFcC7h67iks7ZcsVILXlYJzlQQ3qHQWoyLmVWUTmuUQudrFSthugo6ozEiopbhaz
         pJ00yopSL+75hPyx3CHQZ+WWBBuGHPHmNspDTRXiyS0ruuHDMXZXv7G28FmD7nvDAZd+
         2WlNZfsbR/wxmLzgrhIHjCF8TlCL3BLJOACVsl7/i1OrvSDKtfdm9xrR29PDzMLCPGzS
         I8SLAkG5WhJZvrt44cVyK2h9di/5ghT3dZxf1xc6KI+lxlTibPBahzLRPDhe5AYsV6w6
         IfmcLKach4aMy9i5AB2uIU05yuPY/Q3hFLDxJXaX9pzfB8pInpuAIzkq0n9QWxJ+gTSi
         ITyg==
X-Gm-Message-State: APjAAAUpNwD+Q+U8MWVYc4tX2px4uhFFhzj3bKe49ZHUQUly1NHpObfg
        ChqVdiKvXWB85XVAbE2apbBxcL/KXxHYdUTPKe889f/1nnaH9X+t5t0StIVxN6S8t+QBrjvxLIN
        Odh4XxJbSMViQ93+3
X-Received: by 2002:adf:f885:: with SMTP id u5mr3083557wrp.359.1579857097051;
        Fri, 24 Jan 2020 01:11:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqwHTA1utlLqgh3JNj/13z6suNbkceqhb5JYG+L0X3nT5kjvdpBpX5mJygE3kQEHccGMvWn7Cw==
X-Received: by 2002:adf:f885:: with SMTP id u5mr3083521wrp.359.1579857096726;
        Fri, 24 Jan 2020 01:11:36 -0800 (PST)
Received: from localhost.localdomain ([109.38.141.136])
        by smtp.gmail.com with ESMTPSA id g2sm6536988wrw.76.2020.01.24.01.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 01:11:35 -0800 (PST)
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de>
 <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de>
 <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
Date:   Fri, 24 Jan 2020 10:11:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87iml11ccf.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/24/20 9:35 AM, Thomas Gleixner wrote:
> Hans,
> 
> Hans de Goede <hdegoede@redhat.com> writes:
> 
>> Hi,
>>
>> Sorry for top posting, but this is a long and almost unreadable thread ...
>>
>> So it seems to me that a better fix would be to change the freq_desc_byt struct from:
>>
>> static const struct freq_desc freq_desc_byt = {
>>           1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
>> };
>>
>> to:
>>
>> static const struct freq_desc freq_desc_byt = {
>>           1, { 83333, 100000, 133300, 116700, 80000, 0, 0, 0 }
>> };
>>
>> That should give us the right TSC frequency without needing to mess with
>> the TSC_KNOWN_FREQ and TSC_RELIABLE flags.
> 
> Where does that number come from? Just math?

Yes just math, but perhaps the Intel folks can see if they can find some
datasheet to back this up ?

I mean if the calculated freq is off by that much, then chances are that
my solution actuallly is not only "just math" but also correct :)

Regards,

Hans

