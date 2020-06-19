Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D3520087F
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 14:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732889AbgFSMQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 08:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732885AbgFSMQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 08:16:37 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CA7C06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:16:35 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k8so7435127edq.4
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 05:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UgE82Odu1QuNA/1Xopmuc2hklEln20BAP0tNRA7aELs=;
        b=pKLyRfRhlfIyf+Fq+9vWY6cGAaIn0UYpU4kKt6/m0rOKHPKXD1fi3BTajMw9T4Cn7Y
         k1wmsFWJ2HbVcmXcMhlvIIEguWUAzLTy5zGM03bIRfetQCueEmJlbuqWVS4jmZAbzADD
         Y36ghZWmyopewqM93cVvU+z8uiol/gLPRZmnaoEqI9KSzM78A0+9rP8DsuhWF79UaTv+
         cLP8uLYkZ+GH4iaAcrwVU/WXKjwf+yUYh1siRqoPBrATjf9v+OkZa+sMrS5inpJNAw7n
         KPbK0ykfJjN98RjMGvli8pDi+ufhkvKRrK3ex2PANyf0t6oNUdhtA0j1cmcru1XNMsQj
         uDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UgE82Odu1QuNA/1Xopmuc2hklEln20BAP0tNRA7aELs=;
        b=gVPzr9A7Z1m6/+nQxz9drThxGBTjKd7NF7roQtQ1n7VCsBHZQvbtMP9db0B/UIDauA
         NYFiVI4wv8HbS74Enbm1CPW5WcIQzk8NmSLc9yD54/anlzDKAHDHgUOL9D18M4MN5gW7
         poikXVEQHpOV2lPPwChRUl9LZqFKo9/FaNpmOwqMyekdeTSTf80rnxRBPNnyC7woD3qC
         T6C5n64s2KOG+Z9Jx+9OQzjZ2ps1IfxDP0YCskVRFwK5uaCM3Sd4u2YCHD6RUEQiqREN
         kEVg4pOgV11eqcCcmFiEcvSrCQUJXJDz1XBNUfYZQPI6L/qMmKCC4kXuAhePv1b8mNHq
         oijQ==
X-Gm-Message-State: AOAM531effQt0e8MEh6VTWPBimyO2JPUEClvMb30eWZJOMJKUWhWEG/M
        laMmaaFYChuEKDS44FYK5cNxSxk9wmqdonG1sg5QeA==
X-Google-Smtp-Source: ABdhPJx2gaTsTvhiCWhXwUzvYFPiIwmx/VaNEkCt6z2xJTPtUg5sMsHPxZzW7/rmSkrQYQFwsh03XfrxarTjDd+ax5Q=
X-Received: by 2002:a05:6402:229b:: with SMTP id cw27mr2949047edb.346.1592568993775;
 Fri, 19 Jun 2020 05:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <15924957437531@kroah.com> <20200618162649.GA250996@kroah.com>
 <20200619022822.GV1931@sasha-vm> <20200619092137.GB12177@dhcp22.suse.cz> <82125cf7-a3e0-8596-ef6a-cda750bee28b@redhat.com>
In-Reply-To: <82125cf7-a3e0-8596-ef6a-cda750bee28b@redhat.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Fri, 19 Jun 2020 08:15:57 -0400
Message-ID: <CA+CK2bDVVcjvQAswxPe-2=DTOjf09Ty3tR69WdcEFaTgd87EqQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mm: call cond_resched() from
 deferred_init_memmap()" failed to apply to 5.7-stable tree
To:     David Hildenbrand <david@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        James Morris <jmorris@namei.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        pankaj.gupta.linux@gmail.com,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yiqian Wei <yiwei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I will send the backport. I think only three patches are needed that
were in my original series:

117003c32771 mm/pagealloc.c: call touch_nmi_watchdog() on max order
boundaries in deferred init
3d060856adfc mm: initialize deferred pages with interrupts enabled
da97f2d56bbd mm: call cond_resched() from deferred_init_memmap()

Pasha

On Fri, Jun 19, 2020 at 5:44 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 19.06.20 11:21, Michal Hocko wrote:
> > On Thu 18-06-20 22:28:22, Sasha Levin wrote:
> >> On Thu, Jun 18, 2020 at 06:26:49PM +0200, Greg KH wrote:
> >>> On Thu, Jun 18, 2020 at 05:55:43PM +0200, gregkh@linuxfoundation.org wrote:
> >>>>
> >>>> The patch below does not apply to the 5.7-stable tree.
> >>>> If someone wants it applied there, or to any other stable or longterm
> >>>> tree, then please email the backport, including the original git commit
> >>>> id to <stable@vger.kernel.org>.
> >>>
> >>> Oops, I applied things out of order, I've queued this and the 5.4
> >>> version up, but 4.19 doesn't apply as the dependant patch does not
> >>> apply.
> >>
> >> Something like this should work?
> >
> > Nope. Unless I am misreading the old code you are udner
> > pgdat_resize_lock. Or is there any other change queued before this
> > backport to remove the lock? (I didn't get to check more closely but it
> > would be 3d060856adfc5 IIRC).
>
> I recently did a similar backport. For pre-5.2, the following commits
> might be required to backport cleanly
>
> 56ec43d8b027 mm: drop meminit_pfn_in_nid as it is redundant
> 837566e7e08e mm: implement new zone specific memblock iterator
> 0e56acae4b4d mm: initialize MAX_ORDER_NR_PAGES at a time instead of
> doing larger sections
> b9705d8778e7 mm/page_alloc.c: fix regression with deferred struct page init
> 117003c32771 mm/pagealloc.c: call touch_nmi_watchdog() on max order
> boundaries in deferred init
> 3d060856adfc mm: initialize deferred pages with interrupts enabled
> da97f2d56bbd mm: call cond_resched() from deferred_init_memmap()
>
> did not verify, though, if anything else is missing (and which commits
> can be bypassed with less trouble).
>
> --
> Thanks,
>
> David / dhildenb
>
