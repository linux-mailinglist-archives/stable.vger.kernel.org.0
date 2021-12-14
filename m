Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDB2474CDD
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 21:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhLNU5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 15:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhLNU5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 15:57:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34B3C061574;
        Tue, 14 Dec 2021 12:57:51 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4415A616F3;
        Tue, 14 Dec 2021 20:57:51 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5265A60385;
        Tue, 14 Dec 2021 20:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639515470;
        bh=R9qmZKpcT5w0VsfJbKQW4+XRAWTvMIUvc+QUmb73qc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qkPbNuPXw203FLrZEFtUEahnpUOxFmOk2L3oT9K4CLSyOgiR6GX4LNCsTttcIfG2a
         nviKWftaaWKl4q4oexeadnqveVPKmev7+zRmj3deZqEf/CLSOQFYjtBC77RYNu5MII
         E9XOQ9/TENrvRwyBdqA2YOZhhjEFyXlyPhmE4HcQ=
Date:   Tue, 14 Dec 2021 12:57:48 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Dennis Zhou <dennis@kernel.org>,
        Alexey Makhalov <amakhalov@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Message-Id: <20211214125748.974a400f0b05a633f9b971b7@linux-foundation.org>
In-Reply-To: <Ybht6kqwI0aPx3Jr@dhcp22.suse.cz>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
        <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
        <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
        <YYpTy9eXZucxuRO/@dhcp22.suse.cz>
        <YY6wZMcx/BeddUnH@fedora>
        <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
        <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
        <YZJZes9Gz9fe7bCC@dhcp22.suse.cz>
        <ABEDED57-93A9-4601-8EB6-2FF348A0E0BB@vmware.com>
        <YZMq++inSmJegJmj@fedora>
        <Ybht6kqwI0aPx3Jr@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 14 Dec 2021 11:11:54 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > I need some clarification here. It sounds like memoryless nodes work on
> > x86, but hotplug + memoryless nodes isn't a supported use case or you're
> > introducing it as a new use case?
> > 
> > If this is a new use case, then I'm inclined to say this patch should
> > NOT go in and a proper fix should be implemented on hotplug's side. I
> > don't want to be in the business of having/seeing this conversation
> > reoccur because we just papered over this issue in percpu.
> 
> The patch still seems to be in the mmotm tree. I have sent a different
> fix candidate [1] which should be more robust and cover also other potential
> places.
> 
> [1] http://lkml.kernel.org/r/20211214100732.26335-1-mhocko@kernel.org

Is cool, I'm paying attention.

We do want something short and simple for backporting to -stable (like
Alexey's patch) so please bear that in mind while preparing an
alternative.
