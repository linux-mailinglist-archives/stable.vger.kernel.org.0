Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83BB200A11
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbgFSN2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbgFSN11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:27:27 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB0CC06174E
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:27:27 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dp18so10184054ejc.8
        for <stable@vger.kernel.org>; Fri, 19 Jun 2020 06:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DA6Y6jC2TzaiGodk9y32gytpv8P8xdVd55/nEYjazs0=;
        b=OApq1XezXoo6dYDPPlUTpjnysTFdMg1aN7nLEcfF69A//9AtJMdKm3+oZ8ID5iSPWM
         2FpqSiRFkGgIeq4Lc0/riQjc0AlnRGzl8jHhOAAbi0NHpS7u36VhJ8kib1BlwAqEOI/Y
         D/6wgDvfb1LXweuUZEwz8IRFoxmOqS6bwNBQB2m+fe5zqROcgAHwJ7pEtZ3eoNzzRMxn
         KjWrjpbSBkSBrdGSiYaTwQIJaTuRf5iDYcrHg15CdhZtBDHNiqxr4r8EgyZHUrqGCmkW
         2C1+BdzFXMKLfw9rwUa9Ou3tKK6fs+gl9I0PNJqVVKgxEhMx904za0w5zBzs2dSFhkxZ
         ST5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DA6Y6jC2TzaiGodk9y32gytpv8P8xdVd55/nEYjazs0=;
        b=jElFFfrq6odwi6yaqSymynjfIIfvFAz8OBBVYKa/URvAqqaiSDttPEoNqxACgpYDv+
         ttRLYzTEwVEoD0SM5nVUTlwQMQ8SewaJ8moLUbA4gJXr/txn1TXk9ixV7WvcDoSEXM1b
         mICIPmVn+FPyj3O3qdTHYLC9kTpodDUficii7DUDwo95Q6s+xHHVwNrFebLK5+k7Sq0p
         zO/yI2r1Ojridf+5+y3YlUuWzAUoVrVGuD/IUH2OoCPYik78vbHJZkqabRHijw6RLmj6
         PXEIGARNDWoE27/If1PmhH3LOivda9uLgkZmXl1ui+v2jvEKIPxJeznJTX+ijG/SuUB0
         x9cA==
X-Gm-Message-State: AOAM533mZHhmf2dO92O+n7Kt5P0rMI41h/bChQxNC6RwM8i8LsHESVmU
        F+KoHA4vj8B9ryqDoUgLrl/ymUrwydfM/l6/F+dRNg==
X-Google-Smtp-Source: ABdhPJyZ++0QWLtFlJW7Ohvqxq3hqku6iM11QCUjQV/1Cya634j+pQUzo57CYEEoOgP3wTOIuueJTUKlbskTDxzTdiA=
X-Received: by 2002:a17:907:435f:: with SMTP id oc23mr3775910ejb.426.1592573246161;
 Fri, 19 Jun 2020 06:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <15924957437531@kroah.com> <20200618162649.GA250996@kroah.com>
 <20200619022822.GV1931@sasha-vm> <20200619092137.GB12177@dhcp22.suse.cz>
 <82125cf7-a3e0-8596-ef6a-cda750bee28b@redhat.com> <CA+CK2bDVVcjvQAswxPe-2=DTOjf09Ty3tR69WdcEFaTgd87EqQ@mail.gmail.com>
 <d5d57204-a503-de53-edb1-63d12709e687@redhat.com> <CA+CK2bAo3dD3A4UqX9f3ruMYjBiiM8PRy1H8wJpi3JWUVgomDQ@mail.gmail.com>
In-Reply-To: <CA+CK2bAo3dD3A4UqX9f3ruMYjBiiM8PRy1H8wJpi3JWUVgomDQ@mail.gmail.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Fri, 19 Jun 2020 09:26:50 -0400
Message-ID: <CA+CK2bAa3YGc8e0vpq7czd6fe0QZDJ+7FTVsy+WAPLjA2Ho-yQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mm: call cond_resched() from
 deferred_init_memmap()" failed to apply to 5.7-stable tree
To:     David Hildenbrand <david@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        James Morris <jmorris@namei.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        pankaj.gupta.linux@gmail.com,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yiqian Wei <yiwei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 8:43 AM Pavel Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > > 117003c32771 mm/pagealloc.c: call touch_nmi_watchdog() on max order
> > > boundaries in deferred init
> > > 3d060856adfc mm: initialize deferred pages with interrupts enabled
> > > da97f2d56bbd mm: call cond_resched() from deferred_init_memmap()
> > >
> >
> > Just to note, in contrast to the subject, this is about the 4.19
> > backport IIRC. Is it really only these patches?
>
> Ah, I did not realize it was 4.19 backport.
>
> Yeah, it might be more, I have not checked it.

5.7 backport:
https://lore.kernel.org/stable/20200619122555.372957-1-pasha.tatashin@soleen.com
4.19 backport:
https://lore.kernel.org/stable/20200619132425.425063-1-pasha.tatashin@soleen.com

>
> Thanks,
> Pasha
