Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB41321FAB4
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgGNSy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729973AbgGNSy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 14:54:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5BBC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:54:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id rk21so23891978ejb.2
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Alox4jKEMRaA950HZ1waP0+wedXfzVsNihjzfohVQYc=;
        b=VvlDJH5CSlxwkIB6dqeYM9fELFt2NoQrAo8WwW52hkqyP+QEgrAcfi37PxvMFQ3jXz
         exscy1cS5CvqO0N4kUSCglH47nIFT7m+TmAko7nxgzLwvs9rvLlklibVS3y9Lb+KsOEb
         7GJJwIeCsAlMivcZbPoiCqejNh8PNrAxOIO3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Alox4jKEMRaA950HZ1waP0+wedXfzVsNihjzfohVQYc=;
        b=agxu/8EvHmR22hahtq5mIjleNjPyqDuiKcNRBUDlUW2dkxt8VtR2ZhPxcx9Ju4nZVE
         IKMmyckRJHeyiiQX6bCYWv7xJpA8k5A0DZFOlDGzQyh3fK/jRJHFRcKZfcNBuWKK4atR
         YbbyVyjzpfqRv0XIH+TYsUvbHKhm3jWDOVyDQjDzz6G/yK1dyVnvhfn4uSq/2F+/WsvL
         iOdX3vIE9NZ/UEf2QiRltwJqoCGGMtnLtuA4ZlhPKq2WtL0bhvvWlbpI6md3v7oEXeoD
         oOqmfU8i8JvovbvwcNdXsjUqOT1UbqiJRD5tE0/B4/6myFVlD9rWcJktkERF1RgLxnqJ
         m7cQ==
X-Gm-Message-State: AOAM532ypAlXYb1ThyJz5Xz68J4H1uhyHyWffhwgEbrAX+tg/Yu0PFiT
        +Rt0nKnCMec8tkC5X4nzau5TYcqHFsw=
X-Google-Smtp-Source: ABdhPJwHnvefJbtT/7c9AcWRl2hCUtwKUAVzus0YTYcBs3i6h6XCinU12VZKH81kxxi2jXC529tyPA==
X-Received: by 2002:a17:906:3ac4:: with SMTP id z4mr5501300ejd.65.1594752896974;
        Tue, 14 Jul 2020 11:54:56 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id d23sm13196799eja.27.2020.07.14.11.54.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 11:54:56 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id k6so24145531wrn.3
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:54:56 -0700 (PDT)
X-Received: by 2002:a2e:86c4:: with SMTP id n4mr3097947ljj.312.1594752576542;
 Tue, 14 Jul 2020 11:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
 <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
 <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
 <20200712215041.GA3644504@google.com> <CAHk-=whxP0Gj70pJN5R7Qec4qjrGr+G9Ex7FJi7=_fPcdQ2ocQ@mail.gmail.com>
 <20200714073306.kq4zikkphqje2yzb@box> <20200714160843.GA1685150@google.com>
 <CAHk-=wjffJ=EBrLjsz=KUFyPXVQUO03L=VJmHnLhVr4XvT3Mpw@mail.gmail.com> <CAEXW_YRTnCb-z6TeboA3OCYv8eoX8UiCNn7K1hGMX+41Zdz8Og@mail.gmail.com>
In-Reply-To: <CAEXW_YRTnCb-z6TeboA3OCYv8eoX8UiCNn7K1hGMX+41Zdz8Og@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Jul 2020 11:49:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgRS_WpRdC9nyXzVZ7aWNQt0HKMbyFjhrgrNo49AFNWzg@mail.gmail.com>
Message-ID: <CAHk-=wgRS_WpRdC9nyXzVZ7aWNQt0HKMbyFjhrgrNo49AFNWzg@mail.gmail.com>
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

On Tue, Jul 14, 2020 at 11:12 AM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> I think you misunderstood me. I was not advocating breaking the stack
> movement code or breaking stack randomization, I was going to try to
> see if I could keep that working while not having to do an overlapping
> move.

I'm not really seeing how you'd do that with a big stack that gets
close to the stack ulimit.

Except by avoiding randomization.

But the existing randomization may be so bad that it doesn't much
matter. And I do think we limit the execve stack to a reasonably small
fraction of the whole ulimit. So worth exploring, I guess.

The current code with "align_stack" doing randomization could also do
with a lot of clarifications. The code is odd.

            Linus
