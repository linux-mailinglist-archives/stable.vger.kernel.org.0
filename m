Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC183950D4
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 14:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhE3MUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 08:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhE3MUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 May 2021 08:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4254660FEE;
        Sun, 30 May 2021 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622377120;
        bh=un+pP4moUAJKu8Gas2nHQjYmhxhnWSQg5kj2F+cRNms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hD7lvryUGZUv2Vz6r4wM9flMZiHMZ76pCgi8WOi/vuS2qm0vx4gm9x+19A+g7JHPC
         SkhKfptkE2jGyt7cs3BGXtLy+oCE8VLVzci0R+Z4nOMfh/ckYtEDOEFWmw49bqckxf
         8A+0PxA3DuZuWRr7ovDHYo9ZM/qzlBs2p+eqbTk0=
Date:   Sun, 30 May 2021 14:18:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Phil Elwell <phil@raspberrypi.com>
Cc:     stable@vger.kernel.org
Subject: Re: Back-ports of dwc2 commit break peripheral-only builds
Message-ID: <YLOCnlGa9L7rnwk4@kroah.com>
References: <558ce64c-666a-5b68-ee48-74293b08cbbc@raspberrypi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558ce64c-666a-5b68-ee48-74293b08cbbc@raspberrypi.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 28, 2021 at 11:19:00AM +0100, Phil Elwell wrote:
> Hi,
> 
> Back-ports of [1] - a Fix to the dwc2 driver - cause build errors for
> configurations including CONFIG_USB_DWC2_PERIPHERAL=y because in the stable
> branches the bus_suspended member of struct dwc2_hsotg is not present with
> that setting. [1] depends on [2] to move bus_suspended into a common part of
> dwc2_hsotg, but because [2] is not a fix it hasn't been back-ported to
> stable branches. [2] does not apply cleanly on its own (e.g. to
> linux-5.10.y) , so either more commits must be back-ported, [1] must be
> reverted, or a subset of [2] could be used for the back-ports.
> 
> Phil
> 
> [1] 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes")
> 
> [2] 012466fc8ccc0 ("usb: dwc2: Add device clock gating support functions")

Do you have a "working" version of this patch that we could take for the
older kernel trees that does not break the build?  That might be the
best thing here.

thanks,

greg k-h
