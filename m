Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306E237F563
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 12:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhEMKNe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 06:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhEMKNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 06:13:30 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53448C061574;
        Thu, 13 May 2021 03:12:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s6so30314003edu.10;
        Thu, 13 May 2021 03:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I6ZLVBTAXOh/ae34wFzFrFt/D+FTd0oWmNhF9pEVyBk=;
        b=j5yVSk5zkPeWsZ1/ztLxyn94YNHAKofP+ErJa/hW1KXdS9JH3S6j542sw1PwZ01V/x
         EQ7VR9ZmrVrYnQGXMCS5hhy4rlB9UsBkllk5avzHT7ZJHjF2LTmIMqZ4/7BNlUVQCwbO
         vpjtgcDv6nwzA7QLKOh74Ft4XYMTPyYjKNVrTTBLuZrk9qc8l/C94iGXGwz3kl7lwNbp
         CkMWC1dXeBi8gP5vqLK6b/0t/jvNweR2L5DNNoWc2APO+q7i2ZpPNocetjTxxdb+Q7xr
         r4ffaU2Mx2oGykbZzi6D8DHIUJQXKq2X2zZhoP3rf0+gmRk+U/XUJARWaGauPOOC+mRi
         acuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=I6ZLVBTAXOh/ae34wFzFrFt/D+FTd0oWmNhF9pEVyBk=;
        b=mK9AmeHKVbe6zmvOpmF3kCmW4613hPWWkvPbaj/Raby3Y4id821xphn9v+6WFeFFnM
         tkvEKOEQUPAaZdxdPiq87dIAdZ6mv3qCJdNxrMH9MucD3MpPOS5P/ifMeKUl/j3+WEAw
         KuOYvu1V1WhKEq8cj9qbftfnPhm98raqZ9DUh5S4O6LLWlDdCuIqi9fjIDpZd1POSPRi
         wNlaD/vMG3Kf5+8Y3WiSHeUYC9RCZ0gepOGxETLqmn0CQSdX4GgglYRduzhNI60r62qT
         C8oD+X3ZY9XFc3sUaOQjAUZUe1jrrFmmO8gqqV0ynWC82AsjpcZ/rqThbfDQSJjQEv7t
         V0RQ==
X-Gm-Message-State: AOAM532ExOIw3oHrTiz/5spnnUQgZYwgI4aAzNxsCvpWg+WJK8WGx19m
        h13YJaFZgi8f2un5rfOKBKA=
X-Google-Smtp-Source: ABdhPJxrB7e0M30nEf143fGK2yXdb+LTPCecNIiCvJ4WDBrP8UTCFTT8FKnD1hZ+RnPWrQlRqWVH5w==
X-Received: by 2002:a05:6402:310a:: with SMTP id dc10mr49265825edb.38.1620900737070;
        Thu, 13 May 2021 03:12:17 -0700 (PDT)
Received: from gmail.com (0526E777.dsl.pool.telekom.hu. [5.38.231.119])
        by smtp.gmail.com with ESMTPSA id 9sm1559478ejv.73.2021.05.13.03.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:12:16 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Thu, 13 May 2021 12:12:14 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Huang Rui <ray.huang@amd.com>
Cc:     Alexander Monakov <amonakov@ispras.ru>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <YJz7fp17T1cyed4j@gmail.com>
References: <20210425073451.2557394-1-ray.huang@amd.com>
 <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
 <YJxdttrorwdlpX33@gmail.com>
 <20210513042420.GA1621127@hr-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513042420.GA1621127@hr-amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Huang Rui <ray.huang@amd.com> wrote:

> On Thu, May 13, 2021 at 06:59:02AM +0800, Ingo Molnar wrote:
> > 
> > * Alexander Monakov <amonakov@ispras.ru> wrote:
> > 
> > > On Sun, 25 Apr 2021, Huang Rui wrote:
> > > 
> > > > Some AMD Ryzen generations has different calculation method on maximum
> > > > perf. 255 is not for all asics, some specific generations should use 166
> > > > as the maximum perf. Otherwise, it will report incorrect frequency value
> > > > like below:
> > > 
> > > The commit message says '255', but the code:
> > > 
> > > > --- a/arch/x86/kernel/cpu/amd.c
> > > > +++ b/arch/x86/kernel/cpu/amd.c
> > > > @@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> > > >  		break;
> > > >  	}
> > > >  }
> > > > +
> > > > +u32 amd_get_highest_perf(void)
> > > > +{
> > > > +	struct cpuinfo_x86 *c = &boot_cpu_data;
> > > > +
> > > > +	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > > > +			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> > > > +	    return 166;
> > > > +
> > > > +	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > > > +			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> > > > +	    return 166;
> > > > +
> > > > +	return 225;
> > > > +}
> > > 
> > > says 225? This is probably a typo? In any case they are out of sync.
> > > 
> > > Alexander
> > 
> > Ugh - that's indeed a good question ...
> > 
> 
> Ah sorry! It's my typo. It should be 255 (confirmed in the ucode).
> 
> Alexander, thanks a lot to catch this!
> 
> Ingo, would you mind to update it from 225 -> 255 while you apply this
> patch or let me know if you want me to send v5?

No need to send v5, done!

I have a system that appears to be affected by this bug:

  kepler:~> lscpu | grep -i mhz
  CPU MHz:                         4000.000
  CPU max MHz:                     7140.6250
  CPU min MHz:                     2200.0000

So I should be able to confirm after a reboot.

Thanks,

	Ingo
