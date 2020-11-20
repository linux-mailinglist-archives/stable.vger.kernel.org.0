Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E57D2BA519
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgKTIvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:51:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgKTIvs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:51:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0686922254;
        Fri, 20 Nov 2020 08:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605862306;
        bh=Ci7RCZTsOsqc/q+v5QDFseGFwLdpFuenhgcKVJBqBus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TphDx7ctHSb6HKIeK7oFzMRbQ0n+gQL4k62rKQzHHylGm03mIt93eyIOyEcG5d2yK
         mm0p4jpkGS9pI3+aT40Zt1LPgvy5gp9z3CqlWSSGSsvbHoRCTiSUz7Qrdgf6nxP69/
         S2h8C0z8K7/hdGi+uBcqBqz4UAp4kkDNaynUQsTU=
Date:   Fri, 20 Nov 2020 09:52:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: backport of e50e4f0b85be ("i2c: imx: Fix external abort on
 interrupt in exit paths") for v4.4.y
Message-ID: <X7eDwnjkikIAEz3O@kroah.com>
References: <20201118210914.67lheikunk2b6i5f@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118210914.67lheikunk2b6i5f@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 18, 2020 at 09:09:14PM +0000, Sudip Mukherjee wrote:
> Hi Greg, Sasha,
> 
> This was missing in 4.4-stable. It was easier to backport than picking
> all the other commits needed to aply it cleanly. It has been manually
> backported with an extra label for goto. I will prefer an Ack from
> Wolfram or Krzysztof or Oleksij before you add it to your queue.

Looks sane enough to me, thanks!

All now queued up.

greg k-h
