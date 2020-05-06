Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF65A1C707B
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgEFMkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 08:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgEFMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 08:40:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAD0A20575;
        Wed,  6 May 2020 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588768811;
        bh=G8gEuKlmBJzmbGHfhHOwkTY6nPR6n5yQBwj0gdb/2Iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=06equwvAeTLPGduSJVmUZ9Ay2JaX/WDEV0K5r1qQuOqPGdLd3F30bOqe62ICZWWye
         HUnvM9pU5FtqDYWqnjEzaWVgcGOSQokW8hXdoKbx3dkJDeFU3kllwPPtb1z4kEWwJ+
         /2PtXrRsgbTRI3JlavitBeZxuG7l6KLRfcNvtX+Y=
Date:   Wed, 6 May 2020 14:40:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: Please apply commit dead1c845dbe ("powerpc/pci/of: Parse
 unassigned resources") to v4.19.y and older
Message-ID: <20200506124008.GA3135345@kroah.com>
References: <27f9b53a-d24f-538b-d7cb-f2d79e096ba7@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27f9b53a-d24f-538b-d7cb-f2d79e096ba7@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 06:06:22PM -0700, Guenter Roeck wrote:
> Hi,
> 
> please consider applying commit dead1c845dbe ("powerpc/pci/of: Parse unassigned resources")
> to v4.19.y and older stable branches.
> 
> When testing qemu v5.0 in my build system, I noticed that I can no longer boot pseries
> images from sdhci/mmc with v4.19.y and older kernels. When tracking this down, I found
> that the devicetree structure passed to the kernel has changed in qemu v5.0. Specifically,
> there is no assigned-addresses property anymore, and the devicetree structure looks
> more like a generic devicetree structure.
> As it turns out, that change has been addressed in the Linux kernel with commit
> dead1c845dbe ("powerpc/pci/of: Parse unassigned resources"). After applying this commit
> to v3.16.y..v4.19.y, the problem is fixed.
> 
> I could work around the problem by using qemu 4.2 for older kernel branches, but
> I would prefer to run a single qemu version for all branches if possible.

Now queued up, thanks.

greg k-h
