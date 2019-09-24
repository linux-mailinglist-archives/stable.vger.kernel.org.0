Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC7BD56B
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 01:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411136AbfIXXR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 19:17:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35902 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411114AbfIXXR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Sep 2019 19:17:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id t14so1682112pgs.3
        for <stable@vger.kernel.org>; Tue, 24 Sep 2019 16:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9IB7bdIDm0JVlGPOX0oJIP58ZPbz3ymQiR2AH5kF6ng=;
        b=CcmgROgDS7xGnm6hwGZbptpdg/Yp2sffhbyJar2RTlXPhD9oQu0yl1JI4KTx4YNUZK
         lyUWlT6Vfe4xxRWzflmrg+CKWu9tN7CDOvXYxm+UouHxX6MAh66EgSpPtNWzbg7oLBsD
         /4lK4/dH+15MDBtlWbPqqdtt725cDdvODQcEv2mhYrm2C4mya/hkWC/MQGLYcsppFRNI
         +sXUSPXSZZK/9TtoPBWmWM/AUZG7cnp90vjFqEOSkRJXvPfqtq7KokWSzYNEW9txzCM7
         +Gka3f80E4gzYErOGmAzb+4Xaf//VGWy/t3jUEoH3VwA+EJXeDYyiO2Rsj8YItKixk5k
         nBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9IB7bdIDm0JVlGPOX0oJIP58ZPbz3ymQiR2AH5kF6ng=;
        b=SRZCpKgR7u/vN78nf4273ccbkkSnTXDaBaWEO39jthnmWTzFzcW8LzP+ax6P0b+gax
         c3f8QFequffgBL5T1nF0EMaSY2hzFl6+l2pZMv1ZHQ2pjdshYY2enAUmL4TDLF9O7Zf4
         6Srmb4UneOGqfm4u1tuonfNReAG2yp3iXbMGl+e9zB90QjFQcN3aOTQpaHwHWlN5Q311
         Ma5M97aKS7XJhR8fcr1ydzJ8ptSqYUfkHwAJMPfPxIgEivWVp057g8Vcftx0qCJWa876
         dejHEc4A3LZj9je8guCytUY4IXcESKSX1hqnb1R3NQ//BNcz5PrUh3jL6Qis+kpAWK/r
         Geng==
X-Gm-Message-State: APjAAAV0jAOSFcL54iOmpx5erfVpr0cBwcdezW9WdMUsnRXvD11qUSom
        SiCxdA966l+qKfBfQTA1Ey/CFg==
X-Google-Smtp-Source: APXvYqwSHjP7WUchWLaV5JFALdcAyPkAYEFwtgHTgmt7+uuhlJVE681CrUPfAxL4Y3fhpaLwSnpzoQ==
X-Received: by 2002:a63:2364:: with SMTP id u36mr5412447pgm.449.1569367047521;
        Tue, 24 Sep 2019 16:17:27 -0700 (PDT)
Received: from centauri ([12.157.10.118])
        by smtp.gmail.com with ESMTPSA id 197sm3264330pge.39.2019.09.24.16.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 16:17:26 -0700 (PDT)
Date:   Wed, 25 Sep 2019 01:17:24 +0200
From:   Niklas Cassel <niklas.cassel@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, will.deacon@arm.com
Subject: Re: stable backport request, add cortex-a cpus to whitelist
Message-ID: <20190924231724.GA7380@centauri>
References: <20190909124501.GA14378@centauri>
 <20190919203247.GA258783@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <20190919203247.GA258783@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2019 at 10:32:47PM +0200, Greg KH wrote:
> On Mon, Sep 09, 2019 at 02:45:01PM +0200, Niklas Cassel wrote:
> > Hello,
> > 
> > I would like to request
> > 2a355ec25729 ("arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field")
> > 
> > to be backported to 4.19 stable.
> > 
> > These CPUs are not susceptible to Meltdown, so enabling the mitigations
> > for Meltdown (kpti) should be redundant, especially since we know that
> > it can have a huge performance penalty for certain workloads.
> > 
> > kpti will still be automatically enabled if KASLR is enabled.
> 
> Now queued up, thanks.
> 

Hello Greg, Will,

How about applying this also to v4.14 stable?
(Since kpti is also enabled on Cortex-A CPUs in v4.14.)

2a355ec25729 does not apply cleanly on v4.14.y,
since a LOT of things have changed in the file.

git log --oneline 2a355ec25729053bb9a1a89b6c1d1cdd6c3b3fb1 --not linux-stable/linux-4.14.y arch/arm64/kernel/cpufeature.c | wc -l
72

However, I've attached a simple backport of the commit.


Kind regards,
Niklas

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-arm64-kpti-Whitelist-Cortex-A-CPUs-that-don-t-implem.patch"

From 84406bca325ad4dc1c5d517801d298ae8c9b68a0 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Thu, 13 Dec 2018 13:47:38 +0000
Subject: [PATCH] arm64: kpti: Whitelist Cortex-A CPUs that don't implement the
 CSV3 field

commit 2a355ec25729053bb9a1a89b6c1d1cdd6c3b3fb1 upstream.

While the CSV3 field of the ID_AA64_PFR0 CPU ID register can be checked
to see if a CPU is susceptible to Meltdown and therefore requires kpti
to be enabled, existing CPUs do not implement this field.

We therefore whitelist all unaffected Cortex-A CPUs that do not implement
the CSV3 field.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
MIDR_CORTEX_A35 is not included, since the define does not exist in v4.14.y.

 arch/arm64/kernel/cpufeature.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3312d46fa29e..57ec681a8f11 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -838,6 +838,11 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	switch (read_cpuid_id() & MIDR_CPU_MODEL_MASK) {
 	case MIDR_CAVIUM_THUNDERX2:
 	case MIDR_BRCM_VULCAN:
+	case MIDR_CORTEX_A53:
+	case MIDR_CORTEX_A55:
+	case MIDR_CORTEX_A57:
+	case MIDR_CORTEX_A72:
+	case MIDR_CORTEX_A73:
 		return false;
 	}
 
-- 
2.21.0


--a8Wt8u1KmwUX3Y2C--
