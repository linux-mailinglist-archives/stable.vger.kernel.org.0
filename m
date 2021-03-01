Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB3327E89
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhCAMpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235039AbhCAMpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:45:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 388C364E31;
        Mon,  1 Mar 2021 12:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614602709;
        bh=dPD0C7Tzuy49sCHRNCVck2CfLjlcSDAWog6EhlGIGEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gCVjInKvKdKEbno2zAE1d533k/+fo52I5Z3G8gFAU33sCF6RvpzE9Zol25LR/R1v/
         Icl9M+Z0L0dFZgWJXv+m/X+GSvhnrkXaMfblXOiFHIwBEkwbrDJVPWghF89AXCHAVs
         /DtBxa51s1qZnnF+WB9L3gpAoO0ynPVWKwGk/Wds=
Date:   Mon, 1 Mar 2021 13:45:06 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     yoshihiro.shimoda.uh@renesas.com, stable@vger.kernel.org,
        tho.vu.wh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: renesas_usbhs: Clear pipe running
 flag in" failed to apply to 4.14-stable tree
Message-ID: <YDzh0rLE36VtPQCt@kroah.com>
References: <161277841922126@kroah.com>
 <YDgdn7E9Nx5GMxkq@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDgdn7E9Nx5GMxkq@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 09:58:55PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Feb 08, 2021 at 11:00:19AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Will apply to all branches till 4.4-stable.

queued up, thanks.

greg k-h
