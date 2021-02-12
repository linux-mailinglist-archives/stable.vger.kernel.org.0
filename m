Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA21F31A314
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 17:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBLQqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 11:46:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhBLQqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Feb 2021 11:46:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1288464E8C;
        Fri, 12 Feb 2021 16:46:00 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Steven Price <steven.price@arm.com>, stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Luis Machado <luis.machado@linaro.org>
Subject: Re: [PATCH] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page
Date:   Fri, 12 Feb 2021 16:45:59 +0000
Message-Id: <161314834566.23182.2604906410285576324.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210180316.23654-1-catalin.marinas@arm.com>
References: <20210210180316.23654-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Feb 2021 18:03:16 +0000, Catalin Marinas wrote:
> The ptrace(PTRACE_PEEKMTETAGS) implementation checks whether the user
> page has valid tags (mapped with PROT_MTE) by testing the PG_mte_tagged
> page flag. If this bit is cleared, ptrace(PTRACE_PEEKMTETAGS) returns
> -EIO.
> 
> A newly created (PROT_MTE) mapping points to the zero page which had its
> tags zeroed during cpu_enable_mte(). If there were no prior writes to
> this mapping, ptrace(PTRACE_PEEKMTETAGS) fails with -EIO since the zero
> page does not have the PG_mte_tagged flag set.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page
      https://git.kernel.org/arm64/c/68d54ceeec0e

-- 
Catalin

