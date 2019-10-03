Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB34CAE10
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731010AbfJCSVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 14:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbfJCSVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 14:21:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9FD820830;
        Thu,  3 Oct 2019 18:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570126864;
        bh=GW9kG1g9n8dZDEbuOWx1EUaebZoX1KZ7MOS/WPdSz/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ksi0hPwPEfkkckf2MtmShbXR89JuE3dl0pOUChrXl1S0mCAgGz5ehD1iiRD+jYwWd
         rpWoJgeF8KFnXtJG4fuT7ptHiACOvzA+vybaMFY84fbZi5zjz+LY/bnadRHmqAfSQS
         qjOunk0oOtRj3/DGR3IHtdnVd/YdhM4985rgXOlI=
Date:   Thu, 3 Oct 2019 20:21:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Katsuhiro Suzuki <katsuhiro@katsuster.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.3 204/344] SoC: simple-card-utils: set 0Hz to sysclk
 when shutdown
Message-ID: <20191003182102.GD3457141@kroah.com>
References: <20191003154540.062170222@linuxfoundation.org>
 <20191003154600.389003319@linuxfoundation.org>
 <20191003172849.GB6090@sirena.co.uk>
 <20191003173327.GC6090@sirena.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003173327.GC6090@sirena.co.uk>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 06:33:27PM +0100, Mark Brown wrote:
> On Thu, Oct 03, 2019 at 06:28:49PM +0100, Mark Brown wrote:
> > On Thu, Oct 03, 2019 at 05:52:49PM +0200, Greg Kroah-Hartman wrote:
> 
> > > Some codecs set rate constraints that derives from sysclk. This
> > > mechanism works correctly if machine drivers give fixed frequency.
> 
> > This is a new feature which seems out of scope for stable - I thought
> > I'd raised this already?
> 
> No, I didn't sorry - that was a similar patch in a device driver that
> I'd flagged (and has been correctly dropped).

Now dropped from here and 5.2.y, thansk!

greg k-h
