Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1101625AB7E
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgIBMyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 08:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgIBMy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 08:54:27 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1D0C061244
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 05:54:26 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id n13so4790933edo.10
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 05:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jguf1LcpzdLbnb6m9J0BP0vWI/LKfE1Jts6BiXQTOXA=;
        b=HVouhgUe0h/dT/d25fmAt8+AdYkGMgTHsNTj5v0ofRuKkDS632pxM+ScRs+0Hy3nLB
         DQg3t5tY2PHuwD4M3USyJMU5+lCGOBjBvWIRfCYDvR1uXAoRV/weUz2gSAW/YzaPNURa
         bdfxgPpU+zKvGI07WPyDNuiDG/hb9hQI2afHwcrREBe+XMU2rqLo+5ZmdyRNMNgtNnAq
         bemfPQgUfLIOfyN9sCqvTNSP6TbOhP7odrcAnsvG82RdBk1oU7lD2QZd7LfgMPMz485Z
         Vgnwbx9hyLy6RbBIBo2AtdkOVIvPpzojlLk71ifI/7XXL+r1pLdsrmvR7tu76psXNaoT
         1e8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jguf1LcpzdLbnb6m9J0BP0vWI/LKfE1Jts6BiXQTOXA=;
        b=j5oc5yhOF3qwG+1Bn78ecE3wqzynq9Lcev2dbvM1tgHBXSZgWOh2ONtdJZdAJNYhiN
         jL+xGKxIzLOY76dKCYOGOodjIv2SO1YPRKQV7TJuOs+BKHWm/Z7jqvUrjKenAMwl0McD
         pwoEueDu6rexOe+03LVNKMK/zWbtxnt48kskPOujG4wWzrezTVIBYVb5lHywO43XT2e4
         5DJTqwv/+T273XBQsQQtVTgER58s4UIzhiUM2MKgj3n/Z+rOb5EN2KZRqzct+TeO420F
         22WFY4Rjxj6AY091bAonkAUAhNnYJ/qclqH6y9Pg8tFfk3WVPE1WRx7Pc68pS4Icr4B1
         KMyA==
X-Gm-Message-State: AOAM531e0Xkk03ECtHD8cVwaj8b6dbXv5OyXyFJ50r1L7+zYO1eVoyVr
        IqZei3+6+2prKIp/HjlSEaV6IyLPKnewnejLSJpR2w==
X-Google-Smtp-Source: ABdhPJyaN78gS/ZUa0KTrLX84zGJiMFwqPH7s7EsAhv3YTCXunsjJ0gi6JjMwMbqDGXOC126EP7OpX0Pk8dwY/z8JZ4=
X-Received: by 2002:a05:6402:1d0f:: with SMTP id dg15mr6629378edb.342.1599051265010;
 Wed, 02 Sep 2020 05:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200127173453.2089565-1-guro@fb.com> <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com> <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com> <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
 <6469324e-afa2-18b4-81fb-9e96466c1bf3@suse.cz> <20200902113204.GD4617@dhcp22.suse.cz>
In-Reply-To: <20200902113204.GD4617@dhcp22.suse.cz>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 2 Sep 2020 08:53:49 -0400
Message-ID: <CA+CK2bA6EpfSMZD6egysFqdw0tZFuPAxEJc-rQbJTnjf+u2TGA@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
To:     Michal Hocko <mhocko@suse.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 2, 2020 at 7:32 AM Michal Hocko <mhocko@suse.com> wrote:
>
> On Wed 02-09-20 11:53:00, Vlastimil Babka wrote:
> > >> > > Thread #2: ccs killer kthread
> > >> > >    css_killed_work_fn
> > >> > >      cgroup_mutex  <- Grab this Mutex
> > >> > >      mem_cgroup_css_offline
> > >> > >        memcg_offline_kmem.part
> > >> > >           memcg_deactivate_kmem_caches
> > >> > >             get_online_mems
> > >> > >               mem_hotplug_lock <- waits for Thread#1 to get read access
>
> And one more thing. THis has been brought up several times already.
> Maybe I have forgoten but why do we take hotplug locks in this path in
> the first place? Memory hotplug notifier takes slab_mutex so this
> shouldn't be really needed.

Good point, it seems this lock can be completely removed from
memcg_deactivate_kmem_caches

Pasha

> --
> Michal Hocko
> SUSE Labs
