Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7FB252B68
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 12:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgHZK3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 06:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgHZK3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 06:29:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1306C2071E;
        Wed, 26 Aug 2020 10:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598437754;
        bh=FqIljNcAU9kdTquRGY/YEvffKwBFgT6R95TwqOGVZ0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bGwRZ4U4reQ7zeesbhCXiUnk3SSIQvPPXo3B73MaoqDUQ7HC6588f+DSfp/NTSj13
         ZvR5B9oFAhIq8wdpcDiwxiC+pYDu4qQ1FVuSKHxs8IRYjKtJ5whzwpo2X2fs8LLv6E
         CShuYlojuwNrU5w0q6bDBDX++XZebwHWlmy1F2O0=
Date:   Wed, 26 Aug 2020 12:29:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     stable@vger.kernel.org, mpe@ellerman.id.au,
        linuxppc-dev@lists.ozlabs.org, sashal@kernel.org
Subject: Re: Please apply commit 0828137e8f16 ("powerpc/64s: Don't init
 FSCR_DSCR in __init_FSCR()") to v4.14.y, v4.19.y, v5.4.y, v5.7.y
Message-ID: <20200826102929.GA3356257@kroah.com>
References: <20200825224408.GB6060@mussarela>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825224408.GB6060@mussarela>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 07:44:08PM -0300, Thadeu Lima de Souza Cascardo wrote:
> After commit 912c0a7f2b5daa3cbb2bc10f303981e493de73bd ("powerpc/64s: Save FSCR
> to init_task.thread.fscr after feature init"), which has been applied to the
> referred branches, when userspace sets the user DSCR MSR, it won't be inherited
> or restored during context switch, because the facility unavailable interrupt
> won't trigger.
> 
> Applying 0828137e8f16721842468e33df0460044a0c588b ("powerpc/64s: Don't init
> FSCR_DSCR in __init_FSCR()") will fix it.

Now queued up, thanks.

greg k-h
