Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC14E6E2B06
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjDNURd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjDNURc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:17:32 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E8065B8
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 13:17:30 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f1ffb8ccfso168256297b3.9
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 13:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681503450; x=1684095450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/5C5pFTMpWmw6q1ESZeLufu8w/TNW0cEsKrwVB2i8I=;
        b=VVcKhSAMi40wRLT8awQx5mrC895yRH5nNqowq2lpmFwUT+BOgRMC515AyE0PGXpiQA
         HLQB9s1kZNWeYDSXZ2ujzXLeLYfD8Gf9luhbBMRtqoRByPxo4hFaVwPovcBoaB2BkfEB
         g3+UilnZ/twp+pWbku7EF/EC/KdhLi+xkSGMWoj8YSa/3wJJ+aDvqU34svBGSYTA/2NU
         nxUj3ITKnnAeHIpF8X3047pu3g9+PBL4bFOA4nzmcSK0pQAHd6miLNi/vRs2YfsumGKn
         5/n+Zh2EywjqWgTQ6po4iCVr3zwUyObFyeoPfPS9ox7f6U6QFxPz8AgFqNywHDjsg0HZ
         egbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681503450; x=1684095450;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y/5C5pFTMpWmw6q1ESZeLufu8w/TNW0cEsKrwVB2i8I=;
        b=BMba0YMyM/HV6xgGYPIUrnaoBkEom5jQNuBxJ5fwmthCX8gLQD7t91+Rh+DKoQe09X
         a9uqcwO5lxCd0RrgUM8TMHp+uMgBy9mYn+VApz7X9I0jv+FSpfuEJWitlkKPMvmP3Yc8
         cO66u5leGRxTcTKqr39s8Vw5qrBb06JPL7tUpH7I4wy3QGC9ZE3+R4Ylc6NFruHzecqQ
         NneV+ZXfssHk337V0quQJwe06sjtHXy6eUPZA+lxybBglKizCuGEroF3uV9KgYjfCTlk
         mH+hoZPyIbTPXGGSFmbdpFcjmOX1aFStGNZl27L6IOHsfpL2WdE3X9+a5LCQOUiFXO3S
         ZvMQ==
X-Gm-Message-State: AAQBX9fVU3NQU1PB7TvlNjYWtGfrg7cl1ihYRekczH0HOeDc5mjVMq0z
        ije1Dx8ooveWyLZytHLJm1ixscePlrM=
X-Google-Smtp-Source: AKy350YoxNXEfnS9yH8K+WuYVv8a5aD5F6GKq+hwQ1zTgCg7AqDRSJ8w3a+/kyls4mpLBzOqXTcmyG+/wuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:706:b0:545:5f92:f7ee with SMTP id
 bs6-20020a05690c070600b005455f92f7eemr4642509ywb.2.1681503450151; Fri, 14 Apr
 2023 13:17:30 -0700 (PDT)
Date:   Fri, 14 Apr 2023 13:17:28 -0700
In-Reply-To: <20230414200941.GA6776@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Mime-Version: 1.0
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net> <ZB7oKD6CHa6f2IEO@kroah.com>
 <ZC4tocf+PeuUEe4+@google.com> <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
 <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net> <ZDmEGM+CgYpvDLh6@google.com>
 <20230414200941.GA6776@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Message-ID: <ZDm02GVx0/tiIoiM@google.com>
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP users
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Mathias Krause <minipli@grsecurity.net>, Greg KH <greg@kroah.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023, Jeremi Piotrowski wrote:
> On Fri, Apr 14, 2023 at 09:49:28AM -0700, Sean Christopherson wrote:
> > +Jeremi
> > 
> 
> Adding myself :)

/facepalm

This isn't some mundane detail, Michael!!!

> > On Fri, Apr 14, 2023, Mathias Krause wrote:
> 
> ...
> 
> > > OTOH, the backports give nice speed-ups, ranging from ~2.2 times faster
> > > for pure EPT (legacy) MMU setups up to 18(!!!) times faster for TDP MMU
> > > on v5.10.
> > 
> > Anyone that's enabling the TDP MMU on v5.10 is on their own, we didn't enable the
> > TDP MMU by default until v5.14 for very good reasons.
> > 
> > > I backported the whole series down to v5.10 but left out the CR0.WP
> > > guest owning patch+fix for v5.4 as the code base is too different to get
> > > all the nuances right, as Sean already hinted. However, even this
> > > limited backport provides a big performance fix for our use case!
> > 
> > As a compromise of sorts, I propose that we disable the TDP MMU by default on v5.15,
> > and backport these fixes to v6.1.  v5.15 and earlier won't get "ludicrous speed", but
> > I think that's perfectly acceptable since KVM has had the suboptimal behavior
> > literally since EPT/NPT support was first added.
> > 
> 
> Disabling TDP MMU for v5.15, and backporting things to v6.1 works for me.
> 
> > I'm comfortable backporting to v6.1 as that is recent enough, and there weren't
> > substantial MMU changes between v6.1 and v6.3 in this area.  I.e. I have a decent
> > level of confidence that we aren't overlooking some subtle dependency.
> > 
> > For v5.15, I am less confident in the safety of a backport, and more importantly,
> > I think we should disable the TDP MMU by default to mitigate the underlying flaw
> > that makes the 18x speedup possible.  That flaw is that KVM can end up freeing and
> > rebuilding TDP MMU roots every time CR0.WP is toggled or a vCPU transitions to/from
> > SMM.
> > 
> 
> The interesting thing here is that these CR0.WP fixes seem to improve things
> with legacy MMU as well, and legacy MMU is not affected/touched by [3].

Yep, that's totally expected.  The final patch in this series allows KVM to elide
VM-Exits when the guest toggles CR0.WP (but only on Intel hardware).  Avoiding
VM-Exit entirely is a big performance win when the guest is constantly toggling
CR0.WP, e.g. each exit is roughly 1500 cycles, versus probalby something like ~50
for a native write to CR0.WP.

> So I think you can consider Mathias' ask independent of disabling TDP MMU. On the one
> hand: there is no regression here. On the other: the gain is big and seems important
> to him.

Ya, that's the compromise I am proposing.  Give v6.1 the full tune-up, but only
do the super safe change for v5.15.
