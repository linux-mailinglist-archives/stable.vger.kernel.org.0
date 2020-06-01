Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663251EA7F1
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgFAQrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 12:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgFAQrC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 12:47:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3971520663;
        Mon,  1 Jun 2020 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591030021;
        bh=OmZS0q6ai/19xPePlhpmNJv2tcaYZ8gwlTeuYc0ffk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SSznFSPfdaR3E5eB93eS/bUDKY5yQ5HSa482yObUTxCakvQ0dY9gHaFYaXnFoOZhn
         yowRGYlBVenzScyIFVHTS84R9CHPuDo1BCaF4/p54JRi57M5xxGkPIpdUqyAYBBlpG
         MMgYrFGRSXmOY3QkxG/yaHgRZG9pzIWok68kO5kM=
Date:   Mon, 1 Jun 2020 18:46:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     chenxb_99091@126.com
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Stable backport request for linux-4.4.y
Message-ID: <20200601164659.GA1037203@kroah.com>
References: <1590899395-26674-1-git-send-email-chenxb_99091@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590899395-26674-1-git-send-email-chenxb_99091@126.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 31, 2020 at 12:29:55PM +0800, chenxb_99091@126.com wrote:
> From: Xuebing Chen <chenxb_99091@126.com>
> 
> In linux-4.4.y,the <include/drm/drm_crtc.h> provides drm_for_each_plane_mask macro 
> and plane_mask is defined as bitmask of plane indices, such as
> 1 << drm_plane_index(plane). There is an error setting of plane_mask
> in pan_display_atomic() function.
> 
> Please backport the following patch to the 4.4.y kernel stable tree:
> commit 7118fd9bd975a9f3093239d4c0f4e15356b57fab 
> ("drm/fb-helper: Use proper plane mask for fb cleanup")
> The above patch fixes error setting of plane_mask in pan_display_atomic() function.
>     
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Xuebing Chen <chenxb_99091@126.com>
> 
> 
> 
> 
> 
> 
> 
> 
> 

Now queued up, thanks.

greg k-h
