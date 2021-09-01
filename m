Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29473FD526
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243047AbhIAIS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 04:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242911AbhIAIS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 04:18:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F8760698;
        Wed,  1 Sep 2021 08:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630484282;
        bh=GN6JRgy0rHxRTizsSUkISXXfC+FJ/NBJUSoc2dRDr7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xIZkGOmGCE/bunr/cFptL+5FjMPJ7LXz1r467yWZRHpobP/JKN4rq8eN8UcfHwo5T
         y8LATeNg6XgS82riUxzVxhzN3vD/httFgED35ka2QI/ZXDhPRqc1O7l733i9624Xtm
         BFnK5IA+FW6ejqllALDbXeFkwzPqX3HZd6eNTjlQ=
Date:   Wed, 1 Sep 2021 10:17:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        stable@vger.kernel.org,
        voice INTER connect GmbH <developer@voiceinterconnect.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Felix Fietkau <nbd@nbd.name>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        YouChing Lin <ycllin@mxic.com.tw>
Subject: Re: [PATCH v2 5.10.x] mtd: spinand: Fix incorrect parameters for
 on-die ECC
Message-ID: <YS83NzasS7jExTya@kroah.com>
References: <20210830130211.445728-1-frieder@fris.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830130211.445728-1-frieder@fris.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 03:02:10PM +0200, Frieder Schrempf wrote:
> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> The new generic NAND ECC framework stores the configuration and
> requirements in separate places since commit 93ef92f6f422 ("mtd: nand: Use
> the new generic ECC object"). In 5.10.x The SPI NAND layer still uses only
> the requirements to track the ECC properties. This mismatch leads to
> values of zero being used for ECC strength and step_size in the SPI NAND
> layer wherever nanddev_get_ecc_conf() is used and therefore breaks the SPI
> NAND on-die ECC support in 5.10.x.
> 
> By using nanddev_get_ecc_requirements() instead of nanddev_get_ecc_conf()
> for SPI NAND, we make sure that the correct parameters for the detected
> chip are used. In later versions (5.11.x) this is fixed anyway with the
> implementation of the SPI NAND on-die ECC engine.
> 
> Cc: stable@vger.kernel.org # 5.10.x
> Reported-by: voice INTER connect GmbH <developer@voiceinterconnect.de>
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> Acked-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> Changes in v2:
>   * Fix checkpatch error/warnings for commit message style
>   * Add Miquel's A-b tag

Now queued up, thanks.

greg k-h
