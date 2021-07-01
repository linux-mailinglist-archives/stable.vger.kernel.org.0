Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC01B3B96C1
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 21:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhGATug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 15:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhGATuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Jul 2021 15:50:35 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B30C061762
        for <stable@vger.kernel.org>; Thu,  1 Jul 2021 12:48:04 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id t80so8632658oie.8
        for <stable@vger.kernel.org>; Thu, 01 Jul 2021 12:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=T3WswTQnX8ShmPwxROTSIgUVwoofsCfxjCzxWuNKLGw=;
        b=uu3mt67H1J3p7ttakTvs/6LDQ9UNM4e1jwGhT5v7wf1pks4oVJIkfKrPW13G63kgea
         uB1WnWV4A+PibbTL8Lb+b1VXRAn+sXjelzF+//giL3c7/rHb8dvG34j69n9qi4JPdiAs
         7YE+UuCKtZt0nAOw4xL7vlTe10wGDVlr9ospnpUs/yhl7zH+I15ocG60JbP9EmYQAfTM
         SO2os08uNtbK9lpxr975nLQFk1wNzYKwXhVMjE9DYdcyWGjg5+15SmHHm8+N55CCvp6h
         YzxUX9mAr1UEBCfgAmCNSRrchCisAT9oOdoQ1BjsXDwfF8/iVwi96YUFKuIhndF9z558
         E9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=T3WswTQnX8ShmPwxROTSIgUVwoofsCfxjCzxWuNKLGw=;
        b=gLL19K1bG+hrPcgv2WeVe5sav4HGxUoRzdfB8C/ZPDQ1cNBBihro6e5UakbGWraQwo
         LRc10Ug5jFRJrUbNga73dzChA3C95GnFghLACtfQq0yB3VnPux2t2NFPkiwUMAa827G7
         PvmIpHZqdajZy4/SDWskEeW3Sd4Ez7/cPbglAYcUQykjIRlZa04ge6o8Zt7aGmYC3ZNY
         ZPgmxuokSGFr/usRZbij7c4SqCd4WdCJWMztiMOtGixkfcynRSyCnQ1nU+rI59R0aJGI
         jrrXCJmrME4RqX3F9gZwLaQVNevBIJBhBlaF7fxRgW2wddhHs3SaR2gnC2SBMHQIas1I
         nbEA==
X-Gm-Message-State: AOAM531y0A3LkFGEULZyWFw1/lhqWPSLbR5VJbsz1z5XfVfAjjDdi48N
        yuBJNLR9YVIru1gXME9t8AG0KQ==
X-Google-Smtp-Source: ABdhPJyDcKtVdj3cfbLpdWD9QCDtlE8jET+2K5vm2MsMkemqfKQb1mIzNLG4H8m26IslMuG/P6QgeA==
X-Received: by 2002:a05:6808:13c8:: with SMTP id d8mr335635oiw.92.1625168883324;
        Thu, 01 Jul 2021 12:48:03 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id l8sm188259oib.45.2021.07.01.12.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 12:48:02 -0700 (PDT)
Date:   Thu, 1 Jul 2021 12:47:48 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Sasha Levin <sashal@kernel.org>
cc:     Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Xu Yu <xuyu@linux.alibaba.com>, Jue Wang <juew@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alex Shi <alexs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Subject: Re: mm/thp commits: please wait a few days
In-Reply-To: <265a4571-7eb6-e2e6-7cf9-6ef825cd3152@google.com>
Message-ID: <8ca517a0-421f-5aa0-26f7-f4c09f50ca2b@google.com>
References: <88937026-b998-8d9b-7a23-ff24576491f4@google.com> <YMrU4FRkrQ7AVo5d@kroah.com> <YNNMGjoMajhPNyiK@kroah.com> <ca4d4e0-531-3373-c6ee-a33d379a557c@google.com> <20210623134642.2927395a89b1d07bab620a20@linux-foundation.org> <c2bf7b2-a2d9-95a1-e322-4cf4b8613e9@google.com>
 <6b253bc4-2562-d1bb-18f2-517cfad5d5e7@google.com> <YNm93fkIPrqMwHzd@kroah.com> <366846c0-245a-771e-7a1-4a307ac6e5e1@google.com> <YNqTCV7DmYGZiZ7N@sashalap> <YNq4yJls+PKsULh0@kroah.com> <265a4571-7eb6-e2e6-7cf9-6ef825cd3152@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Jun 2021, Hugh Dickins wrote:
> On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:
> > On Mon, Jun 28, 2021 at 11:27:05PM -0400, Sasha Levin wrote:
> > > On Mon, Jun 28, 2021 at 10:12:57AM -0700, Hugh Dickins wrote:
> > > > On Mon, 28 Jun 2021, Greg Kroah-Hartman wrote:
> > > > > So could you just send a mbox of patches (or tarball), for the 4.19,
> > > > > 4.14, and 4.9 trees?  That would make it much easier to ensure I got
> > > > > them all correct.
> > > > 
> > > > At risk of irritating you, sorry, I am resisting: the more data I send
> > > > you, the more likely I am to mess it up in some stupid way.  Please ask
> > > > again and I shall, but I think your success with 5.12, 5.10, 5.4 just
> > > > means that you were right to take a break before 4.19, 4.14, 4.4.
> > > 
> > > I've tried following the instructions for 4.19, and that worked fine on
> > > my end too.
> > > 
> > > If no one objects, I can pick up 4.9-4.19 after the current set of
> > > kernels is released.
> > 
> > No objection from me, thanks!
> > 
> > greg k-h
> 
> Sure, Sasha, whenever suits you: thanks to you both.

I've now checked today's queue/4.19, queue/4.14, queue/4.9:
exactly as intended, thanks.

Hugh
