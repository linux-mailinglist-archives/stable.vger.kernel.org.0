Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF599E8D95
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 18:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390740AbfJ2REC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 13:04:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45923 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390731AbfJ2REC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 13:04:02 -0400
Received: by mail-pf1-f193.google.com with SMTP id c7so8828335pfo.12
        for <stable@vger.kernel.org>; Tue, 29 Oct 2019 10:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q5qKTb2AGnzQjjrVBPZDGTc0pOQQJCIJrhUvwgBwwt8=;
        b=y3TOYber+p0qKKhM7TPlBuz0zXaB//zf1AuJ4gnhs3TT2teityV1QJVea37wsKzDVS
         GhewnCBAkvafmxm3hZwU7zZrfS164DlFCovqYyxmQoJH4Vqq+dDuohxAHXup0VYM8Sqn
         30+IiCwmpgU3xzdJLodL5i/TQLPeynrGS+Fqjbq6ikazkKAac6DRuFJY/1yXrZYvQu/H
         R7s43g5g4866mW1NiHcavB3OseMzA6nBOpW8dDqjnE4vRwTWhvhvddWzbUEH+GJTf4hZ
         cqG+tC4Zj91pvq11DPRkCKPBLUu74TMxQp1DEAe4OLkwvty/3YuCP+owQcVHXWOSKj5p
         e2mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Q5qKTb2AGnzQjjrVBPZDGTc0pOQQJCIJrhUvwgBwwt8=;
        b=oFKqmQqNE6Y8P88j54jcRoHXcXtlr1H1a0Ghn+HeEIG34WfNK/98TsmiNbmcvTqUQB
         VbNE7Gk8sZflif3eBpWEV96thDqBcUxYi+Ho1lohD5jOVfA8hzA1XKA/m9b7jUb3H0Ka
         pjDHwE0Lytbhy3u4UFkKwQPeCj8oPxjkeprEHJcKe9GuefOQm5HSndMnHV5dnmGtEVug
         m9QFgnbwD2Vs5YaUwjBy6Zg+BzFjLb7rhSxJB+ZzlXifzNNUMAZqCzl6S/UU+DLzskbo
         CGbQdO7i+e+g+FtOSCegxFgfND/QGljG/Q+7Ic6IaVZ1/JGf32C+YTtf6LI1WUl9e7Op
         11eg==
X-Gm-Message-State: APjAAAWN46Ponct40DHbXxVfVyyebvhrfKN6Xjc34GWlfYkDR4koGNia
        IZrGeX/ivvrPW9R4FeBXKYRSSg==
X-Google-Smtp-Source: APXvYqyr6EB0JTFhtAMYl+t/hU+USnVlB+EYIp1st5QMMmHXT4WXGhGGGAWyx57D7FIYLb07L0FktQ==
X-Received: by 2002:a65:47cd:: with SMTP id f13mr7492243pgs.356.1572368641038;
        Tue, 29 Oct 2019 10:04:01 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id e3sm1070108pff.134.2019.10.29.10.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 10:04:00 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:03:57 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] arm64: cpufeature: Enable Qualcomm erratas
Message-ID: <20191029170357.GW571@minitux>
References: <20191029060432.1208859-1-bjorn.andersson@linaro.org>
 <20191029113956.GC12103@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029113956.GC12103@willie-the-truck>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 29 Oct 04:39 PDT 2019, Will Deacon wrote:

> On Mon, Oct 28, 2019 at 11:04:32PM -0700, Bjorn Andersson wrote:
> > With the introduction of 'cce360b54ce6 ("arm64: capabilities: Filter the
> > entries based on a given mask")' the Qualcomm erratas are no long
> > applied.
> > 
> > The result of not applying errata 1003 is that MSM8996 runs into various
> > RCU stalls and fails to boot most of the times.
> > 
> > Give both 1003 and 1009 a "type" to ensure they are not filtered out in
> > update_cpu_capabilities().
> 
> Oh nasty. Thanks for debugging and fixing this.
> 
> > Fixes: cce360b54ce6 ("arm64: capabilities: Filter the entries based on a given mask")
> > Cc: stable@vger.kernel.org
> > Reported-by: Mark Brown <broonie@kernel.org>
> > Suggested-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> >  arch/arm64/kernel/cpu_errata.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> > index df9465120e2f..cdd8df033536 100644
> > --- a/arch/arm64/kernel/cpu_errata.c
> > +++ b/arch/arm64/kernel/cpu_errata.c
> > @@ -780,6 +780,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> >  	{
> >  		.desc = "Qualcomm Technologies Falkor/Kryo erratum 1003",
> >  		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1003,
> > +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
> >  		.matches = cpucap_multi_entry_cap_matches,
> 
> This should probably be ARM64_CPUCAP_LOCAL_CPU_ERRATUM instead, but I'll
> want Suzuki's ack before I take the change.
> 

Sure thing, will fix!

> >  		.match_list = qcom_erratum_1003_list,
> >  	},
> > @@ -788,6 +789,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> >  	{
> >  		.desc = "Qualcomm erratum 1009, ARM erratum 1286807",
> >  		.capability = ARM64_WORKAROUND_REPEAT_TLBI,
> > +		.type = ARM64_CPUCAP_SCOPE_LOCAL_CPU,
> >  		ERRATA_MIDR_RANGE_LIST(arm64_repeat_tlbi_cpus),
> 
> ERRATA_MIDR_RANGE_LIST sets the type already, so I think this is redundant.
> 

You're right, I got lost in the macros. Apologies for that.

Will respin the patch.

Thanks,
Bjorn
