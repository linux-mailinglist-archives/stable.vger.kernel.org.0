Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2543839FD39
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhFHRI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232541AbhFHRI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 13:08:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 270466128E;
        Tue,  8 Jun 2021 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623172015;
        bh=0oq6QLIflkGHbOxU5rx4bKYJt3ntT7idXhuJlwJoNMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vsPcslPrkz/qLjC+oXoJYPqk+5aRMwrlTSumo6CbwSrV+/p/zHCQT7qnWhv4E+85H
         p0Yr6SqqS3w5JPCXeQiRCCfCFXBudKwgpG7fLKq5GKDnZd6jkrPMN3mhz0SbpJVMuY
         KNdbskQlRH113UjomCUIyU74mn02bzCR1SY7dvks=
Date:   Tue, 8 Jun 2021 19:06:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     stable@vger.kernel.org, Michael Weiser <michael.weiser@gmx.de>,
        Martin Vajnar <martin.vajnar@gmail.com>,
        musl@lists.openwall.com, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [stable v4.4] arm64: Remove unimplemented syscall log
 message
Message-ID: <YL+jrRKPCgoDtQ1r@kroah.com>
References: <20210602114651.423605-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602114651.423605-1-arnd@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 02, 2021 at 01:46:51PM +0200, Arnd Bergmann wrote:
> From: Michael Weiser <michael.weiser@gmx.de>
> 
> commit 1962682d2b2fbe6cfa995a85c53c069fadda473e upstream.
> 
> Stop printing a (ratelimited) kernel message for each instance of an
> unimplemented syscall being called. Userland making an unimplemented
> syscall is not necessarily misbehaviour and to be expected with a
> current userland running on an older kernel. Also, the current message
> looks scary to users but does not actually indicate a real problem nor
> help them narrow down the cause. Just rely on sys_ni_syscall() to return
> -ENOSYS.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Martin Vajnar <martin.vajnar@gmail.com>
> Cc: musl@lists.openwall.com
> Acked-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Michael Weiser <michael.weiser@gmx.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This was backported to v4.14 and later, but is missing in v4.4 and
> before, apparently because of a trivial merge conflict. This is
> a manual backport I did after I saw a report about the issue
> by Martin Vajnar on the musl mailing list.
> ---
>  arch/arm64/kernel/traps.c | 8 --------
>  1 file changed, 8 deletions(-)

Now queued up, thanks.

greg k-h
