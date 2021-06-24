Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF43B3911
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 00:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFXWIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 18:08:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229848AbhFXWIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Jun 2021 18:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624572345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0CzP89c1RFf7URSlKpQ6Fl8r6rF5HXChZu0Y5E1Q13Y=;
        b=GvvXJFk+rkh9/7IMqPN5Dc+vTfwxMvG176J9zOosPjiK/hQv70vfQDSvdcESFNrJmdN70X
        tKGF1mKgXrgHPFrX8rRuPsR4/EcUbcA5TwwH7wvCiFAgg5irxhmcxdm1EU5zSI1BBEtA0r
        bdBHTK6PX7MhnP3SPJwqqlwIuJkW824=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-ap8yf89KM_axg1LBP7Mthg-1; Thu, 24 Jun 2021 18:05:43 -0400
X-MC-Unique: ap8yf89KM_axg1LBP7Mthg-1
Received: by mail-ej1-f69.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso2455375ejp.3
        for <stable@vger.kernel.org>; Thu, 24 Jun 2021 15:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0CzP89c1RFf7URSlKpQ6Fl8r6rF5HXChZu0Y5E1Q13Y=;
        b=W5Iv7xOvjsj1o+Wp+pbypc1hO8Sxaz6Os9wp4L+0h9XIHcX6jmtoQ9aCKJkanHZw4U
         wXgJOTDr1KzLBJycwBSLytYdclcvOcAbMXHAJF02Bsrn29AX3U80dk2DfGE8E9oR5V0o
         uqo7sFdZT5ceyMGqvGaKp5mL7tGIIkv8XsS9OieXVx5p9eUHmOYukrwJulM8OnYjb3+0
         HevKLfzHrGvC68CzhOi567wp2HLod05K8vq33G0W+2BzFRID/4DvotLIOB9CXL0POGNY
         te+PPJWb7rkHgxHCoyXNbkm6G2FSLJTZj+DYw8HLYzCsdLjpA3i1dEsSJrRqHreR3CSn
         Ryng==
X-Gm-Message-State: AOAM532TchXujsGKyreJ9i+JyQOAwOdyyqW2gqhVfjGOcwiodab04p4E
        88bpva1YP28hJt49RxGcel9Dw6zCd/ekJ7AJiO9tHMCg0u8bxWwc2kroDaMmOSfq0pFAax+AYXF
        OgRN6loZN44pptslB
X-Received: by 2002:aa7:c588:: with SMTP id g8mr10314583edq.207.1624572342791;
        Thu, 24 Jun 2021 15:05:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLI1/npJnYBqAEWiH+5nizEkXqgnau/KTrdcXOhKUjDThefIJzDSkru8++pi9WSwu7K/T6UA==
X-Received: by 2002:aa7:c588:: with SMTP id g8mr10314560edq.207.1624572342662;
        Thu, 24 Jun 2021 15:05:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hz14sm1732736ejc.107.2021.06.24.15.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 15:05:42 -0700 (PDT)
Subject: Re: [PATCH 5.10] KVM: SVM: Call SEV Guest Decommission if ASID
 binding fails
To:     Alper Gun <alpergun@google.com>, stable@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>
References: <20210624220342.1974675-1-alpergun@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cf45f2e0-776f-bed3-b882-c3d3991196f5@redhat.com>
Date:   Fri, 25 Jun 2021 00:05:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210624220342.1974675-1-alpergun@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/06/21 00:03, Alper Gun wrote:
> commit 934002cd660b035b926438244b4294e647507e13 upstream.
> 
> Send SEV_CMD_DECOMMISSION command to PSP firmware if ASID binding
> fails. If a failure happens after  a successful LAUNCH_START command,
> a decommission command should be executed. Otherwise, guest context
> will be unfreed inside the AMD SP. After the firmware will not have
> memory to allocate more SEV guest context, LAUNCH_START command will
> begin to fail with SEV_RET_RESOURCE_LIMIT error.
> 
> The existing code calls decommission inside sev_unbind_asid, but it is
> not called if a failure happens before guest activation succeeds. If
> sev_bind_asid fails, decommission is never called. PSP firmware has a
> limit for the number of guests. If sev_asid_binding fails many times,
> PSP firmware will not have resources to create another guest context.
> 
> Cc: stable@vger.kernel.org
> Fixes: 59414c989220 ("KVM: SVM: Add support for KVM_SEV_LAUNCH_START command")
> Reported-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Alper Gun <alpergun@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm/sev.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 16b10b9436dc..8112eafd45bc 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -130,9 +130,19 @@ static void sev_asid_free(int asid)
>   	mutex_unlock(&sev_bitmap_lock);
>   }
>   
> +static void sev_decommission(unsigned int handle)
> +{
> +	struct sev_data_decommission decommission;
> +
> +	if (!handle)
> +		return;
> +
> +	decommission.handle = handle;
> +	sev_guest_decommission(&decommission, NULL);
> +}
> +
>   static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   {
> -	struct sev_data_decommission *decommission;
>   	struct sev_data_deactivate *data;
>   
>   	if (!handle)
> @@ -152,15 +162,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
>   
>   	kfree(data);
>   
> -	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
> -	if (!decommission)
> -		return;
> -
> -	/* decommission handle */
> -	decommission->handle = handle;
> -	sev_guest_decommission(decommission, NULL);
> -
> -	kfree(decommission);
> +	sev_decommission(handle);
>   }
>   
>   static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
> @@ -288,8 +290,10 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   
>   	/* Bind ASID to this guest */
>   	ret = sev_bind_asid(kvm, start->handle, error);
> -	if (ret)
> +	if (ret) {
> +		sev_decommission(start->handle);
>   		goto e_free_session;
> +	}
>   
>   	/* return handle to userspace */
>   	params.handle = start->handle;
> 

NACK

for this one too.

Paolo

