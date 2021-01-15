Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AC92F75DB
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbhAOJui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:50:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbhAOJui (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 04:50:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66987235F8;
        Fri, 15 Jan 2021 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610704207;
        bh=1XBn3AfanIIOxpktj4GAHJo5lLzpRwN+ZBAOO7oEs+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x5RPdHBXr9kApcK1GBjOLGH03DsdICUXdYrnzUjcV1JukZG2etutPQNOUl3aShOeI
         OTqWUAqM7ImNcn3og/bPpFv4ZroBtn3m18gPO3nlxysHvbYad3xoW0ml1eA+UqBbKz
         8dVOajtXJXyylVk9QUwXHXgSPJaFGN6GASvFsfi0=
Date:   Fri, 15 Jan 2021 10:50:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     richard@nod.at, chengzhihao1@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ubifs: wbuf: Don't leak kernel memory to
 flash" failed to apply to 4.14-stable tree
Message-ID: <YAFlTX1Kl+/g1np6@kroah.com>
References: <16091478492463@kroah.com>
 <20210113212639.a5ltkvm3dj4zkhk2@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113212639.a5ltkvm3dj4zkhk2@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 09:26:39PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 10:30:49AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will also apply to 4.9-stable and 4.4-stable.

Now applied, thanks.

greg k-h
