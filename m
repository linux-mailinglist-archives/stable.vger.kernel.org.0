Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52823456FBD
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 14:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhKSNja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 08:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235521AbhKSNj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 08:39:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3ACB61A89;
        Fri, 19 Nov 2021 13:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637328988;
        bh=FxC5xTf3L2/vgPivvTnqw1gxGr84y3S9aA2jRnryu3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v3bsri9W07T/DEVgP0C/p1AT4jyofLWIzU/naHGXFs2LDraBoCaXJoxDyzozaRJSr
         yu846zg9mjRoiHuZ+MD3mljTfMlJjPEh1Sm7OqREQrCY/hUC3kl8+qfKo+bsg/Vgpz
         nVPoS89At8TUmKJr5Ag8fLimWCg6Ip6IsW3VXg7s=
Date:   Fri, 19 Nov 2021 14:36:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Sven Schnelle <svens@stackframe.org>
Subject: Re: [PATCH][stable] parisc/entry: fix trace test in syscall exit path
Message-ID: <YZeoWIY5CuVG7udZ@kroah.com>
References: <YZO0xTfo0ZwzTQs+@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZO0xTfo0ZwzTQs+@ls3530>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 02:40:21PM +0100, Helge Deller wrote:
> Please apply this patch to the stable kernels up to v5.15.
> 
> It's basically upstream commit 3ec18fc7831e7d79e2d536dd1f3bc0d3ba425e8a,
> adjusted so that it applies to the stable kernels.
> 
> It requires that upstream commit 8779e05ba8aaffec1829872ef9774a71f44f6580
> is applied before, which shouldn't be a problem as it was tagged for
> stable series in the original commmit already.

Now queued up, thanks.

greg k-h
