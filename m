Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE75C4B5DE
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 12:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfFSKFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 06:05:02 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:50048 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfFSKFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 06:05:02 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hdXSI-0002d2-1J; Wed, 19 Jun 2019 12:04:38 +0200
Date:   Wed, 19 Jun 2019 12:04:36 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Tim Chen <tim.c.chen@linux.intel.com>
cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Gross <mgross@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH v4] Documentation: Add section about CPU vulnerabilities
 for Spectre
In-Reply-To: <20190618212457.9764-1-tim.c.chen@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1906191204060.1765@nanos.tec.linutronix.de>
References: <20190618212457.9764-1-tim.c.chen@linux.intel.com>
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

> Add documentation for Spectre vulnerability and the mitigation mechanisms:
> 
> - Explain the problem and risks
> - Document the mitigation mechanisms
> - Document the command line controls
> - Document the sysfs files
> 
> Co-developed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Co-developed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Renders nicely now. Good work!

Thanks,

	tglx
