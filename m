Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A18D79DB
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbfJOPdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 11:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732659AbfJOPdZ (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 15 Oct 2019 11:33:25 -0400
Received: from localhost (unknown [38.98.37.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61FEF20640;
        Tue, 15 Oct 2019 15:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571153604;
        bh=4dnPslFyjeUFQvgpLb/NEyp7dQx9oO51cNEGVquuM9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xz6PzjwcqDFsOwT40e8exJMZnbtDHcqGqWCzUgHGqgVgaPeARVM3zApQgJpWOrI5+
         cSp0LGX/esWX7OodJu8teERm6sGy/wup+Btq/EUaT+QzXeTrLykj/WAP5JlBfILaFd
         4giOFDPHRYnqBAMNJXqiAca7FXgwENrpVg46yF34=
Date:   Tue, 15 Oct 2019 17:33:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     m.felsch@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: light: fix vcnl4000 devicetree
 hooks" failed to apply to 5.3-stable tree
Message-ID: <20191015153304.GA1002701@kroah.com>
References: <1571069502139213@kroah.com>
 <20191015030419.GJ31224@sasha-vm>
 <20191015061809.GA926806@kroah.com>
 <20191015141931.GO31224@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015141931.GO31224@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 10:19:31AM -0400, Sasha Levin wrote:
> On Tue, Oct 15, 2019 at 08:18:09AM +0200, Greg KH wrote:
> > On Mon, Oct 14, 2019 at 11:04:19PM -0400, Sasha Levin wrote:
> > > On Mon, Oct 14, 2019 at 06:11:42PM +0200, gregkh@linuxfoundation.org wrote:
> > > >
> > > > The patch below does not apply to the 5.3-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > ------------------ original commit in Linus's tree ------------------
> > > >
> > > > > From 1436a78c63495dd94c8d4f84a76d78d5317d481b Mon Sep 17 00:00:00 2001
> > > > From: Marco Felsch <m.felsch@pengutronix.de>
> > > > Date: Tue, 17 Sep 2019 16:56:36 +0200
> > > > Subject: [PATCH] iio: light: fix vcnl4000 devicetree hooks
> > > >
> > > > Since commit ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
> > > > the of_match_table is supported but the data shouldn't be a string.
> > > > Instead it shall be one of 'enum vcnl4000_device_ids'. Also the matching
> > > > logic for the vcnl4020 was wrong. Since the data retrieve mechanism is
> > > > still based on the i2c_device_id no failures did appeared till now.
> > > >
> > > > Fixes: ebd457d55911 ("iio: light: vcnl4000 add devicetree hooks")
> > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
> > > > Cc: <Stable@vger.kernel.org>
> > > > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > 
> > > Greg, I'm not sure why you dropped this one?
> > > 
> > > I've queued it up for 5.3.
> > 
> > It doesn't apply to my 5.3 tree, and now that you added it, it still
> > doesn't apply :(
> > 
> > So I'm going to drop it now.  How did this apply on your side?
> 
> I... uh... it just applies?
> 
> $ git cherry-pick 1436a78c63495dd94c8d4f84a76d78d5317d481b
> [queue-5.3 5f3196259cbe2] iio: light: fix vcnl4000 devicetree hooks
> Author: Marco Felsch <m.felsch@pengutronix.de>
> Date: Tue Sep 17 16:56:36 2019 +0200
> 1 file changed, 5 insertions(+), 5 deletions(-)
> 
> what do you see as the conflict? line numbers look mostly the same, so
> as the context.

It's conflicting with another patch already in the queue, try applying
it now and see what happens :)

greg k-h
