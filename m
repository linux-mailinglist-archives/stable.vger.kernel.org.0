Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F42067D6BA
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 21:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjAZUrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 15:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjAZUrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 15:47:05 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CA573768
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:46:29 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id r205so2492908oib.9
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 12:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=65oEAScgUYAE8KruWPSkfRMTnDB8eV6fK8VEQc/uLFA=;
        b=OqPzMccJcZnZGD9WSHYzTRHjKzY/peIuHLKTZxjF1SbpcroX3gmzt1cOZAaiQP3hgg
         rEuzMwJ/xit6Z5huIjjhSuVMiajhrnubGWfIVXjx4T+t1jke2LskACy5zWmEBSSWo8tg
         OgSKk5lEsAkCjtQO7/kxN428i4RPZ50qavFbsKL4JS9yry7KYQZmTeqZaH3sfQp460bU
         FyczWfAVEx012VR5UUajmVfsfT1iW7fmPDFo/1N1n0deBP2zk+bron3Ws9MPuvht0vSi
         8rdlRN76OWBrwc2N/sUPOWaadU7g5vDdEF867B1zDD246YOr3TD57eO86++Z1koYN4J5
         DrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=65oEAScgUYAE8KruWPSkfRMTnDB8eV6fK8VEQc/uLFA=;
        b=Za4NZ6J06khtAsPtUU5otXhl8xxf89tEmXUwluGrXxP4KT7XT2kqTonWN6k7g3E5ZQ
         +cq4pwFbTo1jFWEFwfWLo8P5V+csCjCleihxsR0cNXra3xjj87IdS3iJ8MpIQdZFnaKR
         pdfV4ljZCLxuha/JRjfGaASAyvBvkclohfCtkcWKqvV9Xg2vOJ9x/3/VdbZxTReAdgsW
         7xje+uBjJggkn5d3KL6HQyFakn3K4dpOyvtVlyYbLsvWU4qlXqHPSEyzrfOCON367K6R
         kIpWMN7fIHk00tL/2PbqHVbQlwoo/rf6NwGCf7O8RgGiswZNub1zZtmwz2WkRDKcPrw+
         2UuA==
X-Gm-Message-State: AFqh2krHOgeDMbkP6l7fEsGmBIMed9u2fxEoYp3w4845ajIUGC4HpeZ7
        agDgmJpkustYqNYRXUf2ZRCn/IgBEYQNwAFgQZQ5AA==
X-Google-Smtp-Source: AMrXdXs/BatnkOGFZ9IZFzSNd4aanhUQg5HHDKCp9DO+wxxsB56W1plvWBP556Lm07LkTjYUGD+fX439sciWUe3T6KA=
X-Received: by 2002:aca:efc6:0:b0:36e:b85f:6081 with SMTP id
 n189-20020acaefc6000000b0036eb85f6081mr1299293oih.103.1674765970022; Thu, 26
 Jan 2023 12:46:10 -0800 (PST)
MIME-Version: 1.0
References: <20221027092036.2698180-1-pbonzini@redhat.com> <CALMp9eQihPhjpoodw6ojgVh_KtvPqQ9qJ3wKWZQyVtArpGkfHA@mail.gmail.com>
 <3a23db58-3ae1-7457-ed09-bc2e3f6e8dc9@redhat.com> <CALMp9eQ3wZ4dkq_8ErcUdQAs2F96Gvr-g=7-iBteJeuN5aX00A@mail.gmail.com>
 <8bdf22c8-9ef1-e526-df36-9073a150669d@redhat.com> <CALMp9eRKp_4j_Q0j1HYP2itT2+z3pRotQK8LwScMsaGF5FpARA@mail.gmail.com>
 <dec8c012-885a-6ed8-534e-4a5f0a435025@redhat.com> <CALMp9eSyVWGS2HQVwwwViE6S_uweiOiFucqa3keuoUjNz9rKqA@mail.gmail.com>
 <f322cce0-f83a-16d9-9738-f47f265b41d8@redhat.com> <CALMp9eTpbwQP3QsqpOBsDb0soLpsv9FZA=ivZUmf2GJgBxhfmw@mail.gmail.com>
 <b3820c5c-370b-44f1-7dac-544e504bc61a@redhat.com>
In-Reply-To: <b3820c5c-370b-44f1-7dac-544e504bc61a@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 26 Jan 2023 12:45:58 -0800
Message-ID: <CALMp9eQe__xPe9JjgpN_jq-zB2UUqBKYrrMpGvJOjohT=gK2=Q@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Do not return host topology information from KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 9:47 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 1/26/23 17:06, Jim Mattson wrote:
> >>> Sadly, there isn't a single kernel involved. People running our VMM on
> >>> their desktops are going to be impacted as soon as this patch hits
> >>> that distro. (I don't know if I can say which distro that is.) So, now
> >>> we have to get the VMM folks to urgently accommodate this change and
> >>> get a new distribution out.
> >>
> >> Ok, this is what is needed to make a more informed choice.  To be clear,
> >> this is _still_ not public (for example it's not ChromeOS), so there is
> >> at least some control on what version of the VMM they use?  Would it
> >> make sense to buy you a few months by deferring this patch to Linux 6.3-6.5?
> >
> > Mainline isn't a problem. I'm more worried about 5.19 LTS.
>
> 5.19 is not LTS, is it?  This patch is only in 6.1.7 and 6.1.8 as far as
> stable kernels is concerned, should I ask Greg to revert it there?

It came to my attention when commit 196c6f0c3e21 ("KVM: x86: Do not
return host topology information from KVM_GET_SUPPORTED_CPUID") broke
some of our tests under 5.10 LTS.

If it isn't bound for linux-5.19-y, then we have some breathing room.
