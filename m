Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C00492247
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345364AbiARJLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:11:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345360AbiARJLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:11:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642497081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnZYlrqb+kccpImxETiPk8O/an1BetjSM81KO3wlhaI=;
        b=a6Oj0VfAVbTPdsIClqRZKFq2THRrEPILpQDRCHGEvXLd/eTR4D1yaPE6/LKWypPMTJF/R4
        f6XgNTxNre/znot1pcqQGJIrxdR20a3d9D6TLM537ofiq0qbqjB3l9hpvkv+Bfn7WcybWA
        4AcCGbQyR7IFYrDIJj4/QE0F1IoYSOQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-mz0eCf2ONZaj1V6Y0rCoPw-1; Tue, 18 Jan 2022 04:11:20 -0500
X-MC-Unique: mz0eCf2ONZaj1V6Y0rCoPw-1
Received: by mail-wm1-f70.google.com with SMTP id v190-20020a1cacc7000000b0034657bb6a66so6533406wme.6
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 01:11:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pnZYlrqb+kccpImxETiPk8O/an1BetjSM81KO3wlhaI=;
        b=uUoZe+ep+9PQLQYQtU6UCBvq25K97P8lbm1x9852tTOmX2wx3SbO90FRdm3Vnr0z4O
         HrC2Uyf5zbI422mc4wYjvSchtOL96Lbm7sZkJ/jeSe6CUO4CilN/T2Yn8s77odR6Kidh
         IJz8/3JJxJdaFRaUGI+J6JF9/lfxuYxu6//21N05ERH7GvDdhuStcWyVoXJBUjO7dmPq
         TWZDOJgN5FMTOM9GuMebvM2n/df8ehAYY5JiqIOHmVeNedickrMsDPAPxQh50SQlqlGm
         jW5MeamCxROgs9tkIRbqpMFNOkTdGc4ZeDDQk124wpXZRkT5AjGYnIPzoYTLefm1iyhh
         sl7Q==
X-Gm-Message-State: AOAM5308lcu/qYyODc8IH3mDWdUfR2NB8grQ4QgGeTqO+M5KK3ioxJkl
        5usgz2NS8OX6KqFDOkh58+FMzda5oiwE2RSAU/cA9jOdRslfYb7KuXI4kwyv53imgTELpv2+9Ag
        SLD/wa6pxEdP1o8IP
X-Received: by 2002:a5d:6482:: with SMTP id o2mr23288389wri.692.1642497079240;
        Tue, 18 Jan 2022 01:11:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxX9R9/kyDmu9DEklwF6y+7LHIotrcBeoXcHfx0Pl2GXyXMlM9PsObNEZngp5OGmpRXE0DTCg==
X-Received: by 2002:a5d:6482:: with SMTP id o2mr23288360wri.692.1642497078991;
        Tue, 18 Jan 2022 01:11:18 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id z1sm13403595wrw.95.2022.01.18.01.11.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 01:11:18 -0800 (PST)
Message-ID: <c173ea91-87a9-bbd5-0216-26bbb0615a38@redhat.com>
Date:   Tue, 18 Jan 2022 10:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Like Xu <like.xu.linux@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20211217124934.32893-1-wei.w.wang@intel.com>
 <CALMp9eR18D6omo6kVTUXQ2enPpUBE=5oQWvQ5uiYu_0h6npE8A@mail.gmail.com>
 <0c87c3e5e1dd4c03959c6c1b0e4fd05a@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0c87c3e5e1dd4c03959c6c1b0e4fd05a@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/18/22 06:04, Wang, Wei W wrote:
> On Tuesday, January 18, 2022 11:54 AM, Jim Mattson wrote:
>> On Fri, Dec 17, 2021 at 6:05 AM Wei Wang <wei.w.wang@intel.com> wrote:
>>>
>>> The fixed counter 3 is used for the Topdown metrics, which hasn't been
>>> enabled for KVM guests. Userspace accessing to it will fail as it's
>>> not included in get_fixed_pmc(). This breaks KVM selftests on ICX+
>>> machines, which have this counter.
>>>
>>> To reproduce it on ICX+ machines, ./state_test reports:
>>> ==== Test Assertion Failure ====
>>> lib/x86_64/processor.c:1078: r == nmsrs
>>> pid=4564 tid=4564 - Argument list too long
>>> 1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
>>> 2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
>>> 3  0x00007fbe21ed5f92: ?? ??:0
>>> 4  0x000000000040264d: _start at ??:?
>>>   Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)
>>>
>>> With this patch, it works well.
>>>
>>> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
>> Reviewed-and-tested-by: Jim Mattson <jmattson@google.com>
>>
>> I believe this fixes commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
>> number of vPMU fixed counters to 3") from v5.9. Should this be cc'ed to
>> stable?
> 
> Sounds good to me.

Sent, thanks.

Paolo

