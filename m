Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFA23EB2CE
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 10:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbhHMIrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 04:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239327AbhHMIrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 04:47:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CCE66103A;
        Fri, 13 Aug 2021 08:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628844405;
        bh=PdiV4uv9arVTJdJW6NMBxaTD5gx7BJLmoJkbhQj3JGw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZyYfbIrPWHW3du2YjcNzBau86isdh0Wsh/w6gVhdmvdctxwnXf9gMDh5rGoI6b86n
         l8vTs02P1rE9/i+Pv/4tSvJPD0GoJETfP1HppcW5iVsGxoRPtM+BiO2jHT/VaM///x
         LL/QnxigrpoGv9QJjKbcwKKGo2t7TPUubRThV6L4=
Date:   Fri, 13 Aug 2021 10:46:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     aford173@gmail.com, geert+renesas@glider.be, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: dts: renesas: beacon: Fix USB ref
 clock references" failed to apply to 5.10-stable tree
Message-ID: <YRYxcvfdOI8rKpHT@kroah.com>
References: <1626979705124214@kroah.com>
 <YRQ5uSbybJgxaQm7@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRQ5uSbybJgxaQm7@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 09:57:29PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Thu, Jul 22, 2021 at 08:48:25PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> There was another failed mail for 56bc54496f5d ("arm64: dts: renesas:
> beacon: Fix USB extal reference"). So, that one and this one together
> with e1076ce07b77 ("arm64: dts: renesas: rzg2: Add usb2_clksel to
> RZ/G2 M/N/H") which is needed for these two to work.

Now queued up, thanks.

greg k-h
