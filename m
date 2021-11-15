Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F013F4508A0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 16:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhKOPi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 10:38:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236811AbhKOPgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 10:36:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A53F661C12;
        Mon, 15 Nov 2021 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636990418;
        bh=ZWK3TA97/LCIB8a32AnL9JVmijBc7RMJbQx62HU8d5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BE4ydVU7QSja4GwsGDuYzon85LBSOdb2gjNfPehmDBoC8g03Jb8BqGsC/OFRlPFX2
         RnQjJfAjYIenOF0n/wux6eIIT4uuEOulqKT2fOdIzxgIHSkzooDDrJQJixzR1gH8yI
         t17BYxHT5vMjgg6+7Z/AUMD6uw/skZvWcVL5GdXA=
Date:   Mon, 15 Nov 2021 16:33:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     kabel@kernel.org, lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: aardvark: Fix PCIe Max Payload Size
 setting" failed to apply to 5.15-stable tree
Message-ID: <YZJ9z4N64bzgl97E@kroah.com>
References: <1636899211215194@kroah.com>
 <20211114142033.isnb6hszl6b5rozt@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211114142033.isnb6hszl6b5rozt@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 14, 2021 at 03:20:33PM +0100, Pali Rohár wrote:
> On Sunday 14 November 2021 15:13:31 gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.15-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hello Greg! Following patch is needed for PCI_EXP_DEVCTL_PAYLOAD_512B macro:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=460275f124fb072dca218a6b43b6370eebbab20d

Thanks, that solved the issue here for 5.10 and newer, but not for
4.9.y, 4.14.y, 4.19.y and 5.4.y.  Can you send fixes for them if it
matters?

thanks,

greg k-h
