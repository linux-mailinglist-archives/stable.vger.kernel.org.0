Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E1D36A1AC
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 16:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbhDXOrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 10:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhDXOq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Apr 2021 10:46:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C26EF613C4;
        Sat, 24 Apr 2021 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619275581;
        bh=4oPo8Ag55Oj+kkLINFDlMDXPrrJ5z7xa+BCsGJ1ptJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HPY31R9uCrHt7Q2Cdvu1iYRoObTdQ6S+IHhFRfIG0wN3KhTZBByUIxjt45c8g/eOT
         t6702EdaGkC2xMv+UP6YP5g4wMZTQytcKRGrRwQ900fci0EuW0O4qdJFzfTeXrqYbY
         i6rCMhz/t2PoDgBja5hyArtB+b9mPyUIUoZ/75zc=
Date:   Sat, 24 Apr 2021 16:46:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mail@anirudhrb.com, davem@davemloft.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: hso: fix null-ptr-deref during tty
 device unregistration" failed to apply to 4.14-stable tree
Message-ID: <YIQvOsYh5+/1ZjrJ@kroah.com>
References: <161806330327108@kroah.com>
 <YIMbD19ioXTqm6cp@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIMbD19ioXTqm6cp@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 23, 2021 at 08:07:59PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sat, Apr 10, 2021 at 04:01:43PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will also apply for 4.9-stable and 4.4-stable.

Thanks, now queued up.

greg k-h
