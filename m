Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D579B27A81
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbfEWK2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:28:20 -0400
Received: from foss.arm.com ([217.140.101.70]:42882 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729972AbfEWK2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 06:28:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A688341;
        Thu, 23 May 2019 03:28:20 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1AA03F718;
        Thu, 23 May 2019 03:28:15 -0700 (PDT)
Date:   Thu, 23 May 2019 11:28:13 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Miller <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        James Hogan <jhogan@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Matt Turner <mattst88@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Burton <paul.burton@mips.com>,
        Paul Mackerras <paulus@samba.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Richard Henderson <rth@twiddle.net>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: Re: [PATCH 00/18] locking/atomic: atomic64 type cleanup
Message-ID: <20190523102813.GC3370@lakrids.cambridge.arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
 <CAK8P3a3X-7Yq9W+wEMRf3QvoEhrPHYmYukLaAr_39iKhJLC-bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3X-7Yq9W+wEMRf3QvoEhrPHYmYukLaAr_39iKhJLC-bA@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 11:18:59PM +0200, Arnd Bergmann wrote:
> On Wed, May 22, 2019 at 3:23 PM Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > Currently architectures return inconsistent types for atomic64 ops. Some return
> > long (e..g. powerpc), some return long long (e.g. arc), and some return s64
> > (e.g. x86).
> >
> > This is a bit messy, and causes unnecessary pain (e.g. as values must be cast
> > before they can be printed [1]).
> >
> > This series reworks all the atomic64 implementations to use s64 as the base
> > type for atomic64_t (as discussed [2]), and to ensure that this type is
> > consistently used for parameters and return values in the API, avoiding further
> > problems in this area.
> >
> > This series (based on v5.1-rc1) can also be found in my atomics/type-cleanup
> > branch [3] on kernel.org.
> 
> Nice cleanup!
> 
> I've provided an explicit Ack for the asm-generic patch if someone wants
> to pick up the entire series, but I can also put it all into my asm-generic
> tree if you want, after more people have had a chance to take a look.

Thanks!

I had assumed that this would go through the tip tree, as previous
atomic rework had, but I have no preference as to how this gets merged.

I'm not sure what the policy is, so I'll leave it to Peter and Will to
say.

Mark.
