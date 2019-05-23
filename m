Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126D427A5A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 12:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfEWKYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 06:24:05 -0400
Received: from foss.arm.com ([217.140.101.70]:42572 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfEWKYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 06:24:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73501341;
        Thu, 23 May 2019 03:24:04 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F6333F718;
        Thu, 23 May 2019 03:24:00 -0700 (PDT)
Date:   Thu, 23 May 2019 11:23:57 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Palmer Dabbelt <palmer@sifive.com>
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        Will Deacon <will.deacon@arm.com>, aou@eecs.berkeley.edu,
        Arnd Bergmann <arnd@arndb.de>, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mattst88@gmail.com, mingo@kernel.org, mpe@ellerman.id.au,
        paul.burton@mips.com, paulus@samba.org, ralf@linux-mips.org,
        rth@twiddle.net, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, vgupta@synopsys.com
Subject: Re: [PATCH 12/18] locking/atomic: riscv: use s64 for atomic64
Message-ID: <20190523102357.GB3370@lakrids.cambridge.arm.com>
References: <20190522132250.26499-13-mark.rutland@arm.com>
 <mhng-678bd8a3-987b-4564-9885-1a764d1725b8@palmer-si-x1e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-678bd8a3-987b-4564-9885-1a764d1725b8@palmer-si-x1e>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 22, 2019 at 12:06:31PM -0700, Palmer Dabbelt wrote:
> On Wed, 22 May 2019 06:22:44 PDT (-0700), mark.rutland@arm.com wrote:
> > As a step towards making the atomic64 API use consistent types treewide,
> > let's have the s390 atomic64 implementation use s64 as the underlying
> 
> and apparently the RISC-V one as well? :)

Heh. You can guess which commit message I wrote first...

> Reviwed-by: Palmer Dabbelt <palmer@sifive.com>

Cheers! I'll add an extra 'e' when I fold this in. :)

Thanks,
Mark.
