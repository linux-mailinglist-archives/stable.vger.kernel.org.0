Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAD9AB528
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 11:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfIFJxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 05:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbfIFJxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 05:53:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB1A5206CD;
        Fri,  6 Sep 2019 09:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567763631;
        bh=Pi0RvVNnF1dvEG/9kbwpUl+xtcxVMY6sbD/U78ApVTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=todaL+blqDF/N6UroUoQv5Nhj4zHiK6P+yDLDm/WUSmVZXUJAtGJ497rWxAOHAhGT
         WSoWjHdZM6/exF5BAMmwOLi7qe2frosYK7rU47d4xp7eM2cnMSkTzw1ynUK8q/dYmF
         rGeUBrtUbZ9bTlJJbqsvhFjGw1eh5IInTfLwNwJQ=
Date:   Fri, 6 Sep 2019 11:53:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH stable 5.2/4.19] Revert "Input: elantech - enable SMBus
 on new (2018+) systems"
Message-ID: <20190906095347.GC16843@kroah.com>
References: <20190906085345.26279-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906085345.26279-1-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 06, 2019 at 10:53:45AM +0200, Benjamin Tissoires wrote:
> This reverts commit 60956b018bfe23b879405a7d88103d0a8f06a5e3.
> 
> This patch depends on an other series:
> https://patchwork.kernel.org/project/linux-input/list/?series=122327&state=%2A&archive=both
> 
> It was a mistake to backport it in the v5.2 branch, as there
> is a high chance we encounter a touchpad that needs the series
> above.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=204733
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=204771
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---
> 
> Hi,
> 
> this is a stable only patch aimed at kernels v5.2 and v4.19 branches.
> 
> We already have 2 bug reports of a failing touchpad, and I don't think
> it is worth trying to get a smoother touchpad if we randomly
> break a few of them in the way.

Now reverted, I'll push out some new releases with that now so people's
machines get back to a working state.

thanks,

greg k-h
