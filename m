Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351861E45F0
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389033AbgE0OcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387732AbgE0OcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 10:32:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293A92084C;
        Wed, 27 May 2020 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590589922;
        bh=anqSJZFvrQGArvjH/LKrfSg/PVPsQ+kEocrkm3XnP7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2uhhEctTmIOv1tn9ojzu4Jxm2cef2z+VtSomvhui9hgNuCc0HgSim1K4aeboYPse/
         ml2Fk5PR+BG+nE+St+/Kkyt28dQfs8MPWOwDvrspEQQEtE2tHHLQw+/GxvE2Xia2Hm
         y+G17BTdASL8uyjhVF+ySTAO6CKxUIV3gujo5S14=
Date:   Wed, 27 May 2020 16:32:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 49/81] powerpc: Remove STRICT_KERNEL_RWX
 incompatibility with RELOCATABLE
Message-ID: <20200527143200.GA497846@kroah.com>
References: <20200526183923.108515292@linuxfoundation.org>
 <20200526183932.664564063@linuxfoundation.org>
 <20200527132831.GA11424@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527132831.GA11424@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 27, 2020 at 03:28:31PM +0200, Pavel Machek wrote:
> On Tue 2020-05-26 20:53:24, Greg Kroah-Hartman wrote:
> > From: Russell Currey <ruscur@russell.cc>
> > 
> > [ Upstream commit c55d7b5e64265fdca45c85b639013e770bde2d0e ]
> > 
> > I have tested this with the Radix MMU and everything seems to work, and
> > the previous patch for Hash seems to fix everything too.
> > STRICT_KERNEL_RWX should still be disabled by default for now.
> > 
> > Please test STRICT_KERNEL_RWX + RELOCATABLE!
> 
> I don't believe this is suitable for -stable. Yes, it is needed for
> the next patch, but doing the merge is right solution this time.

Why?  It's always best to keep things as they are in Linus's tree if at
all possible.

thanks,

greg k-h
