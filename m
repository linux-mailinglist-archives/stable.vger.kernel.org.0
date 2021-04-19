Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82457364D5B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbhDSVyy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhDSVyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:54:53 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69DBC06174A
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 14:54:23 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id y1so2871737plg.11
        for <stable@vger.kernel.org>; Mon, 19 Apr 2021 14:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1i3gRklEVn4rcGvJfanGgRgq9YRpuGxfecqav8SO1PQ=;
        b=aUAFydFnKA6/DNucCjbel4rBIl5NrZp4Fwz35yQFGfFxeyfXtmcnuyQZ7JDoKqZRJm
         wvCm9+aDbVhvxRFpq8D92Ry3gxBJnrVXYrNjTWxni4Kqy1U/WUKWj6x5Q8OTfUnLV/FQ
         mQ5ulMPsRyh2Dg08V/Lj3Orfcm+G2nNPSBK9rBpLmFgyMSeq/7LrwGzarQ7mZGt+zcVF
         KGZleBpbEYLFp1jWUKVRE+4cfGP46DrlAhXBr8xCDAmqUygVHtVFC+PzUbZznfH3xtag
         U13coduseqxJrwnb/MSj3cvIeonNNZEgdZvc8VOvbNJSQgZwo3wTudSOwmnfNj8+jtJ+
         n4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1i3gRklEVn4rcGvJfanGgRgq9YRpuGxfecqav8SO1PQ=;
        b=FSB2PlNgfgyIFaIxPHccbuMfEhhPMGhC07sHed4yyzgjT/jUOO/W7EzGm9Kn9KoAci
         kkgyzo3fZ7eA24cbbfMhzCNDCsqY5FD4XECz7uAkYNx6M5EgdDM0auRdr5PrgIBt3WS5
         RjAt4/0/+tb1LRPBpEHPs4gHNAJRnbaA+sIyWUrLM8ztcK2n67s0bU7Nl0SimDxbJMt/
         wNgYYpyMQqq/SmY+MmNJoNaAzSX8upfpGqdbQF/5/KxuSlk0AC5PY1ylF47QjV3lAlsL
         AW7s3I40H1K4tUV0KiLaf/pbDMClrbImQuqAanlW/Tg+AiMInWbiClrkuIl8MpucTiKZ
         YbUQ==
X-Gm-Message-State: AOAM530eL4eIEp7tNTIT+s1UOT2oN6VSbioLUPQa+e6Dpuhb7l3k8VVY
        aJcUT+Mtqt3Rqp1V6U+mU/5EZN+Vb4bYVQ==
X-Google-Smtp-Source: ABdhPJwRKHcHUUB75RJ8UksC6cCcuOtivKcwdvQTiCRHMAGo4WJYZrc7oY+xQK+RKi9lpCp9nS7JAg==
X-Received: by 2002:a17:90a:7147:: with SMTP id g7mr1214240pjs.225.1618869263264;
        Mon, 19 Apr 2021 14:54:23 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d21sm368051pjx.24.2021.04.19.14.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 14:54:22 -0700 (PDT)
Date:   Mon, 19 Apr 2021 21:54:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Patch "KVM: VMX: Convert vcpu_vmx.exit_reason to a union" has
 been added to the 5.10-stable tree
Message-ID: <YH38CpPjGSsSRUgt@google.com>
References: <20210419002733.D5675610CB@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419002733.D5675610CB@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Paolo

On Sun, Apr 18, 2021, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     KVM: VMX: Convert vcpu_vmx.exit_reason to a union
> 
> to the 5.10-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      kvm-vmx-convert-vcpu_vmx.exit_reason-to-a-union.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

I'm not sure we want this going into stable kernels, even for 5.10 and 5.11.
I assume it got pulled in to resolve a conflict with commit 04c4f2ee3f68 ("KVM:
VMX: Don't use vcpu->run->internal.ndata as an array index"), but that's should
be trivial to resolve since it's just a collision with surrounding code.

Maybe we'll end up with a more painful conflict in the future that would be best
solved by grabbing this refactoring, but I don't think we're there yet.


> commit 1499b54db7d9e7e5f5014307e8391e3ad7986f1f
> Author: Sean Christopherson <seanjc@google.com>
> Date:   Fri Nov 6 17:03:12 2020 +0800
> 
>     KVM: VMX: Convert vcpu_vmx.exit_reason to a union
>     
>     [ Upstream commit 8e53324021645f820a01bf8aa745711c802c8542 ]
>     
>     Convert vcpu_vmx.exit_reason from a u32 to a union (of size u32).  The
>     full VM_EXIT_REASON field is comprised of a 16-bit basic exit reason in
>     bits 15:0, and single-bit modifiers in bits 31:16.
>     
>     Historically, KVM has only had to worry about handling the "failed
>     VM-Entry" modifier, which could only be set in very specific flows and
>     required dedicated handling.  I.e. manually stripping the FAILED_VMENTRY
>     bit was a somewhat viable approach.  But even with only a single bit to
>     worry about, KVM has had several bugs related to comparing a basic exit
>     reason against the full exit reason store in vcpu_vmx.
>     
>     Upcoming Intel features, e.g. SGX, will add new modifier bits that can
>     be set on more or less any VM-Exit, as opposed to the significantly more
>     restricted FAILED_VMENTRY, i.e. correctly handling everything in one-off
>     flows isn't scalable.  Tracking exit reason in a union forces code to
>     explicitly choose between consuming the full exit reason and the basic
>     exit, and is a convenient way to document and access the modifiers.
>     
>     No functional change intended.
>     
>     Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>     Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>     Message-Id: <20201106090315.18606-2-chenyi.qiang@intel.com>
>     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
