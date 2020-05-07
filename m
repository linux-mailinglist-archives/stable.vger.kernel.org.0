Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DA81C8A27
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgEGMLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 08:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgEGMLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 08:11:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CBAC05BD43;
        Thu,  7 May 2020 05:11:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so6237658wmb.4;
        Thu, 07 May 2020 05:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wFVKzsYazuYKj9heOP0kOc+xOXwZKNaQI+1syNAe7nw=;
        b=I6aWz9PinYdDL2Xq1qEgKDQ/b/d3dIjL+jTkyjvbBUGSvPWEJa3WrLKsomaQZmIQZ6
         q6GOJVMlzDXjjZqfu+p/mcA3bPpg7OyDDYU0Ybmh3ADqy7B4C9ooE4ylTcVngppiecPU
         p53doAurX4EcwJC1lOQ+FlA/AjRACV0R2JhEuLpxKdO3OlcaDBJrE96Lcx4Q11Hq4ojT
         kRN73rNpgIOrz1aunSJZ2dsjId17C8YrLH+3AYqKJPdRBHQc2k5gnnq0SwzIUinf5flk
         EINaCym/k8kiybNxkE+Pg6xs99GIplZLQ8ZRyZIOHnHktX/gW/j5D2EWf7Q8PhOw+6fJ
         8wFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wFVKzsYazuYKj9heOP0kOc+xOXwZKNaQI+1syNAe7nw=;
        b=Dq6p5a5zg0bdTNv5WIMHoOXNFzGoeqR0qb78lugcdMHGqfCM9JDnXtCf3apjtCsZTl
         TSf/6KwId3SVH3eYNKQdjNFuLMVJOIO8d3KDuHlP0qPzxTGGjVu8CiXlXnHYdHVq1++K
         MX3XxjVIr6ulHtbwjZqhg0U2P8qBKci6rwShP9rkd0M3jCDeB8p42oP+koZ/HWw4gNbH
         nwJQnI1fmVmgM6hR0mvu5AUZzL0klYQEvIxjWkdzhh/Fj8xO7jRljRTrIaH+gdQNBZrc
         7R9VLFFqT0W1vXsfySN1UW/vfVn3gojbLHWVdO3VK+hgdgB2iug7DVCqaOi8F3pwa0u8
         p6cQ==
X-Gm-Message-State: AGi0Puap8GpAFJjbg+cNtwXjSwjJY7tqRr5TUGIQXVYBc2223bxwt0s8
        pZKRJ3hVIXpiS+dxUDunj2FiVQEKQEw8I8VQbHHSf6qX
X-Google-Smtp-Source: APiQypIrutgCXbulDuAlppfAP6QmfR1GsEMUzPJyU74jqdfzmnkrsibTkvJbih7/k7aJeZ7N5jQMz0hzTsZIfDhSnEg=
X-Received: by 2002:a7b:c74d:: with SMTP id w13mr9755931wmk.36.1588853477169;
 Thu, 07 May 2020 05:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-2-git-send-email-chenhc@lemote.com> <20200506234214.2887220735@mail.kernel.org>
In-Reply-To: <20200506234214.2887220735@mail.kernel.org>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Thu, 7 May 2020 14:10:55 +0200
Message-ID: <CAHiYmc4u6iM8BsEX-bHgFk6eD36FcE=_P-n29U0P=51Cyb5YVA@mail.gmail.com>
Subject: Re: [PATCH V3 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Huacai Chen <chenhc@lemote.com>, Xing Li <lixing@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        QEMU Developers <qemu-devel@nongnu.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=D1=87=D0=B5=D1=82, 7. =D0=BC=D0=B0=D1=98 2020. =D1=83 01:43 Sasha Levin <s=
ashal@kernel.org> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.6.10, v5.4.38, v4.19.120, v4.1=
4.178, v4.9.221, v4.4.221.
>
> v5.6.10: Build OK!
> v5.4.38: Build OK!
> v4.19.120: Build OK!
> v4.14.178: Build OK!
> v4.9.221: Build OK!
> v4.4.221: Failed to apply! Possible dependencies:
>     029499b47738 ("KVM: x86: MMU: Make mmu_set_spte() return emulate valu=
e")
>     19d194c62b25 ("MIPS: KVM: Simplify TLB_* macros")
>     403015b323a2 ("MIPS: KVM: Move non-TLB handling code out of tlb.c")
>     7ee0e5b29d27 ("KVM: x86: MMU: Remove unused parameter of __direct_map=
()")
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
>

Hi, Sasha.

Please wait for the the review of the whole series. It might also be
the case that this patch will be upstreamed before the whole series,
but please do not rush or skip regular review process.

Thanks for you involvement and efforts!

Aleksandar

> --
> Thanks
> Sasha
>
