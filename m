Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA5E3571F7
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 18:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344805AbhDGQPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 12:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhDGQPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 12:15:06 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC522C061756
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 09:14:54 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id o126so29517552lfa.0
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 09:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+GZihE1qWi22Nq3Hnh+PiXEp0mKLQ2A+oFFp9yIals=;
        b=J99hjckmBosLPM9Ed+eK2wWObnFsiBDrZ0ii/IRGS7ALFw6ItbZ+BG7zbtuYs/4LnK
         wNs84LO7gQTNKl4wDVOdHkZp+yR4/UEsTJpB38wAD4VDL1fltxcsnkSToDxC23/kkkMO
         cxUD93e3l2f0ypdrY08/2frZV3aQ/27xDphVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+GZihE1qWi22Nq3Hnh+PiXEp0mKLQ2A+oFFp9yIals=;
        b=qCdyZ1enmgLUr3PWmbdHIKYkzgge0VHXxo3JSnDhngQ2H8WLl69cTFkdUOm7oKripH
         7m/34CeAb+VMuG3spCop1S/e7qOxaJv56ZBDOoV7eBAP6VWarfLpzXqpl0tDL00LAQCz
         eXWRwstYwgZkA0/btT0QX4n4dAG9adQ08GerRXBNq6yHS5PGNmesRUqXZoBn+2rGTi41
         bOusLJYZzPIjkpf1QnZya6DE7O9W2B/fyIIH10h5Lg1YeWnFhpprYBismg5d2gNw1pHQ
         5Rxt68g1xl2HkbPUYgbo5L7YAK1A7vP2lAdZ3oQXguMVZNDBMuEC35RUQWDjjPiBZyMI
         34Tw==
X-Gm-Message-State: AOAM530KA6cH9bxA+DF/Gk20actgWE7w20hjVVgMgu5e6LfM7QI9V+dw
        GTl4fvzpVcf1w6fCSMkAqpnfOuoHmh19puxE
X-Google-Smtp-Source: ABdhPJyZ+DB2gckmN6fkdgG+c1znVjn5H39IMJi/JnjJ5CzDi0nk1lky1NnnfK5tJ9Wc6WllVK0sLw==
X-Received: by 2002:a05:6512:3d04:: with SMTP id d4mr3021051lfv.102.1617812093363;
        Wed, 07 Apr 2021 09:14:53 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id o9sm409708lfb.280.2021.04.07.09.14.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 09:14:53 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id w28so29373341lfn.2
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 09:14:53 -0700 (PDT)
X-Received: by 2002:a2e:9bd0:: with SMTP id w16mr2540948ljj.465.1617811653798;
 Wed, 07 Apr 2021 09:07:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
In-Reply-To: <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 7 Apr 2021 09:07:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
Message-ID: <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 7, 2021 at 6:22 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> 1) Ignore the issue (outside of Android at least). The security model of zygote
> is unusual. Where else a parent of fork() doesn't trust the child, which is the
> same binary?

Agreed. I think this is basically an android-only issue (with
_possibly_ some impact on crazy "pin-and-fork" loads), and doesn't
necessarily merit a backport at all.

If Android people insist on using very old kernels, knowing that they
do things that are questionable with those old kernels, at some point
it's just _their_ problem.

                 Linus
