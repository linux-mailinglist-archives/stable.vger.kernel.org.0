Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBBE450488
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhKOMlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:41:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhKOMlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:41:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D0B36137B;
        Mon, 15 Nov 2021 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636979885;
        bh=B/tkajzX9l7NRAH5hi0tU5vDOBLYle0HIhqkBVdYBwk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQX6elP5641z/xn9TMMF4NvOtCspQANj0V4xJ0N+HTJmlEbIDwf3UdL21PNTZ8L+l
         3Z3um+ThIeA3k1J2lhb0kgYBmhtQhgIUKEwJwXT7u9whpmYVcqs9vMj/1l6UnlDJCe
         geiMcykLd1Sl85C981BNlhyoTv0fQZUIqghqwdiE=
Date:   Mon, 15 Nov 2021 13:38:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] parisc: Fix set_fixmap() on PA1.x CPUs
Message-ID: <YZJUqnTS9pVkoiLI@kroah.com>
References: <YZA28xGM65x4H33o@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZA28xGM65x4H33o@ls3530>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 13, 2021 at 11:06:43PM +0100, Helge Deller wrote:
> Upstream commit 6e866a462867b60841202e900f10936a0478608c failed to
> apply to kernel v5.2 up to v5.4.
> Below is the fixed backport patch.
> Please apply to v5.2 up to v5.4.

Now queued up, thanks.

greg k-h
