Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D9D46079E
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 17:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358595AbhK1Qiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 11:38:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38486 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243266AbhK1Qgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 11:36:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1974161031
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 16:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54568C53FC1;
        Sun, 28 Nov 2021 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638117218;
        bh=0Pvm61dxmXB1Dz6nEG36I5QJjbB4BzKPYVbYy/Orngk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MRqXW4wSGYdEa0r4P1Xjt27krneEIHVMA50K0vNmVkQpU62avCVFRZd/REOA5QGxo
         QYnnS3zS6rg6l9EEsHUclUz4YUtm8YQPlhtyyptHDEQfai1CXFOXup3mkvDoUbE+6V
         0JmF9EbgTGq/c7PHbae4GuAmkiQZBSul0Gh4splp6beIt1FFnSP/0v91r2cMG6FgY6
         di+6loIiuFSqeZodI5ARnw+c+X0YnkteoqKjP96mxNoxJL3OceNf0BTgiPZkgCD7gc
         trTtfM4F17qULWG7tFhoC2R6hFtQ4+Vf9xfbGiR7iA8gj4SJPZKIAfr2SxrKMe4Sik
         KIwqCapXtz4ew==
Received: by pali.im (Postfix)
        id 73AC010CC; Sun, 28 Nov 2021 17:33:35 +0100 (CET)
Date:   Sun, 28 Nov 2021 17:33:35 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/20] Armada 3720 PCIe fixes for 4.19
Message-ID: <20211128163335.ocj4nrmjxb3qfwma@pali>
References: <20211124230500.27109-1-kabel@kernel.org>
 <YaOPUSNrPwAxlZyj@kroah.com>
 <20211128142243.n6enuk6jeicyfoyu@pali>
 <YaOT2nU+W1pnqtWj@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaOT2nU+W1pnqtWj@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 28 November 2021 15:36:10 Greg Kroah-Hartman wrote:
> On Sun, Nov 28, 2021 at 03:22:43PM +0100, Pali Rohár wrote:
> > On Sunday 28 November 2021 15:16:49 Greg Kroah-Hartman wrote:
> > > On Thu, Nov 25, 2021 at 12:04:40AM +0100, Marek Behún wrote:
> > > > Hello Greg, Sasha,
> > > > 
> > > > this series for 4.19-stable backports all the fixes (and their
> > > > dependencies) for Armada 3720 PCIe driver.
> > > > These include:
> > > > - fixes (and their dependencies) for pci-aardvark controller
> > > > - fixes (and their dependencies) for pinctrl-armada-37xx driver
> > > > - device-tree fixes
> > > > 
> > > > Basically all fixes from upstream are taken, excluding those
> > > > that need fix the emulated bridge, since that was introduced
> > > > after 4.19. (Should we backport it? It concerns only mvebu and
> > > > aardvark controllers...)
> > > 
> > > Does anyone care for these old kernels?  I doubt it.
> > 
> > Debian oldstable is using 4.19 kernel.
> 
> Yes, for older hardware and systems.  If this hardware never worked on
> that kernel, you shouldn't be using old distros on it.

pci-aardvark.c is PCIe controller driver. On this hardware some PCIe
cards with 4.14/4.19 kernels are working fine and some only sometimes.
Most parts of Armada 3720 HW is usable with 4.19 kernel and I was using
Debian kernel on it without issues.

> > OpenWRT is using 4.14 kernel and only recently there was a new release
> > where is 5.4 kernel.
> 
> They are getting closer to a modern kernel release, nice :)

It is not funny, but sad :-( At least these stable backport updates make
PCIe cards more stable for users. And hopefully OpenWRT would not revert
them as it is common with updates from stable trees...
