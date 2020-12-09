Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B032D406D
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgLIK6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:58:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgLIK6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 05:58:13 -0500
Date:   Wed, 9 Dec 2020 11:58:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607511452;
        bh=PUqdvWso58mHktRgsbqF22C3V8U6/Fztgnq1bLOQurU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=a4D10+NbStaDorRLJlMKeHk0Zq6CauYf+IQrd67aixUnxxsZ3mzrvHZcNdOphTQ+O
         YMUUXXI2MiYWY204GzXXB4JFM/IUhpn/OPfNAW+DOnyB770Mi8XdIJf5/rIabtS80z
         w+41GolsTPWZJCjng1ualCF3TQvwtMwbvtosraoQ=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     o.rempel@pengutronix.de, u.kleine-koenig@pengutronix.de,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>, wsa@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.4] i2c: imx: Fix reset of I2SR_IAL flag
Message-ID: <X9Ct6R/yGPP9xFEa@kroah.com>
References: <20201209093202.15347-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201209093202.15347-1-ceggers@arri.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:32:02AM +0100, Christian Eggers wrote:
> commit 384a9565f70a876c2e78e58c5ca0bbf0547e4f6d upstream.
> 
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Fixes: 4b775022f6fd ("i2c: imx: add struct to hold more configurable quirks")
> Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Cc: stable@vger.kernel.org
> ---
> Hi Greg,
> 
> here is the patch for linux-5.4. Please let me know if this doesn't apply to
> older kernels.

That worked great, thanks!

greg k-h
