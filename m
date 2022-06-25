Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B982655A83D
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 11:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbiFYJEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 05:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiFYJEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 05:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC66E33E06;
        Sat, 25 Jun 2022 02:04:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D39DB8123D;
        Sat, 25 Jun 2022 09:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2934CC36AEA;
        Sat, 25 Jun 2022 09:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656147882;
        bh=d1m4ViZsUEwStF52CXPdQ9iCbz67N/mVOzUvE7P5wcw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tWDHnfEZx3QkxTH3f5U99sMoIvQNLix0IJC3qrVIHPB3LtrfqVkeLo536RMlO1nX2
         +Zabn6PkNK2NitORIlQENHi7oVs169Ukh+JWLU+KUspJyrPdVMDh55KEsKzoNMwo19
         II3+rohbnpBr34zHgbJElz449MY5eHORDiw89iwKvfC1LTP32yZAMV60SnKbFV1ZSL
         S1tJWHQ4Wk/xcmGgcHuIiuwxbmiTMdzqUlFhblv3jxSnHArza6Ga46gNXqboW1fRnd
         X1qWUuhF2YW95iBfWvQP2T+51fUdhFBFJBtt6wjONoPRTXDGLoMgCwtzfqEfF9XJZF
         HA17ncpGUVN0A==
Received: by mail-vk1-f178.google.com with SMTP id b4so2248343vkh.6;
        Sat, 25 Jun 2022 02:04:42 -0700 (PDT)
X-Gm-Message-State: AJIora/tzVJWrE++TIUSOkGpiwyJw3j2Gvd81aWmCiHgg/bS7bdKSMXb
        /9693EHj40y0UJQUQ9GFWgqT4Yd0whOuRpwZot4=
X-Google-Smtp-Source: AGRyM1uJK+hFV1788av5WDmrYXC8l5SBL9TOTOr7dxCRSj9z5BhWbOhQj1/NWCoCyOaSvuBXPif8Z3VMPiFIkHM61ZI=
X-Received: by 2002:a05:6122:13ab:b0:36c:65f:ea30 with SMTP id
 n11-20020a05612213ab00b0036c065fea30mr943426vkp.37.1656147881167; Sat, 25 Jun
 2022 02:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220625080423.2797-1-chenfeiyang@loongson.cn> <CAMZfGtWT7oPq6bD_fRn2gVNX8Lj3=ev21EAoaCCPeq-P_NYF0g@mail.gmail.com>
In-Reply-To: <CAMZfGtWT7oPq6bD_fRn2gVNX8Lj3=ev21EAoaCCPeq-P_NYF0g@mail.gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 25 Jun 2022 17:04:28 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5K9LG5P6WYJ+64-fi+s=TZbbJQG9E0vHJwOf9Pai5z4w@mail.gmail.com>
Message-ID: <CAAhV-H5K9LG5P6WYJ+64-fi+s=TZbbJQG9E0vHJwOf9Pai5z4w@mail.gmail.com>
Subject: Re: [PATCH] page-flags.h: Fix a missing header include of static_keys.h
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     Feiyang Chen <chris.chenfeiyang@gmail.com>,
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

Hi, Muchun,

On Sat, Jun 25, 2022 at 4:50 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Sat, Jun 25, 2022 at 4:04 PM Feiyang Chen
> <chris.chenfeiyang@gmail.com> wrote:
> >
> > The page-flags.h header relies on static keys since commit
> > a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled
> > with a static_key"), so make sure to include the header to avoid
> > compilation errors.
> >
> > Fixes: a6b40850c442bf ("mm: hugetlb: replace hugetlb_free_vmemmap_enabled with a static_key")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> > ---
> >  include/linux/page-flags.h | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> > index e66f7aa3191d..147b336c7a35 100644
> > --- a/include/linux/page-flags.h
> > +++ b/include/linux/page-flags.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/mmdebug.h>
> >  #ifndef __GENERATING_BOUNDS_H
> >  #include <linux/mm_types.h>
> > +#include <linux/static_key.h>
>
> I did not include this. The change makes sense to me. But I am
> curious what configs cause the compiling error. Would you mind
> sharing the config with us?
We found this problem when we add
ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP to LoongArch. Since this isn't
upstream yet, we cannot give such a config now (the default config of
X86 and ARM64 is just OK).

Huacai
>
> Thanks.
>
> >  #include <generated/bounds.h>
> >  #endif /* !__GENERATING_BOUNDS_H */
> >
> > --
> > 2.27.0
> >
>
