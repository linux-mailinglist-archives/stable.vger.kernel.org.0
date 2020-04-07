Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B981A167A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDGUHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 16:07:11 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41571 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgDGUHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:07:11 -0400
Received: by mail-lj1-f196.google.com with SMTP id n17so5151690lji.8
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xaDI5WZ+Tw5wjkiaUfXulkJabdKkJCvfWkIGtDYsvdM=;
        b=KOYHiHylGotp6u4EirtYoIpBrCpGxl+xmn9mgypeQsxKVqfZv1mwuWYQvivt5kYnrL
         d7NNizemEINPjNMrBZYLYfxUCE+cpeWbWVBtGBLTo1176F+IOOEN9uY35VV4GPfXK+/F
         QJSC4air0ca5DjIKJ6AE2E28LQZZN4daqXwp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xaDI5WZ+Tw5wjkiaUfXulkJabdKkJCvfWkIGtDYsvdM=;
        b=G5R5636YaNX6HSrgpcCiMRX78LdPW/WPU72hu09CHfTSSKclViF5//AViJV9hkHHRU
         4jck4zx/Eb4IibB87h177b9sqz6EZDtsoKkzp6SG2ID8HoKBPKxP58ywtIW0Dk86/Wwf
         Bzwmfi298IL96q+IyX2rNU0E/o9KNuLaf1D49XV7U/CV+03V1mMI6Mo8zglMy3+KQZx5
         ayHBTwcpgLwaPi28qUd8ergFe63hn4NRWqWoKUOoV/pxOuBC+ML/J4Dk8a3xI1lo8BOB
         AY8FpZoMPSdR2emVYdVET4SP+9IyWmNpzFvSWEPUeTDZ7NX4g6uvVocpbPAxECdAYWBb
         KkMg==
X-Gm-Message-State: AGi0Puan0nsogl2q/9pl30+yeiu6wcSvMXSVBXxHPttG2DRrWrTb5jmx
        fKKKBvhKD8d31KkLTTBeuOJ9Nnq6INc=
X-Google-Smtp-Source: APiQypKwrra0jVlFc8xlvZ134m5zNLxUekBIj7+Vhj0geHyreHZa9tAyPYUz5IF6TYWwyyhMbScrDw==
X-Received: by 2002:a2e:81c9:: with SMTP id s9mr2730694ljg.69.1586290026644;
        Tue, 07 Apr 2020 13:07:06 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id c4sm13789152lfm.37.2020.04.07.13.07.05
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 13:07:05 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id h6so3423159lfc.0
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:07:05 -0700 (PDT)
X-Received: by 2002:ac2:4466:: with SMTP id y6mr2462517lfl.125.1586290024968;
 Tue, 07 Apr 2020 13:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
 <20200407031042.8o-fYMox-%akpm@linux-foundation.org> <CAHk-=wi1h-wBC3Kg2qBhs_R1UGyocGq0cT1eO+12pwBsO+d1ww@mail.gmail.com>
 <158627540139.8918.10102358634447361335@build.alporthouse.com>
 <CAHk-=wjTmay+NhnZ5Q+GM9buDioT0ie8njJgcquTFGD_qQhXpw@mail.gmail.com>
 <158628265081.8918.1825514020221532657@build.alporthouse.com> <CAHk-=wj84K2AZNA-qc5DdCo2zUQiSOTK0DOf02KYgPOhw2-DDQ@mail.gmail.com>
In-Reply-To: <CAHk-=wj84K2AZNA-qc5DdCo2zUQiSOTK0DOf02KYgPOhw2-DDQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 Apr 2020 13:06:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgutu+KpwyMDHk1FRasaB_R4UXP7pHxpA4rfY_er553Rg@mail.gmail.com>
Message-ID: <CAHk-=wgutu+KpwyMDHk1FRasaB_R4UXP7pHxpA4rfY_er553Rg@mail.gmail.com>
Subject: Re: [patch 125/166] lib/list: prevent compiler reloads inside 'safe'
 list iteration
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Laight <David.Laight@aculab.com>,
        Marco Elver <elver@google.com>, Linux-MM <linux-mm@kvack.org>,
        Mark Rutland <mark.rutland@arm.com>,
        mm-commits@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 7, 2020 at 1:04 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> You may be relying on some very subtle consistency guarantee that is
> true on x86. For example, x86 does guarantee "causality".
>
> Not everybody else does that.

It's worth noting that maybe for the i915 driver it makes sense to
just assume x86 memory ordering.

But even if that's the case, then it doesn't make sense to change
list_prev_entry_safe() anywhere else.

                 Linus
