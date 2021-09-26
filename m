Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595694188AE
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhIZMlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhIZMlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40AA660FC2;
        Sun, 26 Sep 2021 12:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660013;
        bh=iVJvMd8xDHJe/3+lFc1StACXW6bhjD+RfR8groJ03gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=czIVV4eY6ydLoDOUsjt3ghCS3vrt4gPEhacE7TjBjW67QMAMES4z3rtAqeYkwmzfx
         BN6G6OVeZHQ0s0wAf0wHX6Fnt5heyxrbqWBmwRQdRq8JiFWLPiUwMaWD3bsEUnoHu4
         iWDVy7RxHmz9fd+dnUVN1F7C15tm27YnFS+dgUro=
Date:   Sun, 26 Sep 2021 14:40:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Rui Miguel Silva <rui.silva@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/3] usb: isp1760: do not sleep in field register poll
Message-ID: <YVBqK5B59EhUy3+5@kroah.com>
References: <20210727100516.4190681-1-rui.silva@linaro.org>
 <20210727100516.4190681-3-rui.silva@linaro.org>
 <CEI85GUCGPFO.2GIJLZMWZCXBJ@arch-thunder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEI85GUCGPFO.2GIJLZMWZCXBJ@arch-thunder>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 24, 2021 at 04:35:40PM +0100, Rui Miguel Silva wrote:
> Hi Greg,
> forgot to ask you, can you please merge this one to stable #5.14.y?
> At the time I was not sure if it was getting in final 5.14 or not.
> 
> It applies clean on top of 5.14.7.
> And without it, it triggers BUG sleep in atomic checks.
> 
> upstream commit:
> 41f673183862a1 usb: isp1760: do not sleep in field register poll
> https://lore.kernel.org/r/20210727100516.4190681-3-rui.silva@linaro.org
> 
> fixes tag:
> Fixes: 1da9e1c06873 ("usb: isp1760: move to regmap for register access")
> 
> Thanks in advance,

Now queued up, thanks.

greg k-h
