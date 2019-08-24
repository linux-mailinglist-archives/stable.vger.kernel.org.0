Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E36F9BFC4
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 21:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfHXTOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 15:14:03 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39966 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfHXTOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 15:14:03 -0400
Received: from zn.tnic (p200300EC2F1E940065BE1E18AD5D2E38.dip0.t-ipconnect.de [IPv6:2003:ec:2f1e:9400:65be:1e18:ad5d:2e38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B4B041EC0874;
        Sat, 24 Aug 2019 21:13:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1566674036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=79jMsr0zmqP5Kq51/xn4qfQBqLLHeD4XOJk4/O6hEoc=;
        b=QTUIOkiHbkj28CnnZ7bJADvIzLgEO6cRmPuInwAfMbHsi80Atk02cksHZwaDfw95wYMxPv
        ZQR++Q3cU9eJUAVF+1L+WEb4rI61abvy70icnaN118Hx4sscWWBH5XEh8Vrimz4MIAYRS4
        PTvd2kwHXhrVX2oSyLSpCQKm/AkYgNE=
Date:   Sat, 24 Aug 2019 21:13:53 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Chen Yu <yu.c.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [tip: x86/urgent] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
Message-ID: <20190824191353.GD16813@zn.tnic>
References: <7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com>
 <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
 <20190824135028.GJ1581@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190824135028.GJ1581@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 24, 2019 at 09:50:28AM -0400, Sasha Levin wrote:
> Why is this being removed (along with supporting code)?

This was only a temporary bug in the new tip-bot which is fixed now. The
commit in tip is fine:

c49a0a80137c ("x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h")

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
