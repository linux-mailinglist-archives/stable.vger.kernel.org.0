Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C0422BC7C
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 05:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgGXDco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 23:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGXDcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 23:32:43 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2A3C0619D3;
        Thu, 23 Jul 2020 20:32:43 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id o22so5781252qtt.13;
        Thu, 23 Jul 2020 20:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DtcH1eTSgDszis0K7FXJ1OIRE9d5R8EpJXxCpjozCEs=;
        b=UA/Edbu+dhtvk4WBnl7FYJzN1RWqJ9JCjXCSLIW8hVtUQusFBc56abTMTaTCJuBR4b
         FVuxxneBZrZ8w+IxP8SomsV6jFyeEQxnlEG9Mo1RuD0NNeGJMRRs+AuWbd0Z2bUNrdx9
         PN/B17zT6quEeH7LB8I8Ja2IJ3hwuXI1hJ9kU5mkPgQG6uAxEOfvEFdnYfpXUbJepnnQ
         UyphCL9W88aQRNCKJh2KTochD6+S26lPE6BREfP+abUnOMJzb1bOKuRC6aj+rg7ciPIK
         yfJOKQcmngIelhtdTab84BM3YC7KmmiUTUamk+AvOwMKe1mEW7EWAB/IjsCTXUOmWqr6
         0t5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DtcH1eTSgDszis0K7FXJ1OIRE9d5R8EpJXxCpjozCEs=;
        b=VkBcLm7HnGtvZZd+kwHhZwBv32dB1tbNoibE3fx0J0LDoheFxVwpdb1x/U63PA9n4w
         OENkpSggWqRPk87JfzEmNDI/fDniNVPdiyy0IpxCu2sDU7E6qNd1ljpWjG1uWropMXnl
         ajYBkAwQvrrgg9v/t1068CWuNT6PbLipXGNJLYbpH4PUg7amIkNLjyE+aF9kxh+dch0g
         QAuHjTpcZzVqqwRGr08rW2T4cHBgynBY1nPI2r3Xe3yqEvzG4b+0idte1Erh7iOe32ET
         fM2r5lyhB6aEEKmKMC54UscaGgsOYejkK4neP/ztPAifaJov2F3bRwcEJNigbviRxKlA
         nn9Q==
X-Gm-Message-State: AOAM5325NpoGd0ZeE/NAT7y31Aa4bzqhSK/SCQrSXdkg1woFDcLhXXEh
        6+G+R/pKqzfIIFldtX3RP7xmEN3/POVRnEcQrB+k2A==
X-Google-Smtp-Source: ABdhPJwEn6kqyyLS60CluVwRJCMjkbqAvw20TguZLXgpyUxcMz4OI16TOCT7v39gd4+3OKfY2jKnWs9Xqi14PLWLfYQ=
X-Received: by 2002:ac8:4d0c:: with SMTP id w12mr6645053qtv.194.1595561562872;
 Thu, 23 Jul 2020 20:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <1595468942-29687-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20200723180814.acde28b92ce6adc785a79120@linux-foundation.org>
 <CAAmzW4N9Y4W7CHenWA=TYu9tttgpYR=ZN+ky1vmXPgUJcjitAw@mail.gmail.com>
 <20200723193600.28e3eedd00925b22f7ca9780@linux-foundation.org>
 <CAAmzW4NhY0iaE02vwf+2O+aeK66CoKG_-BvsgqpfwZv3Q-w8dA@mail.gmail.com> <20200723201404.f76ccd792c9e74f3ae8ec9f5@linux-foundation.org>
In-Reply-To: <20200723201404.f76ccd792c9e74f3ae8ec9f5@linux-foundation.org>
From:   Joonsoo Kim <js1304@gmail.com>
Date:   Fri, 24 Jul 2020 12:32:31 +0900
Message-ID: <CAAmzW4Prx+pgwpg8ovwUo6s7YnM9S8LeUmJSTD6a3wZ1iQFYtw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: fix memalloc_nocma_{save/restore} APIs
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lge.com,
        Vlastimil Babka <vbabka@suse.cz>,
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

2020=EB=85=84 7=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 12:14, =
Andrew Morton <akpm@linux-foundation.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> On Fri, 24 Jul 2020 12:04:02 +0900 Joonsoo Kim <js1304@gmail.com> wrote:
>
> > 2020=EB=85=84 7=EC=9B=94 24=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 11:=
36, Andrew Morton <akpm@linux-foundation.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
> > >
> > > On Fri, 24 Jul 2020 11:23:52 +0900 Joonsoo Kim <js1304@gmail.com> wro=
te:
> > >
> > > > > > Second, clearing __GFP_MOVABLE in current_gfp_context() has a s=
ide effect
> > > > > > to exclude the memory on the ZONE_MOVABLE for allocation target=
.
> > > > >
> > > > > More whoops.
> > > > >
> > > > > Could we please have a description of the end-user-visible effect=
s of
> > > > > this change?  Very much needed when proposing a -stable backport,=
 I think.
> > > >
> > > > In fact, there is no noticeable end-user-visible effect since the f=
allback would
> > > > cover the problematic case. It's mentioned in the commit descriptio=
n. Perhap,
> > > > performance would be improved due to reduced retry and more availab=
le memory
> > > > (we can use ZONE_MOVABLE with this patch) but it would be neglectab=
le.
> > > >
> > > > > d7fefcc8de9147c is over a year old.  Why did we only just discove=
r
> > > > > this?  This makes one wonder how serious those end-user-visible e=
ffects
> > > > > are?
> > > >
> > > > As mentioned above, there is no visible problem to the end-user.
> > >
> > > OK, thanks.  In that case, I don't believe that a stable backport is
> > > appropriate?
> > >
> > > (Documentation/process/stable-kernel-rules.rst)
> >
> > Thanks for the pointer!
> >
> > Hmm... I'm not sure the correct way to handle this patch. I thought tha=
t
> > memalloc_nocma_{save,restore} is an API that is callable from the modul=
e.
> > If it is true, it's better to regard this patch as the stable candidate=
 since
> > out-of-tree modules could use it without the fallback and it would caus=
e
> > a problem. But, yes, there is no visible problem to the end-user, at le=
ast,
> > within the mainline so it is possibly not a stable candidate.
> >
> > Please share your opinion about this situation.
>
> We tend not to care much about out-of-tree modules.  I don't think a
> theoretical concern for out-of-tree code justifies risking the
> stability of -stable kernels.

Okay. It's appreciated if you remove the stable tag. Or, I will send it aga=
in
without the stable tag.

Thanks.
