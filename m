Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638407D3BD
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 05:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfHADgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 23:36:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40160 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfHADgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 23:36:03 -0400
Received: by mail-pl1-f193.google.com with SMTP id a93so31440105pla.7
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 20:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=agxFsVFMrS4Uv8rkJ6+rXdsAOnVlA+SAVw+IjLOkFdU=;
        b=bUf4iEgLchiFXfhT1xmjReg6vuHTTMMnUTB4Y363ruCfk0w5x6lY6EiWkCv1iQTvfw
         X4YWjfgyPWpIFC9rKn++rTubN0mkZR7brGnZLLm2s+1NYTM/E4BE55nu+YQ6Ab3Ly9pQ
         WMCZRPQffPZuHyhc99gwM4wFkUavVG3TvyU5MrKjdLzbHQ/Z37n2YZ6adBpj7rYuzPl8
         SfvxW646djXWNNfxHFQNbHRnxaWIVYa6SqB1oRmS2QW/XuJ26OUoYUZJRwo6TnaiSX4A
         W0pjKGYGTaGKFJXX6RZelAdlYFloa7BQiqsDoU84SG8vMZxY7+lXWmf1n8GmXk379TTf
         wX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=agxFsVFMrS4Uv8rkJ6+rXdsAOnVlA+SAVw+IjLOkFdU=;
        b=aGicLZ50V5uZpSDXU6b6RXoUbjz6kHxsa9nc1dVicZIIigLG39DRjjIYmkqYI2XhrW
         GC7AmQFDr2gQUxt5N3dsEyFv21GDgeuG7dprwXic2ntWN+ndEXowZf2ja8xNBg4N7ui2
         2ttT2SMGV2KJQ148DWS4qGdpbjDhPg0IHAsRhr4up71ugEFcNJ9LqfMuJS85OatZt7Ra
         btV/WHOGRusdJkgoXcCasUkDUaTsrJd8WUcQpdX/AAUm8ilvCERvCQLDkBFWOgST+S0i
         tkItxHeK1mLvT08kQzGFUXEWGxMr1syT1WuhO5E8/Xg844y6Ph7SxLEJYxwRZIRrpZhp
         5WTA==
X-Gm-Message-State: APjAAAXlFCXP5ad/siSwjR9e4juMzqyHTL2vhwnN+bOlmDruoc8TjczC
        QtSlNiJvYDHScZNSJFXNeDLJ7Q==
X-Google-Smtp-Source: APXvYqyn64QqVAUXJUwPqvzYRKfETlhmOG6RXrqu4jKI3gLhnUT665IpkZH5AA2VrzxpqDptVQy8fA==
X-Received: by 2002:a17:902:9f8e:: with SMTP id g14mr77875171plq.67.1564630562466;
        Wed, 31 Jul 2019 20:36:02 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id j15sm69478055pfr.146.2019.07.31.20.36.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 20:36:01 -0700 (PDT)
Date:   Thu, 1 Aug 2019 09:05:59 +0530
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
Subject: Re: [PATCH v4.4 V2 15/43] arm64: Move cpu_die_early to smp.c
Message-ID: <20190801033559.23bovxwguppb7bbr@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <dd031e0851c01a0cfe275c05dc24935580d2fd78.1562908075.git.viresh.kumar@linaro.org>
 <20190731123532.GA39768@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731123532.GA39768@lakrids.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-07-19, 13:35, Mark Rutland wrote:
> On Fri, Jul 12, 2019 at 10:58:03AM +0530, Viresh Kumar wrote:
> > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > 
> > commit fce6361fe9b0caeba0c05b7d72ceda406f8780df upstream.
> > 
> > This patch moves cpu_die_early to smp.c, where it fits better.
> > No functional changes, except for adding the necessary checks
> > for CONFIG_HOTPLUG_CPU.
> > 
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Acked-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > [ Viresh: Resolved rebase conflict ]
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> > +void cpu_die_early(void)
> 
> > +	asm(
> > +	"1:	wfe\n"
> > +	"	wfi\n"
> > +	"	b	1b");
> > +}
> 
> Rather than open-coding this loop differently from upstream and the
> v4.9.y backport, please backport commit:
> 
>   c4bc34d20273db69 ("arm64: Add a helper for parking CPUs in a loop")
> 
> ... as a prerequisite of this patch.

Done, thanks.

-- 
viresh
