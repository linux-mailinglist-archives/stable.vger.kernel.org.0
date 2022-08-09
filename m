Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D610858DA60
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 16:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiHIOc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 10:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiHIOcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 10:32:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 867461CB2B
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 07:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660055527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BnCnqK3XkuMaWvfU+WTbvm+XzlcWU8Yyqm7Yd0LhLkE=;
        b=GON+BRbCL/tPJ3b4OmFJdHRnANTruWFbAryMTBU0i+aajOkuTZezpEKTlhXkgDV4odGLra
        thmH3O6tv0HU2m1G3+5a4j3FZARJVLYZH+w2tXZ+GzbpLFXrfJDBU65negQh9vSjzJifwP
        RdNpJzd8jQD8yrwinssP+VtTJ/Ve3mU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-ul_5qADYM7mXnnRms_QM4A-1; Tue, 09 Aug 2022 10:32:06 -0400
X-MC-Unique: ul_5qADYM7mXnnRms_QM4A-1
Received: by mail-ed1-f69.google.com with SMTP id g8-20020a056402424800b0043e81c582a4so7395083edb.17
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 07:32:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=BnCnqK3XkuMaWvfU+WTbvm+XzlcWU8Yyqm7Yd0LhLkE=;
        b=bNUJILOqxKbr1/5U1bh7gRCaThB3f9XWP2Z3fHjTGXWzhc4v+07mx2v/OuUb/kVXGn
         iFOq15t3yu4nL0pHeZJLJNtWawBfP436TFCEwUtHrNG3A4lZ2ddSrHyhFhA4zBCZtN6h
         6W+yKFdo2hCSh47C1FEPj21ePqtfLPdnbsCvyxRjF2GZh7C2WJYrIJa70synDfX4G+06
         XuaNsckda1Koky0gzFbiR8KDwAyUQI2DcT9dOveGamkstr8qZzUe6aa0XyufisoCrhwI
         FPIZJvxITR/kVC6dNBxERNo8zkB6iol3NU3azklcPZ4RLkfeQtVo9mTwpdVIX1f9k6iB
         yifw==
X-Gm-Message-State: ACgBeo14/KS5+Guw65vsQUx6kQHwS9foeEzOYw7xhKdqAmOsdIoCojQT
        A/RMfY+XKOtroGVac/wq76NWL80Cbmc/QE3YOFVgmWDYmGatolTwZonQSNTDXafMs2pTQtQjlGf
        eypDrc5ZO+TcfWaaN
X-Received: by 2002:a17:907:781a:b0:730:cd06:3572 with SMTP id la26-20020a170907781a00b00730cd063572mr17474405ejc.487.1660055525249;
        Tue, 09 Aug 2022 07:32:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5wYRs9LRq936vKKUril1vIXeztDIFofWVQmtrcvT9o55Wcn05sEztvAoT0YGyT1d3Ak9sm9A==
X-Received: by 2002:a17:907:781a:b0:730:cd06:3572 with SMTP id la26-20020a170907781a00b00730cd063572mr17474380ejc.487.1660055524915;
        Tue, 09 Aug 2022 07:32:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r27-20020a056402035b00b0043c92c44c53sm6053094edw.93.2022.08.09.07.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 07:32:03 -0700 (PDT)
Message-ID: <953d2e99-ed1a-384d-6d3a-0f656a243f82@redhat.com>
Date:   Tue, 9 Aug 2022 16:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Coleman Dietsch <dietschc@csp.edu>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com,
        metikaya <metikaya@amazon.co.uk>
References: <20220808190607.323899-2-dietschc@csp.edu>
 <20220808190607.323899-3-dietschc@csp.edu>
 <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
 <43e258cc-71ac-bde4-d1f8-9eb9519928d3@redhat.com>
 <4fc1371b83001b4eed1617c37bec6b9d007e45c2.camel@infradead.org>
 <YvJqIsQsg+ThMg/C@google.com>
 <0b5dcab333906f166fcdbc296373cc5e08bec79f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0b5dcab333906f166fcdbc296373cc5e08bec79f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 16:16, David Woodhouse wrote:
> I find the new version a bit harder to follow, with its init-then-stop-
> then-start logic:
> 
> 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
> 		if (data->u.timer.port &&
> 		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
> 			r = -EINVAL;
> 			break;
>                  }
> 
> 		if (!vcpu->arch.xen.timer.function)
> 			kvm_xen_init_timer(vcpu);
> 
> 		/* Stop the timer (if it's running) before changing the vector */
> 		kvm_xen_stop_timer(vcpu);
> 		vcpu->arch.xen.timer_virq = data->u.timer.port;


I think this is fine, if anything the kvm_xen_stop_timer() call could be 
placed in an "else" but I'm leaning towards applying this version of the 
patch.

Paolo

