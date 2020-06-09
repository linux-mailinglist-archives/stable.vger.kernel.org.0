Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BA51F33F6
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 08:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgFIGLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 02:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgFIGLB (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 9 Jun 2020 02:11:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F985207F9;
        Tue,  9 Jun 2020 06:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591683059;
        bh=eSdrg62KITEmYVAyDpRd7JoweXylWWBolUzSB9I90/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OW5/v4WNzTyhGPZcn5CTuZPQsvbiaLlsbrrv/6aDUeBT9reUSZy250wKEQUxnE3i5
         9QbgAxqPyNM5a4oR2gMGlU9E0PxBmGBeS3XCQbMolA/yH4lBYLvWlghdwRKRkjV+kd
         IykFQa7UfMdgOE96guFC14NE2DOxt2Q+2QZxMFrk=
Date:   Tue, 9 Jun 2020 08:10:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     m.othacehe@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: vcnl4000: Fix i2c swapped word
 reading." failed to apply to 4.14-stable tree
Message-ID: <20200609061057.GA498890@kroah.com>
References: <1591619056246224@kroah.com>
 <20200608204114.GS1407771@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608204114.GS1407771@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 08, 2020 at 04:41:14PM -0400, Sasha Levin wrote:
> On Mon, Jun 08, 2020 at 02:24:16PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
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
> > > From 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 Mon Sep 17 00:00:00 2001
> > From: Mathieu Othacehe <m.othacehe@gmail.com>
> > Date: Sun, 3 May 2020 11:29:55 +0200
> > Subject: [PATCH] iio: vcnl4000: Fix i2c swapped word reading.
> > 
> > The bytes returned by the i2c reading need to be swapped
> > unconditionally. Otherwise, on be16 platforms, an incorrect value will be
> > returned.
> > 
> > Taking the slow path via next merge window as its been around a while
> > and we have a patch set dependent on this which would be held up.
> > 
> > Fixes: 62a1efb9f868 ("iio: add vcnl4000 combined ALS and proximity sensor")
> > Signed-off-by: Mathieu Othacehe <m.othacehe@gmail.com>
> > Cc: <Stable@vger.kernel.org>
> > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> There were some context conflicts due to renaming of the lock (and it
> not existing on 4.4). I've fixed it and queued for 4.14-4.4.

Thanks, but I think you forgot to push your local version of the queue
to git.kernel.org :(
