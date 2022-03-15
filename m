Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833E24DA42D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbiCOUrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 16:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240589AbiCOUrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 16:47:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A17401EAFD
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647377150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mfsuVWuQAKJg+F+zcfbiO96TVlca2UoPYtQW08E2LFI=;
        b=hrGBSiHFRS79x+QCKlu8wlyGkCHjF72l5FPFa+Sh7jRsS5WW/4J4fcZDIJ2yWXBO6pNN+R
        YZ5iDF2cmA8+FmDPjwnXT86CfZyuufzpOS2UgsfF86Q2GABPuqYqmBXBTcROCPuZdSt21K
        Mx5g4I8tlraglyX1Ybi5Yasfchv9SfE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-zdypxzTFO2SzPg8I6rL1ag-1; Tue, 15 Mar 2022 16:45:49 -0400
X-MC-Unique: zdypxzTFO2SzPg8I6rL1ag-1
Received: by mail-ed1-f69.google.com with SMTP id s7-20020a508dc7000000b0040f29ccd65aso158553edh.1
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 13:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mfsuVWuQAKJg+F+zcfbiO96TVlca2UoPYtQW08E2LFI=;
        b=s2oL23WOyEZJD/aupe993oXQadKYvxWi3FgaP8Sf9kLWhuMb/iEVsozVH2xVUoVtDl
         Fbir82kxgREudOia01T0/AxrplKR0ikT1ir+VOV6SihrLFe3rd83Lyx8ub1cv8/VFEmd
         3cOKgeNrqjZrjp1kpmr4bwLtL+7fxXqipoBkXSxw02YycjZbJ8yNpXym12xupIBdOMWr
         S+sSoaDvuHoijGTG03C3Vt4n2SJJZ8SdUyLYUSKIoUr33NJrepc2jVh3bZATbVu1xtJa
         N3yQe61muq1DMdeo44dKAiIqkG/Pku+mp9KKwf8FKEdJZGj1MsZKTa079jER2iPCAKkV
         tYTQ==
X-Gm-Message-State: AOAM531Ig75wf6eiWaRxN1AYzOSvb7cYpfO3J/G9YMA5XT1WQjX88Ufs
        G2NgwCD0jR0zKfflEurNPeoj0Xr5tYiM8CQ51r99+snr85uI8/W8B4GyUq6hgIwpPM/AcxGIh+b
        0aV/kdGYcgYK+RiBf
X-Received: by 2002:a05:6402:5243:b0:418:e5f7:7b1 with SMTP id t3-20020a056402524300b00418e5f707b1mr819108edd.153.1647377148301;
        Tue, 15 Mar 2022 13:45:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDVTf9id9co9geemsNRV2GfTX3x2HDSYveRlWEoLl0162igpVWp9eSdiYwBNBvHBG+KoHtcg==
X-Received: by 2002:a05:6402:5243:b0:418:e5f7:7b1 with SMTP id t3-20020a056402524300b00418e5f707b1mr819095edd.153.1647377148096;
        Tue, 15 Mar 2022 13:45:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id re21-20020a170906d8d500b006daf3718d0csm39570ejb.143.2022.03.15.13.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 13:45:47 -0700 (PDT)
Message-ID: <fc0bca25-fbda-d489-5ad9-04db49cee205@redhat.com>
Date:   Tue, 15 Mar 2022 21:45:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND 1/2] KVM: Prevent module exit until all VMs are
 freed
Content-Language: en-US
To:     muriloo@linux.ibm.com, David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        seanjc@google.com, bgardon@google.com, stable@vger.kernel.org,
        farosas@linux.ibm.com
References: <20220303183328.1499189-1-dmatlack@google.com>
 <20220303183328.1499189-2-dmatlack@google.com>
 <cb11c10b-0520-02ef-afb5-6f524847d67f@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cb11c10b-0520-02ef-afb5-6f524847d67f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/15/22 16:43, Murilo Opsfelder Araújo wrote:
>>
>> +    if (!try_module_get(kvm_chardev_ops.owner)) {
>> +        r = -ENODEV;
>> +        goto out_err;
>> +    }
>> +
> 
> Doesn't this problem also affects the other functions called from
> kvm_dev_ioctl()?
> 
> Is it possible that the module is removed while other ioctl's are
> still running, e.g. KVM_GET_API_VERSION and KVM_CHECK_EXTENSION, even
> though they don't use struct kvm?

No, because opening /dev/kvm also adds a reference to the module.  The 
problem is that create_vm creates another source of references to the 
module that can survive after /dev/kvm is closed.

Paolo

