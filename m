Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230C94606F6
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 15:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhK1OmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 09:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236781AbhK1OkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 09:40:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A0EC061758
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 06:36:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DBDA60FE7
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD32C004E1;
        Sun, 28 Nov 2021 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638110174;
        bh=rRBiLH5p4d4ZrYPzXKV5K3I05Sw2TUyft07BcPDDaWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXcnLk5OnaUGuZDjSXXdFAs9gkT82oHyxxdHgnNSBPagYwW3RnFCboG7LfK4l7vhj
         KQ2RxXCNzi7gXD3hlx7e28WjOhdbtbxSgBYIWVjlFs3qQIu0XwWiVShBGTKh9ASeX2
         1hhsM0nm6P+v1NW3R2GU4jcSM7hT9v2Go/53+fh8=
Date:   Sun, 28 Nov 2021 15:36:10 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/20] Armada 3720 PCIe fixes for 4.19
Message-ID: <YaOT2nU+W1pnqtWj@kroah.com>
References: <20211124230500.27109-1-kabel@kernel.org>
 <YaOPUSNrPwAxlZyj@kroah.com>
 <20211128142243.n6enuk6jeicyfoyu@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211128142243.n6enuk6jeicyfoyu@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 03:22:43PM +0100, Pali Rohár wrote:
> On Sunday 28 November 2021 15:16:49 Greg Kroah-Hartman wrote:
> > On Thu, Nov 25, 2021 at 12:04:40AM +0100, Marek Behún wrote:
> > > Hello Greg, Sasha,
> > > 
> > > this series for 4.19-stable backports all the fixes (and their
> > > dependencies) for Armada 3720 PCIe driver.
> > > These include:
> > > - fixes (and their dependencies) for pci-aardvark controller
> > > - fixes (and their dependencies) for pinctrl-armada-37xx driver
> > > - device-tree fixes
> > > 
> > > Basically all fixes from upstream are taken, excluding those
> > > that need fix the emulated bridge, since that was introduced
> > > after 4.19. (Should we backport it? It concerns only mvebu and
> > > aardvark controllers...)
> > 
> > Does anyone care for these old kernels?  I doubt it.
> 
> Debian oldstable is using 4.19 kernel.

Yes, for older hardware and systems.  If this hardware never worked on
that kernel, you shouldn't be using old distros on it.

> OpenWRT is using 4.14 kernel and only recently there was a new release
> where is 5.4 kernel.

They are getting closer to a modern kernel release, nice :)

thanks,

greg k-h
