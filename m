Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D769C4913A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 22:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfFQUW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 16:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbfFQUW4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 16:22:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E9A886658;
        Mon, 17 Jun 2019 20:22:37 +0000 (UTC)
Received: from tonnant.bos.jonmasters.org (ovpn-122-52.rdu2.redhat.com [10.10.122.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6AF37E5BB;
        Mon, 17 Jun 2019 20:22:20 +0000 (UTC)
To:     Tim Chen <tim.c.chen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
References: <c63945d34bfc9df2412f813d0b9b3a321a65de5d.1560795378.git.tim.c.chen@linux.intel.com>
From:   Jon Masters <jcm@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jcm@redhat.com; keydata=
 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
 yrXvw9qg2waGcnb8WuoS+g==
Subject: Re: [PATCH v3] Documentation: Add section about CPU vulnerabilities
 for Spectre
Message-ID: <5ff842bb-e0b8-c4aa-134d-32c9d838a162@redhat.com>
Date:   Mon, 17 Jun 2019 16:22:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <c63945d34bfc9df2412f813d0b9b3a321a65de5d.1560795378.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 17 Jun 2019 20:22:55 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tim,

Nice writeup. A few suggestions inline.

On 6/17/19 3:11 PM, Tim Chen wrote:

> +In Spectre variant 2 attacks, the attacker can steer speculative indirect
> +branches in the victim to gadget code by poisoning the branch target
> +buffer of a CPU used for predicting indirect branch addresses. Such
> +poisoning could be done by indirect branching into existing code, with the
> +address offset of the indirect branch under the attacker's control. Since
> +the branch prediction hardware does not fully disambiguate branch address
> +and uses the offset for prediction, this could cause privileged code's
> +indirect branch to jump to a gadget code with the same offset.

Maybe mention "on impacted hardware" (implied).

> +One other variant 2 attack vector is for the attacker to poison the
> +return stack buffer (RSB) [13] to cause speculative RET execution to go
> +to an gadget.  An attacker's imbalanced CALL instructions might "poison"
> +entries in the return stack buffer which are later consumed by a victim's
> +RET instruction.  This attack can be mitigated by flushing the return
> +stack buffer on context switch, or VM exit.

Maybe replace CALL and RET with generic equivalents or label as x86
examples.

> +   For kernel code that has been identified where data pointers could
> +   potentially be influenced for Spectre attacks, new "nospec" accessor
> +   macros are used to prevent speculative loading of data.

Maybe explain that nospec (speculative clamping) relies on the absence
of value prediction in the masking (in current hardware). It may NOT
always be a safe approach in future hardware, where Spectre-v1 attacks
are likely to persist but hardware may speculate about the mask value.

> +   On x86, a user process can protect itself against Spectre variant
> +   2 attacks by using the prctl() syscall to disable indirect branch
> +   speculation for itself.

This is not x86 specific. The same prctl is wired up elsewhere also.

Jon.

-- 
Computer Architect | Sent with my Fedora powered laptop
