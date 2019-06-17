Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D90C494FB
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfFQWQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:16:03 -0400
Received: from ms.lwn.net ([45.79.88.28]:45402 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfFQWQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 18:16:03 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id B3B20A4D;
        Mon, 17 Jun 2019 22:16:01 +0000 (UTC)
Date:   Mon, 17 Jun 2019 16:16:00 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Tim Chen <tim.c.chen@linux.intel.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Gross <mgross@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH v3] Documentation: Add section about CPU vulnerabilities
 for Spectre
Message-ID: <20190617161600.77f5f5eb@lwn.net>
In-Reply-To: <alpine.DEB.2.21.1906172217540.1963@nanos.tec.linutronix.de>
References: <c63945d34bfc9df2412f813d0b9b3a321a65de5d.1560795378.git.tim.c.chen@linux.intel.com>
        <alpine.DEB.2.21.1906172217540.1963@nanos.tec.linutronix.de>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Jun 2019 22:21:51 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> > +Spectre variant 1 attacks take advantage of speculative execution of
> > +conditional branches, while Spectre variant 2 attacks use speculative
> > +execution of indirect branches to leak privileged memory. See [1] [5]
> > +[7] [10] [11].  
> 
> It would be great to actually link these [N] to the actual http link at the
> bottom. No idea what's the best way to do that.
> 
> Jonathan?

Append an underscore to the link text, so:

	See [1_] [5_] ...
	
Then, when adding the links:

	.. _1: https://.../

There are other ways; see

    http://docutils.sourceforge.net/docs/user/rst/quickref.html#external-hyperlink-targets 

for the list.

> The below renders horribly when converted to HTML
> 
> You probably want to wrap these into a table
> 
> > +	nospectre_v2	[X86] Disable all mitigations for the Spectre variant 2
> > +			(indirect branch prediction) vulnerability. System may
> > +			allow data leaks with this option, which is equivalent
> > +			to spectre_v2=off.
> > +
> > +
> > +        spectre_v2=     [X86] Control mitigation of Spectre variant 2
> > +			(indirect branch speculation) vulnerability.
> > +			The default operation protects the kernel from
> > +			user space attacks.  
> 
> Maybe Jonathan has a better idea.

The easiest thing is probably a definition list:

	nospectre_v2
	    [X86] Disable all mitigations for the Spectre variant 2
	    (indirect branch prediction) ...

	spectrev2=
	    ...

i.e. just move the descriptive text into an indented block below the term
of interest.

jon
