Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90C2409E05
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243310AbhIMURS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243330AbhIMURR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 16:17:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92045C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:16:01 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id q3so16190671edt.5
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=146IDoLHsnlYB84TPDL7kqzW39fi+lkR3958WvJksNU=;
        b=gyRS8gjhHVDEJW3sWIFVBpPRc2KEVEPHvvR30CLnqsK+D0Cdnc2iMmALs9/mMesYTx
         DWIkQLMkgDI0IL1b4WvgD65bkxCoJcXYobVOE4MVrZsCt0d4JU3u0ngT8fARn6axUyBf
         W1N+PxcICKOZsZfThMM7E97Qm8F9LSOpst2ww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=146IDoLHsnlYB84TPDL7kqzW39fi+lkR3958WvJksNU=;
        b=s5BziZQXdDNCJDXPXQBIP3gTF4d/0gQ7u5VZ5Kctmu8ariqA6E1rMffHgcO+UmG1Oa
         ZG7SjtYlYLp79aTMg19lLnhYHLYSxZWne4Le9K9+QKDD4WjbN5dI4VXDQITC2eQ9R9qb
         iVxl1H3iguFqs5I+wvXw+PDKRQ5lx2OKIglgzCsAkQKvkPiw6/vpRUJBYalieYD611q0
         fvcGzZAp51XtlJtr+xAuMNhscMnIjDlwTnTrVikNjICg51POn/YA07PQ8kIu1XvJ9KYE
         osTy1OupUB3cSQAzLlelOdmx7v2znwx+sn1g09zp6YdGb3D9e7slP7Wa6mgqgyROcz+2
         gRpQ==
X-Gm-Message-State: AOAM530Pcdf9rXkpjyVo7nsCNthCqkYn2BYtp8ofLVavK7IVD71YbFFM
        4F0pHEA6LU4nYP/SOEQw76xPei/XiFM5bTFTRp8=
X-Google-Smtp-Source: ABdhPJyL8P0g2EJg7f4bBZTxMZkILgp/tKLcvJQWBVdjtyqPB+ir4pu/9uKYw/niDMzwC+X8ZvNXyQ==
X-Received: by 2002:aa7:dbd2:: with SMTP id v18mr4028125edt.315.1631564160027;
        Mon, 13 Sep 2021 13:16:00 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id o3sm3892386eju.123.2021.09.13.13.15.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 13:15:59 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id kt8so23647911ejb.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 13:15:59 -0700 (PDT)
X-Received: by 2002:a2e:1542:: with SMTP id 2mr12239121ljv.249.1631563837811;
 Mon, 13 Sep 2021 13:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210913131113.390368911@linuxfoundation.org> <20210913131114.028340332@linuxfoundation.org>
 <CA+G9fYtdPnwf+fi4Oyxng65pWjW9ujZ7dd2Z-EEEHyJimNHN6g@mail.gmail.com>
 <YT+RKemKfg6GFq0S@kroah.com> <CAKwvOdmOAKTkgFK4Oke1SFGR_NxNqXe-buj1uyDgwZ4JdnP2Vg@mail.gmail.com>
 <CAKwvOdmCS5Q7AzUL5nziYVU7RrtRjoE9JjOXfVBWagO1Bzbsew@mail.gmail.com>
 <CA+icZUVuRaMs=bx775gDF88_xzy8LFkBA5xaK21hFDeYvgo12A@mail.gmail.com> <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
In-Reply-To: <CAKwvOdmN3nQe8aL=jUwi0nGXzYQGic=NA2o40Q=yeHeafSsS3g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 13 Sep 2021 13:10:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
Message-ID: <CAHk-=whwREzjT7=OSi5=qqOkQsvMkCOYVhyKQ5t8Rdq4bBEzuw@mail.gmail.com>
Subject: Re: [PATCH 5.14 018/334] nbd: add the check to prevent overflow in __nbd_ioctl()
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Baokun Li <libaokun1@huawei.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        lkft-triage@lists.linaro.org, llvm@lists.linux.dev,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 1:02 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Ha! I pulled+rebased and this code disappeared...I thought I had
> rebased on the wrong branch or committed work to master accidentally.
> Patch to stable-only inbound.

Side note: for stable, can you look into using _Generic() instead of
__builtin_choose_expression() with typeof, or some
__builtin_types_compatible_p() magic?

Yes, yes, we use __builtin_choose_expression() elsewhere, but we've
started using _Generic(), and it's really the more natural model - in
addition to being the standard C one.

Of course, there may be some reason why _Generic() doesn't work, but
it _is_ the natural fit for any "for type X, do Y" kind of thing.

No?

          Linus
