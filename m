Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12842ED760
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 20:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbhAGTS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 14:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbhAGTS7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 14:18:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6504B23441;
        Thu,  7 Jan 2021 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610047098;
        bh=OqFPkqDILLRcWSf6bsVJ5jn64VscWLRwkeo8Jabwv3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HmCe7LnsvrfKcP6FI2EV/dtuE3lYtdIiV6NMG+J4piYjvb30SYupsszfvO0Svfp5w
         0BWL9YKYcP2/VM4dUDlVa2gQtBgCtyLXVr97DXE7PSzTY7csB47RKm5fBVj8sYpBuT
         TR4QStTMtfKqOvFeveGN/XFjdJ2lrB+d5guwM8kY=
Date:   Thu, 7 Jan 2021 20:19:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jinoh Kang <jinoh.kang.kr@gmail.com>
Cc:     stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        PGNet Dev <pgnet.dev@gmail.com>,
        Roger Pau Monne <roger.pau@citrix.com>
Subject: Re: [BACKPORT] xen/pvh: correctly setup the PV EFI interface for dom0
Message-ID: <X/deyng/y7b+9gUM@kroah.com>
References: <1558349221210204@kroah.com>
 <20190527121138.41800-1-roger.pau@citrix.com>
 <aeeaf95b-765d-7bd1-e156-4b26d3dca739@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeeaf95b-765d-7bd1-e156-4b26d3dca739@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 05:30:25PM +0000, Jinoh Kang wrote:
> This patch had slipped through the cracks, yet it still applies cleanly
> to v4.19.165.
> 
> It would be much appreciated to have this patch queued.

Odd, I don't know how I missed this, thanks for noticing.  I'll queue
this up after this next round of releases.

thanks,

greg k-h
