Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E664606DC
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 15:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhK1O2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 09:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357993AbhK1O0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 09:26:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79929C061574
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 06:22:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E4B6100F
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:22:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555FCC004E1;
        Sun, 28 Nov 2021 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638109367;
        bh=2nz5125JhTr/v4VRDuOa0GWbyj2dgl4fa5LhH2aKnxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TroOtQm89VuFJF9TNYa92AwPiuEoaDLVWCYo6wCAfBe7s8AhXXD5lIgKXv3XqQyVb
         CCqmVMhqmDdD+Z9IA9PvI8jy1YpZEu5sejNKjJrtje8YBt+YwcjMs+3eO+liv6sOE2
         +dCtz7rXnn05QQJFuDrPwVWkBbB3R3Iz2lOhUdZHlR1oJ8DimvFMXqblU/e7b/HcDU
         iFwZw3iQhAL4du9OAPCS+RxttwdO9Y3OPpSNJI9tVXounO4i67bH8VodD8+rGKorO6
         wD56VcnP8k3Q4jF+F60/oZAy8Tu1eSqEA5hnz9ZrVxWIVQ5cNeHTlVFWtAZA7H9B1T
         ZzguAD0rUsZmA==
Received: by pali.im (Postfix)
        id E88F910CC; Sun, 28 Nov 2021 15:22:43 +0100 (CET)
Date:   Sun, 28 Nov 2021 15:22:43 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/20] Armada 3720 PCIe fixes for 4.19
Message-ID: <20211128142243.n6enuk6jeicyfoyu@pali>
References: <20211124230500.27109-1-kabel@kernel.org>
 <YaOPUSNrPwAxlZyj@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaOPUSNrPwAxlZyj@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 28 November 2021 15:16:49 Greg Kroah-Hartman wrote:
> On Thu, Nov 25, 2021 at 12:04:40AM +0100, Marek Behún wrote:
> > Hello Greg, Sasha,
> > 
> > this series for 4.19-stable backports all the fixes (and their
> > dependencies) for Armada 3720 PCIe driver.
> > These include:
> > - fixes (and their dependencies) for pci-aardvark controller
> > - fixes (and their dependencies) for pinctrl-armada-37xx driver
> > - device-tree fixes
> > 
> > Basically all fixes from upstream are taken, excluding those
> > that need fix the emulated bridge, since that was introduced
> > after 4.19. (Should we backport it? It concerns only mvebu and
> > aardvark controllers...)
> 
> Does anyone care for these old kernels?  I doubt it.

Debian oldstable is using 4.19 kernel.

OpenWRT is using 4.14 kernel and only recently there was a new release
where is 5.4 kernel.

So these old kernels are still widely used.

But I do not think that spending time on backporting whole emulated
bridge to these kernels is something very important...
