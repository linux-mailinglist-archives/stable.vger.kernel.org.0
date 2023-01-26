Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A59D67D0E2
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 17:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbjAZQGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 11:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjAZQGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 11:06:30 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1424139
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 08:06:28 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-16346330067so2947492fac.3
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 08:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uDaQuB4zE4KgnrjX+Hk1otko+7yWJI0zZ43Q4BlCXeU=;
        b=FvKjmv9dkMM+tpDvvzMCCbED7aweIL0vxA7Pq6UdpBOrgaZpwRfIGfLvvX4jEJncUU
         8+2+9fnBNQ+H4Tsv2ed5+QzmuHAi/mK6A+Ng75yr/DLmP7F7seQnTY7iwtKNM8Oz7J4Y
         OEYxD2fpSW1bE7cNIM/IlhbxWjI9BJGLAOv8ntjnKtgIy7XA3aeTfwshEH7fd5yl9SUN
         dW51OLPVIOedKnVAHWNV9GPUB6o9VW0lAdS8+qZHm8yzD8Fp5q7SIA3KbjS6L1HZEXai
         4pgjvQohy2PuhdyX1RFOETamkY/DSgg0Y5r0OGaE7gM/Ijp+HPtU12mFucY+wV/rhI86
         0i7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uDaQuB4zE4KgnrjX+Hk1otko+7yWJI0zZ43Q4BlCXeU=;
        b=DSyMJHPiL0ve6NWSYdAsJK3ENKjakYDae0GGT0WePHDPC/dvh3t5sx4I8aIM9jt6s6
         D+oR67yyoSH6tjjIViMt2DIMM9mJtSIxkeHqZUhfiz7nkhfPO7GXKQN2ApMW7+II6Ae+
         35OUMUFeTfE/PMkL/lQyld12EHYZe6MdUqNynm0RiJhZgrupk1ga9yCyVWn1t2ntNkr+
         01XL7uzzrrLGXbKLKmYc8bdtV3aZ6FK72ShqX4V0UcVj34px7TtElSgUcTRIkPDUvLhh
         kjfCDvj/09IhKm0P0mOQDLqj8f2ua7O8ugvnl7EeVSblB1IEfucwXoQ9KEk8gHGkJkNN
         L31Q==
X-Gm-Message-State: AO0yUKWIeaZxkhJvDNH3wpefgnibo+nUExHV+g1l3pTCW4KeHruaM3E1
        ytXATtzqUwvhabsuHHdOvyUi4CmquHY7skKWxXKIxUMAc4DRqFL4
X-Google-Smtp-Source: AK7set9VZ06xcui/dvBDxFkmeE+ae9XkXiqX3CM6kmHHw7gakmOYA97DzNO38U65Pxgnuw5b9Wnvcrz32n7BYNys6Ak=
X-Received: by 2002:a05:6871:6ca5:b0:160:3235:9c33 with SMTP id
 zj37-20020a0568716ca500b0016032359c33mr877063oab.103.1674749187821; Thu, 26
 Jan 2023 08:06:27 -0800 (PST)
MIME-Version: 1.0
References: <20221027092036.2698180-1-pbonzini@redhat.com> <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com> <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com> <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
 <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com> <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
 <f322cce0-f83a-16d9-9738-f47f265b41d8@redhat.com>
In-Reply-To: <f322cce0-f83a-16d9-9738-f47f265b41d8@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 26 Jan 2023 08:06:16 -0800
Message-ID: <CALMp9eTpbwQP3QsqpOBsDb0soLpsv9FZA=ivZUmf2GJgBxhfmw@mail.gmail.com>
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

On Thu, Jan 26, 2023 at 1:40 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/26/23 01:58, Jim Mattson wrote:
> >> You wrote it yourself: any VMM must either populate the topology on its
> >> own, or possibly fill it with zeros.  Returning a value that is
> >> extremely unlikely to be used is worse in pretty much every way (apart
> >> from not breaking your VMM, of course).
> >
> > I've complained about this particular ioctl more than I can remember.
> > This is just one of its many problems.
>
> I agree.  At the very least it should have been a VM ioctl.
>
> >> With a total of six known users (QEMU, crosvm, kvmtool, firecracker,
> >> rust-vmm, and the Google VMM), KVM is damned if it reverts the patch and
> >> damned if it doesn't.  There is a tension between fixing the one VMM
> >> that was using KVM_GET_SUPPORTED_CPUID correctly and now breaks loudly,
> >> and fixing 3-4 that were silently broken and are now fixed.  I will
> >> probably send a patch to crosvm, though.
> >>
> >> The VMM being _proprietary_ doesn't really matter, however it does
> >> matter to me that it is not _public_: it is only used within Google, and
> >> the breakage is neither hard to fix in the VMM nor hard to temporarily
> >> avoid by reverting the patch in the Google kernel.
> >
> > Sadly, there isn't a single kernel involved. People running our VMM on
> > their desktops are going to be impacted as soon as this patch hits
> > that distro. (I don't know if I can say which distro that is.) So, now
> > we have to get the VMM folks to urgently accommodate this change and
> > get a new distribution out.
>
> Ok, this is what is needed to make a more informed choice.  To be clear,
> this is _still_ not public (for example it's not ChromeOS), so there is
> at least some control on what version of the VMM they use?  Would it
> make sense to buy you a few months by deferring this patch to Linux 6.3-6.5?

Mainline isn't a problem. I'm more worried about 5.19 LTS.

Thanks!
