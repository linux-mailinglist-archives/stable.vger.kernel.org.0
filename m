Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491831FAEA0
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgFPKwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbgFPKwP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 06:52:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B8920739;
        Tue, 16 Jun 2020 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592304735;
        bh=3oqgdllrNw5k2soDkBe8vHGZqcHXkFuGZj56MddGDTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qwk8gJCUdEr6c+qTawxWIqHVS/gOZ+S9eFwYVT/x3JKAzvV5vfC9vXLDcGLZ81ANO
         TvEVhwWygSWJOtS3gCKiQON4tQCBJLDURZFikEDR8ADR8lldM8Z3g1WSEmQ6CFTTBi
         NZknh61z0w3S3f4fhoxQbb8tKBBoFFbU5T8wSG5g=
Date:   Tue, 16 Jun 2020 12:52:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     hersenxs.wu@amd.com, alexander.deucher@amd.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/amd/display: disable dcn20 abm
 feature for bring up" failed to apply to 5.7-stable tree
Message-ID: <20200616105210.GC2653240@kroah.com>
References: <15922346929938@kroah.com>
 <20200616004617.GK1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616004617.GK1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 08:46:17PM -0400, Sasha Levin wrote:
> On Mon, Jun 15, 2020 at 05:24:52PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.7-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Greg, I think that your scripts went bananas here :)
> 
> No stable tag, no fixes tag, and it's already in 5.7, 5.6, and 5.4.

Ugh, my fault, ment to send this out for 14ed1c908a7a ("Revert
"drm/amd/display: disable dcn20 abm feature for bring up"")

Will go do that now...

thanks,

greg k-h
