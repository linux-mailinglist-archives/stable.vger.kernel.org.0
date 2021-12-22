Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4E147D17F
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbhLVMIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhLVMIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:08:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A9FC061574;
        Wed, 22 Dec 2021 04:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18A65B81C0F;
        Wed, 22 Dec 2021 12:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDADC36AE5;
        Wed, 22 Dec 2021 12:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174886;
        bh=Bs6plq2rfuXMX74t3gcF6+hS3gsW/monRYQ0HiJmGuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gp58VR8QruknRVsqk+6Mpkg1VSGH6b6Ubw5m6s12gPooUpH3vUTARZeBK5bX1Qolu
         isegeFZJ8mcLHgyNcsTBWK93k8OMWJJnaJKDEpVPYOiOzqDYm6iR0nqfCUdT2WVzNq
         HpqWp5mP0Pji0Yjjn8Wt+qpVt253VpLHmk77P5UA=
Date:   Wed, 22 Dec 2021 13:00:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jimmy Assarsson <jimmyassarsson@gmail.com>
Cc:     Jimmy Assarsson <extja@kvaser.com>, linux-can@vger.kernel.org,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] can: kvaser_usb: get CAN clock frequency from device
Message-ID: <YcMTRYM9J1mjeDh6@kroah.com>
References: <20211222002826.1398761-1-extja@kvaser.com>
 <eaefb340-6677-1fcc-83c2-dacc17360b92@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaefb340-6677-1fcc-83c2-dacc17360b92@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 22, 2021 at 01:37:24AM +0100, Jimmy Assarsson wrote:
> Hi,
> 
> I'm not familiar with the tag conventions used in the stable tree.
> This is a backport of upstream commit fb12797ab1fef480ad8a32a30984844444eeb00d,
> for stable 4.4, 4.9 and 4.14.
> How to properly specify this?

You just did!

Now all queued up, thanks.

greg k-h
