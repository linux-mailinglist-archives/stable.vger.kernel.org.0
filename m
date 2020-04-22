Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613D51B365D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 06:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgDVEcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 00:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725355AbgDVEcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 00:32:50 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B49BC061BD3;
        Tue, 21 Apr 2020 21:32:50 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so764934lja.13;
        Tue, 21 Apr 2020 21:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A5QcfjCn4RHqxFiUd6PW5P9dUEa7LK3ItDiWItR+ENY=;
        b=LWv/JZzafay7oRFFZtJqFGtvMDPsNV5bw77dhIFOOeJBjFTu5zh4OpuCyAMv0Y217U
         51SeLdsd6xu3q4qprVgI2FWMiFXF/kFr1q6JtNDSkpLZAePfLFixYyxELG0RznpYIZWl
         oX0MlD8JslD6H1f/UHsdRUZJa3f/cLrNbv2vRgUN4tALvynmTdC9i0FN9PzwV8isMUFL
         xjYza4n00Glv4eRD3aYOE326OhwNLa0hzQOWMxrdfHkEIU1Masj9YSAgBKmCSBdao0fl
         0Zt99AuMLkH3trLAVBKxLLDBj9VchEUyziShKVeDk8zrLxziV41IVHVyPjDSUk7U6yw8
         1aVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A5QcfjCn4RHqxFiUd6PW5P9dUEa7LK3ItDiWItR+ENY=;
        b=rG6afltyXvDONh2EyjzGtKKSUX+5LfQhqMqyzTmnmv9vBkzAmi0e1FPVYH6/FKPfsh
         RpYGKVCc9PKg2ev6rgNeAwcASmC6vkBWIM48VkJPnNZq6K5hImONfsOTmO2zCdgLqFQ8
         FzkY/qIEwUPFT1HjKYrzwZHs6GL+9fQkjMjHPuDmisp8ERLUKTlTYBprp1blexeTkNJF
         2CPTwlV/KqhxgUXoP/vM8YWYyUGjz8t7f3bk4VtB6IAylNJfWjFte86eOigfYlwv4hDY
         pzemmh4xF9jFVvxhxoU3JblOmDu8Pj0u1GtF07g/1iLoGPH3mSZwuIrg2FGF0lj0+toG
         cxkA==
X-Gm-Message-State: AGi0PuYWH6uEIL0Tjd+OQ4SLS95eNx92g44y6hWcdE9LxkJfvM4DAAn4
        jTVAz1j9cGHje9ljyZjoNNZny+LutNFXTLprHu0=
X-Google-Smtp-Source: APiQypLk+D7TFlox7KCXYhUtX1tRIYss0/OkVkleKJZEfuLyIcHMqz3bBCjV80gtvPEUDaLqY+jwZQ+PgnR7cvHkUuY=
X-Received: by 2002:a2e:9b0f:: with SMTP id u15mr618934lji.272.1587529968454;
 Tue, 21 Apr 2020 21:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <1586763024-12197-3-git-send-email-chenhc@lemote.com> <20200421195611.49A4A206E9@mail.kernel.org>
In-Reply-To: <20200421195611.49A4A206E9@mail.kernel.org>
From:   chen huacai <zltjiangshi@gmail.com>
Date:   Wed, 22 Apr 2020 12:40:10 +0800
Message-ID: <CABDp7Vo_rKn2x8zmrNQzdcFHC_1sxXDot1t_ZEt+Y=Q=jo+wOQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
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

On Wed, Apr 22, 2020 at 9:40 AM Sasha Levin <sashal@kernel.org> wrote:
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
Thanks,
Huacai


-- 
Huacai Chen
