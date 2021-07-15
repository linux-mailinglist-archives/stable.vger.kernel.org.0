Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235163C9D6D
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbhGOLIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 07:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232800AbhGOLIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 07:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00377613BA;
        Thu, 15 Jul 2021 11:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626347119;
        bh=qKlD5Cj/W19h5J9sQBXyGpVZp+tcyIMATdhxHcJ4F3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gkyuhZ3c7+W6+tc9YhNmDyz0pNabpEo9dvOlsc8B5MmNEI3aoTkzf+bs2qW/Vl9DQ
         JR8aUkN6D5VyMEJxvmi0S+MXpA4g3ja7MtijOT02vHqzcoZKrCnoQbNyujGfCu+VWq
         nnQ4Xtau9Xw1y86aihRwT1PZc97a5bZWK073w5uA=
Date:   Thu, 15 Jul 2021 13:05:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH for 5.10.y] ath11k: unlock on error path in
 ath11k_mac_op_add_interface()
Message-ID: <YPAWZ80QYvRSmsYa@kroah.com>
References: <20210714090321.3388341-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714090321.3388341-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 06:03:21PM +0900, Nobuhiro Iwamatsu wrote:
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> commit 59ec8e2fa5aaed6afd18d5362dc131aab92406e7 upstream.
> 
> These error paths need to drop the &ar->conf_mutex before returning.
> 
> Fixes: 690ace20ff79 ("ath11k: peer delete synchronization with firmware")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/X85sVGVP/0XvlrEJ@mwanda
> Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
