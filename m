Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0D64528C9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 04:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhKPDzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 22:55:38 -0500
Received: from mail-qt1-f169.google.com ([209.85.160.169]:35603 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbhKPDz1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 22:55:27 -0500
Received: by mail-qt1-f169.google.com with SMTP id j17so17763319qtx.2;
        Mon, 15 Nov 2021 19:52:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sj4fYm8wH0mARg8fNOIlD4wglN2W+wSR5DAgTtuz+CU=;
        b=gjNSF8pyKHxLus6/dIoT+x4B51rRVnSJzHAFiyEH3Anzr80c5MgMCFBVvrZ5NcJs9c
         Tx17ZOPlvryFu+Hsie8bueXhzc2usoR7s7mBo/nL/8CPjAURlNG5vHK3EALtkO8ng1mM
         EYKt8VAOu1SSQnwBYi8cUvBHXWNa1h9jFOK4cnUWGkq6mAMPIGTSkIELWIowgEErUxTx
         gV3m+j7Dtg3sFYhURdj/28v83Ga1nKr8qVUS2DBW3zVn51+F4vcEq/MRUfhMzlojHndU
         YCofNHBbbuleDI9BMyXQ9v/+fDkmr7b6WW82yLOhL+baGvO1EZofw8MzBw/RH4na7XzM
         40FA==
X-Gm-Message-State: AOAM530boIqWgVOyXt0jlzb3+BfPiCkqUKZpdV1UXrL/lW7mnvjwf147
        cGoUybIcUxmq2l0vD/tWRYOypXjdNYWO2Q==
X-Google-Smtp-Source: ABdhPJwXmtUWJ/7Sg2GoLUIiLu/a5A3ymF2qf/Bz6mAKJO6LIoVPl3N6gDd3uetkHbzqujSQ7nxqTg==
X-Received: by 2002:a05:622a:30a:: with SMTP id q10mr4321501qtw.267.1637034749735;
        Mon, 15 Nov 2021 19:52:29 -0800 (PST)
Received: from fedora (pool-173-68-57-129.nycmny.fios.verizon.net. [173.68.57.129])
        by smtp.gmail.com with ESMTPSA id v21sm6882916qta.0.2021.11.15.19.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 19:52:29 -0800 (PST)
Date:   Mon, 15 Nov 2021 22:52:27 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Alexey Makhalov <amakhalov@vmware.com>
Cc:     Michal Hocko <mhocko@suse.com>, Dennis Zhou <dennis@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-ID: <YZMq++inSmJegJmj@fedora>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
 <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
 <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
 <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
 <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 11:11:44PM +0000, Alexey Makhalov wrote:
> 
> 
> > On Nov 15, 2021, at 4:58 AM, Michal Hocko <mhocko@suse.com> wrote:
> > 
> > On Mon 15-11-21 11:04:16, Alexey Makhalov wrote:
> >> Hi Michal,
> >> 
> >>> 
> >>> I have asked several times for details about the specific setup that has
> >>> led to the reported crash. Without much success so far. Reproduction
> >>> steps would be the first step. That would allow somebody to work on this
> >>> at least if Alexey doesn't have time to dive into this deeper.
> >>> 
> >> 
> >> I didn’t know that repro steps are still not clear.
> >> 
> >> To reproduce the panic you need to have a system, where you can hot add
> >> the CPU that belongs to memoryless NUMA node which is not present and onlined
> >> yet. In other words, by hot adding CPU, you will add both CPU and NUMA node
> >> at the same time.
> > 
> > There seems to be something different in your setup because memory less
> > nodes have reportedly worked on x86. I suspect something must be
> > different in your setup. Maybe it is that you are adding a cpu that is
> > outside of possible cpus intialized during boot time. Those should have
> > their nodes initialized properly - at least per init_cpu_to_node. Your
> > report doesn't really explain how the cpu is hotadded. Maybe you are
> > trying to do something that has never been supported on x86.
> Memoryless nodes are supported by x86. But hot add of such nodes not quite
> done.
> 

I need some clarification here. It sounds like memoryless nodes work on
x86, but hotplug + memoryless nodes isn't a supported use case or you're
introducing it as a new use case?

If this is a new use case, then I'm inclined to say this patch should
NOT go in and a proper fix should be implemented on hotplug's side. I
don't want to be in the business of having/seeing this conversation
reoccur because we just papered over this issue in percpu.

Thanks,
Dennis
