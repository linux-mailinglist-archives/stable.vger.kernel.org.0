Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A9437CE6
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 20:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfFFS7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 14:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfFFS7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 14:59:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF292089E;
        Thu,  6 Jun 2019 18:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559847590;
        bh=oFIWsUexMtBpvwlCHQ5qtCv0JmEj8p/ocTGIci0hH4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a0laMfvD0MEbUBAIY/FcUQkhl4NIuFMOQqN2VxXmv2GGW5OHQ5coRgq/LXjiZz1WP
         T/Cd6UyoxbzrXRbfaNcPYgC+Xa9z/9VRsoSfnKpPq60bswqrpJTKJrmxYIopsqkL4L
         Dt/KOmhSRqPJc5yEmiLPV208yv7QYewxjplMlFiY=
Date:   Thu, 6 Jun 2019 20:59:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tim Chen <tim.c.chen@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ben Greear <greearb@candelatech.com>, stable@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Jiri Kosina <jikos@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Gross <mgross@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH v2] Documentation: Add section about CPU vulnerabilities
 for Spectre
Message-ID: <20190606185947.GB19937@kroah.com>
References: <914630f02992a96af92b9229f3d083c6284bfb98.1559844311.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <914630f02992a96af92b9229f3d083c6284bfb98.1559844311.git.tim.c.chen@linux.intel.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 11:08:29AM -0700, Tim Chen wrote:
> Thomas,
> 
> Here's a revised version of the spectre documentation.
> 
> I took out discussions on BPF as Alexi found issues with the original
> blurbs on BPF.  Alexi suggested a separate bpf_security.rst document
> instead.


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
