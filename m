Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265902C2FA2
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 19:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404250AbgKXSH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 13:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404232AbgKXSH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 13:07:57 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6801A206D5;
        Tue, 24 Nov 2020 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606241276;
        bh=Alc6tjQGj83GG4GRqTT3Y7rPf0uV56+AYnWnA+DfU/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VGeP+PTbGGlwA4SFwsbf+p264Jauid5aBgq2AYVyaf4bjlXMO+QVWfE+DXZm/KN7v
         MHC/zJ5SQH2utzYPBivJOVp+O6vBvVEPimIdZ0OwqMbXOm/cDkwpfrmMikwu39vJFq
         cd+wAkzu69zRSKxT04IVM2hrut9/Zfi0x21xxrgY=
Date:   Tue, 24 Nov 2020 19:07:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        olteanv@gmail.com, s.hauer@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <X71L+q6fCbi6E1+c@kroah.com>
References: <1606121664109241@kroah.com>
 <20201124170428.vfs6ffqraer7aumc@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124170428.vfs6ffqraer7aumc@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 05:04:28PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Nov 23, 2020 at 09:54:24AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

This and the 5.9 backport now queued up, thanks.

greg k-h
