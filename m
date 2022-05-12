Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773C25253CC
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 19:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352513AbiELRiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 13:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357113AbiELRiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 13:38:16 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9516C5C671
        for <stable@vger.kernel.org>; Thu, 12 May 2022 10:38:15 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e194so6125213iof.11
        for <stable@vger.kernel.org>; Thu, 12 May 2022 10:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKMSw7vJtmevZcZnNt9tKXeDXLPCDPcF4gSaEC+Ohyo=;
        b=Ub5/VjcnYBIKJE54vhh9DuRGudjuDx3uN5WVtzxK1HoLa7Hmnq+YwT15QwLL/ilN7L
         VgZ8LRWN72bTEsbnNjHWJUNiX015YjoSOfPynDOwBZKdiZIeGsFeiVQaSouFyX1VwsEB
         43gHYUC/oHiUDZfGv3BXgd0z/sU3gwJ9hTL7OdVWagSUeU2KP8LmWQnCDbDCc5r4Mkvc
         D09/gxSxVQ6l4yYCBNQg2/hm93qLD4TZOpr2u5dd9tOz9jI0mDBMNt6SP2YJpxnt4KW+
         4lcqaICPIIpCFaWisLJOM0PMg8Y3MizGdDmHLPghvMGwUfETlwgDaYOUS364/UKvlMAV
         GFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKMSw7vJtmevZcZnNt9tKXeDXLPCDPcF4gSaEC+Ohyo=;
        b=5MPEh4s27mgvhLbdV/aNfSR8HHGjPfQ9mj+EAJVuEssbAA8mSrXY4NmVB1SADqmDUe
         gAjGjMN70dnt7l1OMm1tmrodueSDlEz51iLsV4dzKYjINtjQCSVCz6M0V3CP75OmhLKB
         gb8TwXGjkzyTzxwb6tepeufdnkIy6VfWEyhXXd2puPOIzUKkuY54s7viei4C3crCufnn
         J8aB6tFyd2C6IzPbwDuLHGA8rKbePkD0xL66PSAONbBZQPJwIIUXvSv4M8nXOAz9B2ZA
         469QawGsKA1Ib+JuY6JL4ABH+1z2xoiibEFfgnRD6CeW+RtibpG+gPlluMUywyfqxXfq
         HKmQ==
X-Gm-Message-State: AOAM5315I0MV63DLJCo4IMuwM1cxYrZA5jcKp95NuM0/z2h77TVQ0i+3
        VfDjV3zNm0f1LEIk5X+Z8O+4xxxmnHVCWEBRFAhLBA==
X-Google-Smtp-Source: ABdhPJxuqKdvaFA9Vz+Mrr1gtuFGQ8h1JDF3oIssb8hgw4NSQBLEY8jwnmmcDGop8ujtLWt9iGgDy5/Wg6toNu3GzZk=
X-Received: by 2002:a05:6638:3813:b0:32b:bc69:6783 with SMTP id
 i19-20020a056638381300b0032bbc696783mr563563jav.47.1652377094859; Thu, 12 May
 2022 10:38:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAMdnWFC4+-mEubOVkzaoqC5jnJCwY5hpcQtDnkmgqJ-mY5_GYg@mail.gmail.com>
 <Yn00jd+uX8PVZv/9@kroah.com>
In-Reply-To: <Yn00jd+uX8PVZv/9@kroah.com>
From:   Meena Shanmugam <meenashanmugam@google.com>
Date:   Thu, 12 May 2022 10:38:04 -0700
Message-ID: <CAMdnWFBCyiU-p1ww5NQnvMxVUnVyCkzoS6D+6Hg=7aJR4Bwn5Q@mail.gmail.com>
Subject: Re: Request to cherry-pick f00432063db1 to 5.10
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 9:23 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, May 10, 2022 at 07:33:23PM -0700, Meena Shanmugam wrote:
> > Hi all,
> >
> > The commit f00432063db1a0db484e85193eccc6845435b80e upstream (SUNRPC:
> > Ensure we flush any closed sockets before xs_xprt_free()) fixes
> > CVE-2022-28893, hence good candidate for stable trees.
> > The above commit depends on 3be232f(SUNRPC: Prevent immediate
> > close+reconnect)  and  89f4249(SUNRPC: Don't call connect() more than
> > once on a TCP socket). Commit 3be232f depends on commit
> > e26d9972720e(SUNRPC: Clean up scheduling of autoclose).
> >
> > Commits e26d9972720e, 3be232f, f00432063db1 apply cleanly on 5.10
> > kernel. commit 89f4249 didn't apply cleanly. I have patch for 89f4249
> > below.
>
> We also need this for 5.15.y first, before we can apply it to 5.10.y.
> Can you provide a working backport for that tree as well?
>
> And as others pointed out, your patch is totally corrupted and can not
> be used, please fix your email client.
>
> thanks,
>
> greg k-h

For 5.15.y commit f00432063db1a0db484e85193eccc6845435b80e((SUNRPC:
Ensure we flush any closed sockets before xs_xprt_free())) applies
cleanly. The depend patch
3be232f(SUNRPC: Prevent immediate close+reconnect) also applies
cleanly. Patch  89f4249
(SUNRPC: Don't call connect() more than once on a TCP socket) is
already present in 5.15.34 onwards.

Sorry about the patch corruption, I will fix it.

Thanks,
Meena
