Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA78162531
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 12:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgBRLEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 06:04:06 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:42394 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgBRLEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 06:04:06 -0500
Received: by mail-il1-f194.google.com with SMTP id x2so8120043ila.9
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 03:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2wfeG/i1JRpPbdA/vkKVEKY0AgFZFMUD3jEIPQ4l70g=;
        b=F92pNsaf0B0OnLjQma/oD9xPpmCW8OOAyIpf0G3SWPeyCa95GAsvo05MAOagESZKvc
         wiDGRrkfUTyxq3fBtannwAGYHLfHJooMDFqhTTEIAPkJEYNnZGdW2D9U5uIQH9BeT8ao
         ui7m0IUkayRm5U/qkCdJLcYh92jrsb5yi4V4ohU/VweLVqk75XMm9GJ/pPynt1KkjLFQ
         Yc2V078j408rpthj4wohu++i1JHBi7SGjKENQ3G466Jr7lEWvTBs/Bc+FxU/GtweqVdA
         qj/zpk/TZSnQLDQHtdOETA++E5qdu+H+AGIHQusFbilkZ3bd5nPxTyf/Gd5PNTve8nIs
         /E5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2wfeG/i1JRpPbdA/vkKVEKY0AgFZFMUD3jEIPQ4l70g=;
        b=FT+z0VJGwAPSL8Q0Ost0deCYSOAwyg7hRSy5fT9bmR5mEiWAlc/C1ufuh/+2C8s9q6
         /S3C9TTvRtvSUigEDrKl0kgAkdvqGq4+q6p2iKLEi59W6KXHp5Ft0gDn+yDsm0C24Hxo
         XDLHA9xuBYSrMbyoEQzzfzqXMAZO33yK+XYovHkP635ybe1ILlb8NnJmZQJo2kT8909h
         gTsGyu2pcoZuZQ8S8F1gKH79QQNU0mO3nuMB+0/LjJe0wK98FjDkXkci+PQue4bOFsEQ
         0WfBRV1f9dJeyVh/9HMlUzyN32Unf5KWXCm2RJOWPE1sjtfQ5gAFKCSATU7xpGb2/Fni
         DM5Q==
X-Gm-Message-State: APjAAAUKxGKf7sfJOrLPLnc0FGF/FOob9QIy1mCLtXhMCngo3ZxPhUv+
        5we3nvA+hx8xygXE86ef4c1HF63aLLMCWQYZppE=
X-Google-Smtp-Source: APXvYqyVtqSLccoJ6xcpcX14cLEUxus/LCT8/cyujNpbIvPr6uQBeDFC8ueh2SoF80lnOpi/LOXWVdNVvrIiDGgrVsg=
X-Received: by 2002:a92:911b:: with SMTP id t27mr18436316ild.142.1582023845026;
 Tue, 18 Feb 2020 03:04:05 -0800 (PST)
MIME-Version: 1.0
References: <20200217092459.GG31531@dhcp22.suse.cz> <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz> <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
 <20200217140430.GO31531@dhcp22.suse.cz> <CALOAHbA0=QAo0KkKf-i_tSamhLQX2mmmP7h-CX2bRz9qcOSGwA@mail.gmail.com>
 <20200217143529.GQ31531@dhcp22.suse.cz> <CALOAHbA=fL4AbLFBE3riuxO7k48OnqtBwa1YNk6KBm+=CA7hPw@mail.gmail.com>
 <20200217151417.GS31531@dhcp22.suse.cz> <CALOAHbD-K_BFjw-mLGWY-PWRe4J9BaMc0w7YmU9yp-t4iV4F_A@mail.gmail.com>
 <20200218085951.GE21113@dhcp22.suse.cz>
In-Reply-To: <20200218085951.GE21113@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 18 Feb 2020 19:03:29 +0800
Message-ID: <CALOAHbCJM12ExNuLVbXr7mfQxTLmPHAmwAoKVj+Xc+dPcUa-mQ@mail.gmail.com>
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 4:59 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Tue 18-02-20 10:09:06, Yafang Shao wrote:
> > On Mon, Feb 17, 2020 at 11:14 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Mon 17-02-20 22:40:22, Yafang Shao wrote:
> > > > On Mon, Feb 17, 2020 at 10:35 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > >
> > > > > On Mon 17-02-20 22:28:38, Yafang Shao wrote:
> > > > > > On Mon, Feb 17, 2020 at 10:04 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > >
> > > > > > > On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> > > > > > > > On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > > > > > > > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > > > > > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > > > > > > > > them won't be changed until next recalculation in this function. After
> > > > > > > > > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > > > > > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > > > > > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > > > > > > > > the old values of them will be used to calculate scan count, that is not
> > > > > > > > > > > > proper. We should reset them to zero in this case.
> > > > > > > > > > > >
> > > > > > > > > > > > Here's an example of this issue.
> > > > > > > > > > > >
> > > > > > > > > > > >     root_mem_cgroup
> > > > > > > > > > > >          /
> > > > > > > > > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > > > > > > > > >
> > > > > > > > > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > > > > > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > > > > > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > > > > > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > > > > > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > > > > > > > > 512M, and then this old value will be used in
> > > > > > > > > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > > > > > > > > That is not proper.
> > > > > > > > > > >
> > > > > > > > > > > Please document user visible effects of this patch. What does it mean
> > > > > > > > > > > that this is not proper behavior?
> > > > > > > > > >
> > > > > > > > > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > > > > > > > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > > > > > > > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > > > > > > > > a wrong protection value,
> > > > > > > > > > and the reclaimer can't reclaim the page cache pages protected by this
> > > > > > > > > > wrong protection.
> > > > > > > > >
> > > > > > > > > Could you be more specific please. Your example above says that emin is
> > > > > > > > > not going to be recalculated and stays at 512M even for a potential max
> > > > > > > > > limit reclaim. The min limit is still 512M so why is this value wrong?
> > > > > > > > >
> > > > > > > >
> > > > > > > > Because the relcaimers are changed or the root the relcaimer is changed.
> > > > > > > >
> > > > > > > > Kswapd begins to relcaim memcg-A.
> > > > > > > > kswapd
> > > > > > > >   |
> > > > > > > > calculate the {emin, elow} for memcg-A
> > > > > > > >  |
> > > > > > > > stores {emin, elow} in memory.{emin, elow} of memcg-A
> > > > > > > > |
> > > > > > > > This memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > > > > (See get_scan_count->mem_cgroup_protection)
> > > > > > > > |
> > > > > > > > exit
> > > > > > > > (And it won't relcaim memcg-A for a long time)
> > > > > > > >
> > > > > > > >
> > > > > > > > Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> > > > > > > > and the root of this new reclaimer is memcg-A.
> > > > > > > >
> > > > > > > > This memcg relcaimer begins to reclaim memcg-A.
> > > > > > > > memcg relcaimer
> > > > > > > >       |
> > > > > > > > As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> > > > > > > > for memcg-A.
> > > > > > > > (See if (memcg == root) in mem_cgroup_protected())
> > > > > > > >      |
> > > > > > > > The old memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > > > > (SO WE SHOULD CLEAR THE OLD VALUE)
> > > > > > >
> > > > > > > I am sorry but I still do not follow. Could you focus on _why_ the old
> > > > > > > value is no longer valid?
> > > > > >
> > > > > > Because for the new reclaimer the memory.{emin, elow} should be 0.
> > > > > > The old value may be not 0, but it was thought as 0 in the if
> > > > > > statement (if (memcg == root)).
> > > > >
> > > > > Why should it be 0 when the A.min is still 512MB?
> > > >
> > > > Because A's hard limit is reached and A is the root of memcg relcaimer.
> > >
> > > Confused. But your examples suggests that memory.max > memory.min so
> > > having an effective emin 0 or not doesn't make any difference.
> > >
> >
> > Why is it having an effective emin 0 if memory.max > memory.min ?
> > Note that effective emin is only set in function
> > mem_cgroup_protected(), so if we don't set it explicitly to 0 then it
> > can't be 0.
> >
> > Besides mem_cgroup_protected(), the effective emin also take effect in
> > the function mem_cgroup_protection(), but in this function it only use
> > the existed memory.emin rather than verifying memory.max > memory.min.
> >
> > So the real issue is in mem_cgroup_protection(), because the value it
> > is using may be an old value.
>
> I am sorry but I still do not follow. You keep focusing on talking about
> the code while I am really interested in the user visible semantic that
> you want to achieve. I am sorry to be dense here but believe me I am
> trying.
>

Sorry about my poor English that hasn't described it clearly.

> Your example doesn't help much because the effective protection doesn't
> play any role in the limit reclaim there AFAICS. I would even argue that
> emin == min is the proper thing in your example.
>
> So I can only recommend you to rethink your usecase and try to describe
> it in a higher level way.
>

Yes, I will try to improve the example and make it more clear.


-- 
Yafang Shao
DiDi
