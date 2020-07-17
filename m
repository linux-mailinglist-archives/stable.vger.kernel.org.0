Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36E02237EA
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 11:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgGQJM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 05:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgGQJM1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 05:12:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFC6C061755;
        Fri, 17 Jul 2020 02:12:27 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l23so310459qkk.0;
        Fri, 17 Jul 2020 02:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GnonKWI30rguXS7h1YA4tqQthfNBF8/h7qxKFP7NCi8=;
        b=pN+iEkbKtmtWOS1dFVEJxVYGvO6Nv3DJxZ2rcKhy2el36Lo2M2637mw/46dCxCHNIW
         TPhRPgJUaJND4/d2lfuHCgJawl1BZnE2N/Hczsun4G2e0Skaqa/mO7JtCZBwC3X+Bkwc
         ivPyM6GgChG/9O464ICajuDpJjM65TvQrjnJygIgXnXmwAWV1rSx8OppUb7pDLkpJKNv
         kY735v+9f105rpSvNnA/BFNLcwHKI7AVTTQwuAVJB1n5uK1DSGYvwp5W3+oz35VybHDy
         1eLFZkjaKl4xULjNOzpLVLnpEWaqqQ046yVXcLrJ7pN2O2tkK9gL7jmiGoSs/m65+Y8E
         es+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GnonKWI30rguXS7h1YA4tqQthfNBF8/h7qxKFP7NCi8=;
        b=q6m0tJ/r+nZHZVqMJ3fTA53wmUfX6H4iGsvyGHfpECLyTj9o4OZYuvvM+MNU3atZVm
         HwB3UDxwmxqrBcXnE5I/Eeltxnpx/Pxh3rSTVF9iVtHEhdFj5gkSPd0lwBr6DSugtDP+
         ApTW7hfIvwxUURYsp2GQJXYb05Y3zo6LE/cotf9o6HplllOpF0JBCLnL2ylYrq/kHuOX
         KBEQHfOYO6beRxbo/Z+3xp0K+0Ta3uSCZ5H5MJHgtEytdr2zvaMtRpwmFlvWzb/Vjcqn
         Iu+ZXDXaxJN2VE9PvgfZLXIQFB5H9i7z0mi/U7HG5aqO4TfC8sr1zRi0EOlUAMYTIcJ+
         9a/w==
X-Gm-Message-State: AOAM530ghUKdat4AhpPYrZ9oxMrtCmjqBdqxj/vqefOIB4Fz5SYIi8eG
        Hcy+kWUT2q9KImCniFeRXEa6YjrX5Vt5nSfFVfk=
X-Google-Smtp-Source: ABdhPJwmbE7fIST0ir+FIiy8ZXFYqX5dhV/83uc8D0YuefqFKwDvOAb6dqbKFeID4IrE+dQsoSmmK/rQBrf4jDDZsyM=
X-Received: by 2002:a37:a785:: with SMTP id q127mr8092807qke.452.1594977146715;
 Fri, 17 Jul 2020 02:12:26 -0700 (PDT)
MIME-Version: 1.0
References: <1594789529-6206-1-git-send-email-iamjoonsoo.kim@lge.com>
 <332d620b-bfe3-3b69-931b-77e3a74edbfd@suse.cz> <CAAmzW4NbG0fCtU2mV83pRamUeOEqKKxGTpQK2zuDxzmoF2FVrg@mail.gmail.com>
 <6f18d999-4518-31ce-4cea-9b5b89a577ad@suse.cz> <CAAmzW4MLc8bmkYW1q1fL_WRFQHksX-oy9tS-s9Kb-A=ZEeGETQ@mail.gmail.com>
 <5a8b13d5-da40-7b1b-2968-e6701001cc0e@suse.cz> <c2edfd71-eee5-3d73-a9ee-0c384a3440be@suse.cz>
In-Reply-To: <c2edfd71-eee5-3d73-a9ee-0c384a3440be@suse.cz>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Fri, 17 Jul 2020 18:12:15 +0900
Message-ID: <CAAmzW4PSUsuK4G4mSReksnrj7wq1do=yY=VfvZVMQd-ghwcVKQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/page_alloc: fix non cma alloc context
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Christoph Hellwig <hch@infradead.org>,
        Roman Gushchin <guro@fb.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2020=EB=85=84 7=EC=9B=94 17=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 5:15, V=
lastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 7/17/20 10:10 AM, Vlastimil Babka wrote:
> > On 7/17/20 9:29 AM, Joonsoo Kim wrote:
> >> 2020=EB=85=84 7=EC=9B=94 16=EC=9D=BC (=EB=AA=A9) =EC=98=A4=ED=9B=84 4:=
45, Vlastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>>
> >>> On 7/16/20 9:27 AM, Joonsoo Kim wrote:
> >>> > 2020=EB=85=84 7=EC=9B=94 15=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84=
 5:24, Vlastimil Babka <vbabka@suse.cz>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
> >>> >> >  /*
> >>> >> >   * get_page_from_freelist goes through the zonelist trying to a=
llocate
> >>> >> >   * a page.
> >>> >> > @@ -3706,6 +3714,8 @@ get_page_from_freelist(gfp_t gfp_mask, uns=
igned int order, int alloc_flags,
> >>> >> >       struct pglist_data *last_pgdat_dirty_limit =3D NULL;
> >>> >> >       bool no_fallback;
> >>> >> >
> >>> >> > +     current_alloc_flags(gfp_mask, &alloc_flags);
> >>> >>
> >>> >> I don't see why to move the test here? It will still be executed i=
n the
> >>> >> fastpath, if that's what you wanted to avoid.
> >>> >
> >>> > I want to execute it on the fastpath, too. Reason that I moved it h=
ere
> >>> > is that alloc_flags could be reset on slowpath. See the code where
> >>> > __gfp_pfmemalloc_flags() is on. This is the only place that I can a=
pply
> >>> > this option to all the allocation paths at once.
> >>>
> >>> But get_page_from_freelist() might be called multiple times in the sl=
owpath, and
> >>> also anyone looking for gfp and alloc flags setup will likely not exa=
mine this
> >>> function. I don't see a problem in having it in two places that alrea=
dy deal
> >>> with alloc_flags setup, as it is now.
> >>
> >> I agree that anyone looking alloc flags will miss that function easily=
. Okay.
> >> I will place it on its original place, although we now need to add one
> >> more place.
> >> *Three places* are gfp_to_alloc_flags(), prepare_alloc_pages() and
> >> __gfp_pfmemalloc_flags().
> >
> > Hm the check below should also work for ALLOC_OOM|ALLOC_NOCMA then.
> >
> > /* Avoid allocations with no watermarks from looping endlessly */
> >    if (tsk_is_oom_victim(current) &&
> >         (alloc_flags =3D=3D ALLOC_OOM ||
> >          (gfp_mask & __GFP_NOMEMALLOC)))
> >             goto nopage;
> >
> > Maybe it's simpler to change get_page_from_freelist() then. But documen=
t well.
>
> But then we have e.g. should_reclaim_retry() which calls __zone_watermark=
_ok()
> where ALLOC_CMA plays a role too, so that means we should have alloc_mask=
 set up
> correctly wrt ALLOC_CMA at the __alloc_pages_slowpath() level...

Good catch! Hmm... Okay. It would be necessarily handled in three places.
I will fix it on the next version. Anyway, we need some clean-up about
alloc_flags
handling since it looks not good for maintenance.

Thanks.
