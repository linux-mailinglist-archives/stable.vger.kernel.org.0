Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95443336A1
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 08:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbhCJHtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 02:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhCJHt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 02:49:28 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD71C061760
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 23:49:28 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id p16so16947686ioj.4
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nAmWx2KEyvwzUF+YbYDbLiK4iBYOe+fdbgAgbi/9hWE=;
        b=VrgHTnjdvrVZlvdxmmz/j5XVfeKy0Uq3iIoz2z/Kqo+9+BNwu7ecP+Pd/BL4bT531t
         V52aW0QYL4yJgWdyAerRr6MbYRF4/oL0YUvHLsc+7qJy0oFRa3NyBZ7xvZlNFRg9MOOs
         coDHEaZ+BNE8k34GsADAQx8XVH1GRexyikeK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nAmWx2KEyvwzUF+YbYDbLiK4iBYOe+fdbgAgbi/9hWE=;
        b=jnbfLhyxsBJmJFbadQoRqUvlJBWuBmS7h90Yjt+xmEE/oZV16hRQV8D3sRTFXkD2qU
         7eTRh5jFKWrcrMcgO2lcZuHVOdymtM0rhEa9p/NSLJ/xeOtuWsOz/7ZQloe5VT7nlI8s
         KTlOmr5IT9Smp04Z3ibXMRvfp5KieinefumbTZVUCqTdssr0ip1CaFDqyQuJIeO3Uslj
         ZP3mkPWRYVQJ6Hubyqq/5/Nc9GdDd3CwG8ViqqJjv0+TWBv7OXmm4wtiiHPFIu4BiWga
         ZniiKYZFUFUo/GbnK+4iW7LdT2hRxffhUNMiiBBDLQYugglDlVJCc9UaLtvthhcYjapA
         yYhQ==
X-Gm-Message-State: AOAM532SxV8y+I5EkSXW9wY3AY2jiI1WV+CCoAwX79DWzooajUAGMbAH
        pKRi63peZ2NJhYw9a3rg5XLwrIni5QAOapYg
X-Google-Smtp-Source: ABdhPJw8VpPcsHpZFkQQpUeuK1Z53tHAyFCT3hi+sZgETfg1gd7rllDJA3ixhH2V9C2g9o24/QXLww==
X-Received: by 2002:a05:6602:228f:: with SMTP id d15mr1427108iod.141.1615362567550;
        Tue, 09 Mar 2021 23:49:27 -0800 (PST)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com. [209.85.166.181])
        by smtp.gmail.com with ESMTPSA id h1sm1821102ilo.64.2021.03.09.23.49.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 23:49:27 -0800 (PST)
Received: by mail-il1-f181.google.com with SMTP id z9so14717489iln.1
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 23:49:27 -0800 (PST)
X-Received: by 2002:a05:6e02:1bca:: with SMTP id x10mr1633282ilv.71.1615362566563;
 Tue, 09 Mar 2021 23:49:26 -0800 (PST)
MIME-Version: 1.0
References: <20210310074028.1042475-1-ribalda@chromium.org> <48e8ffd7-7f42-8e22-bf9d-646d9bd89bd9@suse.cz>
In-Reply-To: <48e8ffd7-7f42-8e22-bf9d-646d9bd89bd9@suse.cz>
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 10 Mar 2021 08:49:15 +0100
X-Gmail-Original-Message-ID: <CANiDSCsMo7-PR2XVpw98cF9xBifedDgWbOMFxF8HhV3E9jRRDg@mail.gmail.com>
Message-ID: <CANiDSCsMo7-PR2XVpw98cF9xBifedDgWbOMFxF8HhV3E9jRRDg@mail.gmail.com>
Subject: Re: [PATCH] media: videobuf2: Fix integer overrun in vb2_mmap
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 8:47 AM Jiri Slaby <jslaby@suse.cz> wrote:
>
> On 10. 03. 21, 8:40, Ricardo Ribalda wrote:
> > The plane_length is an unsigned integer. So, if we have a size of
> > 0xffffffff bytes we incorrectly allocate 0 bytes instead of 1 << 32.
> >
> > Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Cc: stable@vger.kernel.org
> > Fixes: 7f8414594e47 ("[media] media: videobuf2: fix the length check for mmap")
> > Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> > ---
> >   drivers/media/common/videobuf2/videobuf2-core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index 543da515c761..876db5886867 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -2256,7 +2256,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
> >        * The buffer length was page_aligned at __vb2_buf_mem_alloc(),
> >        * so, we need to do the same here.
> >        */
> > -     length = PAGE_ALIGN(vb->planes[plane].length);
> > +     length = PAGE_ALIGN((unsigned int)vb->planes[plane].length);
>
> Hi,
>
> I fail to see how case from uint to uint helps -- IOW, did you mean ulong?

Ups... my bad :(

Let me send a v2

>
> regards,
> --
> js
> suse labs



-- 
Ricardo Ribalda
