Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3282748671B
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 16:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240727AbiAFPy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 10:54:59 -0500
Received: from mail.skyhub.de ([5.9.137.197]:34204 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240695AbiAFPy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jan 2022 10:54:58 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3D6501EC01B7;
        Thu,  6 Jan 2022 16:54:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641484493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KY7U837nFB4pEwvnQBxMVM1Sw7SydDnWqLpzfDmuuhU=;
        b=mJYMETx0keG3oXgeLTOe8p48bez+b0q6FlqJEcIlkpu8+xdJbJ5aDvVORI770ic2cPggau
        x9y40kHBZwsIVbvBSatUx1xPRGVAzNNaZhOhWBhNjnboa/8HK7JS+NGGYH1P8lxYtUuQhJ
        uuQxe5BKDUoNGEKYbRdNsBYTyJCZhfQ=
Date:   Thu, 6 Jan 2022 16:54:55 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Huang Rui <ray.huang@amd.com>
Cc:     "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        kernel test robot <lkp@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, sched: Fix the undefined reference building
 error of init_freq_invariance_cppc
Message-ID: <YdcQz7VQEbA+K73X@zn.tnic>
References: <20220106074306.2712090-1-ray.huang@amd.com>
 <20220106074306.2712090-2-ray.huang@amd.com>
 <Ydbdq6lXPKFG98MY@zn.tnic>
 <Ydb+rHXsXqxzmR0V@amd.com>
 <YdcC2JK7sOFs292B@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YdcC2JK7sOFs292B@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 06, 2022 at 10:55:20PM +0800, Huang Rui wrote:
> I just thought the CPPC function should be able to work on single core even
> SMP is disabled.

Why, because SMP=n is a real use case?!

FWIW, we were even speculating on removing SMP=n so how practical is
using CPPC on SMP=n at all?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
