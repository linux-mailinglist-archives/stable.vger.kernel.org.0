Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4AE67C21A
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 01:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbjAZA6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 19:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjAZA6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 19:58:53 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF5C5CFFC
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 16:58:52 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-15f64f2791dso699954fac.7
        for <stable@vger.kernel.org>; Wed, 25 Jan 2023 16:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=erjiEkZ9D43eAKN0jnPh/XHVutvD1e0c37Mj/PZ/I90=;
        b=LADojTLzWfF4+JTwfjq4BL3FNGteMKzy9i0qwRgH34cA6sGXD/h+1MWzDT9mGzAqAI
         /ebaYb3SOJdEg9N3FAJ2nTQQewzMEUuMgMd67VNrpnooR9IBwpk8zNToj/GiVVqKNdX4
         H4qTBOUgt5zf0CN3bQMwVj5vnhOTKv6eJmNiYUjrassnxjYjWgd1K1xzQn/G7za7eTpN
         e0T0as5FqNXeHC1DsL7FBIJ3tVh96aNrVrrCHVLXA1y9cuKOtPyPfmYsvuGtJaoHJHKh
         XeUkOaJAQ1Y6TIFLb6eyZF/2p3sRteXIW0k+PG2s5NvA+B8USExLMZQ1Lf5ACvpNDu1l
         8E3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=erjiEkZ9D43eAKN0jnPh/XHVutvD1e0c37Mj/PZ/I90=;
        b=UiGMAByZUqia5BvW/jz7ZuJsRG0W5lps6nJ5FzzVxMo5xGja7WuFUdM4M/4rf2GAfh
         rKrhliOPfH8hqHnvii/ZufXDP/QvX+M3Xt4J2qvHUarzlZv/2gnj8rRJNeqb851El7DC
         nGCshwWBIU4QYOpTMX54AmLXY3sbMud72JRAtti9iWL0IaNecvFYybX0a6wU97XDYRr8
         Aoh4yIlWz09c6TbB8oQ2G4rP+/RkOyYncK7aRfchH4ZZlFOEXcH8BYEvCHRNO7jU71s7
         YRqzaeKnqODfrOFHaw530LCcsDLYVOBzu5Gd1Km8e4ZgkCfFd4oYofx/SZGlDv7lprM2
         c6vw==
X-Gm-Message-State: AO0yUKU/4SidTi4MhaW9TOrAbwGWQ3f2T6D+ccQANXgTrjCQcgxgoYbZ
        LwuDUazvj5SaxcFAelMHN+TFQIGIme1Iz/O0PL6vEg==
X-Google-Smtp-Source: AK7set9L6/IA9Gj8L+AYOTlQdt7smnu5QUEFf0dssjEPi4hJqca5hVmTRAjgASZWpf9AlBr/WrV+g5rg4U0dmBFAhhU=
X-Received: by 2002:a05:6871:6ca5:b0:160:3235:9c33 with SMTP id
 zj37-20020a0568716ca500b0016032359c33mr675619oab.103.1674694731192; Wed, 25
 Jan 2023 16:58:51 -0800 (PST)
MIME-Version: 1.0
References: <20221027092036.2698180-1-pbonzini@redhat.com> <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com> <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com> <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
 <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com>
In-Reply-To: <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Jan 2023 16:58:40 -0800
Message-ID: <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
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

On Wed, Jan 25, 2023 at 2:44 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/25/23 23:09, Jim Mattson wrote:
> > The topology leaves returned by KVM_GET_SUPPORTED_CPUID *for over a
> > decade* have been passed through unmodified from the host. They have
> > never made sense for KVM_SET_CPUID2, with the unlikely exception of a
> > whole-host VM.
>
> True, unfortunately people have not read the nonexistent documentation
> and they are:
>
> 1) rarely adjusting correctly all of 0xB, 0x1F and 0x8000001E;
>
> 2) never bounding CPUID[EAX=0].EAX to a known CPUID leaf, resulting for
> example in inconsistencies between 0xB and 0x1F.
>
> *But* (2) should not be needed unless you care about maintaining
> homogeneous CPUID within a VM migration pool.  For something like
> kvmtool, having to do (2) would be a workaround for the bug that this
> patch fixes.

Maybe we should just populate up to leaf 3. :-)

> > Our VMM populates the topology of the guest CPUID table on its own, as
> > any VMM must. However, it uses the host topology (which
> > KVM_GET_SUPPORTED_CPUID has been providing pass-through *for over a
> > decade*) to see if the requested guest topology is possible.
>
> Ok, thanks; this is useful to know.
>
> > Changing a long-established ABI in a way that breaks userspace
> > applications is a bad practice. I didn't think we, as a community, did
> > that. I didn't realize that we were only catering to open source
> > implementations here.
>
> We aren't.  But the open source implementations provide some guidance as
> to how the API is being used in the wild, and what the pitfalls are.
>
> You wrote it yourself: any VMM must either populate the topology on its
> own, or possibly fill it with zeros.  Returning a value that is
> extremely unlikely to be used is worse in pretty much every way (apart
> from not breaking your VMM, of course).

I've complained about this particular ioctl more than I can remember.
This is just one of its many problems.

> With a total of six known users (QEMU, crosvm, kvmtool, firecracker,
> rust-vmm, and the Google VMM), KVM is damned if it reverts the patch and
> damned if it doesn't.  There is a tension between fixing the one VMM
> that was using KVM_GET_SUPPORTED_CPUID correctly and now breaks loudly,
> and fixing 3-4 that were silently broken and are now fixed.  I will
> probably send a patch to crosvm, though.
>
> The VMM being _proprietary_ doesn't really matter, however it does
> matter to me that it is not _public_: it is only used within Google, and
> the breakage is neither hard to fix in the VMM nor hard to temporarily
> avoid by reverting the patch in the Google kernel.

Sadly, there isn't a single kernel involved. People running our VMM on
their desktops are going to be impacted as soon as this patch hits
that distro. (I don't know if I can say which distro that is.) So, now
we have to get the VMM folks to urgently accommodate this change and
get a new distribution out.
