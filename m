Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6EB2FEE7D
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 16:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732551AbhAUPYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jan 2021 10:24:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732061AbhAUNZM (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 21 Jan 2021 08:25:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE409206F7;
        Thu, 21 Jan 2021 13:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611235472;
        bh=67q3NGkb3vjATR5SeD8E03IcfjwLslrvpWDW2dD7kH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhSJ6+7jLuyRahXfHSaIRHynBo/LYk4jdNxPLtWTwX8T+YhXgysw7biJ7aFZSecOD
         XGDGNhqu96Inz3k5Ic7uCe+wgul13pD/w6nBEe9YqeV9OdLBRDS6BhUPkG6ZTD1BZQ
         FhIYb3db5V7C+rKSxFjqvKu/MkKwuNkR2sAF2UPY=
Date:   Thu, 21 Jan 2021 14:24:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     nuno.sa@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: buffer: Fix demux update" failed to
 apply to 4.4-stable tree
Message-ID: <YAmAjaW3sSR0MYC0@kroah.com>
References: <1609153940167171@kroah.com>
 <20210120203851.mqmhizwrfonznily@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120203851.mqmhizwrfonznily@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 20, 2021 at 08:38:51PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 12:12:20PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Thanks, now queued up.

greg k-h
