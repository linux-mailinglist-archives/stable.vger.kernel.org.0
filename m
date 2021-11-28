Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DCA4606C5
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 15:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346584AbhK1OWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 09:22:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40926 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352578AbhK1OUI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 09:20:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0F6560FF0
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 14:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD075C004E1;
        Sun, 28 Nov 2021 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638109012;
        bh=fe0mX9cORE8B62ZrNKbYD7fRYYHfGVT+2hTdnTG3YWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mPOJJ9cBCaMCyrgMiyxnfnLokSd/Ej7dlWnrYDNarI7SVjuunTUP8DaUhaDMeowkQ
         B8g+kFmSOwOXx91lq2K03HFQYgAWEx0LknIXi/gJFTC3pA2lffxHBxfRaPVaHDYThL
         R8tEW1egTR+/nENF6KmWwE4i3qMeFXc3hkrmCyTg=
Date:   Sun, 28 Nov 2021 15:16:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/20] Armada 3720 PCIe fixes for 4.19
Message-ID: <YaOPUSNrPwAxlZyj@kroah.com>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 12:04:40AM +0100, Marek Behún wrote:
> Hello Greg, Sasha,
> 
> this series for 4.19-stable backports all the fixes (and their
> dependencies) for Armada 3720 PCIe driver.
> These include:
> - fixes (and their dependencies) for pci-aardvark controller
> - fixes (and their dependencies) for pinctrl-armada-37xx driver
> - device-tree fixes
> 
> Basically all fixes from upstream are taken, excluding those
> that need fix the emulated bridge, since that was introduced
> after 4.19. (Should we backport it? It concerns only mvebu and
> aardvark controllers...)

Does anyone care for these old kernels?  I doubt it.
