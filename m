Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067362C2F9B
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 19:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404083AbgKXSG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 13:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403986AbgKXSG6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 13:06:58 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A69206D5;
        Tue, 24 Nov 2020 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606241218;
        bh=ryPolJrkXeEPUUCbIxYYLYdbYmZUDRMCUtYti6/uKTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pblre8TlwaNnZPQ/+MfLOYDrJezKdY+YVPXHYfavS+Mm1T7oGvN4fIbQmlYhWUYm5
         wIKyyi/nE8TtfMwBHArXZKwBiKpCH9LJZxlko+E4YVX8MyAw3WaMv7flo3ZRILgDfd
         GcaDmBAkLAI9NunjdAu/TZwAfJ4Aev3dK06V/5YM=
Date:   Tue, 24 Nov 2020 19:06:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     lukas@wunner.de, broonie@kernel.org, f.fainelli@gmail.com,
        kdasu.kdev@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm-qspi: Fix use-after-free on
 unbind" failed to apply to 5.4-stable tree
Message-ID: <X71Lv314xaqrtn9B@kroah.com>
References: <160612300715987@kroah.com>
 <20201124134123.ie5jvzygygayajo5@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124134123.ie5jvzygygayajo5@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 01:41:23PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Nov 23, 2020 at 10:16:47AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport for all the stable tree from v4.9.y to v5.4.y.

THis didn't apply to 4.9.y, are you sure you tried that?

Anyway, queued up for all other branches, thanks!

greg k-h
