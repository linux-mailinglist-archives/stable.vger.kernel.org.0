Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD5E55A94B
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 13:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbiFYLR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 07:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiFYLRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 07:17:25 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C679C31DDA
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 04:17:23 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3176b6ed923so46026547b3.11
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 04:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uiCn1wFahqAtSkOl35HmuzXqqUxjUEsg3PyPjnfHW9E=;
        b=3iCOnxC63zzWpEYXppJeaYfZNRtna889N688tU51Fz05zWDXd5qsW086aNb9+MwdJv
         O9EyqixJTnJa8+XS33NPHFlTPra87Yh3ffe2oDLnQiJLBi2R3Vd38kWvw9iGVRTv92+3
         LCEa3bFWRvLtfE/G8Hwknjj9IHh3hswmvsfFnbDG296N5regN/oIcPmqNRjlFXUARSIe
         kj9Q7PaPTaG5bVoYZbf8DHg0J/oRGOwIXWfNGVQmoFx98yuwo48VgRe3N2GRGx4KedLq
         ZcsbEmXYQaQF4cRtK7tpUvGlk1uXjKwda6GoKRmyLyoHRGI0fHKUsy2xipFdKbzqWmfa
         /QrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uiCn1wFahqAtSkOl35HmuzXqqUxjUEsg3PyPjnfHW9E=;
        b=KVqh7f/KzPegBAxqvOPTHFiKUJItRadH7Ua8CCDzb05PxE5mxBakWNBWGaeujjdVgZ
         3RSsB9GiGxswCcRplQ+MFOIl51bI+oP+E0NTttROUAI0NmgSbWXO2wIE3uVPXRp9jUfb
         maceGIcCoKazQ3kXusL2ht0UVNklW3fLWHoxwwT7MHEKxt7/3iewfxAeDNyJN9c2yWke
         9CluswdB6up3cn3f3S3kHQSpLix4PpKMSNok6ZzveDl733KDTh4ClQlAiEsagFteQXHE
         MHQaERtsy6OngrtCYnQo5zNP/ftkXcpEfII7QTdgDBiQqe5njppNw6ukzTEhJ+ZamgfO
         nOCg==
X-Gm-Message-State: AJIora//B1XkiLw2o2kldncvAbBV671Q8OzaCTZbl+x0VFqiqajS1Mdn
        Qjpji7KlizxZHva3S7OKp0f7Xxt5HyR5NgnkULx7lQ==
X-Google-Smtp-Source: AGRyM1uoUJNV+pWkUKZPyqoYjVU92W2AXcs0+oJA8ZTI80Wfq+v4vJ2sRUr54xc0spYE3wbFPeNslZTmLW60JMAY1vM=
X-Received: by 2002:a81:830b:0:b0:317:b41e:9e49 with SMTP id
 t11-20020a81830b000000b00317b41e9e49mr3977250ywf.458.1656155843079; Sat, 25
 Jun 2022 04:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220625080423.2797-1-chenfeiyang@loongson.cn>
 <CAMZfGtWT7oPq6bD_fRn2gVNX8Lj3=ev21EAoaCCPeq-P_NYF0g@mail.gmail.com> <CAAhV-H5K9LG5P6WYJ+64-fi+s=TZbbJQG9E0vHJwOf9Pai5z4w@mail.gmail.com>
In-Reply-To: <CAAhV-H5K9LG5P6WYJ+64-fi+s=TZbbJQG9E0vHJwOf9Pai5z4w@mail.gmail.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Sat, 25 Jun 2022 19:16:46 +0800
Message-ID: <CAMZfGtVq0VwMETGdzAXLkjes8W0gVBw=r0Xk5rpPnhe7x6tRiw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] page-flags.h: Fix a missing header include
 of static_keys.h
To:     Huacai Chen <chenhuacai@kernel.org>
Cc:     Feiyang Chen <chris.chenfeiyang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        loongarch@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 25, 2022 at 5:04 PM Huacai Chen <chenhuacai@kernel.org> wrote:
>
> Hi, Muchun,
>
> On Sat, Jun 25, 2022 at 4:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
> >
> > On Sat, Jun 25, 2022 at 4:04 PM Feiyang Chen
> > <chris.chenfeiyang@gmail.com> wrote:
> > >
> > > The page-flags.h header relies on static keys since commit
> > > a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled
> > > with a static_key"), so make sure to include the header to avoid
> > > compilation errors.
> > >
> > > Fixes: a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> > > ---
> > >  include/linux/page-flags.h | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > > index e66f7aa3191d..147b336c7a35 100644
> > > --- a/include/linux/page-flags.h
> > > +++ b/include/linux/page-flags.h
> > > @@ -11,6 +11,7 @@
> > >  #include <linux/mmdebug.h>
> > >  #ifndef __GENERATING_BOUNDS_H
> > >  #include <linux/mm_types.h>
> > > +#include <linux/static_key.h>
> >
> > I did not include this. The change makes sense to me. But I am
> > curious what configs cause the compiling error. Would you mind
> > sharing the config with us?
> We found this problem when we add
> ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP to LoongArch. Since this isn't

Good news to me. I would love to hear more archs support for HVO (HugeTLB
Vmemmap Optimization).

> upstream yet, we cannot give such a config now (the default config of
> X86 and ARM64 is just OK).

All right. In this case, the "Cc: stable@vger.kernel.org" is unnecessary.

Thanks.
>
> Huacai
> >
> > Thanks.
> >
> > >  #include <generated/bounds.h>
> > >  #endif /* !__GENERATING_BOUNDS_H */
> > >
> > > --
> > > 2.27.0
> > >
> >
