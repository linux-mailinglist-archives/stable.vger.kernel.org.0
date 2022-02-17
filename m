Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0F4BAB37
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 21:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbiBQUna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 15:43:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiBQUna (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 15:43:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEB815C9D8
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 12:43:15 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s24so5386817edr.5
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 12:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R4HSynY+GXD3vvbZ57eqLTHLNIFY/JTbAe+61rsZUWQ=;
        b=mjICA68i4LOmyP3tUQUOzGui3EbhuY2aprlcHIZSLWaJ8jt6kABk6AtxAMqpFqkL6J
         RCe98mtXnoqQAId+IK8SZl23y6FH7hnNd1Jt0qFqnhvTSiljon62CD+CwbMnEZZ1EDr7
         ruYj8FBZJPGOuN3oJRjLgKEZl37/fJ4k8X6VJTi6RccFlrU2+LkCDfwT1/1JTAQUZhbJ
         4Q7grk7QjB5dpjpNFD1XuIKDk22hQVGh4HpbqV6AeWkMNjC+Z5oBNXRyxIToFdsu2Uxw
         9Da9QNEffTjNLeMS9ys69pi9L+Zlv64vlf36ZjyjLL0aXHAs7+c1I3Rtt8Y8nwoP7dA/
         evng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R4HSynY+GXD3vvbZ57eqLTHLNIFY/JTbAe+61rsZUWQ=;
        b=NCQy0jWhHQwJ1iF4+lEb78UsdYOA6CvTk/UguOO179obrDiwY5W+kZo4TVwfK5+D0Q
         UoYFr5FuOwNOMZRwFWovTkONl4E5gQ1XA70DMc1LkBLzRRayjk9Ld/bww1TJx45R4pKH
         KlfE35zxj58CHqy9d/dCksf+zNS19M8KRk8Wc7uUM44OXTEqdH6UiuKAll0p3/nCDanM
         v4AYHpuD11oTYv1klLOxpMyz/xuakWgTTs+QTF9o/flQn8qJEHAp2Z9H4YRZN3ODPKIA
         XXuDo20KMaNMqZDTQU39ij1Y+NTakdDbUJA0+0fCsd5L1zA2lrFg5qI70fshZPA5kJ9p
         kuuw==
X-Gm-Message-State: AOAM531RZ8rdVjMOuZHaZmdJWUZtxSqsIFiFMvaOIFtAqQIOSXI3OLP0
        0eHWMPp8c6XDENdoY6efT8cAqHDQnX9doS/H+zSUsHjReUdNTg==
X-Google-Smtp-Source: ABdhPJyTQgO7iqJkUzWAlSYB5GmLHbjB1cEU2G7w8HQE52DlkjhI7q7pXYTwU8IHj4uk1jbdjTkF8ILDYYnw9KskAM8=
X-Received: by 2002:aa7:cd81:0:b0:410:d64e:aa31 with SMTP id
 x1-20020aa7cd81000000b00410d64eaa31mr4594705edv.167.1645130593426; Thu, 17
 Feb 2022 12:43:13 -0800 (PST)
MIME-Version: 1.0
References: <543efc25-9b99-53cd-e305-d8b4d917b64b@intel.com>
 <20220215192233.8717-1-bgeffon@google.com> <YgwCuGcg6adXAXIz@kroah.com>
 <CADyq12wByWhsHNOnokrSwCDeEhPdyO6WNJNjpHE1ORgKwwwXgg@mail.gmail.com>
 <YgzMTrVMCVt+n7cE@kroah.com> <fc86d51c-7aa2-6379-5f26-ad533c762da3@intel.com>
 <CADyq12yGvqbb3+hp6f39RqyEM3Mu896yY6ik7Lh39W=o44bYbA@mail.gmail.com> <dbe8b78e-bc55-c796-358f-a93e0eac87d1@intel.com>
In-Reply-To: <dbe8b78e-bc55-c796-358f-a93e0eac87d1@intel.com>
From:   Brian Geffon <bgeffon@google.com>
Date:   Thu, 17 Feb 2022 15:42:37 -0500
Message-ID: <CADyq12y8eG63C5Fs4q8-HmjYzTRQaiNZKMoVDA6qtBnvAqsgfg@mail.gmail.com>
Subject: Re: [PATCH stable 5.4,5.10] x86/fpu: Correct pkru/xstate inconsistency
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Willis Kung <williskung@google.com>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        "# v4 . 10+" <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 11:44 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 2/17/22 05:31, Brian Geffon wrote:
> > How would you and Greg KH like to proceed with this? I'm happy to help
> > however I can.
>
> If I could wave a magic wand, I'd just apply the whole FPU rewrite to
> stable.
>
> My second choice would be to stop managing PKRU with XSAVE.
> x86_pkru_load() uses WRPKRU instead of XSAVE and keeps the task's PKRU
> in task->pkru instead of the XSAVE buffer.  Doing that will take some
> care, including pulling XFEATURE_PKRU out of the feature mask (RFBM) at
> XRSTOR.  I _think_ that can be done in a manageable set of patches which
>  will keep stable close to mainline.  I recognize that more bugs might
> get introduced in the process which are unique to stable.

Hi Dave,
I did take some time to look through that series and pick out what I
think is the minimum set that would pull out PKRU from xstate, that
list is:

   9782a712eb  x86/fpu: Add PKRU storage outside of task XSAVE buffer
   784a46618f   x86/pkeys: Move read_pkru() and write_pkru()
   ff7ebff47c59  x86/pkru: Provide pkru_write_default()
   739e2eec0f   x86/pkru: Provide pkru_get_init_value()
   fa8c84b77a   x86/cpu: Write the default PKRU value when enabling PKE
   72a6c08c44  x86/pkru: Remove xstate fiddling from write_pkru()
   2ebe81c6d8  x86/fpu: Dont restore PKRU in fpregs_restore_userspace()
   71ef453355   x86/kvm: Avoid looking up PKRU in XSAVE buffer
   954436989c  x86/fpu: Remove PKRU handling from switch_fpu_finish()
   e84ba47e31  x86/fpu: Hook up PKRU into ptrace()
   30a304a138  x86/fpu: Mask PKRU from kernel XRSTOR[S] operations
   0e8c54f6b2c  x86/fpu: Don't store PKRU in xstate in fpu_reset_fpstate()

The majority of these don't apply cleanly to 5.4, and there are some
other patches we'd have to pull back too that moved code and some of
the those won't be needed for 5.10 though. TBH, I'm not sure it makes
sense to try to do this just given the fact that most do not cleanly
apply.

Brian

>
> If you give that a shot and realize that it's not feasible to do a
> subset, then we can fall back to the minimal fix.  I'm not asking for a
> multi-month engineering effort here.  Maybe an hour or two to see if
> it's really as scary as it looks.
