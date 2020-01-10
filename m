Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78706137878
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 22:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgAJV1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 16:27:35 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33526 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgAJV1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jan 2020 16:27:35 -0500
Received: by mail-oi1-f193.google.com with SMTP id v140so3176879oie.0
        for <stable@vger.kernel.org>; Fri, 10 Jan 2020 13:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dc7C9t8nS5kMbHGnuaUU5Fa2JKAfraVFXFnxYmWF9bM=;
        b=vdr15sBSjoi3j4oUEH5jIDurHcvUNEyEW57q0WyAtFekwNzRnrjVwYvA8hPQQXbIqE
         DIxI19JZ1HDadWeoreEH4fXrqQS6trIV7O3FllR4i+G+aEL6ola42rSNyRj+JKzuBQJg
         poxz2gLWMzx9yD4J50Q4EZbvfDmuFpTP+6TJMWgk5k1kAmgqgjVnyCzbihiEAa/YyXWD
         w+GHu+xvWtvJrZ8/PaY4qmaoEuBqjMoLpFt9DmoSAuQDTXmo/T46CPcZDt8AtupbXqvd
         1VA3Obwi7t67dWTJ2rJsjPNBNgBk9Bn+dFa6CMsRBhLfEOYfgzH8j9iz/ydo0XmyN5RN
         7vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dc7C9t8nS5kMbHGnuaUU5Fa2JKAfraVFXFnxYmWF9bM=;
        b=OYKGjDgfnxKpm/FiQOp3QD7YtRtrJO7Q7lMjdz4FZ8lK7M2FgpigAJSwpi074GsbKO
         /BT7g2nAeHgFMFjyr+txC30qApMEaYgdOa3R17VOId1aeCs09zJMaGnLdeqdj7xiMWGE
         vRZ+Y2tYfvSQ9+glru+YHujHwv9X+De78KlLXB96G1FcRegFk17IC2Hm30o0C4fyMKEo
         W088LSnhiehKwMtHanNqdYwHlrJIWaEux/EBXCPxH+8Xa3+5d5QOBKB7wsC9bS0OAeWK
         7jhByZTO7dAlpX0Fr9rZ1A269rF/v7JjwFS9m3igHU0NyqfFMv+LrD/xOs5d4oAuwxdT
         V09w==
X-Gm-Message-State: APjAAAWoLrtgj9yPuQi7B29WcMPXovvZLw0xtOep+xGUj7dl1aEZMOhM
        idJU49XaqEmL+aPY6zl2lO8wHMip8siTBmVp8ykQaQ==
X-Google-Smtp-Source: APXvYqxNQu1g9Swlj4ItY7HDQzDpLpZJ3izCmtZ6N6CCpd39vuCJadEa4YSBiWIqE+WMu6DZXNyq9S4tBDEBiKXq8Uo=
X-Received: by 2002:aca:4c9:: with SMTP id 192mr4108696oie.105.1578691654771;
 Fri, 10 Jan 2020 13:27:34 -0800 (PST)
MIME-Version: 1.0
References: <157863061737.2230556.3959730620803366776.stgit@dwillia2-desk3.amr.corp.intel.com>
 <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com> <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
 <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com> <CAPcyv4jixmv8fJ5FiYE=97Jud3Mc+6QzRX1txceSYU+WY_0rQA@mail.gmail.com>
 <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com> <CAPcyv4jVpN26RGQLRn4BewYtzHDoQfvh37DEdEBq1dd4-BP0kw@mail.gmail.com>
 <64902066-51dd-9693-53fc-4a5975c58409@redhat.com> <CAPcyv4hcDNeQO3CfnqTRou+6R5gZwyi4pVUMxp1DadAOp7kJGQ@mail.gmail.com>
 <516aa930-9b64-b377-557c-5413ed9fe336@redhat.com>
In-Reply-To: <516aa930-9b64-b377-557c-5413ed9fe336@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 Jan 2020 13:27:24 -0800
Message-ID: <CAPcyv4iiYtN6iGt=rVuNR=O=H9YcY1b1yWp+5TuDhu0QoVqT_A@mail.gmail.com>
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

On Fri, Jan 10, 2020 at 9:42 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 10.01.20 18:39, Dan Williams wrote:
> > On Fri, Jan 10, 2020 at 9:36 AM David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 10.01.20 18:33, Dan Williams wrote:
> >>> On Fri, Jan 10, 2020 at 9:29 AM David Hildenbrand <david@redhat.com> wrote:
> >>> [..]
> >>>>> So then the comment is actively misleading for that case. I would
> >>>>> expect an explicit _unlocked path for that case with a comment about
> >>>>> why it's special. Is there already a comment to that effect somewhere?
> >>>>>
> >>>>
> >>>> __add_memory() - the locked variant - is called from the same ACPI location
> >>>> either locked or unlocked. I added a comment back then after a longe
> >>>> discussion with Michal:
> >>>>
> >>>> drivers/acpi/scan.c:
> >>>>         /*
> >>>>          * Although we call __add_memory() that is documented to require the
> >>>>          * device_hotplug_lock, it is not necessary here because this is an
> >>>>          * early code when userspace or any other code path cannot trigger
> >>>>          * hotplug/hotunplug operations.
> >>>>          */
> >>>>
> >>>>
> >>>> It really is a special case, though.
> >>>
> >>> That's a large comment block when we could have just taken the lock.
> >>> There's probably many other code paths in the kernel where some locks
> >>> are not necessary before userspace is up, but the code takes the lock
> >>> anyway to minimize the code maintenance burden. Is there really a
> >>> compelling reason to be clever here?
> >>
> >> It was a lengthy discussion back then and I was sharing your opinion. I
> >> even had a patch ready to enforce that we are holding the lock (that's
> >> how I identified that specific case in the first place).
> >
> > Ok, apologies I missed that opportunity to back you up. Michal, is
> > this still worth it?
> >
>
> For your reference (roughly 5 months ago, so not that old)
>
> https://lkml.kernel.org/r/20190724143017.12841-1-david@redhat.com

Oh, now I see the problem. You need to add that lock so far away from
the __add_memory() to avoid lock inversion problems with the
acpi_scan_lock. The organization I was envisioning would not work
without deeper refactoring.
