Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA8B2D406E
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgLIK6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgLIK6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 05:58:23 -0500
Date:   Wed, 9 Dec 2020 11:58:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607511463;
        bh=lE2hjSyoVcF2LDUfNoY3QBReJngq5pOO/Rein7/SFtM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=WI7o12lnqtdHVvU+Z2njNFAZNhJ6Wb4yIJoD5AjvhOn//+xsmLfv+DJxsjp0oVp9S
         QoKFUu8mQG0qZ/2W4urd82wsZP2HCH07XZLQ8Dm9ZJsX5pRr+XMZl23E5ZK0Awc6CR
         O2PvKJg3itMmvyMb2xa6JRgT3OydnINzrP4xrBDw=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     krzk@kernel.org, o.rempel@pengutronix.de,
        u.kleine-koenig@pengutronix.de,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>, wsa@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.4] i2c: imx: Check for I2SR_IAL after every byte
Message-ID: <X9Ct87KVV9BLJSlC@kroah.com>
References: <20201209093431.15561-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209093431.15561-1-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:34:31AM +0100, Christian Eggers wrote:
> commit 1de67a3dee7a279ebe4d892b359fe3696938ec15 upstream.
> 
> Arbitration Lost (IAL) can happen after every single byte transfer. If
> arbitration is lost, the I2C hardware will autonomously switch from
> master mode to slave. If a transfer is not aborted in this state,
> consecutive transfers will not be executed by the hardware and will
> timeout.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Tested (not extensively) on Vybrid VF500 (Toradex VF50):
> Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: stable@vger.kernel.org
> ---
> Hi Greg,
> 
> here is the patch for linux-5.4. Please let me know if this doesn't apply to
> older kernels.

That worked everywhere, thanks.

greg k-h
