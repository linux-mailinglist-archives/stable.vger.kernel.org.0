Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2CD21F8D2
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgGNSMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbgGNSMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 14:12:46 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F8AC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:12:46 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t18so15034970ilh.2
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgMYLghS9qV+zQ3j/AEHdigXuQT8tk2Ry048DCv3WNo=;
        b=dq68p4Oe6FTibRT0OKXe06CPAge1OFrmt3gile+/qSYXPHXUtOKRn0era1397ge7iu
         SG0nsm4H7K+6hZKM5Vkb9MlBteNDRdUG8mrLYIN7NPDfr5s5pRLh9h6UcW6OI3ZCFfXb
         Xd09xrFtLNw2jIxhB4wLLFDrF+rMXW9ILgVMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgMYLghS9qV+zQ3j/AEHdigXuQT8tk2Ry048DCv3WNo=;
        b=JLMwaTFLrNHMDaZZgS+sCRjo5pk7Q48hYbQ2Au6zvcRzt678PV7/qRgfsu1IVEfP9l
         UY9vAcjI0k6UB4BEmmz0b3dfB4XL2HOyvg7bz31wqZsBf9uBPOQK1TlPY17xn0Lr+7wJ
         tXovzna/0q+kA4Sc25sUMtDQv+fY1MP/GkyiKz1r5lAaFms+nNiyEuQDhDVO+VoSje/w
         03JMZy9N9KifSYpKz7stFvKg1x9vUSZfOIrDVGkg0PPCTy8knsl9mj/qWDysiG/GosOo
         hwEdAKIKdfsW3ZSG4h9QGYCRIhZH8pJiVVbYZ2UMDOSzXR98n2BshuCtKgufY1LndsP7
         16Kg==
X-Gm-Message-State: AOAM533c1Kjy2psYFBKphBw+DiX/52dHpN9ZEVy1dufCar5zt1LPHk+e
        t+S6ycXRyJKW8ARAalV40vRlqswCCwk23OFEWODcKw==
X-Google-Smtp-Source: ABdhPJxZh9UtdKz/96YNIgTICaWWllWK6qo3ibzuoBpQ/DEDx3DUR9Zka1P+EnolKivtnMEOWWuJNr7z5hjeAlsuqI0=
X-Received: by 2002:a92:cf42:: with SMTP id c2mr6263546ilr.13.1594750365698;
 Tue, 14 Jul 2020 11:12:45 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <20200712215041.GA3644504@google.com> <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
 <20200714073306.kq4zikkphqje2yzb@box> <20200714160843.GA1685150@google.com> <CAHk-=wjffJ=EBrLjsz=KUFyPXVQUO03L=VJmHnLhVr4XvT3Mpw@mail.gmail.com>
In-Reply-To: <CAHk-=wjffJ=EBrLjsz=KUFyPXVQUO03L=VJmHnLhVr4XvT3Mpw@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 14 Jul 2020 14:12:33 -0400
Message-ID: <CAEXW_YRTnCb-z6TeboA3OCYv8eoX8UiCNn7K1hGMX+41Zdz8Og@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 12:11 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Jul 14, 2020 at 9:08 AM Joel Fernandes <joel@joelfernandes.org> wrote:
> >
> > I was thinking we should not call move_page_tables() with overlapping ranges
> > at all, just to keep things simple.
>
> No, we're not breaking the existing stack movement code just to keep
> things simple.
>
> The rule is "make it as simple as possible, but no simpler".
>
> And "as possible" in the case of Linux means "no breaking of old
> interfaces". The stack randomization movement most certainly counts.

Hi Linus,
I think you misunderstood me. I was not advocating breaking the stack
movement code or breaking stack randomization, I was going to try to
see if I could keep that working while not having to do an overlapping
move. That would be what I would do in the future patch (until which
as you mentioned, you would switch the WARN_ON to WARN_ON_ONCE).

I agree with you that we keep things as simple as possible while not
breaking functionality.

Cheers,

 - Joel
