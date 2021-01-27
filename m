Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BB6305CA3
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343782AbhA0NMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 08:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238049AbhA0NKi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Jan 2021 08:10:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA235207A3;
        Wed, 27 Jan 2021 13:09:56 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     linux-kernel@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com
Cc:     Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] arm64: Fix kernel address detection of __is_lm_address()
Date:   Wed, 27 Jan 2021 13:09:54 +0000
Message-Id: <161175296410.16506.3810718723675940477.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210126134056.45747-1-vincenzo.frascino@arm.com>
References: <20210126134056.45747-1-vincenzo.frascino@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 26 Jan 2021 13:40:56 +0000, Vincenzo Frascino wrote:
> Currently, the __is_lm_address() check just masks out the top 12 bits
> of the address, but if they are 0, it still yields a true result.
> This has as a side effect that virt_addr_valid() returns true even for
> invalid virtual addresses (e.g. 0x0).
> 
> Fix the detection checking that it's actually a kernel address starting
> at PAGE_OFFSET.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: Fix kernel address detection of __is_lm_address()
      https://git.kernel.org/arm64/c/519ea6f1c82f

-- 
Catalin

