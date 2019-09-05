Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0167FA9C28
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 09:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfIEHpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 03:45:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42396 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfIEHpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 03:45:11 -0400
Received: by mail-pf1-f194.google.com with SMTP id w22so1172766pfi.9
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 00:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hpCUEGddX7qZLrDE/1ojj9wnkPMw6M1KGQTh1eKUChU=;
        b=SsnUCEcCbGGi4OuiIojnwuy1Ee1+ueJDvGIE8Q02a2QFmbConzEYQb4DP/a+yh5yML
         ZTP0ZI3nP5KRxtf6jCw8NjPLtG7bU61kUQQRfCt2DkOIHR52JELw1RNT1I5zvvHAIDSr
         /qAts2dyovBObTSLxRR9Xo9gnCDc3J/etQW0dlu/MK85xWPqiis6iPbvY6HEMr8fuwm4
         gz2D0qtOXrieZ1waZe86IyltHwsTPgEN15ooTGZhiGvK7GMLVLO0Xz8flIH0er565G2j
         q4AbrYw4B6hz2nMoqiALLqeaBoi4GUmP5b+wYE35sZjO2AUpggcBNmjHVB6TdD1Jr6Df
         JQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hpCUEGddX7qZLrDE/1ojj9wnkPMw6M1KGQTh1eKUChU=;
        b=dTaDHvO439K97ZhQsJWhAlqIGO3kSGdKKabxiI2jwd967DthldVClYngGqYhwqLyxe
         FQsTI1lOoBbkUNIaLcjQWUSJFT9Lrk9UtZ7fQE2rVMdPVWGVqAGvKvxnOzgf7O/5GVvk
         4ePObmT0TPB+Im/6nGxURQoiPZYWl6tf6kZDE5tpzDuie/2dijpAWtBiidwbgEIYDVDP
         QAJLm61sZXt8InO323GbugFzxvyC9eZIhFm8aVJu0kI8sF5AduUAHKEhkThyPRKj0Kl/
         6O5gwIiJbh0Bd3UsgajsiENkIAkaJlVGpv3h6IbvT+mDurPnRrlXbBnliTecXgMJIdS1
         /VYA==
X-Gm-Message-State: APjAAAVX7I4Obzd6Ng1YyH/r/bM/FfnX3TfBNQJJl9rwi53X1pcdGElL
        JE7arclJIOFZe9h/hLVFtt8jWg==
X-Google-Smtp-Source: APXvYqwf0YX6tt1CPUpyTzEzZQjgLyT4wvcmEy6Ovf5SU/FcoQviQhfq965/ABavnjJQs6c9+uWbuA==
X-Received: by 2002:a62:d4:: with SMTP id 203mr2120282pfa.210.1567669509669;
        Thu, 05 Sep 2019 00:45:09 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id j128sm2936214pfg.51.2019.09.05.00.45.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Sep 2019 00:45:08 -0700 (PDT)
Date:   Thu, 5 Sep 2019 13:15:06 +0530
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
Subject: Re: [PATCH ARM64 v4.4 V3 12/44] arm64: cpufeature: Test 'matches'
 pointer to find the end of the list
Message-ID: <20190905074506.oxsw24xoex7gcfgm@vireshk-i7>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
 <617ad445043f040c5ab986b9620b2ba7847b561e.1567077734.git.viresh.kumar@linaro.org>
 <20190902142741.GB9922@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902142741.GB9922@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02-09-19, 15:27, Mark Rutland wrote:
> On Thu, Aug 29, 2019 at 05:03:57PM +0530, Viresh Kumar wrote:
> > From: James Morse <james.morse@arm.com>
> > 
> > commit 644c2ae198412c956700e55a2acf80b2541f6aa5 upstream.
> > 
> > CPU feature code uses the desc field as a test to find the end of the list,
> > this means every entry must have a description. This generates noise for
> > entries in the list that aren't really features, but combinations of them.
> > e.g.
> > > CPU features: detected feature: Privileged Access Never
> > > CPU features: detected feature: PAN and not UAO
> > 
> > These combination features are needed for corner cases with alternatives,
> > where cpu features interact.
> > 
> > Change all walkers of the arm64_features[] and arm64_hwcaps[] lists to test
> > 'matches' not 'desc', and only print 'desc' if it is non-NULL.
> > 
> > Signed-off-by: James Morse <james.morse@arm.com>
> > Reviewed-by : Suzuki K Poulose <suzuki.poulose@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  arch/arm64/kernel/cpufeature.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> >From looking at my 4.9.y/{meltdown,spectre} banches on kernel.org [1,2],
> and chasing the history v4.4..v4.9, there are a number of patches I'd
> expect to have alongside this that I don't spot in this series:
> 
> * e3661b128e53ee281e1e7c589a5b647890bd6d7c ("arm64: Allow a capability to be checked on a single CPU")
> * 8f4137588261d7504f4aa022dc9d1a1fd1940e8e ("arm64: Allow checking of a CPU-local erratum")
> * 67948af41f2e6818edeeba5182811c704d484949 ("arm64: capabilities: Handle duplicate entries for a capability")
> * edf298cfce47ab7279d03b5203ae2ef3a58e49db ("arm64: cpufeature: __this_cpu_has_cap() shouldn't stop early")

I also had to pick this one for cleaner rebase:

752835019c15 arm64: HWCAP: Split COMPAT HWCAP table entries

> 
> ... which IIUC are necessary for big.LITTLE to work correctly.

I have pushed the changes to my branch again with above 5 patches and
some more reordering to match 4.9 log.

> Have you verified this for big.LITTLE?

Not sure if we ever talked about this earlier, but here is the
situation which I explained to Julien earlier.

I don't have access to the test-suite to verify that these patches
indeed fix the spectre mitigations and I was asked to backport these
and then ask for help from ARM to get these tested through the
test-suite. I was expecting Julien to do that earlier.

Julien did ask me to verify few things earlier, which can be done
without the test suite and was about checking that the new code paths
are getting hit now or not, which I did.

I haven't tested these on big LITTLE, though I can get the branch
through LAVA to get it tested on big LITTLE but I have no clue on what
I should be looking for in results :)

If there is some testing that can be done on my side for this, I sure
can do it. But I would need help from you on that to know what exactly
I need to check.

Thanks for the reviews Mark.

-- 
viresh
