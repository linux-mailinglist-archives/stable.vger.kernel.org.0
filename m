Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923E712F956
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgACOur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:50:47 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39426 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACOur (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 09:50:47 -0500
Received: by mail-pg1-f196.google.com with SMTP id b137so23536414pga.6
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 06:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KeBErDxCFP50D3bEt9lREg3Hyksc/0x+hEjtuNqb8Cs=;
        b=fQqf0B9EqcY+Q6vSCDjueO+Tn7PzONhPyiZowkQJ+DcEqzZ3BAGwwI7sjdFQM2P6Tm
         cu49nVoV2AjTTHerJexFbrg1vMChixx4AwVXrymvz6Dwfedo94usFZJnVTXn0Un+enF1
         2rdiT8dEUwcotRzYbb2MLTT+7rcE25nKY3J4aE4d/TvzjZi5VnL1fTOBbe/eRlJjPEQN
         8keEL3zAzwQNXN0xLResla1SR6DBk07qkM6kAz0YfFgOq7bpKUnY1nMeDz+ZC3J5RPvb
         dsBYvkhIR7SKvm9zm9twO4fd3qFMGrZ0kNhwVjx/MTYy0A2KD63cLakq/KOIx8MfGEKh
         W8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KeBErDxCFP50D3bEt9lREg3Hyksc/0x+hEjtuNqb8Cs=;
        b=UiWkfNwZ13ypecl5OEK62wmk5DGUalVnfySRCQVKxEwgcnzyTju7gjc0gzDDnOx+nH
         iosAwrEs8Az/1WiCdhqL1Ethqc+zKBHCn6otp7dpdXYGnLG1R55GfwtaK8JasNV33JbT
         ZefLZVaLZrCd/1LeGv8arj2O6DWlCgZcxWIlpYviiScGVIYFPPiqi76YGBGOlyeoTyx5
         3M7c6Yh34LX4L/28KoAIGCuIiK35Ci0YC4tHFO/h5VHYFiOq69fppdVEQYFiTVQKJmG6
         +tX4rz72yL5vvU6ldA5zqfVX/NuE0ccizlRfoBu0FpIqS2R6CMdIiPEtyi1pOU0tv+S9
         WA2Q==
X-Gm-Message-State: APjAAAUF6FBohn4OFzLYfR5ShtwnXUskCrfh46kXoEBLkTplMfHQAgqV
        NOjCvMvlUnOSw/xz7N+FdiY=
X-Google-Smtp-Source: APXvYqyD+WTzQs7B599oDdt/G4dl5mzEvhgn00flC7Qn75czz3RpQaG3ok3TPeZ1O424H3j5HYKL4Q==
X-Received: by 2002:a63:483:: with SMTP id 125mr95394624pge.217.1578063046811;
        Fri, 03 Jan 2020 06:50:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u10sm63591394pgg.41.2020.01.03.06.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2020 06:50:46 -0800 (PST)
Subject: Re: Clock related crashes in v5.4.y-queue
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <20200102210119.GA250861@kroah.com> <20200102212837.GA9400@roeck-us.net>
 <20200103004024.GM16372@sasha-vm>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <83b51540-f635-19c7-1621-3241315cc62c@roeck-us.net>
Date:   Fri, 3 Jan 2020 06:50:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200103004024.GM16372@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/20 4:40 PM, Sasha Levin wrote:
> On Thu, Jan 02, 2020 at 01:28:37PM -0800, Guenter Roeck wrote:
>> On Thu, Jan 02, 2020 at 10:01:19PM +0100, Greg Kroah-Hartman wrote:
>>> On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
>>> > Hi,
>>> >
>>> > I see a number of crashes in the latest v5.4.y-queue; please see below
>>> > for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
>>> > leak in clk_unregister()").
>>> >
>>> > The context suggests recovery from a failed driver probe, and it appears
>>> > that the memory is released twice. Interestingly, I don't see the problem
>>> > in mainline.
>>> >
>>> > I would suggest to drop that patch from the stable queue.
>>>
>>> That does not look right, as you point out, so I will go drop it now.
>>>
>>> The logic of the clk structure lifetimes seems crazy, messing with krefs
>>> and just "knowing" the lifecycle of the other structures seems like a
>>> problem just waiting to happen...
>>>
>>
>> I agree. While the patch itself seems to be ok per Stephen's feedback,
>> we have to assume that there will be more secondary failures in addition
>> to the one I have discovered. Given that clocks are not normally
>> unregistered, I don't think fixing the memory leak is important enough
>> to risk the stability of stable releases.
>>
>> With all that in mind, I'd rather have this in mainline for a prolonged
>> period of time before considering it for stable release (if at all).
> 
> I would very much like to circle back and add both this patch and it's
> fix to the stable trees at some point in the future.
> 
> If the code is good enough for mainline it should be good enough for
> stable as well. If it's broken - let's fix it now instead of deferring
> this to when people try to upgrade their major kernel versions.
> 

This is where we differ strongly, and where I think the Linux community will
have to make a decision sometime soon. If "good enough for mainline" is a
relevant criteria for inclusion of a patch into stable releases, we don't
need stable releases anymore (we are backporting all bugs into those anyway).
Just use mainline.

Really, stable releases should be limited to fixing severe bugs. This is not
a fix for a severe bug, and on top of that it has side effects. True, those
side effects are that it uncovers other bugs, but that just makes it worse.
If we assume that my marginal testing covers, optimistically, 1% of the kernel,
and it discovers one bug, we have the potential of many more bugs littered
throughout the kernel which are now exposed. I really don't want to export
that risk into stable releases.

Guenter
