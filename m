Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32516386E03
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 02:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbhERADj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 20:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237520AbhERADi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 20:03:38 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372C0C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 17:02:21 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 131so9349414ljj.3
        for <stable@vger.kernel.org>; Mon, 17 May 2021 17:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=htLElq/oj3C40pJk2BBo6bThnbO49lOr0ULOiP+FD0g=;
        b=h55xp2rIwHPHW0X5exVxihYgXBF7wgJRVYnnIQU52FtYgaMRneL/9ekB/ouiWzJUnW
         lFopfdoig/DgqGAn59UOyt4y++aobHQ13xYOWSIk6uvJ3sQijwxxQcrnDZGTz5pdmR6o
         rXWTU+ARtSF2QXUaqUshUp+w2hHfMFt8IIP/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=htLElq/oj3C40pJk2BBo6bThnbO49lOr0ULOiP+FD0g=;
        b=N5SwboHJyAgrZ2WQzMUXOGZxhVSWIHIo8jkl+tcs/jaOycO+gZU2urTv0ZDFNnuBuH
         ATxPrbJdIicKHzF8wT0W64zRJCEmdXtZaTsN2KN+zz2uDkuXSvmNjnlYZHQ3dkVdYp3h
         VlqYu9Dya62ZXyz6iedhXtnRK7dTqEB4JqrmzI0/Scf4+qFF4GH7kMYF6bG9eo7smkWK
         5QNk0fxb3CewrkG4TO/GRzRfjuuu7Mf+Pwp56cheATQ6OF8oeLCLCc9Mmr3SiNWz9tY8
         jSOEseCf7u4Qb8tr3zooX79T8aTL0+lAHy+vaUZdNAubZhDdBxlXwjxcFauuVYkfnd95
         Tkig==
X-Gm-Message-State: AOAM530jI2m6ZDGndBqUGvT/r8iccpQyuncl9qjeL326yJmVQCVHr0Nx
        mxmuEZdRXs9yB0ChWyf4UIwtLmODzMnT61l6
X-Google-Smtp-Source: ABdhPJxx/p6wBSQbn2Yb3pA6+rkRZZ8z8nz42e+jbjPFBFnXohNsm8PwEFL5dQvJ4cmVQ4TnoFW63Q==
X-Received: by 2002:a2e:9acf:: with SMTP id p15mr1635862ljj.337.1621296139461;
        Mon, 17 May 2021 17:02:19 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id z23sm2093217lfu.32.2021.05.17.17.02.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 17:02:18 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id h4so11401223lfv.0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 17:02:18 -0700 (PDT)
X-Received: by 2002:ac2:4a9d:: with SMTP id l29mr1743413lfp.201.1621296137909;
 Mon, 17 May 2021 17:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210516121844.2860628-1-willy@infradead.org> <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org> <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org> <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
 <YKHYFpyPcnwpetM5@casper.infradead.org> <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
 <YKL2C0YtlxYbsRdT@casper.infradead.org> <CAHk-=wja9m_sdu2VekWNJWhswZ8CVKROPvtCreZmANE1jBCHDw@mail.gmail.com>
In-Reply-To: <CAHk-=wja9m_sdu2VekWNJWhswZ8CVKROPvtCreZmANE1jBCHDw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 May 2021 17:02:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiH2++_KaaunpNYWD6YiMuU_VyCHgO-1RbvGUq=0_mAJg@mail.gmail.com>
Message-ID: <CAHk-=wiH2++_KaaunpNYWD6YiMuU_VyCHgO-1RbvGUq=0_mAJg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 4:37 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't mind that rule, but what's the advantage of introducing a new
> name for that? IOW, I get the feeling that almost all of this
> could/should just be "don't use non-head pages".

Put another way: I've often wanted to remove the (quite expensive)
"compund_head()" calls out of the code page functions, and move them
into the callers (and in most cases they probably just end up
disappearing entirely, because the callers fundamentally always have a
proper head page).

It feels like this is what the folio patches do, they just spend a
*lot* of effort doing so incrementally by renaming things and
duplicating functionality, rather than just do it (again
incrementally) by just doing one compound_head() movement at a time..

              Linus
