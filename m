Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC23310A47
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 12:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBELa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 06:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231865AbhBEL1c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 06:27:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 217F564DB2;
        Fri,  5 Feb 2021 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612524410;
        bh=YXsWZs4+oVxRNukl+RAYlFNzzWYjF9MdzAooQHhVKpA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kfAKdx/yY8AwoOZnDWkQ4HEhlqRiUL/y5SbMZGOM9ivEtx3rQuEeIuSoavAXSuNmB
         eI+6NawQuTpO1myaJK3QZuk4FvzykgUBhF/bOiwjxaP1veUZp1ZilN+sCoUG3BwmIt
         9viiq05KFpffmEtZLUyg5FuWJsOK1wmMBNBVVvng=
Date:   Fri, 5 Feb 2021 12:26:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Martin Schiller <ms@dev.tdt.de>,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] net: lapb: Add locking to the lapb
 module" failed to apply to 5.10-stable tree
Message-ID: <YB0rd6IWig/vvM9V@kroah.com>
References: <161245078761138@kroah.com>
 <CAJht_EP5oijCxg-uj9YW8KV+fQESCrTfGZAfq99O2jNGRXWd9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJht_EP5oijCxg-uj9YW8KV+fQESCrTfGZAfq99O2jNGRXWd9Q@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 03:07:02AM -0800, Xie He wrote:
> On Thu, Feb 4, 2021 at 6:59 AM <gregkh@linuxfoundation.org> wrote:
> >
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This patch only fixes a theoretical race condition. I'm not sure the
> race condition is really affecting users. Is it necessary to apply
> this patch to stable branches?

Ok, if this is not affecting anyone, there's no need for a backport,
thanks for letting me know!

greg k-h
