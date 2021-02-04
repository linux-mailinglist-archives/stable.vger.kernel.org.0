Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BE730F5E0
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 16:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhBDPLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 10:11:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237140AbhBDPLP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 10:11:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B002664DF2;
        Thu,  4 Feb 2021 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612451422;
        bh=u1IrwZjnJPuDG/ND0nY7TNwqH19xoW6EhwQxRqnOuVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KKK4XFpMr9SVWpI7+fYCeuD0m7nkNGmmSSuY0iApUXPb1zumygAxQBidiVbdcz7Rf
         uBwXwkLKPm0XaWvixEgpF3fsFmWvTPxgJLasEK6uB3iH6pau0wNsk2L73oqlRVGLVJ
         xsdPRBqhQd38MpzZdhxO+A9GfX8bgTlAVNlGKymM=
Date:   Thu, 4 Feb 2021 16:10:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     edumazet@google.com, cong.wang@bytedance.com, kuba@kernel.org,
        syzkaller@googlegroups.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net_sched: reject silly cell_log in
 qdisc_get_rtab()" failed to apply to 4.14-stable tree
Message-ID: <YBwOW17PFRKpKFxe@kroah.com>
References: <161158786343227@kroah.com>
 <YBnfTyUpzZ+MgLbb@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBnfTyUpzZ+MgLbb@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 11:25:03PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 25, 2021 at 04:17:43PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.9-stable and 4.4-stable.

Now applied, thanks.

greg k-h
