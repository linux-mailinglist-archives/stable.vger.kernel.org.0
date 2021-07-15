Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0286A3C9D6B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241212AbhGOLHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 07:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241176AbhGOLHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 07:07:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BC7613BA;
        Thu, 15 Jul 2021 11:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626347046;
        bh=CtZTxWBhgkfpj48NrkT/qW6992ERI7R/jVxq3j9XRC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OW+Uut5UyBiCKe8zReiC47xuKdCP+DvO6Mld2qsVHrNf088APKcqWk0MjCxkXh9L4
         j4oj5ntEqj5tptncGvhQ08bEgcJEpK5Ryyj9W4OwvnTDKUMggAgFlihbGmzgqLTKY1
         VpW14IBcipVmZ2r3xFi5GbHjPzcsmlhaHIcbks6U=
Date:   Thu, 15 Jul 2021 13:03:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     linux-stable <stable@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ainge Hsu <ainge.hsu@mediatek.com>,
        Eddie Hung <eddie.hung@mediatek.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        Macpaul Lin <macpaul.lin@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        AceLan Kao <acelan.kao@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>
Subject: Re: Fix: Please help to cherry-pick patch "bdi: Do not use freezable
 workqueue" to stable tree
Message-ID: <YPAWHugJQhNMOpYN@kroah.com>
References: <1626323319.18118.17.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626323319.18118.17.camel@mtkswgap22>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 12:28:39PM +0800, Macpaul Lin wrote:
> Dear Greg,
> 
> Our customers have feedback some similar issues as below link on Android
> kernel-4.14 and kernel-4.19.
>   Link: https://marc.info/?l=linux-kernel&m=138695698516487
> 
> They've reported system become abnormal when OTG U-disk has been plugged
> out after the system has been suspended.
> After debugging, we've found the root cause is the same of the issue
> (link) has been reported. We've also tested the patch "bdi: Do not use
> freezable workqueue" is worked.
>   Link: https://lkml.org/lkml/2019/10/4/176
>   commit id in Linus tree: a2b90f11217790ec0964ba9c93a4abb369758c26
> 
> However, we've checked that patch seems hasn't been applied to stable
> tree (We've checked 4.14 and 4.19). Would you please help to cherry-pick
> this patch to stable trees (and to Android trees)?

Now queued up to the stable kernel trees.  If you need something in
Android kernel trees, please contact google or submit a patch to AOSP
for the needed branches.

thanks,

greg k-h
