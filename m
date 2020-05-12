Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2C61CE97D
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 02:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgELAJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 20:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728309AbgELAJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 20:09:41 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59FEC061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 17:09:39 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c21so4426266lfb.3
        for <stable@vger.kernel.org>; Mon, 11 May 2020 17:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B+GIuNeS/zRhNXv8DWJcBs5sdIAbLbnMHoFTqitLrys=;
        b=Ak93banedsJMiV/GLzQObSSQW5MNVGozwtSadLdbb2llutUOeMawnVzTXwPyZMhdn5
         zotibDunSZiYNCo1pURopX//M2oItuHBRSCOe5QbWLnCSD0k+LJAL7kMlmILXXDpJpO1
         SUoeWuk79IlnBSAlPr/pRc1vZh5tqtqot+UYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B+GIuNeS/zRhNXv8DWJcBs5sdIAbLbnMHoFTqitLrys=;
        b=phlc36+OF8VLaF3Yg5tgeG3S+fJiH3bjBgbF3DQBx8Vh7gMQy1lRharqFQB0KALZeR
         7OMoK7NS3lhTpvthse+hu3DRlfDBA8lGaoiM7twhY50zjJbUZMgxpHtsy0rtaTcBh8ai
         yS2Beam2eGGOhz/HIG2spbcLpFavvRbjqSJCorn9k5z3Ute46XFeK7amBZArPpJlvM5U
         IGoXds1QM6zcpp46RyghVqeORCmVmL6j6dAg9z8PzWk7Vm6rznfQ9B7abfxebocHu1uY
         cTA8vrcoofH4Ec0FjsFTEtQ9DIRVFfe0H9DZ1EvTNL82Pp+KMYgUo9HAJP2OUhBlKAx/
         ui4w==
X-Gm-Message-State: AOAM531Fc1aIwc2FRYyka0YQIDLZBp7Co6d9kqWXC/wWNIXHva+FeiLX
        qzqCRztRbhtSCXxCFwdSk+KfZZQqK5o=
X-Google-Smtp-Source: ABdhPJzoetYS5jv0FwE9C9QdYQTAEaDVjJlcH8cmP2ind66FZhaHo/VGFFkpqxnVHadZqOlg5aR3lA==
X-Received: by 2002:ac2:4a6b:: with SMTP id q11mr6360515lfp.71.1589242177848;
        Mon, 11 May 2020 17:09:37 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id h28sm12507051lfe.80.2020.05.11.17.09.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 17:09:37 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id e25so11582855ljg.5
        for <stable@vger.kernel.org>; Mon, 11 May 2020 17:09:36 -0700 (PDT)
X-Received: by 2002:a2e:9a54:: with SMTP id k20mr12584970ljj.265.1589242176533;
 Mon, 11 May 2020 17:09:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200508090202.7s3kcqpvpxx32syu@butterfly.localdomain>
 <20200511215720.303181-1-Jason@zx2c4.com> <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
In-Reply-To: <CAHk-=wi87j=wj0ijkYZ3WoPVkZ9Fq1U2bLnQ66nk425B5kW0Cw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 11 May 2020 17:09:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wioWmE+Xy+RfVpc3q9EMh4NhqPVvWZp5=GqtoU6nZfxcA@mail.gmail.com>
Message-ID: <CAHk-=wioWmE+Xy+RfVpc3q9EMh4NhqPVvWZp5=GqtoU6nZfxcA@mail.gmail.com>
Subject: Re: [PATCH v2] Kconfig: default to CC_OPTIMIZE_FOR_PERFORMANCE_O3 for
 gcc >= 10
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 11, 2020 at 5:04 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Not inlining as aggressively is not necessarily a bad thing. It can
> be, of course. But I've actually also done gcc bugreports about gcc
> inlining too much, and generating _worse_ code as a result (ie
> inlinging things that were behind an "if (unlikely())" test, and
> causing the likely path to grow a stack fram and stack spills as a
> result).

In case people care, the bugzilla case I mentioned is this one:

    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=49194

with example code on why it's actively wrong to inline.

Obviously, in the kernel, we can fix the obvious cases with "noinline"
and "always_inline", but those take care of the outliers.  Having a
compiler that does reasonably well by default is a good thing, and
that very much includes *not* inlining mindlessly.

                  Linus
