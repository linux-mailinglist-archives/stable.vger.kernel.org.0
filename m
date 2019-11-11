Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DBF7734
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKKO6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:58:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbfKKO6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 09:58:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 283D2206BA;
        Mon, 11 Nov 2019 14:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573484319;
        bh=eXaSi9JipYxUwhy9rbxPOJepc8XOLNtb0WXjBjqZh8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XWxoBrU5pQPAuXrMgP9nycHuSF/b8CKwkQE8KrLb92NiRaw5UtoJ/1MJ/PXo9bfkc
         D6D+oTFG65j4bNavPJLsWZsY8dsQIBV5m8y/rlZXcTE5+rfKgFOTH1iCQU1mzoa6U5
         i/EQYp9/8g0GYJyNgCfYH6+DdEMan58M6NXcGilM=
Date:   Mon, 11 Nov 2019 15:58:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     qiangqing.zhang@nxp.com, mkl@pengutronix.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] can: flexcan: disable completely the ECC
 mechanism" failed to apply to 4.14-stable tree
Message-ID: <20191111145837.GA607700@kroah.com>
References: <157345390614177@kroah.com>
 <20191111144401.GF8496@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111144401.GF8496@sasha-vm>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 09:44:01AM -0500, Sasha Levin wrote:
> On Mon, Nov 11, 2019 at 07:31:46AM +0100, gregkh@linuxfoundation.org wrote:
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
> > > From 5e269324db5adb2f5f6ec9a93a9c7b0672932b47 Mon Sep 17 00:00:00 2001
> > From: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Date: Thu, 15 Aug 2019 08:00:26 +0000
> > Subject: [PATCH] can: flexcan: disable completely the ECC mechanism
> > 
> > The ECC (memory error detection and correction) mechanism can be
> > activated or not, controlled by the ECCDIS bit in CAN_MECR. When
> > disabled, updates on indications and reporting registers are stopped.
> > So if want to disable ECC completely, had better assert ECCDIS bit, not
> > just mask the related interrupts.
> > 
> > Fixes: cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
> > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: linux-stable <stable@vger.kernel.org>
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> I've adjusted the patch to work around missing 88462d2a7830 ("can:
> flexcan: Remodel FlexCAN register r/w APIs for big endian FlexCAN
> controllers.") and queued it for 4.14-4.4.

Thanks for this, and fixing up all of the other FAILED: patches as well.

greg k-h
