Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5FF24E475
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 03:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgHVB0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 21:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgHVB0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 21:26:32 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A523C061574
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 18:26:31 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id j16so745982ooc.7
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 18:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=bbVqRO+5zIdkL7CNpFPOnICuenpTd17InbzqAFFRRA0=;
        b=f+1piX8Bq9Q/zt8Y/G1gS5gK8iCQEchGAd6a5mJIePqraUcLN2/JfO9SK8B1EP5mYw
         N36TxejSs//TXB1Bam4cek47pHuTiyL3cX3wlS2a9XBIoMgwugAPR6/prx6fmSinzYOq
         hZE+0vOYPWaQ6hiFDNm+lL603lOGgVL2tRBweyORdn3EKvHFP4fTO1QKWWhhAKYYu60Q
         kkqx7ETofwaP1q2yequrxLegWYAoaUUQMWql9DqEm5vMq7rDkq9JeBFkVcf0xj5aq7qP
         15o2MxFNHopCkHf+o+FfFp6kcfT0NmfLNiRGZBWgoEpwRIbhxCqAPJq2u8qA6kYvbx5k
         JA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=bbVqRO+5zIdkL7CNpFPOnICuenpTd17InbzqAFFRRA0=;
        b=a5Y+49VJ4sN4+YoVd4cGrl5aT7l8edsCFUjgYXoOCOKI8Bns7W9d3gesgYZe1f/+u+
         UIrUTn7EkjSY9o2Ug8nk5jW6gPp14iKfMXACCH+giF4sbBSvvdytfjHGbVFvaeZmAxA6
         0UG7rFKXt6Trg5B3dU9K8RnMBloj822lqqn75fbaXltiEt3Pv2+vP7X6gApZXaKDQq6U
         NMEcwsxnx22iwPq9N+QzNxHMXCyxZYuliuWPAf16ZijFjV94YqKQ7Me7GIvp22E1PIAt
         +N+Is0l+Bvz73Y3OxW9IQr2DdjLtnJmccF5TsAIxeoC3rw8nX+59GAxTUXitBmJegLZi
         3dFw==
X-Gm-Message-State: AOAM530fY/lU/oSZqzs4y3WoAfzvVXCbk2GiH+vzvSoFl/3UJM7dB894
        CNdo++EYU/S5F+ETCkW09LkiGg==
X-Google-Smtp-Source: ABdhPJy/urFZywzMZNV99yKsoqOGopFvoyzL9VsiLvg65Ic8yZ687MExuEZwLN/DVrR1PufQz4QPEQ==
X-Received: by 2002:a4a:52c2:: with SMTP id d185mr4417946oob.8.1598059590127;
        Fri, 21 Aug 2020 18:26:30 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id z10sm711726otk.6.2020.08.21.18.26.28
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 21 Aug 2020 18:26:28 -0700 (PDT)
Date:   Fri, 21 Aug 2020 18:26:15 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     Hugh Dickins <hughd@google.com>, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check mmget_still_valid()"
 has been added to the 5.8-stable tree
In-Reply-To: <20200819135306.GA3311904@kroah.com>
Message-ID: <alpine.LSU.2.11.2008211739460.9564@eggly.anvils>
References: <1597841669128213@kroah.com> <alpine.LSU.2.11.2008190625060.24442@eggly.anvils> <20200819135306.GA3311904@kroah.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Aug 2020, Greg KH wrote:
> On Wed, Aug 19, 2020 at 06:32:26AM -0700, Hugh Dickins wrote:
> > On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     khugepaged: khugepaged_test_exit() check mmget_still_valid()
> > > 
> > > to the 5.8-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch
> > > and it can be found in the queue-5.8 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > 
> > Please hold this one back for the moment: we shall want it, but syzbot
> > detected one place where it can lead to a VM_BUG_ON_MM().  The fix to
> > that is currently in Andrew's tree, but not yet in Linus's - when it
> > gets there, I'll send you its git commit id in reply to this mail.
> > 
> > This patch failed to apply to earlier releases: I'll send the fixup for
> > those at that time.  (Fixups for another patch to follow later today.)
> 
> Now dropped, thanks!

f3f99d63a815 khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
has now reached Linus's tree, so will reach your tree when you next pull.

When that one is ready, please reinstate this commit that we held back:
bbe98f9cadff khugepaged: khugepaged_test_exit() check mmget_still_valid()

The mmap_sem->mmap_lock change means I must then send you a backport of
bbe98f9cadff for 5.7, 5.4, 4.19, 4.14, 4.9: one backport will do for all
of those, and f3f99d63a815 should cherry-pick cleanly into them all.

But you also marked bbe98f9cadff for 4.4: I had not expected that,
but I think you're right - for whatever reason (probably inertia,
it was tiresome because khugepaged.c got split from huge_memory.c),
4.4 lacks a backport of 59ea6d06cfa9 (though it does have the commit
that depended on), and backports of these two will serve just as well
to fix what it was required to fix: I'll send them too.

Thanks: I'm sorry that this is all so confusing,
kudos to syzbot for catching my error as quickly as it did.

Hugh
