Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE8125C9F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 09:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfLSI3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 03:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfLSI3K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 03:29:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E3322465E;
        Thu, 19 Dec 2019 08:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576744150;
        bh=FHAw2F6otFOfhuylqH3eZwBpm08rUgKWmCKSRh9H3FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L69b6pzurV905EjBe2QcjpPzvdVELSmP6iQtOMgjWay/YbswvOUnaZYlYZ83dzSHp
         s2uVy+IU4h8mu2xmc3uAQbRjcWtdRwuT8RPyLLdSwzLlTqyl0gXu14UmO5RYhYaeFA
         ftGi44kK4fFSbQQMwLUvCYeq8NZ3TRATQYRxCDJY=
Date:   Thu, 19 Dec 2019 09:29:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Lee, Chiasheng" <chiasheng.lee@intel.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        "Lee, Hou-hsun" <hou-hsun.lee@intel.com>,
        "Pan, Harry" <harry.pan@intel.com>
Subject: Re: Please apply commit 057d476fff778f1 ("xhci: fix USB3 device
 initiated resume race with roothub autosuspend") to v4.4.y and v4.14.y
Message-ID: <20191219082900.GA1015381@kroah.com>
References: <DBAD849DB12B1B48BA1A6C7335FD47B540A2A63E@PGSMSX108.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DBAD849DB12B1B48BA1A6C7335FD47B540A2A63E@PGSMSX108.gar.corp.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 08:20:12AM +0000, Lee, Chiasheng wrote:
> Hi,
> 
> Commit 057d476fff778f1 ("xhci: fix USB3 device initiated resume race with roothub autosuspend")
> fixes race conditions when we're dealing with a USB3 modem using v4.4 and USB3 hubs using 4.14.
> Kindly apply the patch to v4.4.y and v4.14.y.

Why not 4.9.y and 4.19.y?  You can not just skip stable kernel trees,
otherwise people upgrading will have a regression.

Anyway, the reason I did not backport the patch to older kernels is that
it does not apply at all.  If you have already done the backport (and I
am guessing you have as otherwise how would you have tested this),
please provide it to us so that we can apply it to all trees.

thanks,

greg k-h
