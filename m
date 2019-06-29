Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7456E5A9BE
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 10:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfF2I6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 04:58:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34931 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfF2I6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jun 2019 04:58:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so11119364wml.0;
        Sat, 29 Jun 2019 01:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kO7tgzmZSydnK4bqhKeuzXTFUllU9Q1iN+0ZXCKLzck=;
        b=YizBswWcFG2uMi+/GFGYup7+ZiMd4TQCZmgKL6HPBxq3l8gpfmfiWSFm8K02nrI/wi
         nQPXkpbOcwWAZiHcrDFDOPdl/j+A4Fqr6T6k1Hbk1ZpY7YhTjtI6ynX2/8JLAGF0hn9f
         utJClhfmRgNXeWiCRwfjU3lveIShiTClLL0coWioPWomZCQcsIJC4OKCZ1HdwEljGpv1
         PVdUHCcU1a3uuhD6rjxWKfMohAWzZarALPwHwtmtF26dinqMY01au7N+SiBF1a6MJL0/
         GOt4obe1/gBponWP9qseyYrzWmfADhSRiV6ha8RuC+mUzblwi2gYAQuzMDwjFNzRcB7a
         /4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kO7tgzmZSydnK4bqhKeuzXTFUllU9Q1iN+0ZXCKLzck=;
        b=Gdjomm9JlghYCh+wNwLvijZutgTJxrS7iErSVps3gWmW3zCMdgQEMTJ1pAQJg983c/
         0UEj76LYNaMbmUCqMoeBX4PqgtDBVNDLYtvoeyMe+Axy4un8kdmkvah8+Z1ePDsuqF3z
         T/NLZEvwUK3XRsl1wRaDlYxqZJTmPdMsmHSBnuL6zcnfCytTpxxT6ZUD5nGmPrvQxAx+
         vHgX+iKAkiErPBKPIwUM8dsjr5BhG0/4xz8+tAQjHI9v20X4BhnEQxSBJiA4EJBD/nXk
         P9zuRBTX16UuCbuLfIoIvx3da1HnZ8hpPmSslix619gJf0JpdeRJH0WG9zioXevvYSmZ
         DA6w==
X-Gm-Message-State: APjAAAXg+DqwYc4QI8kedsnj/G3m+2OsOEIscT31uaAvdWXfZ4u4GFXX
        TsalH6yY6Z+/GAGX1V/lIr4tEa66rQ9I7Q==
X-Google-Smtp-Source: APXvYqwjTitAdXbWxy1QM6gemM+535ULxsJo2F2Crn83Qgde90WWSjPQmugEwbQCaEF2STEZv7y97w==
X-Received: by 2002:a1c:c289:: with SMTP id s131mr9953200wmf.115.1561798690042;
        Sat, 29 Jun 2019 01:58:10 -0700 (PDT)
Received: from zhanggen-UX430UQ ([108.61.173.19])
        by smtp.gmail.com with ESMTPSA id q7sm848378wrx.6.2019.06.29.01.58.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 01:58:09 -0700 (PDT)
Date:   Sat, 29 Jun 2019 16:57:57 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Subject: Re: [4.19.y PATCH 1/3] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
Message-ID: <20190629085757.GA2888@zhanggen-UX430UQ>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
 <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
 <20190629065721.GA365@kroah.com>
 <CAKv+Gu-_senkX5Asy1ZL+0cbAJBGib7Ys1WnMgdS36YO2LOU4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-_senkX5Asy1ZL+0cbAJBGib7Ys1WnMgdS36YO2LOU4Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 29, 2019 at 10:47:00AM +0200, Ard Biesheuvel wrote:
> On Sat, 29 Jun 2019 at 08:57, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Fri, Jun 28, 2019 at 11:42:13AM -0700, Srivatsa S. Bhat wrote:
> > > From: Gen Zhang <blackgod016574@gmail.com>
> > >
> > > commit 4e78921ba4dd0aca1cc89168f45039add4183f8e upstream.
> > >
> > > The old_memmap flow in efi_call_phys_prolog() performs numerous memory
> > > allocations, and either does not check for failure at all, or it does
> > > but fails to propagate it back to the caller, which may end up calling
> > > into the firmware with an incomplete 1:1 mapping.
> > >
> > > So let's fix this by returning NULL from efi_call_phys_prolog() on
> > > memory allocation failures only, and by handling this condition in the
> > > caller. Also, clean up any half baked sets of page tables that we may
> > > have created before returning with a NULL return value.
> > >
> > > Note that any failure at this level will trigger a panic() two levels
> > > up, so none of this makes a huge difference, but it is a nice cleanup
> > > nonetheless.
> >
> > With a description like this, why is this needed in a stable kernel if
> > it does not really fix anything useful?
> >
> 
> Because it fixes a 'CVE', remember? :-)

Thanks for your concerns. I have received other people disputing the 
CVEs these days. And if you are interested, you could kindly search 
all the CVEs I requested, almost all of them are marked
*DISPUTED* or under update to that, haha...

Anyway, I am just a starter in requesting CVE. It's my instructor told
me to request CVE for the patches... It is disputed by everybody now.

I am getting to know that a bug hard to exploit can not request CVE.
We should be really careful in doing so. Right?

Thanks
Gen
