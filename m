Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86AF3C9E12
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhGOMBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 08:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhGOMBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 08:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A976961370;
        Thu, 15 Jul 2021 11:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626350338;
        bh=hQvqP4xhUEKWRd0Iet0V2d4p05UjSuxPoJlVUmzmTuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XE/vZk6G0VEmOVS5XK/W4l2PA7+w5icUROKJ25Kl311tBdaxhCw/8nBg07Zi2oQBA
         ZFUqs6QfquCcxwnmA4Eq22VxtbAAQzTzDG6N/OQ2KVk3DsiIZZ9wg7f17yyz9Z2sVd
         1fUOc199hVjkhO4cCRfZuy4DDi2vGX5o4PRvRk84=
Date:   Thu, 15 Jul 2021 13:49:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] serial: mvebu-uart: fix calculation of
 clock divisor" failed to apply to 4.19-stable tree
Message-ID: <YPAg5V+JpiJC3woL@kroah.com>
References: <16260085611907@kroah.com>
 <20210712084802.xhggfwia3l4vaeel@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210712084802.xhggfwia3l4vaeel@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 10:48:02AM +0200, Pali Rohár wrote:
> On Sunday 11 July 2021 15:02:41 gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 4.19-stable tree.
> 
> Hello Greg!
> 
> I have tested this it and it applies cleanly. I have just called
> following commands on top of linux-4.19.y branch without any manual
> backporting and there were no issues.
> 
> git cherry-pick 0e4cf69ede87
> git cherry-pick 9078204ca5c3
> 
> Could you look at it, why it is failing for you?

Ah, my fault, I forgot to grab the first commit here.

Now queued up, thanks.

greg k-h
