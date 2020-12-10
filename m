Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E452D616C
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732833AbgLJQO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:14:28 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:34689 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgLJQOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 11:14:24 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 2510E280074C5;
        Thu, 10 Dec 2020 17:13:18 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B9C6B105B6; Thu, 10 Dec 2020 17:13:36 +0100 (CET)
Date:   Thu, 10 Dec 2020 17:13:36 +0100
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
Message-ID: <20201210161336.GB18087@wunner.de>
References: <20201208073241.GA29998@wunner.de>
 <20201208134739.GJ643756@sasha-vm>
 <20201208171145.GA3241@wunner.de>
 <20201208211745.GL643756@sasha-vm>
 <20201209083747.GA7377@wunner.de>
 <X9Cat0z0YBZkXlvv@kroah.com>
 <20201209093818.GA3082@wunner.de>
 <X9Ccm7X1id8Jj9SH@kroah.com>
 <20201210070142.GA20930@wunner.de>
 <X9IYX/aUVyjmNF/p@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9IYX/aUVyjmNF/p@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 10, 2020 at 01:45:19PM +0100, Greg KH wrote:
> The less "special" steps I have to make, the less chance I mess
> something up :)
> 
> I've queued these up now, please check that I got it right.

Perfect, thank you.  I'll follow up with a respin of the bcm2835aux patch.

Lukas
