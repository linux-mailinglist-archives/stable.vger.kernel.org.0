Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAD23C9D7F
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241748AbhGOLLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 07:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241741AbhGOLLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 07:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FEA36102A;
        Thu, 15 Jul 2021 11:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626347339;
        bh=97tQ82stKIGgJ6MysjKX1RP+sVG2DpS8tN+B0xlewBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EpVApzVT+H9KfPbRmV4jP6JZQQJLv+mTKjicRVZa17Nc8Nk65Bfmt9OesI6v53Bkx
         0ZoebGwbNkw4rVuWE86JNNlolG1KphUDybwmeGTQVpeKQac9XZCW/hAZxhIGl6hds5
         Q9LLi6ZxWu0EY4nRYoFNq091mWceEhf4QTZmT9OM=
Date:   Thu, 15 Jul 2021 13:08:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, bp@alien8.de,
        david@redhat.com, robert.shteynfeld@gmail.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc: fix memory map
 initialization for descending" failed to apply to 5.10-stable tree
Message-ID: <YPAXOsQDvz3A+vKL@kroah.com>
References: <162600462725547@kroah.com>
 <YOr4DMQITU8yzBNT@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOr4DMQITU8yzBNT@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 11, 2021 at 04:54:20PM +0300, Mike Rapoport wrote:
> Hi Greg,
> 
> On Sun, Jul 11, 2021 at 01:57:07PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.10-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> The version below applies to v5.10.49.

Thanks, now queued up.

greg k-h
