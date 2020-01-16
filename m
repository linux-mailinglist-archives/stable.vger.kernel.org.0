Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4804E13D2FB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 05:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgAPED1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 23:03:27 -0500
Received: from mga06.intel.com ([134.134.136.31]:37789 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729110AbgAPED1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Jan 2020 23:03:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jan 2020 20:03:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,324,1574150400"; 
   d="scan'208";a="273859959"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Jan 2020 20:03:25 -0800
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 08F56301003; Wed, 15 Jan 2020 20:03:25 -0800 (PST)
Date:   Wed, 15 Jan 2020 20:03:24 -0800
From:   Andi Kleen <ak@linux.intel.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Frank van der Linden <fllinden@amazon.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Huang Rui <ray.huang@amd.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jan Beulich <jbeulich@suse.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luwei Kang <luwei.kang@intel.com>,
        Martin =?utf-8?B?TGnFoWth?= <mliska@suse.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/cpu/amd: Enable the fixed intructions retired
 free counter IRPERF
Message-ID: <20200116040324.GI302770@tassilo.jf.intel.com>
References: <20200115205646.10678-1-kim.phillips@amd.com>
 <20200115205646.10678-2-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115205646.10678-2-kim.phillips@amd.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +	if (cpu_has(c, X86_FEATURE_IRPERF) &&
> +	    !(c->x86 == 0x17 && c->x86_model <= 0x1f))

Such checks are normally through a x86_pmu lag or possibly a X86_BUG_* flag

> +		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
>  }
>  
>  #ifdef CONFIG_X86_32
> -- 
> 2.24.1
> 
