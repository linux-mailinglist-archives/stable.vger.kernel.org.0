Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA5621F70E
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 18:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgGNQSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 12:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNQSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 12:18:06 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A5AC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 09:18:06 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a1so22670934ejg.12
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 09:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVja+Dm3U4NNdoUzuGjR/wqvDeVbDJNnrorH0uGFQ1c=;
        b=hPQODzQeZU73y/uYKV3Or723M4Cd3tvDmXFHXDZxwc+KS0m8Ik+d8ktVcP6IwAmUh2
         e/Tgq0pCCJ3dVb4vS8wSP+mNSYY+Fbx1xHTpNcw7/DtynQixRQYltmHYu2OHIrdP80P7
         B6L7zYegq+LM862HVAY4Aot1lHzFerNg0ZcSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVja+Dm3U4NNdoUzuGjR/wqvDeVbDJNnrorH0uGFQ1c=;
        b=L7b6CdUmkn7xdBe+wrPxxHDN5JKcpq4Hvl2Ik0/j0s8NCJzO9n38j/Qxaqcy0eek1v
         o+BbouFPkjthhYm3SdZNiA3K4rbQzCF6wIYxQZEUriiDLSedsJw0m6Zku6AylTJYKX6x
         BxDp4kee8SWXGn8Ngf7a46XiVQFGTqosF+OnKVJtieWXGDpJTJ5uau7woDJk4zo8v4C8
         f5J7D7dcsGJObKeWa3e4ZEQIFZfnyAuSBx1vv+bCx+QvbyHl3NBbt9WrfnqrpTyb6+hL
         2gtVrqTkiaWtf9+3GlZiEyATAwL5iF1/GNmfYoaZxH+Pys/ObI9cs474K8IUsV/83X/C
         BP2Q==
X-Gm-Message-State: AOAM531U9KW53AgtFF2BKcnFX5N6zj9KIbA8jTmMoTC8vawPQYllqHbj
        mBQOkA3jdp6mjtDc64zy1cpjpTsxytY=
X-Google-Smtp-Source: ABdhPJxG6nv8+8T8KUPO7M+ixLcUxNtlNgW3t7BvUr6P2lcHIOpVGOvb/g6nh9H1i5+uGLiQNqRkcw==
X-Received: by 2002:a17:906:284e:: with SMTP id s14mr5232882ejc.498.1594743484920;
        Tue, 14 Jul 2020 09:18:04 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id bw7sm12961348ejb.5.2020.07.14.09.18.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 09:18:04 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id a1so12393837edt.10
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 09:18:04 -0700 (PDT)
X-Received: by 2002:a2e:999a:: with SMTP id w26mr2613302lji.371.1594743064458;
 Tue, 14 Jul 2020 09:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <20200712215041.GA3644504@google.com> <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
 <20200714073306.kq4zikkphqje2yzb@box> <20200714160843.GA1685150@google.com>
In-Reply-To: <20200714160843.GA1685150@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Jul 2020 09:10:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjffJ=EBrLjsz=KUFyPXVQUO03L=VJmHnLhVr4XvT3Mpw@mail.gmail.com>
Message-ID: <CAHk-=wjffJ=EBrLjsz=KUFyPXVQUO03L=VJmHnLhVr4XvT3Mpw@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Joel Fernandes <joel@joelfernandes.org>
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

On Tue, Jul 14, 2020 at 9:08 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> I was thinking we should not call move_page_tables() with overlapping ranges
> at all, just to keep things simple.

No, we're not breaking the existing stack movement code just to keep
things simple.

The rule is "make it as simple as possible, but no simpler".

And "as possible" in the case of Linux means "no breaking of old
interfaces". The stack randomization movement most certainly counts.

                  Linus
