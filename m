Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D387F1A74E8
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 09:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgDNHg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 03:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgDNHgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 03:36:55 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28514C0A3BDC
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 00:36:55 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a25so13137854wrd.0
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 00:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IsnIK9bQE2LuCTLv2q71KOwWCpFnc/vSo4lm6j3/7xc=;
        b=NLwftW0bzHWjAyvWR+oY1b3BNaFahQChWuhb8pQyuWItgZmyQgS9e0zp7mGGgH+hd3
         u8rVQfICkp8VE88xd3t7n39Hy36xQNZ5c/qViAofVBukAwgzR4bUbR7Ke+4DXL+d9xr1
         AGCQcMbVsOBSf23SxJpikv2Ng9HUtMjKxdmgR7ko28VQ/OzDOdfZV8PBILpzifCfCHK3
         vntrL//0rjhyJihAKfRinPJGHOA7Le4pQNn8tfwzNLyWRDo+DZvZTP3Ot9ajqr2YMC1L
         DHTcYPnSw5i52ExoamdH35vAAqZVEdEhQGFyEH+EXM3GDiyvQbBixgaY/djWWrYCOl+I
         T/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IsnIK9bQE2LuCTLv2q71KOwWCpFnc/vSo4lm6j3/7xc=;
        b=RZDN0sHpgtXIPFIJFkpbVXkdtSsCH/P9pyWE34gLYru9Plk3JeuaztXPfxQ1D/TWNv
         XVZroA/N9F1tMIAZvqanLVV4r7hcERqr3DS5M/9MckGjCBODIco/mv3WlQJa/k26yfnT
         QTndJ71NDLddlwnKyZtxvkRczMalMtQC9uajUsx/kF6/I2tgNStkr8IeyUUC+tPMUhJb
         MXoezPctHeREfvQKHxHS1bXtJrLdY98akHUg6CuVr3qoyyduV7cW1EGrpb86gobD7VV6
         jI3BnF8kBPGiq6GwdLUBzRLSzRiL1Y3ICU5VCxjWXVZDRltCHJHWVhBUD3zBXI0rpe4c
         yAIQ==
X-Gm-Message-State: AGi0PuZrfXEvEy0BdN+NFHfb8M9ifCylba87T1bBBZfT3meeNcilJumT
        z4yThUSZXv0s+4gchFhBgQ75TA==
X-Google-Smtp-Source: APiQypKZHp/Wioy0LK8BEGEXCXuKxx0E5X9If0mzrToO5uRK9nIXYcXUCD3uWDv7A05xn9+ObXBfJQ==
X-Received: by 2002:a5d:4b90:: with SMTP id b16mr12450587wrt.16.1586849813778;
        Tue, 14 Apr 2020 00:36:53 -0700 (PDT)
Received: from dell ([95.149.164.124])
        by smtp.gmail.com with ESMTPSA id r2sm17862289wmg.2.2020.04.14.00.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 00:36:53 -0700 (PDT)
Date:   Tue, 14 Apr 2020 08:37:53 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 4.19 11/13] perf/core: Reattach a misplaced comment
Message-ID: <20200414073753.GA2167633@dell>
References: <20200403121859.901838-1-lee.jones@linaro.org>
 <20200403121859.901838-12-lee.jones@linaro.org>
 <20200403122604.GA3928660@kroah.com>
 <20200403125246.GE30614@dell>
 <87y2rc66u9.fsf@ashishki-desk.ger.corp.intel.com>
 <20200411114937.GG2606747@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200411114937.GG2606747@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 11 Apr 2020, Greg KH wrote:

> On Fri, Apr 03, 2020 at 04:23:42PM +0300, Alexander Shishkin wrote:
> > Lee Jones <lee.jones@linaro.org> writes:
> > 
> > > On Fri, 03 Apr 2020, Greg KH wrote:
> > >
> > >> > +	/*
> > >> > +	 * Get the target context (task or percpu):
> > >> > +	 */
> > >> >  	ctx = find_get_context(event->pmu, task, event);
> > >> >  	if (IS_ERR(ctx)) {
> > >> >  		err = PTR_ERR(ctx);
> > >> 
> > >> Unless this is needed by a follow-on patch, I kind of doubt thsi is
> > >> needed in a stable kernel release :)
> > >
> > > I believe you once called this "debugging the comments", or
> > > similar. :)
> > >
> > > No problem though - happy to drop it from this and other sets.
> > 
> > It's a precursor to dce5affb94eb54edfff17727a6240a6a5d998666, which I
> > think is a stable candidate.
> 
> Ok, but that's not part of this patch series, so how was I supposed to
> know that?  :)

It wasn't going to be part of mine either, since it's missing from the
Sony vendor tree (the repo I'm analysing to identify these Stable
backports), thus I've dropped the patch.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
