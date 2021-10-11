Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD984287FF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 09:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhJKHqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 03:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234317AbhJKHqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 03:46:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6886160D07;
        Mon, 11 Oct 2021 07:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633938250;
        bh=/2jixCld421JeIZgahFW86TvyynD5HbG6H2Qr2kRgLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LThG+XiDk2r4yDJGIJdCB7QgXj9XXoyP0rMHP6+casjduhXZ8/9cR3eqqjJ1vEepn
         3OxnhqQS/1RMUh3gOKh2LimAtA28owO9zP7gt3c9eeBH77f8EFjRdmtPD6Wh4pHZZn
         JE6RsPcDsCGj8JFCs2ONBykIe5/jCK2YOv7KrTRQ=
Date:   Mon, 11 Oct 2021 09:44:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Message-ID: <YWPrSHGbno3dODKr@kroah.com>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
> Hello everyone,
> 
> The following new device USB ID has landed in linux-next recently:
> 
> 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> 
> It would be nice if it could be backported to stable. I verified it works on
> 5.14.y as a simple cherry-pick .

A patch needs to be in Linus's tree before we can add it to the stable
releases.  Please let us know when it gets there and we will be glad to
pick it up.

thanks,

greg k-h
