Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4800F55AAE0
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiFYORy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiFYORx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:17:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00D611166;
        Sat, 25 Jun 2022 07:17:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4B3E6CE0931;
        Sat, 25 Jun 2022 14:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918CAC341C6;
        Sat, 25 Jun 2022 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656166668;
        bh=/vdN1zyTd6jvoNxaeIf5UuWT3PorSP8Uw1GyBtbjnho=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lwqqwxJWUyL9t69L7ssOccaEUiWzp+WcPWbxVt9ArVp/9EonnphMgG/Pmbg8gjmaQ
         hXo1xNFcqxom3LerXUZsWNCN4RSJTU5TD6BwaL+NrqHjKDQm19tFsN6hnSDfQO5nOI
         vI7eDhLxhAI8soM9b19lKlhfWuP6zDKkjDz0V3ox2GHiLYiSsXOS+ZbDGzygOhnw74
         tdm21+IHiMp7A3Jw+ic+if1+1q9X6/bc5q0XHmogupId16WEVjbWVZuUPie89AoZva
         pxugPMCnEdumI8gkLLEI1OKquxhvxYsIrd+JMJtK+W77L4mAmyPLP+OwqF4yZFp8rX
         PtlyLMzQ+8isA==
Received: by mail-vk1-f176.google.com with SMTP id j26so2468336vki.12;
        Sat, 25 Jun 2022 07:17:48 -0700 (PDT)
X-Gm-Message-State: AJIora+QVHtOi6gbXS1D6bB03vQNgPFaGPM0W/6nGFvU326sHGk5mIxj
        qY5FzPUCPba0IJk56Rbyg5YUPIHfOtLmGLzDd/E=
X-Google-Smtp-Source: AGRyM1tdXWK81iVaLzgUJcAldC8WOB7V3FAvmztZRnPcrWNodKSLifX32OgOmFRLbjtIP4K9fDtvsNfVIXrOOrulZvo=
X-Received: by 2002:a05:6122:13ab:b0:36c:65f:ea30 with SMTP id
 n11-20020a05612213ab00b0036c065fea30mr1434812vkp.37.1656166667586; Sat, 25
 Jun 2022 07:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220625080423.2797-1-chenfeiyang@loongson.cn>
 <CAMZfGtWT7oPq6bD_fRn2gVNX8Lj3=ev21EAoaCCPeq-P_NYF0g@mail.gmail.com>
 <CAAhV-H5K9LG5P6WYJ+64-fi+s=TZbbJQG9E0vHJwOf9Pai5z4w@mail.gmail.com>
 <CAMZfGtVq0VwMETGdzAXLkjes8W0gVBw=r0Xk5rpPnhe7x6tRiw@mail.gmail.com>
 <CAAhV-H4T3ixOWB67XOij3P1xvM+_BUu+THLGtx-VvrCYUgjZyw@mail.gmail.com> <YrcWosmEcADSWax+@kroah.com>
In-Reply-To: <YrcWosmEcADSWax+@kroah.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 25 Jun 2022 22:17:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H44Cs0jf=RUboGSLvmWtCwjBQa-QLy7tPq7XoOZ9jomUA@mail.gmail.com>
Message-ID: <CAAhV-H44Cs0jf=RUboGSLvmWtCwjBQa-QLy7tPq7XoOZ9jomUA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] page-flags.h: Fix a missing header include
 of static_keys.h
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Feiyang Chen <chris.chenfeiyang@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        loongarch@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

On Sat, Jun 25, 2022 at 10:07 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Sat, Jun 25, 2022 at 10:00:43PM +0800, Huacai Chen wrote:
> > Hi, Muchun,
> >
> > On Sat, Jun 25, 2022 at 7:17 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > >
> > > On Sat, Jun 25, 2022 at 5:04 PM Huacai Chen <chenhuacai@kernel.org> wrote:
> > > >
> > > > Hi, Muchun,
> > > >
> > > > On Sat, Jun 25, 2022 at 4:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
> > > > >
> > > > > On Sat, Jun 25, 2022 at 4:04 PM Feiyang Chen
> > > > > <chris.chenfeiyang@gmail.com> wrote:
> > > > > >
> > > > > > The page-flags.h header relies on static keys since commit
> > > > > > a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled
> > > > > > with a static_key"), so make sure to include the header to avoid
> > > > > > compilation errors.
> > > > > >
> > > > > > Fixes: a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> > > > > > ---
> > > > > >  include/linux/page-flags.h | 1 +
> > > > > >  1 file changed, 1 insertion(+)
> > > > > >
> > > > > > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > > > > > index e66f7aa3191d..147b336c7a35 100644
> > > > > > --- a/include/linux/page-flags.h
> > > > > > +++ b/include/linux/page-flags.h
> > > > > > @@ -11,6 +11,7 @@
> > > > > >  #include <linux/mmdebug.h>
> > > > > >  #ifndef __GENERATING_BOUNDS_H
> > > > > >  #include <linux/mm_types.h>
> > > > > > +#include <linux/static_key.h>
> > > > >
> > > > > I did not include this. The change makes sense to me. But I am
> > > > > curious what configs cause the compiling error. Would you mind
> > > > > sharing the config with us?
> > > > We found this problem when we add
> > > > ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP to LoongArch. Since this isn't
> > >
> > > Good news to me. I would love to hear more archs support for HVO (HugeTLB
> > > Vmemmap Optimization).
> > >
> > > > upstream yet, we cannot give such a config now (the default config of
> > > > X86 and ARM64 is just OK).
> > >
> > > All right. In this case, the "Cc: stable@vger.kernel.org" is unnecessary.
> > Maybe make randconfig will have problems on X86/ARM64, so backporting
> > to 5.18 seems reasonable.
>
> Unless it is proven to be needed, there is no need to backport it.
OK, we will try "make randconfig". And if it isn't needed, should we
send V2 to remove Cc stable?

Huacai
>
> thanks,
>
> greg k-h
