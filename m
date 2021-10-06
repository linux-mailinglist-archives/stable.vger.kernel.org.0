Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FB1423CC6
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 13:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbhJFL1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 07:27:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238429AbhJFLZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 07:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633519401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+j8kGyfSEc1b5J6pZ1nvHDgoskjSsEnkTn7JsOcRG8=;
        b=a6i4oDCaH3GPQ8HAMH7m+v85I00vbHCoxvNTk0oZ/Q3do//hArQjjoBMQhqzy2Uqbep17+
        FqMtA1fIzzzCJkZ6qMYNGLktyD+qd1yFQmBGhoGkdjL5aq3Z6w6UZTHQArzanlXkjgRpOC
        XDtobzEajMDlBZb1/8zcJRDrYmxEfNc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-MqQ1qIoWM9SwNVZHm87z8Q-1; Wed, 06 Oct 2021 07:23:20 -0400
X-MC-Unique: MqQ1qIoWM9SwNVZHm87z8Q-1
Received: by mail-ed1-f69.google.com with SMTP id i7-20020a50d747000000b003db0225d219so2395085edj.0
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 04:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K+j8kGyfSEc1b5J6pZ1nvHDgoskjSsEnkTn7JsOcRG8=;
        b=EJMwkSgS+jXiQ3fuNxB4Oc3jagbHNrpQLmhbkZnqree35YydlEPLSDsliZBAzfKIqz
         JnLHWGNGKWrNzj9Pl0lamCc5gqsB12flY07A1HBjslqxhk72e96yrbWIUzc/9QlUnPMk
         gU4g62nKihtFotOL5nFmVgFjX5qjwsLSVJdskbhWC0/9AZoMv4mF7TEFejUHFSTcZLWp
         SOyBCCzFgqBjyMFvJkULb6cSgvszgluoIvu6vpFYZE+jOFrd9OogaZdd26HequO+eO/R
         8X3h3ox8jj8Fo/x2sqM3jbObD3ko2dWFtp6Ym+8cOF9Vl7+hXr3c+e2mio4esd7DsVvL
         5/zQ==
X-Gm-Message-State: AOAM533HStACHrHgwesbug1DHsz+RxBBWbR+jMp5G52KtzoOoa5Dvtdv
        xP9VFDbdTD5B6ybDogJLYT7SsZ/8kgQbD/4tv8Ilnqv+iA4HQgiXxkX4gwo8X9H3aNXbaZ/OirD
        xn2wDn4ktS+gHmYVk
X-Received: by 2002:a17:907:767a:: with SMTP id kk26mr30836885ejc.134.1633519399605;
        Wed, 06 Oct 2021 04:23:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSbrR9RR6C4+3Fp2VVhrEAk9547+8U10Y9UDSOeD6CeQ+ifciYYe5Ljeu4bqSDszAHdpZXPA==
X-Received: by 2002:a17:907:767a:: with SMTP id kk26mr30836865ejc.134.1633519399407;
        Wed, 06 Oct 2021 04:23:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s3sm8842345eja.87.2021.10.06.04.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 04:23:18 -0700 (PDT)
Message-ID: <f4abdd97-d451-f689-75c4-26d412bcc920@redhat.com>
Date:   Wed, 6 Oct 2021 13:23:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH MANUALSEL 5.10 6/7] KVM: x86: nSVM: restore int_vector in
 svm_clear_vintr
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
References: <20211006111234.264020-1-sashal@kernel.org>
 <20211006111234.264020-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211006111234.264020-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/10/21 13:12, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit aee77e1169c1900fe4248dc186962e745b479d9e ]
> 
> In svm_clear_vintr we try to restore the virtual interrupt
> injection that might be pending, but we fail to restore
> the interrupt vector.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Message-Id: <20210914154825.104886-2-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1c23aee3778c..5e1d7396a6b8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1497,6 +1497,8 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
>   			(svm->nested.ctl.int_ctl & V_TPR_MASK));
>   		svm->vmcb->control.int_ctl |= svm->nested.ctl.int_ctl &
>   			V_IRQ_INJECTION_BITS_MASK;
> +
> +		svm->vmcb->control.int_vector = svm->nested.ctl.int_vector;
>   	}
>   
>   	vmcb_mark_dirty(svm->vmcb, VMCB_INTR);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

