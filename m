Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A70C3AE958
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 14:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFUMqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 08:46:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhFUMqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 08:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624279479;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xY6nAdAkng/ghHrBQBfm1ZmFUpZlorDdA2kwXRZ+7xU=;
        b=CdhEmGvziaL/OuEkEanrvzqxYOUc8ePwofpomZazzpX1+IHaLKI/07kYHVeM2ckTt6SVPh
        ApI7WAbbB2Qou1WfnEzJhIVteTw8X+caBgUIINrITQVAO/Yyz+THqYtvgipUiyQs05itIA
        8f0quz+4INSby09ukn474WtYs7wySxE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-k2Mlj9eKPMWetz_oVCzEwg-1; Mon, 21 Jun 2021 08:44:37 -0400
X-MC-Unique: k2Mlj9eKPMWetz_oVCzEwg-1
Received: by mail-wr1-f71.google.com with SMTP id l2-20020adfe5820000b029011a64161d6aso8428875wrm.6
        for <stable@vger.kernel.org>; Mon, 21 Jun 2021 05:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=xY6nAdAkng/ghHrBQBfm1ZmFUpZlorDdA2kwXRZ+7xU=;
        b=gMkTcw2jQMoexL2fyMwKYIxJ56qKS9j/YFVKcCtwlVSml3WRdmgQwdasU/0c0e3T3K
         k1Z4aHtD+g3cpifXzPh2i+U/dkOwkqXCFBGa1bPm8SG/g9V6nFgjYn+GII6oXuJ+z0Ld
         5y6yFIr2c25299AkSsOO/fjwfNdTOH+cWPg+IHK0qv3b1G+zkDK9Tvckq3v4HFxWOjnA
         9lW11XMcJ3Sv3koIsA/cRNIz9nFPZqlhLKnkZvQUgqFrJm//4AxY8d0VWD7GKhxglpxi
         6nn3tsGOPPiahnYLg28Wb9WDA0odUEnkyEjHP9W+jLLY8YsasMRPyf4eUDdESq7OgqNg
         1Lmg==
X-Gm-Message-State: AOAM533AFsyL/4GL9FWVqhy5Z5A4oSXtl194vxT3EI7yGEY6S+OtjCUQ
        aD8WUQwwSOpntPuJVEW+fGTqbrJnKoXtxriJAxRF/ek6O+pJehdZ+I5BBC0okZLw+HUqbWW3ORm
        2i5A9dOm847CV1RV6
X-Received: by 2002:a5d:47af:: with SMTP id 15mr27383122wrb.289.1624279475168;
        Mon, 21 Jun 2021 05:44:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiQHL5PA0rXiLB9N/4Ymzd355PSqLCUCP+mLc4znMmOdX5sFeuYsZH8JOoThSHcMZrCXCncg==
X-Received: by 2002:a5d:47af:: with SMTP id 15mr27383108wrb.289.1624279475043;
        Mon, 21 Jun 2021 05:44:35 -0700 (PDT)
Received: from [192.168.43.95] ([37.173.110.237])
        by smtp.gmail.com with ESMTPSA id r1sm716931wmn.10.2021.06.21.05.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 05:44:34 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
To:     eric.auger.pro@gmail.com, stable@vger.kernel.org, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210621121839.792649-1-eric.auger@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <495e1326-14aa-7d7e-abf4-1054978c8de2@redhat.com>
Date:   Mon, 21 Jun 2021 14:44:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210621121839.792649-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 6/21/21 2:18 PM, Eric Auger wrote:
> When reading the base address of the a REDIST region
> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
> redistributor region list to be populated with a single
> element.
>
> However list_first_entry() expects the list to be non empty.
> Instead we should use list_first_entry_or_null which effectively
> returns NULL if the list is empty.
>
> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
> Cc: <Stable@vger.kernel.org> # v4.19
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reported-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com

so I have resent with the [PATCH for-stable-4.19] prefix.
Please ignore that patch and sorry for the mess.

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-kvm-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 6ada2432e37c..71d92096776e 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -95,8 +95,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>  			goto out;
>  		}
> -		rdreg = list_first_entry(&vgic->rd_regions,
> -					 struct vgic_redist_region, list);
> +		rdreg = list_first_entry_or_null(&vgic->rd_regions,
> +						 struct vgic_redist_region, list);
>  		if (!rdreg)
>  			addr_ptr = &undef_value;
>  		else

