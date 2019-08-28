Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0C7A012F
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 14:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbfH1MAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 08:00:34 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39738 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfH1MAe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 08:00:34 -0400
Received: from zn.tnic (p200300EC2F0A5300B1A6357224C8EB83.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:5300:b1a6:3572:24c8:eb83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1E35E1EC06E5;
        Wed, 28 Aug 2019 14:00:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1566993632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=8xpwVf+VIsLRQ2aLupeFHolCJXDPzjt+Wi6mPweoFlg=;
        b=Jd6T353AKbGfPOz7tG4uD23DNCJsXidU8hWdEU9EXJGXYGFVH9vRF5WV9oRvRaZFd9m8eW
        5gshBwZD3lTmzW92WtE9tivbdyynKQd0GkwTtGgJREm0IGUEYFhq9uQ1vc46DSG8UjyTZ2
        QCb/wSOq3lva6H2aai39nrB21g45mHw=
Date:   Wed, 28 Aug 2019 14:00:24 +0200
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
Message-ID: <20190828120024.GF4920@zn.tnic>
References: <20190827072718.142728620@linuxfoundation.org>
 <20190827072722.020603090@linuxfoundation.org>
 <20190827113604.GB18218@amd>
 <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de>
 <20190828103113.GA14677@amd>
 <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
 <20190828114947.GC8052@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190828114947.GC8052@amd>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 28, 2019 at 01:49:47PM +0200, Pavel Machek wrote:
> AMD screwed this up,

Except that it wasn't AMD who screwed up but BIOS on *some* laptops.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
