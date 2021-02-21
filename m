Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CEE320A4D
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 13:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhBUMyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 07:54:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhBUMyA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 07:54:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BEFC64F03;
        Sun, 21 Feb 2021 12:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613911999;
        bh=EJSswGSZ83uIxqw6U8TQAMa3eQKED6OQwguzz2TkvEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H2/9nOV2bIsakHW3LmeU9THEEXek/x/gy6mgApgbb+7McIToIdrLxjKkjHQbd8jWi
         zRUjlSziG4nM9XYW4nQS2Bzj4qfhooq1yfqGf+rvdl4sW5DEce8CMvmnsqTFavtNWh
         0YpTmdBySCpjEix8uquInPQ23Nc4xD0gOg/6z5Uw=
Date:   Sun, 21 Feb 2021 13:53:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Trent Piepho <tpiepho@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Please apply commit 517b693351a2 ("Bluetooth: btusb: Always
 fallback to alt 1 for WBS") to back to v5.10.y
Message-ID: <YDJXvYLSUQ3P0iMz@kroah.com>
References: <YDJWEh5qNUQbXcv2@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDJWEh5qNUQbXcv2@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 21, 2021 at 01:46:10PM +0100, Salvatore Bonaccorso wrote:
> Hi
> 
> 517b693351a2 ("Bluetooth: btusb: Always fallback to alt 1 for WBS")
> was applied to mainline fixing (restoring) behaviour to pre 5.7. As
> the commit message describes in effect, WBS was broken for all USB-BT
> adapters that do not support alt 6.
> 
> Can you consider it to apply it to back to 5.10.y?

I do not see any such git commit id in Linus's tree, are you sure you
picked the right one?

greg k-h
