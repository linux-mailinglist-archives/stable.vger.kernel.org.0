Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F6F40B869
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 21:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhINT4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 15:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbhINT4E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 15:56:04 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6845C061764
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:54:46 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id bi4so793960oib.9
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 12:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xtR27z6ArnQBxxqRuhMNgUKk5tpQO0X2C1F4R+xD3JM=;
        b=SCLn97FK+hXMMlHmbUSLfHw7x68WBqS0hKDXIZGicXin4gluDW3vfgrkP2Ca4RSOpc
         XibbKhQs8gUw+nb8qarCB2xb87HrBOpLTbs25sC+4CrzbceexThTsvsv9Cdpo2QZahKQ
         982mpMQRpEm/DlBtrRGoR2UVPQ9sd4kxxT00lfVsz1O9mPAVEzVAllr2p8tcS8MhweBs
         hOBITNlddkzMFCO6Spq57aTaCKRcmnK69vaaUSgFoBOb+8q59JHvx5eA/Fz67P65/ZN0
         V3OhgYKPezO1iVjRd4iDkrNYZHd6MPS2W5rDJhUCjW7uq20J0SdaP/6dp4e+JEqOiLbz
         cIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtR27z6ArnQBxxqRuhMNgUKk5tpQO0X2C1F4R+xD3JM=;
        b=7a4X0baUl+McmCYoQQXxHYsmo6JGQG/8MFDkMoS354hpeHeLiQYYKYdNu8ZaMHS5Ai
         cBqZ3B5IIh2/uBH1jlQmGHLsXTRwXDeNHRUszX7+Hepq9lkLf+Em2p5YXLVSF6IloaT4
         teH4p9sTXTPwSXh/Mq9bkGsyCCahxygU2H2IvsQjFwAg86DeWLXwBT1KHzw5VPkAU5p7
         DeEZEFpU2DgR4/aV/2R0XhGBuDmPDbI7mva1LDn7U7NJgxuRVvjaMeZ0dm3gvOaErYjJ
         v3p8rdxjV8s0VUOqymiQwtHoBI+5SfHo4k1NwWDyBZTDbZ/xxqx1vYK/KbTdKchNktZ8
         tRaQ==
X-Gm-Message-State: AOAM532ACDPWlgHNeI10VoUFmJlNBszdxeWqKsDHJUuiwsYZdSG4T3d2
        Krs5YuqRGD01CytcRsKoo8UZIOqpqBzs6nm0Y8Y3bQ==
X-Google-Smtp-Source: ABdhPJyY49qMeuzZKAaa8KedjVaEkbHPUYNH9m6MA6xJpe80HJVWe/OsgcQjWGCihyusAFnyuLtDB0ocuzpVrrtBnH8=
X-Received: by 2002:a05:6808:909:: with SMTP id w9mr2742252oih.164.1631649286048;
 Tue, 14 Sep 2021 12:54:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210914190125.3289256-1-pgonda@google.com>
In-Reply-To: <20210914190125.3289256-1-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 14 Sep 2021 12:54:35 -0700
Message-ID: <CAA03e5HBzp4ttsQ_o8xTmtMNhp9WM0zTUgS_SQViAAhTX5=hTQ@mail.gmail.com>
Subject: Re: [PATCH V2] KVM: SEV: Disable KVM_CAP_VM_COPY_ENC_CONTEXT_FROM for SEV-ES
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Nathan Tempelman <natet@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 14, 2021 at 12:01 PM Peter Gonda <pgonda@google.com> wrote:
>
> Copying an ASID into new vCPUs will not work for SEV-ES since the vCPUs
> VMSAs need to be setup and measured before SEV_LAUNCH_FINISH. Return an
> error if a users tries to KVM_CAP_VM_COPY_ENC_CONTEXT_FROM from an
> SEV-ES guest. The destination VM is already checked for SEV and SEV-ES
> with sev_guest(), so this ioctl already fails if the destination is SEV
> enabled.
>
> Enabling mirroring a VM or copying its encryption context with an SEV-ES
> VM is more involved and should happen in its own feature patch if that's
> needed. This is because the vCPUs of SEV-ES VMs need to be updated with
> LAUNCH_UPDATE_VMSA before LAUNCH_FINISH. This needs KVM changes because
> the mirror VM has all its SEV ioctls blocked and the original VM doesn't
> know about the mirrors vCPUs.
>
> Fixes: 54526d1fd593 ("KVM: x86: Support KVM VMs sharing SEV context")
>
> V2:
>  * Updated changelog with more information and added stable CC.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Nathan Tempelman <natet@google.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/kvm/svm/sev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75e0b21ad07c..8a279027425f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1728,7 +1728,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>         source_kvm = source_kvm_file->private_data;
>         mutex_lock(&source_kvm->lock);
>
> -       if (!sev_guest(source_kvm)) {
> +       if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
>                 ret = -EINVAL;
>                 goto e_source_unlock;
>         }
> --
> 2.33.0.309.g3052b89438-goog
>

Reviewed-by: Marc Orr <marcorr@google.com>
