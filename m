Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2514148D6C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 19:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390769AbgAXSFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 13:05:03 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37950 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390693AbgAXSFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 13:05:03 -0500
Received: by mail-ot1-f67.google.com with SMTP id z9so2467384oth.5
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 10:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRTNXnXM7oz5Drw0JUEzLHf8Tl/lM2SK6ojzvbVm3Do=;
        b=JPa2uVHTQnO/DXnNRVd8XmoPi8VpJuIDhI+MwREr6Mb8Ij5HVUDpA6TxomyZ+Lff6W
         Y0DI9Cm0csX4gVNf0fT2szWUMfB8PaOM+JHgiQ6lHgp2HYGhZ1FLuEQr0mFTp/UHZGEJ
         4+wmRzEAsVw/5tyikkUBaJSaYwn1dj9gvK9c5x/AxAQpvh0podrIffNwzqKp0EkArmJ1
         oMwVvXtqQAlFZUlPokk+ed89Py3Hp2N12VOLnaJO0t5fYarr08YbsRzuILrxgeCojT/8
         rcUiO4nPjlpm1y4ofxPB9A4MFUjfm6TIH4pRlXvUZhWjjbyJWGoW4+7jNw2e/p4KVf8Q
         t5qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRTNXnXM7oz5Drw0JUEzLHf8Tl/lM2SK6ojzvbVm3Do=;
        b=qL69X1ouEEQOYcjU5Kydh0U2r04WltdmC5Q70o8527gMWTvLY7tlgS2cevf49cZi9i
         YJ30MIMAsxlpN3e2ytJJPlJK4NoDL6CJp75EX0i7hewHQ197XeHfCb9Q7Z8GLTw6ANQ3
         SGF0p2IbR/hJF1cPZJOWo6qJo7TC7yyCmZbjkCNjn51JHHXxat13QjN5kCxrderu2izZ
         2DTy53lEn7BOgw2jUolcWCQ9WyGfdHBPbN/QJQEofFhMtjydutdpMWtbT5G2IoVdEd1g
         QEGhhJIf0XWRh7F6GPkvdP/4kdixy4U4GZvdypRwkxADAb+DXwHf/aGgwtW2eir8meqP
         Nx0w==
X-Gm-Message-State: APjAAAUDfIJndI+KAxCP+B982qz+ZtTRoFjdVeAeiMPLI6NXbmWf/QSF
        gCV1FSUk6X+gDawcn9qRpaFybSn3tPhpB76pQtOY5g==
X-Google-Smtp-Source: APXvYqzFJoNGdvBkNazI2Gmjmm0Jg7CrgLUOGYJxHStstoF4GHQEZ08I0ffdQ1SOyeaigHkZmgGXPCfxHkNpYgjxS48=
X-Received: by 2002:a9d:68d3:: with SMTP id i19mr3393231oto.71.1579889102817;
 Fri, 24 Jan 2020 10:05:02 -0800 (PST)
MIME-Version: 1.0
References: <e60e64f9-894b-4121-d97b-fb61459cbbe5@redhat.com>
 <CAPcyv4jm=fmP=-5vbo2jxzMe2qXqZP=zDYF8G_rs3X6_Om0wPg@mail.gmail.com>
 <4d0334e2-c4e7-6d3f-99ba-2ca0495e1549@redhat.com> <CAPcyv4jixmv8fJ5FiYE=97Jud3Mc+6QzRX1txceSYU+WY_0rQA@mail.gmail.com>
 <fc0cfb97-5a60-7e73-4f85-d8e6947c5e28@redhat.com> <CAPcyv4jVpN26RGQLRn4BewYtzHDoQfvh37DEdEBq1dd4-BP0kw@mail.gmail.com>
 <64902066-51dd-9693-53fc-4a5975c58409@redhat.com> <CAPcyv4hcDNeQO3CfnqTRou+6R5gZwyi4pVUMxp1DadAOp7kJGQ@mail.gmail.com>
 <516aa930-9b64-b377-557c-5413ed9fe336@redhat.com> <CAPcyv4iiYtN6iGt=rVuNR=O=H9YcY1b1yWp+5TuDhu0QoVqT_A@mail.gmail.com>
 <20200124124512.GT29276@dhcp22.suse.cz>
In-Reply-To: <20200124124512.GT29276@dhcp22.suse.cz>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 24 Jan 2020 10:04:52 -0800
Message-ID: <CAPcyv4jcCnfGy5HcYimxcyF6v_Anw4nMdaNHQt4tMrqUaN70Rg@mail.gmail.com>
Subject: Re: [PATCH] mm/memory_hotplug: Fix remove_memory() lockdep splat
To:     Michal Hocko <mhocko@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 24, 2020 at 4:56 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 10-01-20 13:27:24, Dan Williams wrote:
> > On Fri, Jan 10, 2020 at 9:42 AM David Hildenbrand <david@redhat.com> wrote:
> [...]
> > > For your reference (roughly 5 months ago, so not that old)
> > >
> > > https://lkml.kernel.org/r/20190724143017.12841-1-david@redhat.com
> >
> > Oh, now I see the problem. You need to add that lock so far away from
> > the __add_memory() to avoid lock inversion problems with the
> > acpi_scan_lock. The organization I was envisioning would not work
> > without deeper refactoring.
>
> Sorry to come back to this late. Has this been resolved?

The mem_hotplug_lock lockdep splat fix in this patch has not landed.
David and I have not quite come to consensus on how to resolve online
racing removal. IIUC David wants that invalidation to be
pages_correctly_probed(), I would prefer it to be directly tied to the
object, struct memory_block, that remove_memory_block_devices() has
modified, mem->section_count = 0.

...or are you referring to the discussion about acpi_scan_lock()? I
came around to agreeing with your position that documenting was better
than adding superfluous locking especially because the
acpi_scan_lock() is take so far away from where the device_hotplug
lock is needed.
