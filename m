Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9202F51515E
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 19:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379415AbiD2RMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 13:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379360AbiD2RMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 13:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 206BED17D7
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651252151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bR7U7XKW06Rd0hYKWp18hOYc2jittIlTjeGYl3Ta7P4=;
        b=OCI1sK17OTqD91AUQxT7vL5HY28/vJ9p9htgQlF7phfXxZ0oMu8IF+Tf189Ry0U5LxlX2x
        K6HXQGZqVDnZ2x6GNyO4c1KD74+XdKqHEB+JtIF0s/au0tuOuUZVCgKWag2ZLo1CliEm7l
        It9A1NtJMxIr0eBZpFzYyYDNmk9ViAE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-Wiwv7a_GPC-R0BEC334_mQ-1; Fri, 29 Apr 2022 13:09:09 -0400
X-MC-Unique: Wiwv7a_GPC-R0BEC334_mQ-1
Received: by mail-ej1-f72.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso4843564ejc.18
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 10:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bR7U7XKW06Rd0hYKWp18hOYc2jittIlTjeGYl3Ta7P4=;
        b=GTV8cOMGz2pG5IkOkAF/RhqNpylu5iJ7ldJHr43qy497Oc6CTYL3FJij6NZSudIM/H
         4Y7x5pUOoEn/2MUP4x35WvGN86JdX+MceDtPwRa/7ms1laz7tV850DP3K7vkJoXyxJoj
         +NZE6oVVEaYd0DU1tFXRrlDNnRe5CZSiy0VNxCh5OJrAhX/ADDtu2DB6DPlmftmr0g7h
         xddukIDjfbnUyrP1EPvSmj42aFR4LfL+EERetUnwRrPopkY3rGRe7FUHQy56Wsh/Mc3w
         0hl9tvMhlaJjYGwQUJqoqxP/VxHfxhTSx638E1El9IIEWuQCATHyelSyW183d1sPwCx/
         1P5Q==
X-Gm-Message-State: AOAM533JHLrB7ObqRMkbiXbLHKY5ouxAWoAWP1SqNwPJcc9SPiw3NLjF
        vbq5Te/IRJ+42Gd1ydJkBZkWO78/TabcBTTQLW8agCkFgTf77UDZGS43XYdDe9VugLEKOoqUGXr
        24G7NJVZX+7AbsqhJ
X-Received: by 2002:a05:6402:5114:b0:423:f33d:b3c with SMTP id m20-20020a056402511400b00423f33d0b3cmr196215edd.199.1651252148326;
        Fri, 29 Apr 2022 10:09:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgSmtYizJefurAotPaAGKxQWAIKDpoKa9RhzQgBMvyNJAu2o8gugfd+deHOvkf9pb1W9NpYQ==
X-Received: by 2002:a05:6402:5114:b0:423:f33d:b3c with SMTP id m20-20020a056402511400b00423f33d0b3cmr196192edd.199.1651252148063;
        Fri, 29 Apr 2022 10:09:08 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id g14-20020a056402180e00b0042617ba6389sm3115953edy.19.2022.04.29.10.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 10:09:07 -0700 (PDT)
Message-ID: <0b554e22-6766-8299-287c-c40240c08536@redhat.com>
Date:   Fri, 29 Apr 2022 19:09:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] KVM: x86: make vendor code check for all nested
 events
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, stable@vger.kernel.org
References: <20220427173758.517087-1-pbonzini@redhat.com>
 <20220427173758.517087-2-pbonzini@redhat.com> <YmwaVY5vERO43CRI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YmwaVY5vERO43CRI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/29/22 19:03, Sean Christopherson wrote:
> This doesn't even compile...
> 
> arch/x86/kvm/vmx/nested.c: In function ‘vmx_has_nested_events’:
> arch/x86/kvm/vmx/nested.c:3862:61: error: ‘vmx’ undeclared (first use in this function)
>   3862 |         return nested_vmx_preemption_timer_pending(vcpu) || vmx->nested.mtf_pending;
>        |                                                             ^~~
> arch/x86/kvm/vmx/nested.c:3862:61: note: each undeclared identifier is reported only once for each function it appears in
>    CC [M]  arch/x86/kvm/svm/svm_onhyperv.o
> arch/x86/kvm/vmx/nested.c:3863:1: error: control reaches end of non-void function [-Werror=return-type]
>   3863 | }
>        | ^
> cc1: all warnings being treated as errors
>    LD [M]  arch/x86/kvm/kvm.o

Yeah, it doesn't.  Of course this will need a v2, also because there are 
failures in the vmx tests.

What can I say, testing these patches on AMD hardware wasn't a great idea.

Paolo

