Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E133E472EF3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238752AbhLMOWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbhLMOWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:22:11 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB396C06173F;
        Mon, 13 Dec 2021 06:22:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so52345212edd.0;
        Mon, 13 Dec 2021 06:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZhqpRIClxmL3L2f9C0eNsNSKn1Q4wI1JX8StOHhqWy8=;
        b=R2ciQIisPKJ1/aIfk/HBnBS4qbDMB6TVDqzX2Pb798vL/h5dNTBfCAJICUx6CjQRPl
         p0zFwU+RknpKf10mTzueHjA2mgZar+K1MuGOBIeIUbG6xfrwuPN56NCN+VAoNzQa+3vG
         rlmXML9PegDtwHhbili7IhPpPhrEFH8fiQ6UlCZUgNZP/ZLVypmJrOwU0GDi38OwxbWh
         rOAV09uyLoJYf2QnLTXpjNukIh+LFmP037jFTgeI26FvleVQvFuplQBMxtXXJ2wsq5o4
         3Pqm79+kdrFrCVIxtyv0qDGU/4p9W/MAwGDwTGlTkkInONcbivS2c1y09bHkwkL/lN+s
         djHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZhqpRIClxmL3L2f9C0eNsNSKn1Q4wI1JX8StOHhqWy8=;
        b=Jx5fh2HredHB1UkEbZ3gheeLD2JBN80UjQnGTsL6ffTf/FAczb0AfqZ7Jreh3DjIPp
         D6ObPqlsY4BVeuWYnREyvXuFRbKRVGfiyTPsUnA+wvz36R8ALK5Z9uI490twvQCaMMRT
         cJ53+h4wT5pKzinUDVY5vQj8T0WPImTnceIDtaUBWu4bYiUsF3C8QWpa/wfNEWUon1H8
         6ogwgoXC1OVbQKLZ1EdmOy/qq2dEX+9Euse0EDKB9ZH0oTHBQTSBG8Aojvs+8gnYjbwa
         MyV8kRlSD+4TCNbhtGoFLkLVFUPxUmst4Eq1ONCJnTyrwtix2LX0yrkhhPF4ePKrSQh3
         2E+w==
X-Gm-Message-State: AOAM5324vci6med+yIR4j/Mek0At7HLdssAYuslcTxmqyX1jJY4X7I9C
        8enPlmw+lvf1/QFypGF/WwWTVuru+KY=
X-Google-Smtp-Source: ABdhPJyUwUrekilc8/JFRzGxh23flIr6pdF0WoIAQFusNBvSv3Cl6LCyWW9VislXjoxUT58diusg7w==
X-Received: by 2002:a17:906:1b1b:: with SMTP id o27mr44292543ejg.279.1639405329448;
        Mon, 13 Dec 2021 06:22:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id y19sm6826046edc.17.2021.12.13.06.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 06:22:09 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <72bf0b09-6383-d5cd-e719-dcd036b49834@redhat.com>
Date:   Mon, 13 Dec 2021 15:22:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH MANUALSEL 5.10 4/4] KVM: downgrade two BUG_ONs to
 WARN_ON_ONCE
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     kvm@vger.kernel.org
References: <20211213142020.352376-1-sashal@kernel.org>
 <20211213142020.352376-4-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211213142020.352376-4-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 15:20, Sasha Levin wrote:
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
> index 97ac3c6fd4441..4a7d377b3a500 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2590,7 +2590,8 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   	int r;
>   	gpa_t gpa = ghc->gpa + offset;
>   
> -	BUG_ON(len + offset > ghc->len);
> +	if (WARN_ON_ONCE(len + offset > ghc->len))
> +		return -EINVAL;
>   
>   	if (slots->generation != ghc->generation) {
>   		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
> @@ -2627,7 +2628,8 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
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
