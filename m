Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7C0A0389
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfH1Nnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 09:43:47 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38165 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfH1Nnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 09:43:46 -0400
Received: by mail-pg1-f193.google.com with SMTP id e11so1506205pga.5
        for <stable@vger.kernel.org>; Wed, 28 Aug 2019 06:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+l/FIe+9zrU0l53l7lGXu9AZmeV4OwcpuLm/cJNgKPI=;
        b=N9EB8jt+CJv33Nblf6j4YeidlvaNIsmCEbb/fvQ/+1W6sNR0Q1s5uM/WTF4iRAtXP/
         VI+LNlCH+jXi9mo8X6Dp28KW6KaSRiYmogl0FEBgwYlQvFGjVeVN8gZ9O2Bh124MKnrU
         OvmCeI1NthGJANyKB9TrCg6vv/OHEUY2XTakxtAUpfhOq3Ht73gqS1LzXa1pOyZN+tDY
         k8JQc6UfPtSzfhFnGfKQWsN2cwKk2SprxTHBkeFy+foQ9GGWRgz4uSbFilo0Xn2WecvM
         xzAGFB7DmLT7+YXdfINUpEHcGQRtoPgzoGb/s5P7okPNb/lvueP6+RdoIyp/KRyy4SIi
         WPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+l/FIe+9zrU0l53l7lGXu9AZmeV4OwcpuLm/cJNgKPI=;
        b=DPUe9HRZlZiwLWqYTb8bCD/+bMbUUrF9052IOFGZmx5B5bbv+unSlKg6/rs/w3bceP
         sKH/wSTU/O4vogX6p2a7GAC6jDwVnHwYTDr87Um5l1Zut9GFYVmJewy3LiBdruuRAtoT
         UfYOx7+CpTdzGkwBYWF2DHm48wUT49/zftibGXVY8KG7p8ryNfAYSBHEiKOcXEB7U5xe
         q5pVuiTQCzN1iI1lP6msqkOfcNU78VM41jEG8DEylO3HBwPos+8GLZM9T1PbfSmTZeiN
         rDuTF3ajoNo5d0xN0l5rJtyBu3WhJLVKoeMCnHVLXwE6Uh/uO4tn0mH4svJI60j5gvf2
         3pUA==
X-Gm-Message-State: APjAAAUFI0ce3weAQQXfvag3xazADxPxTDIL3aKkOaMzSnAJNqkYM5Qp
        QHWjviWeguUd+sK83+kfBD160EJr
X-Google-Smtp-Source: APXvYqyOTvmsW5u/ZP3ohp5VlgN79iFs5YcBiqsGfTmDnaHcTsp5MPZkg6tueGgEOMt3jdXbKXCmAw==
X-Received: by 2002:a63:b102:: with SMTP id r2mr3464525pgf.370.1566999825523;
        Wed, 28 Aug 2019 06:43:45 -0700 (PDT)
Received: from server.roeck-us.net (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id e129sm5956264pfa.92.2019.08.28.06.43.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 06:43:44 -0700 (PDT)
Subject: Re: Patches potentially missing from stable releases
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
References: <20190827171621.GA30360@roeck-us.net>
 <20190827181003.GR5281@sasha-vm> <20190827200151.GA19618@roeck-us.net>
 <20190827202901.GB1118@kroah.com> <20190827204841.GA21062@roeck-us.net>
 <20190828084107.GB29927@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1ff990c8-3ea8-5f8b-78b6-d1d91da9e508@roeck-us.net>
Date:   Wed, 28 Aug 2019 06:43:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190828084107.GB29927@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/28/19 1:41 AM, Greg Kroah-Hartman wrote:
> On Tue, Aug 27, 2019 at 01:48:41PM -0700, Guenter Roeck wrote:
>> On Tue, Aug 27, 2019 at 10:29:01PM +0200, Greg Kroah-Hartman wrote:
>>> On Tue, Aug 27, 2019 at 01:01:51PM -0700, Guenter Roeck wrote:
>>>> On Tue, Aug 27, 2019 at 02:10:03PM -0400, Sasha Levin wrote:
>>>>> On Tue, Aug 27, 2019 at 10:16:21AM -0700, Guenter Roeck wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I recently wrote a script which identifies patches potentially missing
>>>>>> in downstream kernel branches. The idea is to identify patches backported/
>>>>>> applied to a downstream branch for which patches tagged with Fixes: are
>>>>>> available in the upstream kernel, but those fixes are missing from the
>>>>>> downstream branch. The script workflow is something like:
>>>>>>
>>>>>> - Identify locally applied patches in downstream branch
>>>>>> - For each patch, identify the matching upstream SHA
>>>>>> - Search the upstream kernel for Fixes: tags with this SHA
>>>>>> - If one or more patches with matching Fixes: tags are found, check
>>>>>> if the patch was applied to the downstream branch.
>>>>>> - If the patch was not applied to the downstream branch, report
>>>>>>
>>>>>> Running this script on chromeos-4.19 identified, not surprisingly, a number
>>>>>> of such patches. However, and more surprisingly, it also identified several
>>>>>> patches applied to v4.19.y for which fixes are available in the upstream
>>>>>> kernel, but those fixes have not been applied to v4.19.y. Some of those
>>>>>> are on the cosmetic side, but several seem to be relevant. I didn't
>>>>>> cross-check all of them, but the ones I tried did apply to linux-4.19.y.
>>>>>> The complete list is attached below.
>>>>>>
>>>>>> Question: Do Sasha's automated scripts identify such patches ? If not,
>>>>>> would it make sense to do it ? Or is there some reason why the patches
>>>>>> have not been applied to v4.19.y ?
>>>>>
>>>>> Hey Guenter,
>>>>>
>>>>> I have a very similar script with a slight difference: I don't try to
>>>>> find just "Fixes:" tags, but rather just any reference from one patch to
>>>>> another. This tends to catch cases where once patch states it's "a
>>>>> similar fix to ..." and such.
>>>>>
>>>>> The tricky part is that it's causing a whole bunch of false positives,
>>>>> which takes a while to weed through - and that's where the issue is
>>>>> right now.
>>>>>
>>>>
>>>> I didn't see any false positives, at least not yet. Would it possibly
>>>> make sense to start with looking at Fixes: ? After all, additional
>>>> references (wich higher chance for false positives) can always be
>>>> searched for later.
>>>
>>> I used to do this "by hand" with a tiny bit of automation, but need to
>>> step it up and do it "correctly" like you did.
>>>
>>> If you have a pointer to your script, I'd be glad to run it here locally
>>> to keep track of this, like I do so for patches tagged with syzbot
>>> issues.
>>>
>>
>> I'd have to rewrite it to work with stable branches. Its current
>> primary goal is to assist the rebase of one chromeos branch to
>> a later upstream kernel release. I just repurposed part of it and
>> use the generated databases to identify patches tagged with Fixes:.
>>
>> I'll be happy to do that and make it work on stable branches in
>> general if you think it would add value.
> 
> No worries, I can add the functionality to my local scripts that I have.
> If you just had happened to have it in stand-alone format, it would have
> saved me 30 minutes or so :)
> 

I'll do it anyway. Already almost done. You are apparently better than me,
though. It takes me a bit more than 30 minutes, but then I am using the
opportunity to improve the scripts a bit. I'll publish the whole thing
at github once complete.

Guenter
