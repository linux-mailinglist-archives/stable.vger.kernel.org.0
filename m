Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D393DC0CC
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 00:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhG3WG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 18:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhG3WG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 18:06:26 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75DDC06175F
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:06:19 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id l4so14420084ljq.4
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hRvMxRopOfk4wfDLGrvSeXWbdrziagZNRb9gSwqHbig=;
        b=fTtEbfGJErUIEPLddkT7tQyhajByiXgFt5iXayW/HiQx8Dz9DZMcdwPNxxqNYehVe7
         hJZPw2H7EiB5LE9kx1MOr25zYr/xlEHqZYCVytn+vE6iaIqTJ3K0bTNFYUZwOZUEOrj4
         o1BXtaR3EvlPz3z2x5EKHntoIKuG8VQ5rDkII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRvMxRopOfk4wfDLGrvSeXWbdrziagZNRb9gSwqHbig=;
        b=KfwkSnaM6JdsZOBE7h6GfwmqYKGIi3eIswGYsvD0TzSuIxrrc7MN+jf6IlK+4Acjz9
         PmFOkHvTmXOTQdbYscvKxArOZoLsH7PzFRAij9Vr58DOdMFsY+AWAF9qiiAw4wYwSpM1
         WybKsbBfG6lFIEJSNcoOtLLVaTjxvJ0aWLoeeahy0xD9TiDEFcmS4/Ve6kAqsHf6Kq7I
         0gEBg83+iRi0waNAQOhyoF9i93553ZjAFMZOlI/ixwCydIq5+tB2z2Orh1Gguc5Vub/R
         dqe785OpLkN03hIJlVMX5vxoi1RmvJmKW6g3QGgwAxrnPWOKQR/Lrk6qOwTDFL/vDx4Z
         WKnA==
X-Gm-Message-State: AOAM533SF/HtCyuACyqHqgmF3RMQbGlXH/e8rUwWJRu3yeafC0aFeMDG
        vmWlYvn98MvA49LUcvx6hB7eZXhWMczJ5xIZSJM=
X-Google-Smtp-Source: ABdhPJz7siYAnd8SEdy1pb8DbVVHcvRX2sZcA1fo1WIO2ATX73y5IjF5vCRgHCBAXrVpqGFPzsVDow==
X-Received: by 2002:a05:651c:245:: with SMTP id x5mr3160172ljn.92.1627682777879;
        Fri, 30 Jul 2021 15:06:17 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id v20sm247327lfo.158.2021.07.30.15.06.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 15:06:16 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id a26so20617597lfr.11
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 15:06:16 -0700 (PDT)
X-Received: by 2002:ac2:4475:: with SMTP id y21mr3384042lfl.487.1627682776227;
 Fri, 30 Jul 2021 15:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210729222635.2937453-1-sspatil@android.com> <20210729222635.2937453-2-sspatil@android.com>
 <CAHk-=wh-DWvsFykwAy6uwyv24nasJ39d7SHT+15x+xEXBtSm_Q@mail.gmail.com>
 <cee514d6-8551-8838-6d61-098d04e226ca@android.com> <CAHk-=wjStQurUzSAPVajL6Rj=CaPuSSgwaMO=0FJzFvSD66ACw@mail.gmail.com>
 <b1688f32-cb0e-04e1-3c91-aa8cddbcf41d@android.com>
In-Reply-To: <b1688f32-cb0e-04e1-3c91-aa8cddbcf41d@android.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 30 Jul 2021 15:06:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=witY33b-vqqp=ApqyoFDpx9p+n4PwG9N-TvF8bq7-tsHw@mail.gmail.com>
Message-ID: <CAHk-=witY33b-vqqp=ApqyoFDpx9p+n4PwG9N-TvF8bq7-tsHw@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs: pipe: wakeup readers everytime new data written
 is to pipe
To:     Sandeep Patil <sspatil@android.com>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 30, 2021 at 12:47 PM Sandeep Patil <sspatil@android.com> wrote:
>
> aren't we supposed to wakeup on each write in level-triggered (default)
> case though?

No.

The thing about level triggered is that if the condition was already
true, it would not need a wakeup in the first place.

Put another way: select() and poll() are both fundamentally
level-triggered. If the condition was already true, they will return
success immediately, and don't need any extraneous wakeups.

This is literally an epoll() confusion about what an "edge" is.

An edge is not "somebody wrote more data". An edge is "there was no
data, now there is data".

And a level triggered event is *also* not "somebody wrote more data".
A level-triggered signal is simply "there is data".

Notice how neither edge nor level are about "more data". One is about
the edge of "no data" -> "some data", and the other is just a "data is
available".

Sadly, it seems that our old "we'll wake things up whether needed or
not" implementation ended up being something that people thought was
edge-triggered semantics.

But we have the policy that regressions aren't about documentation or
even sane behavior.

Regressions are about whether a user application broke in a noticeable way.

                     Linus
