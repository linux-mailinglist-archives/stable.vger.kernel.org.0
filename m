Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757B24EC3B5
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbiC3MRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345351AbiC3MNq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:13:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C9D14AE37
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 05:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648642039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p4IaRvBma0W1UBcawEsDhyvvua/6JtF1rikRuXR/v3o=;
        b=UDcjrvDDA2M6JJCbmKRAOORM4sC1G7oRuzEzy9UrOgvf5Fa8t+2Zl82yiAuNjJS64+T0NE
        jjrLrz6n/HjZjwQX5IeaE0Fx/GPZku+xOdvNOPeuoN/N0kyZ6CUotbcfeBKhI+6xg31y3R
        cjpQwPFNEOPkvDAzO5yzKvh15nQe4b0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-Q_9Bcd4lN9e7xrbdC4SSWA-1; Wed, 30 Mar 2022 08:07:18 -0400
X-MC-Unique: Q_9Bcd4lN9e7xrbdC4SSWA-1
Received: by mail-ed1-f71.google.com with SMTP id i22-20020a508716000000b0041908045af3so12729850edb.3
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 05:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p4IaRvBma0W1UBcawEsDhyvvua/6JtF1rikRuXR/v3o=;
        b=lZYck2n4RAnS8qiG7kh1tU3gJrp+nGc0xjx/IsTJp8Ahq9xB7PsSR6/0vFOkYT3XeV
         NIEK5VJtjS4/y+8BLEV6GhMTjhwCgrtbE2QpYKSs60+xNd771t4R4JU2ReXh0XITDjGQ
         4QEmlEyWGCi2h//xy/iriS7J94uHxW8XUdF+gG8ZNpe6h7PLuXCw1pE4jqjXYbNUnct0
         pro/rQujXMcsdUiRFBtNJhX05BRuxzrtE6qeKj53dwboN4WpfCs67So8JJW/vetNRvFq
         O069BN0MjRuG3ZkoB3sfbu4IpyLZAcp/OUqtYTV4Z2UL/LJ80PrBoUQPdCy3oBRMrVJb
         qvfQ==
X-Gm-Message-State: AOAM533TPFvl4EKd6P+dwSgcdG1wvLpacqqUUn+v2FCkoWyZL9LnTtfl
        CBMgsKcT8i+qVuFyyYDfycP5HE72Ouvp2I2QgqpVR3BDjRv/A0GyKZ4nzeU1cbdaVJysJABp/Xc
        VLQk+OhhqNR4jebR9
X-Received: by 2002:a17:907:629a:b0:6d7:b33e:43f4 with SMTP id nd26-20020a170907629a00b006d7b33e43f4mr40595887ejc.149.1648642034592;
        Wed, 30 Mar 2022 05:07:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzStAnN2iHa+Rqbu8eIJhXelGfz14EyM1yta1FQP72irc8UflbROtPx9mfIOIWwkGT4QHJKyw==
X-Received: by 2002:a17:907:629a:b0:6d7:b33e:43f4 with SMTP id nd26-20020a170907629a00b006d7b33e43f4mr40595860ejc.149.1648642034371;
        Wed, 30 Mar 2022 05:07:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id v2-20020a17090606c200b006a728f4a9bcsm8235476ejb.148.2022.03.30.05.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 05:07:13 -0700 (PDT)
Message-ID: <27670a35-c67e-726f-f03f-9cf2eae83523@redhat.com>
Date:   Wed, 30 Mar 2022 14:07:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/8] KVM: x86: avoid loading a vCPU after .vm_destroy was
 called
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
References: <20220322172449.235575-1-mlevitsk@redhat.com>
 <20220322172449.235575-2-mlevitsk@redhat.com> <YkOkCwUgMD1SVfaD@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YkOkCwUgMD1SVfaD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/30/22 02:27, Sean Christopherson wrote:
> Rather than split kvm_free_vcpus(), can we instead move the call to svm_vm_destroy()
> by adding a second hook, .vm_teardown(), which is needed for TDX?  I.e. keep VMX
> where it is by using vm_teardown, but effectively move SVM?
> 
> https://lore.kernel.org/all/1fa2d0db387a99352d44247728c5b8ae5f5cab4d.1637799475.git.isaku.yamahata@intel.com

I'd rather do that only for the TDX patches.

Paolo

