Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A758154124F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346756AbiFGTqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354471AbiFGTmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1086735844
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 11:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654625879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j3lpgWA7svbHLWKqRID/rVg39qDI+lSSGg7Fd1qcSWA=;
        b=HX337rafDRTQ40tPfGzLBm+OFRzCstT5rSuQRIdkfDNaZtP5lq48MgdiyXEEXj+sKQJ3ER
        TLhMf6ZecaY0XkG1CC9sqRBNrA0AbYusyWsDaP3bBsUqT4nB/ZHB/Ip+NtX5bNqfUQjx4Z
        sMLb2wBS1OdaJpHemI3cK0TyVWxyQDg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-Xi0GLb54OuaEwAIzmWSFow-1; Tue, 07 Jun 2022 14:17:58 -0400
X-MC-Unique: Xi0GLb54OuaEwAIzmWSFow-1
Received: by mail-io1-f70.google.com with SMTP id v22-20020a5ed716000000b006695c964f37so3256539iom.1
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 11:17:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3lpgWA7svbHLWKqRID/rVg39qDI+lSSGg7Fd1qcSWA=;
        b=Vn42Ah5ie3KBwNs+izJhCBR7Y/ohoXiMzoBfdLen4rMy8f9b51WCpiMFKquBTCCqcT
         fCOOnx+7Eei/CMcRfTmnBYpfZ4P34nNLvi/OvJBV53T/PCIkhKnX3M0IGOMc8QsIPDZu
         dUNej39raScU9DrYRjZx81Z5o3gkI/ZjCpOvOM6UDgKj9qqLg9GgJO6THxFSJkySXLfu
         mDxGrPzhPU+IKAo1lpUdAgVMZ4QLCwEsD/niJhEFIyUyhSysY5eYJMlGTg8P85hi8yV1
         AkClJokhTAyyUBkYHyyWMtpCdgLArL7DfQLnaLJj5rhfW8hXXi/ORlDmGKB55tc/kOb3
         oUGg==
X-Gm-Message-State: AOAM531W2gASOytiO8uFo3HdyAJUAiz2AlW3OWhry8nHX0PqCqM9yuEY
        /Ho8/tZ+q4IjxECcDdtf3kr4YV33cseAYgKTiKg2HLUlK0D6V0fGAQZp1YzzFDmZYY8uJ2WiCcy
        3Ura/fEd92WGoeyQK
X-Received: by 2002:a05:6602:2e8d:b0:64f:b683:c70d with SMTP id m13-20020a0566022e8d00b0064fb683c70dmr14718153iow.62.1654625877413;
        Tue, 07 Jun 2022 11:17:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaKAIwnS/XY4Pi1zuB62rXBWlJN49R3Ls7V+1ZJ6xQfMRWtnLx/TIpsFMW6h2gDggBIhCYmA==
X-Received: by 2002:a05:6602:2e8d:b0:64f:b683:c70d with SMTP id m13-20020a0566022e8d00b0064fb683c70dmr14718146iow.62.1654625877100;
        Tue, 07 Jun 2022 11:17:57 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id x8-20020a92d648000000b002d517c65c51sm4060827ilp.88.2022.06.07.11.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:17:56 -0700 (PDT)
Date:   Tue, 7 Jun 2022 14:17:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Leonardo Bras <leobras@redhat.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org,
        chang.seok.bae@intel.com, luto@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <Yp+WUoA+6x7ZpsaM@xz-m1.local>
References: <20220301201344.18191-1-sashal@kernel.org>
 <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
 <Yp5xSi6P3q187+A+@xz-m1.local>
 <9d336622-6964-454a-605f-1ca90b902836@redhat.com>
 <Yp9o+y0NcRW/0puA@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yp9o+y0NcRW/0puA@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 07, 2022 at 03:04:27PM +0000, Sean Christopherson wrote:
> On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > On 6/6/22 23:27, Peter Xu wrote:
> > > On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > > > > However there seems to be something missing at least to me, on why it'll
> > > > > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > > > > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > > > > patch, but 0x0 if with it.
> > > > 
> > > > What CPU model are you using for the VM?
> > > 
> > > I didn't specify it, assuming it's qemu64 with no extra parameters.
> > 
> > Ok, so indeed it lacks AVX and this patch can have an effect.
> > 
> > > > For example, if the source lacks this patch but the destination has it,
> > > > the source will transmit YMM registers, but the destination will fail to
> > > > set them if they are not available for the selected CPU model.
> > > > 
> > > > See the commit message: "As a bonus, it will also fail if userspace tries to
> > > > set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> > > > the guest configuration.  Such features will never be returned by
> > > > KVM_GET_XSAVE or KVM_GET_XSAVE2."
> > > 
> > > IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
> > > (probably by failing validate_user_xstate_header when checking against the
> > > user_xfeatures on dest host). But that's probably not my case, because here
> > > KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
> > > the precopy migration completes (or for postcopy when the switchover is
> > > done).
> > 
> > Difficult to say what's happening without seeing at least the guest code
> > around the double fault (above you said "fail a migration" and I thought
> > that was a different scenario than the double fault), and possibly which was
> > the first exception that contributed to the double fault.
> 
> Regardless of why the guest explodes in the way it does, is someone planning on
> bisecting this (if necessary?) and sending a backport to v5.15?  There's another
> bug report that is more than likely hitting the same bug.

What's the bisection you mentioned?  I actually did a bisection and I also
checked reverting Leo's change can also fix this issue.  Or do you mean
something else?

> 
> https://lore.kernel.org/all/48353e0d-e771-8a97-21d4-c65ff3bc4192@sentex.net

That is kvm64, and I agree it could be the same problem since both qemu64
and kvm64 models do not have any xsave feature bit declared in cpuid 0xd,
so potentially we could be migrating some fpu states to it even with
user_xfeatures==0 on dest host.

So today I continued the investigation, and I think what's really missing
is qemu seems to be ignoring the user_xfeatures check for KVM_SET_XSAVE and
continues even if it returns -EINVAL.  IOW, I'm wondering whether we should
fail properly and start to check kvm_arch_put_registers() retcode.  But
that'll be a QEMU fix, and it'll at least not causing random faults
(e.g. double faults) in guest but we should fail the migration gracefully.

Sean: a side note is that I can also easily trigger one WARN_ON_ONCE() in
your commit 98c25ead5eda5 in kvm_arch_vcpu_ioctl_run():

	WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));

It'll be great if you'd like to check that up.

Thanks,

-- 
Peter Xu

