Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11DC1B9580
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 05:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgD0De7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Apr 2020 23:34:59 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33102 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgD0De6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Apr 2020 23:34:58 -0400
Received: by mail-io1-f67.google.com with SMTP id o127so17344361iof.0;
        Sun, 26 Apr 2020 20:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bQd3lXTqblCEkvmd58RFuaaBCMl9c3wU/f2GfDs7JmE=;
        b=PfExsySdpr5AqNHORy1X1prIeUVQRL967+1rUqcvhe4tQ4lSma2Va+t0AEDP3YYVzM
         Hg07fO3TPHAWlaMV254l/ZzknyFnKpC4cYtHpL5cTeZLAPgq/9eXmojmskTYp3oOH4Yd
         g5YUv1QBioubDEmvACgohn4irB3qKPXJ0sdoA+ZRseH+gXDbqA4cI8B85gcH0ImKF1qj
         Yihv5mYmamzFWI2kyeGCQreFRSSQpmhFkwiY3Kr5bhL9xmtqE1ophRIebZfaT5ZHHfU3
         osb2wfyFovXbKqS269byvmfF3Tfcowb1ONKBe1UqA+/HqAhqsZQ2rqGgy3hAKAAcGdQ7
         s5Tw==
X-Gm-Message-State: AGi0PuYUkfPJMUYCjrTtION/HLN27hoCZ+jcIPDlNnEL9sNubzuLFO/N
        wWBCwLry5ztYLrbk1g11ZFltvBfHS49wmwEKS6PvMZzU
X-Google-Smtp-Source: APiQypIqE+Y64fdtg5YbsWIbJ47vBWy9vxBZ64Sf5ebWBPKWB2Imr5Vekd1+Swivs+6HTxFREUiyxblizAZYQPDXEbM=
X-Received: by 2002:a5e:8613:: with SMTP id z19mr18642912ioj.84.1587958498049;
 Sun, 26 Apr 2020 20:34:58 -0700 (PDT)
MIME-Version: 1.0
References: <1587726933-31757-2-git-send-email-chenhc@lemote.com> <20200426150343.62F0120A8B@mail.kernel.org>
In-Reply-To: <20200426150343.62F0120A8B@mail.kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Mon, 27 Apr 2020 11:42:25 +0800
Message-ID: <CAAhV-H6EcD8b-NB_toH3yiiNthMfPLCJu8aXbX=+4t3Se8mqaw@mail.gmail.com>
Subject: Re: [PATCH V2 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
To:     Sasha Levin <sashal@kernel.org>
Cc:     Xing Li <lixing@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, "open list:MIPS" <linux-mips@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha,

On Sun, Apr 26, 2020 at 11:04 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.
>
> v5.6.7: Build OK!
> v5.4.35: Build OK!
> v4.19.118: Build OK!
> v4.14.177: Build OK!
> v4.9.220: Build OK!
> v4.4.220: Failed to apply! Possible dependencies:
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
Please ignore this patch in linux-4.4 branch, thanks.

Huacai
>
> --
> Thanks
> Sasha
