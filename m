Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91DD386CD9
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238413AbhEQWUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 18:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhEQWUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 18:20:16 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B04C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:18:58 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s25so9100957ljo.11
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GLrELlliR95s8xq8ltsUwxg/SPX6TRc4gfTFH6EENtk=;
        b=AO+asyhK5fUYvs0AF4y1MOQ6MQ1c7UYRTYooVvqBrtc17ZJtDPkr6A39tQTuq5RKiY
         OarHqMyFq6QU6x0ukIEVV9/uwRInLcmoVQHf/dZxpBmIeO7e8Xz+foeFpLPDSqP7hyTB
         eaBPbaGVgAEPodBpQEHnSOvCxloxQ5tKFxZbM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GLrELlliR95s8xq8ltsUwxg/SPX6TRc4gfTFH6EENtk=;
        b=DFQzmtqd2Lmnpn9nBruJ/DNkxkUn+IX9PiSXQ1ClF7SV3NO0z26yU+vD0lJgvYFoyd
         4qWXerONmjBX06wgg2T0+diwc6QINXDjm6C8EfwNQTGz3E7KsgLKFciDewhPnDkOZj4H
         rKVjlJzJgZ6Ng62a40PsdBiTakR+GmpHSw6zLPr4weh3SMvtu5FDor0ChsCA2kZg01CS
         FlZGexQdrElNGXp6G5nDEZ2c94j9RQd9eU/UgeB4NdDjSg976P2cW9Fv6m3QuplE5lzL
         0dtPM0zq9zjx5VTA3lh8UqFVY744DLq87EO8uUoMOZuduerZGuW2+ZrzapE/U4EGfmyh
         VLGg==
X-Gm-Message-State: AOAM532jMYlLBlMwXnB05ZVNML4MVCOFWkqycz8d8xyamM9S6bobz6cW
        ut3IgoWhYXeEdo5L9ECvXV2h0+lKyVC328Zp
X-Google-Smtp-Source: ABdhPJwGuBjr54wROss8PGpwouOWuQwjr3c8bpMXwi14vGn0nifP4pcIfgX3DWuXyuNaZ7ozdHKpsg==
X-Received: by 2002:a2e:b61a:: with SMTP id r26mr1252187ljn.485.1621289936296;
        Mon, 17 May 2021 15:18:56 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id k5sm2123926lfu.0.2021.05.17.15.18.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 15:18:55 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id i9so11031147lfe.13
        for <stable@vger.kernel.org>; Mon, 17 May 2021 15:18:55 -0700 (PDT)
X-Received: by 2002:a19:ca15:: with SMTP id a21mr1364954lfg.487.1621289934906;
 Mon, 17 May 2021 15:18:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210516121844.2860628-1-willy@infradead.org> <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org> <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org> <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
 <YKHYFpyPcnwpetM5@casper.infradead.org>
In-Reply-To: <YKHYFpyPcnwpetM5@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 May 2021 15:18:38 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
Message-ID: <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
To:     Matthew Wilcox <willy@infradead.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 7:42 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Ah, if you just put one dummy word in front, then dma_addr_t overlaps with
> page->mapping, which used to be fine, but now we can map network queues
> to userspace, page->mapping has to be NULL.

Well, that's a problem in itself. We shouldn't have those kinds of
"oh, it uses one field from one union, and another field from
another".

At least that "low bit of the first word" thing is documented, but
this kind of "oh, it uses dma_addr from one union and mapping from
another" really needs to go away. Because that's just not acceptable.

So that network stack thing should just make the mapping thing explicit then.

Possibly by making mapping/index be the first fields (for both the
page cache and the page_pool thing) and then have the LRU list and the
dma_addr be after that?

> While I've got you on the subject of compound_head ... have you had a look
> at the folio work?  It decreases the number of calls to compound_head()
> by about 25%, as well as shrinking the (compiled size) of the kernel and
> laying the groundwork for supporting things like 32kB anonymous pages
> and adaptive page sizes in the page cache.  Andrew's a bit nervous of
> it, probably because it's such a large change.

I guess I need to take a look. Mind sending me another pointer to the series?

                Linus
