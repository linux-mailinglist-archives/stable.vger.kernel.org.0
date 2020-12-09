Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437C12D3EF3
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 10:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbgLIJjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 04:39:00 -0500
Received: from bmailout3.hostsharing.net ([176.9.242.62]:56321 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgLIJjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 04:39:00 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id A1572100FC173;
        Wed,  9 Dec 2020 10:38:17 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 600D1AECF; Wed,  9 Dec 2020 10:38:18 +0100 (CET)
Date:   Wed, 9 Dec 2020 10:38:18 +0100
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
Message-ID: <20201209093818.GA3082@wunner.de>
References: <70e63c9a7ed172e15b9d1fe82d44603ea9c76288.1607257456.git.lukas@wunner.de>
 <b0fb1c8837b69d56de2004dce945d0aa33d88357.1607257456.git.lukas@wunner.de>
 <20201208004901.GB587492@ubuntu-m3-large-x86>
 <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
 <20201209083747.GA7377@wunner.de>
 <X9Cat0z0YBZkXlvv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9Cat0z0YBZkXlvv@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:36:55AM +0100, Greg KH wrote:
> On Wed, Dec 09, 2020 at 09:37:47AM +0100, Lukas Wunner wrote:
> > Then please apply the series sans bcm2835aux patch and I'll follow up
> > with a two-patch series specifically for that driver.
> 
> Can you just resend the whole series so we know we got it correct?

The other patches in the series do not depend on the bcm2835aux patch,
so you can apply them independently.

Thanks,

Lukas
