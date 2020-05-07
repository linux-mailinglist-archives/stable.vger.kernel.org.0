Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A183D1C9737
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 19:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGRMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 13:12:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:45512 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgEGRMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 13:12:13 -0400
IronPort-SDR: Nr/1nlA6Zc/9O+4u87pCXOre2e/8neMH9Tqh/OZbQKfhXUUPFA/U6G/GghLtQJL7X23wq61xGT
 4NYYjeK8bKyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 10:12:13 -0700
IronPort-SDR: PLFOdPMCHY9Fmbx1ykxgZk/4JqCuF3bVdk7+EpPSnc3GCUAVwrr9zDmWALL12+yzsHaALbXM1F
 VHO01nKj+N8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="339415390"
Received: from yyu32-desk.sc.intel.com ([143.183.136.146])
  by orsmga001.jf.intel.com with ESMTP; 07 May 2020 10:12:12 -0700
Message-ID: <e0bd220a68f35aa7f30658860bf7232e9bb7c5f0.camel@intel.com>
Subject: Re: [PATCH] x86/fpu/xstate: Clear uninitialized xstate areas in
 core dump
From:   Yu-cheng Yu <yu-cheng.yu@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Rik van Riel <riel@surriel.com>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     sam <sunhaoyl@outlook.com>, Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, stable@vger.kernel.org
Date:   Thu, 07 May 2020 10:12:16 -0700
In-Reply-To: <c26a39cc-1387-b55c-ec45-ec0e2357dd47@intel.com>
References: <20200507164904.26927-1-yu-cheng.yu@intel.com>
         <c26a39cc-1387-b55c-ec45-ec0e2357dd47@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-05-07 at 09:52 -0700, Dave Hansen wrote:
> On 5/7/20 9:49 AM, Yu-cheng Yu wrote:
> > In a core dump, copy_xstate_to_kernel() copies only enabled user xfeatures
> > to a kernel buffer without touching areas for disabled xfeatures.  However,
> > those uninitialized areas may contain random data, which is then written to
> > the core dump file and can be read by a non-privileged user.
> > 
> > Fix it by clearing uninitialized areas.
> 
> Do you have a Fixes: tag for this, or some background on where this
> issue originated that might be helpful for backports?

I will add that.

