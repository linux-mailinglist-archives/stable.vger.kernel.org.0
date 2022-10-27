Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CB60F523
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 12:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbiJ0KaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 06:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbiJ0K37 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 06:29:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3AF140C4
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666866583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j5JXrVLSkFVjgCWLE6WTZNlJEm+FHDGGhWaBYEuOMJE=;
        b=YSSAvG6HIeYDaOYX/UAOdQcr6EqCHjOJM8sb97TGgx6SECKIBOm4dNcbtA7Rqf46PDUA9y
        gjjXX3P12OXMDZ86EeyXWDTr52j/g0ZlFJqNdPXhYmRdY6q1VD7xpD61pessNjXzm5+LZw
        6npJCiz08G93JS3/SAufyYShPj4ol0w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-311-Yn4kViWgO0e00l1q5mnzhA-1; Thu, 27 Oct 2022 06:29:42 -0400
X-MC-Unique: Yn4kViWgO0e00l1q5mnzhA-1
Received: by mail-wm1-f72.google.com with SMTP id k34-20020a05600c1ca200b003c706e17799so502827wms.9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 03:29:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5JXrVLSkFVjgCWLE6WTZNlJEm+FHDGGhWaBYEuOMJE=;
        b=Fh+OuG8cNm/sSDhMhKRhi3CQb2LCi8kxanKW+4BmlrSKXwD3dEkK+uVhmg8Bzhd8PI
         oHHdoFRsQaTHuY45RPEGFxQ77rU+eoe/76V6owejxUF17DZ38PcSXsdb0u84y0tzMgNK
         lFilbm9eZI0pF7Cf/hTVoDJSDl7z32YDiPUWSTY+D6rfl/YJjzZFphfDBS2GHI1gFj3M
         yE3DKA6e+jqV9IPxYRG7pjPeerPk81h3qTTSmWE9dYbripneO36jyhCfHAmtGW+wtiQ1
         z48vTXhAl9NdEFW/FlJ2o8KgeUKLrUBSEsgxrcx0bEKx988ZkJBynM7edd002W/1iMsH
         OM+g==
X-Gm-Message-State: ACrzQf1b3AAbK+juWRyRwMZg3uezPov31U890jg9fW604iOhagVMVXcH
        G3E7UvHbW4VpwkoWHDUXny6zQrfTozd7AJD+AD9hm8gMe0wRUnkVh/7ihk+CgrdZhTVZXcmqWqH
        ySpIlYMZ4NL9t9aXt
X-Received: by 2002:a05:6000:1885:b0:22e:7851:b257 with SMTP id a5-20020a056000188500b0022e7851b257mr31136910wri.418.1666866581168;
        Thu, 27 Oct 2022 03:29:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4jsuwxcZ0RljYNheoTZjdhHHk6MtyshB1R5fyZlAA3UHjMYotV2R4AlZjLiMgWxLsRid3x8w==
X-Received: by 2002:a05:6000:1885:b0:22e:7851:b257 with SMTP id a5-20020a056000188500b0022e7851b257mr31136890wri.418.1666866580826;
        Thu, 27 Oct 2022 03:29:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id n4-20020a056000170400b002302dc43d77sm845574wrc.115.2022.10.27.03.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 03:29:39 -0700 (PDT)
Message-ID: <4d421aec-e151-7761-58c7-032c3168d5f2@redhat.com>
Date:   Thu, 27 Oct 2022 12:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: vmx/nested: avoid blindly setting
 SECONDARY_EXEC_ENCLS_EXITING when sgx is enabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Bandan Das <bsd@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221025123749.2201649-1-eesposit@redhat.com>
 <Y1gbAA0JVo9g3joi@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y1gbAA0JVo9g3joi@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/22 19:21, Sean Christopherson wrote:
> Shortlog scope is still wrong, should be "KVM: nVMX:"
> 
> The shortlog is also somewhat is misleading/confusing, as it's not at all obvious
> that "sgx enabled" means "KVM's sgx_module param is enabled" and not "SGX is enabled
> in the system".
> 
> E.g.
> 
>    KVM: nVMX: Advertise ENCLS_EXITING to L1 iff SGX is fully supported

Queued with this commit message:

---
KVM: VMX: fully disable SGX if SECONDARY_EXEC_ENCLS_EXITING unavailable

Clear enable_sgx if ENCLS-exiting is not supported, i.e. if SGX cannot be
virtualized.  When KVM is loaded, adjust_vmx_controls checks that the
bit is available before enabling the feature; however, other parts of the
code check enable_sgx and not clearing the variable caused two different
bugs, mostly affecting nested virtualization scenarios.

First, because enable_sgx remained true, SECONDARY_EXEC_ENCLS_EXITING
would be marked available in the capability MSR that are accessed by a
nested hypervisor.  KVM would then propagate the control from vmcs12
to vmcs02 even if it isn't supported by the processor, thus causing an
unexpected VM-Fail (exit code 0x7) in L1.

Second, vmx_set_cpu_caps() would not clear the SGX bits when hardware
support is unavailable.  This is a much less problematic bug as it only
happens if SGX is soft-disabled (available in the processor but hidden
in CPUID) or if SGX is supported for bare metal but not in the VMCS
(will never happen when running on bare metal, but can theoertically
happen when running in a VM).

Last but not least, this ensures that module params in sysfs reflect
KVM's actual configuration.

RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=2127128
Fixes: 72add915fbd5 ("KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Message-Id: <20221025123749.2201649-1-eesposit@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---

The bug is strictly speaking not in nVMX, although that's where most
of the symptoms surface.

Paolo

