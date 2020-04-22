Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4831B365F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 06:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgDVEde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 00:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725961AbgDVEde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 00:33:34 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5D3C061BD3;
        Tue, 21 Apr 2020 21:33:33 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id n6so772097ljg.12;
        Tue, 21 Apr 2020 21:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6A/JSt/lvhm1/8jW+5g+pqNVCFB1Ru0tyfuhWz6X1oI=;
        b=c7TcHPII2iQm7OBzps9DhQIcRy0VU/z4odqOV8MmTZ9JAzqe0NiJrrV8B79WMKAXGR
         em1ZWTe8oMnSaNd//LpkmCLn6VF6IbfDfbYPA2EMuVGS3VV3mS16Ul4MhWCTDzl4+iOL
         x7hMai51AWj2ruoy3BXtBtD3jwzBA4k+YE7RTuUByAvx1CvKe6Gv108C5cJF//UJaa54
         xpDlgv5F+fnt0RXGflvd+YNYM8ic519NHiuqL+ZNbqMcCTHY9X1tqbzfoXXThyVNY5DP
         OslJUR1fTRdrXW/A1/QEIANJd6IXUXLsPB4hoej9nICxg6o9ri1Fphd3P93K6fXWQlvg
         L/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6A/JSt/lvhm1/8jW+5g+pqNVCFB1Ru0tyfuhWz6X1oI=;
        b=tQlbjz98A9nPLZOZpQCXpEGQczJ4jUrDqiHp9828r4ukHv8B8A5ZiieMTWR335rsLW
         6iDNmMl+1rTBR4+0SQXh23PLoloHvMECg61zjV0FQj6Xhde+HIaFnkpiv/zw2aXNNKHK
         1UiUV2MWfvFU+H/GaXdEMHTze6VBdUkRNmrIg14UOxBpfsER81uypEw7usFlDksy9kpN
         ls7plbwpmBt4uokxeL8rGDJ+Ip7Hygagb8sLriQDA6/z9wTGSMvJwOcJZjZDWVXP0ws6
         9S+dxqzglXR0iwaX2Nyl1ZjVPyBgH/nQsbZJxlg2Q61Dl54E+5jvkYyb/gX2WS9LiLV5
         LUVA==
X-Gm-Message-State: AGi0PubhEG3AvT7qiIc/vuGOHVqC1nYUg3CdZcaC1JGZH6j4C/FQGt8X
        G9icZfgJRPH/IrCafVxFQNJ7WoBl0VWU9iholpc=
X-Google-Smtp-Source: APiQypJCzQXTwcVDAsol0GJSsiyf/YRGJPA1BCsaylnkBqP8rfc2a3FzDvddKmzBEi+evnZScUHUz2AZvsuoEtD4s5M=
X-Received: by 2002:a2e:87d3:: with SMTP id v19mr5744807ljj.176.1587530012019;
 Tue, 21 Apr 2020 21:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <1586763024-12197-4-git-send-email-chenhc@lemote.com> <20200421195613.CD4D1206D9@mail.kernel.org>
In-Reply-To: <20200421195613.CD4D1206D9@mail.kernel.org>
From:   chen huacai <zltjiangshi@gmail.com>
Date:   Wed, 22 Apr 2020 12:40:53 +0800
Message-ID: <CABDp7VoErMhsmG4QepXd-vJgtUiWRYCt77KdjpjwGhpmq3MLZg@mail.gmail.com>
Subject: Re: [PATCH 03/15] KVM: MIPS: Fix VPN2_MASK definition for variable cpu_vmbits
To:     Sasha Levin <sashal@kernel.org>
Cc:     Huacai Chen <chenhc@lemote.com>, Xing Li <lixing@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        qemu-level <qemu-devel@nongnu.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha,

On Wed, Apr 22, 2020 at 9:42 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.
>
> v5.6.5: Build OK!
> v5.5.18: Build OK!
> v5.4.33: Build OK!
> v4.19.116: Build OK!
> v4.14.176: Build OK!
> v4.9.219: Build OK!
> v4.4.219: Failed to apply! Possible dependencies:
>     029499b47738 ("KVM: x86: MMU: Make mmu_set_spte() return emulate value")
>     19d194c62b25 ("MIPS: KVM: Simplify TLB_* macros")
>     403015b323a2 ("MIPS: KVM: Move non-TLB handling code out of tlb.c")
>     7ee0e5b29d27 ("KVM: x86: MMU: Remove unused parameter of __direct_map()")
>     9a99c4fd6586 ("KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)")
>     9fbfb06a4065 ("MIPS: KVM: Arrayify struct kvm_mips_tlb::tlb_lo*")
>     ba049e93aef7 ("kvm: rename pfn_t to kvm_pfn_t")
>     bdb7ed8608f8 ("MIPS: KVM: Convert headers to kernel sized types")
>     ca64c2beecd4 ("MIPS: KVM: Abstract guest ASID mask")
>     caa1faa7aba6 ("MIPS: KVM: Trivial whitespace and style fixes")
>     e6207bbea16c ("MIPS: KVM: Use MIPS_ENTRYLO_* defs from mipsregs.h")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
Please ignore this patch in linux-4.4 branch and even below.

>
> --
> Thanks
> Sasha
>


-- 
Huacai Chen
