Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68A53CD732
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 16:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbhGSOMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232228AbhGSOMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 597D2610F7;
        Mon, 19 Jul 2021 14:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706360;
        bh=NbLAtIkdeqkcYH7ARmXqo2n1RUD25wLOX7FYKUrb4FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lB8J2w1iPbIAougrLwQIeywY1w5Vhkm2CUN2plUSll2VhyMcuH/5qje4iw96RQ0fi
         KzF565fLJJvkFiBkRKOHna44gjH64DF25+TS9FDOS5dMQ5mNsZiyIwN6K6w1JLSlY2
         Tm7IGW3ETcWNzYb6DUFzSR8roc8mLfmb23VjouGE=
Date:   Mon, 19 Jul 2021 16:52:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failure in v4.19.y-queue
Message-ID: <YPWRtkqxI+VrRm0a@kroah.com>
References: <a4a8e5d2-7f54-d8e4-67e6-365bc31fd28a@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4a8e5d2-7f54-d8e4-67e6-365bc31fd28a@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 17, 2021 at 08:46:57AM -0700, Guenter Roeck wrote:
> Build reference: v4.19.197-317-gb088d8812da4
> Compiler version: powerpc64-linux-gcc (GCC) 11.1.0
> 
> Building powerpc:defconfig ... failed
> --------------
> Error log:
> arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
> arch/powerpc/kernel/stacktrace.c:222:33: error: implicit declaration of function 'udelay'

Oops, forgot to fix that one up too.  Now done, thanks.

greg k-h
