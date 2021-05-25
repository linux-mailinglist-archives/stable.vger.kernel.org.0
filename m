Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63745390343
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 16:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233438AbhEYODh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 10:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233273AbhEYODh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 10:03:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DCB26141B;
        Tue, 25 May 2021 14:02:06 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marco Elver <elver@google.com>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH v2] arm64: mm: don't use CON and BLK mapping if KFENCE is enabled
Date:   Tue, 25 May 2021 15:02:04 +0100
Message-Id: <162195131724.26304.9816849348015861632.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210525104551.2ec37f77@xhacker.debian>
References: <20210525104551.2ec37f77@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 May 2021 10:45:51 +0800, Jisheng Zhang wrote:
> When we added KFENCE support for arm64, we intended that it would
> force the entire linear map to be mapped at page granularity, but we
> only enforced this in arch_add_memory() and not in map_mem(), so
> memory mapped at boot time can be mapped at a larger granularity.
> 
> When booting a kernel with KFENCE=y and RODATA_FULL=n, this results in
> the following WARNING at boot:
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: mm: don't use CON and BLK mapping if KFENCE is enabled
      https://git.kernel.org/arm64/c/e69012400b0c

-- 
Catalin

