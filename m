Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70192356CA1
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 14:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbhDGMvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 08:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352436AbhDGMvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 08:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E50D761279;
        Wed,  7 Apr 2021 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617799857;
        bh=+xgTyeHX2g7WM+VExjEg53lxrjvf4HVnJKmAKXV2P/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NuNLDOEVsGkXQUl2i4u1+AjOwHjWiePrFfr78XcqxJr1NQpSos3cTCxoWbhUMeovd
         1BUDHVMqJ2hpHQG4y/uwrBtjjdKSMiWQKCzRfBD3nRi+dbL0+Ge2OLb1cmJcouXIy/
         KXVV7zwv/RQtlcLqUtS9ldgQm1tME4G/8uyVpHbY=
Date:   Wed, 7 Apr 2021 14:50:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5.10 1/8] driver core: add a min_align_mask field to
 struct  device_dma_parameters
Message-ID: <YG2qruv25jVq+Fe9@kroah.com>
References: <20210405210230.1707074-1-jxgao@google.com>
 <20210405210230.1707074-2-jxgao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405210230.1707074-2-jxgao@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 09:02:23PM +0000, Jianxiong Gao wrote:
> 'commit 36950f2da1ea ("driver core: add a min_align_mask field to struct device_dma_parameters")'

Odd first line, can you at least try to use the normal format we use for
stable kernels?

> Some devices rely on the address offset in a page to function
> correctly (NVMe driver as an example). These devices may use
> a different page size than the Linux kernel. The address offset
> has to be preserved upon mapping, and in order to do so, we
> need to record the page_offset_mask first.
> 
> Signed-off-by: Jianxiong Gao <jxgao@google.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

What happened to all the other signed-off-by lines?

And yours should go last, right?

This series needs work :(

thanks,

greg k-h
