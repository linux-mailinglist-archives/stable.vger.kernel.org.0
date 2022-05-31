Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23815391A8
	for <lists+stable@lfdr.de>; Tue, 31 May 2022 15:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiEaNT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 May 2022 09:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbiEaNT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 May 2022 09:19:26 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 06:19:24 PDT
Received: from outgoing-stata.csail.mit.edu (outgoing-stata.csail.mit.edu [128.30.2.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDF3F8CCC4;
        Tue, 31 May 2022 06:19:24 -0700 (PDT)
Received: from ip4d17f91f.dynamic.kabel-deutschland.de ([77.23.249.31] helo=srivatsab-a02.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1nw1Lp-000Lu4-Ri; Tue, 31 May 2022 08:51:58 -0400
To:     Peter Zijlstra <peterz@infradead.org>,
        Shreenidhi Shedi <yesshedi@gmail.com>
Cc:     amakhalov@vmware.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Shreenidhi Shedi <sshedi@vmware.com>
References: <20220527175737.915284-1-sshedi@vmware.com>
 <YpIpL728ii08D9uK@worktop.programming.kicks-ass.net>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v3] x86/vmware: use unsigned integer for shifting
Message-ID: <5dfc62d1-5778-ed94-3f3e-54e12ee5e4e6@csail.mit.edu>
Date:   Tue, 31 May 2022 14:51:53 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YpIpL728ii08D9uK@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/28/22 6:52 AM, Peter Zijlstra wrote:
> On Fri, May 27, 2022 at 11:27:37PM +0530, Shreenidhi Shedi wrote:
>> From: Shreenidhi Shedi <sshedi@vmware.com>
>>
>> Shifting signed 32-bit value by 31 bits is implementation-defined
>> behaviour. Using unsigned is better option for this.
> 
> The kernel builds with -fno-strict-overflow and as such this behaviour
> is well defined.
>

Ah, I see. Thank you, Peter!
 
>> Fixes: 4cca6ea04d31 ("x86/apic: Allow x2apic without IR on VMware platform")
> 
> Nothing broken, therefore nothing fixed.
> 

Agreed.

I think using the BIT() macro still provides a nice readability
improvement. So, Shreenidhi, could you spin a new version of the patch
with the same code changes but with a different commit message about
using the BIT() macro to simplify the code, and also include a
clarification as to why the existing code is correct (which Peter
pointed out), please?

Thank you!

Regards,
Srivatsa
VMware Photon OS
