Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7C2E1D4D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgLWOPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgLWOPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 09:15:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA12D2332A;
        Wed, 23 Dec 2020 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608732893;
        bh=KeKKCtSDHpeL7+hJCK6YAm9CcfqALVWKrkRoEA5pMOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=REafBxV9HcMoIYaHUvprcz8oinxhxjOkj/SfbFUSiXV/6+MqD0bop5xZWh96oc9xo
         Gty5AYdUrbmtx5ebq/rM4YPJqqTJ4weO93vfXRJNqtza5ebty+Wx+ftpNolzwgZV8c
         ivGtABCV8A9Hgq+7iDseK9aAJ/w7Lrd2DDUMvhT0=
Date:   Wed, 23 Dec 2020 15:16:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     ebiggers@google.com
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] f2fs: prevent creating duplicate
 encrypted filenames" failed to apply to 4.9-stable tree
Message-ID: <X+NRJJkGcbZDkvhx@kroah.com>
References: <1608732531208141@kroah.com>
 <X+NQalRwl81mfnyV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+NQalRwl81mfnyV@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 03:12:58PM +0100, Greg KH wrote:
> On Wed, Dec 23, 2020 at 03:08:51PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Oops, got these out of order, my fault, let me try this again...

Ok, got it applied to 5.10.y, but nothing else due to the dependant
patch not working anywhere other than that :(

thanks,

greg k-h
