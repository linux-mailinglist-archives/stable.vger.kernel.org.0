Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35B437AF1
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 18:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhJVQd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 12:33:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233524AbhJVQd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Oct 2021 12:33:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634920268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n/eK/Q0sUb0isw4uCVZWU+zVv806HjFFB2ffIfJ7LWo=;
        b=LhXvHfjtYmAbZl2wNUG1Ki18XS3BXsj/6jJKI7qTPNgZNHGHxA5dtZMttWrTmDVyIu6jno
        MkW23NrIwfk0+bRENdu9FPk3nrq2ZUcGei7UCq5UsfDT8I2xjR9iYlG5E9aWXzeM5kUELM
        I/PJf5hZ6Peig8gZxLJjrSR0qRmnwRM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-UT5zDz4dNFGp3jXj1b4pNQ-1; Fri, 22 Oct 2021 12:31:07 -0400
X-MC-Unique: UT5zDz4dNFGp3jXj1b4pNQ-1
Received: by mail-ed1-f69.google.com with SMTP id u10-20020a50d94a000000b003dc51565894so4194713edj.21
        for <stable@vger.kernel.org>; Fri, 22 Oct 2021 09:31:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n/eK/Q0sUb0isw4uCVZWU+zVv806HjFFB2ffIfJ7LWo=;
        b=ToWR6drI/roCfJxTneYVdAhT9wNyDtbjy+LF+gQimN2nJkkEzfypc1HjxRzFKuZthY
         qRThGDiqokfKwmeBwg+Dva2Jqw4UYNSF7QzI6SJV9LzNnBPolMqSWcmsDHuYZxZdAZgB
         DUYqKRvuLyp9H6OTC7lfFByNPo9UV3+lrd86IH3bbev0f+U/x/HstBC2ZSysnxLMvV33
         5XtMvqF4/9am/xmO4uXOtT4SuZRTRoJ35BqHwG/GXvW5OaTdNfPJQEPiz1h/92Egx6jT
         CV87EdrGERYVWv/6sAx05nVu5jSEvocIivr6bCFq8UYGFA9+Omxud6SvsN3LWKFGm99y
         pzww==
X-Gm-Message-State: AOAM530kamV0ePh9+VuYl1csopF1TKhnQ1pmi7o7DDcR9Pd5XYjWB54+
        4P9up5Dzc2aoGQph019EPnpYyBHAHwJn9EkrEBMEXIvpWiELuNG2mit2LNn67Bu8CzosIkBXxuC
        rD86YvhPAt+n/id7E
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr1319806edd.94.1634920266320;
        Fri, 22 Oct 2021 09:31:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFf2ARdxVTBE+4xCNMGhCEtBXmLBuP233sDWRgIfbEeL/Gw1yeWc27lCIYD0Fk5HpBH5qyvQ==
X-Received: by 2002:a05:6402:5189:: with SMTP id q9mr1319764edd.94.1634920266047;
        Fri, 22 Oct 2021 09:31:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w3sm4915436edj.63.2021.10.22.09.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 09:31:05 -0700 (PDT)
Message-ID: <0eab7a31-53e0-2899-76d7-3e9c0be76fad@redhat.com>
Date:   Fri, 22 Oct 2021 18:31:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 4/8] KVM: SEV-ES: clean up kvm_sev_es_ins/outs
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com,
        stable@vger.kernel.org
References: <20211013165616.19846-1-pbonzini@redhat.com>
 <20211013165616.19846-5-pbonzini@redhat.com>
 <1ae6a54626342dd2391d04a3566bd680c6831e93.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1ae6a54626342dd2391d04a3566bd680c6831e93.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/10/21 01:14, Maxim Levitsky wrote:
>>   
>>   	vcpu->arch.pio.count = 0;
> ^^^
> I wonder what the rules are for clearing vcpu->arch.pio.count for userspace PIO vm exits.
> Looks like complete_fast_pio_out clears it, but otherwise the only other place
> that clears it in this case is x86_emulate_instruction when it restarts the instuction.
> Do I miss something?

For IN, it is cleared by the completion callback.

For OUT, it can be cleared either by the completion callback or before 
calling it, because the completion callback will not need it.  I would 
like to standardize towards clearing it in the callback for out, too, 
even if sometimes it's unnecessary to have a callback in the first 
place; this is what patch 8 does for example.  This way 
vcpu->arch.pio.count > 0 tells you whether the other fields have a 
recent value.

Paolo

