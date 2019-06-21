Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5834F12A
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 01:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFUX32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 19:29:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57882 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfFUX32 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 19:29:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=veIfsznsGG3ioukN8XMlSwEnuA6OV0M+qbciLbASVM0=; b=byvtoB+Qt9qV9tAMsibhKYm1te
        LqQN2fCMSI8jm3dpX3kQIk0hUknDDfsVUSWcbZgNihtO/AiSLPju7pzXbldu+cc7rTfvKPRxQfQmu
        NWvLLzoKvC0m2VJJ+h8zPv7hkv0qvxXZIfkPtEoeSQPinBwpSI/js1PSGrmLOW8sFvrgz1kgJp4nG
        9vDPnLtc7yqO9MA1pdSl1c1JIvylxFTYKgB2oGV9wdxscJobCOrMlaFbC97qYPNo8GfBE7vn+5myQ
        GqnSXvJmMQEAJ3XCHrKjb8E6IwCmIb0GyLUl0+xQhnf1Rrl7HgbxYacm9oGnoTgoCQuMp6Iu/Q6jE
        bULrYjZQ==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1heSy6-0000Ov-Du; Fri, 21 Jun 2019 23:29:18 +0000
Subject: Re: [PATCH v6] Documentation: Add section about CPU vulnerabilities
 for Spectre
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
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Mark Gross <mgross@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <20190620231050.22816-1-tim.c.chen@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6cce35f2-4447-7671-54dc-52bbb71ba8b2@infradead.org>
Date:   Fri, 21 Jun 2019 16:29:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620231050.22816-1-tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/19 4:10 PM, Tim Chen wrote:
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
> ---
>  Documentation/admin-guide/hw-vuln/index.rst   |   1 +
>  Documentation/admin-guide/hw-vuln/spectre.rst | 697 ++++++++++++++++++
>  Documentation/userspace-api/spec_ctrl.rst     |   2 +
>  3 files changed, 700 insertions(+)
>  create mode 100644 Documentation/admin-guide/hw-vuln/spectre.rst
> 

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
