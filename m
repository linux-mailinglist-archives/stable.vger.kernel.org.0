Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E1D3932A4
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhE0Ppe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235184AbhE0Ppe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:45:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA04661008;
        Thu, 27 May 2021 15:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622130240;
        bh=2fJn3hCYMdQLFVFjxMiTLdeoF8teeXHiIdFoTfIrLV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RWqpTgNYSHbFuwARBdx3O8mrwe5Z7ox6ACvILOZfG7FpmGuGR5MmS4vQ6BZ6AHYSc
         tz0V964Xg9LgsMeJNKfD9gU+qSS+dsW8Ac9tKQ88PW/TvpxMoscxG9IEVaLiFZW9/k
         8ZTRbSBsK2B0eTqv0VhMIcHZJEDPpgUhWfoL6Mwo=
Date:   Thu, 27 May 2021 17:43:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jack Wang <jack.wang.usish@gmail.com>, wanpengli@tencent.com,
        tglx@linutronix.de, stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Defer vtime accounting 'til
 after IRQ handling" failed to apply to 5.10-stable tree
Message-ID: <YK++PXNzKZDGgfHr@kroah.com>
References: <1621006676203106@kroah.com>
 <CA+res+S2Jb2_pJFFDRQvizzm2s7yuaKJkqO16WoUT6hM9c0Neg@mail.gmail.com>
 <YK9jzz3vOMNJdAo1@kroah.com>
 <YK+57TTRNIhk6xCh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YK+57TTRNIhk6xCh@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 03:25:33PM +0000, Sean Christopherson wrote:
> On Thu, May 27, 2021, Greg Kroah-Hartman wrote:
> > On Wed, May 26, 2021 at 08:08:09AM +0200, Jack Wang wrote:
> > > <gregkh@linuxfoundation.org> 于2021年5月14日周五 下午9:32写道：
> > > >
> > > >
> > > > The patch below does not apply to the 5.10-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > 
> > > If I first apply 866a6dadbb02 ("context_tracking: Move guest exit
> > > context tracking to separate helpers")
> > > and 88d8220bbf06 ("context_tracking: Move guest exit vtime accounting
> > > to separate helpers")
> > > 
> > > then I can apply this commit cleanly to latest 5.10.y, I suppose it
> > > will work for 5.12.
> 
> Thanks much!
> 
> > That worked, thanks!  Now queued up.
> 
> To not mess up in the future, I assume known dependencies should be tagged
> "Cc: stable...", even if the dependencies aren't technically bug fixes?

Yes, the documentation shows also how to do this semi-automatically:

    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
