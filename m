Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECFE44646E
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhKENvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhKENvf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 09:51:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62BC06023B;
        Fri,  5 Nov 2021 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636120135;
        bh=83ngMd380uIBIlavC69ALdRUZzxEX39dP7+7zOUMsCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xZLxCDdQqHNYrrYTnMrpXk4WR5A5jyHpmWnWbm9/Bj/A/A4RRMUtRuM8Y/noJfZay
         zslcRJ2jebsgedTVf5sagJ+w/aGyuByqzKPjtP+wb3hllK6d16e/xFwOs7QRazyKTe
         3AEP+WQJwn/fb4dHpiC9+7oYzChzgEtTO9MTIw6k=
Date:   Fri, 5 Nov 2021 14:48:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v4.4.y and v4.9.y] net: hso: register netdev later to avoid a
 race condition
Message-ID: <YYU2RbxKV399oROI@kroah.com>
References: <YYU1KqvnZLyPbFcb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYU1KqvnZLyPbFcb@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 05, 2021 at 01:44:10PM +0000, Lee Jones wrote:
> Stable Maintainers,
> 
> Please consider this patch for back-porting to v4.4y and v4.9.y
> 
>   4c761daf8bb9a ("net: hso: register netdev later to avoid a race condition")
> 
> It should apply cleanly to both branches.

Now queued up, thanks.

greg k-h
