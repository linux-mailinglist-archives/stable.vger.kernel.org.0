Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7BB310738
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 09:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBEI5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 03:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229843AbhBEI5R (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 03:57:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073BF64EE2;
        Fri,  5 Feb 2021 08:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612515396;
        bh=F9XJuYsZw+Wgr338G8iiOQ+yv1J+ma4lIRR67HlcDAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DDlzskMZVNInqnjP2n8Ug4jCJBD7NdVH/nVZdcYNuFdfqr3EIrHQx4euoRWZ7E+Su
         DoFZV4MK3b0AsGmHnyx/PQMa071R4tdSK6TqN8XbqRboql7K1m3TayMXV37obm5cST
         lJiGl2CKL+rZqp4Hs/Rh28BVjqtgdqfmfYiA2mwE=
Date:   Fri, 5 Feb 2021 09:56:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Thinh.Nguyen@synopsys.com, balbi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: udc: core: Use lock when write to
 soft_connect" failed to apply to 4.4-stable tree
Message-ID: <YB0IQeV4OAxYhd5R@kroah.com>
References: <1611584391127172@kroah.com>
 <YBwlsCtNI9Nyuwq6@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBwlsCtNI9Nyuwq6@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 04, 2021 at 04:49:52PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 25, 2021 at 03:19:51PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Applied, thanks.

greg k-h
