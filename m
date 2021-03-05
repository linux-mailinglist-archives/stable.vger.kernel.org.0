Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3771F32E67F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCEKeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:34:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhCEKd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 05:33:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11EBB64FD2;
        Fri,  5 Mar 2021 10:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614940438;
        bh=CKeGZdY/7/4g0d7xQynfHJJU1PZfOgO7mYX6EfqA/Lc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TqMM+u/qmP+OLB18JZWNPJ1xyLKrFSu3eqqyyNwnyzKdUUh/LG07rJJlg1zU+7yfI
         RckARw1EvOFAIPOAsv90x4SOJ8TXaACle9i21gC9hE1t3yWUCs6ei/T/Wq501NxUII
         k5YjPyM6FJ/7kHdd9PQKVcMy21gx1NBMcDXav7ys=
Date:   Fri, 5 Mar 2021 11:33:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     arnd@arndb.de, arnd@kernel.org, hverkuil-cisco@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab+huawei@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] media: v4l: ioctl: Fix memory leak in
 video_usercopy" failed to apply to 4.4-stable tree
Message-ID: <YEIJE1trsGQzpZ1S@kroah.com>
References: <1614597440191109@kroah.com>
 <20210305101329.GP3@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305101329.GP3@paasikivi.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 12:13:29PM +0200, Sakari Ailus wrote:
> Hi Greg,
> 
> On Mon, Mar 01, 2021 at 12:17:20PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I've manually backported patches for the stable trees as there have been
> changes in the upstream between the stable trees and the fix. Small changes
> were also needed between different stable kernels.

Thanks for these, all now queued up.

greg k-h
