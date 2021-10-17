Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784164309E9
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 16:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343932AbhJQO7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 10:59:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343940AbhJQO7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 10:59:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD91860C4D;
        Sun, 17 Oct 2021 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634482634;
        bh=GG1wZ5bwzzR2u/Vf+0flW4xsfN2YM/4vqjUZ3AEpPLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qmTNuBWhLpl3VwnGcQRASjzPW2EczHLScChtmlaVOm6YnYwt+RdgJVgWiS1wMyUpl
         vvsFvT9FTHeXDYn5zRBsYEwBgltLOMC/+Xuf8iHwExLIzKV03Nu5rPWTdYKwhwGOre
         L7LVIrBJu1b9+odl+qngL9wUc1fXFlssDEMdVIVs=
Date:   Sun, 17 Oct 2021 16:57:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH 5.4] watchdog: orion: use 0 for unset heartbeat
Message-ID: <YWw5x2xnFSygNsBL@kroah.com>
References: <20211014155819.14680-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211014155819.14680-1-marek.behun@nic.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 14, 2021 at 05:58:19PM +0200, Marek Behún wrote:
> From: Chris Packham <chris.packham@alliedtelesis.co.nz>
> 
> commit bb914088bd8a91c382f54d469367b2e5508b5493 upstream.
> 
> If the heartbeat module param is not specified we would get an error
> message
> 
>   watchdog: f1020300.watchdog: driver supplied timeout (4294967295) out of range
>   watchdog: f1020300.watchdog: falling back to default timeout (171)
> 
> This is because we were initialising heartbeat to -1. By removing the
> initialisation (thus letting the C run time initialise it to 0) we
> silence the warning message and the default timeout is still used.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/r/20200313031312.1485-1-chris.packham@alliedtelesis.co.nz
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
> The error message appears also in 5.4, but not 4.19. So apply also for 5.4.

Now queued up, thanks.


greg k-h
