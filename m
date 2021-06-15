Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CEF3A7CAD
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 13:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFOLIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 07:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229968AbhFOLIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 07:08:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D2F61455;
        Tue, 15 Jun 2021 11:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623755193;
        bh=9YpOOfgix+L3k99C9A+Xuvr/JK66X4XZ3z1UIs6bpi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rXEIIt+8Do1Kt6RpafEWpZOd85TlfHkYr+WIxg1xyAue35kptrUKRgqPk1WJaTFiX
         cfFUGo9zbw1xxqHipiqT5M1dOelk0P6vqaKlr9O1msgTGU4yzPcVMid3pllP4dIgFW
         Cpi/1hucbM/s8FusL08wOpM8VEUbBfbf2bk1SRtt1znRTUK6hLee5zNyqiZDIl+NBr
         rutxDRYzRII38POpEviCA7Q1GJf7Qr3w/FL48a5A1NmUwfv5YAEk8lxNDU2JMcwp8N
         KfeUhJuC90YHbciWekkuAEss53ewVrpVve5ocpW4+tZp99MwgnpdAnAoEoLdrt6HdJ
         KeUW/8j41+hTw==
Date:   Tue, 15 Jun 2021 16:36:29 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Moritz Fischer <mdf@kernel.org>, maz@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: [PATCH] usb: renesas-xhci: Fix handling of unknown ROM state
Message-ID: <YMiJtbesPMxJv7C7@vkoul-mobl>
References: <20210615022514.245274-1-mdf@kernel.org>
 <YMhTddYjJwDcNau/@kroah.com>
 <YMhcV39CtSx0F45o@vkoul-mobl>
 <YMh2gnQl9c93mlu+@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMh2gnQl9c93mlu+@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15-06-21, 11:44, Greg KH wrote:
> On Tue, Jun 15, 2021 at 01:22:55PM +0530, Vinod Koul wrote:
> > On 15-06-21, 09:15, Greg KH wrote:
> > > On Mon, Jun 14, 2021 at 07:25:14PM -0700, Moritz Fischer wrote:
> > > > If the ROM status returned is unknown (RENESAS_ROM_STATUS_NO_RESULT)
> > > > we need to attempt loading the firmware rather than just skipping
> > > > it all together.
> > > 
> > > How can this happen?  Can you provide more information here?
> > 
> > Sometimes ROM load seems to return unknown status, this helps in those
> > cases by doing attempting RAM load. The status should be success of
> > fail, here it is neither :(
> 
> Then this needs to be added to the changelog text please.

/me nods

-- 
~Vinod
