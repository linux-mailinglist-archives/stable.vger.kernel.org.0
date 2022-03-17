Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4FB4DCB2A
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 17:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236492AbiCQQZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 12:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiCQQZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 12:25:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8103ABB92A;
        Thu, 17 Mar 2022 09:24:05 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t14so3028247pgr.3;
        Thu, 17 Mar 2022 09:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CxHgpSNZZuEtV5slXCliwgtbxDqjHZAN89PA6Kha9DQ=;
        b=iPAspoN1cg41/RL92HB4FhRGyagjBvagM5CpfCMVgHIe/NOZVcb+ykblGBqEVqTLtz
         xF8Skv9VuPLU37EdRRSifh8gynYM+K5ULxGEmG3ByTmueZrXPQIj6+ouCaCTlWRFLlNF
         otsnBI08np3EV3drQhJ0xTW/L483Q5q85CxzujVmQ0LH7ytdX/neCpf/MYBCnR3RrKDu
         10Wxy4Kr6ABKpryrufH/P8PxG6GplEO/7NTNESKE5F2SHT3bVkrKcobomZ84iUTfIYim
         KRl3H4JGmn10rTxV4JZI/N1J7jWwvpt7DWmPPgNB/x3LSmoZPmAmkDyFeNBrPKXGpLju
         VkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CxHgpSNZZuEtV5slXCliwgtbxDqjHZAN89PA6Kha9DQ=;
        b=rnYnkAxudSxOCXZbojhRtiTVTIV2n2vFApaO8Ge6stD9ACvpkTn+9J26+nacjhL8ai
         V9PZ9SNjqS8Yi+R59OiIzH4eqGjRF2SXc+QB9h6rM36Ry86fRGNFNfSqzOaOmge4pyzn
         Pob5XVmFPFi19kVXUrj1MNpZklkPMlPhV4QcTBleshnH4KYwDn7mg3SCc5RjeFGYyNDX
         Hoj0g67+ruSD9sYR/c8XkGSayNQRyuqmOKGhtESAQZDgVwsNAgZ72U/y2Wo9uyPQy+Hy
         kYPHzWGll7NYH+RWuDUm2hJNfWdOa2+WyKCIcs6k61QhO92rE9+8MCU7HSxgQuyD5E5s
         RYhg==
X-Gm-Message-State: AOAM5338gSGrqK2WH4CF+8Gg3JLGG1Nep1vLwppUE8vhD6Sel74XLE2g
        07dVP0tlB9A2QVFdBK/h7yCvBmq9oP4=
X-Google-Smtp-Source: ABdhPJxzBcB7aeTPqJrx6jD8KKAt6PoUG1RqtUoPQyS+6jB+C9zd1Ix29rCWyHkQ1xVZp+b2p2Sjew==
X-Received: by 2002:a63:cd:0:b0:382:1204:84f6 with SMTP id 196-20020a6300cd000000b00382120484f6mr2059100pga.109.1647534244814;
        Thu, 17 Mar 2022 09:24:04 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:b625:fd41:4746:7bf5])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a0002c500b004f6dbd217c9sm6726611pft.108.2022.03.17.09.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:24:04 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 17 Mar 2022 09:24:01 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, surenb@google.com,
        vbabka@suse.cz, rientjes@google.com, sfr@canb.auug.org.au,
        edgararriaga@google.com, nadav.amit@gmail.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "# 5 . 10+" <stable@vger.kernel.org>
Subject: Re: [PATCH V2,2/2] mm: madvise: skip unmapped vma holes passed to
 process_madvise
Message-ID: <YjNgoeg1yOocsjWC@google.com>
References: <cover.1647008754.git.quic_charante@quicinc.com>
 <4f091776142f2ebf7b94018146de72318474e686.1647008754.git.quic_charante@quicinc.com>
 <YjEaFBWterxc3Nzf@google.com>
 <20220315164807.7a9cf1694ee2db8709a8597c@linux-foundation.org>
 <YjFAzuLKWw5eadtf@google.com>
 <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5428f192-1537-fa03-8e9c-4a8322772546@quicinc.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 07:49:38PM +0530, Charan Teja Kalla wrote:
> Thanks Andrew and Minchan.
> 
> On 3/16/2022 7:13 AM, Minchan Kim wrote:
> > On Tue, Mar 15, 2022 at 04:48:07PM -0700, Andrew Morton wrote:
> >> On Tue, 15 Mar 2022 15:58:28 -0700 Minchan Kim <minchan@kernel.org> wrote:
> >>
> >>> On Fri, Mar 11, 2022 at 08:59:06PM +0530, Charan Teja Kalla wrote:
> >>>> The process_madvise() system call is expected to skip holes in vma
> >>>> passed through 'struct iovec' vector list. But do_madvise, which
> >>>> process_madvise() calls for each vma, returns ENOMEM in case of unmapped
> >>>> holes, despite the VMA is processed.
> >>>> Thus process_madvise() should treat ENOMEM as expected and consider the
> >>>> VMA passed to as processed and continue processing other vma's in the
> >>>> vector list. Returning -ENOMEM to user, despite the VMA is processed,
> >>>> will be unable to figure out where to start the next madvise.
> >>>> Fixes: ecb8ac8b1f14("mm/madvise: introduce process_madvise() syscall: an external memory hinting API")
> >>>> Cc: <stable@vger.kernel.org> # 5.10+
> >>>
> >>> Hmm, not sure whether it's stable material since it changes semantic of
> >>> API. It would be better to change the semantic from 5.19 with man page
> >>> update to specify the change.
> >>
> >> It's a very desirable change and it makes the code match the manpage
> >> and it's cc:stable.  I think we should just absorb any transitory
> >> damage which this causes people.  I doubt if there will be much - if
> >> anyone was affected by this they would have already told us that it's
> >> broken?
> > 
> > 
> > process_madvise fails to return exact processed bytes at several cases
> > if it encounters the error, such as, -EINVAL, -EINTR, -ENOMEM in the
> > middle of processing vmas. And now we are trying to make exception for
> > change for only hole?
> I think EINTR will never return in the middle of processing VMA's for
> the behaviours supported by process_madvise().
> 
> It can return EINTR when:
> -------------------------
> 1) PTRACE_MODE_READ is being checked in mm_access() where it is waiting
> on task->signal->exec_update_lock. EINTR returned from here guarantees
> that process_madvise() didn't event start processing.
> https://elixir.bootlin.com/linux/v5.16.14/source/mm/madvise.c#L1264 -->
> https://elixir.bootlin.com/linux/v5.16.14/source/kernel/fork.c#L1318
> 
> 2) The process_madvise() started processing VMA's but the required
> behavior on a VMA needs mmap_write_lock_killable(), from where EINTR is
> returned. The current behaviours supported by process_madvise(),
> MADV_COLD, PAGEOUT, WILLNEED, just need read lock here.
> https://elixir.bootlin.com/linux/v5.16.14/source/mm/madvise.c#L1164
>  **Thus I think no way for EINTR can be returned by process_madvise() in
> the middle of processing.** . No?
> 
> for EINVAL:
> -----------
> The only case, I can think of,  where EINVAL can be returned in the
> middle of processing is in examples like, given range contains VMA's
> with a hole in between and one of the VMA contains the pages that fails
> can_madv_lru_vma() condition.
> So, it's a limitation that this returns -EINVAL though some bytes are
> processed.
> 	OR
> Since there exists still some invalid bytes processed it is valid to
> return -EINVAL here and user has to check the address range sent?
> 
> for ENOMEM:
> ----------
> Though complete range is processed still returns ENOMEM. IMO, This
> shouldn't be treated as error which the patch is targeted for. Then
> there is limitation case that you mentioned below where it returns
> positive processes bytes even though it didn't process anything if it
> couldn't find any vma for the first iteration in madvise_walk_vmas
> 
> I think the above limitations with EINVAL and ENOMEM are arising because
> we are relying on do_madvise() functionality which madvise() call uses
> to process a single VMA. When 'struct iovec' vector processing interface
> is given in a system call, it is the expectation by the caller that this
> system call should return the correct bytes processed to help the user
> to take the correct decisions. Please correct me If i am wrong here.
> 
> So, should we add the new function say do_process_madvise(), which take
> cares of above limitations? or any alternative suggestions here please?

What I am thinking now is that the process_madvise needs own iterator(i.e.,
do_process_madvise) and it should represent exact bytes it addressed with
exacts ranges like process_vm_readv/writev. Poviding valid ranges is
responsiblity from the user.

> 
> > IMO, it's worth to note in man page.
> > 
> 
> Or the current patch for just ENOMEM is sufficient here and we just have
> to update the man page?
> 
> > In addition, this change returns positive processes bytes even though
> > it didn't process anything if it couldn't find any vma for the first
> > iteration in madvise_walk_vmas.
> 
> Thanks,
> Charan
> 
