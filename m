Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA21B30D0
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 21:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgDUT43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 15:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726337AbgDUT4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 15:56:21 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B432076B;
        Tue, 21 Apr 2020 19:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587498981;
        bh=2mt0X8VBZiX2mA4QQHhFfNXW9PQPT6mIJsAXtaOJlZ8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Ccb0GTBtFXTjO+ltbJAAzxFW0VkL9xgzUuMaAKbhGKYtu0GgJmdrUpYHCHfBvOmSh
         CdNGhiiTw8MBrCNDwREjUN+Zr9bvgjr85qbxtPrpHXzVgf+lMziXZrergbeWkfa7Y2
         KRNWH4Bedo/rZdivam2/R70VyHfl6ZmpqCjENhQE=
Date:   Tue, 21 Apr 2020 19:56:20 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To:     axboe@kernel.dk, josef@toxicpanda.com
Cc:     linux-block@vger.kernel.org, nbd@other.debian.org
Cc:     stable@kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] nbd: Fix memory leak from krealloc() if another allocation fails
In-Reply-To: <20200410122913.14339-1-tuomas.tynkkynen@iki.fi>
References: <20200410122913.14339-1-tuomas.tynkkynen@iki.fi>
Message-Id: <20200421195620.D4B432076B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: .+

The bot has tested the following trees: v5.6.5, v5.5.18, v5.4.33, v4.19.116, v4.14.176, v4.9.219, v4.4.219.

v5.6.5: Build OK!
v5.5.18: Build OK!
v5.4.33: Build OK!
v4.19.116: Build OK!
v4.14.176: Build OK!
v4.9.219: Failed to apply! Possible dependencies:
    20032ec38d16 ("nbd: reset the setup task for NBD_CLEAR_SOCK")
    5ea8d10802ec ("nbd: separate out the config information")
    9442b739207a ("nbd: cleanup ioctl handling")
    9561a7ade0c2 ("nbd: add multi-connection support")
    feffa5cc7b47 ("nbd: fix setting of 'error' in NBD_DO_IT ioctl")

v4.4.219: Failed to apply! Possible dependencies:
    0e4f0f6f63d3 ("nbd: Cleanup reset of nbd and bdev after a disconnect")
    1f7b5cf1be43 ("nbd: Timeouts are not user requested disconnects")
    23272a6754b8 ("nbd: Remove signal usage")
    37091fdd831f ("nbd: Create size change events for userspace")
    5ea8d10802ec ("nbd: separate out the config information")
    9561a7ade0c2 ("nbd: add multi-connection support")
    97240963eb30 ("nbd: fix race in ioctl")
    9b4a6ba9185a ("nbd: use flags instead of bool")
    fd8383fd88a2 ("nbd: convert to blkmq")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
