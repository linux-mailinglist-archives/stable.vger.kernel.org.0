Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4359158
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 04:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfF1Cju (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 22:39:50 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33043 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfF1Cju (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 22:39:50 -0400
Received: by mail-ot1-f66.google.com with SMTP id q20so4486518otl.0
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 19:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+w5fn2Y32/L39vIbDWdR2CfVz49VqoI4F4CB/r+uKs=;
        b=2BroReMxSyl7fumvZHFYCsXog9so/PwacI6uZo45fszzwoTUhDjTDVIC3dmDgkvhjI
         1vPIrM+hSnKeAwrkzbGzAjTEPTTgmqOwCVSZQUdIDrvAxKA2cMV8Dr6GunOjfoKKRYiR
         i8n913ea5p94gaxe2NpjIpJwUJ2qhzkQ+wHLtf//YGUdDQeqhjuL7sHzp6EjAr//ec01
         XTKGHBCDcdPjUSb8oFPiQDfaUdsVI1ufjKYoVyP6pZsvPych6kooqkVWEaGAH73GpfeW
         Q64A9UAnw0STfqhTNC283nlq9ZOnnmCyzDAjw3roZzNRDyNGYbLpCBliRHdGmg3LI7kY
         Wv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+w5fn2Y32/L39vIbDWdR2CfVz49VqoI4F4CB/r+uKs=;
        b=PX7bzwPsgKgnkmbJvvooSGGOcbFGS5Y3btjXmMmz8r4fjo1k+zPqsv9/+YU2TaPIFs
         Ty9kLJgWe2jCC+clZDR6beyRnApPj8YdqYQPlsosBxu823WMo1UgG+ddS/n4x6OoWUZX
         bEqgCf8/rXNasPKNt01GGa468nPDyiH0+PllvvdnJGYdYSoavp8jEtp+n1fVBhwA+m5R
         +y7wyWeNPzkv5qTgL4NDejvJNbUE0rpYYW85NBl7zKOTPbaVLY2Ocw1AanEjln6NCkt2
         MTbAwynapE197//7ivKL+05Hf+5Lzi0wppW+NEEDttCETmNZ3yqD17w3Vnj+i70v1W42
         UGBg==
X-Gm-Message-State: APjAAAXNMQlIoDRuY+byRJ2EwIpDWCx2GyURksBemtI1IudvDCYhUdsv
        VCQyxQHDKW0p+zSN7QHsgfuIXc3cxZSGdHBIwnSPPg==
X-Google-Smtp-Source: APXvYqwSf5cu88/vylJhhX2x15ji/SfzGkHLqjJ94ZW0+LXDsKMlI1/GoQT5qpbwxtU93udva3CYg32AyPTcsoNMv3U=
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr5967248oto.207.1561689589382;
 Thu, 27 Jun 2019 19:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org> <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
 <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
 <CAPcyv4h6HgNE38RF5TxO3C268ZvrxgcPNrPWOt94MnO5gP_pjw@mail.gmail.com>
 <CAPcyv4gwd1_VHk_MfHeNSxyH+N1=aatj9WkKXqYNPkSXe4bFDg@mail.gmail.com> <20190627195948.GB4286@bombadil.infradead.org>
In-Reply-To: <20190627195948.GB4286@bombadil.infradead.org>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 27 Jun 2019 19:39:37 -0700
Message-ID: <CAPcyv4iB3f1hDdCsw=Cy234dP-RXpxGyXDoTwEU8nt5qUDEVQg@mail.gmail.com>
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

On Thu, Jun 27, 2019 at 12:59 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Thu, Jun 27, 2019 at 12:09:29PM -0700, Dan Williams wrote:
> > > This bug feels like we failed to unlock, or unlocked the wrong entry
> > > and this hunk in the bisected commit looks suspect to me. Why do we
> > > still need to drop the lock now that the radix_tree_preload() calls
> > > are gone?
> >
> > Nevermind, unmapp_mapping_pages() takes a sleeping lock, but then I
> > wonder why we don't restart the lookup like the old implementation.
>
> We have the entry locked:
>
>                 /*
>                  * Make sure 'entry' remains valid while we drop
>                  * the i_pages lock.
>                  */
>                 dax_lock_entry(xas, entry);
>
>                 /*
>                  * Besides huge zero pages the only other thing that gets
>                  * downgraded are empty entries which don't need to be
>                  * unmapped.
>                  */
>                 if (dax_is_zero_entry(entry)) {
>                         xas_unlock_irq(xas);
>                         unmap_mapping_pages(mapping,
>                                         xas->xa_index & ~PG_PMD_COLOUR,
>                                         PG_PMD_NR, false);
>                         xas_reset(xas);
>                         xas_lock_irq(xas);
>                 }
>
> If something can remove a locked entry, then that would seem like the
> real bug.  Might be worth inserting a lookup there to make sure that it
> hasn't happened, I suppose?

Nope, added a check, we do in fact get the same locked entry back
after dropping the lock.

The deadlock revolves around the mmap_sem. One thread holds it for
read and then gets stuck indefinitely in get_unlocked_entry(). Once
that happens another rocksdb thread tries to mmap and gets stuck
trying to take the mmap_sem for write. Then all new readers, including
ps and top that try to access a remote vma, then get queued behind
that write.

It could also be the case that we're missing a wake up.
