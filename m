Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E771C6B89
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgEFIXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 04:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbgEFIXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 04:23:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8676A206E6;
        Wed,  6 May 2020 08:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588753384;
        bh=7fu/3TQKpRpgi2EDPCXEPyJx+GlgDFduW9zzFY9NNew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0bQm43DSAf6Rqo1TiYqaM9hY0UcrjPDyrFF1jTuKFKRehYHlNmIwhKp5HBbrXpjAe
         GGQTg1HLCzEEk4jVLOqA4/Gy4+BJaD6HMp39rwG2xs7tyxivUiXAsBtLJfhvgfrfp0
         JS5L/BWsNjj7mbUlPHbeFtljzYGrspQ1ycH8ZxGY=
Date:   Wed, 6 May 2020 10:23:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
Subject: Re: [PATCH 4.4 08/16] serial/sunsu: add missing of_node_put()
Message-ID: <20200506082301.GA2492474@kroah.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-9-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-9-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 09:40:06PM +0100, Lee Jones wrote:
> From: Yangtao Li <tiny.windzz@gmail.com>
> 
> [ Upstream commit 20d8e8611eb0596047fd4389be7a7203a883b9bf ]
> 
> of_find_node_by_path() acquires a reference to the node
> returned by it and that reference needs to be dropped by its caller.
> This place is not doing this, so fix it.
> 
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/tty/serial/sunsu.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

What about 4.9.y, 4.14.y, and 4.19.y for this?

greg k-h
