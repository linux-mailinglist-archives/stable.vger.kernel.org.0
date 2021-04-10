Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA70135ACD2
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDJLNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 07:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234180AbhDJLNL (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sat, 10 Apr 2021 07:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5723061056;
        Sat, 10 Apr 2021 11:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618053176;
        bh=HqTrZVvMqiracjVENFkLBpjDZ+mc556fgFHvGVCxY2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zS/RVudG/zUyBRepP5o+auUBZZnQ7ecrR6gms/HwQMzUxd947W+XJpjcnFQINqu1/
         P2a5scboqHI513x71+hLCMxmUXRBdhhVWr0qbfQ1GC2hafTFlX+XsNtEWzu4T+dKc4
         44XjBbdcp1U9RnKQf1dUdvOnMBxnG5pP4jZmXhAo=
Date:   Sat, 10 Apr 2021 13:12:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     xiang.ye@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: hid-sensor-prox: Fix scale not
 correct issue" failed to apply to 4.9-stable tree
Message-ID: <YHGINo6e2TDW7eWq@kroah.com>
References: <16164044805955@kroah.com>
 <YGyDZ/jeAXqypWSa@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGyDZ/jeAXqypWSa@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 04:51:03PM +0100, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Mar 22, 2021 at 10:14:40AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.4-stable.

Thanks, now queued up.

greg k-h
