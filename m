Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A828D6226A4
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKIJRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKIJRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:17:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48823206
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 01:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667985325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X02nRL309PhEzx0jCPIZSs9mBHARHTVVyhCWK/3u8/A=;
        b=DT+GQY+lZ2xtvTped+FBJvGW5DTjxj6Tz8e+w50U8TiuTa3dOO+Gq/6CsL0kXHEFpqHjlp
        4QM2Y+/E08nBEv/i3KEedbDWKKuw6OvZvmZyYrSBYc7/ZRjyqfyEdDQ7FSmX8EZ6BeRURo
        8wC6HEWmBPCSt3zrmLojNZp43ruqnbM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-2nruA384P4ikqsekojH-5g-1; Wed, 09 Nov 2022 04:15:23 -0500
X-MC-Unique: 2nruA384P4ikqsekojH-5g-1
Received: by mail-qt1-f199.google.com with SMTP id i13-20020ac8764d000000b003a4ec8693dcso12150242qtr.14
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 01:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X02nRL309PhEzx0jCPIZSs9mBHARHTVVyhCWK/3u8/A=;
        b=cWPPgSSektUTWW2DNj6BuxEubDJtLUQSeejF+Koh92HHr/9NIp7sywpCL+/C5l93V5
         2WRNxh2DZHjDI855Ghtr5AJZaOFZFSdUeSGgrnvzinkbsE9B7el1wSv+/eh8asSNd89M
         AapvGYH4PpbVq7ghzIKT3vjrTcnFEgZ5IpqMP8IGuaXReHuEjl2+GzlMmQCX2yp/fG5n
         uzSIzYkvTS5Ds6QMS2X8HdGOItAP9N5h38r7KX/UXIndtywx1fEZ3GcGzo41i7WrvXOm
         BQSZqYSCdcxaWkJjaFocXCrdJfwG1jBGHHSe4XLvTEoJmJBwRaGN3sl2Z5SopAghfUHm
         WQ0w==
X-Gm-Message-State: ACrzQf0zfEMiX+K8wmzWuOPLx+psUWquXX+jQGqY9PHIx1xBlng80DoI
        UpKBRhPsUpHVNKDgpOWT6EZpnKC5TaPkmMuXk/tNRxyZdUXqxmigE/NUJ3Egg50Jz+MwQpFUuD5
        XfP84qtWl47b8CLpR
X-Received: by 2002:a05:620a:22c3:b0:6ec:53bb:d296 with SMTP id o3-20020a05620a22c300b006ec53bbd296mr42354535qki.158.1667985321974;
        Wed, 09 Nov 2022 01:15:21 -0800 (PST)
X-Google-Smtp-Source: AMsMyM72DOuuaGj1I+qPxM2t/sXaQdbORDHatD+H9ZRGH21aquAj6PF1iyJoYCs45Nh/suMZZUzzMQ==
X-Received: by 2002:a05:620a:22c3:b0:6ec:53bb:d296 with SMTP id o3-20020a05620a22c300b006ec53bbd296mr42354511qki.158.1667985321736;
        Wed, 09 Nov 2022 01:15:21 -0800 (PST)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id h12-20020a05620a284c00b006cbc6e1478csm10388193qkp.57.2022.11.09.01.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:15:21 -0800 (PST)
Message-ID: <30b8e07970f2cfbba0ebee82aa3b46a047a0f43b.camel@redhat.com>
Subject: Re: [PATCH v2 9/9] KVM: x86: remove exit_int_info warning in
 svm_handle_exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Date:   Wed, 09 Nov 2022 11:15:16 +0200
In-Reply-To: <3d25a0b4-6957-d070-db11-69ec9e0132ba@oracle.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
         <20221103141351.50662-10-mlevitsk@redhat.com>
         <3d25a0b4-6957-d070-db11-69ec9e0132ba@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2022-11-06 at 15:53 +0000, Liam Merwick wrote:
> On 03/11/2022 14:13, Maxim Levitsky wrote:
> > It is valid to receive external interrupt and have broken IDT entry,
> > which will lead to #GP with exit_int_into that will contain the index of
> > the IDT entry (e.g any value).
> > 
> > Other exceptions can happen as well, like #NP or #SS
> > (if stack switch fails).
> > 
> > Thus this warning can be user triggred and has very little value.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 9 ---------
> >   1 file changed, 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index e9cec1b692051c..36f651ce842174 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3428,15 +3428,6 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> >                 return 0;
> >         }
> >   
> > -       if (is_external_interrupt(svm->vmcb->control.exit_int_info) &&
> > -           exit_code != SVM_EXIT_EXCP_BASE + PF_VECTOR &&
> > -           exit_code != SVM_EXIT_NPF && exit_code != SVM_EXIT_TASK_SWITCH &&
> > -           exit_code != SVM_EXIT_INTR && exit_code != SVM_EXIT_NMI)
> > -               printk(KERN_ERR "%s: unexpected exit_int_info 0x%x "
> > -                      "exit_code 0x%x\n",
> > -                      __func__, svm->vmcb->control.exit_int_info,
> > -                      exit_code);
> > -
> >         if (exit_fastpath != EXIT_FASTPATH_NONE)
> >                 return 1;
> >   
> 
> This was the only caller of is_external_interrupt() - should the 
> definition be removed also to avoid a 'defined but not used' warning?

I hate to say it but I have seen a warning about an unused function,
but I really didn't expect that to come from this patch.
I somehow thought that its some leftover in kvm/queue.

I'll remove the unused function in a next version.

Best regards,
	Maxim Levitsky

> 
> Regards,
> Liam
> 


