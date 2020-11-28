Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3172C73DF
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgK1Vtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732838AbgK1TEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Nov 2020 14:04:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7C5624689;
        Sat, 28 Nov 2020 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606575262;
        bh=gm1ucmMJy6FreUXCQatzoc4hthE80bnTjvqbERhtidU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OV4JRQ2OQGPn4vje2JZp8qhd3T5KhgeeJ32vajpwo8Ftctp4Ak2NSJoK8CnHvdAlK
         j20drMnQMyu9kcolM63xY9/TMK65A94TDHo54GtlVek/a+LuUJsRMBuhe6u7sGSxYt
         crGwU2m2a9o/aFPCJ58XUe7aCijz3vThGw+Qbx0s=
Date:   Sat, 28 Nov 2020 15:55:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     kai.vehmanen@linux.intel.com, stable@vger.kernel.org, tiwai@suse.de
Subject: Re: FAILED: patch "[PATCH] ALSA: hda/hdmi: fix incorrect locking in
 hdmi_pcm_close" failed to apply to 4.19-stable tree
Message-ID: <X8Jk4WHVaKds9tTq@kroah.com>
References: <1602933698101166@kroah.com>
 <20201127173738.mvg5vamgc2v6zrrr@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127173738.mvg5vamgc2v6zrrr@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 05:37:38PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sat, Oct 17, 2020 at 01:21:38PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

All now applied, thanks!

greg k-h
