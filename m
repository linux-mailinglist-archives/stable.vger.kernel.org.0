Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D0C2E97CE
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbhADO5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:57:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbhADO5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 09:57:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82590221E5;
        Mon,  4 Jan 2021 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609772185;
        bh=f6C+nbf18LWcQ5y/0LW9mVgHTTgacG4/qJ2lViUGn4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2pTrZkV2wYOIfw0aucykAsQuQ5t00RCVQoTmtLYzv7VZcdU+MZQwi/LzDnUsX3lQf
         pppoGUkcbJoBb4QAYf6YosiJEbiiRIeL4b/pEEIBdsRgvarCYjoNhquFhqnGrIIIfl
         oxYPfOAkxs+0+UlbND+peCsauSmrx/0RW+yP9aso=
Date:   Mon, 4 Jan 2021 15:57:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: iuu_phoenix: fix DMA from stack
Message-ID: <X/Ms7xMPzdgWs8Fx@kroah.com>
References: <20210104145007.28093-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104145007.28093-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 03:50:07PM +0100, Johan Hovold wrote:
> Stack-allocated buffers cannot be used for DMA (on all architectures) so
> allocate the flush command buffer using kmalloc().
> 
> Fixes: 60a8fc017103 ("USB: add iuu_phoenix driver")
> Cc: stable <stable@vger.kernel.org>     # 2.6.25
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
