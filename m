Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D7E2DEECD
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 13:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgLSMkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:40:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgLSMkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:40:40 -0500
Date:   Sat, 19 Dec 2020 13:41:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608381599;
        bh=A9yC0wE2Xa4Rbw1o/0Pnwyi9P3bpi6upbV9LMTnMfrs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKLmEv4sMR4NF+LkuX9K7OWhajAYnjASaHaDgYXGfu9MqS4GhCelTiZesH0LM9sAJ
         +MTUC8++1gnBu+8tnUpVmevQQ5UJXTLfHQLjBkjdiVuWkDpMdnGzYsEvsZCAzsMdnF
         wuDuXzhGNgCBwQFu4LRVF23VPHwPUIE8gUcQaS2s=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     oleksandr_andrushchenko@epam.com, dan.carpenter@oracle.com,
        jgross@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/xen-front: Fix misused IS_ERR_OR_NULL
 checks" failed to apply to 4.19-stable tree
Message-ID: <X9307xbxxgszr2U4@kroah.com>
References: <1597669476206215@kroah.com>
 <20201216122329.r3656l5cx3n4aam3@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216122329.r3656l5cx3n4aam3@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 16, 2020 at 12:23:29PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Aug 17, 2020 at 03:04:36PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

Thanks!
