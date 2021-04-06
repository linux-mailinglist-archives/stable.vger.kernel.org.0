Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE69355875
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 17:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhDFPtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 11:49:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46897 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231784AbhDFPtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 11:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617724134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2E9FBI0FyS37cy8+M6B/bRI7HePcKctqTpcNooNX+xs=;
        b=CR+8hu3+ORH0Jsqfl43+O/7m/XfFmemgQo9yLdRnWmygljUl8m9HizgLy0kqV9fAVLuJQH
        PE+1Ul7ych60AtwAUbK8541Y+TYKlUdYBr9ehknP8dgt7zivx85M2V1zfr/83By4z/JDgQ
        pjAT0hykg9ifOnDw8W7h36HPsl0jWc4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-HWy_ofpnMTqAA03LCtCB1Q-1; Tue, 06 Apr 2021 11:48:53 -0400
X-MC-Unique: HWy_ofpnMTqAA03LCtCB1Q-1
Received: by mail-ed1-f70.google.com with SMTP id m21so985157edp.12
        for <stable@vger.kernel.org>; Tue, 06 Apr 2021 08:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2E9FBI0FyS37cy8+M6B/bRI7HePcKctqTpcNooNX+xs=;
        b=dFMvbv6uDrRr2JTBZdgIp2K1ULytRz1t3nTaQ6Rjwg7hympmJbfMgKwkOYDXcqNAkp
         7i1iJSxZenePvfh20B4Q4YrxE4iVgYeGabFY6/1Q3Vt1vAUsfBUi+B+0CLkpSYvaFbsU
         WtIZKb49iY0xN0jsZ0R6s5Wd/lvqxAS2CgVOWpMHqXftM1XVIDp87StZ/X7yx3jndohR
         mSzZSgJziEq8zS99DXnTzQ5wX7GeP+f4nVIUqsKIXE0PoPthySoR7D6PZFOkXn0o3vuE
         Odo0NqasNscgiIN+mjB6BPjRMx2JcG+1pZ1JAKWW6kWts5c/7QUKxCeoashAdVQkK9bK
         nUKg==
X-Gm-Message-State: AOAM533Xs0bkoERxJs4XIWZ82FHmOz+qiLe+lnsrMm2UaenTenhwwZ9T
        oY8RyTwx1upet5KLW9JSPmqwY5bQe4QXYlP714s0g9QoBg/AtEiijp5f5qVCUlgHRpsZzhxR6uE
        XZmJdSj6egBJ+D56a
X-Received: by 2002:a17:906:1957:: with SMTP id b23mr8137630eje.245.1617724132150;
        Tue, 06 Apr 2021 08:48:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmyB262cEUVNIN+Rjs909ZczmcbzipE3/L8ejlxteip+MOjiMkQOsVI3ODXeuCw2J3w2Qtlg==
X-Received: by 2002:a17:906:1957:: with SMTP id b23mr8137608eje.245.1617724131968;
        Tue, 06 Apr 2021 08:48:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lk12sm11419176ejb.14.2021.04.06.08.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 08:48:51 -0700 (PDT)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com> <YGxm+WISdIqfwqXD@sashalap>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs in
 TDP MMU map
Message-ID: <fd2030f3-55ba-6088-733b-ac6a551e2170@redhat.com>
Date:   Tue, 6 Apr 2021 17:48:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGxm+WISdIqfwqXD@sashalap>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/21 15:49, Sasha Levin wrote:
> On Tue, Apr 06, 2021 at 08:09:26AM +0200, Paolo Bonzini wrote:
>> Whoa no, you have included basically a whole new feature, except for 
>> the final patch that actually enables the feature.  The whole new MMU 
> 
> Right, we would usually grab dependencies rather than modifying the
> patch. It means we diverge less with upstream, and custom backports tend
> to be buggier than just grabbing dependencies.

In general I can't disagree.  However, you *are* modifying at least 
commit 048f49809c in your backport, so it's not clear where you draw the 
line and why you didn't ask for help (more on this below).

Only the first five patches here are actual prerequisites for an easy 
backport of the two commits that actually matter (a835429cda91, "KVM: 
x86/mmu: Ensure TLBs are flushed when yielding during GFN range zap"; 
and 048f49809c52, "KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU 
during NX zapping", 2021-03-30).  Everything after "KVM: x86/mmu: Yield 
in TDU MMU iter even if no SPTES changed" could be dropped without 
making it any harder to backport those two.

>> is still not meant to be used in production and development is still 
>> happening as of 5.13.
> 
> Unrelated to this discussion, but how are folks supposed to know which
> feature can and which feature can't be used in production? If it's a
> released kernel, in theory anyone can pick up 5.12 and use it in
> production.

It's not enabled by default and requires turning on a module parameter.

That also means that something like CKI will not notice if anything's 
wrong with these patches.  It also means that I could just shrug and 
hope that no one ever runs this code in 5.10 and 5.11 (which is actually 
the most likely case), but it is the process that is *just wrong*.

>> Were all these patches (82-97) included just to enable patch 98 ("KVM: 
>> x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")? Same 
>> for 105-120 in 5.11.
> 
> Yup. Is there anything wrong with those patches?

The big issue, and the one that you ignoredz every time we discuss this 
topic, is that this particular subset of 17 has AFAIK never been tested 
by anyone.

There's plenty of locking changes in here, one patch that you didn't 
backport has this in its commit message:

    This isn't technically a bug fix in the current code [...] but that
    is all very, very subtle, and will break at the slightest sneeze,

meaning that the locking in 5.10 and 5.11 was also less robust to 
changes elsewhere in the code.

Let's also talk about the process and the timing.  I got the "failed to 
apply" automated message last Friday and I was going to work on the 
backport today since yesterday was a holiday here.  I was *never* CCed 
on a post of this backport for maintainers to review; you guys 
*literally* took random subsets of patches from a feature that is new 
and in active development, and hoped that they worked on a past release.

I could be happy because you just provided me with a perfect example of 
why to use my employer's franken-kernel instead of upstream stable 
kernels... ;) but this is not how a world-class operating system is 
developed.  Who cares if a VM breaks or even if my laptop panics; but 
I'd seriously fear for my data if you applied the same attitude to XFS 
or ext4fs.

For now, please drop all 17 patches from 5.10 and 5.11.  I'll send a 
tested backport as soon as possible.

Paolo

