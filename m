Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3F16D9F42
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 19:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbjDFRwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 13:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239924AbjDFRwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 13:52:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9635B8689
        for <stable@vger.kernel.org>; Thu,  6 Apr 2023 10:52:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id g18so3317308ejj.5
        for <stable@vger.kernel.org>; Thu, 06 Apr 2023 10:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680803562; x=1683395562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mso+OWc0NQ4kyA8lIzevjY2mQtAeqGXpiGyLYztjC/Y=;
        b=s5QCc1DIbED97dHwuf8rxyDbmRf2F4IYzf5opI/14uRp1aXTwC4lD0imTvSCQufV6B
         X0LmlL3+zP8Z4+S2CPA1qLby3O9EvzYfOd0VlUOegtwFw6pN04N3xs0l0SfgmXCp+Yv3
         obuyFP4UksfJ/LCY10Bv8YdngrpN6Ziv6pIeqVKvlelCn/SZJrC4lvU00uCyAVAg9c7/
         vXr6CTPZM0eiUEplNIqwYWehXL/xeBf2y+OIS1s95p4Dq+QA6RKjZ2S4xG5hPXqhPPzr
         xUsFMkVvjX9m/peKtPgc07nKE12zWeXLBHDpjWUnNBSegsQnBUBs9Og/n3QELi1H/cmZ
         HSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680803562; x=1683395562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mso+OWc0NQ4kyA8lIzevjY2mQtAeqGXpiGyLYztjC/Y=;
        b=AF8UODRhNPBx/81spTVVPMYQaHNE1OlMWoBa4E5toslhI7eHltTodh7enxlvKsXnbR
         eGivBRgkhbJECuPl1bzlU6u/NU0hyON2TKYkb5fsTw7b6e4X4Ebj/9H1YMRkPsBv+dNI
         TN2xz7QtSVKlpk3em3BTZn1OuO88zjjI3d5f0t+8jSvgC7NTkdgCtX6883DGeRVPEHpb
         17EOhy3PMrqOJlw5aSu0S3Am5exkD5kluH+82PqYhjT0fGzvM5PKJyq7wPU1S6OKA8n5
         54kg6uoufr3Vk+R/JMy2GcPgZRdvxyvB5sg5edkPHINS5c2JuSXQluPdZKQWhEVhmFvJ
         cQ8g==
X-Gm-Message-State: AAQBX9euvlupdGWbg69W9p83QTi9LQq86a+DDe9e6JK0r4/fRnS6FZXk
        6uP56vdXA5SrirSwtd90j+06rpz0RU0QrYTvTrsUCg==
X-Google-Smtp-Source: AKy350a/zH2HmIWU3g5/OCjvmyr0CzZS6J95jcesZjoDC13AW/qyRPcnARZrC8SELVEDgBE6kxWR4pkbhrYcIo9w1Ew=
X-Received: by 2002:a17:906:3393:b0:933:7658:8b44 with SMTP id
 v19-20020a170906339300b0093376588b44mr3571466eja.15.1680803561756; Thu, 06
 Apr 2023 10:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230405185427.1246289-1-yosryahmed@google.com>
 <20230405185427.1246289-2-yosryahmed@google.com> <a8cb406a-70cd-aa47-fdda-50cd0eb8c941@redhat.com>
 <CAJD7tkbNsLo8Cd0nOm22oxD14GMppPoLNOHx2f8BJZA1wkpWnQ@mail.gmail.com> <14d50ddd-507e-46e7-1a32-72466dec2a40@redhat.com>
In-Reply-To: <14d50ddd-507e-46e7-1a32-72466dec2a40@redhat.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Thu, 6 Apr 2023 10:52:05 -0700
Message-ID: <CAJD7tkY42_Vw8e+h4uHAfXZex3JS4dGzYJcHiz9mjpWBAQQS3g@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 6, 2023 at 10:50=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 06.04.23 16:07, Yosry Ahmed wrote:
> > Thanks for taking a look, David!
> >
> > On Thu, Apr 6, 2023 at 3:31=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 05.04.23 20:54, Yosry Ahmed wrote:
> >>> We keep track of different types of reclaimed pages through
> >>> reclaim_state->reclaimed_slab, and we add them to the reported number
> >>> of reclaimed pages.  For non-memcg reclaim, this makes sense. For mem=
cg
> >>> reclaim, we have no clue if those pages are charged to the memcg unde=
r
> >>> reclaim.
> >>>
> >>> Slab pages are shared by different memcgs, so a freed slab page may h=
ave
> >>> only been partially charged to the memcg under reclaim.  The same goe=
s for
> >>> clean file pages from pruned inodes (on highmem systems) or xfs buffe=
r
> >>> pages, there is no simple way to currently link them to the memcg und=
er
> >>> reclaim.
> >>>
> >>> Stop reporting those freed pages as reclaimed pages during memcg recl=
aim.
> >>> This should make the return value of writing to memory.reclaim, and m=
ay
> >>> help reduce unnecessary reclaim retries during memcg charging.  Writi=
ng to
> >>> memory.reclaim on the root memcg is considered as cgroup_reclaim(), b=
ut
> >>> for this case we want to include any freed pages, so use the
> >>> global_reclaim() check instead of !cgroup_reclaim().
> >>>
> >>> Generally, this should make the return value of
> >>> try_to_free_mem_cgroup_pages() more accurate. In some limited cases (=
e.g.
> >>> freed a slab page that was mostly charged to the memcg under reclaim)=
,
> >>> the return value of try_to_free_mem_cgroup_pages() can be underestima=
ted,
> >>> but this should be fine. The freed pages will be uncharged anyway, an=
d we
> >>
> >> Can't we end up in extreme situations where
> >> try_to_free_mem_cgroup_pages() returns close to 0 although a huge amou=
nt
> >> of memory for that cgroup was freed up.
> >>
> >> Can you extend on why "this should be fine" ?
> >>
> >> I suspect that overestimation might be worse than underestimation. (se=
e
> >> my comment proposal below)
> >
> > In such extreme scenarios even though try_to_free_mem_cgroup_pages()
> > would return an underestimated value, the freed memory for the cgroup
> > will be uncharged. try_charge() (and most callers of
> > try_to_free_mem_cgroup_pages()) do so in a retry loop, so even if
> > try_to_free_mem_cgroup_pages() returns an underestimated value
> > charging will succeed the next time around.
> >
> > The only case where this might be a problem is if it happens in the
> > final retry, but I guess we need to be *really* unlucky for this
> > extreme scenario to happen. One could argue that if we reach such a
> > situation the cgroup will probably OOM soon anyway.
> >
> >>
> >>> can charge the memcg the next time around as we usually do memcg recl=
aim
> >>> in a retry loop.
> >>>
> >>> The next patch performs some cleanups around reclaim_state and adds a=
n
> >>> elaborate comment explaining this to the code. This patch is kept
> >>> minimal for easy backporting.
> >>>
> >>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> >>> Cc: stable@vger.kernel.org
> >>
> >> Fixes: ?
> >>
> >> Otherwise it's hard to judge how far to backport this.
> >
> > It's hard to judge. The issue has been there for a while, but
> > memory.reclaim just made it more user visible. I think we can
> > attribute it to per-object slab accounting, because before that any
> > freed slab pages in cgroup reclaim would be entirely charged to that
> > cgroup.
> >
> > Although in all fairness, other types of freed pages that use
> > reclaim_state->reclaimed_slab cannot be attributed to the cgroup under
> > reclaim have been there before that. I guess slab is the most
> > significant among them tho, so for the purposes of backporting I
> > guess:
> >
> > Fixes: f2fe7b09a52b ("mm: memcg/slab: charge individual slab objects
> > instead of pages")
> >
> >>
> >>> ---
> >>>
> >>> global_reclaim(sc) does not exist in kernels before 6.3. It can be
> >>> replaced with:
> >>> !cgroup_reclaim(sc) || mem_cgroup_is_root(sc->target_mem_cgroup)
> >>>
> >>> ---
> >>>    mm/vmscan.c | 8 +++++---
> >>>    1 file changed, 5 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >>> index 9c1c5e8b24b8f..c82bd89f90364 100644
> >>> --- a/mm/vmscan.c
> >>> +++ b/mm/vmscan.c
> >>> @@ -5346,8 +5346,10 @@ static int shrink_one(struct lruvec *lruvec, s=
truct scan_control *sc)
> >>>                vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned =
- scanned,
> >>>                           sc->nr_reclaimed - reclaimed);
> >>>
> >>> -     sc->nr_reclaimed +=3D current->reclaim_state->reclaimed_slab;
> >>> -     current->reclaim_state->reclaimed_slab =3D 0;
> >>
> >> Worth adding a comment like
> >>
> >> /*
> >>    * Slab pages cannot universally be linked to a single memcg. So onl=
y
> >>    * account them as reclaimed during global reclaim. Note that we mig=
ht
> >>    * underestimate the amount of memory reclaimed (but won't overestim=
ate
> >>    * it).
> >>    */
> >>
> >> but ...
> >>
> >>> +     if (global_reclaim(sc)) {
> >>> +             sc->nr_reclaimed +=3D current->reclaim_state->reclaimed=
_slab;
> >>> +             current->reclaim_state->reclaimed_slab =3D 0;
> >>> +     }
> >>>
> >>>        return success ? MEMCG_LRU_YOUNG : 0;
> >>>    }
> >>> @@ -6472,7 +6474,7 @@ static void shrink_node(pg_data_t *pgdat, struc=
t scan_control *sc)
> >>>
> >>>        shrink_node_memcgs(pgdat, sc);
> >>>
> >>
> >> ... do we want to factor the add+clear into a simple helper such that =
we
> >> can have above comment there?
> >>
> >> static void cond_account_reclaimed_slab(reclaim_state, sc)
> >> {
> >>          /*
> >>           * Slab pages cannot universally be linked to a single memcg.=
 So
> >>           * only account them as reclaimed during global reclaim. Note
> >>           * that we might underestimate the amount of memory reclaimed
> >>           * (but won't overestimate it).
> >>           */
> >>          if (global_reclaim(sc)) {
> >>                  sc->nr_reclaimed +=3D reclaim_state->reclaimed_slab;
> >>                  reclaim_state->reclaimed_slab =3D 0;
> >>          }
> >> }
> >>
> >> Yes, effective a couple LOC more, but still straight-forward for a
> >> stable backport
> >
> > The next patch in the series performs some refactoring and cleanups,
> > among which we add a helper called flush_reclaim_state() that does
> > exactly that and contains a sizable comment. I left this outside of
> > this patch in v5 to make the effective change as small as possible for
> > backporting. Looks like it can be confusing tho without the comment.
> >
> > How about I pull this part to this patch as well for v6?
>
> As long as it's a helper similar to what I proposed, I think that makes
> a lot of sense (and doesn't particularly bloat this patch).

Sounds good to me, I will do that and respin.

Thanks David!

>
> --
> Thanks,
>
> David / dhildenb
>
>
