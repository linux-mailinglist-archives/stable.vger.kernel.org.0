Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195812655F3
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 02:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgIKALE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 20:11:04 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:41087 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIKALC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 20:11:02 -0400
Received: by mail-il1-f196.google.com with SMTP id f82so2770205ilh.8;
        Thu, 10 Sep 2020 17:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ofLdB1ZTDFH7QGV+wOpkPUtE3Hz6n1lrSjhV0ZOygs=;
        b=lNT7LB47llKqXt4bTUaoV3MHdxxlWx7xBVevo+qyaXYKyhhmb/90rXnN62D32hRM37
         zl/qJY8tB1o+WSdbZZ+42BZ0jMGaStb+RDR2Cv4kW88tN593yJL3PLjHQ2jtnTzCmDne
         s2L3seVXx+uv6XybwInILhqD7AqKrSS79prH7Yw14Y0y/AHYBjWjOrwfwO/rISYcFAe/
         9UeXwy0ey/OVe/8IU5iDtMrNE1lyYetC0nOOEN8sjJFXEMwGFFhjdGkbZ1zAbi3SYFbx
         pfMquJrJiIAkDyUHcmuodFdxgBVuE9yHotKia3VC+efFYpDr6Xxpi9IxBdfCvll97S6W
         0C4g==
X-Gm-Message-State: AOAM5311PWF45st/Igoaps6CWLQxPMrg0tc2Z3jgPzx4nndgTOVthSsY
        BXEcj4MNx/3IlUGxrkhkXf5pimbkmeh9OFsOJzs=
X-Google-Smtp-Source: ABdhPJxwo4436m7iJCImQHy6OK9kWHFVqaxlofwYLEz606Ig4xIb4Zd/1AIoKV58P082+l/R9T/RyebyBghhV0Mq3rU=
X-Received: by 2002:a92:c8c4:: with SMTP id c4mr7970513ilq.287.1599783061593;
 Thu, 10 Sep 2020 17:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <1599734031-28746-1-git-send-email-chenhc@lemote.com> <20200910163419.E0D1421D81@mail.kernel.org>
In-Reply-To: <20200910163419.E0D1421D81@mail.kernel.org>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Fri, 11 Sep 2020 08:10:50 +0800
Message-ID: <CAAhV-H52CkenD5AE-4mNs3pC0poOJwbcP+Ey4Z_AfLUSnQ8yZg@mail.gmail.com>
Subject: Re: [PATCH] KVM: MIPS: Change the definition of kvm type
To:     Sasha Levin <sashal@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Sasha,

On Fri, Sep 11, 2020 at 1:18 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.
>
> v5.8.7: Build OK!
> v5.4.63: Build OK!
> v4.19.143: Build OK!
> v4.14.196: Build OK!
> v4.9.235: Failed to apply! Possible dependencies:
>     06c158c96ed8 ("KVM: MIPS/MMU: Convert guest physical map to page table")
>     1534b3964901 ("KVM: MIPS/MMU: Simplify ASID restoration")
>     1581ff3dbf69 ("KVM: MIPS/MMU: Move preempt/ASID handling to implementation")
>     91cdee5710d5 ("KVM: MIPS/T&E: Restore host asid on return to host")
>     a2c046e40ff1 ("KVM: MIPS: Add vcpu_run() & vcpu_reenter() callbacks")
>     a31b50d741bd ("KVM: MIPS/MMU: Invalidate GVA PTs on ASID changes")
>     a60b8438bdba ("KVM: MIPS: Convert get/set_regs -> vcpu_load/put")
>     a7ebb2e410f8 ("KVM: MIPS/T&E: active_mm = init_mm in guest context")
>     a8a3c426772e ("KVM: MIPS: Add VZ & TE capabilities")
>     c550d53934d8 ("KVM: MIPS: Remove duplicated ASIDs from vcpu")
>     c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")
>
> v4.4.235: Failed to apply! Possible dependencies:
>     107d44a2c5bf ("KVM: document KVM_REINJECT_CONTROL ioctl")
>     366baf28ee3f ("KVM: PPC: Use RCU for arch.spapr_tce_tables")
>     462ee11e58c9 ("KVM: PPC: Replace SPAPR_TCE_SHIFT with IOMMU_PAGE_SHIFT_4K")
>     58ded4201ff0 ("KVM: PPC: Add support for 64bit TCE windows")
>     5ee7af18642c ("KVM: PPC: Move reusable bits of H_PUT_TCE handler to helpers")
>     a8a3c426772e ("KVM: MIPS: Add VZ & TE capabilities")
>     c92701322711 ("KVM: PPC: Book3S HV: Add userspace interfaces for POWER9 MMU")
>     d3695aa4f452 ("KVM: PPC: Add support for multiple-TCE hcalls")
>     f8626985c7c2 ("KVM: PPC: Account TCE-containing pages in locked_vm")
>     fcbb2ce67284 ("KVM: PPC: Rework H_PUT_TCE/H_GET_TCE handlers")
>     fe26e52712cc ("KVM: PPC: Add @page_shift to kvmppc_spapr_tce_table")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
Backport to 4.14+ is enough.

Huacai
>
> --
> Thanks
> Sasha
