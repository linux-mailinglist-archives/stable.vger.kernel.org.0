Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3191156AC6
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgBIN5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbgBIN5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 08:57:22 -0500
Received: from localhost (unknown [38.98.37.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD96B206D6;
        Sun,  9 Feb 2020 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581256641;
        bh=w4HTIRR+0HebeqAR2iuPnF48JAptlbap+qhoeKhCzsY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZw5i2hZbCVZVRQbFhzsrgQfSUYSqWxeUjlv8W1KkGcIkcDQ1Z/DQSGzUFOQraqR9
         OF2WI5Mn8PLY40TIdeiAn/zM7aS9WwFwVpQpdkb+LMewHgyRT/rNWUEeDBPDvZdMJO
         B7bfa7bJVIy2ZBumpq3Wt7oHRR6+x9tcGDwOU26g=
Date:   Sun, 9 Feb 2020 14:26:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     josef@toxicpanda.com, dsterba@suse.com, martin@lichtvoll.de,
        wqu@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: do not zero f_bavail if we have
 available space" failed to apply to 5.5-stable tree
Message-ID: <20200209132640.GA2059551@kroah.com>
References: <158124801131151@kroah.com>
 <45d4c547-7e27-3c59-e2f7-19f4e7b3548c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45d4c547-7e27-3c59-e2f7-19f4e7b3548c@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 02:04:21PM +0100, Jiri Slaby wrote:
> On 09. 02. 20, 12:33, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.5-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 Mon Sep 17 00:00:00 2001
> > From: Josef Bacik <josef@toxicpanda.com>
> > Date: Fri, 31 Jan 2020 09:31:05 -0500
> > Subject: [PATCH] btrfs: do not zero f_bavail if we have available space
> 
> 5.5.2 was already released with this patch:
> commit 165387a9c90152f35976d82feca6eff5f0d5ac02
> Author: Josef Bacik <josef@toxicpanda.com>
> Date:   Fri Jan 31 09:31:05 2020 -0500
> 
>     btrfs: do not zero f_bavail if we have available space
> 
>     commit d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6 upstream.
> 
> It cannot be applied twice :).

Oops, Sasha beat me too it, sorry for the noise :)

greg k-h
