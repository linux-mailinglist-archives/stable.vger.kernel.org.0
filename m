Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2522C1374FF
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 18:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgAJRjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 12:39:22 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44544 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbgAJRjW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 12:39:22 -0500
Received: by mail-oi1-f195.google.com with SMTP id d62so2516323oia.11
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 09:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Q1GBS2pY7ztdnXlxR3cAwmNzA2VCbkxidjpkZWDyrg=;
        b=NjJNvotbDqOEkfMWJSRvy4vwUYI02ZW1vOSpc2cHl5/mvinqgRmosIgnU9GAnW7jfZ
         v9Vlcqf//c1HxTEGAMSoZCLpIf7OE3Teox/n23PC6nclz3FTEGTEHizc0gQrIDAvsx1Y
         z2auqAILAT2p3aJc/R68vhuZw3zZjJkER2JgIND3oe962/kDbQ1yOS3VDme/pzfRXFPh
         lJK61eqLfeVM6f+PohuKoP5pcrgpSmWSfvGFwSh/GXRr/35//kLdmgKLKui3a3P5XyoS
         7o6za661JWFcr9eLDUbZUMVUQMLMHVoXInq4fTFQGyx1Imnt4LS/VFXOLos7XaVFBpLW
         76oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Q1GBS2pY7ztdnXlxR3cAwmNzA2VCbkxidjpkZWDyrg=;
        b=VvayIL7p/u/zgJlzdluPmYB6edJj0qUH/6tjwUF9atSgYZWkfwnCb5tUc8cu+rqFpI
         RcGw+K+sTyVnXadaUXPkDXgwDrScnm3Hvz3iubf+ADqPnYJ11Pv6LvXBxc19Fy3X9Wuj
         UUTMSqUqUXEfvKrhHM9akvkhluVTrxR3kBq6J7V56zwwhqJPL1PPpWpMt07eJbHzoCAp
         yOxS19PVvctGmPacvQj899oY0u9tZxtSt5/QvLe1fLc0eKtotfAeyJFsTj4QLwrkIWm8
         Fe8Md32vHerEiTo994fcDH7/ehCV+m4h4BlUMvlYOcSwGb7h7pna61ioynWPKSSuq4zc
         h1BQ==
X-Gm-Message-State: APjAAAUon0rJLM52HoAlbQeHRXLQ/R28ocltpTTzL17+X7quPYqrJAar
        ogOyISoAjhR68oiZqCDoj/TE16Pqg7bhRNqZBHtRcg==
X-Google-Smtp-Source: APXvYqxARCQe9P9OLwQdhXf4V41HnnrUs1BdyjYA2CaZfxWAt/5GhiRBCgVf4q02kq9VN+CH7UUrqyW8cIun9nTI8Yc=
X-Received: by 2002:aca:1103:: with SMTP id 3mr2970929oir.70.1578677961220;
 Fri, 10 Jan 2020 09:39:21 -0800 (PST)
MIME-Version: 1.0
References: <157863061737.2230556.3959730620803366776.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com> <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
 <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com> <CAPcyv4jixmv8fJ5FiYE=97Jud3Mc+6QzRX1txceSYU+WY_0rQA@mail.gmail.com>
 <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com> <CAPcyv4jVpN26RGQLRn4BewYtzHDoQfvh37DEdEBq1dd4-BP0kw@mail.gmail.com>
 <64902066-51dd-9693-53fc-4a5975c58409@redhat.com>
In-Reply-To: <64902066-51dd-9693-53fc-4a5975c58409@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Jan 2020 09:39:10 -0800
Message-ID: <CAPcyv4hcDNeQO3CfnqTRou+6R5gZwyi4pVUMxp1DadAOp7kJGQ@mail.gmail.com>
Subject: Re: [PATCH] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Michal Hocko <mhocko@suse.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 10, 2020 at 9:36 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 10.01.20 18:33, Dan Williams wrote:
> > On Fri, Jan 10, 2020 at 9:29 AM David Hildenbrand <david@redhat.com> wrote:
> > [..]
> >>> So then the comment is actively misleading for that case. I would
> >>> expect an explicit _unlocked path for that case with a comment about
> >>> why it's special. Is there already a comment to that effect somewhere?
> >>>
> >>
> >> __add_memory() - the locked variant - is called from the same ACPI location
> >> either locked or unlocked. I added a comment back then after a longe
> >> discussion with Michal:
> >>
> >> drivers/acpi/scan.c:
> >>         /*
> >>          * Although we call __add_memory() that is documented to require the
> >>          * device_hotplug_lock, it is not necessary here because this is an
> >>          * early code when userspace or any other code path cannot trigger
> >>          * hotplug/hotunplug operations.
> >>          */
> >>
> >>
> >> It really is a special case, though.
> >
> > That's a large comment block when we could have just taken the lock.
> > There's probably many other code paths in the kernel where some locks
> > are not necessary before userspace is up, but the code takes the lock
> > anyway to minimize the code maintenance burden. Is there really a
> > compelling reason to be clever here?
>
> It was a lengthy discussion back then and I was sharing your opinion. I
> even had a patch ready to enforce that we are holding the lock (that's
> how I identified that specific case in the first place).

Ok, apologies I missed that opportunity to back you up. Michal, is
this still worth it?
