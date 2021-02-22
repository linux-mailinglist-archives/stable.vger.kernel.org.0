Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA4B321495
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhBVK5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:57:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230318AbhBVK5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 05:57:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1185364E00;
        Mon, 22 Feb 2021 10:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613991419;
        bh=0UStbZg0k5k6msHnyoYQaF5MawOBNH9Mi5vMZxhMoqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t3ufcZxAbm7VFQsHgKfHScSPe43Nz+KXl666n+2YrkUbBTTDXdcKItiEAFLk6mCWS
         23b19XQj4B1LQQ2tSFxpxGwsEJUFGG5yQcoCXkrNdhebgsXitxyMJhZ9c9dTKLMVdF
         a3blk3RRH+kUnaj/lCDLngA+AbW9TxvqUuGeAz34=
Date:   Mon, 22 Feb 2021 11:56:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     manish.narani@xilinx.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: gadget: u_ether: Fix MTU size
 mismatch with RX packet" failed to apply to 4.14-stable tree
Message-ID: <YDON+c2Iic1bVjTm@kroah.com>
References: <1610354613231213@kroah.com>
 <YC2ECvwJvBaZ8f/1@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC2ECvwJvBaZ8f/1@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 09:00:58PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 11, 2021 at 09:43:33AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport along with eea52743eb56 ("USB: Gadget Ethernet: Re-enable Jumbo frames.")
> for easy backporting. And looks like that should have been in stable by itself.

Now queued up, thanks.

greg k-h
