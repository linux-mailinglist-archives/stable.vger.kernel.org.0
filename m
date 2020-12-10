Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92652D544F
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 08:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgLJHCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 02:02:38 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:48449 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgLJHC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 02:02:26 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id B2882280001A4;
        Thu, 10 Dec 2020 08:01:24 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 064305BEE; Thu, 10 Dec 2020 08:01:42 +0100 (CET)
Date:   Thu, 10 Dec 2020 08:01:42 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.com>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19-stable 4/5] spi: bcm2835aux: Fix use-after-free on
 unbind
Message-ID: <20201210070142.GA20930@wunner.de>
References: <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
 <20201209083747.GA7377@wunner.de>
 <X9Cat0z0YBZkXlvv@kroah.com>
 <20201209093818.GA3082@wunner.de>
 <X9Ccm7X1id8Jj9SH@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9Ccm7X1id8Jj9SH@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:44:59AM +0100, Greg KH wrote:
> On Wed, Dec 09, 2020 at 10:38:18AM +0100, Lukas Wunner wrote:
> > On Wed, Dec 09, 2020 at 10:36:55AM +0100, Greg KH wrote:
> > > On Wed, Dec 09, 2020 at 09:37:47AM +0100, Lukas Wunner wrote:
> > > > Then please apply the series sans bcm2835aux patch and I'll follow up
> > > > with a two-patch series specifically for that driver.
> > > 
> > > Can you just resend the whole series so we know we got it correct?
> > 
> > The other patches in the series do not depend on the bcm2835aux patch,
> > so you can apply them independently.
> 
> Ok, so I need to drop this patch from all of the other series you sent
> out?  You can see how this is getting messy from my side :)

Is this workflow description still up-to-date?

http://kroah.com/log/blog/2019/08/14/patch-workflow-with-mutt-2019/

So you just select all patches in Mutt sans the bcm2835aux one
and apply them?

No I don't see how this is getting messy.

Thanks,

Lukas
