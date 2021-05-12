Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F4837EFA4
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242713AbhELXO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348145AbhELXFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 19:05:10 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB96C0612ED;
        Wed, 12 May 2021 15:59:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c22so28932646edn.7;
        Wed, 12 May 2021 15:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rOAA39qDqCF5GcRlEH9lP1dgFdhOxpfB8dof90LWcm8=;
        b=hLNKjvnimL2wUXU6jNr9izLQ1bDpX1InzTso4SOAbtPTdHdOo7lE6Bj/KNVVE4EStG
         hmUIU26AvA9r259RpOFTI8kcjfyEQwh/Yp9NlwQWe4V7vE9iw61cTjskRvDdd12UWYHm
         wLVUoxxgMt/c2FfeOtUBeL3LK9PziSv2sSJD2ElSuFd2YNxCEZtonbdAltNWa2ArLkPt
         rDGIgDlW/21p/d7AdUJO9aGtSxip/reOS+3ndUjohzH9aiAQBxW3CB08Tt//KbVZVCvQ
         hkyGYVFgZSwyDDVjeh1/dwXdlh2Pe6gQ/zxDfFW3MvFYMVXdRiWw8RgEmN22eAcxrz/j
         po7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rOAA39qDqCF5GcRlEH9lP1dgFdhOxpfB8dof90LWcm8=;
        b=Gmg+Qqv8Smp5BXYLKZLk4jGV3DzoCzwuXgC/9MYY4KcctjnnorUSRNiA41YTXNeTd5
         vIosP0Vr1sxZGWCAxwV9cWnNiwE9gdVOTfBGij5dFe62TVKoBtsGxULQCuFZiVP3tgwV
         OhuWfEM/jPHhGDQaC0xvlKU6XaPHQ4zei+WagH8Q5mzLy4bMruydNJHAbadAvTphBK9b
         kH39RYts8RD4C7VD03O0vfLmKedr8oYQF1kld7uVd7FSfFnBn44J8MRd/vwowGL02Bq3
         TXwYJ8izW07w17vyIihcQAtrG36VfvHLsLmnV6QwA5YY4rylUzXBr1PIKy2w8+M2v9Q2
         egbA==
X-Gm-Message-State: AOAM532g5zKoJzviZY1z70eEZvg4FexQTbTWDNGq9XCxHMYfaBfGTW8S
        FuN3Lw4oEKIRzZ4M0ZAWfvRJMzmd+Os=
X-Google-Smtp-Source: ABdhPJxqAsq/8o0vGsZEccm2uH2DPHHVOH4COsVvCUOPtWZj7nVcrWiyyNudekpI7Agv5a0W8rz8Yg==
X-Received: by 2002:a50:ab06:: with SMTP id s6mr37598918edc.100.1620860346329;
        Wed, 12 May 2021 15:59:06 -0700 (PDT)
Received: from gmail.com (0526E777.dsl.pool.telekom.hu. [5.38.231.119])
        by smtp.gmail.com with ESMTPSA id u6sm775508ejn.14.2021.05.12.15.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 15:59:05 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Thu, 13 May 2021 00:59:02 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Alexander Monakov <amonakov@ispras.ru>
Cc:     Huang Rui <ray.huang@amd.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <YJxdttrorwdlpX33@gmail.com>
References: <20210425073451.2557394-1-ray.huang@amd.com>
 <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Alexander Monakov <amonakov@ispras.ru> wrote:

> On Sun, 25 Apr 2021, Huang Rui wrote:
> 
> > Some AMD Ryzen generations has different calculation method on maximum
> > perf. 255 is not for all asics, some specific generations should use 166
> > as the maximum perf. Otherwise, it will report incorrect frequency value
> > like below:
> 
> The commit message says '255', but the code:
> 
> > --- a/arch/x86/kernel/cpu/amd.c
> > +++ b/arch/x86/kernel/cpu/amd.c
> > @@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> >  		break;
> >  	}
> >  }
> > +
> > +u32 amd_get_highest_perf(void)
> > +{
> > +	struct cpuinfo_x86 *c = &boot_cpu_data;
> > +
> > +	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > +			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> > +	    return 166;
> > +
> > +	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > +			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> > +	    return 166;
> > +
> > +	return 225;
> > +}
> 
> says 225? This is probably a typo? In any case they are out of sync.
> 
> Alexander

Ugh - that's indeed a good question ...

Thanks,

	Ingo
