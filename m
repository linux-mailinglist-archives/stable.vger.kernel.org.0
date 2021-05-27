Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C516392A97
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhE0JUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235873AbhE0JTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 05:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC91613D3;
        Thu, 27 May 2021 09:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622107090;
        bh=Ci0A0F4GNBGdxjvOyTIqXiqna+jABVOlhsJzNunPVH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0J9dduxbOg5XKwiZ86pDs+q+tDswPVnptMgWxFn4UVqXxzCZWXJx85DQQKcAM/58P
         la+mBnDyzh+0bGC/irryaGNfGNNOK28g1TO4hKYPa+oIGZHzQZo+8rXKimoP/k/KpH
         VuZ3vHYPbQ0ZV8cqhphUc1ZXMg8mY/borJkwHv3s=
Date:   Thu, 27 May 2021 11:18:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     wanpengli@tencent.com, seanjc@google.com, tglx@linutronix.de,
        stable <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] KVM: x86: Defer vtime accounting 'til
 after IRQ handling" failed to apply to 5.10-stable tree
Message-ID: <YK9jzz3vOMNJdAo1@kroah.com>
References: <1621006676203106@kroah.com>
 <CA+res+S2Jb2_pJFFDRQvizzm2s7yuaKJkqO16WoUT6hM9c0Neg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+res+S2Jb2_pJFFDRQvizzm2s7yuaKJkqO16WoUT6hM9c0Neg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021 at 08:08:09AM +0200, Jack Wang wrote:
> <gregkh@linuxfoundation.org> 于2021年5月14日周五 下午9:32写道：
> >
> >
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> If I first apply 866a6dadbb02 ("context_tracking: Move guest exit
> context tracking to separate helpers")
> and 88d8220bbf06 ("context_tracking: Move guest exit vtime accounting
> to separate helpers")
> 
> then I can apply this commit cleanly to latest 5.10.y, I suppose it
> will work for 5.12.

That worked, thanks!  Now queued up.

greg k-h
