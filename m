Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD58A67BF9E
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 23:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjAYWKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 17:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjAYWKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 17:10:12 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EBA5CE58
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 14:10:09 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id r9so17576650oie.13
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 14:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4MBoQI2jQuhUw84T5k/gy2Pds/AaFtiV5Xy1X72d3Cw=;
        b=R3UDI3pxYKcrC49x+0YFuHvc1nRET9DxRjhYOs0/0aQ+O5ZN7ErIteIRxDNQ5BZB7J
         Ga0V6/qNBFsd9ynV+wBqgTw0dj+oyaOuqj9JQucRalQOTwUnMdM2R77At75ZYvy9KqUh
         8ufY4Kbk1udXKKf6sKa1RnsVtrK1jkoc4HLDzoyaUydk4Uul3Oa7tmHrybtX8vrvMY3O
         Ix8wG3ThO0RXpq5O7+1TvhMJm9tis4Xb/H8I4O1l5cIHkoW5hc9Fly9JcwKK+LIE1yEY
         ob24jBK09LOMwi3B5Obj6pClMXqQQLKfAnjaoTLW4am8MO0cfPci0VIk2Ms72XA9jVS7
         sfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4MBoQI2jQuhUw84T5k/gy2Pds/AaFtiV5Xy1X72d3Cw=;
        b=E8prFv6fxgFrI7t87Ag+nzfPl/9EukVExdeDnGpQvWsCOeOXy/K1e6slcGSFO6lape
         /Z5tzvQ6B7608Jb+gJjahlOfZHr1KZ1J+yDJkKsHZ1FwEflavpwMQfTTqxGz0v2rzDur
         bQ+j7D03joaw7q2cpUGgCD/vwh8ZDJifcJHq3WgHvSo9J8rbavoquHwvbvK7JEOzbJ3P
         g1Eby6v4q5q6IiOW6poCldnWQWUfL73w/VO0UcBOsxC8INYsux0EIyCQt/lODwKoYmHo
         oMkes51CwD77Vfs/svc4r4ALGY7DcFj3b+cymtxvMW1/w5C3URr+7OFbMRBGfUURxmFx
         f4ew==
X-Gm-Message-State: AFqh2kr9yE3ynqigYJuW54huSGK6gZ12jPlb/km8gLq4KZWXQtOBuc1e
        r6TjjxpTAxPl2dJaJMUP++3uecQd76LO7fdYqbVpkg==
X-Google-Smtp-Source: AMrXdXslDOOF4Gq3gbyLF6+vrB8DgsCL6Eaw6PLWV+g67DAh5lYWllmUF2JzZjoe92TzZKkkKEPiKvjmO1n7H01TqNY=
X-Received: by 2002:aca:efc6:0:b0:36e:b85f:6081 with SMTP id
 n189-20020acaefc6000000b0036eb85f6081mr1086274oih.103.1674684608381; Wed, 25
 Jan 2023 14:10:08 -0800 (PST)
MIME-Version: 1.0
References: <20221027092036.2698180-1-pbonzini@redhat.com> <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com> <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com>
In-Reply-To: <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Jan 2023 14:09:56 -0800
Message-ID: <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 1:46 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/25/23 17:47, Jim Mattson wrote:
> >> Part of the definition of the API is that you can take
> >> KVM_GET_SUPPORTED_CPUID and pass it to KVM_SET_CPUID2 for all vCPUs.
> >> Returning host topology information for a random host vCPU definitely
> >> violates the contract.
> >
> > You are attempting to rewrite history.  Leaf 0xB was added to > KVM_GET_SUPPORTED_CPUID in commit 0771671749b5 ("KVM: Enhance guest
> > cpuid management"), and the only documentation of the
> > KVM_GET_SUPPORTED_CPUID ioctl at that time was in the commit message:
> >
> >       - KVM_GET_SUPPORTED_CPUID: get all cpuid entries the host (and kvm)
> >         supports
> >
> > [...] the intention was to return the
> > host topology information for the current logical processor.
>
> The handling of unknown features is so naive in that commit, that I
> don't think it is possible to read anything from the implementation; and
> it certainly should not be a paragon for a future-proof implementation
> of KVM_GET_SUPPORTED_CPUID.
>
> For example, it only hid _known_ CPUID leaves or features and passed the
> unknown ones through, which you'll agree is completely broken.  It also
> didn't try to handle all leaves for which ECX might turn out to be
> significant---which happened for EAX=7 so the commit returns a wrong
> output for CPUID[EAX=7,ECX=0].EAX.
>
> In other words, the only reason it handles 0xB is because it was known
> to have subleaves.
>
> We can get more information about how userspace was intended to use it
> from the qemu-kvm fork, which at the time was practically the only KVM
> userspace.  As of 2009 it was only checking a handful of leaves:
>
> https://git.kernel.org/pub/scm/virt/kvm/qemu-kvm.git/tree/target-i386/kvm.c?h=kvm-88#n133
>
> so shall we say that userspace is supposed to build each CPUID leaf one
> by one and use KVM_GET_SUPPORTED_CPUID2 for validation only?  I think
> the first committed documentation agrees: "Userspace can use the
> information returned by this ioctl to construct cpuid information (for
> KVM_SET_CPUID2) that is consistent with hardware, kernel, and userspace
> capabilities, and with user requirements".
>
> However, that's the theory.  "Do not break userspace" also involves
> looking at how userspace *really* uses the API, and make compromises to
> cater to those uses; which is different from rewriting history.
>
> And in practice, people basically stopped reading after "(for
> KVM_SET_CPUID2)".
>
> For example in kvmtool:
>
>         kvm_cpuid->nent = MAX_KVM_CPUID_ENTRIES;
>         if (ioctl(vcpu->kvm->sys_fd, KVM_GET_SUPPORTED_CPUID, kvm_cpuid) < 0)
>                 die_perror("KVM_GET_SUPPORTED_CPUID failed");
>
>         filter_cpuid(kvm_cpuid, vcpu->cpu_id);
>
>         if (ioctl(vcpu->vcpu_fd, KVM_SET_CPUID2, kvm_cpuid) < 0)
>                 die_perror("KVM_SET_CPUID2 failed");
>
> where filter_cpuid only does minor adjustments that do not include 0xB,
> 0x1F and 0x8000001E.  The result is a topology that makes no sense if
> host #vCPUs != guest #vCPUs, and which doesn't include the correct APIC
> id in EDX.
>
> https://github.com/kvmtool/kvmtool/blob/5657dd3e48b41bc6db38fa657994bc0e030fd31f/x86/cpuid.c
>
>
> crosvm does optionally attempt to pass through leaves 0xB and 0x1F, but
> it fails to adjust the APIC id in EDX.  On the other hand it also passes
> through 0x8000001E if ctx.cpu_config.host_cpu_topology is false,
> incorrectly.  So on one hand this patch breaks host_cpu_topology ==
> true, on the other hand it fixes host_cpu_topology == false on AMD
> processors.
>
> https://github.com/google/crosvm/blob/cc79897fc0813ee8412e6395648593898962ec82/x86_64/src/cpuid.rs#L121
>
>
> The rust-vmm reference hypervisor adjusts the APIC id in EDX for 0xB but
> not for 0x1F.  Apart from that it passes through the host topology
> leaves, again resulting in nonsensical topology for host #vCPUs != guest
> #vCPUs.
>
> https://github.com/rust-vmm/vmm-reference/blob/5cde58bc955afca8a180585a9f01c82d6277a755/src/vm-vcpu-ref/src/x86_64/cpuid.rs
>
>
> Firecracker, finally, ignores KVM_GET_SUPPORTED_CPUID's output for 0xb
> and 0x8000001E (good!) but fails to do the same for 0x1F, so this patch
> is again a fix of sorts---having all zeroes in 0x1F is better than
> having a value that is valid but inconsistent with 0xB.
>
> https://github.com/firecracker-microvm/firecracker/blob/cdf4fef3011c51206f178bdf21ececb87caa16c1/src/cpuid/src/transformer/intel.rs#L120
> https://github.com/firecracker-microvm/firecracker/blob/cdf4fef3011c51206f178bdf21ececb87caa16c1/src/cpuid/src/transformer/amd.rs#L88
>
>
> So basically the only open source userspace that is penalized (but not
> broken, and also partly fixed) by the patch is crosvm.  QEMU doesn't
> care, while firecracker/kvmtool/vmm-reference are a net positive.
>
> Paolo

The topology leaves returned by KVM_GET_SUPPORTED_CPUID *for over a
decade* have been passed through unmodified from the host. They have
never made sense for KVM_SET_CPUID2, with the unlikely exception of a
whole-host VM.

Our VMM populates the topology of the guest CPUID table on its own, as
any VMM must. However, it uses the host topology (which
KVM_GET_SUPPORTED_CPUID has been providing pass-through *for over a
decade*) to see if the requested guest topology is possible.

Changing a long-established ABI in a way that breaks userspace
applications is a bad practice. I didn't think we, as a community, did
that. I didn't realize that we were only catering to open source
implementations here.
