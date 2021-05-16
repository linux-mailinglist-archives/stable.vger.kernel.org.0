Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377E5382096
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 21:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhEPTYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 15:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhEPTYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 15:24:17 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B88C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 12:23:01 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id v5so4608328ljg.12
        for <stable@vger.kernel.org>; Sun, 16 May 2021 12:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKVgwmOVwBaZ8n3JxTnEWG0KlNYSEd+kYduhao9YLBo=;
        b=IdOat7WkacrZ8FwlM5PQRcmReJBYlueitXBWPRh3qbTL/r/fxhFOxEzaMbbvDZNv4Q
         PpLcvE2FgS5+le3kdQBVjZ0/vF0yun/uUqr8CLviYoPv6sD7GYvp41oglV3n4ZtF8QTd
         MDK+q6rsxPQx4d5hX97wb9OH2iiWZiYISnNcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QKVgwmOVwBaZ8n3JxTnEWG0KlNYSEd+kYduhao9YLBo=;
        b=JpVhswdGvqT6TvQBGbzYp9fscLI6VfH2QdB++MXrMgMxH42aaRH3Uj9/TZ2W9DqlVI
         bsuc6T+9x/BftLqPanV8RLcz4d3D3U/yFRRUxN3DLpGcN17Cie3lQjAIJkDG20JmKzSv
         WVfeg7/5pvFnT7Fj6bLP+DOvMtlm79PJD7uGnc03xnQaiB8u1sqiDK1Oxz7nIKY/eeW6
         Z3oXzDCzyJPD3RQf7OgKPUCi32sRFtBjbMmRU5NlJ89ZFxIDXC7yMH2A98dl+izHJ3mG
         pd8yOhOkAgZJoxN+tEAaoLt1edxVECP1kfb4qbfHzbLU+JrEOgYcqDaVP0aQCyB4caWO
         oNOQ==
X-Gm-Message-State: AOAM530Ilxwb4J78L11G893+hws0Mt8FxlHzwWGJ4NS/s/gR4UCgASED
        hN99zHhnQ9MbTpdyOL8mfE9F+3Dua+PE5E6v
X-Google-Smtp-Source: ABdhPJw+X3kneBpg9O4ZS/EheZK0zFWRZuWOKJuGCPd7PzdjcvvQ7cWzag6jWY+khMVI7wln2UGBGw==
X-Received: by 2002:a2e:9a18:: with SMTP id o24mr45687057lji.110.1621192979863;
        Sun, 16 May 2021 12:22:59 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id v14sm1737519lfo.76.2021.05.16.12.22.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 12:22:59 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id s25so4610272ljo.11
        for <stable@vger.kernel.org>; Sun, 16 May 2021 12:22:59 -0700 (PDT)
X-Received: by 2002:a2e:9251:: with SMTP id v17mr46089899ljg.507.1621192978848;
 Sun, 16 May 2021 12:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210516121844.2860628-1-willy@infradead.org> <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org> <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org>
In-Reply-To: <YKFt4Njj5au/JEhT@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 16 May 2021 12:22:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
Message-ID: <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
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

On Sun, May 16, 2021 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> That was the other problem fixed by this patch -- on big-endian 32-bit
> platforms with 64-bit dma_addr_t (mips, ppc), a DMA address with bit 32 set
> inadvertently sets the PageTail bit.  So we need to store the low bits
> in the first word, even on big-endian platforms.

Ouch. And yes, that would have shot down the "dma page frame number" model too.

Oh how I wish PageTail was in "flags". Yes, our compound_head() thing
is "clever", but it's a pain,

That said, that union entry is "5 words", so the dma_addr_t thing
could easily just have had a dummy word at the beginning.

          Linus
