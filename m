Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055FD6B91DA
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 12:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCNLln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 07:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbjCNLlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 07:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2269BE1B
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 04:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678794051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvUKdBCqtDsCDJokDequ8gIlKpdN3GQsgjjeCWrl9fk=;
        b=bUuruULo57o8+2WUi5O3vx5z7z1IHJtgbFujRFgpGWUpFtYtLu6bXjFV5uIJMXp2N1FJX6
        wnB/jUcMrnx7ccC7w6H2GxBjp3zYMPXIcdmdQxGmvVqHxny5JBdjyk5wXduMFY9RIAZEFA
        E+O3Na4mH5SYIKTQCQl5V+kcwj4geQw=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-wFzoZy0MOlm8i4fYyHH5dQ-1; Tue, 14 Mar 2023 07:40:50 -0400
X-MC-Unique: wFzoZy0MOlm8i4fYyHH5dQ-1
Received: by mail-ua1-f70.google.com with SMTP id p18-20020ab02a52000000b0073dfce6f0edso5126267uar.16
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 04:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678794050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvUKdBCqtDsCDJokDequ8gIlKpdN3GQsgjjeCWrl9fk=;
        b=tld13eXSc2Iimt9ihMifVsLgN2/RCDFmX3rC2LahKrYj7GJzCavnl9ni5B9M2GqZKU
         ikLG0fXpAMgAZQ2GCxThV/dMfDXEjUp0QkdHd8xAD/nHo+QyXaI12IXEVXUT5aF/ft9I
         66jzx+SmUYkiRfDlwDZSq6/0PvOwCH4CLZLpYP9JYlcG3ned4YdUxjKQLVQm08bJXa10
         0PYAuQXyvLrWVriibmsnxR5WP7Q9Y25ws3C/73IJ8sNiUgp3hY6qcg8eBXsJjDLDEY+1
         FwI7U/e+IHHU+37lyRwyH1ZMPkNIst1ZeVfVYGKPZbDoYzNgt4W3GI+yAdvopJ588i+g
         04Ng==
X-Gm-Message-State: AO0yUKVk+Uy3+mep1ZosVSfA2G7zid+Oxfy2c6Tyvz3VTrY9iM1tMYyG
        BZAYQHC5jJvmgZkEMwlCgg9E6Q6+Cxv1sX5OKskChDcjAAS1Gp8CuZoGIQxjaRZ3TlumMUqj8/u
        dfvpWpzLF0Dl7e0xtLsF8U2gyUjfUQiXp
X-Received: by 2002:a67:d08c:0:b0:425:a3a9:a6e8 with SMTP id s12-20020a67d08c000000b00425a3a9a6e8mr1680165vsi.1.1678794050023;
        Tue, 14 Mar 2023 04:40:50 -0700 (PDT)
X-Google-Smtp-Source: AK7set8m2YHyzZwKxEeDVZaI9vGT3421ek6caI5yO0ukBXyVOVG8nEWdZx1OXuEsVVYm6GXhA2bwA99fmZZJcza4we0=
X-Received: by 2002:a67:d08c:0:b0:425:a3a9:a6e8 with SMTP id
 s12-20020a67d08c000000b00425a3a9a6e8mr1680153vsi.1.1678794049787; Tue, 14 Mar
 2023 04:40:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230310234304.2908714-1-pbonzini@redhat.com> <ZAvGjCqfKgsSEQhZ@google.com>
In-Reply-To: <ZAvGjCqfKgsSEQhZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 14 Mar 2023 12:40:38 +0100
Message-ID: <CABgObfbwAe3ut18bS2u05pAgDoUvix_N9LKMb1iBcx8xNd9dMQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: add missing consistency checks for CR0 and CR4
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Reima ISHII <ishiir@g.ecc.u-tokyo.ac.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 1:17=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > @@ -3047,6 +3047,19 @@ static int nested_vmx_check_guest_state(struct k=
vm_vcpu *vcpu,
> >                                          vmcs12->guest_ia32_perf_global=
_ctrl)))
> >               return -EINVAL;
> >
> > +     if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) =3D=3D X86=
_CR0_PG))
> > +             return -EINVAL;
> > +
> > +#ifdef CONFIG_X86_64
>
> The #ifdef isn't necessary, attempting to set for a 32-bit host should be=
 rejected
> by nested_vmx_check_controls() since nested_vmx_setup_ctls_msrs() clears =
the bit.
> Ditto for the host logic related to VM_EXIT_HOST_ADDR_SPACE_SIZE, which l=
ooks
> suspiciously similar ;-)

Yeah, I noticed that too and decided that the idea could have been to
allow some dead code elimination on 32-bit kernels, so I copied what
the host state checks were doing. But if you prefer the more compact
way I am absolutely not going to complain.

> > +     if (CC(ia32e &&
> > +            (!(vmcs12->guest_cr4 & X86_CR4_PAE) ||
> > +             !(vmcs12->guest_cr0 & X86_CR0_PG))))
> > +             return -EINVAL;
>
> This is a lot easier to read IMO, and has the advantage of more precisely
> identifying the failure in the tracepoint.
>
>         if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
>             CC(ia32e && !(vmcs12->guest_cr4 & X86_CR0_PG)))
>                 return -EINVAL;

Looks good.  I squashed everything in.

Paolo

