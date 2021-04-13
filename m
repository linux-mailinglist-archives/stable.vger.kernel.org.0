Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4BD35DF0F
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 14:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhDMMkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 08:40:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231235AbhDMMkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Apr 2021 08:40:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C096E613AE;
        Tue, 13 Apr 2021 12:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618317603;
        bh=FHf3iVimbCgzHy7R6PtR3PJXmue0BTUbqB0ywVSchi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nuOBpIiJCs5QMaIEYrhTI5vjuQIZQB2Ks9UuW4xAC2WOxI2DcXtBU1n7DQVWP2KxB
         s4a87wK3s8vvQ/CmTXvdVw52MifywsBVNOD/gwY3RCAbC1l+GtfFhdx5MGfpNNyqwJ
         SIv+QLOuHRP/mMvp3082jruzRT7pmwm+yFxjpNz8=
Date:   Tue, 13 Apr 2021 14:40:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.4 097/111] net: sched: bump refcount for new action in
 ACT replace mode
Message-ID: <YHWRICLRggwtsFrv@kroah.com>
References: <20210412084004.200986670@linuxfoundation.org>
 <20210412084007.483296509@linuxfoundation.org>
 <YHV0SagpvPYZznFT@debian>
 <YHV3ntI2dnYC+2IA@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHV3ntI2dnYC+2IA@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 13, 2021 at 12:51:10PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 13, 2021 at 11:36:57AM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> > 
> > On Mon, Apr 12, 2021 at 10:41:15AM +0200, Greg Kroah-Hartman wrote:
> > > From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > 
> > > commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149 upstream.
> > 
> > This has been reverted upstream by:
> > 4ba86128ba07 ("Revert "net: sched: bump refcount for new action in ACT replace mode"")
> 
> Ah, I added that to the 5.10 and 5.11 queues, but not 4.19 or 5.4, odd,
> my fault, thanks for letting me know, I'll go fix that up...

I see why I did it that way.  The revert is there because of additional
patches in the tree that means that the original patch is not needed
anymore.  But those patches were not backported to 4.19 and 5.4, so the
revert shouldn't be needed either.

Right?  It would be great if someone else could verify this...

thanks,

greg k-h
