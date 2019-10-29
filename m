Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B13E8DA0
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390518AbfJ2RGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 13:06:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39747 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390436AbfJ2RGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 13:06:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id p12so10005326pgn.6
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 10:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u4GnrTtOrQejEaELYRBPSBE1OQ/6WvsreGc0J38yGc4=;
        b=XVWRXF/oQeqO5hH9MARUaj/lEcqlZvJbHvV6EO4Kut1kVF5eW35IIzTOHx/WYTrR54
         X3Ltd/8PkY9MLBzG7hJTP9eGaRITzL890W1dDPbxiDe1GZakMyCU0ElbfFOGkTdZ18uU
         YDBrfpUcUilQVaDw38ZYzkoCcHPJrglUtXc/+QL+kXavMHBjwJVJy3YHB4GJsliSzCrz
         FF05853tBjX97KOLJx1zMwKIrvNbNo8wMQ1Zuhi0/K7wDoBw35GUmfbeFrepewkFZhVa
         KDIby2o4jPPDg6NZNtMU/naIDRSlvVWPED0z6MorsCcmq7niig++8q81VSvN+ZbZFxHQ
         FpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=u4GnrTtOrQejEaELYRBPSBE1OQ/6WvsreGc0J38yGc4=;
        b=A7qi8gSkyApmcrJRLrxSBVRzVkF4fQS/vZrCpUAp5ZZ8m7QaF5O2jDNzHtoBH8jNFt
         BuBXTUn899JaBiXP86DcscT9W4t///GhPnIRBV+aZxsHd3u8j0a2zV75PVaINrU7UqJ1
         bnRTFyuqbCq29y6K8Hi0R7EJkJP6v2JmWUsum8UNUuCp+1Dgc1I09exATPBedj1OF8V2
         yqD9sr1tFmtcelbpfuH3YbHuffkFQWt3fPV4k3oDfuM3o2zlpkCkL12lu8pvweeCnq0/
         16XvDVI3Z2dz2ZjEsZ8oTKehtiWMsZE+NFehQ9MukOEeWCFpSIiaDJhSSqkTzC0GUP+A
         LAXw==
X-Gm-Message-State: APjAAAUJgv9DQuUuEh0BkJxxFwdSUmh82tRLuLxqS7KZpV55mH44zils
        68dsEQd5eehMqxxIBWZGcj989w==
X-Google-Smtp-Source: APXvYqxxmhkL7zLBgZCW8TKbKUkshYT4R+uLXT2RMbgocDu5SuK+1rnnfEXwzR+Htceb946hUMHc/A==
X-Received: by 2002:a65:5541:: with SMTP id t1mr28199191pgr.39.1572368797042;
        Tue, 29 Oct 2019 10:06:37 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id 37sm13127555pgv.32.2019.10.29.10.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 10:06:36 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:06:33 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     will@kernel.org, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        broonie@kernel.org
Subject: Re: [PATCH] arm64: cpufeature: Enable Qualcomm erratas
Message-ID: <20191029170633.GX571@minitux>
References: <20191029060432.1208859-1-bjorn.andersson@linaro.org>
 <20191029113956.GC12103@willie-the-truck>
 <1d1a3dca-16ce-f541-5d78-e61ad24227e0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d1a3dca-16ce-f541-5d78-e61ad24227e0@arm.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 29 Oct 05:04 PDT 2019, Suzuki K Poulose wrote:

> On 10/29/2019 11:39 AM, Will Deacon wrote:
> > On Mon, Oct 28, 2019 at 11:04:32PM -0700, Bjorn Andersson wrote:
> > > With the introduction of 'cce360b54ce6 ("arm64: capabilities: Filter the
> > > entries based on a given mask")' the Qualcomm erratas are no long
> > > applied.
> > > 
> > > The result of not applying errata 1003 is that MSM8996 runs into various
> > > RCU stalls and fails to boot most of the times.
> > > 
> > > Give both 1003 and 1009 a "type" to ensure they are not filtered out in
> > > update_cpu_capabilities().
> > 
> > Oh nasty. Thanks for debugging and fixing this.
> > 
> > > Fixes: cce360b54ce6 ("arm64: capabilities: Filter the entries based on a given mask")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Mark Brown <broonie@kernel.org>
> > > Suggested-by: Will Deacon <will@kernel.org>
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > > ---
> > >   arch/arm64/kernel/cpu_errata.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> > > index df9465120e2f..cdd8df033536 100644
> > > --- a/arch/arm64/kernel/cpu_errata.c
> > > +++ b/arch/arm64/kernel/cpu_errata.c
> > > @@ -780,6 +780,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> > >   	{
> > >   		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
> > >   		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
> > > +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
> > >   		.matches = cpucap_multi_entry_cap_matches,
> > 
> > This should probably be ARM64_CPUCAP_LOCAL_CPU_ERRATUM instead, but I'll
> > want Suzuki's ack before I take the change.
> 
> Yes, it must be ARM64_CPUCAP_LOCAL_CPU_ERRATUM.
> 

Thanks, will fix.

> It may be a good idea to stick in a check to make sure that the scope is
> set for all the capabilities in a separate patch. e.g,
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index d260e3bdf07b..51a79b4a44eb 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -546,6 +546,8 @@ static void __init
>  init_cpu_hwcaps_indirect_list_from_array(const struct
> arm64_cpu_capabilities *caps)
>  {
>  	for (; caps->matches; caps++) {
> +		WARN(!cpucap_default_scope(caps),
> +		     "Invalid scope for capability %d\n", caps->capability);
>  		if (WARN(caps->capability >= ARM64_NCAPS,
>  			"Invalid capability %d\n", caps->capability))
> 			continue;

In hindsight this would have saved me a considerable amount of time, so
I like this proposal!

Regards,
Bjorn

> 
> Otherwise looks good to me.
> 
> > >   		.match_list = qcom_erratum_1003_list,
> > >   	},
> > > @@ -788,6 +789,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> > >   	{
> > >   		.desc = "Qualcomm erratum 1009, ARM erratum 1286807",
> > >   		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
> > > +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
> > >   		ERRATA_MIDR_RANGE_LIST(arm64_repeat_tlbi_cpus),
> > 
> > ERRATA_MIDR_RANGE_LIST sets the type already, so I think this is redundant.
> > 
> > Will
> > 
> 
> 
> 
> Cheers
> Suzuki
