Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5921662DFE4
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 16:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiKQPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 10:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiKQPb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 10:31:57 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4536F039
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 07:31:55 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k2-20020a17090a4c8200b002187cce2f92so521695pjh.2
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 07:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YYbyGvr7R4QJ31YRKXqxJVIlaxGSfN/nVPLH9/segYo=;
        b=bhV42qvhSh6JlAr5LOzLdUDf3KEvgkBFoxSgGMdYhoPh4wNmiNmakO5pya7uYnFNX3
         9vKnTRjuljBe+GvnX2CkYyrlclqY1/0MWPRPksqKeLO4NhA2lGk5oFt9yTwq7qAyaDQy
         16zGofSttVBr7KsWP7JC5kJoDoJSMlh/tUIaMbm1gFflZT41h1lXXpfZvGjWMUnexXSC
         XFbOfhqZ8rRfdbenEkZQfMLMWRZ+KDxBAeflZifNmraa/XKSUNql8j51PuZNSs1hVJDw
         GmMGb3ZTI2FOYZ7Yes6t/xn8JvLFzyDsxqCyMmVIi3WtCSCO1fEfFREmA+vUGKciNLHl
         MI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYbyGvr7R4QJ31YRKXqxJVIlaxGSfN/nVPLH9/segYo=;
        b=M61M2/PEJj3vLGGeh/WAy1QaEQ6lhPw2c0lY25IPP363BZb6M9mj9gyuFgpYfBJ/83
         S3lwahrBwqCbTecRUg2KlFXVL8KLAPve9llSfRyuSJ3PMx2a59adPPeSe3AyL/O4h/zm
         ybYMCcUs9wTitTogWmYxGUrEXZ6I3d9fS/VaphoCdPnHbeoy7rQXWaKoK60g9B3GCGTg
         3ylJfejo1wuqwp3i+uyTV7hznAbZL6a3xZd8bfmNgXyLpLy0+i28S6iA/eVX8eZu79Nj
         lxcfbalS6CPosG6g0UYyXnEanv0ezib+gnHKiFLRdIYjVBJ/Lc2wPeuY8JjoO8MlYulO
         bI5g==
X-Gm-Message-State: ANoB5pnSuT4qcQJE02HuZ5wWlLn+1/+Q1JXM8fezPrwexuDv8uckiDdh
        RX32FsL7MDH1EsvaoYIAjTJcqDhZRgWwpe7bTwmF
X-Google-Smtp-Source: AA0mqf7PTUB1E6jT7w2n1cqUSGbsHd4TwbTJSD3G3paAWrXk8kz5NT/xoC/cgmw9kA0xw6mqSK8TjJ9No6As8SS+Zq4=
X-Received: by 2002:a17:902:b097:b0:17b:4ace:b67f with SMTP id
 p23-20020a170902b09700b0017b4aceb67fmr3442926plr.12.1668699115322; Thu, 17
 Nov 2022 07:31:55 -0800 (PST)
MIME-Version: 1.0
References: <20221115175652.3836811-1-roberto.sassu@huaweicloud.com>
 <20221115175652.3836811-4-roberto.sassu@huaweicloud.com> <CAHC9VhTA7SgFnTFGNxOGW38WSkWu7GSizBmNz=TuazUR4R_jUg@mail.gmail.com>
 <83cbff40f16a46e733a877d499b904cdf06949b6.camel@huaweicloud.com>
 <CAHC9VhRX0J8Z61_fH9T5O1ZpRQWSppQekxP8unJqStHuTwQkLQ@mail.gmail.com> <Y3XLgrYbIEpdW0vy@kroah.com>
In-Reply-To: <Y3XLgrYbIEpdW0vy@kroah.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 17 Nov 2022 10:31:44 -0500
Message-ID: <CAHC9VhTXegLqVH18AXTYrFPBn1WF0Wu8hbybc1Y5LTr-StFrOw@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/4] lsm: Redefine LSM_HOOK() macro to add return
 value flags as argument
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Roberto Sassu <roberto.sassu@huaweicloud.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 12:50 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Nov 16, 2022 at 05:04:05PM -0500, Paul Moore wrote:
> > On Wed, Nov 16, 2022 at 3:11 AM Roberto Sassu
> > <roberto.sassu@huaweicloud.com> wrote:
> > > On Tue, 2022-11-15 at 21:27 -0500, Paul Moore wrote:
> > > > On Tue, Nov 15, 2022 at 12:58 PM Roberto Sassu
> > > > <roberto.sassu@huaweicloud.com> wrote:
> > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > >
> > > > > Define four return value flags (LSM_RET_NEG, LSM_RET_ZERO, LSM_RET_ONE,
> > > > > LSM_RET_GT_ONE), one for each interval of interest (< 0, = 0, = 1, > 1).
> > > > >
> > > > > Redefine the LSM_HOOK() macro to add return value flags as argument, and
> > > > > set the correct flags for each LSM hook.
> > > > >
> > > > > Implementors of new LSM hooks should do the same as well.
> > > > >
> > > > > Cc: stable@vger.kernel.org # 5.7.x
> > > > > Fixes: 9d3fdea789c8 ("bpf: lsm: Provide attachment points for BPF LSM programs")
> > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > ---
> > > > >  include/linux/bpf_lsm.h       |   2 +-
> > > > >  include/linux/lsm_hook_defs.h | 779 ++++++++++++++++++++--------------
> > > > >  include/linux/lsm_hooks.h     |   9 +-
> > > > >  kernel/bpf/bpf_lsm.c          |   5 +-
> > > > >  security/bpf/hooks.c          |   2 +-
> > > > >  security/security.c           |   4 +-
> > > > >  6 files changed, 466 insertions(+), 335 deletions(-)
> > > >
> > > > Just a quick note here that even if we wanted to do something like
> > > > this, it is absolutely not -stable kernel material.  No way.
> > >
> > > I was unsure about that. We need a proper fix for this issue that needs
> > > to be backported to some kernels. I saw this more like a dependency.
> > > But I agree with you that it would be unlikely that this patch is
> > > applied to stable kernels.
> > >
> > > For stable kernels, what it would be the proper way? We still need to
> > > maintain an allow list of functions that allow a positive return value,
> > > at least. Should it be in the eBPF code only?
> >
> > Ideally the fix for -stable is the same as what is done for Linus'
> > kernel (ignoring backport fuzzing), so I would wait and see how that
> > ends up first.  However, if the patchset for Linus' tree is
> > particularly large and touches a lot of code, you may need to work on
> > something a bit more targeted to the specific problem.  I tend to be
> > more conservative than most kernel devs when it comes to -stable
> > patches, but if you can't backport the main upstream patchset, smaller
> > (both in terms of impact and lines changed) is almost always better.
>
> No, the mainline patch (what is in Linus's tree), is almost always
> better and preferred for stable backports.  When you diverge, bugs
> happen, almost every time, and it makes later fixes harder to backport
> as well.
>
> But first work on solving the problem in Linus's tree.  Don't worry
> about stable trees until after the correct solution is merged.

Perhaps you missed my very first sentence where I mentioned exactly
the same things: solve it in Linus' tree first, backports of patches
in Linus' tree is ideal.

-- 
paul-moore.com
