Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3D30B9D93
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 13:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437785AbfIULVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 07:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437782AbfIULVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 07:21:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C162086A;
        Sat, 21 Sep 2019 11:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569064907;
        bh=0UK+pe7RgNGQknS/IZUQXLVEVW50BOoU4FkbQAcndwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7vbmHaEj5CKvubQEEO1ODpP1UhTP+y0ACRt6DaINiUD+PxRhQ0gTVpoosqzWPEig
         FcvQXSyW7ViKpmJI1EOmLX0MS4lMMyZlGKFlDVofRSuBHSxao90s9pNOSaEGESI7rG
         Ft3lShux+uC9dppl0IJXgIr0BOzFXQyA1EUSR1FY=
Date:   Sat, 21 Sep 2019 13:21:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 0/1] netfilter: bridge: build fix for 5.3
Message-ID: <20190921112145.GA2408749@kroah.com>
References: <20190921110523.15085-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190921110523.15085-1-jeremy@azazel.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 21, 2019 at 12:05:22PM +0100, Jeremy Sowden wrote:
> Adam Borowski reported a build-failure in 5.3 when
> CONFIG_NF_CONNTRACK_BRIDGE is set but CONFIG_NF_TABLES is not.  It was
> introduced into the mainline by:
> 
>   3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> 
> There is also a fix in the mainline:
> 
>   47e640af2e49 ("netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.")
> 
> I've cherry-picked it, and added the "Fixes:", "Reported-by:", "Link:"
> and "Cc:" tags.
> 
> Please consider applying it to 5-3-y.

Now queued up, thanks!

greg k-h
