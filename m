Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A89447AA2
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 07:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbhKHHAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 02:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237114AbhKHG77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 01:59:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5205F60041;
        Mon,  8 Nov 2021 06:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636354635;
        bh=oXPkLG9UQMbQzEsjgMGmo5rrYLPdclwno9fWmRJctjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Go/gI09zs0oo4A+YPy63Q9cK7ZQz7ocpXYguw6iDCBQ8ILfX08egRVUqba0FSp3FB
         6nlxff0D3Ek4MeS6SxEM89/oBw1gVMRE+7p9bu1LJaUQVVeGHseEtJuhrEbZ905yHd
         YXGn9VsUMpy1BdC/rCA5DUbD/y+SIyS3kPuRjsLE=
Date:   Mon, 8 Nov 2021 07:57:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: Please apply 3d5e7a28b1ea2d603dea478e58e37ce75b9597ab to 5.15,
 5.14, and 5.10
Message-ID: <YYjKSQ4Axy44KNcs@kroah.com>
References: <YYQjyo/dKfDb/no3@archlinux-ax161>
 <c3757fc0-09fa-b0f1-7165-795e0363058d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3757fc0-09fa-b0f1-7165-795e0363058d@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 05, 2021 at 09:44:05AM +0100, Paolo Bonzini wrote:
> On 11/4/21 19:17, Nathan Chancellor wrote:
> > Hi Greg and Sasha,
> > 
> > Please apply commit 3d5e7a28b1ea ("KVM: x86: avoid warning with
> > -Wbitwise-instead-of-logical") to 5.10, 5.14, and 5.15, where it
> > resolves a build error with tip of tree clang due to -Werror:
> > 
> > arch/x86/kvm/mmu/mmu.c:3548:15: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
> >                  reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
> >                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >                                                                            ||
> > arch/x86/kvm/mmu/mmu.c:3548:15: note: cast one or both operands to int to silence this warning
> > 1 error generated.
> > 
> > It applies cleanly to 5.14 and 5.15 and I have attached a backport for
> > 5.10. I have added Paolo in case he has any objections to this.
> 
> No problem.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

All now queued up, thanks.

greg k-h
