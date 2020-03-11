Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9792F182095
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730688AbgCKSSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:18:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730679AbgCKSSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 14:18:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583950716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IIEuNm0s1KSd9ucNBIED5u8XC49ZUleRh3A+TtaDM9A=;
        b=F/NG77U8vdv0gKQZex9AH4h+EGa1K1C082Ta7yXSMZNKms8jzxmH0RYZasvXZ5kgQfRcvJ
        P4O1a/anPsEIE0KuKvdDsWiYG2YCEmYyyg014nKql4ucKSj8JkH5UNyMvpvRNnMoc17iIz
        4zGhPo2mLZp4aFw/ouc8UGkuDe6P940=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-Rk2fVxmvNaahqEnx-I_oig-1; Wed, 11 Mar 2020 14:18:34 -0400
X-MC-Unique: Rk2fVxmvNaahqEnx-I_oig-1
Received: by mail-wr1-f70.google.com with SMTP id j17so1313604wru.19
        for <stable@vger.kernel.org>; Wed, 11 Mar 2020 11:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IIEuNm0s1KSd9ucNBIED5u8XC49ZUleRh3A+TtaDM9A=;
        b=frP0hp3R03sZ9FW9NMaKdC98q/OPAnGIp1a6jrW3ZsYeR4yoUBgA7wZCF194A6dAaj
         4ZKsQdZIUaCIGdFwpykioAXJih7afVsaT/6h88RaeGptMU9jORnZDWsDku9Sf4n4+2Lq
         Br5BwUe1hsCD2wJLxEn0Jfad0DuGEMq2DgYfVHU452ZWUwissbTPE2o3d97DLNL1/PVH
         p6ZDmNEKQCRZGrYEA73eFxfuV5uhlm4ZCi/uxf14XFm5dBUrCBkHwHdCk0ng7G7fLRHu
         ZBaESY2rQiPRmf9dxpYR8cIV1FokuSpQ41i2SK+cA3R5zu2bWDnT17A/l5yL3lurFZlP
         qdFQ==
X-Gm-Message-State: ANhLgQ1KeRzsz6lgvZgZ18ESpLDkSpqXXlK34PSyxawuB1b+tCaVDkbs
        wYRWXDm8XkRnbZR3xb+30FQWD33eHWn83EKcx8hRdVOptwKveehVmeqF4a7zpdrsaMEnpb6FSSJ
        Bat4uBgd/SgnxfCxF
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr35472wmb.118.1583950713297;
        Wed, 11 Mar 2020 11:18:33 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vull0VAoH6OT00g7UtPFzzvBf5edDKUbKJ3cpfh/bStE6A6kp/2YRlGvAJBVLJS4Bh77Ftt5Q==
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr35442wmb.118.1583950713010;
        Wed, 11 Mar 2020 11:18:33 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c0c-fe00-fc7e-fd47-85c1-1ab3.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:fc7e:fd47:85c1:1ab3])
        by smtp.gmail.com with ESMTPSA id r9sm1977728wma.47.2020.03.11.11.18.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 11:18:32 -0700 (PDT)
Subject: Re: [PATCH v4 1/3] x86/tsc_msr: Use named struct initializers
To:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        Rahul Tanwar <rahul.tanwar@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200223140610.59612-1-hdegoede@redhat.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <9705677f-f52e-938f-a84a-8db8afc9fc8f@redhat.com>
Date:   Wed, 11 Mar 2020 19:18:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200223140610.59612-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 2/23/20 3:06 PM, Hans de Goede wrote:
> Use named struct initializers for the freq_desc struct-s initialization
> and change the "u8 msr_plat" to a "bool use_msr_plat" to make its meaning
> more clear instead of relying on a comment to explain it.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I believe that this series is ready for merging now? Can we
please get this merged?

Regards,

Hans


> ---
>   arch/x86/kernel/tsc_msr.c | 28 ++++++++++++++++++----------
>   1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
> index e0cbe4f2af49..5fa41ac3feb1 100644
> --- a/arch/x86/kernel/tsc_msr.c
> +++ b/arch/x86/kernel/tsc_msr.c
> @@ -22,10 +22,10 @@
>    * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
>    * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
>    * so we need manually differentiate SoC families. This is what the
> - * field msr_plat does.
> + * field use_msr_plat does.
>    */
>   struct freq_desc {
> -	u8 msr_plat;	/* 1: use MSR_PLATFORM_INFO, 0: MSR_IA32_PERF_STATUS */
> +	bool use_msr_plat;
>   	u32 freqs[MAX_NUM_FREQS];
>   };
>   
> @@ -35,31 +35,39 @@ struct freq_desc {
>    * by MSR based on SDM.
>    */
>   static const struct freq_desc freq_desc_pnw = {
> -	0, { 0, 0, 0, 0, 0, 99840, 0, 83200 }
> +	.use_msr_plat = false,
> +	.freqs = { 0, 0, 0, 0, 0, 99840, 0, 83200 },
>   };
>   
>   static const struct freq_desc freq_desc_clv = {
> -	0, { 0, 133200, 0, 0, 0, 99840, 0, 83200 }
> +	.use_msr_plat = false,
> +	.freqs = { 0, 133200, 0, 0, 0, 99840, 0, 83200 },
>   };
>   
>   static const struct freq_desc freq_desc_byt = {
> -	1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
> +	.use_msr_plat = true,
> +	.freqs = { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
>   };
>   
>   static const struct freq_desc freq_desc_cht = {
> -	1, { 83300, 100000, 133300, 116700, 80000, 93300, 90000, 88900, 87500 }
> +	.use_msr_plat = true,
> +	.freqs = { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
> +		   88900, 87500 },
>   };
>   
>   static const struct freq_desc freq_desc_tng = {
> -	1, { 0, 100000, 133300, 0, 0, 0, 0, 0 }
> +	.use_msr_plat = true,
> +	.freqs = { 0, 100000, 133300, 0, 0, 0, 0, 0 },
>   };
>   
>   static const struct freq_desc freq_desc_ann = {
> -	1, { 83300, 100000, 133300, 100000, 0, 0, 0, 0 }
> +	.use_msr_plat = true,
> +	.freqs = { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
>   };
>   
>   static const struct freq_desc freq_desc_lgm = {
> -	1, { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 }
> +	.use_msr_plat = true,
> +	.freqs = { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
>   };
>   
>   static const struct x86_cpu_id tsc_msr_cpu_ids[] = {
> @@ -91,7 +99,7 @@ unsigned long cpu_khz_from_msr(void)
>   		return 0;
>   
>   	freq_desc = (struct freq_desc *)id->driver_data;
> -	if (freq_desc->msr_plat) {
> +	if (freq_desc->use_msr_plat) {
>   		rdmsr(MSR_PLATFORM_INFO, lo, hi);
>   		ratio = (lo >> 8) & 0xff;
>   	} else {
> 

