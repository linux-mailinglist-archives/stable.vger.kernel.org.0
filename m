Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40428AFF5
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 10:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgJLIUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 04:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgJLIUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 04:20:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B0E208FE;
        Mon, 12 Oct 2020 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602490819;
        bh=fS2jbBI9B2wB59Mx6/O3VLCQ1yFoeZoyHQyLYKDnzQQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uIhOyiKk7o5vSVy5auB1oVxK2gW4keuz1uMiPlWUcKfrGT/vw3vZdWDnqFsucKLr0
         qKEZit2rxIlFN0LgN/1MJgPv7L1Rt5VqM1pBpr8k/yg36foSnKtaYeGKWDBNnltB/4
         7UmPv8k8CW+dylPaIrwYoXX90z56VaBcZH5WyaVc=
Date:   Mon, 12 Oct 2020 10:20:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     u.kleine-koenig@pengutronix.de, wsa@kernel.org,
        stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "i2c: imx: Fix reset of I2SR_IAL flag" has been added to
 the 5.8-stable tree
Message-ID: <20201012082059.GA3798940@kroah.com>
References: <1602406113214120@kroah.com>
 <6827529.2cDsNes8Pd@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6827529.2cDsNes8Pd@n95hx1g2>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 09:38:30AM +0200, Christian Eggers wrote:
> Hi Greg,
> 
> the patch below has meanwhile been reverted by Wolfram Sang [1], because it has
> been superseded. Although the patch itself is not wrong, you also may want to
> revert it in order to avoid conflicts with the next version.
> 
> Best regards
> Christian
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5a02e7c429cb5e082e5d7be6e5b768828014ba70

Thanks for letting me know, now dropped.

greg k-h
