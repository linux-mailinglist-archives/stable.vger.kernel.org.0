Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89EC458A01
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 20:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF0SaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 14:30:05 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38594 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0SaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 14:30:05 -0400
Received: by mail-ot1-f67.google.com with SMTP id d17so3300518oth.5
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 11:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7E3kE8wu6XArETAHziQvnZYV/Eha0av5p2dljNuncOs=;
        b=foFvp30DG07jcUeEQRk8SMFfwd/Wva8/DnhLRWyqOIEHY3iQ0bH3xBBjNEWt1UAb9i
         aSc3lqlBun4TcabEhTjxpZ+OkIyuycNXsXlxccJejQbd632UL5dTF0ReYx9tgjN1LZpK
         mBX/S+GBhEMY+hKQwLcUyojf3H+OPilbFg/JD2SVMM8M3MT8ZlLkX9kEa99YULT2J3wq
         SG/RSlHZrZLlAxovfeBCH2Ijpak7jmNP8mbWhWYFIOM4MtwTQ47fcYTztP21tUI+pIKW
         0YYfQqSutj9IcqcAXAchA74/rzypF+j+tEfioCqOTkayP1R9aOB5o1e55rrlVcQGp0yZ
         oBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7E3kE8wu6XArETAHziQvnZYV/Eha0av5p2dljNuncOs=;
        b=X4sFHpoZKXbKN8GGt3BHeTfuVNDTjBXDBO4tzmXTiCv/nb8wNJR5lSnQGAU5fgX9tJ
         Rycap/4AlJ6BQXBVInYBgTWtXqr8A9VWUoqmXL7Vm9aEpphWjJWQNtwc7QVhrj4sN0Kv
         pcp2ME3poNnxQzVv3AS4TDHJHjNK19Y5SihaGpdwV9ytgMkY0KIAzej+738RNhpwV/Ak
         XfxV0BdaYCVdrGRv3ceTeSyiDocajRD6UYGVJJy2plhGS8Syu4nh8nPNPQ1WoCqMd+d0
         sZq1eWXCHUwROTm5IoPyPDJRmrxe4yOzzYhEsb/hoDVw+6G9nmGCopV1vw8q5SCfKP5W
         x2Kg==
X-Gm-Message-State: APjAAAVq8NGhKAxGBi3gq1cd/KJUtrZOlS3oAMMesvzNfYGZGAxUmueJ
        dfVHa63+7fDYqtenpMRXpRBj214VLiqXjfyQYOjQqg==
X-Google-Smtp-Source: APXvYqzR6jmVs33hZDIYobItCy5fbsq9anYEdod2Ip+FjFmtBNmx0NXxWd92xbXTibPcVqTURkcFzBgWlQkkEVlfzdE=
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr4463320oto.207.1561660204791;
 Thu, 27 Jun 2019 11:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190627123415.GA4286@bombadil.infradead.org> <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
In-Reply-To: <CAPcyv4jQP-SFJGor-Q3VCRQ0xwt3MuVpH2qHx2wzyRA88DGQww@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 27 Jun 2019 11:29:53 -0700
Message-ID: <CAPcyv4jjqooboxivY=AsfEPhCvxdwU66GpwE9vM+cqrZWvtX3g@mail.gmail.com>
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

On Thu, Jun 27, 2019 at 9:06 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Thu, Jun 27, 2019 at 5:34 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Jun 26, 2019 at 05:15:45PM -0700, Dan Williams wrote:
> > > Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
> > > been encountering intermittent lockups. The backtraces always include
> > > the filesystem-DAX PMD path, multi-order entries have been a source of
> > > bugs in the past, and disabling the PMD path allows a test that fails in
> > > minutes to run for an hour.
> >
> > On May 4th, I asked you:
> >
> > Since this is provoked by a fatal signal, it must have something to do
> > with a killable or interruptible sleep.  There's only one of those in the
> > DAX code; fatal_signal_pending() in dax_iomap_actor().  Does rocksdb do
> > I/O with write() or through a writable mmap()?  I'd like to know before
> > I chase too far down this fault tree analysis.
>
> RocksDB in this case is using write() for writes and mmap() for reads.

It's not clear to me that a fatal signal is a component of the failure
as much as it's the way to detect that the benchmark has indeed locked
up.
