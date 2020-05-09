Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5EC1CC153
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgEIMa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgEIMa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 08:30:56 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7CF9218AC;
        Sat,  9 May 2020 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027455;
        bh=4eDX4+vczY4BvjCe0KI5NzaClWwU2LcMQJLE9Xm9qx4=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=wzQXq8qQTsX588B+r245mPfmArgc1UAM7bjthP0bLiHHMMPTGsEYzJ0Xt+JXe/qpV
         MyARsOajVxaEHxPCieJR+l87lQV8Su8wnmwrjqywXdbgbN+YiUw1pXMCWgU/MWd9BN
         kg3rFSp8oaBP5dt9wU8KDzgW0kAtQ/XWCOU25HW4=
Date:   Sat, 09 May 2020 12:30:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Charan Teja Reddy <charante@codeaurora.org>
To:     sumit.semwal@linaro.org, ghackmann@google.com, fengc@google.com
Cc:     linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] dma-buf: fix use-after-free in dmabuffs_dname
In-Reply-To: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
References: <1588920063-17624-1-git-send-email-charante@codeaurora.org>
Message-Id: <20200509123055.B7CF9218AC@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: bb2bb9030425 ("dma-buf: add DMA_BUF_SET_NAME ioctls").

The bot has tested the following trees: v5.6.11, v5.4.39.

v5.6.11: Build OK!
v5.4.39: Failed to apply! Possible dependencies:
    15fd552d186c ("dma-buf: change DMA-buf locking convention v3")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
