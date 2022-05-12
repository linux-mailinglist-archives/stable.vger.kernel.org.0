Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA3552526B
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 18:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356186AbiELQW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356434AbiELQWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 12:22:22 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78BF1EE0B7;
        Thu, 12 May 2022 09:22:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 2D5C632008C0;
        Thu, 12 May 2022 12:22:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 12 May 2022 12:22:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652372537; x=1652458937; bh=cpMJqs2BPo
        uThgcWTZqhODB+0SLfKgwqdJV/jowmtjE=; b=OQi7CuJ4Quxmrh6Igu5bPVn94D
        r6Q1n3lQuyMvgJp1Wus4vJFuyQS/4e4hc/AKlZPbqRs3VV78b3Fit/l1gH5mZrea
        pw8E8BnWjyUaIGlBNg6UawHFu7VdeCCc+Fh+pjZZ+7aSsjLMXyQUZOjWjpf1mojQ
        ElZzK5VJ06W0r3CR95L3aUQNYFZBZnzcmiU+ZSTSLKsf/S2PTrwnxnJ81jcOFpmr
        00ANz+5K5j28u+MIApCugalXK/O1LxBG0we9vXalfEuuLZGgWAqm68qvRE0/2T56
        Sjh5K7bDTQVvxUaeSpv6+akTxsRJxZ0nQT5Zi3tLRcWUpPv0nXokwHGjo59w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652372537; x=
        1652458937; bh=cpMJqs2BPouThgcWTZqhODB+0SLfKgwqdJV/jowmtjE=; b=X
        gfUrRUARFIdakEMpkSWJl+D0ZAsUo4BI7UzPhkPyXMaehkGGagAkYHUo/Q8EGuIP
        QToTB9T8oNzXs8CRGyvjN1FJmLL6quuB6759Xn6+OAIpJmf/Z/6nQpy+JtHlg4rJ
        8iq1iXIMJ1iCoXh6ZipOEABLZ8jGNm0vcXBzk31TwLfHm0QDAlSRXq8XzRt8P1Xt
        IAB43nKcn+D4n42N2enc91S2qtaEeWxOAXy3PXed0ovKlbbme1V/r9pLyEq1twVO
        3raYlzr1Qh/7gP6PTntC1wn/KstmLFBBDI7dPrmvp784sgZg6AWHel8d4tkvDRa0
        QrBtkDw3Qv50gbX7h3XyA==
X-ME-Sender: <xms:ODR9YrDN2d9UBQQXwmmKafjVuRJejZtAXWXWaz3MKZfpE32MQ1whng>
    <xme:ODR9YhjQvoTBEdB3JGg4mrCeODm_ODQVKtFWJb3uAqaWtgnz8VYaXA1k4QyFzlplx
    3h5i17u5nuM3Q>
X-ME-Received: <xmr:ODR9YmmCtJHinAfc2_RFO4YuBRlMk5ZUlp3ZgCxtJEHtD9eBioUeY4ulo59JUgAQB3dG0o1wWsTYsMMbWwT4mkiFDcODl0oM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedtheeige
    egueejffejleefkeevjeegiedtgfeigeetudeghfekjeelieelffefjeenucffohhmrghi
    nheprhhrqdhprhhojhgvtghtrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ODR9YtxItcJMGtOdRYx51kKNfdr0x-70BK4z6nf1x5TkE-t-jdx6Fg>
    <xmx:ODR9YgRyufX6mgUX6kTINajd6josu9QVCIQTfQTN4xjcmFk85mSFSA>
    <xmx:ODR9YgbA-1CpEJNRtmodMtqgitMQTWxDcMeSBQ5nAUp5ByjtlAS4cw>
    <xmx:OTR9YnLl9RObvQZC8RkT_r-1Bbb-I-_D2AOpR6p1DFamwZ8Kc_czcg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 May 2022 12:22:16 -0400 (EDT)
Date:   Thu, 12 May 2022 18:22:13 +0200
From:   Greg KH <greg@kroah.com>
To:     Kyle Huey <me@kylehuey.com>
Cc:     stable@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Robert O'Callahan <robert@ocallahan.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.4] KVM: x86/svm: Account for family 17h event
 renumberings in amd_pmc_perf_hw_id
Message-ID: <Yn00NbPVMOUF9yM/@kroah.com>
References: <20220512143852.90281-1-khuey@kylehuey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512143852.90281-1-khuey@kylehuey.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 12, 2022 at 07:38:52AM -0700, Kyle Huey wrote:
> From: Kyle Huey <me@kylehuey.com>
> 
> commit 5eb849322d7f7ae9d5c587c7bc3b4f7c6872cd2f upstream
> 
> Zen renumbered some of the performance counters that correspond to the
> well known events in perf_hw_id. This code in KVM was never updated for
> that, so guest that attempt to use counters on Zen that correspond to the
> pre-Zen perf_hw_id values will silently receive the wrong values.
> 
> This has been observed in the wild with rr[0] when running in Zen 3
> guests. rr uses the retired conditional branch counter 00d1 which is
> incorrectly recognized by KVM as PERF_COUNT_HW_STALLED_CYCLES_BACKEND.
> 
> [0] https://rr-project.org/
> 
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> Message-Id: <20220503050136.86298-1-khuey@kylehuey.com>
> Cc: stable@vger.kernel.org
> [Check guest family, not host. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [Backport to 5.15: adjusted context]
> Signed-off-by: Kyle Huey <me@kylehuey.com>
> ---
>  arch/x86/kvm/pmu_amd.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu_amd.c b/arch/x86/kvm/pmu_amd.c
> index f843c6bbcd31..799b9a3144e3 100644
> --- a/arch/x86/kvm/pmu_amd.c
> +++ b/arch/x86/kvm/pmu_amd.c
> @@ -44,6 +44,22 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
>  	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
>  };
>  
> +/* duplicated from amd_f17h_perfmon_event_map. */
> +static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
> +	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
> +	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
> +	[2] = { 0x60, 0xff, PERF_COUNT_HW_CACHE_REFERENCES },
> +	[3] = { 0x64, 0x09, PERF_COUNT_HW_CACHE_MISSES },
> +	[4] = { 0xc2, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
> +	[5] = { 0xc3, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> +	[6] = { 0x87, 0x02, PERF_COUNT_HW_STALLED_CYCLES_FRONTEND },
> +	[7] = { 0x87, 0x01, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
> +};
> +
> +/* amd_pmc_perf_hw_id depends on these being the same size */
> +static_assert(ARRAY_SIZE(amd_event_mapping) ==
> +	     ARRAY_SIZE(amd_f17h_event_mapping));
> +
>  static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
>  {
>  	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> @@ -128,19 +144,25 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>  
>  static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
>  {
> +	struct kvm_event_hw_type_mapping *event_mapping;
>  	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
>  	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
>  	int i;
>  
> +	if (guest_cpuid_family(pmc->vcpu) >= 0x17)
> +		event_mapping = amd_f17h_event_mapping;
> +	else
> +		event_mapping = amd_event_mapping;
> +
>  	for (i = 0; i < ARRAY_SIZE(amd_event_mapping); i++)
> -		if (amd_event_mapping[i].eventsel == event_select
> -		    && amd_event_mapping[i].unit_mask == unit_mask)
> +		if (event_mapping[i].eventsel == event_select
> +		    && event_mapping[i].unit_mask == unit_mask)
>  			break;
>  
>  	if (i == ARRAY_SIZE(amd_event_mapping))
>  		return PERF_COUNT_HW_MAX;
>  
> -	return amd_event_mapping[i].event_type;
> +	return event_mapping[i].event_type;
>  }
>  
>  /* return PERF_COUNT_HW_MAX as AMD doesn't have fixed events */
> -- 
> 2.36.0
> 

Now queued up, thanks.

greg k-h
