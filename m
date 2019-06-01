Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923CA31FF4
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 18:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbfFAQUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 12:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfFAQUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 12:20:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A256B27753;
        Sat,  1 Jun 2019 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559406036;
        bh=nKe8XKOVM5oAWjQWs73h5gY//PZ5JoisK7aclAP9fL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZHp1glx3ON5yINQU+hCJ6dIP1rq7wpCsbYs1VmbQnlHfNOMaaFs+XKGpjdIHHjjC
         Ov/Lp1qesJlmwiSeGdxjcWxt+lrJ7KYwm5vvSwdzdB67A7kNxdo6Wo4gdNmrDqj+dm
         OuwBDTo2egTzWOx7AD0NXd7SNmnaTzxo7llEQ6cY=
Date:   Sat, 1 Jun 2019 09:19:29 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kangjie Lu <kjlu@umn.edu>, Aditya Pakki <pakki001@umn.edu>,
        Finn Thain <fthain@telegraphics.com.au>,
        Rob Herring <robh@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.4 44/56] video: imsttfb: fix potential NULL
 pointer dereferences
Message-ID: <20190601161929.GA5028@kroah.com>
References: <20190601132600.27427-1-sashal@kernel.org>
 <20190601132600.27427-44-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601132600.27427-44-sashal@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 01, 2019 at 09:25:48AM -0400, Sasha Levin wrote:
> From: Kangjie Lu <kjlu@umn.edu>
> 
> [ Upstream commit 1d84353d205a953e2381044953b7fa31c8c9702d ]
> 
> In case ioremap fails, the fix releases resources and returns
> -ENOMEM to avoid NULL pointer dereferences.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> Cc: Aditya Pakki <pakki001@umn.edu>
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [b.zolnierkie: minor patch summary fixup]
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/video/fbdev/imsttfb.c | 5 +++++
>  1 file changed, 5 insertions(+)

Why only 4.4.y?  Shouldn't this be queued up for everything or none?

thanks,

greg k-h
