Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAD82E3683
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgL1LeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:34:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgL1LeI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 06:34:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD61229C4;
        Mon, 28 Dec 2020 11:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609155208;
        bh=saKOfYncCd9Ec75dBMzr7MpCe5M2fYvC02vnawyCTDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Um/GuWVlwvn5yoXMQzCrBVsSwn10oXBH8CDNZs/Jt3zbFEO8VwsNlnkPUbVhpndT9
         y7hL0mn5tPln8ULHbkQs12qbg0v6pz2JibwGT7ydVWmywhQmahdGG835i8H7lIKoZK
         IoqXv3t9RFvKsxXadReFOJ5/wpEajfZMZ+PCguAM=
Date:   Mon, 28 Dec 2020 12:29:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     stable@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        doebel@amazon.de, aams@amazon.de, mku@amazon.de, jgross@suse.com,
        julien@xen.org, wipawel@amazon.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Backport of patch series for stable 4.4 branch
Message-ID: <X+nBh/5nsI8QrWCg@kroah.com>
References: <20201217160402.26303-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217160402.26303-1-sjpark@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 05:03:57PM +0100, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> Changes from v2
> (https://lore.kernel.org/stable/20201217130501.12702-1-sjpark@amazon.com/)
> - Move 'nr_pending' increase from 5th patch to 4th patch
> 
> Changes from v1
> (https://lore.kernel.org/stable/20201217081727.8253-1-sjpark@amazon.com/)
> - Remove wrong 'Signed-off-by' lines for 'Author Redacted'

All now queued up, but you also need a series of this for the 4.9.y tree
as well.

thanks,

greg k-h
