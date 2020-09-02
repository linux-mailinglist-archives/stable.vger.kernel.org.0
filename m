Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C71425AB35
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 14:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgIBMfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 08:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIBMfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 08:35:13 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00BFC061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 05:35:11 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g4so439495edk.0
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 05:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X4rF/yq5M8ifTAczaYaXvE/5Rh0KHOWFFE/+jNdXZrs=;
        b=SX43yO/lEpB+wj0mnfbD4nBzXL8bX3IZcPZnzMlnu3ip23vQ2I8ocHqN1f9i8/4tDI
         bGLkc0pEP1LTiWJiGYvj77n/Nb5hpc167l+QaiVDmlebzyHAvB+iJP1U58CF5gK+hrrF
         z1jDRw6vgfAdo1jOY8vW9v9NPpTUaLTd7pN2/s6j7SLqc17yJLr1l6EgSo80rhZOxkoP
         DrcRcsL0FHNKw9gqxeFj53SeErvNxsq6y9htoAWg19HX8jFTb4PbfsE8Hoi0/Whq5cLW
         A3omfeeb54TcWf1YbK22kl3lFx1mQbDvMW6wjZ2Ve4mGNmuwqllqkeMnAQQzn/b8R6qK
         H8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X4rF/yq5M8ifTAczaYaXvE/5Rh0KHOWFFE/+jNdXZrs=;
        b=AEgPTk3oUw2WavNnqyu9Glf2Rz9w1B7ZnzytQOkAnJbkZh9VTDhs7aTB26FHYezLZn
         fpDhstCgz1s4g9yw5yBW/MXgsbfj23TKZ3Tgrcv3sVlqLJlZCqf8Bcc+neENXHEh3YZc
         IS74b4I2cA32pQWaoh7KI4eMHkr96MRLWJWHxzgyZcBKfHVWvbg81wYP2iWQ7mydVm10
         5d7aRRDBnBqcFs4uNz3GfHVBBHG4SZJbCU57mjoHFOGvxlmwQ4uQDfE7gKtEPeCdHux3
         fUzqjTirbIdXRR+l9zghe8sLYKMVhlIiSOPJ5VVtI+I0BxEvBS6psXPr7kCvTMQJwvaV
         VoIQ==
X-Gm-Message-State: AOAM531D6j2MBKzkXwsUPUXh351UBy9d9nz+NdLpi6lbPSQMsgM/KlGi
        mPbyCOLy+BypC3wB13/IkgtBM7JIuFJzjMBTjxRx8Q==
X-Google-Smtp-Source: ABdhPJwDY5rfx6SUKhnLfANCZH4T5a7778rYWZ4Dkd+N+1SS1+FyIo0aivBzlr1A066niH50hwCEBfUC59DPTKJn+Hw=
X-Received: by 2002:a05:6402:17da:: with SMTP id s26mr1105652edy.221.1599050109841;
 Wed, 02 Sep 2020 05:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200127173453.2089565-1-guro@fb.com> <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com> <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com> <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com>
 <20200901052819.GA52094@in.ibm.com> <CA+CK2bDZW4F-Y7PDiVZ_Jdbw8F5GCa26JRSXyxFbdu-Q6dEpRg@mail.gmail.com>
 <20200902062311.GB52094@in.ibm.com>
In-Reply-To: <20200902062311.GB52094@in.ibm.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 2 Sep 2020 08:34:34 -0400
Message-ID: <CA+CK2bB4bSUHc8wONCdbBXtnxmR_dvxVVW2mKs_hGnyG0+Gv6g@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I am on an old codebase that already has the fix that you are proposing,
> so I might be seeing someother issue which I will debug further.
>
> So looks like the loop in __offline_pages() had a call to
> drain_all_pages() before it was removed by
>
> c52e75935f8d: mm: remove extra drain pages on pcp list

I see, thanks. There is a reason to have the second drain, my fix is a
little better as it is performed only on a rare occasion when it is
needed, but I should add a FIXES tag. I have not checked
alloc_contig_range race.
