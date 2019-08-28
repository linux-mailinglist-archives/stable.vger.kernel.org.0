Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D4BA021D
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfH1Mq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:46:28 -0400
Received: from mail.skyhub.de ([5.9.137.197]:47058 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbfH1Mq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 08:46:28 -0400
Received: from zn.tnic (p200300EC2F0A5300B1A6357224C8EB83.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:5300:b1a6:3572:24c8:eb83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 596B01EC09E2;
        Wed, 28 Aug 2019 14:46:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1566996386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YotASNKG5TQSIo5/90ZJMMOo66u6rq+Oxb5MG7ExeFI=;
        b=ANJ2J/8Qgwxx2nKsfT3swocAsnLzRZS10vUSsL9UD+cLKvyOm49ULSHJl4vQTFa2Vwnp60
        2tNRkKLRq05O9sokFKiG5dlleG3PLvhXaK++tvwHsGx84jexrhunszr8RoDIXSeJpWCoP5
        kit090PCjxJItAS0rgxU07S8c5EvYRs=
Date:   Wed, 28 Aug 2019 14:46:21 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chen Yu <yu.c.chen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4.19 72/98] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
Message-ID: <20190828124621.GI4920@zn.tnic>
References: <20190827072722.020603090@linuxfoundation.org>
 <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
 <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
 <20190828114947.GC8052@amd>
 <20190828120024.GF4920@zn.tnic>
 <20190828120935.GD8052@amd>
 <20190828121628.GG4920@zn.tnic>
 <20190828122913.GE8052@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190828122913.GE8052@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 02:29:13PM +0200, Pavel Machek wrote:
> This is not a way to have an inteligent conversation.

No, this *is* the way to keep the conversation sane, without veering
off into some absurd claims.

So, to cut to the chase: you can simply add "rdrand=force" to your
cmdline parameters and get back to using RDRAND.

And yet if you still feel this fix does not meet your expectations,
you were told already to either produce patches or who to contact. I'm
afraid complaining on this thread won't get you anywhere but that's your
call.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
