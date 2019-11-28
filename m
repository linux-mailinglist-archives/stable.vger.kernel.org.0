Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F12A910C235
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 03:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbfK1CSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 21:18:36 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41459 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbfK1CSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 21:18:36 -0500
Received: by mail-qk1-f194.google.com with SMTP id m125so21403836qkd.8
        for <stable@vger.kernel.org>; Wed, 27 Nov 2019 18:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=L1b0Bt33NdY9mtVStwod3wyXL+kGJUN8JzoIDUImWQE=;
        b=CP4KrifqYV0qY4EIeqeiHpNuCl2SZt17wUh8dlhL5LqRjuSYbOX7PzkaYbzabcA9WQ
         g3WNdsDNP2hOd71pA9tKT9K9n5dr/L7A8xqZJ9RWUmUPNrHFWGmzT+uEsbtuZ0uXvDqf
         c3Q4S/Q8j4OQ0Nm37BdcA+WCUO4/U6X8shT+MGzgJSEcxPTWwV9rNN/2FbsubT7+ykYo
         IFLMXIQddLnutk/egglz8tmEjro6IMipAhqvqAfcgIRsYEy/jTIMlTAp99ZnHm0pVbvn
         xYwVDIii+YQ5fN+9/xt3FskvKM+u+m/siJpSuMWq8FNkW6OpqunpsKITlE11F+qi6jx9
         mkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=L1b0Bt33NdY9mtVStwod3wyXL+kGJUN8JzoIDUImWQE=;
        b=AuosQeAwGEM+osm5C79wGUNLV0dCxf0oegZQNzeCewxqmhafG+vTU2MkeuwSq0rijS
         ypGz4dJMyBxHrzGiL9bZvFObHILT2jOFUv8MMi5/htvGlqYrwg1U8oCJwafh9eLHcHqH
         DVUvCxicNt7+vB3fLHnJKitNZsqdZuNl/3s/4/55evcnzVFUjAqQ0TJbffaZ0xYvfooo
         Ee4ZbxeB8v8SK4M9x2ti8OHU7OUfK77DBC9bcug+rDUuE6NEKJwRh4UFGMxGA+Vyfo7V
         fJj0oGNdXzjFC/f0Z/9qpSgjc/39vURVfbdfO27mlODhdSFvb+DTpGrF9+MqIJGd92jH
         xEOg==
X-Gm-Message-State: APjAAAXAwBZA4YzapJmR4lfrtehVorAXjNug1pZV+rqrGc/2MIuikEDc
        q4LVxACgls2N3i5dbl8kYH2N40Nc
X-Google-Smtp-Source: APXvYqzHdMk/+ROOXpYW9wOQlG20rkKSjCpAtiugW8Aeq61lEyIk+ESDJIvita/Kr3XP1x0QVjAjVg==
X-Received: by 2002:a37:9c0f:: with SMTP id f15mr7962962qke.297.1574907513465;
        Wed, 27 Nov 2019 18:18:33 -0800 (PST)
Received: from [192.168.1.101] ([104.246.133.66])
        by smtp.gmail.com with ESMTPSA id o10sm7688742qkg.83.2019.11.27.18.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 18:18:33 -0800 (PST)
Subject: Re: Bug Report - Kernel Branch 4.4.y - asus-wmi.c
To:     Sasha Levin <sashal@kernel.org>, Willy Tarreau <w@1wt.eu>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
References: <33bfa93a-3853-85f5-47f9-8a69ed9c656e@gmail.com>
 <20191123092701.GA2129125@kroah.com>
 <e452278c-4b5c-59fc-441c-94b41d817503@gmail.com>
 <20191123192244.GA16156@1wt.eu> <20191125133048.GA12367@sasha-vm>
From:   Bob Funk <bobfunk11@gmail.com>
Message-ID: <de753b87-d419-0b54-53c5-2efb48c7600f@gmail.com>
Date:   Wed, 27 Nov 2019 20:17:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191125133048.GA12367@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I tested out the patch that was announced today for the 4.4.204-stable 
review and
all is working well here. Thanks for addressing this.

Regards,

Bob Funk


On 11/25/19 7:30 AM, Sasha Levin wrote:
> On Sat, Nov 23, 2019 at 08:22:44PM +0100, Willy Tarreau wrote:
>> On Sat, Nov 23, 2019 at 01:08:03PM -0600, Bob Funk wrote:
>>> For the record, the patch that Willy offered does fix the issue on my
>>> affected
>>> system. That might be a better choice than my request to revert as 
>>> per the
>>> original email.
>>
>> Greg, FWIW I did nothing more than a regular backport so that you can 
>> take
>> it as-is. I think you dropped it from 4.4 because it did not apply well
>> and was not worth the hassle, but given that it fixes a regression 
>> caused
>> by another backport I think it makes sense to take it, at least so that
>> some users do not stop updating. The fix was only merged into 4.19, not
>> 4.4/4.9/4.14.
>>
>> The backports for 4.9 and 4.14 are easy to do, if you're willing to take
>> the patches I can do them as well, just let me know.
>
> Let's try something like this:
>
> For 4.14 and 4.9 I'll also grab db2582afa744 ("platform/x86:
> asus-nb-wmi: Support ALS on the Zenbook UX430UQ") which makes 401fee819
> apply cleanly.
>
> For 4.4, I'll grab this long list:
>
> 92a505e8055f ("platform/x86: asus-wmi: add SERIO_I8042 dependency")
> db2582afa744 ("platform/x86: asus-nb-wmi: Support ALS on the Zenbook 
> UX430UQ")
> 71f38c11cdb8 ("platform/x86: asus-wmi: Set specified XUSB2PR value for 
> X550LB")
> 999d4376c628 ("platform/x86: asus-wmi: fix asus ux303ub brightness 
> issue")
> a961a285b479 ("asus-wmi: Add quirk_no_rfkill_wapf4 for the Asus X456UF")
> a977e59c0c67 ("asus-wmi: Create quirk for airplane_mode LED")
> 6b7ff2af5286 ("asus-wmi: Add quirk_no_rfkill for the Asus Z550MA")
> 02db9ff7af18 ("asus-wmi: Add quirk_no_rfkill for the Asus U303LB")
> 2d735244b798 ("asus-wmi: Add quirk_no_rfkill for the Asus N552VW")
> b5643539b825 ("platform/x86: asus-wmi: Filter buggy scan codes on ASUS 
> Q500A")
> 7c1c184bb571 ("platform/x86: asus-wmi: try to set als by default")
> aca234f63788 ("asus-wmi: provide access to ALS control")
>
> Which looks scary, but it's all quirks for laptops folks are actually
> using with this kernel. Then 401fee819 also applies cleanly on 4.4.
>
