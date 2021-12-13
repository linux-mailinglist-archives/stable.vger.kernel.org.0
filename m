Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AA3472F3E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhLMO22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbhLMO22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:28:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EFEC061574;
        Mon, 13 Dec 2021 06:28:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o20so53115960eds.10;
        Mon, 13 Dec 2021 06:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L1YqcUf8tUArbOAJMXi15iOKQNwtOCLTu+LlsK480y4=;
        b=MZoL1XTnWw68iKuFmUQwDRPIHn+gdJEMTqBWsL7u+j2IalNHz/MEUcqVDOSbHnMCkQ
         N3ysq+hCStY6ZUoYzGVwH9RDSlNIXVTJ0WwFfbyGpKB2RpWWp8I+iCXMu/mnmaBBYrTA
         TRk7fxHXK51ogiDRDDLTIGy8RXlxIBatwDB8dRhxiwcYo3tYxcVmjcmYuVQbsWLbGrgO
         tOMigK+hQF0raDST9EJrP7s5oSGcEquqICpRF9VMKw4SbuGYvOu9kvCPcrxpWO85NzlD
         VCNaitRzyXuEmKX5rCC/r5W38O0YGswo8lZpcekHezC1D/4VKB4xaVYtRTxSbrom+Cj5
         tPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L1YqcUf8tUArbOAJMXi15iOKQNwtOCLTu+LlsK480y4=;
        b=5HBmgwE9QSLJitzIB0CE9duQsSQZHlygYiPYFfcEihCw/9IzHartqTQ/3ow9U2jSSO
         2F+NFKYDTVxu49g/8Zyu19dYrIYPa68oYtHzZQS1aStR01ClZgSaiFlmLOOGzDb2qKiH
         JcvD9sBoMIaiKC0o6ZRK/5OblykRmmgXUbxqMGD8kzdvctsUEluxe3rnnBjAI6mpfCqL
         0eROvmAU0UTD9lbtxYQV1OJxxyY7Xoa5FN5KBDqZB1/ydWOQ3EOIyAfxxK0+MmynkRH9
         PEWLyoKE0LormmV6qRCHh1HS1wQmU5Y6YI5/hmzcZJf3Z1DaABJQ/psG4hEIajQDyCqV
         h+1Q==
X-Gm-Message-State: AOAM5319Ceb5xBzwjiFFd/NuIVY/rkeeWIzgmnvQritd2NIlAiXBJm+o
        ljTGDJSckRs1BIc1ZkA9LDM=
X-Google-Smtp-Source: ABdhPJxXh/83cDzm4RIF5R6fORGy/0AjXS454rmeCqthFz8xFx6m9UKgAHY2/D8Mqw5pGskFZWSm0Q==
X-Received: by 2002:a17:907:60d6:: with SMTP id hv22mr45291141ejc.503.1639405705648;
        Mon, 13 Dec 2021 06:28:25 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m25sm6438972edj.80.2021.12.13.06.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:28:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d4f4e730-3976-6b5f-d5cc-d4378fc85230@redhat.com>
Date:   Mon, 13 Dec 2021 15:28:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.15 8/9] KVM: downgrade two BUG_ONs to
 WARN_ON_ONCE
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     kvm@vger.kernel.org
References: <20211213141944.352249-1-sashal@kernel.org>
 <20211213141944.352249-8-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213141944.352249-8-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:19, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit 5f25e71e311478f9bb0a8ef49e7d8b95316491d7 ]
> 
> This is not an unrecoverable situation.  Users of kvm_read_guest_offset_cached
> and kvm_write_guest_offset_cached must expect the read/write to fail, and
> therefore it is possible to just return early with an error value.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/kvm_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ce1847bc898b2..c6bfd4e15d28a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3001,7 +3001,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   	int r;
>   	gpa_t gpa = ghc->gpa + offset;
>   
> -	BUG_ON(len + offset > ghc->len);
> +	if (WARN_ON_ONCE(len + offset > ghc->len))
> +		return -EINVAL;
>   
>   	if (slots->generation != ghc->generation) {
>   		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
> @@ -3038,7 +3039,8 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   	int r;
>   	gpa_t gpa = ghc->gpa + offset;
>   
> -	BUG_ON(len + offset > ghc->len);
> +	if (WARN_ON_ONCE(len + offset > ghc->len))
> +		return -EINVAL;
>   
>   	if (slots->generation != ghc->generation) {
>   		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
