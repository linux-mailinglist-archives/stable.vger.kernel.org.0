Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840053A7AFE
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 11:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhFOJql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 05:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbhFOJql (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 05:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D562613ED;
        Tue, 15 Jun 2021 09:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623750276;
        bh=vx6hr4RNu4Z2Nf2Z3lL6itYQPkp8P7oEiUd8XdLIBBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2r8nL1/tNgnQUEZ6/vLjLAGZnkMEJHTuF6PgVvJqbG36yINLCS0PBdf1xddCC3Zah
         tvYvMZ+Fl1338n9QDH22+kIFng7dMyH9veFfBuI6bVYzJH6uPhEyVNNnHEvQb4MLKc
         EcsM0t20vJ8m+rYMkULSDYZODfENAFPPMssoEJXw=
Date:   Tue, 15 Jun 2021 11:44:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Moritz Fischer <mdf@kernel.org>, maz@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: [PATCH] usb: renesas-xhci: Fix handling of unknown ROM state
Message-ID: <YMh2gnQl9c93mlu+@kroah.com>
References: <20210615022514.245274-1-mdf@kernel.org>
 <YMhTddYjJwDcNau/@kroah.com>
 <YMhcV39CtSx0F45o@vkoul-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMhcV39CtSx0F45o@vkoul-mobl>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 01:22:55PM +0530, Vinod Koul wrote:
> On 15-06-21, 09:15, Greg KH wrote:
> > On Mon, Jun 14, 2021 at 07:25:14PM -0700, Moritz Fischer wrote:
> > > If the ROM status returned is unknown (RENESAS_ROM_STATUS_NO_RESULT)
> > > we need to attempt loading the firmware rather than just skipping
> > > it all together.
> > 
> > How can this happen?  Can you provide more information here?
> 
> Sometimes ROM load seems to return unknown status, this helps in those
> cases by doing attempting RAM load. The status should be success of
> fail, here it is neither :(

Then this needs to be added to the changelog text please.

thanks,

greg k-h
