Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817A0382055
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhEPS2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 14:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhEPS2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 14:28:45 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608F1C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 11:27:29 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s25so4511918ljo.11
        for <stable@vger.kernel.org>; Sun, 16 May 2021 11:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUr+F139TDZByYjLXJsVttFSu60sbxHUTjnS2x2OfZc=;
        b=Z6QDJU4F2HoAzo1hUUpuBq8+y6o2jdqLAMITSyXeYCT8NjzSPy3WMk6L4zvqRySFYl
         7lui52+soPfGpAd3DLGYArs/IGFwEsD+TRHz959uVd+dAO5dQI+H65SqmNScfr09poJz
         ubnhOqcoDsblpKD4SbvgVfnvulwqk/5jye8V8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUr+F139TDZByYjLXJsVttFSu60sbxHUTjnS2x2OfZc=;
        b=ib+VKaxJeslwNxpn4GOQPkfBvORuCuXDaFZRYQI/ygN6JN1u13uWvBegZi6fXvnOgV
         eZi7+gC8/B4b3ICRqH4dqyn1gn5pGgHfnjSBbqmRxTTbf7lwwMNWfCR7B247wvA5EgIi
         y4RdeWcz/UekvbDGmii/9BM/vt2McdFh6C4LpmADqguVjC2ObSrUgXPkxoj1H/p9TLhp
         T1ar+N7J0wi+Pqy16JrOu1nNv9YjSxLm6LU6Dl4iI1bSQozfOaf+89tQZk/a5fipcpiw
         bVkQ29i7HKnRHZYaY4vdibpYn2hB9JZt4luhJANYpgX5enIjSAV0wcP4pjX0a4VFGLuD
         bCJA==
X-Gm-Message-State: AOAM532GglfVOoq3p0hDglFp/zsKjtqdU5TmTTUTlYGdcY3GWhRqA6b0
        OuaKEjd8IUQ+yCc0mkrC8K5dK4OQQRUKEuM5
X-Google-Smtp-Source: ABdhPJxmB0HwFvCyum2Qc36FmCfLQzH8Jvajcp1RYBCE3Mf6glTvbgko8NLWQ2RdU3jhcSVksskNaQ==
X-Received: by 2002:a2e:9b84:: with SMTP id z4mr24182959lji.341.1621189647328;
        Sun, 16 May 2021 11:27:27 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id y5sm1736716lfa.148.2021.05.16.11.27.26
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 11:27:26 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id o8so4594029ljp.0
        for <stable@vger.kernel.org>; Sun, 16 May 2021 11:27:26 -0700 (PDT)
X-Received: by 2002:a05:651c:1311:: with SMTP id u17mr44525442lja.48.1621189646059;
 Sun, 16 May 2021 11:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210516121844.2860628-1-willy@infradead.org> <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org>
In-Reply-To: <YKFi1hIBGLIQOHgc@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 16 May 2021 11:27:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
Message-ID: <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
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

On Sun, May 16, 2021 at 11:22 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> Nobody's been willing to guarantee that all 32-bit architectures keep the
> top 20 bits clear for their DMA addresses.  I've certainly seen hardware
> (maybe PA-RISC?  MIPS?) which uses the top few bits of the DMA address to
> indicate things like "coherent" or "bypasses IOMMU".  Rather than trying
> to find out, I thought this was the safer option.

Fair enough. I just find it somewhat odd.

But I still find this a bit ugly. Maybe we could just have made that
one sub-structure "__aligned(4)", and avoided this all, and let the
compiler generate the split load (or, more likely, just let the
compiler generate a regular load from an unaligned location).

IOW, just

                struct {        /* page_pool used by netstack */
                        /**
                         * @dma_addr: might require a 64-bit value even on
                         * 32-bit architectures.
                         */
                        dma_addr_t dma_addr;
                } __aligned((4));

without the magic shifting games?

              Linus
