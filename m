Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E592F05FA
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 09:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbhAJIdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 03:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbhAJIdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 03:33:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9672D22273;
        Sun, 10 Jan 2021 08:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610267554;
        bh=jBOMBbrY8ejC7e+1+GDTy1/aQY2hSrvpdZYSjkPw/QM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Po/iyCtsXWMi0rag0UBrCjRhfDTpm6aVF+VtIidWI8HaZp02lfbr8xW6H7zgpvCH0
         pwy5FVyUMJ4KMuO4gOPMlsy1KRg6a2PQXok50o3yFrdeevGhuG+knKriybE7FytU1f
         hZm2VN/nPaBHOkCRgs85ouLdG96G4jCbibDaz+Jk=
Date:   Sun, 10 Jan 2021 09:32:30 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        Michael Walle <michael@walle.cc>, kernel-team@android.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] driver core: Fix device link device name collision
Message-ID: <X/q7nhF8E++ASg5Y@kroah.com>
References: <20210109224506.1254201-1-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109224506.1254201-1-saravanak@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 02:45:06PM -0800, Saravana Kannan wrote:
> The device link device's name was of the form:
> <supplier-dev-name>--<consumer-dev-name>
> 
> This can cause name collision as reported here [1] as device names are
> not globally unique. Since device names have to be unique within the
> bus/class, add the bus/class name as a prefix to the device names used to
> construct the device link device name.
> 
> So the devuce link device's name will be of the form:
> <supplier-bus-name>:<supplier-dev-name>--<consumer-bus-name>:<consumer-dev-name>
> 
> [1] - https://lore.kernel.org/lkml/20201229033440.32142-1-michael@walle.cc/
> 
> Cc: stable@vger.kernel.org
> Fixes: 287905e68dd2 ("driver core: Expose device link details in sysfs")
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  Documentation/ABI/testing/sysfs-class-devlink |  4 +--
>  .../ABI/testing/sysfs-devices-consumer        |  5 ++--
>  .../ABI/testing/sysfs-devices-supplier        |  5 ++--
>  drivers/base/core.c                           | 27 ++++++++++---------
>  include/linux/device.h                        | 12 +++++++++
>  5 files changed, 35 insertions(+), 18 deletions(-)
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
