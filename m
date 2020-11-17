Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD6A2B5E94
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgKQLqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:46:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:33238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgKQLqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 06:46:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67969222E8;
        Tue, 17 Nov 2020 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605613608;
        bh=Ab/dVcW1wRF7+2a2h9NCIfnjTV57sgd1sYUWfQQHuLo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CuaO30TEZXrcYNUb4kMe8GaxYGsY56OR8XwH+dhKZrPYTp7oWAibq1B8wD5cXBDlD
         m5ZJfG0gvPAxAWm4FmHe2yumB3K8xKveMs9D34vMwYwHo5E8GDqPxxI8eDvv82kgl1
         Vgoa6yIq3ipmu0UkXd3EkybOn2waaJEKvIwKqrKw=
Date:   Tue, 17 Nov 2020 12:47:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, keescook@chromium.org, linux@roeck-us.net,
        pasha.tatashin@soleen.com, pmladek@suse.com, robinmholt@gmail.com,
        rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] Revert "kernel/reboot.c: convert
 simple_strtoul to kstrtoint"" failed to apply to 4.19-stable tree
Message-ID: <X7O4WDxa/8dagokm@kroah.com>
References: <160554320237238@kroah.com>
 <20201116184211.lq6lxexxsai5jz6q@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116184211.lq6lxexxsai5jz6q@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 06:42:11PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Nov 16, 2020 at 05:13:22PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport. This will apply to v4.19.y, v4.14.y, v4.9.y and
> also v4.4.y.

This, and the follow-on patch, all now queued up, thanks.

greg k-h
