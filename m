Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284CE56FC0
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 19:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFZRn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 13:43:27 -0400
Received: from ms.lwn.net ([45.79.88.28]:40982 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbfFZRn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 13:43:27 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id C679B2AE;
        Wed, 26 Jun 2019 17:43:25 +0000 (UTC)
Date:   Wed, 26 Jun 2019 11:43:24 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Tim Chen <tim.c.chen@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v6] Documentation: Add section about CPU vulnerabilities
 for Spectre
Message-ID: <20190626114324.2c78d73d@lwn.net>
In-Reply-To: <20190620231050.22816-1-tim.c.chen@linux.intel.com>
References: <20190620231050.22816-1-tim.c.chen@linux.intel.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 20 Jun 2019 16:10:50 -0700
Tim Chen <tim.c.chen@linux.intel.com> wrote:

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
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org

Applied, thanks.

jon
