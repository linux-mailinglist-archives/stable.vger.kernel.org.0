Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8308F78EF9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387944AbfG2PTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:19:05 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42631 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfG2PTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 11:19:04 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so62898478otn.9
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 08:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rCT6H9w7mRPFe9tLjSH6a/cwajZAI16F1Mz9k4S0jwo=;
        b=bw8SQC4b3IVQPpG8+lymx/5VvfWVb17DQbUIblaNzQ+DivE/9bZrLa1es+hytSIsb4
         st4IVP90+jBqEINN4yoCPm61vk9e/iayOi66FNlhn5dYMF3FkwdxXmRS9QBPg3jZ/EBI
         1/zEryAVLcFGSYfWtnkGzTIacI0eDBEQI3LL2MJwDFGuXVFaoLNEvv7HU4DOrtwcyX3c
         8BoKKJMt1wbDx1ZPmjpdztw6bJ+1/eFNc+39XbtVdYu3o5Zp2RLdaBT9RRza5m3Xo+CG
         XWE9Km4WBRApykf0CL9lWcPxOvhP4EisuNC6Ehj9bIcJ/nbDXkwpossXNQEbG2s8wOKw
         coIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rCT6H9w7mRPFe9tLjSH6a/cwajZAI16F1Mz9k4S0jwo=;
        b=sUChybH55qSEXD7Vsi4ODcKPcZ6BW9yw21/z0r51PIj1qJokHqXP0dRB0GGI/Fl14f
         var8d9YY4r07h1Zm7xGrg5WFOWIrZiLHKV7TxYk3zOVkeyUd3eUdX3ZFX/Ve5DU52dub
         bFGIANh/vOwUbTOtG1frrSWbbviZ3CZJoHyR5Ehuwbwo767EW7TyIm8haTuh1DuPQUNK
         4O91SZ7aMKl/TmzIeFKqNQMELy6/ysVrrk1EBlRjZPmw9f+lCyv2TQ0iyhZDrTYOJjnM
         fnkusIucR7z+B8dZXlQp78Zx+J1+TJ5lQsJMEQIp/MgYmJ4s3/iQ7o92aDHOGi7r68W1
         sa3g==
X-Gm-Message-State: APjAAAWKVqysJ5ukU/HzWIPfgec44KcbEseeQjg2IDeRimT2Ia2mdUdp
        fEiYO47irNxTH6QUCJS20ONX6qgz73sk6UcsorZBhQ==
X-Google-Smtp-Source: APXvYqxYWAjs7eLjr+8klpuvyVa2e+dzwHIBnTZXXBRs/ed3hhF2B01PvzuOFqm6GTJEk7S3DAaC0Ry44CTuealvMbg=
X-Received: by 2002:a9d:470d:: with SMTP id a13mr80213537otf.126.1564413543911;
 Mon, 29 Jul 2019 08:19:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4gUiDw8Ma9mvbW5BamQtGZxWVuvBW7UrOLa2uijrXUWaw@mail.gmail.com>
 <20190705191004.GC32320@bombadil.infradead.org> <CAPcyv4jVARa38Qc4NjQ04wJ4ZKJ6On9BbJgoL95wQqU-p-Xp_w@mail.gmail.com>
 <20190710190204.GB14701@quack2.suse.cz> <20190710201539.GN32320@bombadil.infradead.org>
 <20190710202647.GA7269@quack2.suse.cz> <20190711141350.GS32320@bombadil.infradead.org>
 <20190711152550.GT32320@bombadil.infradead.org> <20190711154111.GA29284@quack2.suse.cz>
 <CAPcyv4hA+44EHpGN9F5eQD5Y_AuyPTKmovNWvccAFGhF_O2JMg@mail.gmail.com> <20190729120228.GC17833@quack2.suse.cz>
In-Reply-To: <20190729120228.GC17833@quack2.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 29 Jul 2019 08:18:52 -0700
Message-ID: <CAPcyv4hMJnMYAW=qcZWcadMoofgsnoQ66Xk5O6ZpxKCK4Yfr5g@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix missed PMD wakeups
To:     Jan Kara <jack@suse.cz>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Boaz Harrosh <openosd@gmail.com>,
        stable <stable@vger.kernel.org>,
        Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 5:02 AM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 16-07-19 20:39:46, Dan Williams wrote:
> > On Fri, Jul 12, 2019 at 2:14 AM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Thu 11-07-19 08:25:50, Matthew Wilcox wrote:
> > > > On Thu, Jul 11, 2019 at 07:13:50AM -0700, Matthew Wilcox wrote:
> > > > > However, the XA_RETRY_ENTRY might be a good choice.  It doesn't normally
> > > > > appear in an XArray (it may appear if you're looking at a deleted node,
> > > > > but since we're holding the lock, we can't see deleted nodes).
> > > >
> > > ...
> > >
> > > > @@ -254,7 +267,7 @@ static void wait_entry_unlocked(struct xa_state *xas, void *entry)
> > > >  static void put_unlocked_entry(struct xa_state *xas, void *entry)
> > > >  {
> > > >       /* If we were the only waiter woken, wake the next one */
> > > > -     if (entry)
> > > > +     if (entry && dax_is_conflict(entry))
> > >
> > > This should be !dax_is_conflict(entry)...
> > >
> > > >               dax_wake_entry(xas, entry, false);
> > > >  }
> > >
> > > Otherwise the patch looks good to me so feel free to add:
> > >
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> >
> > Looks good, and passes the test case. Now pushed out to
> > libnvdimm-for-next for v5.3 inclusion:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/commit/?h=libnvdimm-for-next&id=23c84eb7837514e16d79ed6d849b13745e0ce688
>
> Thanks for picking up the patch but you didn't apply the fix I've mentioned
> above. So put_unlocked_entry() is not waking up anybody anymore... Since
> this got already to Linus' tree, I guess a separate fixup patch is needed
> (attached).

Sigh, indeed. I think what happened is I applied the fixup locally,
tested it, and then later reapplied the patch from the list as I was
integrating the new automatic "Link:" generation script that has been
proposed on the ksummit list.

I'll get this pushed immediately.

Lesson learned: no manual local fixups, ask for resends to always be
able to pull the exact contents from the list.
