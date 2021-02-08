Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC43135D4
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 15:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhBHO5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 09:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233067AbhBHO4h (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 09:56:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66FE864E0B;
        Mon,  8 Feb 2021 14:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612796157;
        bh=tDEF+JqYmN4RM2/9OGjxnkfOMnrqA6425j36h4NIBgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CetLeBy2tyel3xmr2zA0pJUseyHWllAx4pbLZiAKtMhZz0LPhHQmVQRdtnzIpkz0z
         bzYx/AmyoIOOAa1hHSDOrfAHkegt2UVXVy+Zkm8CJHYnHdZ17yqQWNqSXsv81orPvJ
         mx3PJJj0YNewCQ5DyAsUTVS7jVY0Hhe78k5XlV8tCaav5jjHt7g/AUqkVOPW/TH9o7
         POTOxSBn0Ba3SGvByNA7LVI6FC8zji4eTbSWl8AELQFeQT4dQoiQmzkFP66/p9rrGO
         EwTG+MRntXVpU6gTmlTOQlO2iwiyhzYY71q5PIMqCjwrME656OrVHKb0mFOrBUZr7x
         n8mRWfgpR2BWQ==
From:   Will Deacon <will@kernel.org>
To:     linux-arm-kernel@lists.infradead.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        James Morse <james.morse@arm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
Date:   Mon,  8 Feb 2021 14:55:51 +0000
Message-Id: <161278735697.2383360.10059960897244362605.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210203230057.3961239-1-suzuki.poulose@arm.com>
References: <20210203230057.3961239-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Feb 2021 23:00:57 +0000, Suzuki K Poulose wrote:
> The erratum 1024718 affects Cortex-A55 r0p0 to r2p0. However
> we apply the work around for r0p0 - r1p0. Unfortunately this
> won't be fixed for the future revisions for the CPU. Thus
> extend the work around for all versions of A55, to cover
> for r2p0 and any future revisions.

Applied to arm64 (for-next/errata), thanks!

[1/1] arm64: Extend workaround for erratum 1024718 to all versions of Cortex-A55
      https://git.kernel.org/arm64/c/c0b15c25d251

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
