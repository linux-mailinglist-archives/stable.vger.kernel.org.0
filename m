Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0054192B3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 13:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhI0LF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 07:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233897AbhI0LF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 07:05:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF09061058;
        Mon, 27 Sep 2021 11:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632740628;
        bh=vSYRwndrh3eKEx+7FDEFsnWqqwtbPtSCDm4Bk/Dc2cA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UAu6Ak/kWPEI9BxlR+umrTGDl59369s7rW+/G1ks4je6LDUbn1uGn6v7DOSS/vXBo
         SaOR3AT6c9uzZPMzod5BCB/YkXB0D99drXUim6m1WWipnpg45A4raNMhh2Ib3kLttK
         C5LgGlfANUjmiINjVSHjd1ULNDpB0lDWzIc2uhYk=
Date:   Mon, 27 Sep 2021 13:03:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@linux.alibaba.com>
Cc:     stable@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 4.19.y RESEND] erofs: fix up erofs_lookup tracepoint
Message-ID: <YVGlEkRjA2OfM9mW@kroah.com>
References: <163266167710981@kroah.com>
 <20210927052954.136280-1-hsiangkao@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927052954.136280-1-hsiangkao@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 27, 2021 at 01:29:54PM +0800, Gao Xiang wrote:
> commit 93368aab0efc87288cac65e99c9ed2e0ffc9e7d0 upstream.
> 
> Fix up a misuse that the filename pointer isn't always valid in
> the ring buffer, and we should copy the content instead.
> 
> Link: https://lore.kernel.org/r/20210921143531.81356-1-hsiangkao@linux.alibaba.com
> Fixes: 13f06f48f7bf ("staging: erofs: support tracepoint")
> Cc: stable@vger.kernel.org # 4.19+
> Reviewed-by: Chao Yu <chao@kernel.org>
> [ Gao Xiang: resolve trivial conflicts for 4.19.y. ]
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> ---
> add missing upstream commit id...

Now queued up, thanks.

greg k-h
