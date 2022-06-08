Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9E7543DE9
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 22:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiFHUxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 16:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiFHUxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 16:53:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71A791D08A8
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 13:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654721589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMqOytVP+gk8AwC7a473qnQFRe9VfwTYdUh9Vb7sypY=;
        b=cSApQ/+TtfcBEPOX4DtkvB8gA7h0SQe4HjnRaf/FUlFOasnu0G/2HJ9nBLZk1VZK+lOoLz
        w4bqOkuNCy5KbodPetJ4d5XmKJZ6lKRF/Vfbnvi7VrHNoFfWMoKEI29v+CsaB5KyJgKkHV
        2njqDlB4sl+hDntMjxUp7SoKAT5dBUc=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-hMoF2tJFNsmcEgAVBJcSpg-1; Wed, 08 Jun 2022 16:53:08 -0400
X-MC-Unique: hMoF2tJFNsmcEgAVBJcSpg-1
Received: by mail-il1-f199.google.com with SMTP id a3-20020a924443000000b002d1bc79da14so16436744ilm.15
        for <stable@vger.kernel.org>; Wed, 08 Jun 2022 13:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vMqOytVP+gk8AwC7a473qnQFRe9VfwTYdUh9Vb7sypY=;
        b=VvwvbUyiNSFGNnhjXIuok2XdJHiQ0sYZM4R+qagwZ+08gvTNLIERnSJG9MoeFVjld3
         WlVnaSaoQai7Y7zLAaAMH0fhldC18b+XxYMe+DJiMGX1OaDLgp56Gi9u5pcIB0TUfQzg
         u0SDP6fc8tIXE24wcT3A3o7YKG5I1sEayiCVEdGQfNxzP6XE/OHW3TOmDd9XMdtz3LlD
         zVdGiObUGl7XQACuPuCSciuJO2aRIVBTANhqqcW7kKAsZ3NHsOXtcuHctcSUKsYhjHTn
         eGqmkilqpqpZ9ih7amKzsrT/dPOpaqXL1/TGLRp9PGRmsP9jEgl4GYJH68Hp0YY7up8V
         b+ig==
X-Gm-Message-State: AOAM533zPR5IrPJUN4XUVVASehJ3dF3QmemG2F7UCro8Il6temxOdziz
        5MWuUcsF3oELaYP36b0EoZiuYytW/P7JcJMXt9DyK0gaP416H+dJ953XcLtB2R/LVT5o3bJ6ami
        TUngcR1MfaiDUBsWe
X-Received: by 2002:a6b:4013:0:b0:668:825b:1ceb with SMTP id k19-20020a6b4013000000b00668825b1cebmr17742756ioa.180.1654721587553;
        Wed, 08 Jun 2022 13:53:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxopWnsYF95s4welx4WWFq4NLuJEHYDQQYm2nwC+zbK37ryM5m2m4qZkMSC2JRt/hkCY79T6w==
X-Received: by 2002:a6b:4013:0:b0:668:825b:1ceb with SMTP id k19-20020a6b4013000000b00668825b1cebmr17742737ioa.180.1654721587236;
        Wed, 08 Jun 2022 13:53:07 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id a13-20020a92d34d000000b002d3de4c1ecbsm8918633ilh.68.2022.06.08.13.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 13:53:06 -0700 (PDT)
Date:   Wed, 8 Jun 2022 16:53:04 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Leonardo Bras Soares Passos <leobras@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 07/28] x86/kvm/fpu: Limit guest
 user_xfeatures to supported bits of XCR0
Message-ID: <YqEMMOPwc/ctL26P@xz-m1.local>
References: <20220301201344.18191-7-sashal@kernel.org>
 <5f2b7b93-d4c9-1d59-14df-6e8b2366ca8a@redhat.com>
 <YppVupW+IWsm7Osr@xz-m1.local>
 <2d9ba70b-ac18-a461-7a57-22df2c0165c6@redhat.com>
 <Yp5xSi6P3q187+A+@xz-m1.local>
 <9d336622-6964-454a-605f-1ca90b902836@redhat.com>
 <Yp9o+y0NcRW/0puA@google.com>
 <Yp+WUoA+6x7ZpsaM@xz-m1.local>
 <Yp+fBeyf7TjI1qgo@xz-m1.local>
 <CAJ6HWG7x_VA3JAsopojCq+t2-MDZ-rn4DXZqt0SoXEDxTzrRMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJ6HWG7x_VA3JAsopojCq+t2-MDZ-rn4DXZqt0SoXEDxTzrRMQ@mail.gmail.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 05:34:18PM -0300, Leonardo Bras Soares Passos wrote:
> Hello Peter,
> 
> On Tue, Jun 7, 2022 at 5:07 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Tue, Jun 07, 2022 at 02:17:54PM -0400, Peter Xu wrote:
> > > On Tue, Jun 07, 2022 at 03:04:27PM +0000, Sean Christopherson wrote:
> > > > On Tue, Jun 07, 2022, Paolo Bonzini wrote:
> > > > > On 6/6/22 23:27, Peter Xu wrote:
> > > > > > On Mon, Jun 06, 2022 at 06:18:12PM +0200, Paolo Bonzini wrote:
> > > > > > > > However there seems to be something missing at least to me, on why it'll
> > > > > > > > fail a migration from 5.15 (without this patch) to 5.18 (with this patch).
> > > > > > > > In my test case, user_xfeatures will be 0x7 (FP|SSE|YMM) if without this
> > > > > > > > patch, but 0x0 if with it.
> > > > > > >
> > > > > > > What CPU model are you using for the VM?
> > > > > >
> > > > > > I didn't specify it, assuming it's qemu64 with no extra parameters.
> > > > >
> > > > > Ok, so indeed it lacks AVX and this patch can have an effect.
> > > > >
> > > > > > > For example, if the source lacks this patch but the destination has it,
> > > > > > > the source will transmit YMM registers, but the destination will fail to
> > > > > > > set them if they are not available for the selected CPU model.
> > > > > > >
> > > > > > > See the commit message: "As a bonus, it will also fail if userspace tries to
> > > > > > > set fpu features (with the KVM_SET_XSAVE ioctl) that are not compatible to
> > > > > > > the guest configuration.  Such features will never be returned by
> > > > > > > KVM_GET_XSAVE or KVM_GET_XSAVE2."
> > > > > >
> > > > > > IIUC you meant we should have failed KVM_SET_XSAVE when they're not aligned
> > > > > > (probably by failing validate_user_xstate_header when checking against the
> > > > > > user_xfeatures on dest host). But that's probably not my case, because here
> > > > > > KVM_SET_XSAVE succeeded, it's just that the guest gets a double fault after
> > > > > > the precopy migration completes (or for postcopy when the switchover is
> > > > > > done).
> > > > >
> > > > > Difficult to say what's happening without seeing at least the guest code
> > > > > around the double fault (above you said "fail a migration" and I thought
> > > > > that was a different scenario than the double fault), and possibly which was
> > > > > the first exception that contributed to the double fault.
> > > >
> > > > Regardless of why the guest explodes in the way it does, is someone planning on
> > > > bisecting this (if necessary?) and sending a backport to v5.15?  There's another
> > > > bug report that is more than likely hitting the same bug.
> > >
> > > What's the bisection you mentioned?  I actually did a bisection and I also
> > > checked reverting Leo's change can also fix this issue.  Or do you mean
> > > something else?
> >
> > Ah, I forgot to mention on the "stable tree decisions": IIUC it also means
> > we should apply Leo's patch to all the stable trees if possible, then
> > migrations between them won't trigger the misterous faults anymore,
> > including when migrating to the latest Linux versions.
> >
> > However there's the delimma that other kernels (any kernel that does not
> > have Leo's patch) will start to fail migrations to the stable branches that
> > apply Leo's patch too..
> 
> IIUC, you commented before that the migration issue should be solved with a
> QEMU fix, is that correct? That would mean something like 'QEMU is relying on a
> kernel bug to work', and should be no blocker for fixing the kernel.

The QEMU fix (that I posted [1]) is not a real fix, only the kernel fix is.

The QEMU patchset only allows the migration to fail early, the kernel patch
allows the migration to go through with no problem as long as both sides
are applied with the fix (or both are not..).  So there're two issues we're
tackling with and IMHO we should fix both.

[1] https://lore.kernel.org/qemu-devel/20220607230645.53950-1-peterx@redhat.com/

> 
> If that's the case, I think we should apply the fix to every supported
> stable branch that
> have the fpku issue, and in parallel come with a qemu fix for that.
> 
> What do you think about it?

Yes I mostly agree with you. I think your patch still does the right thing
by not migrating anything the guest doesn't even support, and that seems to
be the only way to fix the pksu-like issue on migrations between hosts with
different processor configurations.  But it'll also bring other unwanted
side effects, that's why IMHO we need some careful thoughts and I hope I
didn't miss anything important.

Thanks,

-- 
Peter Xu

