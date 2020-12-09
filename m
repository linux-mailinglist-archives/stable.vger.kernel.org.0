Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209662D3F0A
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 10:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgLIJo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 04:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbgLIJoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 04:44:22 -0500
Date:   Wed, 9 Dec 2020 10:44:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607507022;
        bh=OGv89knfwfqKlm+IZJ65tJhz1RjvZTsVSJZ4ExOnwLY=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=e/dJ+PZLPEqV9D6lnRq9CBG79Pt45Kp0Mvy26lEVYns03xLCYvlER8HvvqycKdVrP
         LrKpyOhy4j+YXwdSCc3CVXHDNHp2HlcEH0uiL4KpTqLonxu5DmIpDPLTVD/MUpL77F
         aykUF+VrHTxYRXvC302LXYdZYL2eQARl9HLflwng=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <X9Ccm7X1id8Jj9SH@kroah.com>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
 <20201209083747.GA7377@wunner.de>
 <X9Cat0z0YBZkXlvv@kroah.com>
 <20201209093818.GA3082@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209093818.GA3082@wunner.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:38:18AM +0100, Lukas Wunner wrote:
> On Wed, Dec 09, 2020 at 10:36:55AM +0100, Greg KH wrote:
> > On Wed, Dec 09, 2020 at 09:37:47AM +0100, Lukas Wunner wrote:
> > > Then please apply the series sans bcm2835aux patch and I'll follow up
> > > with a two-patch series specifically for that driver.
> > 
> > Can you just resend the whole series so we know we got it correct?
> 
> The other patches in the series do not depend on the bcm2835aux patch,
> so you can apply them independently.

Ok, so I need to drop this patch from all of the other series you sent
out?  You can see how this is getting messy from my side :)

thanks,

greg k-h
