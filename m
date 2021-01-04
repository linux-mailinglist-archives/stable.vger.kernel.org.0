Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64202EA107
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbhADXnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbhADXnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:43:08 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D3BC061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 15:42:28 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id z21so20089624pgj.4
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 15:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=eNcgfhUH3QKYpUY98WCEv63bBY9Nf2uLqktog8188UY=;
        b=Q1HRRTRiVGdmztc79/yAsE3LQzxWtk8X4ZYiL/4A/DctXXvJhRBjejT09z8Ld15Kxi
         xdD1A08ad3RiyJV5iIrbtdkxf5CY+efy+Q1Z2iYMmq3GW3KI/sq2IqCaAQ9+iBUoxUg6
         ACMGqCJ+o/pBsuB8aOo/+NuYhyDDLx1w6GeeshXLC860XnoCuZSbzV5IzM/dfQeN56gF
         XTWx+vJk0sAKUlWBrPWJ2a5tbJcyqMoLb91zDq4ZTk2BAfuSBa+xYRplbSyvBhsiiMRb
         i/eDQr3fqBp5VsSwQKJgDS4ajxCO7dPC9oPxUx4guflfiaX41+0nznzDaW/97p+MAxNm
         11FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=eNcgfhUH3QKYpUY98WCEv63bBY9Nf2uLqktog8188UY=;
        b=ogk0/2hCt2P/8XX4Ucw1IdbJNr6wcHfSb2Qc4sqXWpv17ExUjx9JWDnmbvtOWYQ5dA
         J7iHyzcr2FHz9qyZ/wvYIP51WCrmuyL6X8kZQjPIYvHWgZvTjq4ywCHZP1sxPN4yYkQK
         Ruc5HVhd13NElZiIskGjAeOEdpcYVSJxlNv42rOk3V4M8Q4CwUU0TuSW5oQcKGp7ddWQ
         YblPGYRconZYt/PTAC9wwNyANR8sJmpEQ5XmFVnJmenvn5afv34eyGhzumEQZXsRoWLG
         kkf0Eoy2e3F0rAZBqahc3kOELOtFiqsepFLGD5ghc3F42oUYEwvxzS/+uoRq8mzoKWil
         nngg==
X-Gm-Message-State: AOAM533l64NvoY+Ko5/X4tDIY/5yy15M/901DfTBH5u+1h5bC8b55VNz
        q84F3hqZjTjpQad1lKHdOyLV2qQfgfTvnA==
X-Google-Smtp-Source: ABdhPJzikLZ3QfFOsyzWCOgH0pNGBkGyoV2ldJcI1V4FHud8togqI3PIt48IMbl1hW3Bm7v7+h4gCg==
X-Received: by 2002:a17:902:123:b029:dc:27b:3c62 with SMTP id 32-20020a1709020123b02900dc027b3c62mr74061334plb.16.1609799821947;
        Mon, 04 Jan 2021 14:37:01 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id j8sm373281pji.1.2021.01.04.14.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 14:37:01 -0800 (PST)
Date:   Mon, 4 Jan 2021 14:37:00 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Greg KH <greg@kroah.com>
cc:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Christoph Hellwig <hch@lst.de>, nsaenzjulienne@suse.de,
        geert@linux-m68k.org, sjhuang@iluvatar.ai
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA
 allocations
In-Reply-To: <X/MRdPz/POas6FFf@kroah.com>
Message-ID: <ef6fed57-cbb7-ed8b-6925-cea0fd55df85@google.com>
References: <20200925161916.204667-1-pgonda@google.com> <20201005130729.GD827657@kroah.com> <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com> <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com>
 <X/MRdPz/POas6FFf@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Jan 2021, Greg KH wrote:

> > The series of commits certainly expanded from my initial set that I asked 
> > about in a thread with the subject "DMA API stable backports for AMD SEV" 
> > on May 19.  Turns out that switching how DMA memory is allocated based on 
> > various characteristics of the allocation and device is trickier than 
> > originally thought :)  There were a number of fixes that were needed for 
> > subtleties and cornercases that folks ran into, but were addressed and 
> > have been merged by Linus.  I believe it's stable in upstream and that 
> > we've been thorough in compiling a full set of changes that are required 
> > for 5.4.
> > 
> > Note that without this series, all SEV-enabled guests will run into the 
> > "sleeping function called from invalid context" issue in the vmalloc layer 
> > that Peter cites when using certain drivers.  For such configurations, 
> > there is no way to avoid the "BUG" messages in the guest kernel when using 
> > AMD SEV unless this series is merged into an LTS kernel that the distros 
> > will then pick up.
> > 
> > For my 13 patches in the 30 patch series, I fully stand by Peter's 
> > backports and rationale for merge into 5.4 LTS.
> 
> Given that this "feature" has never worked in the 5.4 or older kernels,
> why should this be backported there?  This isn't a bugfix from what I
> can tell, is it?  And if so, what kernel version did work properly?
> 

I think it can be considered a bug fix.

Today, if you boot an SEV encrypted guest running 5.4 and it requires 
atomic DMA allocations, you'll get the "sleeping function called from 
invalid context" bugs.  We see this in our Cloud because there is a 
reliance on atomic allocations through the DMA API by the NVMe driver.  
Likely nobody else has triggered this because they don't have such driver 
dependencies.

No previous kernel version worked properly since SEV guest support was 
introduced in 4.14.

> And if someone really wants this new feature, why can't they just use a
> newer kernel release?
> 

This is more of a product question that I'll defer to Peter and he can 
loop the necessary people in if required.

Since the SEV feature provides confidentiality for guest managed memory, 
running an unmodified guest vs a guest modified to avoid these bugs by the 
cloud provider is a very different experience from the perspective of the 
customer trying to protect their data.

These customers are running standard distros that may be slow to upgrade 
to new kernels released over the past few months.  We could certainly work 
with the distros to backport this support directly to them on a 
case-by-case basis, but the thought was to first attempt to fix this in 
5.4 stable for everybody and allow them to receive the fixes necessary for 
running a non-buggy SEV encrypted guest that way vs multiple distros doing 
the backport so they can run with SEV.
