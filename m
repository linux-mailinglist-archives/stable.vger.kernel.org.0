Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1C625FA1
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 17:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiKKQiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 11:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiKKQiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 11:38:04 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914C3836A8
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 08:38:03 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id z192so6497327yba.0
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 08:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kylehuey.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K6NvtIX+Lbvb+KUOrKTR0ljTcijw4msq9rtYQAvDAUk=;
        b=ZIV1Enf0EAuq2JCxnGrXKI8jk/7tY3he6qJy8sZcYtjGNNiLD0dUKQN26hcwcVr7g0
         ZHSsqZwjYd/amA7hKKNWDI9b5LZ19MVL2uGtfJ2XCvRFB4DlM9Gj7XdDctYmU/Rqnvt8
         5kasCPXeKaizIqzuDA7tWJaJx/RmSqeAsezseVn+JObhr7w+AnWOUt0cuM9yl9qdfNRo
         NOxm7kb/aTOMFj+7vJMjknh6lMSUQl08qkuBuQHNCypelX6FicXzpCsPfN44ihrZ+VP4
         bAaZI7hDq6zsG384dY8S0x+JWdVqUt+Z1OxRjg3HZXFn5EboRSLm6+ZTiDvpmh+RGCqg
         LumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6NvtIX+Lbvb+KUOrKTR0ljTcijw4msq9rtYQAvDAUk=;
        b=SH9jJDHuwBrGMIGPWeeMTdkZ7jNzyTwut3kUxyU46KQi69Z4b7P+NtgXNzw2OsFReO
         VlVjijmEZlb9jmi45NH3151fp9P43Y+9+bZxXf81hOLRcwY75WQCnK/Fm6lX5Z2/8k6f
         3XGmrC/VfhIQssf8j+tBfgjiEodLahDJquucgMzhwwA9eFv6EhdU4tNrR8EV0+M3H9TQ
         IumTUVEYugCtqGKdqOkhs8njtnHFViuGBcxk/gy15XJfYXVOW/ktuZjhvNEjlBAVKNcT
         WKw4Tm2y2zfyI7NBcnQRhTxvL+C2aJsH7LbQWGnUWrtDUgTlQrIOO0zEYPZ5Bck2kkBz
         wduQ==
X-Gm-Message-State: ANoB5plPhSMjw7lkh21WHPy+3R0Q0DB1SKWkt66aGO+EYWZVU51/iH+M
        Mx/uygc7cd6FRudWCgclArPQBsGSdziwCTHGA5GAeQ==
X-Google-Smtp-Source: AA0mqf59F1exMtt7BFu3TKN2pQsxyZEPjDy9r/NuB/KlmIuT83XtZxGvU1wIl1kHMhe4l07A5h8qeMI+Z94l5cp/ee4=
X-Received: by 2002:a5b:38b:0:b0:6cb:75a6:3bdb with SMTP id
 k11-20020a5b038b000000b006cb75a63bdbmr2407196ybp.96.1668184682697; Fri, 11
 Nov 2022 08:38:02 -0800 (PST)
MIME-Version: 1.0
References: <20221107063807.81774-1-khuey@kylehuey.com> <20221107063807.81774-2-khuey@kylehuey.com>
 <64e62ab9-71f6-6d90-24de-402921c244e7@intel.com> <CAP045ArEuTmA6DGoVEgeSRd-F+oQCqRaeyzwgdxuCnOP0jgqWA@mail.gmail.com>
 <b41b6a33-7fdc-bd54-8b15-02bf4e713ed7@intel.com>
In-Reply-To: <b41b6a33-7fdc-bd54-8b15-02bf4e713ed7@intel.com>
From:   Kyle Huey <me@kylehuey.com>
Date:   Fri, 11 Nov 2022 08:37:49 -0800
Message-ID: <CAP045Ar1WxzWy+fDLrDYR6EWCYtH=wPca+ixJ=9SGQiMZS1ALQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v6 1/2] x86/fpu: Allow PKRU to be (once again)
 written by ptrace.
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        "Robert O'Callahan" <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 10, 2022 at 5:38 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 11/10/22 16:03, Kyle Huey wrote:
> > On Tue, Nov 8, 2022 at 10:23 AM Dave Hansen <dave.hansen@intel.com> wrote:
> ...
> >> At a high level, this patch does a *LOT*.  Generally, it's nice when
> >> bugfixes can be encapsulted in one patch, but I think there's too much
> >> going on here for one patch.
> >
> > Ok. How about I break the first part into two pieces, one that changes the
> > signatures of copy_uabi_from_kernel_to_xstate() and
> > copy_sigframe_from_user_to_xstate(), and one that moves the relevant
> > KVM code from fpu_copy_uabi_to_guest_fpstate() to copy_uabi_to_xstate()
> > and deals with the edge case behavior of the mask?
>
> Sounds like a good start.  My gut says there's another patch or two that
> could be broken out, but that sounds like a reasonable next step.
>
> >>> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> >>> index 3b28c5b25e12..c273669e8a00 100644
> >>> --- a/arch/x86/kernel/fpu/core.c
> >>> +++ b/arch/x86/kernel/fpu/core.c
> >>> @@ -391,8 +391,6 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
> >>>  {
> >>>       struct fpstate *kstate = gfpu->fpstate;
> >>>       const union fpregs_state *ustate = buf;
> >>> -     struct pkru_state *xpkru;
> >>> -     int ret;
> >>>
> >>>       if (!cpu_feature_enabled(X86_FEATURE_XSAVE)) {
> >>>               if (ustate->xsave.header.xfeatures & ~XFEATURE_MASK_FPSSE)
> >>> @@ -406,16 +404,16 @@ int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf,
> >>>       if (ustate->xsave.header.xfeatures & ~xcr0)
> >>>               return -EINVAL;
> >>>
> >>> -     ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
> >>> -     if (ret)
> >>> -             return ret;
> >>> +     /*
> >>> +      * Nullify @vpkru to preserve its current value if PKRU's bit isn't set
> >>> +      * in the header.  KVM's odd ABI is to leave PKRU untouched in this
> >>> +      * case (all other components are eventually re-initialized).
> >>> +      * (Not clear that this is actually necessary for compat).
> >>> +      */
> >>> +     if (!(ustate->xsave.header.xfeatures & XFEATURE_MASK_PKRU))
> >>> +             vpkru = NULL;
> >>
> >> I'm not a big fan of hunks that are part of bugfixes where it is not
> >> clear that the hunk is necessary.
> >
> > This is necessary to avoid changing KVM's behavior at the same time
> > that we change
> > ptrace, since KVM doesn't want the same behavior as ptrace.
>
> Your "This is necessary" doesn't really match with "Not clear that this
> is actually necessary" from the comment, right?
>
> Rather than claim whether it is necessary or not, maybe just say why
> it's there: it's there to preserve wonky KVM behavior.
>
> BTW, I'd love to know if KVM *REALLY* depends on this.  It'd be nice to
> kill if not.

qemu didn't appear to (it treats the KVM_GET_XSAVE2/KVM_SET_XSAVE
buffers as opaque blobs afaict) but it's of course not the only KVM
application out there.

> >> Would something like this be more clear?
> >>
> >>         if (hdr.xfeatures & XFEATURE_MASK_PKRU) {
> >>                 struct pkru_state *xpkru;
> >>
> >>                 xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
> >>                 *pkru = xpkru->pkru;
> >>         } else {
> >>                 /*
> >>                  * KVM may pass a NULL 'pkru' to indicate
> >>                  * that it does not need PKRU updated.
> >>                  */
> >>                 if (pkru)
> >>                         *pkru = 0;
> >>         }
> >
> > Yeah, Sean Christopherson suggested this (with the else and if
> > collapsed into a single level) when I submitted this previously.
>
> I generally agree with Sean, but he's also been guilty of an atrocity or
> two over the years.  :)  While I generally like low levels of
> indentation I also think my version is much more clear in this case.
>

- Kyle
