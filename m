Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3476E16358C
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 22:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgBRVyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 16:54:19 -0500
Received: from mail.skyhub.de ([5.9.137.197]:42678 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgBRVyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 16:54:19 -0500
Received: from zn.tnic (p200300EC2F0C1F00B896B40159BA1A96.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1f00:b896:b401:59ba:1a96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E0C8F1EC0C31;
        Tue, 18 Feb 2020 22:54:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1582062857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zwwTIfNeXE0+PhfSG968Dl+SHEvpcxijJ0a07ILjQLw=;
        b=QGtWD285YbgVFOi9XzS2Uav1mmO1rv7jcv9KXSra++21FdyQVYyJLcboFb0M8IGe35XYI7
        9H+SxFWLcTxBt+N4MkalKow4lNV9vIp56K10d8n6RqrvAogTfYxweMD/fot9Oa4SFicM6l
        l6mrEs67SdidLPEekTl7JA4BBpXBn3U=
Date:   Tue, 18 Feb 2020 22:54:11 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Babu Moger <babu.moger@amd.com>,
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
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] x86/cpu/amd: Enable the fixed Instructions Retired
 counter IRPERF
Message-ID: <20200218215411.GU14449@zn.tnic>
References: <20200214201805.13830-1-kim.phillips@amd.com>
 <20200218112035.GB14449@zn.tnic>
 <15f0ff78-1a94-cfa7-297b-c226cb98d10f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15f0ff78-1a94-cfa7-297b-c226cb98d10f@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 03:35:25PM -0600, Kim Phillips wrote:
> The only reason to have it show in /proc/cpuinfo is for userspace,
> but they can check for a nonzero count prior to using, instead.

How is userspace going to check it? perf tool or people *can* check it?
If perf is going to check it then I'm fine with having the bug bit in
/proc/cpuinfo along with a patch for perf adding usage for it.

If not and people in userspace can maybe check it but they probably
won't then adding that bug bit would be a waste of bit.

> Let me know if you'd like me to send a v4, or if you will just apply
> this version of yours.

I can take the simpler version for now. If you still want to have perf
tool check the bit, you could submit a new patch adding that bug bit
along with a perf tool patch using it...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
