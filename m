Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F93423F74
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhJFNiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239006AbhJFNiV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 09:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633527389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mdCtjmJ1UXZrI9DLoQzPgnLklkeoiryi6u7rrgv0/LQ=;
        b=TkVUvQF0J1sX4zB+K+Klpvzd86F6Khm6U4cK7duRMygRG6T7wYuvX6OIlwH4PqmORp6k1A
        JjVDweLEqSOn5tRWpq6NnWfrHYAhocQzgZ+CnNuFJuVpsSY7KMmKhBLqsPk7EMVWcc+9CQ
        uCnnCCw2OVs4d1ckHz5LJoQJ2Z0aNpg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-uK7u-Q7wPQ66ZQFVKzuuRA-1; Wed, 06 Oct 2021 09:36:28 -0400
X-MC-Unique: uK7u-Q7wPQ66ZQFVKzuuRA-1
Received: by mail-ed1-f72.google.com with SMTP id w6-20020a50d786000000b003dabc563406so2631270edi.17
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 06:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mdCtjmJ1UXZrI9DLoQzPgnLklkeoiryi6u7rrgv0/LQ=;
        b=pj39S4ksZg4Yi4ZliZ6wEBvb25WA/FfWAtSzrjyTSB1DfodMo3S/RlgKym+P/Wg3IM
         SwAMorfFyFU9uEY4OIzN2dTuubvVz9l/8KHC7zZhZ+SvLiedGZn6ccweKZ+AdVQ1va2F
         W00fVOpmq4xk88jZPgOCy9M//Ctut16a3KGqhK0lHFw9Qnn0+SNs/RkPSXocAfZ3PJnp
         njQJyloLJvBv1Qlcuwa+qTUTW3KSkEKUNT8o1sl3Dw2ZGSLz1FYQT1RhXhBM5fZkZS1w
         +EhdoERIVp+2n8j7G/psgfVblNGi6XbVN6vwUdspZfpJCCG4ECkNuJy4ZbgYLHmmCEW/
         kEcw==
X-Gm-Message-State: AOAM530pmXialVANhWHspg6Wo/FWt1NOUL7r0Zz3Z7ESAitu0QrwzIcU
        pLpiv3kulSpDb0uhw6xjcZYJ6xMt/+JDPGAhA8qio8tZGE3sWpRsjlM1O2L8xAwIoLMfKTE2NKK
        KIOYEEgPYii6tFu4u
X-Received: by 2002:a05:6402:19b5:: with SMTP id o21mr34283822edz.214.1633527386841;
        Wed, 06 Oct 2021 06:36:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDV8zgstcj54ZGrgP0aY+OjAgvKhSz+WwnxgH7Gza00q6jnFcohQUibpIG3XAbbBVd0XZV+w==
X-Received: by 2002:a05:6402:19b5:: with SMTP id o21mr34283798edz.214.1633527386673;
        Wed, 06 Oct 2021 06:36:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id eg31sm770602edb.38.2021.10.06.06.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 06:36:26 -0700 (PDT)
Message-ID: <e561a2a4-96f1-a56c-21f0-06e4e21c4765@redhat.com>
Date:   Wed, 6 Oct 2021 15:36:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.14 3/9] KVM: do not shrink halt_poll_ns below
 grow_start
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>, kvm@vger.kernel.org
References: <20211006133021.271905-1-sashal@kernel.org>
 <20211006133021.271905-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006133021.271905-3-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 15:30, Sasha Levin wrote:
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> [ Upstream commit ae232ea460888dc5a8b37e840c553b02521fbf18 ]
> 
> grow_halt_poll_ns() ignores values between 0 and
> halt_poll_ns_grow_start (10000 by default). However,
> when we shrink halt_poll_ns we may fall way below
> halt_poll_ns_grow_start and endup with halt_poll_ns
> values that don't make a lot of sense: like 1 or 9,
> or 19.
> 
> VCPU1 trace (halt_poll_ns_shrink equals 2):
> 
> VCPU1 grow 10000
> VCPU1 shrink 5000
> VCPU1 shrink 2500
> VCPU1 shrink 1250
> VCPU1 shrink 625
> VCPU1 shrink 312
> VCPU1 shrink 156
> VCPU1 shrink 78
> VCPU1 shrink 39
> VCPU1 shrink 19
> VCPU1 shrink 9
> VCPU1 shrink 4
> 
> Mirror what grow_halt_poll_ns() does and set halt_poll_ns
> to 0 as soon as new shrink-ed halt_poll_ns value falls
> below halt_poll_ns_grow_start.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Message-Id: <20210902031100.252080-1-senozhatsky@chromium.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b50dbe269f4b..1a11dcb670a3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3053,15 +3053,19 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
>   
>   static void shrink_halt_poll_ns(struct kvm_vcpu *vcpu)
>   {
> -	unsigned int old, val, shrink;
> +	unsigned int old, val, shrink, grow_start;
>   
>   	old = val = vcpu->halt_poll_ns;
>   	shrink = READ_ONCE(halt_poll_ns_shrink);
> +	grow_start = READ_ONCE(halt_poll_ns_grow_start);
>   	if (shrink == 0)
>   		val = 0;
>   	else
>   		val /= shrink;
>   
> +	if (val < grow_start)
> +		val = 0;
> +
>   	vcpu->halt_poll_ns = val;
>   	trace_kvm_halt_poll_ns_shrink(vcpu->vcpu_id, val, old);
>   }
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

