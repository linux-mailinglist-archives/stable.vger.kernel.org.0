Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4C92DEECC
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLSMj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgLSMj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:39:57 -0500
Date:   Sat, 19 Dec 2020 13:40:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608381556;
        bh=fdJl8QREJXafHojqD5A7xQqhiF+6dUI+o9zR8KG3QXU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=yv1tbuq9DL7+M4cTWDRRZlFYwup+oFaxn3nBSinRVzs/KOZdjYwEM8qk/vHRqdmMD
         2xnW6POYoe0IFwczd1129CqTymMFMkDG5toUM/x6KwovSA/xuAzLTCkuzqa5DPjn0I
         LWSPKtDUHQYFj8s1U/L9C6nZtvHhnoz2/Kvbly9w=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     brant.merryman@silabs.com, johan@kernel.org, phu.luu@silabs.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: cp210x: enable usb generic
 throttle/unthrottle" failed to apply to 4.4-stable tree
Message-ID: <X930xQEIeBIanTHd@kroah.com>
References: <159765869110835@kroah.com>
 <20201216115758.7gfz5oxcfghsbftx@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216115758.7gfz5oxcfghsbftx@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 11:57:58AM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Aug 17, 2020 at 12:04:51PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Thanks, now queued up.

greg k-h
