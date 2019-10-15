Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B29D6F7F
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 08:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfJOGSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 02:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfJOGSM (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 15 Oct 2019 02:18:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D947217F9;
        Tue, 15 Oct 2019 06:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571120291;
        bh=LRXtpotUCjD0bsBU7ky792piziqgTm0PoP0rsrdtyuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rw7qKhHMxbLAIFV+7k3U/WelGz/f1a8LcOynw5BE9uaiveSqxqNPJU7za7p/IVjJA
         CLP4P9Gy2W8DwbdnBCcYo5gkInWT+ISDK3mvyJOCcPT+mqb8FQo4mPpIC3VyENGp4I
         vZDRbypi5Amx8LrjAZerJ7gvaJijfruKCtE6NGsc=
Date:   Tue, 15 Oct 2019 08:18:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     m.felsch@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: light: fix vcnl4000 devicetree
 hooks" failed to apply to 5.3-stable tree
Message-ID: <20191015061809.GA926806@kroah.com>
References: <1571069502139213@kroah.com>
 <20191015030419.GJ31224@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015030419.GJ31224@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 11:04:19PM -0400, Sasha Levin wrote:
> On Mon, Oct 14, 2019 at 06:11:42PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.3-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 1436a78c63495dd94c8d4f84a76d78d5317d481b Mon Sep 17 00:00:00 2001
> > From: Marco Felsch <m.felsch@pengutronix.de>
> > Date: Tue, 17 Sep 2019 16:56:36 +0200
> > Subject: [PATCH] iio: light: fix vcnl4000 devicetree hooks
> > 
> > Since commit ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
> > the of_match_table is supported but the data shouldn't be a string.
> > Instead it shall be one of 'enum vcnl4000_device_ids'. Also the matching
> > logic for the vcnl4020 was wrong. Since the data retrieve mechanism is
> > still based on the i2c_device_id no failures did appeared till now.
> > 
> > Fixes: ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> Greg, I'm not sure why you dropped this one?
> 
> I've queued it up for 5.3.

It doesn't apply to my 5.3 tree, and now that you added it, it still
doesn't apply :(

So I'm going to drop it now.  How did this apply on your side?

thanks,

greg k-h
