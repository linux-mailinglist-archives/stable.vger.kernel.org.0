Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F547D4D2
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 07:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbfHAFUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 01:20:15 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38587 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfHAFUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 01:20:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so33312865pfn.5
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 22:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ByilU0oHOLjKLDAdcNFMrrRyGOR7w5s2w9IJUNLzc/Q=;
        b=TM1wwx99Yv8fB9IJPm1UXWFNGGOC0TweHVPmdsTIlI/yvJ2ElLvfQsmO+TZzISOqPo
         GIDdHMBkaRsgHN/m3BWiv9ZNU8YG3ZPMESEWB7VxaazWDK6YChN7mVWERKuwqPKR3/o9
         cCNTVq5AgTJVNHdQovjcMTrAL8XcHMQQStVbau9jgTNVMtDmJiCz8G4SvPS9Mn/+8DG/
         RwNRfllVFdVkbBw2F6wM4UpKl1mYyvjeNa8+ues2fbx+vtFN7QJ9ej+lrkRfCnz1Cr5i
         3bQhPaRxLvaifPJERA1cTcM57Mtvun2e8AMLY+OmlmT3pWFNX7ngiiD+luI7w0T4UqAM
         K+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ByilU0oHOLjKLDAdcNFMrrRyGOR7w5s2w9IJUNLzc/Q=;
        b=QgYvyCO5wZAlck80y6QqbVEx8Zm4Ispoeg8A8v8gZr+snh87J0UldnqI/DHsVgOTiz
         nLWIMLWunsryLOg5xy02YN3XUk5fxXTFchOviRmACVyCBKU7fwouLXI56GZW+eE7UN+P
         aqWBf0AfwaZfM2pk9q4kxweEGix7zq05MUMxTpNwRt+6slwBJFw8kPkBdbkizaLpavwV
         ELY9Jff+m75lg2y7ZwM/O0LaNjVtJVPnGvHPJO3/FTdGHZS2KA6hpbpwlyCzGpMoERFQ
         ZfAoPyskhoTcupjzdRJ6gd7og7X9Xo3JEXjQ+2Gma8maZUUROVc2LCgbr35fDHVQMmJk
         VXXQ==
X-Gm-Message-State: APjAAAWmlQPelfvvlEWG7rLXXlz7xN0m9Eyo5RJUN+5JguiyguedYr/k
        hFcUhr6PMdklJRrTZ/uMomna7A==
X-Google-Smtp-Source: APXvYqx+yL0UJaSz+q9AN3LrrV43T11zeoEPEKnpQ9C6/VjWRF61rdKAr4tBlUF2gIlwAswV0U/SOw==
X-Received: by 2002:a65:64cf:: with SMTP id t15mr113670369pgv.88.1564636813755;
        Wed, 31 Jul 2019 22:20:13 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id r13sm98686393pfr.25.2019.07.31.22.20.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 22:20:12 -0700 (PDT)
Date:   Thu, 1 Aug 2019 10:50:11 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: Re: [PATCH v4.4 V2 24/43] arm64: Add skeleton to harden the branch
 predictor against aliasing attacks
Message-ID: <20190801052011.2hrei36v4zntyfn5@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <4349161f0ed572bbc6bff64bad94aa96d07b27ff.1562908075.git.viresh.kumar@linaro.org>
 <20190731164556.GI39768@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731164556.GI39768@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-07-19, 17:45, Mark Rutland wrote:
> On Fri, Jul 12, 2019 at 10:58:12AM +0530, Viresh Kumar wrote:
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit 0f15adbb2861ce6f75ccfc5a92b19eae0ef327d0 upstream.
> > 
> > Aliasing attacks against CPU branch predictors can allow an attacker to
> > redirect speculative control flow on some CPUs and potentially divulge
> > information from one context to another.
> > 
> > This patch adds initial skeleton code behind a new Kconfig option to
> > enable implementation-specific mitigations against these attacks for
> > CPUs that are affected.
> > 
> > Co-developed-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > [ v4.4: Changes made according to 4.4 codebase ]
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> [...]
> 
> >  /* id_aa64pfr0 */
> > +#define ID_AA64PFR0_CSV2_SHIFT		56
> 
> Note: CSV3 is bits 63-60, 
> 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 474b34243521..040a42d79990 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -83,7 +83,8 @@ static struct arm64_ftr_bits ftr_id_aa64isar0[] = {
> >  };
> >  
> >  static struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
> > -	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 32, 0),
> > +	ARM64_FTR_BITS(FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_CSV2_SHIFT, 4, 0),
> > +	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 28, 0),
> 
> This line should be:
> 
> 	ARM64_FTR_BITS(FTR_STRICT, FTR_EXACT, 32, 24, 0),
> 
> ... as it was in the v4.9 backbort, making it cover bits 55:32. As in
> this patch, it covers 59:32, overlapping with CSV2.

Fixed thanks.

> We also need to cater for bits 63:60. In the v4.9 backport, the meltdown
> bits were applied first, so nothing special was necessary.
> 
> What's the plan w.r.t. meltdown mitigations and v4.4?

I haven't started looking at meltdown patches yet and so that will be
done at a later point of time, if at all done by me. I have been asked
to backport both Spectre and Meltdown though to 4.4.

-- 
viresh
