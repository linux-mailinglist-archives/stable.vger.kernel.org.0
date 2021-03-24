Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004E7347EF2
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 18:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237425AbhCXRLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 13:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbhCXRKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 13:10:24 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7465EC0613E9
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 10:09:21 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b83so33073830lfd.11
        for <stable@vger.kernel.org>; Wed, 24 Mar 2021 10:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oPHlCBeoTk7E8H/kSVNwXw422z7kCWrhvuSAS7d04P0=;
        b=hG8wb808KgTJ8d36OZqVidKXA8X92CDYQPiYJoiKoGymUuEafG/24ceYlNZyhil4g0
         qDUe/oX7kJulpDI44EcQGWKx+OTDyy3UeS1twGlkgUkNgbQ8toA2dRfPoDhbnLliJBT+
         o0XbAXk+l6JAvvyFVVriJPMppH3sO//Bav781RoeNMS1EOZMl0kvuIx5ApAe/tkdAWiw
         UltKiUeoZIRSfkLrDV801/Fw1XP5sxx+wNMAzO4vmC7+xjETdUUh23J96XRjLaentmH6
         Q41keIxVtD/9uub7/YbN3J1uXX/p8NVumTw9GG6HOiDSOP75yaojKfz/WXg1W1Jd5STq
         laWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oPHlCBeoTk7E8H/kSVNwXw422z7kCWrhvuSAS7d04P0=;
        b=pc643hQKj73e7Rq0RBFHjkOiNoTGKZ4gAQfSFqdw3B+RgGSbycvcypVcaKFFvfgeiU
         EQTXMzCUkf+BRTrXfioyV3hY6B9feAtz8icKzO1iv5/CXANrh8bXip1ffXq8BVIpL6Fi
         0rkwbjdwm6FInd4URTJAXqC6n5UcoSYylywJwCimP7Suu/44+YNlXlVU5SeF68wlMKq1
         O4Q3GGEqTUK2TZM09sQ87b3i0BcopQSOM7xFFLQqfoWU9AjWmpL/0OSimtjnLkuZvakQ
         SGXJGYyaQHMuxz19dp6spdqeL+5R6IJjcqAUxUXziSnX0wYUAoSExKHfCmg0kBeX3t3f
         8yVQ==
X-Gm-Message-State: AOAM531mcaDkZRxqIq8XNLJnrdVbkO4a7PtcYGvgKyqsm/e4v0xXA8GZ
        3eggUj2HT8tbc7XNelBhZpqjxPaiYXIq9+RsT6ytDg==
X-Google-Smtp-Source: ABdhPJwID7IJtfBNhXzib0KyOxepSDzyEJLsFyGuqoUuGRwCKFP3HQIVKP1Pdo2hIQjphvp4ZZnL90+r91uWABevRxk=
X-Received: by 2002:a19:430e:: with SMTP id q14mr2698537lfa.374.1616605759753;
 Wed, 24 Mar 2021 10:09:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdmCpMf1Zp3tB=oqse6-Bsm_ybJQ=G5h__kEuOa47CjBHg@mail.gmail.com>
 <YFtxnlHk4TLqtP5z@kroah.com>
In-Reply-To: <YFtxnlHk4TLqtP5z@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 24 Mar 2021 10:09:08 -0700
Message-ID: <CAKwvOd=2k_NaC1U9MwNHzfCHAfhwi55fyoTa+AHFM=drh9d3Ng@mail.gmail.com>
Subject: Re: please pick 552546366a30 to 5.4.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        =?UTF-8?B?TWlsZXMgQ2hlbiAo6Zmz5rCR5qi6KQ==?= 
        <miles.chen@mediatek.com>, mike.kravetz@oracle.com,
        Nathan Chancellor <nathan@kernel.org>, dbueso@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 10:06 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 24, 2021 at 09:47:49AM -0700, Nick Desaulniers wrote:
> > Dear stable kernel maintainers,
> > Please consider cherry-picking
> > commit 552546366a30 ("hugetlbfs: hugetlb_fault_mutex_hash() cleanup")
> > to linux-5.4.y.  It first landed in v5.5-rc1 and fixes an instance of
> > the warning -Wsizeof-array-div.
>
> What shows that warning?  I don't see it here with my gcc builds :)

$ make LLVM=1 -j72 defconfig
$ ./scripts/config -e CONFIG_HUGETLBFS
$ make LLVM=1 -j72 mm/hugetlb.o
...
  CC      mm/hugetlb.o
mm/hugetlb.c:4159:40: warning: expression does not compute the number
of elements in this array; element type is 'unsigned long', not 'u32'
(aka 'unsigned int') [-Wsizeof-array-div]
        hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
                                          ~~~ ^
mm/hugetlb.c:4153:16: note: array 'key' declared here
        unsigned long key[2];
                      ^
mm/hugetlb.c:4159:40: note: place parentheses around the 'sizeof(u32)'
expression to silence this warning
        hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
                                              ^
-- 
Thanks,
~Nick Desaulniers
