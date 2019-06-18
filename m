Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7934ABDB
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 22:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfFRUdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 16:33:51 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:48727 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbfFRUdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 16:33:51 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hdKn1-0002HC-L1; Tue, 18 Jun 2019 22:33:11 +0200
Date:   Tue, 18 Jun 2019 22:33:10 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Tim Chen <tim.c.chen@linux.intel.com>
cc:     Jon Masters <jcm@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        Waiman Long <longman9394@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Gross <mgross@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH v3] Documentation: Add section about CPU vulnerabilities
 for Spectre
In-Reply-To: <95881c0e-5849-9062-a0c5-eb55081a06aa@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1906182232330.1766@nanos.tec.linutronix.de>
References: <c63945d34bfc9df2412f813d0b9b3a321a65de5d.1560795378.git.tim.c.chen@linux.intel.com> <5ff842bb-e0b8-c4aa-134d-32c9d838a162@redhat.com> <526833c7-b9b4-1847-9f9b-52dd248548ad@redhat.com> <95881c0e-5849-9062-a0c5-eb55081a06aa@linux.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 18 Jun 2019, Tim Chen wrote:
> On 6/17/19 1:30 PM, Jon Masters wrote:
> > On 6/17/19 4:22 PM, Jon Masters wrote:
> > 
> >>> +   For kernel code that has been identified where data pointers could
> >>> +   potentially be influenced for Spectre attacks, new "nospec" accessor
> >>> +   macros are used to prevent speculative loading of data.
> >>
> >> Maybe explain that nospec (speculative clamping) relies on the absence
> >> of value prediction in the masking (in current hardware). It may NOT
> >> always be a safe approach in future hardware, where Spectre-v1 attacks
> >> are likely to persist but hardware may speculate about the mask value.
> > 
> > Something like the Arm CSDB barrier would seem to be potentially useful
> > for $FUTURE_X86 as a fence with lighter-weight semantics than an *fence.
> > 
> 
> Is it necessary to go into such level of implementation details on nospec?
> These seem to be appropriate as code comments in nospec for kernel developer.
> But for an admin-guide doc, it may confuse sys admin to think that nospec
> could not be ineffective.
> 
> When new hardware appears that need new implementations of nospec, we should
> tweak nospec and not need the admin to worry about such implementation details.

Correct. Those details are architecture level details. See the split of the
MDS documentation...

Thanks,

	tglx
