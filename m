Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72432C73CD
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733126AbgK1Vtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733202AbgK1TGp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Nov 2020 14:06:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4388024686;
        Sat, 28 Nov 2020 14:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606575172;
        bh=NeUmFiW0/fgip3EEm/BmlN1P0iQ9LWonrD5kKKvmViM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hFmDPCtFqrQTnEYizuuQQGeQRVWhGWxTmRvF3e4nTrMghHpldiD0FkZNLGUhbH5v2
         /PosdwrK84jzR49EdkNEl6k3GYHZpmbIj7vEBrVRtX0yChvVvlG9S1FPQUeavQz8zm
         /4xLg7ee4rbB607KqjYe912X8WQ2rr4rbPq02Jgw=
Date:   Sat, 28 Nov 2020 15:54:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     ceggers@arri.de, u.kleine-koenig@pengutronix.de, wsa@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] i2c: imx: Fix reset of I2SR_IAL flag"
 failed to apply to 5.4-stable tree
Message-ID: <X8JkiNsrpj7YNNqq@kroah.com>
References: <1602405612123102@kroah.com>
 <20201127192742.mwxcjkmmzj72v7zz@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127192742.mwxcjkmmzj72v7zz@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 07:27:42PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Oct 11, 2020 at 10:40:12AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. It will apply till 4.9-stable.

All now queued up, thanks.

greg k-h
