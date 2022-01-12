Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F07B48CAC4
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 19:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356110AbiALSPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 13:15:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56546 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244244AbiALSPJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 13:15:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE23DB81B35;
        Wed, 12 Jan 2022 18:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4E4C36AEA;
        Wed, 12 Jan 2022 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642011306;
        bh=ZcmAqVFnGEJyQt3jJzPIZLfhI0N8qHZHleql61NckAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jNMUN0LW/tBWl8BgMeq3r3mEVaVoFz1xN+cCmc4SUJqR5ewuZeDY/t7y821OECMlX
         RNFRO4OvWIW4iK2YqysVxG4C00sLVtUg18niyK/K2azOsKYMfcQt4iUXSSspgLWyTV
         wEmXiSvIdtPnoJCIAmBEKtiBcjWWWN8bKpIiIIas=
Date:   Wed, 12 Jan 2022 19:15:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guillaume Morin <guillaume@morinfr.org>
Cc:     linux-raid@vger.kernel.org, stable@vger.kernel.org,
        guoqing.jiang@linux.dev, artur.paszkiewicz@intel.com,
        song@kernel.org
Subject: Re: [PATCH backport for 5.10]: md: revert io stats accounting
Message-ID: <Yd8aqDgZqSapNB52@kroah.com>
References: <Yd3PDbLH4v5Ea682@bender.morinfr.org>
 <Yd3STJyOHVBz8zUo@kroah.com>
 <Yd8PVH8rBepVYXwg@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yd8PVH8rBepVYXwg@bender.morinfr.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 06:26:44PM +0100, Guillaume Morin wrote:
> commit ad3fc798800fb7ca04c1dfc439dba946818048d8 upstream.
> 
> The commit 41d2d848e5c0 ("md: improve io stats accounting") could cause
> double fault problem per the report [1], and also it is not correct to
> change ->bi_end_io if md don't own it, so let's revert it.
> 
> And io stats accounting will be replemented in later commits.
> 
> [1]. https://lore.kernel.org/linux-raid/3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com/T/#t
> 
> Fixes: 41d2d848e5c0 ("md: improve io stats accounting")
> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> Signed-off-by: Song Liu <song@kernel.org>
> [GM: backport to 5.10-stable]
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> ---
>  drivers/md/md.c | 57 +++++++++++--------------------------------------
>  drivers/md/md.h |  1 -
>  2 files changed, 12 insertions(+), 46 deletions(-)

Now queued up, thanks.

greg k-h
