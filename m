Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E59A048B
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 16:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfH1OPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 10:15:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47494 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfH1OPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Aug 2019 10:15:19 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2yj5-0005hU-A0; Wed, 28 Aug 2019 16:15:07 +0200
Date:   Wed, 28 Aug 2019 16:15:06 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Pavel Machek <pavel@denx.de>
cc:     Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <20190828133713.GF8052@amd>
Message-ID: <alpine.DEB.2.21.1908281610310.23149@nanos.tec.linutronix.de>
References: <20190827113604.GB18218@amd> <alpine.DEB.2.21.1908271525480.1939@nanos.tec.linutronix.de> <20190828103113.GA14677@amd> <alpine.DEB.2.21.1908281231480.1869@nanos.tec.linutronix.de> <20190828114947.GC8052@amd> <20190828120024.GF4920@zn.tnic>
 <20190828120935.GD8052@amd> <20190828121628.GG4920@zn.tnic> <20190828122913.GE8052@amd> <20190828124621.GI4920@zn.tnic> <20190828133713.GF8052@amd>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Aug 2019, Pavel Machek wrote:
> On Wed 2019-08-28 14:46:21, Borislav Petkov wrote:
> > On Wed, Aug 28, 2019 at 02:29:13PM +0200, Pavel Machek wrote:
> > > This is not a way to have an inteligent conversation.
> > 
> > No, this *is* the way to keep the conversation sane, without veering
> > off into some absurd claims.
> > 
> > So, to cut to the chase: you can simply add "rdrand=force" to your
> > cmdline parameters and get back to using RDRAND.
> > 
> > And yet if you still feel this fix does not meet your expectations,
> > you were told already to either produce patches or who to contact. I'm
> > afraid complaining on this thread won't get you anywhere but that's your
> > call.
> 
> No, this does not meet my expectations, it violates stable kernel
> rules, and will cause regression to some users, while better solution
> is known to be available.

Your unqualified ranting does not meet my expectation either and it
violates any rule of common sense.

For the record:

  Neither AMD nor we have any idea which particular machines have a fixed
  BIOS and which have not. There is no technical indicator either at boot
  time as the wreckage manifests itself only after resume.

  So in the interest of users the only sensible decision is to disable
  RDRAND for this class of CPUs.

  If you have a list of machines which have a fixed BIOS, then provide it
  in form of patches. If not then stop claiming that there is a better
  solution available.

Anyway, I'm done with that and further rants of yours go directly to
/dev/null.

Thanks for wasting everyones time

       tglx
