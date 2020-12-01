Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29E92C9970
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgLAI2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgLAI2s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:28:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4464020659;
        Tue,  1 Dec 2020 08:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606811287;
        bh=ybSwY65Euxd9eeIi/BhBMSZtSfVM97hsQZ1ax4gLaU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O5qzH5ph28yeXIwpdq4TpdoSJ7Cmm63jiwgHrB3QwbD/n6QfIypMCcEW6RG8yT+KS
         8koA30K6iKPYvLl5/9FDt0/cYCuNefyoZXQHwU8Ku3WsrUP9MQKNR+bRJsBSHsMEP/
         T7BcyD4lBWam5ae6Zg0KEVi8WNnSBofFDa+fr8xY=
Date:   Tue, 1 Dec 2020 09:29:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mirq-linux@rere.qmqm.pl, a.fatoum@pengutronix.de,
        broonie@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] regulator: workaround self-referent
 regulators" failed to apply to 4.9-stable tree
Message-ID: <X8X+4MXqRzI4l8WB@kroah.com>
References: <160612321754170@kroah.com>
 <20201130173454.7wknj2obm23f4an7@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130173454.7wknj2obm23f4an7@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 05:34:54PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Nov 23, 2020 at 10:20:17AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. It needs to be applied after the backport of
> 4b639e254d3d ("regulator: avoid resolve_supply() infinite recursion")
> which is in the separate 'failed' mail.

Both now queued up, thanks!
