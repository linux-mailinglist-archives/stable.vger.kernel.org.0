Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D54A73AE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfICTbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:31:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:45467 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfICTbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 15:31:50 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x83JVTV8020900;
        Tue, 3 Sep 2019 14:31:29 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id x83JVTPO020899;
        Tue, 3 Sep 2019 14:31:29 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Tue, 3 Sep 2019 14:31:28 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
Message-ID: <20190903193128.GC9749@gate.crashing.org>
References: <20190812023214.107817-1-natechancellor@gmail.com> <878srdv206.fsf@mpe.ellerman.id.au> <20190828175322.GA121833@archlinux-threadripper> <CAKwvOdmXbYrR6n-cxKt3XxkE4Lmj0sSoZBUtHVb0V2LTUFHmug@mail.gmail.com> <20190828184529.GC127646@archlinux-threadripper> <6801a83ed6d54d95b87a41c57ef6e6b0@AcuMS.aculab.com> <20190903055553.GC60296@archlinux-threadripper>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903055553.GC60296@archlinux-threadripper>
User-Agent: Mutt/1.4.2.3i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 10:55:53PM -0700, Nathan Chancellor wrote:
> On Thu, Aug 29, 2019 at 09:59:48AM +0000, David Laight wrote:
> > From: Nathan Chancellor
> > > Sent: 28 August 2019 19:45
> > ...
> > > However, I think that -fno-builtin-* would be appropriate here because
> > > we are providing our own setjmp implementation, meaning clang should not
> > > be trying to do anything with the builtin implementation like building a
> > > declaration for it.
> > 
> > Isn't implementing setjmp impossible unless you tell the compiler that
> > you function is 'setjmp-like' ?
> 
> No idea, PowerPC is the only architecture that does such a thing.

Since setjmp can return more than once, yes, exciting things can happen
if you do not tell the compiler about this.


Segher
