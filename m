Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36EA29F5CA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 21:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgJ2UEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 16:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgJ2UEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 16:04:09 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5D6C0613CF;
        Thu, 29 Oct 2020 13:04:08 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id m22so3506312ots.4;
        Thu, 29 Oct 2020 13:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=0F81eRwqq83+qPi3KAe4QleTCoxsZbUjRsximTvvoKs=;
        b=P8Z9ExBJWweugFwpJG5IKZv+5cPh/bIf89zOVMz2t+Z0cZQn3YZ/KVlwYUOOh4XVb6
         QdMK0pYiqohWFHRNiMjsiAbkShuGia47yxHzxtubf0tTzYnt7xh5TiUGVkeCXiuYnTh3
         JbvKOyk/kHbJD36FaZiJ2pB1pGXsE1456sYpTtODCM+ite6rupVJIlBQlHnmZalvIAbd
         +GqnmjMFSVh79RvDAAjSh+Jprb2ceqBxOyr4kWePOKIqs8docZa18zZeCfw+ApotwJ8c
         h6haT4L9iuYf+ZCkWt6lgrCmwUUOPaXtDG8W0qeKCkk4nlPMX+78mj0W3XSYhl7wNqyR
         ASPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0F81eRwqq83+qPi3KAe4QleTCoxsZbUjRsximTvvoKs=;
        b=F8Srxj67OU/PX6d72qJVFZgziwjyeHzYkbQM9pma7PdbiFkvpFmW3VzNVqUDlDCAgj
         IFvJOP+guIG7nzWKwYFqYBNAYzH/2HQRjoNLqhCHNoAUcYS6rMWFOznJ5Ln+F31z4Qwi
         E9fH+xLUbb1erJhLOEamDVhvpKa2X/C5EiObr6BqxxrbhZ+PEXwKWVMkRnqlL1c3uSsJ
         DhsJPcOA1Yc2ts6VQrk7Lihi5PYgnrLtAVBplBepVfFjE7M6EUrs7F7rplrNul+b7VOS
         3earrAX1KD3YV0AUNQ8X3MoIWCy8sDygoJp9956zNDGxJyi794dSDUY8kUhuvDKFgGKv
         5ERg==
X-Gm-Message-State: AOAM5322fzed8nwwDj/Vs25I9L9bng7YJM+sF3U7sHKjqGj5o3mgy0xp
        8alXeiLvUIv78D1I24I/rfjjwUbOChDMt4pK
X-Google-Smtp-Source: ABdhPJye46ERAb8qLBxqL1PfHuZHcNKRR5vk7joij+9tHoxTIGpZR1lIYZ0IfbMbXTxzrBUA9VXN7g==
X-Received: by 2002:a9d:365:: with SMTP id 92mr4473791otv.125.1604001847855;
        Thu, 29 Oct 2020 13:04:07 -0700 (PDT)
Received: from ?IPv6:2600:1700:4a30:eaf0::11? ([2600:1700:4a30:eaf0::11])
        by smtp.gmail.com with ESMTPSA id m65sm852018otc.36.2020.10.29.13.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 13:04:07 -0700 (PDT)
Subject: Re: [PATCH] Add devices for HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE
To:     Greg KH <greg@kroah.com>, Chris Ye <lzye@google.com>
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, trivial@kernel.org
References: <20201028235113.660272-1-lzye@google.com>
 <20201029054147.GB3039992@kroah.com>
 <CAFFudd+7DrJ+vYZ5wQ58mei6VMkMPGCpS1d7DwZMrzM-FVKzqQ@mail.gmail.com>
 <20201029191413.GB986195@kroah.com>
From:   Chris Ye <linzhao.ye@gmail.com>
Message-ID: <8975d128-e47f-c97c-fbd9-6045de67f34a@gmail.com>
Date:   Thu, 29 Oct 2020 13:04:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201029191413.GB986195@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Yes, I can see them on https://lore.kernel.org/linux-input/ now.

But I didn't put [PATCH v1] in subject,  should I sent them again with 
version?


Thanks!

On 10/29/20 12:14 PM, Greg KH wrote:
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> On Thu, Oct 29, 2020 at 08:23:57AM -0700, Chris Ye wrote:
>> Haha, thanks!
>> I have fixed my git config and sent a new mail, can you check it?
> Do you have a pointer to it on lore.kernel.org?
>
> And you did properly version the patch, right?
>
> thanks,
>
> greg k-h
