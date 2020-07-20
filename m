Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EDC225E3C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgGTMPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728564AbgGTMPe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 08:15:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD6020B1F;
        Mon, 20 Jul 2020 12:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595247333;
        bh=JG8/Ze1juBDB4GBsfoY4AdUSsaGsRqBkeIuY8+rKj8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IlyM2eEJDDnSaO6IdwKYyB1UsgR+Bp3k2QXZ6J3+x8QlkHgqVxVEtyDyH4wn85anJ
         U5Qc+KmbzRUZzsN7w0AYM400hUzHUCsyAPDxw+m65BD7riLv/19m7XZAbul8G+wzNl
         xdq/VnIsMh6Fmft/NKC5OeJATwg0Qjau8KD2OG/c=
Date:   Mon, 20 Jul 2020 14:15:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Upstream fixes not merged in 5.4.y
Message-ID: <20200720121543.GA2984743@kroah.com>
References: <20200629142805.28013-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629142805.28013-1-sjpark@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 04:28:05PM +0200, SeongJae Park wrote:
> Hello,
> 
> 
> With my little script, I found below commits in the mainline tree are more than
> 1 week old and fixing commits that back-ported in v5.4..v5.4.49, but not merged
> in the stable/linux-5.4.y tree.  Are those need to be merged in but missed or
> dealyed?
> 
> 9210c075cef2 ("nvme-pci: avoid race between nvme_reap_pending_cqes() and nvme_poll()")

I tried this first patch, and it doesn't apply to the 5.4.y tree, so are
you sure you tried these yourself?

If so, please send a series of backported patches that you have
successfully tested, or if a patch applies cleanly, just the git id.

thanks,

greg k-h
