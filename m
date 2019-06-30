Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D51C5AF39
	for <lists+stable@lfdr.de>; Sun, 30 Jun 2019 09:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfF3H1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jun 2019 03:27:23 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34832 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfF3H1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jun 2019 03:27:23 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so10332811otq.2
        for <stable@vger.kernel.org>; Sun, 30 Jun 2019 00:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ifuX0GPUPwU8sJc/BBSReUnmOObSyjtXhS37cebQo4=;
        b=LU835ZbJa6zElZNkXLBkWXoIWv0zK5xbEYX9CWP5Tf/akdP5trCGEfpuxDozkOC7bx
         tQUcIxoINIM+CEi9IRccQJySPhwZ25NmI6sp+AUWSckXq39KldCbbbpCUCdtr7U5FqmS
         JZWDf/EV1vZJxZJt9Hp4Rmr4lfSgGpuXx35W44uFwcc5gz5iJcQ8d2x0/kVxjbJwKAMZ
         zJdbi/BO1uliKiutjuwvCpUSl6KpJCoMb6XetG3BAfi0FKTktexTzuJ5KZbUq0xlNwin
         cFAYQxjjwQpPsbCZ0gLyBIJRre7DPRBKg5qnIinCJ1x1F966ivSqXFFGmmKlbypcwng/
         tCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ifuX0GPUPwU8sJc/BBSReUnmOObSyjtXhS37cebQo4=;
        b=b5PqkQ6/BmBC9pZ9iSMQkAH2dAfe2UPaQ7RzT+h2oV8rNrtolotv82GAliEguqYoNt
         L/zcYnNEOeeBWq1Wvz9c+k2blhSpLZu0wqPhlDqQtFvHwOf+DWJ+nbtT585oJyg5O/CA
         pOpaviOqbOynErvcwOcOQwpGj3Fr/XeYLd/+YDhf5Ncq15lf6g+WKp2dgVDrwHiDaAO9
         gc4SZaglO40QaSiWVFZgRjwSitDruGFMlUcJFH/yw+lbUQnmpicPb04psJNOe3Vvkk7M
         ZNE+7iX20/PwQ40eQoRmO2euacyQbq5wp1HJ/Eejj3QfI21tV7B5cZ/7q7dW+DlaXCw9
         r9iA==
X-Gm-Message-State: APjAAAXOKuS0c3XilZLSy3d7cFJUtSEmqOd2IeYT048jXD5xB4xylPg8
        Sf0ZHZiVbhBquUPVdTZSB1Vhq9xbkPwUEIRjqBLp+w==
X-Google-Smtp-Source: APXvYqzG3yWwXue81yNig6ezxWIPCgBdC5dvtqes+GhNboUBH50PqIBy7laVTzJ0AvIOZbQvNAl3Xx/oC59rNVkK+6A=
X-Received: by 2002:a9d:470d:: with SMTP id a13mr14638073otf.126.1561879642668;
 Sun, 30 Jun 2019 00:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org> <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com>
 <20190627195948.GB4286@bombadil.infradead.org> <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
 <20190629160336.GB1180@bombadil.infradead.org>
In-Reply-To: <20190629160336.GB1180@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sun, 30 Jun 2019 00:27:11 -0700
Message-ID: <CAPcyv4ge3Ht1k_v=tSoVA6hCzKg1N3imhs_rTL3oTB+5_KC8_Q@mail.gmail.com>
Subject: Re: [PATCH] filesystem-dax: Disable PMD support
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 29, 2019 at 9:03 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jun 27, 2019 at 07:39:37PM -0700, Dan Williams wrote:
> > On Thu, Jun 27, 2019 at 12:59 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Thu, Jun 27, 2019 at 12:09:29PM -0700, Dan Williams wrote:
> > > > > This bug feels like we failed to unlock, or unlocked the wrong entry
> > > > > and this hunk in the bisected commit looks suspect to me. Why do we
> > > > > still need to drop the lock now that the radix_tree_preload() calls
> > > > > are gone?
> > > >
> > > > Nevermind, unmapp_mapping_pages() takes a sleeping lock, but then I
> > > > wonder why we don't restart the lookup like the old implementation.
> > >
> > > We have the entry locked:
> > >
> > >                 /*
> > >                  * Make sure 'entry' remains valid while we drop
> > >                  * the i_pages lock.
> > >                  */
> > >                 dax_lock_entry(xas, entry);
> > >
> > >                 /*
> > >                  * Besides huge zero pages the only other thing that gets
> > >                  * downgraded are empty entries which don't need to be
> > >                  * unmapped.
> > >                  */
> > >                 if (dax_is_zero_entry(entry)) {
> > >                         xas_unlock_irq(xas);
> > >                         unmap_mapping_pages(mapping,
> > >                                         xas->xa_index & ~PG_PMD_COLOUR,
> > >                                         PG_PMD_NR, false);
> > >                         xas_reset(xas);
> > >                         xas_lock_irq(xas);
> > >                 }
> > >
> > > If something can remove a locked entry, then that would seem like the
> > > real bug.  Might be worth inserting a lookup there to make sure that it
> > > hasn't happened, I suppose?
> >
> > Nope, added a check, we do in fact get the same locked entry back
> > after dropping the lock.
> >
> > The deadlock revolves around the mmap_sem. One thread holds it for
> > read and then gets stuck indefinitely in get_unlocked_entry(). Once
> > that happens another rocksdb thread tries to mmap and gets stuck
> > trying to take the mmap_sem for write. Then all new readers, including
> > ps and top that try to access a remote vma, then get queued behind
> > that write.
> >
> > It could also be the case that we're missing a wake up.
>
> OK, I have a Theory.
>
> get_unlocked_entry() doesn't check the size of the entry being waited for.
> So dax_iomap_pmd_fault() can end up sleeping waiting for a PTE entry,
> which is (a) foolish, because we know it's going to fall back, and (b)
> can lead to a missed wakeup because it's going to sleep waiting for
> the PMD entry to come unlocked.  Which it won't, unless there's a happy
> accident that happens to map to the same hash bucket.
>
> Let's see if I can steal some time this weekend to whip up a patch.

Theory seems to have some evidence... I instrumented fs/dax.c to track
outstanding 'lock' entries and 'wait' events. At the time of the hang
we see no locks held and the waiter is waiting on a pmd entry:

[ 4001.354334] fs/dax locked entries: 0
[ 4001.358425] fs/dax wait entries: 1
[ 4001.362227] db_bench/2445 index: 0x0 shift: 6
[ 4001.367099]  grab_mapping_entry+0x17a/0x260
[ 4001.371773]  dax_iomap_pmd_fault.isra.43+0x168/0x7a0
[ 4001.377316]  ext4_dax_huge_fault+0x16f/0x1f0
[ 4001.382086]  __handle_mm_fault+0x411/0x1390
[ 4001.386756]  handle_mm_fault+0x172/0x360
