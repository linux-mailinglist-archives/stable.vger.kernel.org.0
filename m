Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E978460652
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 14:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbhK1NGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 08:06:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbhK1NER (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 08:04:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49F6C061758
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 05:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813AF60FDF
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 13:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4885EC004E1;
        Sun, 28 Nov 2021 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638104460;
        bh=BznoFKZqVCjoyyv94eKFg9DB8E3EgFFeWX41446ebZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWOCAtfLDG11GECEa2BdClVfZEYHIHyqfyyZtuvEiBXGxLV9Z3MQ22MPEawv11ZTK
         a1MLQzUPw2bFf463pc63E1pM+OYZNiO/fFHMwZlxOjCdxMMajlsgSn2gWzrzmFXZhS
         HiCKZjoZSN+XovnWGNO0DEkUOvMKFNkc5pRJaT+o=
Date:   Sun, 28 Nov 2021 14:00:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, pali@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/22] Armada 3720 PCIe fixes for 5.4
Message-ID: <YaN9iT/8Jw3brGPD@kroah.com>
References: <20211125002616.31363-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211125002616.31363-1-kabel@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 01:25:54AM +0100, Marek Behún wrote:
> Hello Greg, Sasha,
> 
> this series for 5.4-stable backports all the fixes (and their
> dependencies) for Armada 3720 PCIe driver.
> These include:
> - fixes (and their dependencies) for pci-aardvark controller
> - fixes for pci-bridge-emul
> - fixes (and their dependencies) for pinctrl-armada-37xx driver
> - device-tree fixes

Now queued up, thanks.

greg k-h
