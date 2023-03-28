Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 565046CBF05
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjC1M3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjC1M3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:29:16 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DD48A50
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:29:15 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so48900856edb.13
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680006553;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mrOjxRQpJOqzj8z/jCUY5gGiGOpQ6ERLOciMFIFaSDw=;
        b=AyeMaUF6/cUutsLZpC4QZ/ytuCQMOHsNuH/bPRkzS1gywTieDBRR1WIb76/bSQCGHG
         1pB6rBa5owsLnoUHVJDiU98fxDQY93TzzIRM97lE7wChkIuZi66fLsOyV77qYSXvwZ6G
         lF0+mhpsRVJoJ869wXxix0EXTMjbWVduobp2a3a6J7r/QLxjRpO9MrVxVEQXmxngjB5g
         4uIb0ROhDbqqfdoXPXT7MHoQ2Xi3w2nsHYm5wbdM4vc4jiLatDUKLH4SuYK5JIqneIiy
         OpvWIE2oKd2uZIPbRhXoyYk7PbeGX9AohZg7bPN2hsh1ZWd8+vVbATczfG3wsDsu+6D/
         7TuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680006553;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mrOjxRQpJOqzj8z/jCUY5gGiGOpQ6ERLOciMFIFaSDw=;
        b=rLpmESvYT+offRilsuqRPcd8Zz4qQVbXjGkDt/rriLlrwt6JRKSFeiLzzu/TMfHZdV
         mVg2YOrbQdxn4YDrwd3sAwcvDboN/e+bP8VVuh5/ZQ5E13/16vF1v2XKSW0brUcyDMV7
         6BxEkVnxJUuS7Rv7IO8XGLmAzit0clyuINCZEnySZKllUYRmvrsLycjLHMgKx4lclu+a
         qEUG2Dh8kosDo+RfnEKbdunSTdfICSEWBSp4idC8wK8yxK6jlG7Ghnef68+bgSSJSNFc
         66YByQXxrMdnAJ2ctPuz6HnC6D8bPyPGtkQopNtIEyMk3bIwNQNk0HHB5mNlFQCBhoOS
         3ZrQ==
X-Gm-Message-State: AAQBX9dxjYhg1oxOaHSc5HVHjN5r2h2PjuPY3lXvv1a2QNZILOPfvvjq
        l4GuMeS5YV9DHVrMIuoTYHwNmQ==
X-Google-Smtp-Source: AKy350Z50h+0X/iXCd/ROMSdaYTHlmIl8irV6DB13lcclZYFdTmJRZR61VpQjfNTYRnTlaMorKcVkw==
X-Received: by 2002:aa7:ccce:0:b0:500:5627:a20a with SMTP id y14-20020aa7ccce000000b005005627a20amr13849024edt.25.1680006553679;
        Tue, 28 Mar 2023 05:29:13 -0700 (PDT)
Received: from ?IPV6:2003:f6:af12:cb00:3146:384f:5efc:fd5d? (p200300f6af12cb003146384f5efcfd5d.dip0.t-ipconnect.de. [2003:f6:af12:cb00:3146:384f:5efc:fd5d])
        by smtp.gmail.com with ESMTPSA id v1-20020a50d581000000b0050234b3fecesm4220886edi.73.2023.03.28.05.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 05:29:13 -0700 (PDT)
Message-ID: <f86cb36e-b331-8b8d-f087-5e2e8a5ae962@grsecurity.net>
Date:   Tue, 28 Mar 2023 14:29:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Linux 5.15.103
Content-Language: en-US, de-DE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        lwn@lwn.net, jslaby@suse.cz,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1679040264214179@kroah.com>
 <c359c777-c3af-b4a6-791d-d51916160bf5@grsecurity.net>
 <ZCLaLWJiIsDV5yGr@kroah.com>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <ZCLaLWJiIsDV5yGr@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.03.23 14:14, Greg Kroah-Hartman wrote:
> On Tue, Mar 28, 2023 at 02:02:03PM +0200, Mathias Krause wrote:
>> On 17.03.23 09:04, Greg Kroah-Hartman wrote:
>>> I'm announcing the release of the 5.15.103 kernel.
>>>
>>> [...]
>>>
>>> Vitaly Kuznetsov (4):
>>>       KVM: Optimize kvm_make_vcpus_request_mask() a bit
>>>       KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
>>>       KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
>>>       KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
>>>
>>
>> That list is missing commit 6470accc7ba9 ("KVM: x86: hyper-v: Avoid
>> calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL") to fulfill
>> the prerequisite of "KVM: Optimize kvm_make_vcpus_request_mask() a bit".
>>
>> Right now the kvm selftests trigger a kernel NULL deref for the hyperv
>> test, making the system hang.
>>
>> Please consider applying commit 6470accc7ba9 for the next v5.15.x release.
> 
> It wasn't tagged for the stable kernels, so we didn't pick it up :(

Neither were any of the above commits. o.O

Commit 3e48a6349d29 ("KVM: Optimize kvm_make_vcpus_request_mask() a
bit") has this tag, though:

Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last
thing during initialization")

I don't know why, though. These two commits have little in common.
Maybe Sasha knows why?

> 
> Have now done so, thanks.

Thanks!

Mathias
