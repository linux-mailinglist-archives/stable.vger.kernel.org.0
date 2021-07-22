Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6823D2611
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhGVOFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 10:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhGVOFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 10:05:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACD8060FEE;
        Thu, 22 Jul 2021 14:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626965138;
        bh=Db9hmHPJbU2Wema1lfm36z4m9F7q7X85bixfMgyLz3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N6eXp3pvRSYPU3udpNwXbYl8QFNlEkQOjCp5T8YWyPMc0Kx6grH8rgF2Wc/mJDskW
         u99AtDO263bAOSH10cauEXGpC6z8JW+iKag1lEpArAKRUnFJBenAzvIBgTLRE4itJm
         5kDRz9aVCCXcLd965FdKO/iT3JDzkW/FJDHoIYUc=
Date:   Thu, 22 Jul 2021 16:45:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm writecache: fix writing beyond end of
 underlying device" failed to apply to 4.19-stable tree
Message-ID: <YPmEj3bAdbzyjMnm@kroah.com>
References: <1614606368115248@kroah.com>
 <alpine.LRH.2.02.2107191120160.17791@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2107191120160.17791@file01.intranet.prod.int.rdu2.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 11:20:49AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 1 Mar 2021, gregkh@linuxfoundation.org wrote:
> 
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi
> 
> This is backport of the patch 4134455f2aafdfeab50cabb4cccb35e916034b93 for
> the stable branch 4.19.

Now queued up, thanks.

greg k-h
