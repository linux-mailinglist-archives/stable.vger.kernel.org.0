Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36EF2BA539
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgKTIzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbgKTIzy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:55:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B93622256;
        Fri, 20 Nov 2020 08:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605862554;
        bh=mC18zPUCIASC9qaiBc6ANH27U5frpdHstHW/rTu1FKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0HbLbNk4R23aqFL/9ZtdGgotdsgEuFSTmmKyio/O/wWLHxUhhKstW6IZaNYnKpyVY
         kwLbSj54P40gEXkMujhDXFyMuVa2BMCukNUwiAjT1ex5XKOdVYrRdoI5AXdkp/QTeD
         1j58WYJd/Rkch4v2MK/SGk7BztN+RNZACzMt7apk=
Date:   Fri, 20 Nov 2020 09:56:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     bgolaszewski@baylibre.com, andriy.shevchenko@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpio: mockup: fix resource leak in error
 path" failed to apply to 4.14-stable tree
Message-ID: <X7eExLkI0H/Oe7zH@kroah.com>
References: <160180783111955@kroah.com>
 <20201119205839.u7sbd4ytxjivybts@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119205839.u7sbd4ytxjivybts@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 08:58:39PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Sun, Oct 04, 2020 at 12:37:11PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. Please consider for 4.14-stable.

Now queued up, thanks.

greg k-h
