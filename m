Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FEC7BD2F
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfGaJax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfGaJax (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:30:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F9A920449;
        Wed, 31 Jul 2019 09:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564565452;
        bh=lSL8iGeInfXr8NLRPR0FK43KE1M/rPiN+13E2P6u5yU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ufo5Tln9D1R5asrSkzQOBYwK+O96ML2SrMsu85z2rU1jq8RRlJfowMNPaSDhubV47
         ClYdEjUaZzp7E0T8794QK6uhc3+ui3e2Eafh1cKsqFg2FzYWSyYIp+3xGkrGCvSEO6
         ysgcPIH59Y5kKz2TkfgG4O7lVuVtHLE4bbig+lC8=
Date:   Wed, 31 Jul 2019 11:30:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: Request vsock and hv_sock patches to be backported for
 linux-5.2.y, linux-4.19.y and linux-4.14.y
Message-ID: <20190731093049.GC18269@kroah.com>
References: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169AD4EB10548EACCED82C2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 06:41:10AM +0000, Dexuan Cui wrote:
> Hi,
> Sunil Muthuswamy <sunilmut@microsoft.com> made some important fixes for
> hv_sock recently. I and Sunil think it would be great to backport the
> fixes to the longterm stable kernels.
> 
> Since hv_sock was firstly introduced in v4.14, we only care about
> v4.14, v4.19 and v5.2.
> 
> For linux-5.2.y (currently it's v5.2.4), only one patch is missing.
> The mainline commit ID is:
>         d5afa82c977e ("vsock: correct removal of socket from the list")
> It can be cleanly cherry-picked from the mainline.
> 
> 
> For linux-4.19.y (currently it's v4.19.62), 3 patches are missing.
> The mainline commit IDs are:
>         cb359b604167 ("hvsock: fix epollout hang from race condition")
>         a9eeb998c28d ("hv_sock: Add support for delayed close")
>         d5afa82c977e ("vsock: correct removal of socket from the list")
> They can be cleanly cherry-picked from the mainline, in the listed order here.
> Note: it looks the first commit (cb359b604167) has been queued.
> 
> 
> For linux-4.14.y (currently it's v4.14.134), 4 patches are missing.
> The mainline commit IDs are:
>         cb359b604167 ("hvsock: fix epollout hang from race condition")
>         3b4477d2dcf2 ("VSOCK: use TCP state constants for sk_state")
>         a9eeb998c28d ("hv_sock: Add support for delayed close")
>         d5afa82c977e ("vsock: correct removal of socket from the list")
> The third patch (a9eeb998c28d) needs small manual adjustments, and please
> use the attached backported patch for it; the other 3 patches can be cleanly
> cherry-picked from the mainline, in the listed order here.
> Note: it looks the first commit (cb359b604167) has been queued.

I have not taken 3b4477d2dcf2 ("VSOCK: use TCP state constants for
sk_state") for 4.14.y as it doesn't look like you really needed it.  Are
you sure you did?

The other ones are now queued up, please let me know if I have messed
anythign up.

thanks,

greg k-h
