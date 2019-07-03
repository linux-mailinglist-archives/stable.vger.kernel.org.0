Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC525EF31
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 00:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfGCWgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 18:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfGCWgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 18:36:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E8B21871;
        Wed,  3 Jul 2019 22:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562193409;
        bh=BGg0WqAaB7ArGQN6xoXq7msmqbAoL7In/lfHnOsKO5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d59Ru3R8b8CNpkRzxD2gO63UUpAmVQG4E2MYv5/XXFjatbG+GPd4tKoOlPh5CeWHM
         7yJbACR9p5OdoqYzTsJMLO5XflolzhWt11ISbXRH60GA8oOlhDEXQOUPxGMDM204wf
         cEA3nGBdZqy8zhXCQz5rJCiaEqzswNPEIEcFSmjU=
Date:   Wed, 3 Jul 2019 18:36:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "4.4.y backports" <stable@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [STABLE-4.4] proposed backports
Message-ID: <20190703223647.GA10104@sasha-vm>
References: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 03, 2019 at 10:17:09PM +0200, Arnd Bergmann wrote:
>I looked at the kernelci.org output for 4.4.y and found a couple of
>patches that need to be applied here:
>
>0eca6fdb3193 ("ARC: Assume multiplier is always present")
>1dec78585328 ("ARC: fix build warning in elf.h")
>173a3efd3edb ("bug.h: work around GCC PR82365 in BUG()")
>8535f2ba0a9b ("MIPS: math-emu: do not use bools for arithmetic")
>67fc5dc8a541 ("MIPS: VDSO: Include $(ccflags-vdso) in o32,n32 .lds builds")
>993dc737c099 ("mfd: omap-usb-tll: Fix register offsets")
>386744425e35 ("swiotlb: Make linux/swiotlb.h standalone includible")

I took all of these except 67fc5dc8a541.

>Further, the backport of commit 867bfa4a5fce ("fs/binfmt_flat.c: make
>load_flat_shared_library() work") relies on commit bdd1d2d3d251 ("fs:
>fix kernel_read prototype"). Either that gets backported as well, or
>the new patch dropped or modified:
>
>fs/binfmt_flat.c:832:35: warning: passing argument 2 of 'kernel_read'
>makes integer from pointer without a cast [-Wint-conversion]
>include/uapi/linux/binfmts.h:18:25: warning: passing argument 3 of
>'kernel_read' makes pointer from integer without a cast
>[-Wint-conversion]
>fs/binfmt_flat.c:832:58: warning: passing argument 4 of 'kernel_read'
>makes integer from pointer without a cast [-Wint-conversion]

I've fixed it up.

Thank you!

--
Thanks,
Sasha
