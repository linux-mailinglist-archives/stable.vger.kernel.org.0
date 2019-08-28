Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B557A0029
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 12:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfH1Krh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 06:47:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46672 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfH1Krh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 06:47:37 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2vTw-0001Eg-Ko; Wed, 28 Aug 2019 12:47:16 +0200
Date:   Wed, 28 Aug 2019 12:47:10 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Pavel Machek <pavel@denx.de>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
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
In-Reply-To: <20190828103113.GA14677@amd>
Message-ID: <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de>
References: <20190827072718.142728620@linuxfoundation.org> <20190827072722.020603090@linuxfoundation.org> <20190827113604.GB18218@amd> <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de> <20190828103113.GA14677@amd>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Pavel,

On Wed, 28 Aug 2019, Pavel Machek wrote:
> On Tue 2019-08-27 15:30:30, Thomas Gleixner wrote:
> > There is no way to reinitialize RDRAND from the kernel otherwise we would
> > have exactly done that. If you know how to do that please tell.
> 
> Would they? AMD is not exactly doing good job with communication

Yes they would. Stop making up weird conspiracy theories.

> here. If BIOS can do it, kernel can do it, too...

May I recommend to read up on SMM and BIOS being able to lock down access
to certain facilities?

> or do you have information saying otherwise?

Yes. It was clearly stated by Tom that it can only be done in the BIOS.

> > Also disabling it for every BIOS is the only way which can be done because
> > there is no way to know whether the BIOS is fixed or not at cold boot
> > time. And it has to be known there because applications cache the
> 
> I'm pretty sure DMI-based whitelist would help here. It should be
> reasonably to fill it with the common machines at least.

Send patches to that effect.
 
> Plus, where is the CVE, and does AMD do anything to make BIOS vendors
> fix them?

May I redirect you to: https://www.amd.com/en/corporate/contact

Thanks,

	tglx
