Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7345C2B5E96
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgKQLrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgKQLrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 06:47:52 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80696C0613CF
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 03:47:50 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id i193so18674428yba.1
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 03:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ygoOCND1uteBbX6OuvT0PDLFD+vd1u8WBqWcrayFaj8=;
        b=r13MarwZI7MzbaKXKU+pf5+8JzLCzYLnsgiaC2CXsNFF/+wpflHtjYNeSxRkqeWC4o
         hFBu1pmXZQVnjE9Ppz2xQL3vUq03oivGg7k9VvSKy86WhZwJEiPMNmIYpL27cGnQGZpj
         kXo8zJDPuPj8u4X6KOBjTU6Hk/JSvcZ1tMlkI/zkMYRYf61mmhAA9FGXiCAfYpHW65lS
         Y9v85UMiy/H+vloFIKx0zi7deRacA6b7rUdkoLghJ7Rrl0AQs0JdxjX3jZMzIqXCTSZN
         oJJeafJGTv2G2ykzFmnCAuwigpUORRFRqVfqSHRKeYNhWIrIQltOT1X7GmCpr8b5P/o+
         YY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ygoOCND1uteBbX6OuvT0PDLFD+vd1u8WBqWcrayFaj8=;
        b=YoQnWIvazjx1avg+PRQlBAtN9gJj2w5qFhk2If+wCZxHCZnG4KTOB3Rx1C3skkh8/j
         seRZmLTMZMS6sLlolDUeNkNLx7jFcVU76MoT5WKiN5ymLLaF0URCXv4VUcUpxxMN14fH
         fBLZ7SH4nlQAju7xodDo79uqkkMmcoWX3fzEYmzk7O1AeNI3xBnNKFRLCs2j8Vnl9xVH
         c+7+WM3gTcJ9qmO2oW56vAx53AdcNdGsmJgSlg3toleC/pjjnzapVfzZ9Lt35oD2aCyY
         qunbiakFQ/q3ZWwUHON9eejw08fhNWcgWax9yX/kOamkrYEO6LCHDWgJ9NW1uqnYu3Xk
         MypQ==
X-Gm-Message-State: AOAM531HfYHy5SMsQ2Zgjs9xTctIid+RXqKHUk01NVW9v8rp/gv0jh7H
        IETYVVPJie9hikazKtieiW4EMMcKdZi+QD2iAm0=
X-Google-Smtp-Source: ABdhPJxpl6V4pWHGqOmxmn/z2DwEI1W2uerprPwl79Bifo2lFpybdD/NTlgzPpATsn+nW+s3lkz2H3i5kgx6vZB8Q40=
X-Received: by 2002:a25:209:: with SMTP id 9mr33472705ybc.127.1605613669731;
 Tue, 17 Nov 2020 03:47:49 -0800 (PST)
MIME-Version: 1.0
References: <20201112133112.w3z6vyq5m5p7aowx@debian> <X7OynckqadusPjk2@kroah.com>
In-Reply-To: <X7OynckqadusPjk2@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 17 Nov 2020 11:47:13 +0000
Message-ID: <CADVatmM6nQuKJ4c2nx4iQjwy8aQAYCW3YnfCy43GgFkgcV=-+A@mail.gmail.com>
Subject: Re: [v4.9.y] backport of few missed perf fixes
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        kiyin@tencent.com, Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Nov 17, 2020 at 11:22 AM Greg KH <gregkh@linuxfoundation.org> wrote=
:
>
> On Thu, Nov 12, 2020 at 01:31:12PM +0000, Sudip Mukherjee wrote:
> > Hi Greg, Sasha,
> >
> > These are few missing commits for stable v4.9.y branch.
>
> <snip>
>
> >
> > Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
> > Signed-off-by: "kiyin(=E5=B0=B9=E4=BA=AE)" <kiyin@tencent.com>
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Cc: "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
> > Cc: Anthony Liguori <aliguori@amazon.com>
> > --
> >  kernel/events/core.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> >
> > [sudip: Backported to 4.9: adjust context]
> > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > ---
> >  kernel/events/core.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
>
> Odd way to add your s-o-b :)

Yeah, I know. :(

But the file changed line before my s-o-b was part of the original
commit message, and so I had to add the s-o-b after that to preserve
the original message.


--
Regards
Sudip
